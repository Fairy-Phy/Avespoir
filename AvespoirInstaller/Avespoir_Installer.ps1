#! /usr/bin/pwsh 

${en-US} = '{
    "MainMenu": {
        "Welcome": "Welcome to Avespoir!",
        "CurrentVersion": "Current Version",
        "Update": "There is a new version!",
        "1": "Download Avespoir",
        "2": "Run Avespoir",
        "3": "Install prerequisite software",
        "4": "Setup ClientConfig.json",
        "5": "Setup MongoDBConfig.json",
        "6": "Exit",
        "ReadLineWindows": "Please choose one from 1 to 6",
        "ReadLineLinux": "Please choose one from 1 to 5"
    },
    "CCS": {
        "Token": "Enter your DiscordBot token",
        "BotownerId": "Enter your Discord User ID",
        "MainPrefix": "Enter the prefix to use on the bot",
        "PublicPrefixTag": "Enter the public prefix tag",
        "ModeratorPrefixTag": "Enter the moderator prefix tag",
        "BotownerPrefixTag": "Enter Botowner prefix tag"
    },
    "DCS": {
        "DBSetupped": "Make sure you have already set up MongoDB before typing!",
        "ConfirmDBSetup": "Settings completed?",
        "UseDatabase": "Enter the database to use for login",
        "Url": "Enter the URL of the database",
        "Port": "Enter the database port number",
        "Username": "Enter the username you use to login",
        "Password": "Enter the password for user to use to login",
        "Mechanism": "Enter the login authentication mechanism",
        "MainDatabase": "Enter the database name to use"
    },
    "Confirm": "Is this really OK?",
    "Cancel": "It was interrupted",
    "ReturnMainMenu": "Return to the main menu ...",
    "Exit": "Exit..."
}' 

${ja-JP} = '{
    "MainMenu": {
        "Welcome": "Avespoirへようこそ！",
        "CurrentVersion": "現在のバージョン",
        "Update": "新しいバージョンがあります！",
        "1": "Avespoirをダウンロードします",
        "2": "Avespoirを起動します",
        "3": "起動に必要なソフトをインストールします",
        "4": "ClientConfig.jsonの設定をします",
        "5": "MongoDBConfig.jsonの設定をします",
        "6": "終了します",
        "ReadLineWindows": "1から6の中で選んでください",
        "ReadLineLinux": "1から5の中で選んでください"
    },
    "CCS": {
        "Token": "DiscordBotのトークンを入力してください",
        "BotownerId": "あなたのDiscordユーザーIDを入力してください",
        "MainPrefix": "Botで使うプレフィックスを入力してください",
        "PublicPrefixTag": "公開用プレフィックスタグを入力してください",
        "ModeratorPrefixTag": "モデレーター用プレフィックスタグを入力してください",
        "BotownerPrefixTag": "Botオーナー用プレフィックスタグを入力してください"
    },
    "DCS": {
        "DBSetupped": "入力する前にMongoDBの設定がすでに完了していることを確認してください！",
        "ConfirmDBSetup": "設定は完了していますか？",
        "UseDatabase": "ログインに使用するデータベースを入力してください",
        "Url": "データベースのURlを入力してください",
        "Port": "データベースのポート番号を入力してください",
        "Username": "ログインに使用するユーザーネームを入力してください",
        "Password": "ログインに使用するユーザーのパスワードを入力してください",
        "Mechanism": "ログインの認証メカニズムを入力してください",
        "MainDatabase": "使用するデータベース名を入力してください"
    },
    "Confirm": "これでよろしいですか？",
    "Cancel": "中断しました",
    "ReturnMainMenu": "メインメニューに戻ります...",
    "Exit": "終了します..."
}' 

function BotRun {
	Write-Host "Start Bot Run..." -ForegroundColor Magenta

	$OldPath = (Get-Location).Path
	$BinPath = "./Avespoir"
	if (!(Test-Path $BinPath)) {
		Write-Host "Not exist Avespoir directory" -ForegroundColor Red
		return
	}
	Set-Location $BinPath

	if (Test-Path "./Avespoir.dll") {
		Start-Process "dotnet" -ArgumentList @("./Avespoir.dll") -NoNewWindow -Wait
	}
	elseif (Test-Path "./AvespoirTest.Test.dll") {
		Start-Process "dotnet" -ArgumentList @("./AvespoirTest.Test.dll") -NoNewWindow -Wait
	}
	else {
		Write-Host "Not exist Excute Avespoir files" -ForegroundColor Red
		return
	}

	Write-Host "End Bot Run." -ForegroundColor Green
	
} 

