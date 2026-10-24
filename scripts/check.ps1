<#
.SYNOPSIS
    Runs flutter pub get, analyze and test in the shared package and in every
    lesson project, then prints a summary.

.DESCRIPTION
    PowerShell version of scripts/check.sh, for Windows PowerShell 5.1 and
    PowerShell 7 on any OS. Exits with code 1 if any project fails.

.PARAMETER Lessons
    Optional lesson numbers. Only lessons/<number>-* are checked, and the
    shared package is skipped.

.EXAMPLE
    ./scripts/check.ps1
    Checks packages/lesson_kit and every lesson.

.EXAMPLE
    ./scripts/check.ps1 07 34
    Checks only lessons/07-* and lessons/34-*.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts/check.ps1
    Runs the script when the execution policy blocks local scripts.
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $Lessons
)

Set-StrictMode -Version 2.0
# Native tools write progress to stderr; keep that from becoming a
# terminating error when it is redirected.
$ErrorActionPreference = 'Continue'

$root = Split-Path -Parent $PSScriptRoot

# On Windows this finds flutter.bat through PATHEXT.
$flutterCommand = Get-Command -Name flutter -CommandType Application -ErrorAction SilentlyContinue |
    Select-Object -First 1
if ($null -eq $flutterCommand) {
    Write-Error 'flutter was not found on PATH. Install the Flutter SDK and add its bin folder to PATH.'
    exit 1
}
$flutter = $flutterCommand.Source

function Invoke-Flutter {
    param(
        [Parameter(Mandatory = $true)] [string] $Directory,
        [Parameter(Mandatory = $true)] [string[]] $Arguments
    )
    Push-Location -LiteralPath $Directory
    try {
        # 2>&1 turns stderr lines into ErrorRecords; "$_" makes them text.
        $lines = @(& $flutter @Arguments 2>&1 | ForEach-Object { "$_" })
        $code = $LASTEXITCODE
    }
    finally {
        Pop-Location
    }
    [pscustomobject]@{
        ExitCode = $code
        Output   = $lines
    }
}

$failed = New-Object System.Collections.Generic.List[string]
$total = 0

# Projects as (display name, full path) pairs.
$projects = New-Object System.Collections.Generic.List[object]
$lessonsDir = Join-Path -Path $root -ChildPath 'lessons'
if ($null -eq $Lessons -or $Lessons.Count -eq 0) {
    $projects.Add([pscustomobject]@{
            Name = 'packages/lesson_kit'
            Path = Join-Path -Path (Join-Path -Path $root -ChildPath 'packages') -ChildPath 'lesson_kit'
        })
    $dirs = Get-ChildItem -LiteralPath $lessonsDir -Directory | Sort-Object -Property Name
    foreach ($dir in $dirs) {
        $projects.Add([pscustomobject]@{ Name = "lessons/$($dir.Name)"; Path = $dir.FullName })
    }
}
else {
    foreach ($number in $Lessons) {
        $dirs = @(Get-ChildItem -LiteralPath $lessonsDir -Directory |
                Where-Object { $_.Name -like "$number-*" } |
                Sort-Object -Property Name)
        if ($dirs.Count -eq 0) {
            Write-Warning "No lesson folder matches lessons/$number-*"
            $failed.Add("lessons/$number-* (no such lesson)")
        }
        foreach ($dir in $dirs) {
            $projects.Add([pscustomobject]@{ Name = "lessons/$($dir.Name)"; Path = $dir.FullName })
        }
    }
}


foreach ($project in $projects) {
    Write-Output "== $($project.Name)"

    $pubGet = Invoke-Flutter -Directory $project.Path -Arguments @('pub', 'get')
    if ($pubGet.ExitCode -ne 0) {
        $pubGet.Output | Write-Output
        $failed.Add("$($project.Name) (pub get)")
        continue
    }

    $analyze = Invoke-Flutter -Directory $project.Path -Arguments @('analyze', '--no-pub')
    if ($analyze.ExitCode -ne 0) {
        $analyze.Output | Write-Output
        $failed.Add("$($project.Name) (analyze)")
    }

    $test = Invoke-Flutter -Directory $project.Path -Arguments @('test', '--no-pub', '-r', 'expanded')
    if ($test.ExitCode -ne 0) {
        $test.Output | Select-Object -Last 30 | Write-Output
        $failed.Add("$($project.Name) (test)")
    }

    # The last progress line reads like "00:02 +11: All tests passed!".
    $count = $null
    foreach ($line in $test.Output) {
        if ($line -match '\+(\d+).*All tests passed') {
            $count = [int]$Matches[1]
        }
    }
    if ($null -eq $count) {
        Write-Output '   ? tests'
    }
    else {
        Write-Output "   $count tests"
        $total += $count
    }
}

Write-Output ''
Write-Output "$($projects.Count) projects, $total tests passed"
if ($failed.Count -gt 0) {
    Write-Output 'FAILED:'
    foreach ($item in $failed) {
        Write-Output "  $item"
    }
    exit 1
}
exit 0
