# MIT License
# 
# Copyright (c) 2019 Yoichi Hirotake
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE`
# SOFTWARE.
# LoginSense v1.0 



$FQDN = "QlikServer1.domain.local"
$UserDirectory = "Domain" #$UserDirectory
$UserId = "alex" #$UserId
$Attributes = "[]" #$Attributes

$hdrs = @{}
$hdrs.Add("X-Qlik-Xrfkey","examplexrfkey123")
#$hdrs.Add("X-Qlik-User", "UserDirectory=INTERNAL;UserId=sa_repository")
#$hdrs
$xrfkey="examplexrfkey123"
#$xrfkey
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My" | Where {$_.Subject -like '*QlikClient*'}
#$cert


$body = "{"+ "`"UserDirectory`":"+"`"$($UserDirectory)`""+","+ "`"UserId`":"+"`"$($UserId)`""+","+ "`"Attributes`":"+"$($Attributes)"+"}"
#$body

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy


$res = Invoke-RestMethod -Uri "https://$($FQDN):4243/qps/ticket?xrfkey=$($xrfkey)" -Method Post -Headers $hdrs -Body $body -ContentType 'application/json' -Certificate $cert
$return = $res | Out-String
#$return

$rtn = $return  -replace "`r`n",','
$rtn = $rtn -replace "\s", ''
$rtn = $rtn.Remove(0,2)
$rtn = $rtn.Split(",")
$rtn = $rtn.Split(":") #$rtn
$ticket = $rtn[7]
Write-Host "Issued ticket is: " $ticket

$HUB = "https://$($FQDN)/hub?qlikTicket=$($ticket)"
$QMC = "https://$($FQDN)/qmc?qlikTicket=$($ticket)"
$ie = New-Object -ComObject InternetExplorer.Application
$ie.Navigate("$($HUB)")
$ie.Visible = $true
$ie = New-Object -ComObject InternetExplorer.Application
$ie.Navigate("$($QMC)")
$ie.Visible = $true
