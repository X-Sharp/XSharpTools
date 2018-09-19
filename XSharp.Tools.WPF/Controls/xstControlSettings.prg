// Application : XSharp.Tools.WPF
// xstControlSettings.prg , Created : 18.09.2018   11:52
// User : Wolfgang

BEGIN NAMESPACE XSharp.Tools.WPF

PUBLIC STATIC CLASS xstControlSettings

#region Constructors	

STATIC CONSTRUCTOR()
		
	SUPER()
	
	RETURN

#endregion Constructors	

#region Public methods
		
#endregion Public methods	

#region Public properties

PUBLIC STATIC PROPERTY FontFamily AS System.Windows.Media.FontFamily AUTO GET SET 
PUBLIC STATIC PROPERTY FontSize AS double AUTO GET SET
PUBLIC STATIC PROPERTY FontStretch	AS System.Windows.FontStretch AUTO GET SET
PUBLIC STATIC PROPERTY FontStyle AS System.Windows.FontStyle AUTO GET SET
PUBLIC STATIC PROPERTY FontWeight AS System.Windows.FontWeight AUTO GET SET
PUBLIC STATIC PROPERTY ButtonWidth AS INT AUTO GET SET
PUBLIC STATIC PROPERTY ButtonHeight AS INT AUTO GET SET		
PUBLIC STATIC PROPERTY MinButtonWidth AS INT AUTO GET SET
PUBLIC STATIC PROPERTY MinButtonHeight AS INT AUTO GET SET		
PUBLIC STATIC PROPERTY TextBoxWidth AS INT AUTO GET SET
PUBLIC STATIC PROPERTY TextBoxHeight AS INT AUTO GET SET		
PUBLIC STATIC PROPERTY MinTextBoxWidth AS INT AUTO GET SET
PUBLIC STATIC PROPERTY MinTextBoxHeight AS INT AUTO GET SET		
PUBLIC STATIC PROPERTY Margin AS System.Windows.Thickness AUTO GET SET
// public static property GridRowHeight as double	

#endregion Public properties

#region Internal methods
#endregion Internal methods
	
END CLASS

END NAMESPACE
