# Paths
$pluginPath = "C:\\wamp64\\www\\mybb-plugin-repos\\NewPoints\\Upload"
$mybbPath = "C:\\wamp64\\www\\mybb\\ryu"

# File paths to delete and symlink (based on the provided file tree)
$filesToSymlink = @(
    "newpoints.php",
    "admin\modules\\newpoints\\forumrules.php",
    "admin\modules\\newpoints\\grouprules.php",
    "admin\modules\\newpoints\\log.php",
    "admin\modules\\newpoints\\maintenance.php",
    "admin\modules\\newpoints\\module_meta.php",
    "admin\modules\\newpoints\\plugins.php",
    "admin\modules\\newpoints\\settings.php",
    "admin\modules\\newpoints\\stats.php",
    "admin\modules\\newpoints\\upgrades.php",
    "images\\newpoints\\index.html",
    "inc\\languages\\english\\newpoints.lang.php",
    "inc\\languages\\english\\admin\\newpoints.lang.php",
    "inc\\languages\\english\\admin\\newpoints_module_meta.lang.php",
    "inc\\plugins\\newpoints.php",
    "inc\\plugins\\newpoints\\admin.php",
    "inc\\plugins\\newpoints\\classes.php",
    "inc\\plugins\\newpoints\\core.php",
    "inc\\plugins\\newpoints\\index.html",
    "inc\\plugins\\newpoints\\core\\hooks.php",
    "inc\\plugins\\newpoints\\core\\index.html",
    "inc\\plugins\\newpoints\\core\\plugin.php",
    "inc\\plugins\\newpoints\\hooks\\admin.php",
    "inc\\plugins\\newpoints\\hooks\\forum.php",
    "inc\\plugins\\newpoints\\hooks\\shared.php",
    "inc\\plugins\\newpoints\\languages\\index.html",
    "inc\\plugins\\newpoints\\languages\\english\\index.html",
    "inc\\plugins\\newpoints\\languages\\english\\newpoints_hello.lang.php",
    "inc\\plugins\\newpoints\\languages\\english\\admin\\index.html",
    "inc\\plugins\\newpoints\\plugins\\newpoints_hello.php",
    "inc\\plugins\\newpoints\\settings\\donations.json",
    "inc\\plugins\\newpoints\\settings\\income.json",
    "inc\\plugins\\newpoints\\settings\\logs.json",
    "inc\\plugins\\newpoints\\settings\\main.json",
    "inc\\plugins\\newpoints\\settings\\stats.json",
    "inc\\plugins\\newpoints\\templates\\button_manage.html",
    "inc\\plugins\\newpoints\\templates\\button_orders.html",
    "inc\\plugins\\newpoints\\templates\\donate.html",
    "inc\\plugins\\newpoints\\templates\\donate_form.html",
    "inc\\plugins\\newpoints\\templates\\donate_inline.html",
    "inc\\plugins\\newpoints\\templates\\header_menu.html",
    "inc\\plugins\\newpoints\\templates\\home.html",
    "inc\\plugins\\newpoints\\templates\\home_income_row.html",
    "inc\\plugins\\newpoints\\templates\\home_income_table.html",
    "inc\\plugins\\newpoints\\templates\\input_select.html",
    "inc\\plugins\\newpoints\\templates\\input_select_option.html",
    "inc\\plugins\\newpoints\\templates\\logs_filter_table.html",
    "inc\\plugins\\newpoints\\templates\\logs_table.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_empty.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_row.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_row_delete.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_row_user.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_thead_delete.html",
    "inc\\plugins\\newpoints\\templates\\logs_table_thead_user.html",
    "inc\\plugins\\newpoints\\templates\\menu.html",
    "inc\\plugins\\newpoints\\templates\\menu_category.html",
    "inc\\plugins\\newpoints\\templates\\modal.html",
    "inc\\plugins\\newpoints\\templates\\no_results.html",
    "inc\\plugins\\newpoints\\templates\\option.html",
    "inc\\plugins\\newpoints\\templates\\option_selected.html",
    "inc\\plugins\\newpoints\\templates\\page.html",
    "inc\\plugins\\newpoints\\templates\\page_confirm.html",
    "inc\\plugins\\newpoints\\templates\\page_confirm_cancel.html",
    "inc\\plugins\\newpoints\\templates\\page_confirm_purchase.html",
    "inc\\plugins\\newpoints\\templates\\page_pagination.html",
    "inc\\plugins\\newpoints\\templates\\points_format.html",
    "inc\\plugins\\newpoints\\templates\\postbit.html",
    "inc\\plugins\\newpoints\\templates\\profile.html",
    "inc\\plugins\\newpoints\\templates\\statistics.html",
    "inc\\plugins\\newpoints\\templates\\statistics_donation.html",
    "inc\\plugins\\newpoints\\templates\\statistics_richest_user.html",
    "inc\\plugins\\newpoints\\upgrades\\index.html",
    "inc\\plugins\\newpoints\\upgrades\\upgrade11.php",
    "inc\\plugins\\newpoints\\upgrades\\upgrade12.php",
    "inc\\plugins\\newpoints\\upgrades\\upgrade19.php",
    "inc\\plugins\\newpoints\\upgrades\\upgrade195.php",
    "inc\\tasks\\backupnewpoints.php", 
    "inc\\tasks\\newpoints.php" 
)

# Process each file and directory
foreach ($relativePath in $filesToSymlink) {
    $sourcePath = Join-Path $pluginPath $relativePath
    $targetPath = Join-Path $mybbPath $relativePath

    # Ensure the target directory exists
    $targetDir = Split-Path $targetPath
    if (!(Test-Path $targetDir)) {
        Write-Host "Creating directory: $targetDir"
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Remove existing file/directory
    if (Test-Path $targetPath) {
        Write-Host "Deleting existing: $targetPath"
        Remove-Item -Path $targetPath -Recurse -Force
    }

    # Create the symlink
    if (Test-Path $sourcePath) {
        Write-Host "Creating symlink: $targetPath -> $sourcePath"
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath | Out-Null
    } else {
        Write-Host "Source not found, skipping: $sourcePath"
    }
}

Write-Host "All symlinks created successfully!"
