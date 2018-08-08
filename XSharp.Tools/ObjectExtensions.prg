// Application : XSharp.Tools.Core
// ObjectExtensions.prg , Created : 30.07.2018   06:27
// User : Wolfgang

using System                        
using System.Text
using System.Runtime.InteropServices
using System.Reflection 
using System.Diagnostics
using System.Collections.Generic

begin namespace XSharp.Tools

class ObjectExtensions
/// <summary> 
/// static class to extend objects by some extension methods
/// </summary>

#region constructors
static constructor()  
/// <summary> 
/// constructor
/// </summary>
/// <param name="oAssembly">Assembly from which read the classes</param>
/// <returns>aClassNames</returns>
	super()

	return
#endregion
#region public properties
#endregion
#region public methods

static method IsMethod( self oObject as object, cMethod as string ) as logic
/// <summary> 
/// checks if the given object has a method with the given name
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <param name="cMethod">method name</param>
/// <returns>logic value</returns>
	local oType as System.Type
	local lReturn as logic
	
	if oObject == null_object
		lReturn		:= false
	else
		oType 		:= oObject:GetType()
		if oType:GetMethod( cMethod ) == null_object
			lReturn		:= false
		else
			lReturn		:= true
		endif
	endif
	
	return lReturn

static method Send( self oObject as object, cMethod as string, aParameters as object[] ) as object 
/// <summary> 
/// send a method to an object and pass parameters
/// </summary>
/// <param name="oObject">object to which send the method</param>
/// <param name="cMethod">method name</param>
/// <param name="aParameters">object array of the parameters to pass</param>
/// <returns>object, return value of the method</returns>
	local oType as System.Type
	local oReturn as object
	local oInfo as MethodInfo
	
	oType 				:= oObject:GetType()
	oReturn				:= null_object
	// try
	oInfo				:= oType:GetMethod( cMethod )
	if oInfo != null_object
		oReturn				:= oInfo:Invoke( oObject, aParameters )
	endif
	
	// end try         
	oType				:= null_object
	oInfo				:= null_object
	
	return oReturn              
	
static method ClassName( self oObject as object ) as string 
/// <summary> 
/// returns the class name of the passed object
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <returns>name of the class, string value</returns>
	local cReturn		as string   
	
	if oObject == null
		cReturn				:= "Null"
	else
		cReturn				:= oObject:GetType():Name
	endif
	
	return cReturn	    
	
static method PropertyNames( self oObject as object ) as string[]
/// <summary> 
/// returns an array of all existent property names of the passed object
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <returns>existing properties, array of string</returns>
	local aReturn		as string[]
	local nLen			as int
	local nI			as int       
	local oProperties	as System.Reflection.PropertyInfo[]
                          
	oProperties		:= oObject:GetType():GetProperties()	
	nLen			:= oProperties:Length
	aReturn			:= string[]{nLen}
	for nI := 1 upto nLen
		aReturn[nI]		:= oProperties[nI]:Name
	next
	oProperties		:= null_object
		
	return aReturn	
	
static method IsProperty( self oObject as object, cPropertyName as string ) as logic pascal
/// <summary> 
/// checks if the passed object has a property with the passed name, case insensitive
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <param name="cPropertyName">property to check</param>
/// <returns>logic value</returns>
	local aProperties	as string[]
	local lReturn		as logic
	local nLen			as int
	local nI			as int       
	
	aProperties		:= PropertyNames( oObject )
	cPropertyName	:= cPropertyName:ToLower()
	nLen			:= aProperties:Length
	lReturn			:= false
	for nI := 1 upto nLen
		if aProperties[nI]:ToLower() == cPropertyName
			lReturn			:= true
			exit
		endif
	next
	
	return lReturn
	
static method FixPropertyName( self oObject as object, cPropertyName as string ) as string pascal
	local aProperties	as string[]
	local cReturn		as string
	local nLen			as int
	local nI			as int       
	
	aProperties		:= PropertyNames( oObject )
	cPropertyName	:= cPropertyName:ToLower()
	nLen			:= aProperties:Length
	cReturn			:= cPropertyName
	for nI := 1 upto nLen
		if aProperties[nI]:ToLower() == cPropertyName
			cReturn			:= aProperties[nI]
			exit
		endif
	next
	
	return cReturn

static method GetPropertyValue( self oObject as object, cPropertyName as string ) as object pascal
//private object getProperty(object containingObject, string propertyName)
//{
//    return containingObject.GetType().InvokeMember(propertyName, BindingFlags.GetProperty, null, containingObject, null);
//}        
// Achtung: PropertyName muß korrekt geschrieben sein!!!!
	local oReturn		as object	
	local oInfo			as System.Reflection.PropertyInfo
	
	oInfo			:= oObject:GetType():GetProperty( cPropertyName ) //, System.Reflection.BindingFlags.GetProperty )
	if oInfo != null_object                                  
		oReturn			:= oInfo:GetValue( oObject, null_object ) 
	else
		oReturn			:= null_object
	endif

//	oReturn			:= oObject:GetType():InvokeMember( cPropertyName, System.Reflection.BindingFlags.GetProperty, null, oObject, null )
	
	return oReturn

static method SetPropertyValue( self oObject as object, cPropertyName as string, oValue as object ) as void pascal 
//private void setProperty(object containingObject, string propertyName, object newValue)
//{
//    containingObject.GetType().InvokeMember(propertyName, BindingFlags.SetProperty, null, containingObject, new object[] { newValue });
//}
// Achtung: PropertyName muß korrekt geschrieben sein!!!!   
	local oInfo			as System.Reflection.PropertyInfo
	
	oInfo			:= oObject:GetType():GetProperty( cPropertyName ) //, System.Reflection.BindingFlags.SetProperty )
	if oInfo != null_object
		// debOut( "set property " + cPropertyName + " to " + oValue:ToString() )
		oInfo:SetValue( oObject, oValue, null_object )                        
	//else
		// debOut( "set property " + cPropertyName + " not ok, Property not found" )
	endif
//	oObject:GetType():InvokeMember( cPropertyName, System.Reflection.BindingFlags.SetProperty, null, oObject, ( Object[] ) oValue )
	
	return

	

#endregion
#region internal methods
#endregion
end class

end namespace
