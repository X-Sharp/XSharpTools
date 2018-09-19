// Application : XSharp.Tools.WPF
// xstMessage.prg , Created : 18.09.2018   08:50
// User : Wolfgang

USING System.Collections.Generic

BEGIN NAMESPACE XSharp.Tools.WPF

INTERFACE IXstMessage

PROPERTY Message AS STRING GET
PROPERTY Sender AS IXstMessengerClient GET
PROPERTY Receiver AS IXstMessengerClient GET
PROPERTY Data AS OBJECT GET
PROPERTY Parameters AS Dictionary<STRING,OBJECT> GET
METHOD AddParameter( cName AS STRING, oValue AS OBJECT ) AS VOID 
METHOD GetParameter( cName AS STRING ) AS OBJECT

END INTERFACE

END NAMESPACE

