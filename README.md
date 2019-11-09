# AtlaNode

## Installatie
Voor het runnen van de AtlaNET node zijn een paar programma's benodigd.
Installeer deze als volgt:
```
sudo apt-get -y install screen cmake python2.7 python-pip build-essential libusb-1.0 qt4-qmake libpulse-dev libx11-dev qt4-default
```

Rtl-sdr is de software die de radio ontvanger gaat besturen.
Compile en installeer deze als volgt:
```
mkdir -p ~/src/
cd ~/src/
git clone git://git.osmocom.org/rtl-sdr.git
cd rtl-sdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
```

Vervolgens moeten we zorgen dat RPI drivers niet gaan conflicteren.
Daarom gaan we deze drivers aan de RPI driver blacklist toevoegen:
```
sudo nano /etc/modprobe.d/raspi-blacklist.conf
```

Plaats daar in deze 3 lijnen:
```
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
```

Ook hebben we multimon nodig voor het decoden van de messages.
```
cd ~/src/
git clone https://github.com/EliasOenal/multimonNG.git
cd multimonNG
mkdir build
cd build
qmake ../multimon-ng.pro
make
sudo make install
```

Nu moeten we de benodigde pip packages installeren:
```
pip install -r requirements.txt
```

## Configureren
In principe is de software nu ready to go. We moeten alleen de instellingen nog even veranderen.
Copy config/config_default.json naar config/config.json.
Vul in de nieuwe config.json file de gegeven API key in.

## Uitvoeren
Nu kan AtlaNode uitgevoerd worden:
```
python monitor.pyc
```
