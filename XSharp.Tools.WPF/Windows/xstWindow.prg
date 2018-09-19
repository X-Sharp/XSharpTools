// Application : XSharp.Tools.WPF
// xstWindow.prg , Created : 18.09.2018   11:58
// User : Wolfgang

USING System.Diagnostics
USING System.Windows 
USING System.Windows.Data  
USING Microsoft.Win32 

BEGIN NAMESPACE XSharp.Tools.WPF   

CLASS xstWindow INHERIT Window IMPLEMENTS IDisposable, IXstMessengerClient, IXstMessageDisplay
	PROTECT _oGuid			AS Guid     
	PROTECT _oInitMessage	AS IMessengerMessage

CONSTRUCTOR()

	SUPER()	
	SELF:Initialize()
	
	RETURN
	
VIRTUAL METHOD Initialize() AS LOGIC
	LOCAL oBinding			AS Binding
	
    _oGuid							:= Guid.NewGuid()
    MessageHub.RegisterClient( SELF )
	SELF:DataContextChanged			+= DependencyPropertyChangedEventHandler{ SELF, @OnDataContextChanged() }
	SELF:SetBinding( Window.TitleProperty, Binding{ "CaptionText" } )
	SELF:SetBinding( Window.IconProperty, Binding{ "Icon" } )
	SELF:SetBinding( Window.CursorProperty, Binding{ "Cursor" } )
	oBinding				:= Binding{ "WindowHeight" }
	oBinding:Mode			:= BindingMode.TwoWay
	SELF:SetBinding( Window.HeightProperty, oBinding )
	oBinding				:= Binding{ "WindowWidth" } 
	oBinding:Mode			:= BindingMode.TwoWay
	SELF:SetBinding( Window.WidthProperty, oBinding )
	
	RETURN
	
PRIVATE METHOD OnDataContextChanged( oSender AS OBJECT, e AS DependencyPropertyChangedEventArgs ) AS VOID
	
	IF e:NewValue IS IRequestCloseViewModel
      // if the new datacontext supports the IRequestCloseViewModel we can use
      // the event to be notified when the associated viewmodel wants to close
      // the window
      ( ( IRequestCloseViewModel ) e:NewValue ):RequestClose += CloseWindow // {| Sender, EventArgs | self:Close() }
	ENDIF
	
	RETURN 	

METHOD CloseWindow( oSender AS OBJECT, e AS EventArgs ) AS VOID 
	
	SELF:Close()
	
	RETURN               
	
#region IMessengerClient interface

PUBLIC VIRTUAL PROPERTY Guid AS Guid GET _oGuid
PUBLIC VIRTUAL PROPERTY InitMessage AS IXstMessage SET _oInitMessage := VALUE
VIRTUAL METHOD ReceiveMessage( oMessage AS IXstMessage ) AS LOGIC
	
	RETURN FALSE

VIRTUAL METHOD InitData() AS VOID
// stub method, is called after assign CauseMessage
	
	RETURN

#endregion     

#region IDisposable Members
VIRTUAL METHOD Dispose() AS VOID
		
	SELF:OnDispose()
			
RETURN

PROTECTED VIRTUAL METHOD OnDispose() AS VOID

    MessageHub.UnRegisterClient( SELF )
		
	RETURN

#endregion // IDisposable Members
#region IMessageDisplay implementation
VIRTUAL METHOD ErrorMessage( cError AS STRING ) AS VOID
	
	System.Windows.MessageBox.Show( cError )
	
	RETURN
	
VIRTUAL METHOD DisplayMessageBox( cCaption AS STRING, cMessage AS STRING ) AS System.Windows.MessageBoxResult
	LOCAL oResult				AS System.Windows.MessageBoxResult

	oResult				:= System.Windows.MessageBox.Show( cMessage, cCaption )
	
	RETURN oResult
	
VIRTUAL METHOD DisplayMessageBox( cCaption AS STRING, cMessage AS STRING, nMessageBoxButton AS System.Windows.MessageBoxButton ) AS System.Windows.MessageBoxResult
	LOCAL oResult				AS System.Windows.MessageBoxResult

	oResult				:= System.Windows.MessageBox.Show( cMessage, cCaption, nMessageBoxButton )
	
	RETURN oResult
	
VIRTUAL METHOD DisplayMessageBox( cCaption AS STRING, cMessage AS STRING, nMessageBoxButton AS System.Windows.MessageBoxButton, nDefault AS System.Windows.MessageBoxResult ) AS System.Windows.MessageBoxResult
	LOCAL oResult				AS System.Windows.MessageBoxResult

	oResult				:= System.Windows.MessageBox.Show( cMessage, cCaption, nMessageBoxButton, System.Windows.MessageBoxImage.None, nDefault )
	
	RETURN oResult
	
