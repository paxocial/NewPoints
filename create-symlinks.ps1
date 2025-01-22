# Paths
$pluginPath = "C:\\wamp64\\www\\mybb-plugin-repos\\NewPoints\\Upload"
$mybbPath = "C:\\wamp64\\www\\mybb\\ryu"

# Excluded files or directories
$exclusions = @(".git", "filetree.txt", "*.log", "create-symlinks.ps1")

# Function to check if a file or folder is excluded
function IsExcluded {
    param ([string]$relativePath)
    foreach ($exclude in $exclusions) {
        if ($relativePath -like "*$exclude*") {
            return $true
        }
    }
    return $false
}

# Recursively scan the plugin folder and create symlinks
function CreateSymlinks {
    param ([string]$sourceDir, [string]$targetDir)

    Get-ChildItem -Path $sourceDir -Recurse | ForEach-Object {
        # Ensure the item is within the source directory and calculate the relative path
        $fullPath = $_.FullName
        if ($fullPath.Length -le $sourceDir.Length) {
            return
        }

        $relativePath = $fullPath.Substring($sourceDir.Length + 1)

        # Skip excluded files or directories
        if (IsExcluded -relativePath $relativePath) {
            Write-Host "Skipping excluded: $relativePath"
            return
        }

        # Determine source and target paths
        $sourcePath = $fullPath
        $targetPath = Join-Path $targetDir $relativePath

        # Ensure the target directory exists
        $targetDirPath = Split-Path $targetPath
        if (!(Test-Path $targetDirPath)) {
            Write-Host "Creating directory: $targetDirPath"
            New-Item -ItemType Directory -Path $targetDirPath -Force | Out-Null
        }

        # Handle files
        if ($_.PSIsContainer -eq $false) {
            # Remove existing target file/symlink if it exists
            if (Test-Path $targetPath) {
                Write-Host "Deleting existing file/symlink: $targetPath"
                Remove-Item -Path $targetPath -Force
            }

            # Create the symlink
            Write-Host "Creating symlink: $targetPath -> $sourcePath"
            New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
        }
    }
}

# Run the symlink creation
CreateSymlinks -sourceDir $pluginPath -targetDir $mybbPath

Write-Host "Symlink creation completed!"
