

USING System.ComponentModel    
USING System.Runtime.CompilerServices  
USING System.Collections.Generic   
USING System.Diagnostics   

BEGIN NAMESPACE XSharp.Tools

/// <summary>
/// Baseclass for implementing the INotifyPropertyChanged interface. Here'a sample for using it:
///    public string FirstName
///    {
///        get { return Get<string>(); }
///        set { Set<string>(value); }
///    }
/// </summary>
PUBLIC ABSTRACT CLASS BindableBase IMPLEMENTS INotifyPropertyChanged              
   	PROTECT _properties := Dictionary<STRING, OBJECT>{} AS Dictionary<STRING, OBJECT> 
    PUBLIC EVENT PropertyChanged AS PropertyChangedEventHandler

/// <summary>
/// Gets the value of a property
/// </summary>
/// <typeparam name="T"></typeparam>
/// <param name="name">name of the parameter</param>
/// <returns></returns>
PROTECTED METHOD _Get<T>( [CallerMemberName] name := null AS STRING ) AS T
  	LOCAL VALUE := null AS OBJECT

    Debug.Assert( name != null, "name != null" )
    IF _properties.TryGetValue( name, OUT VALUE )
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
/// <typeparam name="T"></typeparam>
/// <param name="value">value of the parameter</param>
/// <param name="name">name of the parameter</param>
/// <remarks>Use this overload when implicitly naming the property</remarks>
PROTECTED METHOD _Set<T>( VALUE AS T, [CallerMemberName] name := null AS STRING ) AS VOID

    // Debug.Print( "passed Name is " + name + ", passed value is " + value.ToString() )

    Debug.Assert(name != null, "name != null")
    IF ( EQUALS( VALUE, _Get<T>(name) ) )
        RETURN    
    ENDIF
    _properties[name] := VALUE
    OnPropertyChanged( name )
        
    RETURN

/// <summary>
/// Notifies about a changed property value
/// </summary>
/// <param name="propertyName">name of the property</param>
PROTECTED VIRTUAL METHOD OnPropertyChanged([CallerMemberName] propertyName := null AS STRING ) AS VOID
 	LOCAL handler AS PropertyChangedEventHandler
    	
    handler := SELF:PropertyChanged
    IF handler != null
        handler( SELF, PropertyChangedEventArgs{ propertyName } )
    ENDIF
        
    RETURN
            
END CLASS
	
END NAMESPACE
