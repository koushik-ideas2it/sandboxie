# Download all the files and put it in setup directory
$Java = "jre-8u231-windows-i586.exe"
$Git = "Git-Install.exe"
$nvm = "nvm-setup.exe"
$Node = "$($PSScriptRoot)\node-v10.15.1-x86.msi"
$camunda = "camunda-bpm-tomcat-7.11.0.zip"
$python = "$($PSScriptRoot)\python-2.7.15.msi"

$Software_path = "C:\Software\"
$camunda_server = "$($Software_path)\camunda"

function ProcessingAnimation($proc) {
    $cursorTop = [Console]::CursorTop
    
    try {
        [Console]::CursorVisible = $false
        
        $counter = 0
        $frames = '|', '/', '-', '\' 
    
        while (!(ps | ? {$_.path -eq $prog})){
            $frame = $frames[$counter % $frames.Length]
            
            Write-Host "$frame" -NoNewLine
            [Console]::SetCursorPosition(0, $cursorTop)
            
            $counter += 1
            Start-Sleep -Milliseconds 125
        }
        
        # Only needed if you use a multiline frames
        Write-Host ($frames[0] -replace '[^\s+]', ' ')
    }
    finally {
        [Console]::SetCursorPosition(0, $cursorTop)
        [Console]::CursorVisible = $true
    }
}

try
{
    Write-Output "Ideas RPA $($PSScriptRoot)" 
	Set-ExecutionPolicy AllSigned
	Get-ExecutionPolicy
	Write-Output "Extracting code ...."
	Expand-Archive -LiteralPath $camunda -DestinationPath $camunda_server
	Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy RemoteSigned -Force
	#Write-Output ".Net Environment Runtime 472 ....." 
	#Start-Process -Wait -FilePath C:\setup\NDP472-KB4054530-x86-x64-AllOS-ENU.exe -ArgumentList "/S" -PassThru
	Write-Output "Installing Java ....."
	$proc = Start-Process -Wait -FilePath $Java -ArgumentList "INSTALL_SILENT=Enable AUTO_UPDATE=Disable REBOOT=Disable INSTALLDIR=""$($Software_path)jre""" -PassThru
	$proc.WaitForExit()
	$Env:Path += ";$($Software_path)jre\bin"
	Write-Output "Installing Git ...." 
	$proc = Start-Process -Wait -FilePath $Git -ArgumentList "/SILENT /NORESTART /NOCANCEL /NOICONS /SP- /DIR=""$($Software_path)Git\"" /COMPONENTS=""icons,ext\reg\shellhere,assoc,assoc_sh""" -PassThru
	#ProcessingAnimation { $proc }
	$proc.WaitForExit()
	Write-Output "$($env:USERPROFILE)\AppData\Local\Programs\Git\bin"
	$Env:Path += ";$($env:USERPROFILE)\AppData\Local\Programs\Git\bin"
	$Env:Path += ";$($env:USERPROFILE)\AppData\Local\Programs\Git\cmd"
	$Env:Path += ";$($Software_path)Git\bin"
	$Env:Path += ";$($Software_path)Git\cmd"
	Write-Output "Cloning Git Repository ...." 
	Invoke-Command -ScriptBlock {git clone --single-branch --branch dev https://github.com/Ideas2IT/idea-rpa.git C:\idea-rpa}
	Write-Output "Installing node 10.15.1 ....." 
	$proc = Start-Process "msiexec" -ArgumentList "/qb /I $($Node) INSTALLLOCATION=""$($Software_path)Node""" -Wait -PassThru
	$proc.WaitForExit()
	Write-Output "Installing Python 2.7.15 ....." 
	$proc = Start-Process "msiexec" -ArgumentList "/qb /I $($python) INSTALLLOCATION=""$($Software_path)Python""" -Wait -PassThru
	$proc.WaitForExit()
	$Env:Path += ";$($Software_path)Node\bin"
	$Env:Path += ";$($Software_path)Python27"
	$Env:Path += ";C:\Python27"
	Invoke-Command -ScriptBlock {npm install -g node-gyp}
	Invoke-Command -ScriptBlock {npm install -g --production windows-build-tools}
	Invoke-Command -ScriptBlock {cd "C:\idea-rpa"}
	Invoke-Command -ScriptBlock {npm install}
	start-process "cmd.exe" "/c $($camunda_server)\server\apache-tomcat-9.0.19\bin\setenv.bat"
	#$proc = Start-Process nvm-setup.exe -ArgumentList '/silent' -Wait -PassThru
	#$proc.WaitForExit()
	Exit-PSSession
}
catch
{
    Write-Error $_.Exception.ToString()
    Read-Host -Prompt "The above error occurred. Press Enter to exit."
}