function CheckUpdate($Version) {
	$Latest = (ConvertFrom-Json (Invoke-WebRequest "https://gitlab.com/api/v4/projects/Avespoir_Project%2FAvespoir/repository/tags").Content)[0].name

	if ($Version -ne $Latest) {
		return $true
	}
	else {
		return $false
	}
} 

function ClientConfigSetting($LanguageObject) {
	Write-Host "Start ClientConfig.json setting..." -ForegroundColor Magenta

	$TokenCheck = $true
	while ($TokenCheck) {
		Write-Host $LanguageObject.CCS.Token
		if (($Token = Read-Host -Prompt "Token")) {
			$TokenCheck = $false
		}
	}

	Write-Host $LanguageObject.CCS.BotownerId
	$BotownerId = Read-Host -Prompt "Botowner ID(Default: 0)"
	if ([string]::IsNullOrWhiteSpace($BotownerId)) {
		$BotownerId = "0"
	}

	Write-Host $LanguageObject.CCS.MainPrefix
	$MainPrefix = Read-Host -Prompt "Main prefix(Default: null)"

	Write-Host $LanguageObject.CCS.PublicPrefixTag
	$PublicPrefixTag = Read-Host -Prompt "Public prefix tag(Default: $)"
	if ([string]::IsNullOrWhiteSpace($PublicPrefixTag)) {
		$PublicPrefixTag = "$"
	}

	Write-Host $LanguageObject.CCS.ModeratorPrefixTag
	$ModeratorPrefixTag = Read-Host -Prompt "Moderator prefix tag(Default: @)"
	if ([string]::IsNullOrWhiteSpace($ModeratorPrefixTag)) {
		$ModeratorPrefixTag = "@"
	}

	Write-Host $LanguageObject.CCS.BotownerPrefixTag
	$BotownerPrefixTag = Read-Host -Prompt "Botowner prefix tag(Default: >)"
	if ([string]::IsNullOrWhiteSpace($BotownerPrefixTag)) {
		$BotownerPrefixTag = ">"
	}

	Write-Host (
		"Token: " + $Token + "`n" +
		"BotownerId: " + $BotownerId + "`n" +
		"MainPrefix: " + $MainPrefix + "`n" +
		"PublicPrefixTag: " + $PublicPrefixTag + "`n" +
		"ModeratorPrefixTag: " + $ModeratorPrefixTag + "`n" +
		"BotownerPrefixTag: " + $BotownerPrefixTag + "`n"
	)

	$ConfirmCheck = $true
	while ($ConfirmCheck) {
		if (($Confirm = Read-Host -Prompt ($LanguageObject.Confirm + "(y or n)"))) {
			if ($Confirm -eq "y") {
				$ClientConfigPSObject = New-Object PSObject -Property @{
					Token = $Token
					BotownerId = $BotownerId
					MainPrefix = $MainPrefix
					PublicPrefixTag = $PublicPrefixTag
					ModeratorPrefixTag = $ModeratorPrefixTag
					BotownerPrefixTag = $BotownerPrefixTag
				}
			
				if (!(Test-Path "./Avespoir")) {
					New-Item "./Avespoir" -ItemType Directory | Out-Null
				}
				if (!(Test-Path "./Avespoir/Configs")) {
					New-Item "./Avespoir/Configs" -ItemType Directory | Out-Null
				}
				ConvertTo-Json $ClientConfigPSObject | Out-File -Encoding UTF8 -FilePath "./Avespoir/Configs/ClientConfig.json"
		
				$ConfirmCheck = $false
			}
			elseif ($Confirm -eq "n") {
				Write-Host $LanguageObject.Cancel
		
				return
			}
		}
	}

	Write-Host "End ClientConfig.json setting." -ForegroundColor Green

	return
} 

