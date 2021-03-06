# IE lockdown - advanced Internet options.
#
# USAGE:
#
#     Lockdown-IeAdvancedOptions.ps1 {Action}
#
# where the mandatory argument Action can be one of the following values: "Hide", "Show".


# TODO: Logging
#
# TBD: Consider the following options:
#
# - Logging to a file specific to this script.
#
# - Logging to a MI Bridge event log (shared by all the MI Bridge script). A common MI Bridge logging library would be required
#
# - Logging to the Applications event log (shared by all Windows applications).


# TODO: Rollback:
#
# Add an option to restore the "original state" - the state before the very first run of this script.
#
#
# TBD: Implementation to consider: 
#
# (1) During the very first run, backup the original settings - e.g. save the current settings in the registry or in a file.
#
# (2) When rollback is requested, restore the original settings from the backup (and remove the backup).
#
# CAVEAT: The original state may have the settings *undefined*! In such a case, rollback is supposed to make the setting undefined again.


# TBD: Disable/Enable Controls: Possible additional feature - cost/benefit analysis needed. 
#
# Do we need a version that, instead of hiding the "Advanced" page, only disables it?
# In other words, do we want to have an option to prevent users from modifying advanced settings but still to allow users to see those settings?
#
# Such variant is technically possible, too. But it would require modification of the HKCU hives, for *each* local user.
# It is more complicated than working with the HKLM hive only.


Param
(
    [Parameter(Mandatory=$TRUE)] [String] $Action
)

# Available actions against the "Advanced" page of the "Internet Options" dialog.
#
$ACTION_HIDE="Hide"                  # Make sure the page is hidden.
$ACTION_SHOW="Show"                  # Make sure the page is visible.
# TBD: Disable/Enable Controls # $ACTION_DISABLE="Disable"    # Make sure all the controls on the page are disabled.
# TBD: Disable/Enable Controls # $ACTION_ENABLE="Enable"      # Make sure all the controls on the page are enabled.
# TODO: Rollback # $ACTION_ROLLBACK="Rollback"  # Restore original state (the state before the first run of this script).

# Relative path to the target registry key. Could be re-used for backup/rollback.
$rpath    = "Software\Policies\Microsoft\Internet Explorer\Control Panel"
# Absolute path to the target registry key. 
$path     = "HKLM:\$rpath"
# Name of the target registry key property.
$propname = "AdvancedTab"

# 
$propval = $NULL
switch ($Action)
{
    $ACTION_HIDE     { $propval = 1     }
    $ACTION_SHOW     { $propval = 0     }
    # # $ACTION_DISABLE  { $propval = 1 }
    # # $ACTION_ENABLE   { $propval = 0 }
    # TODO: Rollback # $ACTION_ROLLBACK { $propval = $NULL }
}

if ( $propval -ne $NULL )
{

    if ( -not (Test-Path -Path $path) )
    {
        New-Item -Force -Path $path
    }
    # TODO: Rollback # else backup the current setting (if not yet backed up)

    Set-ItemProperty -Path $path -Name $propname -Force -Value $propval
    
}
# TODO: Rollback # else use backup to restore original setting (including property removal if there is no backup)



# Pertinent information from MS "Group Policy Reference" document.
#
#
# Disable the Advanced page - machine scope:
#
# File name ...............: inetres.admx	
# Policy Setting Name .....: Disable the Advanced page	
# Scope ...................: Machine	
# Policy Path .............: Windows Components\Internet Explorer\Internet Control Panel
# Registry information ....: HKLM\Software\Policies\Microsoft\Internet Explorer\Control Panel!AdvancedTab	
# Supported on ............: At least Internet Explorer 5.0	
# Help Text ...............: Removes the Advanced tab from the interface in the Internet Options dialog box.  
# If you enable this policy, users are prevented from seeing and changing advanced Internet settings, such as security, multimedia, and printing.  
# If you disable this policy or do not configure it, users can see and change these settings.  
# When you set this policy, you do not need to set the "Disable changing Advanced page settings" policy (located in \User Configuration\Administrative Templates\Windows Components\Internet Explorer\), 
# because this policy removes the Advanced tab from the interface.	
#
# Disable the Advanced page - user scope:
#
# ...
# Scope ...................: User
# ...
# Registry information ....: HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel!AdvancedTab
# ...

# Disable changing Advanced page settings (user scope only)
#
# File name ...............: inetres.admx	
# Policy Setting Name .....: Disable changing Advanced page settings	
# Scope ...................: User	
# Policy Path .............: Windows Components\Internet Explorer	
# Registry information ....: HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel!Advanced	
# Supported on ............: At least Internet Explorer 5.0	Prevents users from changing settings on the Advanced tab in the Internet Options dialog box.  
# Help Text ...............: If you enable this policy, users are prevented from changing advanced Internet settings, such as security, multimedia, and printing. 
# Users cannot select or clear the check boxes on the Advanced tab.  
# If you disable this policy or do not configure it, users can select or clear settings on the Advanced tab.  
# If you set the "Disable the Advanced page" policy (located in \User Configuration\Administrative Templates\Windows Components\Internet Explorer\Internet Control Panel), 
# you do not need to set this policy, because the "Disable the Advanced page" policy removes the Advanced tab from the interface.	
