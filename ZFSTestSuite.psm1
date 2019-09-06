<#
    .DESCRIPTION This will pull the block info using the smartctl software
#>
function Get-SmartBlocks {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $SMARTCtlPath = 'C:\Program Files\smartmontools\bin\smartctl.exe',
        
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SMARTDevice
    )
    $SMARTOutput = cmd /c $SMARTCtlPath -a $SMARTDevice
    $output = @()
    switch -Wildcard ($SMARTOutput) {
        "*Host_Pro*" {
            $output += $PSItem
        }
    }
    $output = $SMARTOutput|Select-String -Pattern "Host_Pro"
    if (!$output) {
        foreach ($i in $SMARTOutput) {
            Write-Verbose -Message $i
        }
        Write-Error -Message "Could not find the the Host_Pro string in the smart output" -ErrorAction Stop
    }
    else {
        foreach ($line in $output) {
            $line.split(' ')[-1]
        }
    }
}