# Exchange PowerShell Commands  

This document is a compilation of Exchange Management Shell Commands. Practically, anything that needs to be done with the Exchange Management Shell will be listed here. Simply copy and paste any command and substitute the appropriate variables.

Note: You need to have an elevated shell, allow remote signed PowerShell scripts, and permissions to make changes on Exchange with your user.


TODO: Update commands to new EXO commands, include licensing commands. Build a module using all of these. That module should be a "single pane of glass" allowing for management of an Exchange Online environment.

## Table of Contents

 * [Mailbox Commands](https://github.com/kemotep/Windows/blob/master/Notes/Exchange%20Management.md#mailbox-commands) 
 * [Automatic Processing Commands](https://github.com/kemotep/Windows/blob/master/Notes/Exchange%20Management.md#automatic-processing-commands) 
 * [Permissions Commands](https://github.com/kemotep/Windows/blob/master/Notes/Exchange%20Management.md#permissions-commands) 
 * [Distribution List Commands](https://github.com/kemotep/Windows/blob/master/Notes/Exchange%20Management.md#distribution-list-commands) 
 * [Tracking  Commands](https://github.com/kemotep/Windows/blob/master/Notes/Exchange%20Management.md#tracking-commands)
 
## Documentation

[This](https://docs.microsoft.com/en-us/powershell/exchange/exchange-server/exchange-management-shell?view=exchange-ps) is the Official Exchange Management Shell Documentation by Microsoft.


## How to Connect to Exchange Online

    Import-Module ExchangeOnlineManagement #If you have not already imported the module.
    Connect-ExchangeOnline
    
More information on how to connect can be found [here](https://docs.microsoft.com/en-us/powershell/exchange/connect-to-exchange-online-powershell?view=exchange-ps).


## Mailbox Commands

 Create Mail User
 
    New-Mailbox -name "USERNAME" -alias USERNAME -organizationalunit 'domain.example.com/PATH/TO/OU' -userprincipalname USERNAME -samaccountname USERNAME -password fourwordsuppercase -resetpasswordonnextlogon: $true -database 'EXCHANGE_DB'

 Rename Mailbox

    Get-Mailbox OLDMAILBOX | Set-Mailbox -displayname 'NEW MAILBOX' -name 'NEW MAILBOX' -alias NEWMAILBOX

 Create a Shared Mailbox

    New-Mailbox -shared -name "MAILBOX NAME" -alias "MAILBOXALIAS" -organizationalunit 'domain.example.com/PATH/TO/OU' -userprincipalname MAILBOXALIAS@domain.example.com -samaccountname MAILBOXALIAS -database 'EXCHANGE_DB'

 Create Room for meetings, etc.

    New-Mailbox -room -name "ROOM NAME" -alias "ROOMALIAS" -organizationalunit 'domain.example.com/PATH/TO/OU' -userprincipalname ROOMALIAS@domain.example.com -samaccountname ROOMALIAS -database 'EXCHANGE_DB'
	
 Create Equipment (Same as before but with the `-equipment` option instead of shared or room)

 Full Access Rights
 
    Get-Mailbox MAILBOX | Add-MailboxPermission -user USERNAME -AccessRights FullAccess
	
 Send on Behalf Rights
 
    Get-Mailbox MAILBOX | Set-Mailbox -grantsendonbehalf USERNAME
	
 Send As Rights
 
    Get-Mailbox MAILBOX | Add-ADPermission -user USERNAME -ExtendRights Send-As

 Both Full Access and Send As Rights in one go
 
    Get-Mailbox MAILBOX | Add-MailboxPermission -user USERNAME -AccessRights FullAccess | Add-ADPermission -user USERNAME -ExtendRights Send-As

 Change Mailbox Type [equipment|room|shared|user]
 
    Get-Mailbox MAILBOXALIAS | Set-Mailbox -Type: [TYPE]
	
 Add Contact
 
    New-MailContact -Name 'LastName, FirstName' -alias FirstName.LastName -ExternalEmailAddress 'EmailAddress@example.com' -organizationalunit domain.example.com/PATH/TO/ContactsOU


## Automatic Processing Commands
 
 Calendar Invitation AutoAccept
 
    Get-Mailbox | Set-CalendarProcessing -automateprocessing AutoAccept -AddOrganizerToSubject $false -BookingWindowInDays 547 -MaximumDurationInMinutes 9360 -DeleteSubject $false -DeleteComments $false -EnforceSchedulingHorizon $false -RemovePrivateProperty $false
 
 Calendar AutoUpdate
 
    Get-Mailbox | Set-CalendarProcessing -automateprocessing AutoUpdate -AddOrganizerToSubject $false -BookingWindowInDays 547 -MaximumDurationInMinutes 9360 -DeleteSubject $false -DeleteComments $false -EnforceSchedulingHorizon $false -RemovePrivateProperty $false


## Permissions Commands

 Mailbox Folder Permissions
 
  Individual Permissions:[CreateItems|CreateSubfolders|DeleteAllItems|DeleteOwnedItems|EditAllItems|EditOwnedItems|FolderContact|FolderOwner|FolderVisible|ReadItems]
  
  Roles:[Author|Contributor|Editor|None|NonEditingAuthor|Owner|PublishingEditor|PublishingAuthor|Reviewer]
 
    Add-MailboxFolderPermission MAILBOX:\FOLDER -user UserOrSecurityGroup -accessrights [PERMISSION or ROLE]

 Calendar Folder Permissions
 
  Roles specific to Calendar folders:[AvailabilityOnly|LimitedDetails]

    Add-MailboxFolderPermission MAILBOX:\Calendar -user UserOrSecurityGroup -accessrights [PERMISSION or ROLE]


## Distribution List Commands

 Create Non-Security Distribution Group
 
    New-DistributionGroup -name 'DL GROUP NAME' -type 'distribution' -organizationalunit 'domain.example.com/PATH/TO/OU' -alias 'DLGROUPNAME' -samaccountname 'DLGROUPNAME' -managedby user1,user2,user3,userN | set-distributiongroup -CustomAttribute2 AttributeName -requiresenderauthenticationenabled: $true

 Create Security Distribution Group 
  
    New-DistributionGroup -name 'DL SECURITY GROUP NAME' -type 'security' -organizationalunit 'domain.example.com/PATH/TO/OU' -alias 'DLSECURITYGROUPNAME' -samaccountname 'DLSECURITYGROUPNAME' -managedby user1,user2,user3,userN | set-distributiongroup -CustomAttribute2 AttributeName -requiresenderauthenticationenabled: $false

 Add Members to Distribution List
 
    Add-DistributionGroupMember 'DL GROUP NAME' -member UserAlias

 Remove Members from Distribution List
 
    Remove-DistributionGroupMember -Identity 'DL GROUP NAME' -Member UserAlias -BypassSecurityGroupManagerCheck

 Get Distribution List Member
 
    Get-DistributionGroupMember "UserAlias" | fl PrimarySmtpAddress
	
 List Distribution List Membership of User by Distinguished Name
 
  (Step 1)
  
    Get-Mailbox 'UserAlias' | select DistinguishedName | Export-CSV $env:UserProfile\DLMember.csv -notype -append
	
  (Step 2)
  
    Get-DistributionGroup -ResultSize Unlimited -Filter 'Members -eq "User Distinguished Name"' | select name>$env:UserProfile\USERNAME.txt

 Add Manager to Distribution List without Manager Replacement
 
    Get-DistributionGroup 'DL GROUP NAME' | Set-DistributionGroup -managedby @{Add='UserAlias'} -BypassSecurityGroupManagerCheck

 Add Manager to Distribution List with Manager Replacement
 
    Get-DistributionGroup 'DL GROUP NAME' | Set-DistributionGroup -managedby UserAlias -BypassSecurityGroupManagerCheck
	
 Rename Distribution List
 
    Get-DistributionGroup 'CURRENT DL GROUP NAME' | Set-DistributionGroup -DisplayName 'NEW DL GROUP NAME' -alias NEWDLGROUPNAME -BypassSecurityGroupManagerCheck
	

## Tracking Commands
 
 Track Sender
 
    Get-MessageTrackingLog -Sender sender@example.com -Start '01/01/70 12:00am' -End '01/19/38 3:14am' -ResultSize Unlimited | Export-CSV "Path/To/Export.csv" -notype

 Track Recipient
 
    Get-MessageTrackingLog -Recipients recipient@example.com -Start '01/01/70 12:00am' -End '01/19/38 3:14am' -ResultSize Unlimited | Export-CSV "Path/To/Export.csv" -notype
	
 Track Subject
 
    Get-MessageTrackingLog -MessageSubject "Subject in Question" -Start '01/01/70 12:00am' -End '01/19/38 3:14am' -ResultSize Unlimited | Export-CSV "Path/To/Export.csv" -notype
