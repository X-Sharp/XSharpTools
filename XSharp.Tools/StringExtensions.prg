
BEGIN NAMESPACE XSharp.Tools

/// <summary> 
/// static container class for extension methods for the array class
/// </summary>
STATIC CLASS StringExtensions
 
/// <summary> 
/// initialization routines
/// </summary>
STATIC CONSTRUCTOR()

    RETURN

/// <summary> 
/// is the string composed by only digits from 0 to 9
/// </summary>
/// <returns>logic value</returns>
STATIC METHOD IsDigitsOnly( SELF cString AS STRING ) AS LOGIC
	LOCAL lReturn			AS LOGIC
	
	lReturn				:= TRUE
	FOREACH cChar AS CHAR IN cString
		IF cChar < '0' .OR. cChar > '9'
			lReturn				:= FALSE
			EXIT
		ENDIF
	NEXT
	
	RETURN lReturn

/// <summary> 
/// is the string composed by only digits from 0 to 9, decimal point and comma
/// </summary>
/// <returns>logic value</returns>
STATIC METHOD IsDecimalDigitsOnly( SELF cString AS STRING ) AS LOGIC
	LOCAL lReturn			AS LOGIC
	
	lReturn				:= TRUE
	FOREACH cChar AS CHAR IN cString
		IF ( cChar < '0' .OR. cChar > '9' ) .AND. ! cChar == '.' .AND. ! cChar == ','
			lReturn				:= FALSE
			EXIT
		ENDIF
	NEXT
	
	RETURN lReturn
	
/// <summary> 
/// returns the part of the string that starts after the pattern
/// </summary>
/// <param name="cPattern">substring to search</param>
/// <returns>the remainder of the string after the pattern. Empty string if the pattern does not exist</returns>
STATIC METHOD StrAfter( SELF cString AS STRING, cPattern AS STRING ) AS STRING
	LOCAL cReturn			AS STRING
	LOCAL nPos				AS INT
	
	IF ( nPos := cString:IndexOf( cPattern ) ) < 1
		cReturn				:= ""
	ELSE
		cReturn				:= cString:Substring( nPos + cPattern:Length )
	ENDIF
	
	RETURN cReturn

/// <summary> 
/// returns the part of the string before the pattern
/// </summary>
/// <param name="cPattern">substring to search</param>
/// <returns>the string before the pattern. The entire string if the pattern does not exist</returns>
STATIC METHOD StrUntil( SELF cString AS STRING, cPattern AS STRING ) AS STRING
	LOCAL cReturn			AS STRING
	LOCAL nPos				AS INT
	
	IF ( nPos := cString:IndexOf( cPattern ) ) < 0
		cReturn				:= cString
	ELSE
		cReturn				:= cString:Substring( 0, nPos )
	ENDIF
	
	RETURN cReturn   
	
/// <summary> 
/// replaces a pattern in a string, case insensitive
/// </summary>
/// <param name="cSearch">substring to search</param>
/// <param name="cReplace">substring to replace</param>
/// <returns>the changed string</returns>
STATIC METHOD StrTranI( SELF cString AS STRING, cSearch AS STRING, cReplace AS STRING ) AS STRING
    LOCAL nPos				AS INT
    LOCAL nLen				AS INT

    cSearch		:= cSearch:ToUpper()
    nLen		:= cSearch:Length
    nPos		:= 0              
    WHILE ( nPos := cString:ToUpper():IndexOf( cSearch, nPos ) ) >= 0
    	IF nPos == 0
    		cString		:= cReplace + cString:SubString( nLen )
    	ELSE
    		cString		:= cString:Substring( 0, nPos ) + cReplace + cString:SubString( nPos + nLen )
    	ENDIF
    END

	RETURN cString


END CLASS

END NAMESPACE // XSharp.Tools
