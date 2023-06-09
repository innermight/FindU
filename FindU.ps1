Import-Module ActivrDirectory
(Get-Host).UI.RawUI.MaxWindowSize.Height = 100
(Get-Host).UI.RawUI.MaxWindowSize.Width = 100
(Get-Host).UI.RawUI.BackgroundColor="black"
cls

function Write-HostColored() {
    [CmdletBinding()]
    param(
        [parameter(Position=0, ValueFromPipeline=$true)]
        [string[]] $Text
        ,
        [switch] $NoNewline
        ,
        [ConsoleColor] $BackgroundColor = $host.UI.RawUI.BackgroundColor
        ,
        [ConsoleColor] $ForegroundColor = $host.UI.RawUI.ForegroundColor
    )
    begin {
        if ($Text -ne $null) {
            $Text = "$Text"
        }
    }
    process {
        if ($Text) {
            $curFgColor = $ForegroundColor
            $curBgColor = $BackgroundColor
            $tokens = $Text.split("#")
            $prevWasColorSpec = $false
            foreach($token in $tokens) {
                if (-not $prevWasColorSpec -and $token -match '^([a-z]*)(:([a-z]+))?$') {
                    try {
                        $curFgColor = [ConsoleColor] $matches[1]
                        $prevWasColorSpec = $true
                    } catch {}
                    if ($matches[3]) {
                        try {
                            $curBgColor = [ConsoleColor] $matches[3]
                            $prevWasColorSpec = $true
                        } catch {}
                    }
                    if ($prevWasColorSpec) {
                        continue
                    }
                }
                $prevWasColorSpec = $false
                if ($token) {
                    $argsHash = @{}
                    if ([int] $curFgColor -ne -1) { $argsHash += @{ 'ForegroundColor' = $curFgColor } }
                    if ([int] $curBgColor -ne -1) { $argsHash += @{ 'BackgroundColor' = $curBgColor } }
                    Write-Host -NoNewline @argsHash $token
                }
                $curFgColor = $ForegroundColor
                $curBgColor = $BackgroundColor
            }
        }
        if (-not $NoNewLine) { write-host }
    }
}

