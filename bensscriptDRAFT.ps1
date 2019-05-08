#Initialize thumb drive or ext hard drive for user migrations
Get-Disk
"`n"
$disknum = (Read-Host "Please enter the number associated with your disk")
$confirmation = Read-Host "Are you sure you want to continue? This will format the USB drive, erasing all data."
if ($confirmation -eq 'y') {
  Clear-Disk -Number $disknum -RemoveData
  New-Partition -DiskNumber $disknum -UseMaximumSize -IsActive -DriveLetter M
  Format-Volume -DriveLetter E -FileSystem FAT32 -NewFileSystemLabel Migration
}




net user /domain
"Enter the names of the users to be migrated."
">>"
#$User = Read-Host -Prompt 'Enter the name of the user'
"Press ENTER to finish list input"
$users = @()
do {
 $input = (Read-Host "Please enter the user name")
 if ($input -ne '') {$users += $input}
}
until ($input -eq '')

"`n"
#array of users 
$users

#M:\ must be replaced with path for thumb drive if tech chose not to format
$flsdrv = "M:"

#creates a directory for each user on root of harddrive
ForEach ($dir in (Get-ChildItem -Path "$flsdrv" | where {$_.mode -like 'd*'})){
    New-Item -Path $dir.fullname -Name "$user" -ItemType 'Directory'
    #creates sub-directories under each $user directory
    'Pictures', 'Documents', 'Desktop', 'Bookmarks' | % {New-Item -Name ".\$user\$_" -ItemType 'Directory'}
    #will have to populate each $user folder with an executable that copies
}

#this file-path will need to be changed for each client, and the .exe changed in each server
#this one will work for Leading Age, with files on the Kommon drive (K:)
$destFolders | ForEach-Object {Copy-Item -Path "K:\Information Technology\test_script\copyscript.exe" -Destination "M:\$users"}

"Please verify that all directories and sub-directories were created properly on the drive"

#script to eject/dismount USB
$confirmation1 = Read-Host "Are you sure you want to continue? This will eject the USB drive, dismounting it."
if ($confirmation1 -eq 'y') {
  $driveEject = New-Object -ComObject Shell.Application
  $driveEject.Namespace(17).ParseName("E:").InvokeVerb("Eject")
}

