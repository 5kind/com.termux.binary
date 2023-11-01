<h1 align="center">Termux Binary Files Modules</h1>

<div align="center">
  <!-- Current Termux -->
    <img src="https://img.shields.io/badge/Termux-0.118.0-blue.svg?longCache=true&style=flat-square"
      alt="_time_stamp_" />
  <!-- Min Magisk -->
    <img src="https://img.shields.io/badge/MinMagisk-20.4-red.svg?longCache=true&style=flat-square"
      alt="_time_stamp_" />
  <!-- Min KSU -->
    <img src="https://img.shields.io/badge/MinKernelSU-0.6.6-red.svg?longCache=true&style=flat-square"
      alt="_time_stamp_" /></div>

<div align="center">
  <h3>
    <a href="https://github.com/termux/termux-app">
      Source Code
    </a>
    <span>
  </h3>
</div>

### Usage
- install `git zip apt-file` in termux app (`apt install git zip apt-file`)
- `apt-file update`
- `git clone https://github.com/5kind/com.termux.binary`
- `cd com.termux.binary`
- run [./update-binary.sh](./update-binary.sh) `<pkgname>` (such as bash)
- `zip -r install.zip *`
- install module install.zip in Magisk/KernelSU (`su -c magisk --install-module install.zip`)
