# 📡 bandplan-cli

A lightweight Bash utility for Amateur Radio operators to quickly reference frequency allocations, sub-band modes, and licensing privileges (US FCC) directly from the Linux terminal.

Perfect for headless Raspberry Pi setups, field operations, and quick CLI lookups without needing a web connection.

## 🛠 Features
- **ASCII Art Interface**: Clean, high-contrast display for field use.
- **Specific Band Flags**: Access 160m through 23cm using common wavelength nomenclature (e.g., `-40`, `-10`, `-70`).
- **Smart Frequency Lookup**: Use `-f [freq]` to check if a frequency is in-band and what privileges (Tech, General, Extra) apply.
- **Tech Privilege Tracking**: Specifically identifies Technician CW and SSB segments on HF.
- **60m Support**: Lists center frequencies for all 5 USB channels.

## 📥 Installation

1. **Clone or copy the script** to your local machine.
2. **Ensure `bc` is installed** (required for frequency math):
   ```bash
   sudo apt update && sudo apt install bc -y
