[CmdletBinding()] 
param(
    [Parameter(Mandatory=$true)]
    [string]$TenantId,
    [Parameter(Mandatory=$true)]
    [string]$ServicePrincipal_ID,
    [Parameter(Mandatory=$true)]
    [string]$ServicePrincipal_Secret,
    [Parameter(Mandatory=$true)]
    [string]$KeyVaultName,
    [Parameter(Mandatory=$true)]
    [string]$KeyName,
    [Parameter(Mandatory=$true)]
    [string]$BashScriptPath
)

Import-Module -Name Az

$keyExists = Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyName -ErrorAction SilentlyContinue;

if($null -eq $keyExists) {

    if($Env:OS -like "*windows*" -or $IsWindows -eq $true) {
        Write-Host "Generating Root Cert for Windows";
        $certPath = "Cert:\CurrentUser\My";
        $rootCert = Get-ChildItem -Path $certPath | Where-Object { $_.Subject -eq "CN=VPN CA" };
        if($null -eq $rootCert) {
            $rootCert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
                    -Subject "CN=VPN CA" -KeyExportPolicy Exportable `
                    -HashAlgorithm sha256 -KeyLength 2048 `
                    -CertStoreLocation $certPath -KeyUsageProperty Sign -KeyUsage CertSign;
        }
        
        $rootCertPublicKey = $rootCert.GetPublicKeyString();
        Export-Certificate -Cert $rootCert.PSPath -FilePath C:\certs\rootCert.cer
        $rootCertPublicKey = $rootCert.GetRawCertDataString();
        $rootCertPublicKey = [Convert]::ToBase64String($rootCertPublicKey);
    }
    else {
        Write-Host "Generating Root Cert for Linux";
        Get-Location | Write-Host;
        bash -c "chmod 755 $BashScriptPath"
        $rootCertPublicKey = (bash -c "$BashScriptPath $TenantId $ServicePrincipal_ID $ServicePrincipal_Secret $KeyVaultName $KeyName")[0];
    }
    Write-Host $rootCertPublicKey;
    $secureString = ConvertTo-SecureString -String $rootCertPublicKey -AsPlainText -Force;
    Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $KeyName -SecretValue $secureString;
}