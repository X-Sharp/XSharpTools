
USING System.Windows.Forms 
USING System.Diagnostics  
USING XSharp.Tools

BEGIN NAMESPACE XSharp.Tools.Windows.Forms

CLASS xstButton INHERIT Button
	
CONSTRUCTOR()      
		SUPER()
	RETURN

PROTECT METHOD OnClick( e AS EventArgs ) AS VOID
	
	SUPER:OnClick( e )
	IF SELF:Parent:IsMethod( SELF:Name ) 
		SELF:Parent:Send( SELF:Name, null_object )
	ENDIF
	
	RETURN
	
METHOD Enable() AS VOID PASCAL
	
	SELF:Enabled		:= true
	
	RETURN	
	
METHOD Disable() AS VOID PASCAL
	
	SELF:Enabled		:= false
	
	RETURN	

	
END CLASS

END NAMESPACE 
