// Application : XSharp.Tools.Core
// ObjectExtensions.prg , Created : 30.07.2018   06:27
// User : Wolfgang

USING System                        
USING System.Text
USING System.Runtime.InteropServices
USING System.Reflection 
USING System.Diagnostics
USING System.Collections.Generic

BEGIN NAMESPACE XSharp.Tools

/// <summary> 
/// static class to extend objects by some extension methods
/// </summary>
CLASS ObjectExtensions

#region constructors
/// <summary> 
/// constructor
/// </summary>
STATIC CONSTRUCTOR()  
	SUPER()

	RETURN
#endregion
#region PUBLIC properties
#endregion
#region PUBLIC methods

/// <summary> 
/// checks if the given object has a method with the given name
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <param name="cMethod">method name</param>
/// <returns>logic value</returns>
STATIC METHOD IsMethod( SELF oObject AS OBJECT, cMethod AS STRING ) AS LOGIC
	LOCAL oType AS System.Type
	LOCAL lReturn AS LOGIC
	
	IF oObject == null_object
		lReturn		:= false
	ELSE
		oType 		:= oObject:GetType()
		IF oType:GetMethod( cMethod ) == null_object
			lReturn		:= false
		ELSE
			lReturn		:= true
		ENDIF
	ENDIF
	
	RETURN lReturn

/// <summary> 
/// send a method to an object and pass parameters
/// </summary>
/// <param name="oObject">object to which send the method</param>
/// <param name="cMethod">method name</param>
/// <param name="aParameters">object array of the parameters to pass</param>
/// <returns>object, return value of the method</returns>
STATIC METHOD Send( SELF oObject AS OBJECT, cMethod AS STRING, aParameters AS OBJECT[] ) AS OBJECT 
	LOCAL oType AS System.Type
	LOCAL oReturn AS OBJECT
	LOCAL oInfo AS MethodInfo
	
	oType 				:= oObject:GetType()
	oReturn				:= null_object
	// try
	oInfo				:= oType:GetMethod( cMethod )
	IF oInfo != null_object
		oReturn				:= oInfo:Invoke( oObject, aParameters )
	ENDIF
	
	// end try         
	oType				:= null_object
	oInfo				:= null_object
	
	RETURN oReturn              
	
/// <summary> 
/// returns the class name of the passed object
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <returns>name of the class, string value</returns>
STATIC METHOD ClassName( SELF oObject AS OBJECT ) AS STRING 
	LOCAL cReturn		AS STRING   
	
	IF oObject == null
		cReturn				:= "Null"
	ELSE
		cReturn				:= oObject:GetType():Name
	ENDIF
	
	RETURN cReturn	    
	
/// <summary> 
/// returns an array of all existent property names of the passed object
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <returns>existing properties, array of string</returns>
STATIC METHOD PropertyNames( SELF oObject AS OBJECT ) AS STRING[]
	LOCAL aReturn		AS STRING[]
	LOCAL nLen			AS INT
	LOCAL nI			AS INT       
	LOCAL oProperties	AS System.Reflection.PropertyInfo[]
                          
	oProperties		:= oObject:GetType():GetProperties()	
	nLen			:= oProperties:Length
	aReturn			:= STRING[]{nLen}
	FOR nI := 1 UPTO nLen
		aReturn[nI]		:= oProperties[nI]:Name
	NEXT
	oProperties		:= null_object
		
	RETURN aReturn	
	
/// <summary> 
/// checks if the passed object has a property with the passed name, case insensitive
/// </summary>
/// <param name="oObject">object which is checked</param>
/// <param name="cPropertyName">property to check</param>
/// <returns>logic value</returns>
STATIC METHOD IsProperty( SELF oObject AS OBJECT, cPropertyName AS STRING ) AS LOGIC PASCAL
	LOCAL aProperties	AS STRING[]
	LOCAL lReturn		AS LOGIC
	LOCAL nLen			AS INT
	LOCAL nI			AS INT       
	
	aProperties		:= PropertyNames( oObject )
	cPropertyName	:= cPropertyName:ToLower()
	nLen			:= aProperties:Length
	lReturn			:= false
	FOR nI := 1 UPTO nLen
		IF aProperties[nI]:ToLower() == cPropertyName
			lReturn			:= true
			EXIT
		ENDIF
	NEXT
	
	RETURN lReturn
	
STATIC METHOD FixPropertyName( SELF oObject AS OBJECT, cPropertyName AS STRING ) AS STRING PASCAL
	LOCAL aProperties	AS STRING[]
	LOCAL cReturn		AS STRING
	LOCAL nLen			AS INT
	LOCAL nI			AS INT       
	
	aProperties		:= PropertyNames( oObject )
	cPropertyName	:= cPropertyName:ToLower()
	nLen			:= aProperties:Length
	cReturn			:= cPropertyName
	FOR nI := 1 UPTO nLen
		IF aProperties[nI]:ToLower() == cPropertyName
			cReturn			:= aProperties[nI]
			EXIT
		ENDIF
	NEXT
	
	RETURN cReturn

STATIC METHOD GetPropertyValue( SELF oObject AS OBJECT, cPropertyName AS STRING ) AS OBJECT PASCAL
//private object getProperty(object containingObject, string propertyName)
//{
//    return containingObject.GetType().InvokeMember(propertyName, BindingFlags.GetProperty, null, containingObject, null);
//}        
// Achtung: PropertyName muß korrekt geschrieben sein!!!!
	LOCAL oReturn		AS OBJECT	
	LOCAL oInfo			AS System.Reflection.PropertyInfo
	
	oInfo			:= oObject:GetType():GetProperty( cPropertyName ) //, System.Reflection.BindingFlags.GetProperty )
	IF oInfo != null_object                                  
		oReturn			:= oInfo:GetValue( oObject, null_object ) 
	ELSE
		oReturn			:= null_object
	ENDIF

//	oReturn			:= oObject:GetType():InvokeMember( cPropertyName, System.Reflection.BindingFlags.GetProperty, null, oObject, null )
	
	RETURN oReturn

STATIC METHOD SetPropertyValue( SELF oObject AS OBJECT, cPropertyName AS STRING, oValue AS OBJECT ) AS VOID PASCAL 
//private void setProperty(object containingObject, string propertyName, object newValue)
//{
//    containingObject.GetType().InvokeMember(propertyName, BindingFlags.SetProperty, null, containingObject, new object[] { newValue });
//}
// Achtung: PropertyName muß korrekt geschrieben sein!!!!   
	LOCAL oInfo			AS System.Reflection.PropertyInfo
	
	oInfo			:= oObject:GetType():GetProperty( cPropertyName ) //, System.Reflection.BindingFlags.SetProperty )
	IF oInfo != null_object
		// debOut( "set property " + cPropertyName + " to " + oValue:ToString() )
		oInfo:SetValue( oObject, oValue, null_object )                        
	//else
		// debOut( "set property " + cPropertyName + " not ok, Property not found" )
	ENDIF
//	oObject:GetType():InvokeMember( cPropertyName, System.Reflection.BindingFlags.SetProperty, null, oObject, ( Object[] ) oValue )
	
	RETURN


#endregion
#region INTERNAL methods
#endregion
END CLASS

END NAMESPACE
