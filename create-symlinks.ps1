# Paths
$pluginPath = "C:\wamp64\www\mybb-plugin-repos\NewPoints\Upload"
$mybbPath   = "C:\wamp64\www\mybb\ryu"

# Excluded files and directories
$exclusions = @(".git", "*.log", "*.ps1", "filetree.txt")

# Function to check if a file or folder should be excluded
function IsExcluded {
    param (
        [string]$relativePath
    )
    foreach ($exclude in $exclusions) {
        if ($relativePath -like "*$exclude*") {
            return $true
        }
    }
    return $false
}

# Function to recursively scan the plugin folder and create symlinks
function CreateSymlinks {
    param (
        [string]$sourceDir,
        [string]$targetDir
    )

    # Validate directories
    if (!(Test-Path -Path $sourceDir)) {
        Write-Error "Source directory does not exist: $sourceDir"
        return
    }

    if (!(Test-Path -Path $targetDir)) {
        Write-Host "Creating target directory: $targetDir"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Get all files and directories recursively from source
    Get-ChildItem -Path $sourceDir -Recurse | ForEach-Object {
        $fullPath = $_.FullName

        # Compute the relative path by removing the source directory portion
        $relativePath = $fullPath.Substring($sourceDir.Length)
        # Trim any leading slashes
        $relativePath = $relativePath.TrimStart("\", "/")

        # Skip excluded files or directories
        if (IsExcluded -relativePath $relativePath) {
            Write-Host "Skipping excluded: $relativePath"
            return
        }

        # Determine the final path in the MyBB folder
        $targetPath = Join-Path $targetDir $relativePath

        if ($_.PSIsContainer) {
            # -- REAL DIRECTORIES + FILE SYMLINKS --
            # Create an actual directory (not a symlink) if it doesn't exist
            if (!(Test-Path $targetPath)) {
                Write-Host "Creating directory: $targetPath"
                New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
            }
        }
        else {
            # Remove existing target file or symlink if it exists
            if (Test-Path $targetPath) {
                Write-Host "Removing existing file/symlink: $targetPath"
                Remove-Item -Path $targetPath -Force
            }
            # Create a file symlink
            Write-Host "Creating symlink: $targetPath -> $fullPath"
            try {
                New-Item -ItemType SymbolicLink -Path $targetPath -Target $fullPath | Out-Null
                Write-Host "Successfully created symlink for: $relativePath"
            }
            catch {
                Write-Error "Failed to create symlink for: $relativePath"
            }
        }
    }
}

# Run the symlink creation
CreateSymlinks -sourceDir $pluginPath -targetDir $mybbPath

Write-Host "Symlink creation completed successfully!"
