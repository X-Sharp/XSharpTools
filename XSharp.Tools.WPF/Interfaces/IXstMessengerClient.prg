// Application : XSharp.Tools.WPF
// IXstMessenger.prg , Created : 18.09.2018   08:52
// User : Wolfgang

BEGIN NAMESPACE XSharp.Tools.WPF

INTERFACE IXstMessengerClient

METHOD ReceiveMessage( oMessage AS IXstMessage ) AS LOGIC
METHOD InitData() AS VOID
PROPERTY InitMessage AS IXstMessage SET
PROPERTY Guid AS Guid GET

END INTERFACE

END NAMESPACE

