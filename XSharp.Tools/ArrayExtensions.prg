
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

/// <summary> 
/// returns the 1-based index of the pattern array in the buffer array, starting at offset
/// </summary>
/// <param name="aPattern">byte array to search</param>
/// <param name="nOffset">1-based offset where to start</param>
/// <returns>the 1-based offset of aPattern in aBuffer</returns>
PUBLIC STATIC METHOD IndexOfBytes( SELF aBuffer AS BYTE[], aPattern AS BYTE[], nOffset AS INT ) AS INT
// 1-based!
	LOCAL nReturn			AS INT
	LOCAL nI				AS INT
	LOCAL nLen				AS INT
	LOCAL nPointer			AS INT

	// 1-based arrays	
	nReturn			:= 0
	nPointer		:= 1
	nLen			:= aBuffer:Length
	
	FOR nI := ( nOffset ) UPTO nLen
		IF aBuffer[nI] == aPattern[nPointer]
			++nPointer
		ELSE
			nPointer			:= 1
		ENDIF
		IF nPointer > aPattern:Length
			nReturn				:= nI - aPattern:Length + 1
			EXIT
		ENDIF
	NEXT
	
	RETURN nReturn
	
/// <summary> 
/// returns a subarray, starting at given offset
/// </summary>
/// <param name="nStart">1-based offset where to start</param>
/// <returns>a new array, copy starting at given offset</returns>
PUBLIC STATIC METHOD SubArray<T>( SELF aSource AS T[], nStart AS INT ) AS T[]
// 1-based
	LOCAL aReturn			AS T[]
	LOCAL nI				AS INT

	IF nStart > aSource:Length
		aReturn				:= T[]{ 0 }
	ELSE	
		aReturn				:= T[]{ aSource:Length - nStart + 1 }
		FOR nI := nStart UPTO aSource:Length
			aReturn[nI-nStart+1] := aSource[nI]
		NEXT
	ENDIF
	
	RETURN aReturn		

/// <summary> 
/// returns a subarray, starting at given offset, and with a specified length
/// </summary>
/// <param name="nStart">1-based offset where to start</param>
/// <param name="nStart">length to return</param>
/// <returns>a new array, copy starting at given offset, with the specified length. If the source array is not long enough, the returned array is shorter than </returns>
PUBLIC STATIC METHOD SubArray<T>( SELF aSource AS T[], nStart AS INT, nLength AS INT ) AS T[]
// 1-based
	LOCAL aReturn			AS T[]
	LOCAL nI				AS INT
	
	IF nLength > ( aSource:Length - nStart + 1 )
		nLength				:= aSource:Length - nStart + 1
	ENDIF
	aReturn				:= T[]{ nLength }
	FOR nI := 1 UPTO nLength
		aReturn[nI] 		:= aSource[nStart+nI-1]
	NEXT
	
	RETURN aReturn		



END CLASS

END NAMESPACE

