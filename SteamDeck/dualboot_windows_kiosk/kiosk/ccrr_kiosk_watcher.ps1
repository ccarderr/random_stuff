# Importowanie biblioteki do wyświetlania okienka dialogowego
Add-Type -AssemblyName System.Windows.Forms

# Funkcja do wyświetlania okienka dialogowego
function Show-MessageBox {
    param (
        [string]$message,
        [string]$title
    )

    # Tworzymy nowe okno dialogowe
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $title
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.Size = New-Object System.Drawing.Size(500, 200)  # Ustawiamy rozmiar okna na 500x200
    $form.TopMost = $true  # Ustawiamy okno na zawsze na wierzchu

    # Tworzymy etykietę z tekstem
    $label = New-Object System.Windows.Forms.Label
    $label.Text = $message
    $label.Size = New-Object System.Drawing.Size(470, 80)  # Zmniejszamy wysokość etykiety o 100px
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Font = New-Object System.Drawing.Font("Arial", 14)  # Zwiększamy czcionkę
    $form.Controls.Add($label)

    # Tworzymy przycisk "Yes"
    $buttonYes = New-Object System.Windows.Forms.Button
    $buttonYes.Text = "Yes"
    $buttonYes.Size = New-Object System.Drawing.Size(160, 60)  # Zwiększamy rozmiar przycisku
    $buttonYes.Location = New-Object System.Drawing.Point(70, 90)  # Wycentrowanie pierwszego przycisku
    $buttonYes.Font = New-Object System.Drawing.Font("Arial", 14)  # Zwiększamy czcionkę przycisku
    $buttonYes.DialogResult = [System.Windows.Forms.DialogResult]::Yes
    $form.Controls.Add($buttonYes)

    # Tworzymy przycisk "No"
    $buttonNo = New-Object System.Windows.Forms.Button
    $buttonNo.Text = "No"
    $buttonNo.Size = New-Object System.Drawing.Size(160, 60)  # Zwiększamy rozmiar przycisku
    $buttonNo.Location = New-Object System.Drawing.Point(270, 90)  # Wycentrowanie drugiego przycisku
    $buttonNo.Font = New-Object System.Drawing.Font("Arial", 14)  # Zwiększamy czcionkę przycisku
    $buttonNo.DialogResult = [System.Windows.Forms.DialogResult]::No
    $form.Controls.Add($buttonNo)

    # Ustawiamy przyciski jako wyniki
    $form.AcceptButton = $buttonYes
    $form.CancelButton = $buttonNo

    # Pokaż okno
    $form.ShowDialog()

    return $form.DialogResult
}

# Funkcja do uruchamiania Steam z argumentami: -noverifyfiles -silent
function Start-SteamDesktop {
    Write-Host "Running Steam..."  # Log Steam launch
    Start-Process "C:\Program Files (x86)\Steam\Steam.exe" -ArgumentList "-noverifyfiles -silent"
    Write-Host "Steam launched with -noverifyfiles and -silent. Exiting script..."  # Log Steam launch and exit
    exit
}

function Start-SteamGame {
    # Create the arguments list
    $arguments = "-noverifyfiles"

    # Add -tenfoot argument if $arg_nobigpicture is false
    if (-not $arg_nobigpicture) {
        $arguments = "$arguments -tenfoot"
    }

    # Add steam://rungameid at the end
    $arguments = "$arguments steam://rungameid/$arg_appid"

    # Start Steam with the appropriate arguments
    $steamProcess = Start-Process "C:\Program Files (x86)\Steam\Steam.exe" -ArgumentList $arguments

    # If script restarted
    if ($scriptRestarted) {
        Write-Host "Restarting game with ID: $arg_appid..."
    } else {
        $modeMessage = if ($arg_nobigpicture) {
            'Forced desktop mode.'
        } else {
            'Forced Big Picture mode.'
        }
        Write-Host "Starting Steam and game with ID: $arg_appid. $modeMessage"
    }
}




