#!/bin/bash

# --- ASCII Header ---
show_header() {
    echo "  _                     _       _            "
    echo " | |__   __ _ _ __   __| |_ __ | | __ _ _ __ "
    echo " | '_ \ / _' | '_ \ / _' | '_ \| |/ _' | '_ \\"
    echo " | |_) | (_| | | | | (_| | |_) | | (_| | | | |"
    echo " |_.__/ \__,_|_| |_|\__,_| .__/|_|\__,_|_| |_|"
    echo "                         |_|                 "
    echo "----------------------------------------------"
}

# --- Quick Reference Displays ---
print_hf() {
    echo "160m | 1.800  - 2.000  MHz | [CW/DATA/PHON]"
    echo "80m  | 3.500  - 4.000  MHz | [CW/DATA/PHON]"
    echo "60m  | 5.332  - 5.405  MHz | [USB CHANNELS]"
    echo "40m  | 7.000  - 7.300  MHz | [CW/DATA/PHON]"
    echo "30m  | 10.100 - 10.150 MHz | [CW/DATA ONLY]"
    echo "20m  | 14.000 - 14.350 MHz | [CW/DATA/PHON]"
    echo "17m  | 18.068 - 18.168 MHz | [CW/DATA/PHON]"
    echo "15m  | 21.000 - 21.450 MHz | [CW/DATA/PHON]"
    echo "12m  | 24.890 - 24.990 MHz | [CW/DATA/PHON]"
    echo "10m  | 28.000 - 29.700 MHz | [CW/DATA/PHON/FM]"
}

print_vhf_uhf() {
    echo "6m   | 50.0   - 54.0   MHz | [CW/DATA/PHON/FM]"
    echo "2m   | 144.0  - 148.0  MHz | [CW/DATA/PHON/FM]"
    echo "220  | 222.0  - 225.0  MHz | [CW/DATA/PHON/FM]"
    echo "70cm | 420.0  - 450.0  MHz | [CW/DATA/PHON/FM]"
}

