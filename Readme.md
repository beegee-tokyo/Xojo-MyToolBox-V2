# MyToolBox

A desktop tool to configure RAKwireless WisBlock LoRa / LoRaWAN devices over USB with AT commands.
It is written in [Xojo](https://www.xojo.com/).

MyToolBox works with devices running

- the [**WisBlockLoRaWAN**](https://github.com/beegee-tokyo/WisBlockLoRaWAN) library,
- **RUI3** firmware (RUI3 AT commands),
- the [**WisBlock API V2**](https://github.com/beegee-tokyo/WisBlock-API-V2) library.

## Features

- Lists the available serial (USB) ports and connects with 115200 baud, 8N1.
- Log window that shows everything sent to and received from the device, with a field to send your own AT commands.
- **Load Device Settings** reads the current settings from the device. The tab that matches the device's network mode is selected automatically.
- Three settings tabs:
  - **LoRaWAN**: region (including ISM2400), join mode (OTAA / ABP), credentials, datarate, ADR, TX power, confirmed mode, auto join and join retry. A QR code scan button can fill in the credentials.
  - **LoRa P2P**: frequency, bandwidth, spreading factor, coding rate, preamble length, TX power and sync word.
  - **FSK**: frequency, bit rate, frequency deviation, RX bandwidth, preamble length (bytes), TX power and sync word (hex).
- **Update LoRaWAN Credentials** sends only the credentials that belong to the selected join mode (OTAA: DevEUI, AppEUI, AppKey. ABP: AppSKey, NwkSKey, DevAddr).
- Send interval (`ATC+SENDINT`) and device status (`ATC+STATUS`) for firmware that provides these custom AT commands.
- **Save Settings** (`AT+SAVE`), **Device Restart** (`ATZ`) and **Boot Mode** (`AT+BOOT`, restarts into the bootloader for firmware upload).

LoRa P2P and FSK settings are sent to the device as soon as you change them. For text fields press **Enter**. LoRaWAN credentials are only sent with **Update LoRaWAN Credentials**.

Changes made with the WisBlockLoRaWAN library are lost at the next reset unless you press **Save Settings**. RUI3 and older versions of the WisBlockLoRaWAN library do not support `AT+SAVE`.

### Compatibility notes

- The FSK tab uses the AT commands of the WisBlockLoRaWAN library (`AT+NWM=2`, `AT+PBR`, `AT+PFDEV`, `AT+PBW`, `AT+SYNCWORD`, ...). Using it with other firmware has not been tested.
- ISM2400 and 2.4 GHz P2P frequencies need a device with a 2.4 GHz capable radio (LR2021).

## Installation

### Windows (tested)

1. Download `MyToolBox-Setup-2.x.x.exe` from the [`Installer`](installer) folder (use the highest version).
2. Run the installer and follow the steps.
3. If Windows SmartScreen warns about an unknown publisher, click **More info** and then **Run anyway**.
4. Connect your WisBlock device with a USB cable and start MyToolBox.

WisBlock Core modules with a USB port show up as a standard COM port. No extra driver is normally needed on current Windows versions.

### macOS (not tested)

There is no ready-made macOS build. You can build the application from source:

1. Install [Xojo](https://www.xojo.com/download/) (the project was saved with Xojo 2025r2.1, use that or a newer release) and make sure your Xojo license allows building for macOS.
2. Clone or download this repository.
3. Open `MyToolBox.xojo_xml_project` in Xojo.
4. Select **Build > Build Settings**, enable **macOS**, then choose **Build > Build** (or press **Run** to test directly from the IDE).
5. The first start of a build that is not signed may be blocked by Gatekeeper. Right-click the app, choose **Open**, then confirm.

Serial devices appear as `/dev/cu.usbmodem*`. No driver is needed for WisBlock Core modules.

### Linux (not tested)

There is no ready-made Linux build. You can build the application from source:

1. Install [Xojo](https://www.xojo.com/download/) for Linux (Xojo 2025r2.1 or newer) with a license that allows building for Linux. Xojo desktop apps need the GTK 3 libraries.
2. Clone or download this repository.
3. Open `MyToolBox.xojo_xml_project` in Xojo.
4. Select **Build > Build Settings**, enable **Linux**, then choose **Build > Build** (or press **Run**).
5. Give your user access to the serial port. On most distributions this means joining the `dialout` group, then logging out and in again:

   ```bash
   sudo usermod -aG dialout $USER
   ```

   On Arch based distributions the group is `uucp`.
6. If the port disappears or is busy right after plugging in the device, `ModemManager` may be probing it. Stop it with `sudo systemctl stop ModemManager` or add a udev rule to ignore the device.

## Quick start

1. Connect the WisBlock device with a USB cable.
2. Select the COM / serial port and click **Connect**.
3. Click **Load Device Settings**. The settings of the device are shown and the tab for its network mode (LoRaWAN, LoRa P2P or FSK) is selected.
4. Change the settings:
   - LoRaWAN: edit the values and click **Update LoRaWAN Credentials** to send the credentials.
   - LoRa P2P and FSK: change a value (press **Enter** in text fields) and it is sent immediately.
5. Click **Save Settings** to keep the settings over a reset (WisBlockLoRaWAN library only).

To change the network mode use the **Network Mode** list. After switching, click **Load Device Settings** to read the settings of the new mode.

## Troubleshooting

- **The port cannot be opened**: another program (Arduino IDE or PlatformIO serial monitor, a terminal) is using it. Close it and try again.
- **"The device does not response or returned wrong value"**: check that you selected the right port and that the device runs firmware with AT commands. Try to reset the device and reconnect.
- **No ports in the list**: use a USB data cable (not a charge-only cable) and check that the device is detected by your computer.

## Building from source

Open `MyToolBox.xojo_xml_project` in Xojo and run or build it as described above. The Windows installer in `installer` is created from a Windows build of this project.

## License

MyToolBox is released under the [MIT License](LICENSE).

RAKwireless, RAK and WisBlock are trademarks of RAKwireless Technology Limited. They are used here only to name the supported hardware.
