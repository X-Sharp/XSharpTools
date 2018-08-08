
using System.Collections.Generic
using System.Reflection
using System.IO
using System.Security.Principal
using System.Diagnostics

begin namespace XSharp.Tools

static class Functions
/// <summary> 
/// container class for static methods i.e. functions
/// </summary>

static constructor()

	return

static method AssemblyClasses( oAssembly as Assembly ) as string[]
/// <summary> 
/// returns an array of all classes in the given assembly
/// </summary>
/// <param name="oAssembly">Assembly from which read the classes</param>
/// <returns>aClassNames</returns>
	local oClassNames		as List<string>
	local aTypes			as Type[]
	local aReturn			as string[]
	
	oClassNames			:= List<string>{}
	aTypes				:= oAssembly:GetTypes()
	foreach oType as Type in aTypes
		oClassNames:Add( oType:FullName )
	next
	aTypes				:= null
	aReturn				:= oClassNames:ToArray()
	oClassNames			:= null
	
	return aReturn
	
	
static method AssemblyClasses( oAssembly as Assembly, cInterfaceName as string ) as string[]
/// <summary> 
/// returns an array of all classes in the given assembly that implement the given interface
/// </summary>
/// <param name="oAssembly">Assembly from with read the classes</param>
/// <param name="cInterfaceName">Interface to implement</param>
/// <returns>aClassNames</returns>
	local oClassNames		as List<string>
	local aTypes			as Type[]
	local aInterfaces		as Type[]          
	local aReturn			as string[]
	
	oClassNames			:= List<string>{}
	aTypes				:= oAssembly:GetTypes()
	foreach oType as Type in aTypes
		aInterfaces			:= oType:GetInterfaces()
		foreach oInterface as Type in aInterfaces
			if oInterface:FullName == cInterfaceName
				oClassNames:Add( oType:FullName )
			endif
		next
		aInterfaces			:= null
	next
	aTypes				:= null
	aReturn				:= oClassNames:ToArray()
	oClassNames			:= null
	
	return aReturn
	
static method CombinePath( cPath1 as string, cPath2 as string ) as string
/// <summary> 
/// combines two parts of a path, better behavior than Path.Combine
/// </summary>
/// <param name="cPath1">first part of path</param>
/// <param name="cPath2">second part of path</param>
/// <returns>combined path</returns>
	local cReturn			as string
	
	if cPath2:Length > 1 .and. ( cPath2[0] == Path.DirectorySeparatorChar .or. cPath2[0] == Path.AltDirectorySeparatorChar )
		cPath2				:= cPath2:Substring( 1 )
	endif
	cReturn				:= Path.Combine( cPath1, cPath2 )
	
	return cReturn
	
static method CurrentUser() as string pascal
/// <summary> 
/// returns the name of the currently logged in user
/// </summary>
/// <returns>currently logged in user</returns>
	local cUserName			as string
	
	cUserName			:= Environment.UserName
	
	return cUserName  

static method DocumentDirectory() as string 
/// <summary> 
/// returns the MyDocuments path of the currently logged in user
/// </summary>
/// <returns>MyDocuments path</returns>
	local cDocumentPath		as string
	
	cDocumentPath		:= System.Environment.GetFolderPath( System.Environment.SpecialFolder.MyDocuments )
	
	return cDocumentPath   
	
static method GetExeFileName() as string
/// <summary> 
/// returns the name of the executing exe file
/// </summary>
/// <returns>name of the current exe file</returns>
	local cExeFileName		as string
	
	cExeFileName		:= Assembly.GetEntryAssembly():Location
	
	return cExeFileName      
	
static method GetFilenameFromPath( cFullPath as string ) as string
/// <summary> 
/// get the Filename part from the given full path
/// </summary>
/// <param name="cFullPath">full path name</param>
/// <returns>filename part</returns>
	local nPos				as int
	local cReturn			as string
	
	if ( nPos := cFullPath:LastIndexOf( Path.DirectorySeparatorChar ) ) <= 0
		cReturn				:= cFullPath
	else  
		if cFullPath:Length > ( nPos + 1 )
			cReturn				:= cFullPath:Substring( nPos + 1 )
		else
			cReturn				:= ""
		endif
	endif
	
	return cReturn           
	