function Restart-Script {
    Write-Host "Restarting the script to relaunch the game..."  # Log the restart
    
    # Get the script path and the arguments passed to the script
    $scriptPath = $PSCommandPath  # Path to the script (this should be more reliable)
    $arguments = $args  # Arguments passed to the script

    # Check if the -restart argument is present
    if ($arguments -notcontains "-restart") {
        $arguments += "-restart"  # Add the -restart argument if it's missing
    }

    # If debug mode is enabled, add the -debug argument if it's missing
    if ($debugMode -and $arguments -notcontains "-debug") {
        $arguments += "-debug"
    }

    # Ensure that $scriptPath is a valid string and then restart the script with the updated arguments
    if ($scriptPath) {
        # Ensure arguments are passed correctly as an array
        & "$scriptPath" @arguments
    } else {
        Write-Host "Error: Unable to retrieve the script path."  # Log error if script path is invalid
    }

    exit
}

function Restart-System {
    # Jeśli żadne z warunków nie jest spełniony, restartujemy system
    if (-not ($debugMode -eq $true -or $arg_noreturn -eq $true)) {
        Restart-Computer -Force
    } else {
        if ($debugMode -eq $true) {
            Write-Host "System restart skipped: debug mode."  # Log for debugMode
        }
        if ($arg_noreturn -eq $true) {
            Write-Host "System restart skipped: -noreturn argument."  # Log for noreturn argument
        }
    }
}



# Funkcja sprawdzająca, czy proces z argumentem '-ccrr_kiosk_game' istnieje
function Is-GameProcessRunning {
    # Sprawdzanie, czy proces z określonym argumentem istnieje
    $process = Get-WmiObject Win32_Process | Where-Object { $_.CommandLine -match $trackingArgument }
    return $process
}







# Zmienne
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$debugMode = $false
$scriptRestarted = $false
$waitTimeout = 30
$trackingArgument = "-ccrr_kiosk"
$arg_appid = "desktop"        # AppID to launch
$arg_bigpicture = $false      # For desktop mode
$arg_nobigpicture = $false    # For game mode
$arg_killexplorer = $false    # Kill explorer
$arg_noreturn = $false        # Don't return to SteamOS

Write-Host " "
Write-Host "==================="
Write-Host "CCRR Kiosk Launcher"
Write-Host "==================="
Write-Host " "

# Sprawdzamy, czy skrypt został wywołany z argumentem -debug
if ($args -contains '-debug') {
    $debugMode = $true
    Write-Host "Debug mode enabled. System will not be restarted."  # Log debug mode enabled
}
# Sprawdzamy, czy skrypt został wywołany z argumentem -restart
if ($args -contains '-restart') {
    $scriptRestarted = $true
    Write-Host "Script was restarted. Wait timeout will be reduced."  # Log script restart
}

# Reduce wait timeout if script was restarted
if ($scriptRestarted) {
    $waitTimeout = 10
}


# Log script directory
Write-Host "Script is located in: $scriptDir"  # Log directory path






Write-Host " "





# Check if the "ccrr_kiosk_args.txt" file exists
Write-Host "Checking arguments passed by SteamOS..."  
$filePath = Join-Path -Path $scriptDir -ChildPath "ccrr_kiosk_arg.txt"

# Sprawdzenie, czy plik istnieje
# Sprawdzenie, czy plik istnieje
if (Test-Path $filePath) {
    Write-Host "Arguments file found. Loading content..."  # Log file existence
    
    # Wczytanie zawartości pliku
    $fileContent = (Get-Content $filePath) -join ' '
    Write-Host "File content loaded: $fileContent"  # Log the content of the file

    # Dopasowanie i przypisanie wartości
    if ($fileContent -match "-appid (\S+)") {
        $arg_appid = $matches[1]
        Write-Host "Argument found: -appid $arg_appid"  # Log found AppID
    }

    if ($fileContent -match "-nobigpicture") {
        $arg_nobigpicture = $true
        Write-Host "Argument found: -nobigpicture"  # Log found -nobigpicture
    }

    if ($fileContent -match "-bigpicture") {
        $arg_bigpicture = $true
        Write-Host "Argument found: -bigpicture"  # Log found -bigpicture
    }

    if ($fileContent -match "-noreturn") {
        $arg_noreturn = $true
        Write-Host "Argument found: -noreturn"  # Log found -noreturn
    }

    if ($fileContent -match "-killexplorer") {
        $arg_killexplorer = $true
        Write-Host "Argument found: -killexplorer"  # Log found -killexplorer
    }

} else {
    Write-Host "Arguments file not found: $filePath, continuing with default values..."  # Log if file does not exist
}



