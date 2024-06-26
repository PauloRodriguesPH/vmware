﻿# Importar o módulo do PowerCLI
Import-Module VMware.PowerCLI

# Definir o servidor vCenter e credenciais
$vCenterServer = "vcenter.lab.local"
$vCenterUser = "paulo.rodrigues@vsphere.local"
$vcPassword = "P@ssw0rd"

# Conectar ao vCenter Server 
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vcPassword

# Caminho para o arquivo CSV
$csvPath = "U:\Scripts\lista.csv"

# Importar o arquivo CSV
$vms = Import-Csv -Path $csvPath

# Loop através de cada VM no CSV
foreach ($vm in $vms) {
    $vmName = $vm.VMName

    # Obter a VM
    $vmObject = Get-VM -Name $vmName

    # Obter as placas de rede da VM
    $networkAdapters = Get-NetworkAdapter -VM $vmObject

    # Exibir informações sobre a VM e suas placas de rede
    Write-Host "VM: $vmName"
    Write-Host "---------------------------"
    foreach ($adapter in $networkAdapters) {
        $adapterName = $adapter.Name
        $networkName = $adapter.NetworkName
        $adapterType = $adapter.Type
        $vlanId = (Get-VirtualPortGroup -VM $vmObject -Name $networkName).VlanId

        Write-Host "Adapter Name: $adapterName"
        Write-Host "Network Name: $networkName"
        Write-Host "Adapter Type: $adapterType"
        Write-Host "VLAN ID: $vlanId"
        Write-Host "---------------------------"
    }
    Write-Host "`n" # Adicionar uma linha em branco entre as VMs
}

# Desconectar do vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false