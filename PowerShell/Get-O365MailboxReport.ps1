<###############################################################################

              Get-O365MailboxReport | version 2.0
              kemotep | Apache 2.0
              kemotep@fastmail.com | https://gitlab.com/kemotep

###############################################################################>

<# TODO: Make into PowerShell Module

               Pull domain name to paste into report.

               Switches for options

function Get-O365MailboxReport {
.SYNOPSIS
       Pull a report of Office 365 Mailbox Statistics.
.DESCRIPTION
       This function will pull a report of Office 365 mailbox sizes in MB,
       total number of messages, and last logon time. Outputs results as CSV.
#>

       # First, connect to Exchange Online
       Connect-ExchangeOnline
       # Setup the variables
       $Date = Get-Date -Format yy-MM-dd
       $Report = @()
       $All_Mailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited
       $Total_Mailboxes = $All_Mailboxes.Count
       $i = 1
       # Iterate through Mailboxes, checking to see if users have logged on at least once
       $All_Mailboxes | ForEach-Object {
              $i++
              $Mailbox = $_
              $Mailbox_Stats = Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName
              if ($Mailbox_Stats.LastLogonTime -eq $null){
                     $Logon_Time = "Never Logged In"
              } else {
                     $Logon_Time = $Mailbox_Stats.LastLogonTime
              }

  

       # Here is the progress report of the script
              Write-Progress -activity "Processing $Mailbox" -status "$i out of $Total_Mailboxes completed"
              # Format the results
              $Report += New-Object PSObject -property @{
                     UserPrincipalName = $Mailbox.UserPrincipalName
                     Total_Size_MB = [math]::Round(($Mailbox_Stats.TotalItemSize.ToString().Split('(')[1].Split(' ')[0].Replace(',','')/1MB),2)
                     TotalMessages = $Mailbox_Stats.ItemCount
                     LastLogonTime = $Logon_Time
              }
       }
    
       # Export results to CSV, sorted by largest mailbox size
       $Report | Select UserPrincipalName, Total_Size_MB, TotalMessages, LastLogonTime | Sort-Object Total_Size_MB -Descending | Export-CSV "O365 Mailbox Usage Report ${Date}.csv" -NoTypeInformation -Encoding UTF8