function DBConfigSetting($LanguageObject) {
	Write-Host "Start DBConfig.json setting..." -ForegroundColor Magenta

	Write-Host $LanguageObject.DCS.DBSetupped -ForegroundColor Yellow
	$DBSetupCheck = $true
	while ($DBSetupCheck) {
		if (($DBSetupped = Read-Host -Prompt ($LanguageObject.DCS.ConfirmDBSetup + "(y or n)"))) {
			if ($DBSetupped -eq "y") {
				$DBSetupCheck = $false
			}
			elseif ($DBSetupped -eq "n") {
				Write-Host $LanguageObject.Cancel
		
				return
			}
		}
	}

	Write-Host $LanguageObject.DCS.UseDatabase
	$UseDatabase = Read-Host -Prompt "UseDatabase(Default: admin)"
	if ([string]::IsNullOrWhiteSpace($UseDatabase)) {
		$UseDatabase = "admin"
	}

	Write-Host $LanguageObject.DCS.Url
	$Url = Read-Host -Prompt "Url(Default: localhost)"
	if ([string]::IsNullOrWhiteSpace($Url)) {
		$Url = "localhost"
	}

	Write-Host $LanguageObject.DCS.Port
	[int]$Port = Read-Host -Prompt "Port(Default: 27017)"
	if ($Port -eq 0) {
		$Port = 27017
	}

	$UsernameCheck = $true
	while ($UsernameCheck) {
		Write-Host $LanguageObject.DCS.Username
		if (($Username = Read-Host -Prompt "Username")) {
			$UsernameCheck = $false
		}
	}

	$PasswordCheck = $true
	while ($PasswordCheck) {
		Write-Host $LanguageObject.DCS.Password
		if (($Password = Read-Host -Prompt "Password")) {
			$PasswordCheck = $false
		}
	}

	Write-Host $LanguageObject.DCS.Mechanism
	$Mechanism = Read-Host -Prompt "Mechanism(Default: SCRAM-SHA-256)"
	if ([string]::IsNullOrWhiteSpace($Mechanism)) {
		$Mechanism = "SCRAM-SHA-256"
	}

	Write-Host $LanguageObject.DCS.MainDatabase
	$MainDatabase = Read-Host -Prompt "MainDatabase(Default: DiscordBot)"
	if ([string]::IsNullOrWhiteSpace($MainDatabase)) {
		$MainDatabase = "DiscordBot"
	}

	Write-Host (
		"UseDatabase: " + $UseDatabase + "`n" +
		"Url: " + $Url + "`n" +
		"Port: " + $Port + "`n" +
		"Username: " + $Username + "`n" +
		"Password: " + $Password + "`n" +
		"Mechanism: " + $Mechanism + "`n" +
		"MainDatabase: " + $MainDatabase
	)

	$ConfirmCheck = $true
	while ($ConfirmCheck) {
		if (($Confirm = Read-Host -Prompt ($LanguageObject.Confirm + "(y or n)"))) {
			if ($Confirm -eq "y") {
				$DBConfigPSObject = New-Object PSObject -Property @{
					UseDatabase  = $UseDatabase
					Url          = $Url
					Port         = $Port
					Username     = $Username
					Password     = $Password
					Mechanism    = $Mechanism
					MainDatabase = $MainDatabase
				}
			
				if (!(Test-Path "./Avespoir")) {
					New-Item "./Avespoir" -ItemType Directory | Out-Null
				}
				if (!(Test-Path "./Avespoir/Configs")) {
					New-Item "./Avespoir/Configs" -ItemType Directory | Out-Null
				}
				ConvertTo-Json $DBConfigPSObject | Out-File -Encoding UTF8 -FilePath "./Avespoir/Configs/DBConfig.json"
		
				$ConfirmCheck = $false
			}
			elseif ($Confirm -eq "n") {
				Write-Host $LanguageObject.Cancel
		
				return
			}
		}
	}

	Write-Host "End DBConfig.json setting." -ForegroundColor Green

	return
} 

# Referenced from https://docs.microsoft.com/en-us/archive/blogs/jasonn/downloading-files-from-the-internet-in-powershell-with-progress
function DownloadFile($url, $targetFile) {
	try {
		$uri = New-Object "System.Uri" "$url"
		$request = [System.Net.HttpWebRequest]::Create($uri)
		$request.set_Timeout(15000) #15 second timeout
		$response = $request.GetResponse()
		$totalLength = [System.Math]::Floor($response.get_ContentLength() / 1024)
		$responseStream = $response.GetResponseStream()
		$targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $targetFile, Create
		$buffer = new-object byte[] 10KB
		$count = $responseStream.Read($buffer, 0, $buffer.length)
		$downloadedBytes = $count
		while ($count -gt 0) {
			[System.Console]::CursorLeft = 0
			[System.Console]::Write("Downloaded {0}K of {1}K", [System.Math]::Floor($downloadedBytes / 1024), $totalLength)
			$targetStream.Write($buffer, 0, $count)
			$count = $responseStream.Read($buffer, 0, $buffer.length)
			$downloadedBytes = $downloadedBytes + $count
		}
		[System.Console]::WriteLine()
		$targetStream.Flush()
		$targetStream.Close()
		$targetStream.Dispose()
		$responseStream.Dispose()

		return
	}
	catch {
		Write-Host "Error: " -NoNewline -ForegroundColor Red
		Write-Host "Could not download File"
		Remove-Item $targetFile

		return
	}
} 

