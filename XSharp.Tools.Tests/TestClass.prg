﻿//
// Note 1: If this does not compile then you need to restore the Nuget Packages for XUnit
// You can do that by right clicking on the project item in the solution explorer
// and choosing 'Manage Nuget packages' 
// You can also set a setting inside Visual Studio to make sure the Nuget Packages get restored
// automatically. See: Tools - Nuget Package Manager - Package Manager Settings
//
// Note 2: Inside Visual Studio you should open the Test - Windows - Test Explorer Window
// From there you can run the tests and see which tests succeeded and which tests failed
//
USING System
USING System.Collections.Generic
USING System.Linq
USING System.Text
USING XUnit
BEGIN NAMESPACE XSharp.Tools.Tests
	CLASS TestClass
	CONSTRUCTOR()
		RETURN		
		
	[Fact];
	METHOD TestMethod1 AS VOID
		Assert.Equal(1,1)
	RETURN
	[Fact];
	METHOD TestMethod2 AS VOID
		Assert.Equal(True, False) // Note that this will fail of course
	END CLASS
END NAMESPACE
