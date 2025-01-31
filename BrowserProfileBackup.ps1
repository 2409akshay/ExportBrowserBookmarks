#Bookmark paths
$chromeProfiles = Get-ChildItem -Path $env:LOCALAPPDATA"\Google\Chrome\User Data" | Where-Object { $_.Name -like "Default" -or $_.Name -like "*Profile*"}
$edgeProfiles = Get-ChildItem -Path $env:LOCALAPPDATA"\Microsoft\Edge\User Data" | Where-Object { $_.Name -like "Default" -or $_.Name -like "*Profile*"}

#Output path
$outputPath = $($env:USERPROFILE + "\Desktop\")


#copy Chrome Bookmarks
foreach ($profile in $chromeProfiles)
{
	Get-ChildItem $profile.FullName -Filter "Bookmark*" | Foreach-Object {
		Copy-Item -Path $_.PSPath -Destination $($outputPath + $profile.Name + "_Chrome_" + $(Get-Date).ToString("MMddyyyy") + "_" + $_.Name)
	}
}

#Copy Edge Bookmarks
foreach ($profile in $edgeProfiles)
{
	Get-ChildItem $profile.FullName -Filter "Bookmark*" | Foreach-Object {
		Copy-Item -Path $_.PSPath -Destination $($outputPath + $profile.Name + "_Edge_" + $(Get-Date).ToString("MMddyyyy") + "_" + $_.Name)
	}
}

#Get Chrome Profile mapping
$chromeProfileMapping = Get-ChildItem $env:LOCALAPPDATA"\Google\Chrome\User Data" -Filter "Local State"
$profileMappingObj = Get-Content $chromeProfileMapping.FullName | ConvertFrom-Json
#Add empty line in output file
"" > $($outputPath + "ChromeProfileMapping.txt")
$profileMappingObj.profile.profiles_order | Foreach-Object { 
	$_ + " : " + $profileMappingObj.profile.info_cache.$_.name >> $($outputPath + "ChromeProfileMapping.txt")
}

#Get Edge Profile mapping
$edgeProfileMapping = Get-ChildItem $env:LOCALAPPDATA"\Microsoft\Edge\User Data" -Filter "Local State"
$profileMappingObj = Get-Content $edgeProfileMapping.FullName | ConvertFrom-Json
#Add empty line in output file
"" > $($outputPath + "EdgeProfileMapping.txt")
$profileMappingObj.profile.profiles_order | Foreach-Object { 
	$_ + " : " + $profileMappingObj.profile.info_cache.$_.name >> $($outputPath + "EdgeProfileMapping.txt")
}
