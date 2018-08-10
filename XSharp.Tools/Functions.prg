
USING System.Collections.Generic
USING System.Reflection
USING System.IO
USING System.Security.Principal
USING System.Diagnostics

BEGIN NAMESPACE XSharp.Tools

/// <summary> 
/// container class for static methods i.e. functions
/// </summary>
STATIC CLASS Functions

STATIC CONSTRUCTOR()

	RETURN

/// <summary> 
/// returns an array of all classes in the given assembly
/// </summary>
/// <param name="oAssembly">Assembly from which read the classes</param>
/// <returns>aClassNames</returns>
STATIC METHOD AssemblyClasses( oAssembly AS Assembly ) AS STRING[]
	LOCAL oClassNames		AS List<STRING>
	LOCAL aTypes			AS Type[]
	LOCAL aReturn			AS STRING[]
	
	oClassNames			:= List<STRING>{}
	aTypes				:= oAssembly:GetTypes()
	FOREACH oType AS Type IN aTypes
		oClassNames:Add( oType:FullName )
	NEXT
	aTypes				:= null
	aReturn				:= oClassNames:ToArray()
	oClassNames			:= null
	
	RETURN aReturn
	
/// <summary> 
/// returns an array of all classes in the given assembly that implement the given interface
/// </summary>
/// <param name="oAssembly">Assembly from with read the classes</param>
/// <param name="cInterfaceName">Interface to implement</param>
/// <returns>aClassNames</returns>
STATIC METHOD AssemblyClasses( oAssembly AS Assembly, cInterfaceName AS STRING ) AS STRING[]
	LOCAL oClassNames		AS List<STRING>
	LOCAL aTypes			AS Type[]
	LOCAL aInterfaces		AS Type[]          
	LOCAL aReturn			AS STRING[]
	
	oClassNames			:= List<STRING>{}
	aTypes				:= oAssembly:GetTypes()
	FOREACH oType AS Type IN aTypes
		aInterfaces			:= oType:GetInterfaces()
		FOREACH oInterface AS Type IN aInterfaces
			IF oInterface:FullName == cInterfaceName
				oClassNames:Add( oType:FullName )
			ENDIF
		NEXT
		aInterfaces			:= null
	NEXT
	aTypes				:= null
	aReturn				:= oClassNames:ToArray()
	oClassNames			:= null
	
	RETURN aReturn
	
/// <summary> 
/// combines two parts of a path, better behavior than Path.Combine
/// </summary>
/// <param name="cPath1">first part of path</param>
/// <param name="cPath2">second part of path</param>
/// <returns>combined path</returns>
STATIC METHOD CombinePath( cPath1 AS STRING, cPath2 AS STRING ) AS STRING
	LOCAL cReturn			AS STRING
	
	IF cPath2:Length > 1 .and. ( cPath2[0] == Path.DirectorySeparatorChar .or. cPath2[0] == Path.AltDirectorySeparatorChar )
		cPath2				:= cPath2:Substring( 1 )
	ENDIF
	cReturn				:= Path.Combine( cPath1, cPath2 )
	
	RETURN cReturn
	
/// <summary> 
/// returns the name of the currently logged in user
/// </summary>
/// <returns>currently logged in user</returns>
STATIC METHOD CurrentUser() AS STRING PASCAL
	LOCAL cUserName			AS STRING
	
	cUserName			:= Environment.UserName
	
	RETURN cUserName  

/// <summary> 
/// returns the MyDocuments path of the currently logged in user
/// </summary>
/// <returns>MyDocuments path</returns>
STATIC METHOD DocumentDirectory() AS STRING 
	LOCAL cDocumentPath		AS STRING
	
	cDocumentPath		:= System.Environment.GetFolderPath( System.Environment.SpecialFolder.MyDocuments )
	
	RETURN cDocumentPath   
	
/// <summary> 
/// returns the name of the executing exe file
/// </summary>
/// <returns>name of the current exe file</returns>
STATIC METHOD GetExeFileName() AS STRING
	LOCAL cExeFileName		AS STRING
	
	cExeFileName		:= Assembly.GetEntryAssembly():Location
	
	RETURN cExeFileName      
	
/// <summary> 
/// get the Filename part from the given full path
/// </summary>
/// <param name="cFullPath">full path name</param>
/// <returns>filename part</returns>
STATIC METHOD GetFilenameFromPath( cFullPath AS STRING ) AS STRING
	LOCAL nPos				AS INT
	LOCAL cReturn			AS STRING
	
	IF ( nPos := cFullPath:LastIndexOf( Path.DirectorySeparatorChar ) ) <= 0
		cReturn				:= cFullPath
	ELSE  
		IF cFullPath:Length > ( nPos + 1 )
			cReturn				:= cFullPath:Substring( nPos + 1 )
		ELSE
			cReturn				:= ""
		ENDIF
	ENDIF
	
	RETURN cReturn           
	
