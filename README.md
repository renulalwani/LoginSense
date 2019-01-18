# LoginSense
The Script to login Qlik Sense HUB and QMC
# ReadMe
- The machine from where you run this script must be reachable to the Qlik Sense, and necessary port needs to be opened such as 4243.
- Sense Certificate must be imported into Windows Certificate store Current User > Personal in the machine where you run this script.
  Following public article may be useful on how to export/import certificate.
  https://qliksupport.force.com/articles/000005433
- The script work for default proxy
- The script work for Windows local users and Windows Domain users
- The script may not work for SAML users
- You may need to change FQDN, UserDirectory and UserId in the script to fit your environment.
  UserDirecotry and UserId is the user you want to use.

# Instruction
1. Donwload LoginSense.ps1 onto your machine
2. Follow each bullets stated in ReadMe
3. Open Windows Powershell and move to the folder where you saved LoginSense.ps1 on Powershell Console
4. Run .\LoginSense.ps1
5. IE opens and login in Qlik Sense Hub and QMC automatically with the user you specified

# Requirement
 Qlik Sesne Server
 
# Disclaimer
The scripts is not supported by Qlik. Please use it on your own risk
# License
This project is provided "AS IS", without any warranty, under the MIT License - see the LICENSE file for details
