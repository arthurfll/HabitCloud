#!/usr/bin/env pwsh
<#
    Deploy script: commita e envia as mudancas para o GitHub (branch main),
    depois builda, tageia e envia a imagem Docker para o Docker Hub.
#>

$ErrorActionPreference = "Stop"

$DockerHubImage = "arthurfll/habit-cloud"
$DockerfilePath = "Core/Dockerfile"
$DockerContext  = "Core"
$GitBranch      = "main"

function Invoke-Step {
    param(
        [string]$Description,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==> $Description" -ForegroundColor Cyan
    & $Command
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Falha em: $Description" -ForegroundColor Red
        exit 1
    }
}

$Version = Read-Host "Versao do app (ex: 1.0.0)"
if ([string]::IsNullOrWhiteSpace($Version)) {
    Write-Host "Versao nao pode ser vazia." -ForegroundColor Red
    exit 1
}

$CommitMessage = Read-Host "Comentario do commit"
if ([string]::IsNullOrWhiteSpace($CommitMessage)) {
    Write-Host "Comentario nao pode ser vazio." -ForegroundColor Red
    exit 1
}

$FullTag   = "${DockerHubImage}:${Version}"
$LatestTag = "${DockerHubImage}:latest"

Invoke-Step "Adicionando alteracoes ao git" { git add -A }

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Nenhuma alteracao para commitar, seguindo para o build da imagem." -ForegroundColor Yellow
} else {
    Invoke-Step "Commitando alteracoes" { git commit -m "$CommitMessage" }
}

Invoke-Step "Enviando para o GitHub (branch $GitBranch)" { git push origin $GitBranch }

Invoke-Step "Buildando a imagem Docker ($FullTag)" {
    docker build -t $FullTag -t $LatestTag -f $DockerfilePath $DockerContext
}

Invoke-Step "Enviando $FullTag para o Docker Hub" { docker push $FullTag }
Invoke-Step "Enviando $LatestTag para o Docker Hub" { docker push $LatestTag }

Write-Host ""
Write-Host "Deploy concluido: $FullTag" -ForegroundColor Green