# Jeśli $arg_appid to "desktop", uruchamiamy Steam, zamykamy skrypt
if ($arg_appid -eq "desktop") {
    Write-Host " "
    Write-Host "Argument -appid not specified, running Steam in desktop mode..."  # Log that the condition matches
    Start-SteamDesktop  # Call the function to run Steam
    exit
}






Write-Host " "
Write-Host "Script is looking for processes launched with argument '$trackingArgument'..."
Write-Host "Waiting for process to start..."

# Pierwsza pętla: Multiple tries to launch the game 
$counter_waitforstart = 0
do {

    # If count is exual to $waitTimeout, show dialog that game is refusing to launch
    if ($counter_waitforstart -ge $waitTimeout) {
        Write-Host " "
        Write-Host "Timeout: Game is not detected within $waitTimeout seconds, asking user for next action."
        # Ask the user if they want to restart the game
        $response = Show-MessageBox "Game is not detected, add following argument to game launch options: $trackingArgument`nDo you want to try start the game again?" "..."

        # 4 is the result for "Yes", 7 for "No"
        if ($response -eq 6) {  # Yes

            Write-Host "User selected Yes. Restarting script..."  # Log exit
            Write-Host " "
            Restart-Script  # Call the function to restart the script
        } elseif ($response -eq 7) {  # No
            Write-Host "User selected No. Returning to SteamOS..."  # Log exit
            Restart-System  # Call the function to restart the system
            exit
        } else {
            Write-Host "Invalid input. Exiting script..."  # Log invalid input
            exit
        }
        break
    }

    # Break from the loop if the process is running    
    $process = Is-GameProcessRunning
    if ($process) {
        break  # Zakończymy pierwszą pętlę, gdy proces się pojawi
    }

    # On count 0, try to launch the game
    if ($counter_waitforstart -eq 0) {
        Start-SteamGame  # Call the function to run Steam
    }

    # (if $scriptRestarted is true) When count is divisible by 5, try to launch the game
    if ($scriptRestarted -and $counter_waitforstart % 5 -eq 0) {
        Start-SteamGame  # Call the function to run Steam
    }

    # Wait a moment before checking again
    Start-Sleep -Seconds 1
    $counter_waitforstart += 1

} while ($true)  # Infinite loop until the process appears



Write-Host "Process found, assuming game has started. Wait time: $counter_waitforstart seconds."

# Log o czekaniu przed drugą pętlą
Write-Host "Waiting for process to stop..."  # Log przed drugą pętlą

# Druga pętla: Czekamy, aż proces z argumentem przestanie działać
do {
    $process = Is-GameProcessRunning

    if ($process) { } else {
        Write-Host "No process with argument '$trackingArgument' found. Assuming game has closed."  # Log that the game has closed
        break  # Zakończymy drugą pętlę, gdy proces przestanie działać
    }

    # Wait a moment before checking again
    Start-Sleep -Seconds 1

} while ($true)  # Infinite loop until the process stops





Write-Host " "
Write-Host "Asking user for next action..."

# Ask the user if they want to restart the game
$response = Show-MessageBox "The game has been closed.`nDo you want to restart the game?" "Game Over"

# 4 is the result for "Yes", 7 for "No"
if ($response -eq 6) {  # Yes

    Write-Host "User selected Yes. Restarting script..."  # Log exit
    Restart-Script  # Call the function to restart the script
} elseif ($response -eq 7) {  # No
    Write-Host "User selected No. Returning to SteamOS..."  # Log exit
    Restart-System  # Call the function to restart the system
    exit
} else {
    Write-Host "Invalid input. Exiting script..."  # Log invalid input
    exit
}
