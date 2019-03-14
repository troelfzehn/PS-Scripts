#Abgleich, ob Fonts bereits installiert sind. Wenn nicht für Weiterverarbeitung in Temp-Ordner kopieren
            Write-Log -Message '[Start]'
                                    Write-Log -Message "Prüfung auf bereits installierte SPK-Fonts"
            $winfonts = (Get-Childitem "C:\Windows\Fonts" -Filter *.ttf).Name
            $spkfonts = (Get-Childitem "C:\temp\LBBW_SYS_SPKFONTS_1.0.0.0_XX_220900_ALL_X96_01_01\Paket\Files\TTFs" -Filter *.ttf).Name

            foreach ($font in $spkfonts) {
                If ($winfonts -notcontains $font) {
                    Copy-File -Path "$dirFiles\TTFs\$font" -Destination "$envSystemDrive\temp\Fonts"
                    }
                    }
            #Installaion der Fonts
                                    $sa = New-Object -comobject shell.application
             
            get-childitem -Path C:\temp\fonts | foreach-object {
                 
                $fonts = $sa.NameSpace(0x14)
                $fonts.CopyHere("$envSystemDrive\temp\Fonts\$($_.Name)",16)
                Write-Log -Message "$($_.Name) wurde installiert"
         } 

         #Ein paar Fonts werden mit anderem Namen im System abgelegt, wodurch das Skript sie nicht als bereits installiert erkennt
         #Für diese Fonts erfolgt eine Prüfung anhand der Registry (S_A und S_A Bold sowie S_C und S_C Bold)
         #Spk_cbd.ttf - S_C Bold
         $check = Get-RegistryKey -Key "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Value "Sparkassen-S_C Bold (TrueType)"
         IF (!($check)) {
            #$sa = New-Object -comobject shell.application
            $fonts = $sa.NameSpace(0x14)
            $fonts.CopyHere("$dirFiles\Spk_cbd.ttf")
            }
         #SPK_c.ttf - Sparkassen-S_C
         $check = Get-RegistryKey -Key "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Value "Sparkassen-S_C (TrueType)"
            IF (!($check )) {
            #$sa = New-Object -comobject shell.application
            $fonts = $sa.NameSpace(0x14)
            $fonts.CopyHere("$dirFiles\SPK_c.ttf")
            }
           #SPK_adb.ttf - Sparkassen-S_A Bold
         $check = Get-RegistryKey -Key "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Value "Sparkassen-S_A Bold (TrueType)"
         IF (!($check )) {
            #$sa = New-Object -comobject shell.application
            $fonts = $sa.NameSpace(0x14)
            $fonts.CopyHere("$dirFiles\SPK_adb.ttf")
            }
         #SPK_a.ttf - Sparkassen-S_A
         $check = Get-RegistryKey -Key "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Value "Sparkassen-S_A (TrueType)"
            IF (!($check )) {
           # $sa = New-Object -comobject shell.application
            $fonts = $sa.NameSpace(0x14)
            $fonts.CopyHere("$dirFiles\SPK_a.ttf")
            }