# --- Frequency Lookup Engine ---
lookup_freq() {
    local f=$1
    echo "--- Frequency Analysis: $f MHz ---"

    # 160 Meters
    if (( $(echo "$f >= 1.8 && $f <= 2.0" | bc -l) )); then
        echo "BAND: 160m | HAM: YES | MODE: CW/Data/Phone | PRIV: General/Extra"
    
    # 80 Meters
    elif (( $(echo "$f >= 3.5 && $f <= 4.0" | bc -l) )); then
        echo "BAND: 80m | HAM: YES"
        if (( $(echo "$f >= 3.525 && $f <= 3.600" | bc -l) )); then
            echo "MODE: CW | PRIV: Tech/General/Extra (Tech CW only)"
        else
            echo "MODE: CW/Data/Phone | PRIV: General/Extra"
        fi

    # 40 Meters
    elif (( $(echo "$f >= 7.0 && $f <= 7.3" | bc -l) )); then
        echo "BAND: 40m | HAM: YES"
        if (( $(echo "$f >= 7.025 && $f <= 7.125" | bc -l) )); then
            echo "MODE: CW | PRIV: Tech/General/Extra (Tech CW only)"
        else
            echo "MODE: CW/Data/Phone | PRIV: General/Extra"
        fi

    # 20 Meters
    elif (( $(echo "$f >= 14.0 && $f <= 14.35" | bc -l) )); then
        echo "BAND: 20m | HAM: YES | MODE: CW/Data/Phone | PRIV: General/Extra"

    # 15 Meters
    elif (( $(echo "$f >= 21.0 && $f <= 21.45" | bc -l) )); then
        echo "BAND: 15m | HAM: YES"
        if (( $(echo "$f >= 21.025 && $f <= 21.200" | bc -l) )); then
            echo "MODE: CW | PRIV: Tech/General/Extra (Tech CW only)"
        else
            echo "MODE: CW/Data/Phone | PRIV: General/Extra"
        fi

    # 10 Meters
    elif (( $(echo "$f >= 28.0 && $f <= 29.7" | bc -l) )); then
        echo "BAND: 10m | HAM: YES"
        if (( $(echo "$f >= 28.0 && $f <= 28.3" | bc -l) )); then
            echo "MODE: CW/Data | PRIV: Tech/General/Extra"
        elif (( $(echo "$f >= 28.3 && $f <= 28.5" | bc -l) )); then
            echo "MODE: Phone (SSB) | PRIV: Tech/General/Extra"
        else
            echo "MODE: Phone/FM | PRIV: General/Extra"
        fi

    # 6 Meters
    elif (( $(echo "$f >= 50.0 && $f <= 54.0" | bc -l) )); then
        echo "BAND: 6m | HAM: YES | MODE: All Modes | PRIV: Tech/General/Extra"

    # 2 Meters
    elif (( $(echo "$f >= 144.0 && $f <= 148.0" | bc -l) )); then
        echo "BAND: 2m | HAM: YES"
        if (( $(echo "$f < 144.1" | bc -l) )); then
            echo "MODE: CW Only | PRIV: Tech/General/Extra"
        else
            echo "MODE: All Modes | PRIV: Tech/General/Extra"
        fi

    # 220 Band (1.25 Meters)
    elif (( $(echo "$f >= 222.0 && $f <= 225.0" | bc -l) )); then
        echo "BAND: 222MHz | HAM: YES | MODE: All Modes | PRIV: Tech/General/Extra"

    # 70cm (440)
    elif (( $(echo "$f >= 420.0 && $f <= 450.0" | bc -l) )); then
        echo "BAND: 70cm | HAM: YES | MODE: All Modes | PRIV: Tech/General/Extra"

    # 33cm / 23cm
    elif (( $(echo "$f >= 902.0 && $f <= 928.0" | bc -l) )); then
        echo "BAND: 33cm | HAM: YES | MODE: All Modes | PRIV: Tech/General/Extra"
    elif (( $(echo "$f >= 1240.0 && $f <= 1300.0" | bc -l) )); then
        echo "BAND: 23cm | HAM: YES | MODE: All Modes | PRIV: Tech/General/Extra"

    else
        echo "HAM: NO | This frequency is outside common US Amateur allocations."
    fi
}

# --- Main Argument Parsing ---
if [[ $# -eq 0 ]]; then set -- "-a"; fi

case "$1" in
    -h|--help)
        show_header
        echo "Usage: bandplan [option]"
        echo "  -160, -80, -40, -20, -15, -10 : Show specific HF band"
        echo "  -a                            : Show all (160m to 70cm)"
        echo "  --hf                          : Show HF only (160m to 10m)"
        echo "  -v                            : Show VHF (2m and 220)"
        echo "  -u | -70                      : Show UHF (70cm/440)"
        echo "  -g                            : Show SHF (23cm and 33cm)"
        echo "  -60                           : Show 60m Channels"
        echo "  -f [freq]                     : Lookup freq in MHz (e.g. 144.2)"
        ;;
    -a) show_header; print_hf; print_vhf_uhf ;;
    --hf) show_header; print_hf ;;
    -v) show_header; echo "2m: 144-148 MHz"; echo "220: 222-225 MHz" ;;
    -u|-70) show_header; echo "70cm: 420-450 MHz" ;;
    -g) show_header; echo "33cm: 902-928 MHz"; echo "23cm: 1240-1300 MHz" ;;
    -60) show_header; echo "60m USB Channels: 5332, 5348, 5358.5, 5373, 5405 kHz" ;;
    -160) echo "160m: 1.800 - 2.000 MHz" ;;
    -80)  echo "80m: 3.500 - 4.000 MHz" ;;
    -40)  echo "40m: 7.000 - 7.300 MHz" ;;
    -20)  echo "20m: 14.000 - 14.350 MHz" ;;
    -15)  echo "15m: 21.000 - 21.450 MHz" ;;
    -10)  echo "10m: 28.000 - 29.700 MHz" ;;
    -220) echo "220: 222.0 - 225.0 MHz" ;;
    -f) shift; lookup_freq $1 ;;
    *) echo "Unknown option. Use -h for help." ;;
esac
