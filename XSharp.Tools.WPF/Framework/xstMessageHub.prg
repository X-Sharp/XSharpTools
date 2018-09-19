// Application : XSharp.Tools.WPF
// xstMessageHub.prg , Created : 18.09.2018   09:15
// User : Wolfgang

USING System.Collections.Generic

BEGIN NAMESPACE XSharp.Tools.WPF

/// <summary> 
/// a class for a central message hub where clients can register isself
/// </summary>
CLASS xstMessageHub
	STATIC PROTECT _oMessageHub	AS xstMessageHub
	PROTECT _oClients			AS List<IXstMessengerClient>
	      
#region Constructors	
	
/// <summary> 
/// static constructor
/// </summary>
STATIC CONSTRUCTOR()
	
	_oMessageHub			:= xstMessageHub{}

	RETURN
	
/// <summary> 
/// class constructor, cannot be accessed externally
/// </summary>
PRIVATE CONSTRUCTOR()
	
	_oClients			:= List<IXstMessengerClient>{}
	
	RETURN

#endregion
#region Static methods

/// <summary> 
/// return the current instance of the message hub
/// </summary>
/// <returns>a xstMessagHub object</returns>
STATIC METHOD GetInstance() AS XstMessageHub
	
	RETURN _oMessageHub
	
/// <summary> 
/// registers a new client in the message hub
/// </summary>
/// <param name="oClient">a new client, implementing the IXstMessengerClient interface</param>
/// <returns>nothing</returns>
STATIC METHOD RegisterClient( oClient AS IXstMessengerClient ) AS VOID 
	
	xstMessageHub.GetInstance():_RegisterClient( oClient )        
	
	RETURN
	
/// <summary> 
/// removes a client from the message hub clients
/// </summary>
/// <param name="oClient">the client to remove from the message hub clients</param>
/// <returns>nothing</returns>
STATIC METHOD UnRegisterClient( oClient AS IXstMessengerClient ) AS VOID
	
	xstMessageHub.GetInstance():_UnRegisterClient( oClient )        
	
	RETURN
	
/// <summary> 
/// send a message to all registered clients of the message hub
/// </summary>
/// <param name="oMessage">the message to send, must implement the IXstMessage interface</param>
/// <returns>the number of clients accepting the message</returns>
STATIC METHOD SendMessage( oMessage AS IXstMessage ) AS INT
	LOCAL nSent			AS INT
	
	nSent			:= xstMessageHub.GetInstance():_SendMessage( oMessage )

	RETURN nSent

#endregion
#region Private methods

PROTECT METHOD _RegisterClient( oClient AS IXstMessengerClient ) AS VOID
// every object should be registered only once!
	LOCAL oGuid			AS Guid
	
	oGuid			:= oClient:Guid
	
	FOREACH oItem AS IXstMessengerClient IN _oClients
		IF oItem:Guid == oGuid
			_oClients:Remove( oItem )
			EXIT
		ENDIF
	NEXT    
	_oClients:Add( oClient )
	
	RETURN

PROTECT METHOD _UnRegisterClient( oClient AS IXstMessengerClient ) AS VOID
	LOCAL oGuid			AS Guid
	
	oGuid			:= oClient:Guid
	
	FOREACH oItem AS IXstMessengerClient IN _oClients
		IF oItem:Guid == oGuid
			_oClients:Remove( oItem )
			EXIT
		ENDIF
	NEXT
	
	RETURN
	
PROTECT METHOD _SendMessage( oMessage AS IXstMessage ) AS INT
	LOCAL oReceiverGuid		AS Guid
	LOCAL nSent				AS INT
	LOCAL nLen				AS INT
	LOCAL nI				AS INT
	LOCAL oItem 			AS IXstMessengerClient
	                               
	IF oMessage:Receiver == NULL
		oReceiverGuid		:= Guid.Empty
	ELSE
		oReceiverGuid		:= oMessage:Receiver:Guid
	ENDIF
	nSent				:= 0      
	nLen				:= _oClients:Count - 1 
	// foreach does NOT works because the collection can be modified in the loop
	
	IF oReceiverGuid == Guid.Empty
		FOR nI := 0 UPTO nLen                 
			IF _oClients:Count >= nI
				oItem			:= _oClients[nI]
				IF oItem != NULL
					IF oItem:ReceiveMessage( oMessage )
						++nSent
					ENDIF
				ENDIF
			ENDIF
		NEXT
	ELSE
		FOR nI := 0 UPTO nLen                 
			IF _oClients:Count >= nI
				oItem			:= _oClients[nI]
				IF oItem != NULL
					IF oItem:Guid == oReceiverGuid
						IF oItem:ReceiveMessage( oMessage )
							++nSent
						ENDIF
						EXIT
					ENDIF
				ENDIF
			ENDIF
		NEXT
	ENDIF
	
	RETURN nSent


#endregion

END CLASS  

END NAMESPACE