do {
Write-HostColored "#green#╔═══════════════════════════##red#═════════════════════════════##green#═══════════════════════════╗#"
Write-HostColored "#red#╠═══════════════════════════##yellow#═════════════════════════════##red#═══════════════════════════╣#"
Write-HostColored "#yellow#║#                                                                                   #cyan#║#"
Write-HostColored "#magenta#║# #darkcyan#+++++++++++++#                                    #yellow#+++++#        #magenta#+++++         +++++# #green#║#"
Write-HostColored "#green#║#  #darkcyan#+++++++++++#                                      #yellow#+++#          #magenta#+++           +++#  #yellow#║#"
Write-HostColored "#cyan#║#  #darkcyan#+++     +++#                                      #yellow#+++#          #magenta#+++           +++#  #magenta#║#"
Write-HostColored "#red#║#  #darkcyan#+++    +++++#                                     #yellow#+++#          #magenta#+++           +++#  #cyan#║#"
Write-HostColored "#yellow#║#  #darkcyan#+++#            #red#+++#    #darkgreen#++++ ++++#                  #yellow#+++#          #magenta#+++           +++#  #green#║#"
Write-HostColored "#green#║#  #darkcyan#+++  +#         #red#+++#     #darkgreen#+++++  +++#         #yellow#+++++  +++#          #magenta#+++           +++#  #yellow#║#"
Write-HostColored "#magenta#║#  #darkcyan#++++++#                 #darkgreen#++++    +++#      #yellow#++++++++++++#          #magenta#+++           +++#  #cyan#║#"
Write-HostColored "#green#║#  #darkcyan#++++++#        #red#+++++#    #darkgreen#+++     +++#     #yellow#+++       +++#          #magenta#+++           +++#  #red#║#"
Write-HostColored "#cyan#║#  #darkcyan#+++  +#         #red#+++#     #darkgreen#+++     +++#     #yellow#+++       +++#          #magenta#+++           +++#  #yellow#║#"
Write-HostColored "#yellow#║#  #darkcyan#+++#            #red#+++#     #darkgreen#+++     +++#     #yellow#+++       +++#           #magenta#+++         +++#   #magenta#║#"
Write-HostColored "#red#║#  #darkcyan#+++#            #red#+++#     #darkgreen#+++     +++#      #yellow#++++++++++++#            #magenta#+++++++++++++#    #cyan#║#"
Write-HostColored "#magenta#║# #darkcyan#+++++#          #red#+++++#   #darkgreen#+++++   +++++#      #yellow#+++++  +++++#             #magenta#+++++++++#      #green#║#"
Write-HostColored "#yellow#║#                                                                                   #red#║#"
Write-HostColored "#darkblue#╠═══════════════════════════##red#═════════════════════════════##darkblue#═══════════════════════════╣#"
Write-HostColored "#yellow#╚═══════════════════════════##blue#═════════════════════════════##yellow#═══════════════════════════╝#"
""
	$FName=read-host "Введите имя ПК"
	[array]$Comp=@(Get-ADComputer -Filter ('Name -like "*'+$FName+'*"') -Properties * | sort LastLogonDate | % {$_.Name})
    [array]$CompDate=@(Get-ADComputer -Filter ('Name -like "*'+$FName+'*"') -Properties * | sort LastLogonDate | % {$_.LastLogonDate})
    $CompCount=0
    if ($Comp.Count -gt 1){
    Write-HostColored "#magenta#Уточните имя. Найдены следующие варианты:#"
        while ($CompCount -lt $Comp.Count)
        {
        if (Test-Connection $comp[$CompCount] -Count 1 -ErrorAction SilentlyContinue){
        $Ping="В СЕТИ"
        $LLD=$CompDate[$CompCount]
        $TMName=Gwmi Win32_ComputerSystem -Comp $Comp[$CompCount] | % {$_.UserName}
        $TMName = $TMName.Substring($TMName.IndexOf("\")+1)
        $FNUser=Get-ADUser $TMName -properties * | % {$_.Name}
        }
        else
        {
        $Ping="НЕ В СЕТИ"
        $LLD=$CompDate[$CompCount]
        $TMName=" - "
        $FNUser=" - "
        }
        [string]$compCount+"   "+[string]$comp[$compCount]+"   "+[string]$Ping+"   "+[string]$LLD+"   "+[string]$TMName+"   "+[string]$FNUser
        $compCount++
        }
        }
  else {
    if (Test-Connection $comp -Count 1 -ErrorAction SilentlyContinue){
	Write-HostColored "СОЕДИНЕНИЕ                    [  #green#OK#  ]"
	""
	""
	Write-HostColored "#magenta#КТО АВТОРИЗОВАН:#"
	$TMName=Gwmi Win32_ComputerSystem -Comp $comp | % {$_.UserName}
	$TMName=$TMName.Substring($TMName.IndexOf("\")+1)
	$UCreated=Get-ADUser $TMName -properties * | % {$_.Created}
	$UMail=Get-ADUser $TMName -properties * | % {$_.Mail}
	$UModified=Get-ADUser $TMName -properties * | % {$_.Modified}
	$UName=Get-ADUser $TMName -properties * | % {$_.Name}
	$UPhone=Get-ADUser $TMName -properties * | % {$_.TelephoneNumber}
	$UJob=Get-ADUser $TMName -properties * | % {$_.Title}
	$UDepartment=Get-ADUser $TMName -properties * | % {$_.Department}
	Write-HostColored "Компьютер        : #yellow#$comp#"
	Write-HostColored "Логин            : #green#$TMName#"
	Write-HostColored "Имя пользователя : #green#$UName#"
	"Должность        : $UJob"
	"Номер отдела     : $UDepartment"
	Write-HostColored "Создан           : #yellow#$UCreated#"
	Write-HostColored "Изменен          : #yellow#$UModified#"
	Write-HostColored "Номер телефона   : #green#$UPhone#"
	"Почтовый адрес   : $UMail"
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О СЕТИ:#"
	$IPAddress=@(Gwmi Win32_NetworkAdapterConfiguration -comp $comp -Filter IPEnabled=True | % {$_.IPAddress})
	$MACAddress=@(Gwmi Win32_NetworkAdapterConfiguration -comp $comp -Filter IPEnabled=True | % {$_.MACAddress})
	$Description=@(Gwmi Win32_NetworkAdapterConfiguration -comp $comp -Filter IPEnabled=True | % {$_.Description})
	$NetCount=0
		while ($NetCount -lt $IPAddress.Count) 
		{
			"IP адрес          : "+$IPAddress[$NetCount]
			"MAC адрес         : "+$MACAddress[$NetCount]
			"Имя сетевой карты : "+$Description[$NetCount]
			""
			$NetCount++
		}
	""
	""
	Write-HostColored "#magenta#ВЕРСИЯ ОС:#"
	$Caption=Gwmi Win32_OperatingSystem -comp $comp | % {$_.Caption}
	$OSArchitecture=Gwmi Win32_OperatingSystem -comp $comp | % {$_.OSArchitecture}
	Write-HostColored "Редакция    : #green#$Caption#"
	Write-HostColored "Разрядность : #green#$OSArchitecture#"
	""
	Write-HostColored "#magenta#ЛИЦЕНЗИЯ WINDOWS:#"
	$license = Get-WmiObject SoftwareLicensingProduct -comp $comp | where {$_.LicenseStatus} | % {$_.LicenseStatus}
	$licTXT = @()
        foreach ($lic in $license) {
        switch ($lic) {
        0 { $licTXT += "Активация отсутствует" }
        1 { $licTXT += "Активация выполнена" }
        2 { $licTXT += "Отсутствует ключ лицензии" }
        3 { $licTXT += "Требуется активация" }
        4 { $licTXT += "Истек срок действия лицензии" }
        5 { $licTXT += "Предупреждение о необходимости активации" }
        6 { $licTXT += "Расширенный период использования без лицензии" }
        default { $licTXT += "Неизвестно" }
            }
        }
    $licTXT = $licTXT -join ", "
	Write-HostColored "Лицензия    : #green#$licTXT#"

	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О МОНИТОРЕ:#"
	$MonitorManufacturer=Gwmi win32_DesktopMonitor -Comp $comp | % {$_.MonitorManufacturer}
	$ScreenHeight=Gwmi win32_DesktopMonitor -Comp $comp | % {$_.ScreenHeight}
	$ScreenWidth=Gwmi win32_DesktopMonitor -Comp $comp | % {$_.ScreenWidth}
	$MonCount=0
		while ($MonCount -lt $MonitorManufacturer.Count)
		{
			"Производитель : "+$MonitorManufacturer[$MonCount]
			"Разрешение    : "+$ScreenWidth[$MonCount]+" x "+$ScreenHeight[$MonCount]
			""
			$MonCount++
		}
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О ВИДЕОКАРТЕ:#"
	$VName=Gwmi win32_Videocontroller -Comp $comp | % {$_.Name}
	$VCount=0
		while ($VCount -lt $VName.Count)
		{
			"Модель : "+$VName[$VCount]
			$VCount++
			""
		}
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О ПРОЦЕССОРЕ:#"
	$ProcName=Gwmi Win32_Processor -Comp $comp | % {$_.Name}
	"Модель : $ProcName"
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О МАТЕРИНСКОЙ ПЛАТЕ:#"
	$BoardManufacturer=Gwmi Win32_Baseboard -Comp $comp | % {$_.Manufacturer}
	$BoardProduct=Gwmi Win32_Baseboard -Comp $comp | % {$_.Product}
	"Производитель : $BoardManufacturer"
	"Модель        : $BoardProduct"
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ ОБ ОПЕРАТИВНОЙ ПАМЯТИ:#"
	$MemManufacturer=@(Gwmi Win32_PhysicalMemory -Comp $comp | % {$_.Manufacturer})
	$MemCapacity=@(Gwmi Win32_PhysicalMemory -Comp $comp | % {$_.Capacity/1mb})
	$MemCount=0
		while ($MemCount -lt $MemManufacturer.Count)
		{
			"Производитель : "+$MemManufacturer[$MemCount]
			"Объём         : "+$MemCapacity[$MemCount]+" MB"
			$MemCount++
			""
		}
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О РАЗДЕЛАХ HDD:#"
	$HDDDeviceID=Gwmi Win32_LogicalDisk -Comp $comp | % {$_.DeviceID}
	$HDDSize=Gwmi Win32_LogicalDisk -Comp $comp | % {$_.Size/1gb}
	$HDDFreeSpace=Gwmi Win32_LogicalDisk -Comp $comp | % {$_.FreeSpace/1gb}
	$HDDCount=0

		while ($HDDCount -lt $HDDDeviceID.Count)
		{
    			$HDDDeviceID[$HDDCount]+" "+$HDDSize[$HDDCount]+" GB"
    			"Свободное место : "+$HDDFreeSpace[$HDDCount]+" GB"
    			$HDDCount++
    			""
		}
	""
	""
	Write-HostColored "#magenta#ИНФОРМАЦИЯ О ПРИНТЕРАХ#"
	$PrintName=@(Gwmi win32_Printer -comp $comp | % {$_.Name})
	$PrintPortName=@(Gwmi win32_Printer -comp $comp | % {$_.PortName})
	$PrintCount=0
		while ($PrintCount -lt $PrintName.Count)
		{
			"Имя принтера     : "+$PrintName[$PrintCount]
			"Порт подключения : "+$PrintPortName[$PrintCount]
			$PrintCount++
			""
		}
	""
	""
	pause
	cls
    }  
  else { 
    Write-HostColored "СОЕДИНЕНИЕ                    [  #red#ОТСУТСТВУЕТ#  ]"
    pause
    cls 
  } 
       }
       }
while ($FName -ne "")