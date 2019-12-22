$VersionRegexWithoutMinor = "\d+\.\d+\."

$files = gci $Env:BUILD_SOURCESDIRECTORY -recurse | 
		?{ $_.PSIsContainer } | 
		foreach { gci -Path $_.FullName -Recurse -include *.json }
if($files)
{
		foreach ($file in $files) {
				$filecontent = Get-Content($file)
				$VersionData = [regex]::matches($filecontent,$VersionRegexWithoutRevision)
				$NewVersion = $VersionData[0]
				Write-Verbose "VersionData: $NewVersion"
				Write-Verbose "VersionDataxx: $Env:BUILD_BUILDNUMBER"
				$NewVersion = "$NewVersion$Env:BUILD_BUILDNUMBER"
				Write-Verbose "Version: $NewVersion"

				attrib $file -r
				$filecontent -replace $VersionRegex, $NewVersion | Out-File $file
				Write-Verbose "$file.FullName - version applied"
		}

		$Env:BUILD_BUILDNUMBER = $NewVersion
}
else
{
		Write-Warning "Found no files."
}
