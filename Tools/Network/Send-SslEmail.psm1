Function Send-SslEmail {

 Param(
        [Parameter(Mandatory=$True)][String]$mUsr,
        [Parameter(Mandatory=$True)][String]$mPss,
        [Parameter(Mandatory=$False)][String]$mAttch,
        [Parameter(Mandatory=$True)][String]$mTo,
        [Parameter(Mandatory=$False)][String]$mFrom=$mUsr,
        [Parameter(Mandatory=$False)][String]$mCc,
        [Parameter(Mandatory=$False)][String]$mBcc,
        [Parameter(Mandatory=$False)][String]$mSbj="Action required",
        [Parameter(Mandatory=$False)][String]$mBdy="Action required",
        [Parameter(Mandatory=$False)][String]$mSmtpSrv="smtp.office365.com",
        [Parameter(Mandatory=$False)][String]$mPort="587"

    )

$mMsg = new-object System.Net.Mail.MailMessage 
$mMsg.From = $mFrom 
$mMsg.To.Add($mTo) 

########Optional Email parameters: CC, Bcc, Attachment.#######################################################################

if ($mCc) {$mMsg.CC.Add($mCc)}
if ($mBcc) {$mMsg.Bcc.Add($mBcc)}
if ($mAttch) {
                $Attach = new-object Net.Mail.Attachment($mAttch) 
                $mMsg.Attachments.Add($Attach)
             }


##############################################################################################################################


$mMsg.IsBodyHtml = $True 

$mMsg.Subject = $mSbj 
$mMsg.body = $mBdy 

$Smtp = new-object Net.Mail.SmtpClient($mSmtpSrv,$mPort) 
$Smtp.EnableSsl=$True
$Smtp.Credentials = New-Object System.Net.NetworkCredential($mUsr,$mPss )
$Smtp.Send($mMsg) 
}