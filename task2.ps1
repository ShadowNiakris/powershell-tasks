    param
    (
        [Parameter(Mandatory=$true, Position=0)]
        $CsvFile
    )

    $accounts = Import-Csv -path $CsvFile -Delimiter ','
    $TextInfo = (Get-Culture).TextInfo
    
    $emails = @()
    $accounts_new = @()

    foreach($line in $accounts)
    {
        $email = ($line.name.Split(' ')[0][0]+$line.name.Split(' ')[1]).ToLower()
        $emails+=($email)

        $newLine = [PSCustomObject]@{
            id = $line.id
            location_id=$line.location_id
            Name = $TextInfo.ToTitleCase($line.name)
            title=$line.title
            email = $email
            department=$line.department
        }
        $accounts_new+=$newline        
    }

    foreach($line in $accounts_new){
        if (($emails -match $line.email) -gt 1){
            $line.email += $line.location_id+'@abc.com'
        }
    }

    $path = "$((Get-ChildItem $CsvFile).Directory)\accounts_new.csv"
     $accounts_new |Export-Csv -Path $path -NoTypeInformation -Delimiter ','
