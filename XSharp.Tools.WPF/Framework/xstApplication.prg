// Application : XSharp.Tools.WPF
// xstApp.prg , Created : 18.09.2018   09:13
// User : Wolfgang


USING System.Windows

BEGIN NAMESPACE XSharp.Tools.WPF

#region Class declaration

/// <summary> 
/// a extended Application class
/// </summary>
CLASS xstApplication INHERIT Application IMPLEMENTS IXstMessengerClient
	PROTECT _oGuid			AS Guid
	PROTECT _oInitMessage	AS IXstMessage

#endregion
#region constructor and initialization

/// <summary> 
/// constructor, creates the GUID and registers itself in the messagehub
/// </summary>
CONSTRUCTOR()

	SUPER()
	_oGuid				:= Guid.NewGuid()
	xstMessageHub.RegisterClient( SELF )

	RETURN                            
	
#endregion
#region IXstMessengerClient interface

/// <summary> 
/// returns the GUID
/// </summary>
/// <returns>returns the GUID of the object instance</returns>
PUBLIC VIRTUAL PROPERTY Guid AS Guid GET _oGuid

/// <summary> 
/// permits to set an init message
/// </summary>
PUBLIC VIRTUAL PROPERTY InitMessage AS IXstMessage SET _oInitMessage := VALUE

/// <summary> 
/// processes the message, to be overwritten in child classes
/// </summary>
/// <param name="oMessage">message to process</param>
/// <returns>logic value if the message was processed</returns>
VIRTUAL METHOD ReceiveMessage( oMessage AS IXstMessage ) AS LOGIC
	LOCAL lProcessed			AS LOGIC
	
	lProcessed			:= FALSE
	
	RETURN lProcessed
	
/// <summary> 
/// stub method, called after assigning the message
/// </summary>
/// <returns>nothing</returns>
VIRTUAL METHOD InitData() AS VOID
	// Stub method, called after assigning the Message
	
	RETURN

#endregion


END CLASS

END NAMESPACE

