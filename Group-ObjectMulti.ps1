function Group-ObjectMulti
    {
    <#
        .SYNOPSIS
            This cmdlet extends Group-Object to return a table with a separate column for each property, rather than a single "Name" column with a comma separated list of properties
        .DESCRIPTION
            This cmdlet will 
        .PARAMETER Property
            Specifies the properties for grouping.
        .PARAMETER InputObject
            Specifies the objects to group. Enter a variable that contains the objects. To group the objects in a collection, pipe the objects to Group-ObjectMulti.
        .PARAMETER WithElement
            Indicates that this cmdlet includes the members of a group from the results. This is the reverse of the Group-Object NoElement property
        .EXAMPLE
            Get-ChildItem | Group-ObjectMulti -Property PSIsContainer,Extension
        .NOTES

        .LINK
            https://github.com/marknettle/psUtils
    #>

    [CmdletBinding()]

    param (
        [parameter(Mandatory)]          [Object[]]  $Property,
        [parameter(ValueFromPipeline)]  [Object[]]  $InputObject,
        [parameter()]                   [switch]    $WithElement
    )

    begin {
        $i=0
        $columns = $Property | Foreach-Object {
            @{  Label =       [System.String]$_
                Expression =  [System.Management.Automation.ScriptBlock]::Create("(`$_.Name -split ', ')[$i]")
            }
            $i++
        }
        $columns = ,"Count"+$columns
        if ($WithElement) { $columns = $columns+"Group"}
        $objects = @()
    }

    process {
        $objects += $InputObject
    }

    end {
        $objects | Group-Object -Property $Property -NoElement:(!$WithElement) | Select-Object $columns
        $columns | Format-Table | Out-String | Write-Verbose
    }
}
