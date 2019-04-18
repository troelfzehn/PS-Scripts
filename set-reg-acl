#Funktion, um Berechtigungen für Registry-Keys zu erteilen
                                    function set-PIAce {
                    param (
                                [parameter(Mandatory=$true)][String]$Path,
                                [parameter(Mandatory=$true)][String]$UserName,
                                [parameter(Mandatory=$true)][String]$Rights,
                                [parameter(Mandatory=$true)][String]$Access,
                                [String]$InheritFlag,
                                [String]$PropFlag,
                                [String]$Domain
            
                    )
                    try {

                                $FunctionName = "set-PIAce"
                                $TrennSymbol =" # "
                                $ACLInfo =""
                                $AceCount =0 
                                #ist Path vorhanden
                        If (!(Test-Path -Path $Path)){
                                  #Path nicht vorhanden
                                  Throw ("[$FunctionName] Der Pfad  >{1}< existiert nicht! oder es handelt sich um ein Registry-Value (Berechtigung auf Reg-Value nicht möglich)" -f  $FunctionName,$Path) 
                                }
                        
                                Write-Log -Message "[$FunctionName]Uebergebener Path-Parameter >$Path<"
                                # Welcher Provider wird genutzt
                                $provider= (get-Item $path -force ).psprovider.Name 
                        $IsContainer= (get-Item $path -force ).PSIsContainer
                                Write-Log -Message "[$FunctionName]Provider:  >$Provider< . Container: $IsContainer"
                        
                                If ($Domain -eq "") {
                                  Write-Log -Message "[$FunctionName] Keine Domain angegen. Domain wird ermittelt "
                                  #Auslesen Domain nicht fullquallified 
                                  [String] $Domain = $envUserDomain
                                  Write-Log -Message "[$FunctionName] Ermittelte Domain: $Domain  " 
                                }
                        
                                # Account Objekt erstellen 
                        $Account = new-object system.security.principal.ntaccount($Domain,$UserName)
                                Write-Log -Message "[$FunctionName] Ermittelter Account: $Account  "
                        
                                #Intitialisieren der Variable
                                $setAccess = [System.Security.AccessControl.AccessControlType]::$Access
                                                              
                       #Pruefe auf gueltigen Provider
                       If  (($Provider -ne "Registry") -and ($Provider -ne "FileSystem")){
                         throw ("Nicht unterstützter Powershell Provider wird verwendet")
                       }

                       #Initaisierung der Rechte - Parameter je nach verwendeten Providerart der der Containerart
               
                                # Registry-Key
                                If (($Provider -eq "Registry") -and ($IsContainer)){
                                  Write-Log -Message "[$FunctionName]Initalisiertung der Rechte-Paramter für Registry-Keys"
                          
                          
                                  If (($InheritFlag -ne "Containerinherit") -and  ($InheritFlag -ne "None")){
                                    # Registry nur Containerinerhit und None
                                    $setInheritFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit
                                    Write-Log -Message "[$FunctionName] Kein Inherit Flag oder ungültiger Flag angegeben, Defaultwert >$setInheritFlag< wird verwendet" 
                                  }
                                  else {
                          
                                    $setInheritFlag = [System.Security.AccessControl.InheritanceFlags]::$InheritFlag
                                    Write-Log -Message "[$FunctionName] Es wurde >$setInheritFlag< als Inheritance Flag mitgegeben"
                                  } 
                          
                                  switch ($PropFlag){ 

                                            "" {$setPropFlag =[System.Security.AccessControl.PropagationFlags]::None
                                                        Write-Log -Message "[$FunctionName] Kein Propagation Flag mitgegeben, Defaultwert >$setPropFlag< wird verwendet"
                                                        break} 

                                             "InerhitOnly/NoPropagateInherit" {$setPropFlag =[System.Security.AccessControl.PropagationFlags]::InheritOnly -bor [System.Security.AccessControl.PropagationFlags]::NoPropagateInherit
                                                                       Write-Log -Message "[$FunctionName] Es werden <InerhitOnly und NoPropagateInherit> als Propagation Flag verwendet" $setPropFlag
                                                                               break}

                                     default {$setPropFlag =[System.Security.AccessControl.PropagationFlags]::$PropFlag
                                           Write-Log -Message "[$FunctionName] Es wurde >$setPropFlag< als  Propagation Flag mitgegeben" }     
                  } #Switchende
                          
                         
                                 Write-Log -Message "[$FunctionName] Es werden die Rechte >$Rights< gesetzt. "            
                                 $setRights = [System.Security.AccessControl.Registryrights]$Rights
                        
                                 Write-Log -Message "[$FunctionName] Accessregeln werden erstellt"
                                 $AccessRule = new-object System.Security.AccessControl.RegistryAccessRule($Account,$setRights,$setInheritFlag,$setPropFlag,$setAccess)
                        
                                 Write-Log -Message "[$FunctionName] Rechte, PropagationFlag,InheritanceFlags und Accessregeln fuer RegistryKey erfolgreich initialisiert "   
                                }
                        
                                #ACL auslesen
                                $ACL = Get-Acl $Path 
                        
                                #Alte Access Rules entfernen
                                Write-Log -Message "[$FunctionName]Alte ACE des Accounts wird  $Account entfernt"
                               $ACL.PurgeAccessRules($Account)
                        
                                # Neue Access Rules hinzufuegen
                                Write-Log -Message "[$FunctionName]Neue ACE des Accounts $Account wird hinzugefuegt"
                                $ACL.AddAccessRule($AccessRule)

                        
                                # ACL speichern
                                Write-Log -Message "[$FunctionName]Neue ACL wird gespeichert"
                                set-acl -AclObject $ACL -Path $Path | Out-Null
                        
                                #ACL erneut auslesen und protokollieren
                                $acl=Get-Acl $Path
                                Write-Log -Message "[$FunctionName]Auslesen der ACE fuer $Account, $Path in der neuen ACL "
                                $ACL=$ACL.Access | where {$_.IdentityReference -eq $Account} 

                                Write-Log -Message "[$FunctionName]Folgende ACE-Eintraege existieren für die Source $Path."
                        
                                $ACL | ForEach-Object {
                                 $ACLInfo=""         
                                 $ACLInfo += "Benutzer: " + $_.IdentityReference +$TrennSymbol

                                 if ($Provider -eq "Registry"){$ACLInfo += "Rechte: " + $_.RegistryRights +$TrennSymbol}
                                   else {$ACLInfo += "Rechte: " + $_.FileSystemRights +$TrennSymbol}
                        
                                 $ACLInfo +="Type: " + $_.AccessControlType +$TrennSymbol
                        
                                if ($IsContainer){
                                  $ACLInfo +="InheritanceFlag: " + $_.InheritanceFlags +$TrennSymbol
                                  $ACLInfo +="Propagation Flag: " + $_.PropagationFlags +$TrennSymbol
                                 }
                          
                                  if ($_.isInherited ){$ACLInfo += "ACE wurde geerbt " +$TrennSymbol}
                                            else {$ACLInfo += "ACE wurde nicht geerbt " +$TrennSymbol}

                          
                          
                                  $ACECount=$ACECount + 1 
                                  Write-Log -Message "[$FunctionName] ($AceCount). ACE-Eintrag: $AclInfo"
                                    }
                        
                                               }
                                               catch {
                                                           throw ("{0}.{1} Exception: {2}" -f $MyInvocation.MyCommand.ModuleName,$MyInvocation.MyCommand.Name,$_.Exception.Message)
                                               }
                                    }
