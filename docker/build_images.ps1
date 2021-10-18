$ErrorActionPreference = "Stop"
docker build -f dockerfiles/wine.dockerfile  -t starcraft:wine   .
if (-not $?) {throw "Failed to build starcraft:wine image"}
docker build -f dockerfiles/bwapi.dockerfile -t starcraft:bwapi  .
if (-not $?) {throw "Failed to build starcraft:bwapi image"}
docker build -f dockerfiles/play.dockerfile  -t starcraft:play   .
if (-not $?) {throw "Failed to build starcraft:play image"}
docker build -f dockerfiles/java.dockerfile  -t starcraft:java   .
if (-not $?) {throw "Failed to build starcraft:java image. You can verify that you will build with proper version of Java in file dockerfiles/play.dockerfile"}

Push-Location ../scbw/local_docker
if (!(Test-Path starcraft.zip))
{
    Invoke-WebRequest 'http://files.theabyss.ru/sc/starcraft.zip' -OutFile starcraft.zip
}
if (-not (Get-FileHash starcraft.zip -Algorithm SHA256).Hash -eq (Get-Content starcraft.zip.sha256).Substring(0,64)) {throw "Wrong hash for starcraft.zip file."}

docker build -f game.dockerfile  -t "starcraft:game" .
if (-not $?) {throw "Failed to build starcraft:game image"}
Pop-Location