function GetCultureDictionary {
	try {
		$DefaultLang = "en-US"
		$GetCulture = (Get-Culture).Name
		
		$LangData = Get-Variable -Name $GetCulture -ValueOnly -ea SilentlyContinue
		if ($LangData -eq $null) {
			Write-Host "Warning: " -NoNewline -ForegroundColor Yellow
			Write-Host "Not Exist Language Json"
			$LangData = Get-Variable -Name $DefaultLang -ea SilentlyContinue
		}

		$LangPSObject = ConvertFrom-Json $LangData
	
		return $LangPSObject
	}
	catch {
		Write-Host "Could not get culture dictionary" -ForegroundColor Red
		return $null
	}
} 

function GetVersion {
	try {
		$Version = [System.IO.File]::ReadAllText("./Avespoir/Version", [System.Text.Encoding]::UTF8)
		return $Version
	}
	catch {
		return $null
	}
} 


function DownloadAvespoir {
	Write-Host "Start Download Avespoir..." -ForegroundColor Magenta

	$Version = GetVersion
	$VersionNotExist = [string]::IsNullOrWhiteSpace($Version)
	if (!$VersionNotExist) {
		$UpdateCheck = CheckUpdate($Version)
		if (!$UpdateCheck) {
			Write-Host "This version is Latest"
			return
		}
	}

	if (Get-Command git -ea SilentlyContinue) {
		if (Get-Command dotnet -ea SilentlyContinue) {
			$OldPath = (Get-Location).Path
			$BinPath = $OldPath + "/Avespoir"
			Set-Location ($env:temp +"/")
			$RepoTemp = $env:temp + "/Avespoir"
			$Latest = (ConvertFrom-Json (Invoke-WebRequest "https://gitlab.com/api/v4/projects/Avespoir_Project%2FAvespoir/repository/tags").Content)[0].name

			if (Test-Path $RepoTemp) {
				Remove-Item -Recurse -Force $RepoTemp
			}

			Write-Host "Clone Avespoir..." -ForegroundColor Green
			Start-Process "git" -ArgumentList @("clone", "-b", $Latest, "https://gitlab.com/Avespoir_Project/Avespoir.git") -NoNewWindow -Wait
			Set-Location $RepoTemp

			Write-Host "Build Avespoir..." -ForegroundColor Green
			Start-Process "dotnet" -ArgumentList @("restore") -NoNewWindow -Wait
			Start-Process "dotnet" -ArgumentList @("build", "-c", "Release", "-o", $BinPath) -NoNewWindow -Wait

			Set-Location $BinPath
			$VersionPath = "./Version"
			Get-Variable "Latest" -ValueOnly | Out-File -Encoding UTF8 -NoNewline -FilePath $VersionPath

			Write-Host "End Download Avespoir." -ForegroundColor Green
			Set-Location $OldPath
			return
		}
		else {
			Write-Host "Dotnet Core SDK is not installed" -ForegroundColor Red
			return
		}
	}
	else {
		Write-Host "Git is not installed" -ForegroundColor Red
		return
	}
}

