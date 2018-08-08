
using System
using System.Collections.Generic
using System.Text
using System.Threading.Tasks
using System.ComponentModel
using System.Diagnostics
using System.Runtime.CompilerServices
using System.Dynamic

begin namespace XSharp.Tools

public abstract class ExpandoBase inherit DynamicObject implements INotifyPropertyChanged
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
	protect _oProperties 		:= Dictionary<string, object>{} as Dictionary<string, object> 
    public event PropertyChanged as PropertyChangedEventHandler

public virtual method TrySetMember( oBinder as SetMemberBinder, value as object ) as logic 
/// <summary>
/// When a new property is set, add the property name and value to the dictionary
/// Called when an undefined property setter is accessed
/// </summary>     
/// <param name="oBinder"></param>
/// <param name="value"></param>
/// <returns></returns>
    
    if ! _oProperties.ContainsKey( oBinder.Name )
        _oProperties.Add( oBinder.Name, value )
    else
        _oProperties[oBinder.Name] 	:= value
    endif

    self:OnPropertyChanged( oBinder.Name )

    return true

public virtual method TryGetMember( oBinder as GetMemberBinder, result out object ) as logic
/// <summary>
/// When user accesses something, return the value if we have it
/// Called when an undefined property getter is accessed
/// </summary>      
/// <param name="oBinder"></param>
/// <param name="result"></param>
    local lReturnValue 		as logic

    if _oProperties.ContainsKey( oBinder:Name )
        result 			:= _oProperties[oBinder:Name]
        lReturnValue 	:= true
    else
        lReturnValue 	:= super:TryGetMember( oBinder, out result )
    endif

    return lReturnValue

public virtual method TryInvokeMember( oBinder as InvokeMemberBinder, args as object[], result out object ) as logic
/// <summary>
/// If a property value is a delegate, invoke it
/// Called when an undefined property delegate is accessed
/// </summary>     
/// <param name="oBinder"></param>
/// <param name="args">array of arguments</param>
/// <param name="result">result value</param>
    local lReturnValue 		as logic

    if _oProperties.ContainsKey( oBinder:Name ) .and. _oProperties[oBinder:Name] is System.Delegate
        result 				:= ( ( System.delegate ) _oProperties[oBinder:Name] ):DynamicInvoke( args )
        lReturnValue 		:= true
    else
        lReturnValue 		:= super:TryInvokeMember( oBinder, args, out result )
    endif

    return lReturnValue

public method GetValue( cName as string ) as object
/// <summary>
/// Gets the value of a dynamic property
/// </summary>
/// <typeparam name="T"></typeparam>
/// <param name="name">name of the property</param>
/// <returns></returns>
	local oValue as object
	
    Debug.Assert( cName != null, "cName == null")
    oValue 			:= null
    _oProperties.TryGetValue( cName, out oValue )
    
    return oValue

public method SetValue( cName as string, oValue as object ) as void
/// <summary>
/// Sets the value of a dynamic property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="value">value of the property</param>
/// <param name="name">name of the property</param>
/// <remarks>Use this overload when implicitly naming the property</remarks>

    Debug.Assert( cName != null, "cName == null")
    if Equals( oValue, GetValue( cName ) )
        return
    endif       
    _oProperties[cName] 	:= oValue
    OnPropertyChanged( cName )
    
    return

protected method _Get<T>( [CallerMemberName] cName := null as string ) as T 
/// <summary>
/// Gets the value of a property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="name">name of the property (can be omitted)</param>
/// <returns></returns>
	local value 	:= null as object

    Debug.Assert( cName != null, "cName != null" )
    if _oProperties.TryGetValue( cName, out value )
    	if value == null
    		return Default(T)
    	else
    		return (T) value
    	endif
        // return value == null ? Default(T) : (T)value
    endif
    return Default(T)

protected method _Set<T>( value as T, [CallerMemberName] cName := null as string ) as void 
/// <summary>
/// Sets the value of a property
/// </summary>
/// <typeparam name="T">type of the property</typeparam>
/// <param name="value">value of the property</param>
/// <param name="name">name of the property, can be omitted</param>
/// <remarks>Use this overload when implicitly naming the property</remarks>

    Debug.Print( "passed Name is " + cName + ", passed value is " + value.ToString() )

    Debug.Assert( cName != null, "cName != null" )
    if ( Equals( value, _Get<T>( cName) ) )
        return    
    endif
    _oProperties[cName] := value
    OnPropertyChanged( cName )
    
    return

public virtual method GetDynamicMemberNames() as IEnumerable<string>
/// <summary>
/// Return all dynamic member names
/// </summary>
/// <returns>

    return _oProperties.Keys
    
protected virtual method OnPropertyChanged([CallerMemberName] cPropertyName := null as string ) as void
/// <summary>
/// Notifies about a changed property value
/// </summary>
/// <param name="propertyName">name of the property, can be omitted</param>
	local handler as PropertyChangedEventHandler
	
    handler := self:PropertyChanged
    if handler != null
        handler( self, PropertyChangedEventArgs{ cPropertyName } )
    endif
    
    return

end class

end namespace