/// <summary> 
/// get the path part from the given full path
/// </summary>
/// <param name="cFullPath">full path name</param>
/// <returns>path part</returns>
STATIC METHOD GetPathFromFileName( cFullPath AS STRING ) AS STRING
	LOCAL nPos			AS INT   
	LOCAL cReturn		AS STRING
	
	IF ( nPos := cFullPath:LastIndexOf( System.IO.Path.DirectorySeparatorChar ) ) < 0
		cReturn				:= ""
	ELSE
		cReturn				:= cFullPath:Substring( 0, nPos )
	ENDIF
	
	RETURN cReturn    
	
/// <summary> 
/// returns the language of the system in the form "de-DE"
/// </summary>
/// <returns>current system language</returns>
STATIC METHOD GetSystemLanguage() AS STRING
	LOCAL oCultureInfo		AS System.Globalization.CultureInfo
	LOCAL cReturn			AS STRING
	
	oCultureInfo		:= System.Globalization.CultureInfo.CurrentUICulture
	cReturn				:= oCultureInfo:Name
	
	RETURN cReturn

/// <summary> 
/// Is the current process running with elevated rights?
/// </summary>
STATIC METHOD IsRunningElevated() AS LOGIC
	LOCAL lReturn			AS LOGIC
	
	IF WindowsPrincipal{ WindowsIdentity.GetCurrent() }:IsInRole( WindowsBuiltInRole.Administrator )
		lReturn			:= true
	ELSE
		lReturn			:= false
	ENDIF
	
	RETURN lReturn	   
	
/// <summary> 
/// returns an array of the static ressources in an assembly
/// </summary>
/// <returns>string array of static ressources</returns>
STATIC METHOD ListStaticRessources( oAssembly AS System.Reflection.Assembly ) AS STRING[]
	// z.B. Utility.ListStaticRessources( System.Reflection.Assembly.GetExecutingAssembly() )
	LOCAL aRessources	AS STRING[]
	
	aRessources		:= oAssembly:GetManifestResourceNames()
	
	RETURN aRessources

/// <summary> 
/// returns the local settings path in the AppData structure
/// </summary>
/// <returns>local settings path</returns>
STATIC METHOD LocalSettingsPath() AS STRING PASCAL
	LOCAL cSettingsPath		AS STRING
	
	cSettingsPath	:= System.Environment.GetFolderPath( System.Environment.SpecialFolder.ApplicationData )
	IF ! cSettingsPath:Substring( cSettingsPath:Length ) == "\" // Right( cSettingsPath, 1 ) != "\"
		cSettingsPath		:= cSettingsPath + "\"
	ENDIF
	
	RETURN cSettingsPath

/// <summary> 
/// returns the path from where the exe is executed
/// </summary>
/// <returns>execution path</returns>
STATIC METHOD ProgramPath() AS STRING
	LOCAL cPrgPath			AS STRING
	
	cPrgPath			:= AppDomain.CurrentDomain:BaseDirectory
	
	RETURN cPrgPath      
	
/// <summary> 
/// was the current process started from a network drive
/// </summary>
/// <returns>lStartedFromNetwork</returns>
STATIC METHOD StartedFromNetwork() AS LOGIC
	LOCAL oDriveInfo		AS System.IO.DriveInfo
	LOCAL lReturn			AS LOGIC

	oDriveInfo			:= System.IO.DriveInfo{ ProgramPath() }
	IF oDriveInfo:DriveType == System.IO.DriveType.Network
		lReturn				:= true
	ELSE
		lReturn				:= false
	ENDIF
	
	RETURN lReturn
	
/// <summary> 
/// was the current process started from a removable media
/// </summary>
/// <returns>lStartedFromRemovableMedia</returns>
STATIC METHOD StartedFromRemovableMedia() AS LOGIC
	LOCAL oDriveInfo		AS System.IO.DriveInfo
	LOCAL lReturn			AS LOGIC

	oDriveInfo			:= System.IO.DriveInfo{ ProgramPath() }
	IF oDriveInfo:DriveType == System.IO.DriveType.Removable
		lReturn				:= true
	ELSE
		lReturn				:= false
	ENDIF
	
	RETURN lReturn 
	
/// <summary> 
/// sleep for milliseconds
/// </summary>
/// <param name="nMilliseconds">milliseconds to sleep</param>
/// <returns></returns>
STATIC METHOD Sleep( nMilliSeconds AS INT ) AS VOID 
	
	System.Threading.Thread.Sleep( nMilliSeconds )
	
	RETURN     

END CLASS

END NAMESPACE
