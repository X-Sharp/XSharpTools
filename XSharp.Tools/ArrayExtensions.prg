
begin namespace XSharp.Tools

static class ArrayExtensions
/// <summary> 
/// static container class for extension methods for the array class
/// </summary>

static method FirstIndex( self aArray as System.Array ) as int
/// <summary> 
/// returns the index of the first array member, depending on the compiler switch
/// </summary>

	return __ARRAYBASE__


static method LastIndex( self aArray as System.Array ) as int
/// <summary> 
/// returns the index of the last array member, depending on the compiler switch
/// </summary>
	local nLength			as int
		
	nLength			:= aArray:Length - 1 + __ARRAYBASE__
		
	return nLength

end class

end namespace

