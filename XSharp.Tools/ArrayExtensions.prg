
BEGIN NAMESPACE XSharp.Tools

/// <summary> 
/// static container class for extension methods for the array class
/// </summary>
STATIC CLASS ArrayExtensions

/// <summary> 
/// returns the index of the first array member, depending on the compiler switch
/// </summary>
STATIC METHOD FirstIndex( SELF aArray AS System.Array ) AS INT

	RETURN __ARRAYBASE__

/// <summary> 
/// returns the index of the last array member, depending on the compiler switch
/// </summary>
STATIC METHOD LastIndex( SELF aArray AS System.Array ) AS INT
	LOCAL nLength			AS INT
		
	nLength			:= aArray:Length - 1 + __ARRAYBASE__
		
	RETURN nLength

END CLASS

END NAMESPACE