function DotnetInstall.Windows {
	function InstallDotnet.Windows {
		if ([System.Environment]::Is64BitOperatingSystem -or [System.Environment]::Is64BitProcess) {
			$InstallFileUrl = "https://download.visualstudio.microsoft.com/download/pr/43660ad4-b4a5-449f-8275-a1a3fd51a8f7/a51eff00a30b77eae4e960242f10ed39/dotnet-sdk-3.1.200-win-x64.exe"
			$InstallFilePath = "$env:temp/dotnet-sdk-3.1.200-win-x64.exe"
	
			Write-Host "Download Dotnet Install File..."
			DownloadFile($InstallFileUrl, $InstallFilePath)
			if (!Test-Path $InstallFilePath) {
				Write-Host "Could not download Dotnet Install File"
	
				return
			}
			Write-Host "Successfully Downloaded Dotnet Install File."
	
			Write-Host "Excute Dotnet Install File..."
			Start-Process -FilePath $InstallFilePath -Wait
		}
		else {
			$InstallFileUrl = "https://download.visualstudio.microsoft.com/download/pr/05b7bc3e-69b2-4226-ad11-db472130e6e8/50e04d3ed87cde4a7aa2d591051bfafb/dotnet-sdk-3.1.200-win-x86.exe"
			$InstallFilePath = "$env:temp/dotnet-sdk-3.1.200-win-x86.exe"
	
			Write-Host "Download Dotnet Install File..."
			DownloadFile($InstallFileUrl, $InstallFilePath)
			if (!Test-Path $InstallFilePath) {
				Write-Host "Could not download Dotnet Install File"
	
				return
			}
			Write-Host "Successfully Downloaded Dotnet Install File."
	
			Write-Host "Excute Dotnet Install File..."
			Start-Process -FilePath $InstallFilePath -Wait
		}
		Write-Host "Excuted Dotnet Install File."
	
		Write-Host "Remove Dotnet Install File..."
		Remove-Item -Path $InstallFilePath
		Write-Host "Removed Dotnet Install File."
		
		return
	}
	
	if (Get-Command dotnet -ea SilentlyContinue) {
		$DotnetVersion = Invoke-Expression "dotnet --Version"
		if ($DotnetVersion -ge "3.1") {
			Write-Host "Dotnet is already installed"

			return
		}
		else {
			InstallDotnet.Windows

			return
		}
	}
	else {
		InstallDotnet.Windows

		return
	}
}

function GitInstall.Windows {
	function InstallGit.Windows {
		if ([System.Environment]::Is64BitOperatingSystem -or [System.Environment]::Is64BitProcess) {
			$InstallFileUrl = "https://github.com/git-for-windows/git/releases/download/v2.25.1.windows.1/Git-2.25.1-64-bit.exe"
			$InstallFilePath = "$env:temp/v2.25.1.windows.1/Git-2.25.1-64-bit.exe"
	
			Write-Host "Download Git Install File..."
			DownloadFile($InstallFileUrl, $InstallFilePath)
			if (!Test-Path $InstallFilePath) {
				Write-Host "Could not download Git Install File"
	
				return
			}
			Write-Host "Successfully Downloaded Git Install File."
	
			Write-Host "Excute Git Install File..."
			Start-Process -FilePath $InstallFilePath -Wait
		}
		else {
			$InstallFileUrl = "https://github.com/git-for-windows/git/releases/download/v2.25.1.windows.1/Git-2.25.1-32-bit.exe"
			$InstallFilePath = "$env:temp/v2.25.1.windows.1/Git-2.25.1-32-bit.exe"
	
			Write-Host "Download Git Install File..."
			DownloadFile($InstallFileUrl, $InstallFilePath)
			if (!Test-Path $InstallFilePath) {
				Write-Host "Could not download Git Install File"
	
				return
			}
			Write-Host "Successfully Downloaded Git Install File."
	
			Write-Host "Excute Git Install File..."
			Start-Process -FilePath $InstallFilePath -Wait
		}
		Write-Host "Excuted Git Install File."
	
		Write-Host "Remove Git Install File..."
		Remove-Item -Path $InstallFilePath
		Write-Host "Removed Git Install File."
		
		return
	}
	
	if (Get-Command git -ea SilentlyContinue) {
		Write-Host "Git is already installed"

		return
	}
	else {
		InstallGit.Windows

		return
	}
}

function MongoInstall.Windows {
	function InstallMongo.Windows {
		$InstallFileUrl = "https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2012plus-4.2.3-signed.msi"
		$InstallFilePath = "$env:temp/mongodb-win32-x86_64-2012plus-4.2.3-signed.msi"

		Write-Host "Download MongoDB Install File..."
		DownloadFile($InstallFileUrl, $InstallFilePath)
		if (!Test-Path $InstallFilePath) {
			Write-Host "Could not download MongoDB Install File"

			return
		}
		Write-Host "Successfully Downloaded MongoDB Install File."

		Write-Host "Excute MongoDB Install File..."
		$CommandArgs = @("/i", $InstallFilePath)
		Start-Process -FilePath "msiexec" -ArgumentList $CommandArgs -Wait
		Write-Host "Excuted MongoDB Install File."

		Write-Host "Remove MongoDB Install File..."
		Remove-Item -Path $InstallFilePath
		Write-Host "Removed MongoDB Install File."
		
		return
	}

	if (Get-Command mongo -ea SilentlyContinue) {
		$MongoVersion = ((mongo --version).Split(" ") | Select-Object -Skip 3 -First 1).SubString(1)
		if ($MongoVersion -ge "4.2") {
			Write-Host "MongoDB is already installed"

			return
		}
		else {
			InstallMongo.Windows

			return
		}
	}
	else {
		InstallMongo.Windows

		return
	}
}


