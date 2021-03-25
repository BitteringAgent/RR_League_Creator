$Teams = Read-Host "Enter the path of your Teams/Players text document"
[System.Collections.ArrayList]$Players = Get-Content $Teams
$PossibleSeasonMatchups = $Players.Count - 1
$ExistingSeasonMatchups = @()
while ($PossibleSeasonMatchups -gt 0) {
 
    $i = $Players.Count

    $Matchup = @()
    $WeeklyMatchup = @()

    while ($i -gt 0) {
        if($MatchupErrorCatch -eq 30){
            $i = 0
            Continue
        }
        if ($Matchup.Count -gt 2) {
            $Matchup = @()
        }
        $Random = Get-Random $i
        $Player = $Players[$Random]
        $Matchup += $Player

        if ($Matchup.Count -eq 2) {
            $MatchupPlayers = Compare-Object -ReferenceObject $Matchup[0] -DifferenceObject $Matchup[1] -ExcludeDifferent -IncludeEqual
            
            $CompareMatchup = "$($Matchup[0]) $($Matchup[1])"
            $MatchupAlreadyExists = Compare-Object -ReferenceObject $CompareMatchup -DifferenceObject $ExistingSeasonMatchups -IncludeEqual -ExcludeDifferent 
            
            $CompareAltMatchup = "$($Matchup[1]) $($Matchup[0])"
            $AltMatchupAlreadyExists = Compare-Object -ReferenceObject $CompareAltMatchup -DifferenceObject $ExistingSeasonMatchups -IncludeEqual -ExcludeDifferent 

           # Write-Host "Matchup"
           # $MatchupPlayers
           # Write-Host "Compare Matchup"
           # $CompareMatchup
           # Write-Host "Compare Alt Matchup
           # $CompareAltMatchup"

            if ($MatchupPlayers.InputObject -gt 0) {
                
                #Test
                #Write-Host "$Matchup These Players Are The Same"
                
                $Matchup = @()
                $MatchupPlayers = $null
                
                $MatchupErrorCatch ++
                Continue
            }
            
            if ($MatchupAlreadyExists.InputObject -gt 0) {
                
                #Test
                #Write-Host "$Matchup Already Exists" -ForegroundColor Red
                
                $Matchup = @()
                $MatchupAlreadyExists = $null
                
                #Catch a never ending loop
                $MatchupErrorCatch ++
                
                Continue
            }
            if ($AltMatchupAlreadyExists.InputObject -gt 0) {
                
                #Test
                #Write-Host "$Matchup Alt Matchup Already Exists" -ForegroundColor Red

                $Matchup = @()
                $AltMatchupAlreadyExists = $null
                
                #Catch a never ending loop
                $MatchupErrorCatch ++
                
                Continue
            }
            Else {

                $WeeklyMatchup += "$Matchup"

                $MatchupErrorCatch = $null
                $Players.Remove("$($Matchup[0])")
                $Players.Remove("$($Matchup[1])")
                $i --
                $i --
                #Write-Host "Existing Players $Players"
               
            }
        } 
    }
    if($MatchupErrorCatch -gt 29){
        Write-Host "RESTART WEEK" -ForegroundColor Red
        $MatchupErrorCatch = $null
        [System.Collections.ArrayList]$Players = Get-Content $Teams
        Continue
    }
    Write-Host "Week $PossibleSeasonMatchups Matchups" -ForegroundColor Red
    $WeeklyMatchup
    $MatchupErrorCatch = $null
    $ExistingSeasonMatchups += $WeeklyMatchup
    $WeeklyMatchup = $null
    [System.Collections.ArrayList]$Players = Get-Content $Teams
    $PossibleSeasonMatchups --
    
}
