$PlayerUpload = Read-Host "Please input the path to the player list text document"
[System.Collections.ArrayList]$Players = Get-Content $PlayerUpload
$i = $Players.Count
$Matchup = @()
$ExistingMatchups = @()
while ($i -gt 0) {
    if ($Matchup.Count -gt 1) {
        $Matchup = @()
    }
    $Random = Get-Random $i
    $Player = $Players[$Random]
    $Matchup += $Player
    $Players.Remove("$Player")
    $i --
    if ($Matchup.Count -eq 2) {
        Write-Host "$($Matchup[0]) vs $($Matchup[1])"
        $ExistingMatchups += $Matchup
    }
}