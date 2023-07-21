function test-ipaddress{   

param(
    [Parameter(Mandatory=$true)]
    [ValidateScript ({$_ -match "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"})]
    [string]$ip_address_1,

    [Parameter(Mandatory=$true)]
    [ValidateScript ({$_ -match "^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"})]
    [string]$ip_address_2,

    [Parameter(Mandatory=$true)]
    [ValidateScript ({if ($_.split(".").count -eq 4){($_.Split(".")| foreach{("0000000"+[convert]::ToString([byte]$_,2)) -replace '.*(.{8})','$1' -notmatch "01"}) -notcontains $false}else{[int]$_ -ge 0 -and [int]$_ -le 32}})]
    [string]$network_mask
)

    #convert addresses and mask to binary
    $ip1 = ($ip_address_1.split(".")| foreach{("0000000"+[convert]::ToString([int]$_,2)) -replace '.*(.{8})','$1'}) #-join ""
    $ip2 = ($ip_address_2.split(".")| foreach{("0000000"+[convert]::ToString([int]$_,2)) -replace '.*(.{8})','$1'}) #-join ""

    if([string]$network_mask.split(".").count -eq 4)
        {
            $mask=($network_mask.split(".")| foreach{("0000000"+[convert]::ToString([int]$_,2)) -replace '.*(.{8})','$1'})
        }
    else
        {
            $mask=("1"*[int]$network_mask+"0"*32).Substring(0,32) -split('(.{8})') | Where-Object{$_}
        }

    #main part: bitwise comparison
    for ($i=0; $i -le 3; $i+=1){
        if (([int]$ip1[$i] -band [int]$mask[$i]) -ne ([int]$ip2[$i] -band [int]$mask[$i]))
        {
            Write-Host "no"
          return
        }
    }
    Write-Host "yes"
}

