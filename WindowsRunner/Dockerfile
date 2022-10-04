# Powershell script wrapper to deal with dockerd not
# waiting for gracefull stop
FROM mcr.microsoft.com/dotnet/sdk:6.0 as wrapper-build
WORKDIR /app

COPY ScriptWrapper/*.csproj .
RUN dotnet restore

COPY ScriptWrapper/* ./
RUN dotnet publish -c Release -o out --no-restore


# Main Image
FROM mcr.microsoft.com/windows/server:ltsc2022

ARG RUNNER_VERSION

LABEL Author="Manuel Roat"
LABEL Email="roat.manuel@gmail.com"
LABEL GitHub="https://github.com/redek91"
LABEL BaseImage="mcr.microsoft.com/windows/server:ltsc2022"
LABEL RunnerVersion=${RUNNER_VERSION}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
WORKDIR /actions-runner

#Install chocolatey
ADD scripts/Install-Choco.ps1 .
RUN .\Install-Choco.ps1 -Wait; \
  Remove-Item .\Install-Choco.ps1 -Force

#Install Dependencies
RUN choco install -y \
  git \
  gh

# Download Github runner
RUN Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v$env:RUNNER_VERSION/actions-runner-win-x64-$env:RUNNER_VERSION.zip -OutFile actions-runner.zip; \
  Expand-Archive -Path ".\\actions-runner.zip" -DestinationPath '.'; \
  Remove-Item ".\\actions-runner.zip" -Force


#USER ContainerAdministrator
#RUN reg add hklm\system\currentcontrolset\services\cexecsvc /v ProcessShutdownTimeoutSeconds /t REG_DWORD /d 60
#RUN reg add hklm\system\currentcontrolset\control /v WaitToKillServiceTimeout /t REG_SZ /d 60000 /f

COPY --from=wrapper-build /app/out .
ADD scripts/start.ps1 .
ADD scripts/stop.ps1 .

ENTRYPOINT [ "ScriptWrapper.exe"]