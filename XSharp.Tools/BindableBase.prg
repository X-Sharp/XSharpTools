

using System.ComponentModel    
using System.Runtime.CompilerServices  
using System.Collections.Generic   
using System.Diagnostics   

begin namespace XSharp.Tools

public abstract class BindableBase implements INotifyPropertyChanged              
    /// <summary>
    /// Baseclass for implementing the INotifyPropertyChanged interface. Here'a sample for using it:
    ///    public string FirstName
    ///    {
    ///        get { return Get<string>(); }
    ///        set { Set<string>(value); }
    ///    }
    /// </summary>
   	protect _properties := Dictionary<string, object>{} as Dictionary<string, object> 
    public event PropertyChanged as PropertyChangedEventHandler

protected method _Get<T>( [CallerMemberName] name := null as string ) as T
    /// <summary>
    /// Gets the value of a property
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="name">name of the parameter</param>
    /// <returns></returns>
  	local value := null as object

    Debug.Assert( name != null, "name != null" )
    if _properties.TryGetValue( name, out value )
     	if value == null
       		return Default(T)
       	else
       		return (T) value
       	endif
        // return value == null ? Default(T) : (T)value
    endif
    return Default(T)

protected method _Set<T>( value as T, [CallerMemberName] name := null as string ) as void
    /// <summary>
    /// Sets the value of a property
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="value">value of the parameter</param>
    /// <param name="name">name of the parameter</param>
    /// <remarks>Use this overload when implicitly naming the property</remarks>

    // Debug.Print( "passed Name is " + name + ", passed value is " + value.ToString() )

    Debug.Assert(name != null, "name != null")
    if ( Equals( value, _Get<T>(name) ) )
        return    
    endif
    _properties[name] := value
    OnPropertyChanged( name )
        
    return

protected virtual method OnPropertyChanged([CallerMemberName] propertyName := null as string ) as void
    /// <summary>
    /// Notifies about a changed property value
    /// </summary>
    /// <param name="propertyName">name of the property</param>
 	local handler as PropertyChangedEventHandler
    	
    handler := self:PropertyChanged
    if handler != null
        handler( self, PropertyChangedEventArgs{ propertyName } )
    endif
        
    return
            
end class
	
end namespace