VIRTUAL METHOD DisplayMessageBox( cCaption AS STRING, cMessage AS STRING, nMessageBoxButton AS System.Windows.MessageBoxButton, nMessageBoxImage AS System.Windows.MessageBoxImage ) AS System.Windows.MessageBoxResult
	LOCAL oResult				AS System.Windows.MessageBoxResult

	oResult				:= System.Windows.MessageBox.Show( cMessage, cCaption, nMessageBoxButton, nMessageBoxImage )
	
	RETURN oResult
	
VIRTUAL METHOD DisplayMessageBox( cCaption AS STRING, cMessage AS STRING, nMessageBoxButton AS System.Windows.MessageBoxButton, nMessageBoxImage AS System.Windows.MessageBoxImage, nDefault AS System.Windows.MessageBoxResult ) AS System.Windows.MessageBoxResult
	LOCAL oResult				AS System.Windows.MessageBoxResult

	oResult				:= System.Windows.MessageBox.Show( cMessage, cCaption, nMessageBoxButton, nMessageBoxImage, nDefault )
	
	RETURN oResult
	
VIRTUAL METHOD ProcessException( oException AS Exception ) AS rdm.MVVMBase.ProcessExceptionResult
	
	SELF:ErrorMessage( String.Format( e"{0}\n\n{1}", oException:Message, oException:StackTrace ) )
	
	RETURN rdm.MVVMBase.ProcessExceptionResult.None

VIRTUAL METHOD OpenFileName( cFileName AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	
	cReturn				:= SELF:OpenFileName( cFileName, "*.*", "", "" )
	
	RETURN cReturn
	
VIRTUAL METHOD OpenFileName( cFileName AS STRING, cFilter AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	
	cReturn				:= SELF:OpenFileName( cFileName, cFilter, "", "" )
	
	RETURN cReturn
	
VIRTUAL METHOD OpenFileName( cFileName AS STRING, cFilter AS STRING, cInitialDirectory AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		

	cReturn				:= SELF:OpenFileName( cFileName, cFilter, cInitialDirectory, "" )
	
	RETURN cReturn
	
VIRTUAL METHOD OpenFileName( cFileName AS STRING, cFilter AS STRING, cInitialDirectory AS STRING, cCaption AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	LOCAL oDialog			AS OpenFileDialog
	
	oDialog						:= OpenFileDialog{}
	IF ! String.IsNullOrEmpty( cFileName )
		oDialog:FileName			:= cFileName
	ENDIF
	IF ! String.IsNullOrEmpty( cFilter )
		oDialog:Filter				:= cFilter
	ENDIF
	IF ! String.IsNullOrEmpty( cInitialDirectory )
		oDialog:InitialDirectory	:= cInitialDirectory
	ENDIF                       
	IF ! String.IsNullOrEmpty( cCaption )
		oDialog:Title				:= cCaption
	ENDIF
	oDialog:ShowDialog( SELF )
	cReturn				:= oDialog:FileName
	
	RETURN cReturn
	
VIRTUAL METHOD SaveAsFileName( cFileName AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	
	cReturn				:= SELF:SaveAsFileName( cFileName, "", "", "" )
	
	RETURN cReturn
	
VIRTUAL METHOD SaveAsFileName( cFileName AS STRING, cFilter AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	
	cReturn				:= SELF:SaveAsFileName( cFileName, cFilter, "", "" )
	
	RETURN cReturn
	
VIRTUAL METHOD SaveAsFileName( cFileName AS STRING, cFilter AS STRING, cInitialDirectory AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	
	cReturn				:= SELF:SaveAsFileName( cFileName, cFilter, cInitialDirectory, "" )
	
	RETURN cReturn
	
VIRTUAL METHOD SaveAsFileName( cFileName AS STRING, cFilter AS STRING, cInitialDirectory AS STRING, cCaption AS STRING ) AS STRING
	LOCAL cReturn			AS STRING		
	LOCAL oDialog			AS SaveFileDialog
	
	oDialog						:= SaveFileDialog{}
	IF ! String.IsNullOrEmpty( cFileName )
		oDialog:FileName			:= cFileName
	ENDIF
	IF ! String.IsNullOrEmpty( cFilter )
		oDialog:Filter				:= cFilter
	ENDIF
	IF ! String.IsNullOrEmpty( cInitialDirectory )
		oDialog:InitialDirectory	:= cInitialDirectory
	ENDIF                       
	oDialog:ShowDialog( SELF )
	cReturn				:= oDialog:FileName
	
	RETURN cReturn        
	
VIRTUAL METHOD SelectDirectory( cPathName AS STRING ) AS STRING
	LOCAL cReturn			AS STRING	
	
	cReturn				:= SELF:SelectDirectory( cPathName, "" )
	
	RETURN cReturn	

VIRTUAL METHOD SelectDirectory( cPathName AS STRING, cCaption AS STRING ) AS STRING
	LOCAL cReturn			AS STRING	
	
	cReturn				:= WPFUtility.SelectFolder( SELF, cPathName, cCaption, TRUE )
	
	RETURN cReturn

#endregion


END CLASS

END NAMESPACE
