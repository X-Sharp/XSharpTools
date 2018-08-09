
USING System
USING System.Collections.Generic
USING System.Text
USING System.Threading.Tasks
USING System.ComponentModel
USING System.Diagnostics
USING System.Runtime.CompilerServices
USING System.Dynamic

BEGIN NAMESPACE XSharp.Tools

/// <summary>
/// Baseclass for a dynamic object, implementing the INotifyPropertyChanged interface. 
/// Created from scratch because the ExpandoObject from the Framework is sealed
/// Here'a sample for using the "normal" properties:
///    public string FirstName
///    {
///        get { return _Get<string>(); }
///        set { _Set<string>(value); }
///    }
/// </summary>
PUBLIC ABSTRACT CLASS ExpandoBase INHERIT DynamicObject IMPLEMENTS INotifyPropertyChanged
	PROTECT _oProperties 		:= Dictionary<STRING, OBJECT>{} AS Dictionary<STRING, OBJECT> 
    PUBLIC EVENT PropertyChanged AS PropertyChangedEventHandler

/// <summary>
/// When a new property is set, add the property name and value to the dictionary
/// Called when an undefined property setter is accessed
/// </summary>     
/// <param name="oBinder"></param>
/// <param name="value"></param>
/// <returns></returns>
PUBLIC VIRTUAL METHOD TrySetMember( oBinder AS SetMemberBinder, VALUE AS OBJECT ) AS LOGIC 
    
    IF ! _oProperties.ContainsKey( oBinder.Name )
        _oProperties.Add( oBinder.Name, VALUE )
    ELSE
        _oProperties[oBinder.Name] 	:= VALUE
    ENDIF

    SELF:OnPropertyChanged( oBinder.Name )

    RETURN true

/// <summary>
/// When user accesses something, return the value if we have it
/// Called when an undefined property getter is accessed
/// </summary>      
/// <param name="oBinder"></param>
/// <param name="result"></param>
PUBLIC VIRTUAL METHOD TryGetMember( oBinder AS GetMemberBinder, result OUT OBJECT ) AS LOGIC
    LOCAL lReturnValue 		AS LOGIC

    IF _oProperties.ContainsKey( oBinder:Name )
        result 			:= _oProperties[oBinder:Name]
        lReturnValue 	:= true
    ELSE
        lReturnValue 	:= SUPER:TryGetMember( oBinder, OUT result )
    ENDIF

    RETURN lReturnValue

/// <summary>
/// If a property value is a delegate, invoke it
/// Called when an undefined property delegate is accessed
/// </summary>     
/// <param name="oBinder"></param>
/// <param name="args">array of arguments</param>
/// <param name="result">result value</param>
PUBLIC VIRTUAL METHOD TryInvokeMember( oBinder AS InvokeMemberBinder, args AS OBJECT[], result OUT OBJECT ) AS LOGIC
    LOCAL lReturnValue 		AS LOGIC

    IF _oProperties.ContainsKey( oBinder:Name ) .and. _oProperties[oBinder:Name] IS System.Delegate
        result 				:= ( ( System.delegate ) _oProperties[oBinder:Name] ):DynamicInvoke( args )
        lReturnValue 		:= true
    ELSE
        lReturnValue 		:= SUPER:TryInvokeMember( oBinder, args, OUT result )
    ENDIF

    RETURN lReturnValue

/// <summary>
/// Gets the value of a dynamic property
/// </summary>
/// <typeparam name="T"></typeparam>
/// <param name="name">name of the property</param>
/// <returns></returns>
PUBLIC METHOD GetValue( cName AS STRING ) AS OBJECT
	LOCAL oValue AS OBJECT
	
    Debug.Assert( cName != null, "cName == null")
    oValue 			:= null
    _oProperties.TryGetValue( cName, OUT oValue )
    
    RETURN oValue

/// <summary>
/// Sets the value of a dynamic property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="value">value of the property</param>
/// <param name="name">name of the property</param>
/// <remarks>Use this overload when implicitly naming the property</remarks>
PUBLIC METHOD SetValue( cName AS STRING, oValue AS OBJECT ) AS VOID

    Debug.Assert( cName != null, "cName == null")
    IF EQUALS( oValue, GetValue( cName ) )
        RETURN
    ENDIF       
    _oProperties[cName] 	:= oValue
    OnPropertyChanged( cName )
    
    RETURN

/// <summary>
/// Gets the value of a property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="name">name of the property (can be omitted)</param>
/// <returns></returns>
PROTECTED METHOD _Get<T>( [CallerMemberName] cName := null AS STRING ) AS T 
	LOCAL VALUE 	:= null AS OBJECT

    Debug.Assert( cName != null, "cName != null" )
    IF _oProperties.TryGetValue( cName, OUT VALUE )
    	IF VALUE == null
    		RETURN DEFAULT(T)
    	ELSE
    		RETURN (T) VALUE
    	ENDIF
        // return value == null ? Default(T) : (T)value
    ENDIF
    RETURN DEFAULT(T)

/// <summary>
/// Sets the value of a property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="value">value of the property</param>
/// <param name="name">name of the property, can be omitted</param>
/// <remarks>Use this overload when implicitly naming the property</remarks>
PROTECTED METHOD _Set<T>( VALUE AS T, [CallerMemberName] cName := null AS STRING ) AS VOID 

    Debug.Print( "passed Name is " + cName + ", passed value is " + value.ToString() )

    Debug.Assert( cName != null, "cName != null" )
    IF ( EQUALS( VALUE, _Get<T>( cName) ) )
        RETURN    
    ENDIF
    _oProperties[cName] := VALUE
    OnPropertyChanged( cName )
    
    RETURN

/// <summary>
/// Return all dynamic member names
/// </summary>
/// <returns>
PUBLIC VIRTUAL METHOD GetDynamicMemberNames() AS IEnumerable<STRING>

    RETURN _oProperties.Keys
    
/// <summary>
/// Notifies about a changed property value
/// </summary>
/// <param name="propertyName">name of the property, can be omitted</param>
PROTECTED VIRTUAL METHOD OnPropertyChanged([CallerMemberName] cPropertyName := null AS STRING ) AS VOID
	LOCAL handler AS PropertyChangedEventHandler
	
    handler := SELF:PropertyChanged
    IF handler != null
        handler( SELF, PropertyChangedEventArgs{ cPropertyName } )
    ENDIF
    
    RETURN

END CLASS

END NAMESPACE
