# Load .env variables
Get-Content ..\.env | Foreach-Object {
    if ($_ -match '^([^#=]+)=(.*)') {
        [Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
}

Write-Host "Starting Backup..."

# 1. Dump MongoDB
Write-Host "--> Dumping MongoDB..."
docker exec excalidraw-db mongodump `
  --username=$Env:DB_USER `
  --password=$Env:DB_PASS `
  --authenticationDatabase=admin `
  --out=/data/dump

# 2. Upload to Cloud
Write-Host "--> Uploading to Backblaze B2..."
restic backup ..\mongo-dumps --tag excalidraw

Write-Host "--> Done! Snapshot saved."
