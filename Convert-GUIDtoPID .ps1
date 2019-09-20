Function Convert-GUIDtoPID 
		{
		[CmdletBinding()]
		 param(
		 #Accepts only GUID data type, to ensure Valid string format.
		 [Parameter(Mandatory=$True, ValueFromPipeline=$true,Position=0)]
		 [GUID]$GUID)
		 
		 #Stripping off the brackets and the dashes from the GUID, leaving only alphanumerical chars.
		 $ProductIDChars = [regex]::replace($GUID, "[^a-zA-Z0-9]", "")
		 
		 #1. Reversing the first 8 characters, next 4, next 4. Then for the latter half, reverse every two char.
		 $RearrangedCharIndex = 7,6,5,4,3,2,1,0,11,10,9,8,15,14,13,12,17,16,19,18,21,20,23,22,25,24,27,26,29,28,31,30
		 Return -join ($RearrangedCharIndex | ForEach-Object{$ProductIDChars[$_]})
		 }