static method GetPathFromFileName( cFullPath as string ) as string
/// <summary> 
/// get the path part from the given full path
/// </summary>
/// <param name="cFullPath">full path name</param>
/// <returns>path part</returns>
	local nPos			as int   
	local cReturn		as string
	
	if ( nPos := cFullPath:LastIndexOf( System.IO.Path.DirectorySeparatorChar ) ) < 0
		cReturn				:= ""
	else
		cReturn				:= cFullPath:Substring( 0, nPos )
	endif
	
	return cReturn    
	
static method GetSystemLanguage() as string
/// <summary> 
/// returns the language of the system in the form "de-DE"
/// </summary>
/// <returns>current system language</returns>
	local oCultureInfo		as System.Globalization.CultureInfo
	local cReturn			as string
	
	oCultureInfo		:= System.Globalization.CultureInfo.CurrentUICulture
	cReturn				:= oCultureInfo:Name
	
	return cReturn

static method IsRunningElevated() as logic
/// <summary> 
/// Is the current process running with elevated rights?
/// </summary>
	local lReturn			as logic
	
	if WindowsPrincipal{ WindowsIdentity.GetCurrent() }:IsInRole( WindowsBuiltInRole.Administrator )
		lReturn			:= true
	else
		lReturn			:= false
	endif
	
	return lReturn	   
	
static method ListStaticRessources( oAssembly as System.Reflection.Assembly ) as string[]
/// <summary> 
/// returns an array of the static ressources in an assembly
/// </summary>
/// <returns>string array of static ressources</returns>
	// z.B. Utility.ListStaticRessources( System.Reflection.Assembly.GetExecutingAssembly() )
	local aRessources	as string[]
	
	aRessources		:= oAssembly:GetManifestResourceNames()
	
	return aRessources

static method LocalSettingsPath() as string pascal
/// <summary> 
/// returns the local settings path in the AppData structure
/// </summary>
/// <returns>local settings path</returns>
	local cSettingsPath		as string
	
	cSettingsPath	:= System.Environment.GetFolderPath( System.Environment.SpecialFolder.ApplicationData )
	if ! cSettingsPath:Substring( cSettingsPath:Length ) == "\" // Right( cSettingsPath, 1 ) != "\"
		cSettingsPath		:= cSettingsPath + "\"
	endif
	
	return cSettingsPath

static method ProgramPath() as string
/// <summary> 
/// returns the path from where the exe is executed
/// </summary>
/// <returns>execution path</returns>
	local cPrgPath			as string
	
	cPrgPath			:= AppDomain.CurrentDomain:BaseDirectory
	
	return cPrgPath      
	
static method StartedFromNetwork() as logic
/// <summary> 
/// was the current process started from a network drive
/// </summary>
/// <returns>lStartedFromNetwork</returns>
	local oDriveInfo		as System.IO.DriveInfo
	local lReturn			as logic

	oDriveInfo			:= System.IO.DriveInfo{ ProgramPath() }
	if oDriveInfo:DriveType == System.IO.DriveType.Network
		lReturn				:= true
	else
		lReturn				:= false
	endif
	
	return lReturn
	
static method StartedFromRemovableMedia() as logic
/// <summary> 
/// was the current process started from a removable media
/// </summary>
/// <returns>lStartedFromRemovableMedia</returns>
	local oDriveInfo		as System.IO.DriveInfo
	local lReturn			as logic

	oDriveInfo			:= System.IO.DriveInfo{ ProgramPath() }
	if oDriveInfo:DriveType == System.IO.DriveType.Removable
		lReturn				:= true
	else
		lReturn				:= false
	endif
	
	return lReturn 
	
static method Sleep( nMilliSeconds as int ) as void 
/// <summary> 
/// sleep for milliseconds
/// </summary>
/// <param name="nMilliseconds">milliseconds to sleep</param>
/// <returns></returns>
	
	System.Threading.Thread.Sleep( nMilliSeconds )
	
	return     
	


end class

end namespace
