#First of all we need to create a Key-File, this can be done in any Powershell-Session
$KeyFile = "C:\temp\AES.key"
$Key = New-Object Byte[] 16   # You can use 16, 24, or 32 for AES
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file $KeyFile

#Now we create a File where we can save the encrypted password - Important is the use of -Key, otherwise the password is not
#usable by other users/machines
$PasswordFile = "C:\temp\Password.txt"
$KeyFile = "C:\temp\AES.key"
$Key = Get-Content $KeyFile
$Password = "P@ssword1" | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile


#With the key file and the password file together other users on other machines can use the password too
$PasswordFile = "C:\temp\Password.txt"
$KeyFile = "C:\temp\AES.key"
$Key = Get-Content $KeyFile
$PlainPassword = Get-Content $PasswordFile | ConvertTo-SecureString -Key $key

#$PlainPassword now has the following value: System.Security.SecureString
#It can be used in this form
#We can also use the password-file for creating a PSCredential-Object (of course $User has to be specified for this):
$MyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)

#We can also convert the $PlainPassword back to the unsecure Plain Text password:
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PlainPassword)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

#an other, thinner way for getting the unsecure Plain Password:
[System.Net.NetworkCredential]::new("", $PlainPassword).Password

<#
IMPORTANT:
Be sure to protect that AES key as if it were your password. 
Anybody who can read the AES key can decrypt anything that was encrypted with it.
#>