function MainMenu.Windows {
	$LanguageObject = GetCultureDictionary
	Write-Host $LanguageObject.MainMenu.Welcome

	[bool]$LoopCheck = $true
	while ($LoopCheck) {
		$Version = GetVersion
		if (!([string]::IsNullOrWhiteSpace($Version))) {
			Write-Host ($LanguageObject.MainMenu.CurrentVersion + ": " + $Version)

			$UpdateCheck = CheckUpdate($Version)
			if ($UpdateCheck) {
				Write-Host $LanguageObject.MainMenu.Update
			}
		}

		Write-Host (
			"[1]: " + $LanguageObject.MainMenu.1 + "`n" +
			"[2]: " + $LanguageObject.MainMenu.2 + "`n" +
			"[3]: " + $LanguageObject.MainMenu.3 + "`n" +
			"[4]: " + $LanguageObject.MainMenu.4 + "`n" +
			"[5]: " + $LanguageObject.MainMenu.5 + "`n" +
			"[6]: " + $LanguageObject.MainMenu.6
		)
		$SelectNumber = Read-Host -Prompt $LanguageObject.MainMenu.ReadLineWindows

		# Download Avespoir
		if ($SelectNumber -eq 1) {
			DownloadAvespoir
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# Run Avespoir
		elseif ($SelectNumber -eq 2) {
			BotRun
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# Install prerequisites
		elseif ($SelectNumber -eq 3) {
			PrerequisitesInstall.Windows
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# ClientConfig,json setup
		elseif ($SelectNumber -eq 4) {
			ClientConfigSetting($LanguageObject)
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# MongoDBConfig.json setup
		elseif ($SelectNumber -eq 5) {
			DBConfigSetting($LanguageObject)
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# Exit
		elseif ($SelectNumber -eq 6) {
			Write-Host $LanguageObject.Exit
			return
		}
		else {
			Clear-Host
		}
	}
}

function PrerequisitesInstall.Windows {
	Write-Host "Start install prerequisites..." -ForegroundColor Magenta

	GitInstall.Windows
	DotnetInstall.Windows
	MongoInstall.Windows

	Write-Host "End install prerequisites." -ForegroundColor Green

	return
}

function MainMenu.Linux {
	$LanguageObject = GetCultureDictionary
	Write-Host $LanguageObject.MainMenu.Welcome

	[bool]$LoopCheck = $true
	while ($LoopCheck) {
		$Version = GetVersion
		if (!([string]::IsNullOrWhiteSpace($Version))) {
			Write-Host ($LanguageObject.MainMenu.CurrentVersion + ": " + $Version)

			$UpdateCheck = CheckUpdate($Version)
			if ($UpdateCheck) {
				Write-Host $LanguageObject.MainMenu.Update
			}
		}

		Write-Host (
			"[1]: " + $LanguageObject.MainMenu.1 + "`n" +
			"[2]: " + $LanguageObject.MainMenu.2 + "`n" +
			"[3]: " + $LanguageObject.MainMenu.4 + "`n" +
			"[4]: " + $LanguageObject.MainMenu.5 + "`n" +
			"[5]: " + $LanguageObject.MainMenu.6
		)
		$SelectNumber = Read-Host -Prompt $LanguageObject.MainMenu.ReadLineLinux

		# Download Avespoir
		if ($SelectNumber -eq 1) {
			DownloadAvespoir
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# Run Avespoir
		elseif ($SelectNumber -eq 2) {
			BotRun
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# ClientConfig,json setup
		elseif ($SelectNumber -eq 3) {
			ClientConfigSetting($LanguageObject)
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# MongoDBConfig.json setup
		elseif ($SelectNumber -eq 4) {
			DBConfigSetting($LanguageObject)
			Write-Host $LanguageObject.ReturnMainMenu
			Start-Sleep -Seconds 3
		}
		# Exit
		elseif ($SelectNumber -eq 5) {
			Write-Host $LanguageObject.Exit
			return
		}
		else {
			Clear-Host
		}
	}
}

if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows)) {
	MainMenu.Windows
}
elseif ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
	MainMenu.Linux
}

Start-Sleep -Seconds 3
exit
