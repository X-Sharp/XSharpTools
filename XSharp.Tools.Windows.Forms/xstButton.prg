
using System.Windows.Forms 
using System.Diagnostics  
using XSharp.Tools.Core  

begin namespace XSharp.Tools.Windows.Forms

class xstButton inherit Button
	
constructor()      
		super()
	return

protect method OnClick( e as EventArgs ) as void
	
	super:OnClick( e )
	if self:Parent:IsMethod( self:Name )
		self:Parent:Send( self:Name, null_object )
	endif
	
	return
	
method Enable() as void pascal
	
	self:Enabled		:= true
	
	return	
	
method Disable() as void pascal
	
	self:Enabled		:= false
	
	return	

	
end class

end namespace 