if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}

$Path = ".\\Bin\\Ethash-Phoenix\\PhoenixMiner.exe"
$Uri = "http://nemos.dx.am/opt/nemos/PhoenixMiner_3.0c.7z"
$Commands = [PSCustomObject]@{
    "ethash" = " -di $($($Config.SelGPUCC).Replace(',',''))" #Ethash(fastest)
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-esm 3 -allpools 1 -allcoins 1 -platform 2 -mport -$($Variables.NVIDIAMinerAPITCPPort) -epool $($Pools.Ethash.Host):$($Pools.Ethash.Port) -ewal $($Pools.Ethash.User) -epsw $($Pools.Ethash.Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week * .9935} # substract 0.65% devfee
        API = "Wrapper"
        Port = $Variables.NVIDIAMinerAPITCPPort #3333
        Wrap = $true
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
        Host = $Pools.(Get-Algorithm $_).Host
        Coin = $Pools.(Get-Algorithm $_).Coin
    }
}
