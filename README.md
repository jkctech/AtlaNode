# AtlaNode

## Benodigdheden (Hardware)
Om een AtlaNode te kunnen installeren zijn er 2 hardware benodigdheden:

- Een Linux capable computer met minimaal 1 vrije USB poort. (Bijvoorbeeld een Raspberry Pi)
- Een USB SDR ontvanger.

De SDR ([Software Defined Radio](https://nl.wikipedia.org/wiki/Software-defined_radio)) ontvanger is het hart van dit project.
Deze kunnen we instellen om radioberichten van P2000 te onderscheppen.
Zo'n ontvanger (DVB-T RTL2832U + R820T2) is vrij goedkoop (+- 10 euro) te vinden op AliExpress.
Hier een [linkje naar zo'n ontvanger](https://nl.aliexpress.com/item/32813234033.html).

![AtlaNode](https://112centraal.nl/images/examples/atlanode_car.jpg "AtlaNode")

## Installatie
Voor het runnen van de AtlaNET node zijn een paar programma's benodigd.
Installeer deze als volgt:
```
sudo apt-get -y install git screen python2.7 python-pip libusb-1.0 cmake build-essential qt4-qmake qt4-default libpulse-dev libx11-dev
```

De programma's die we installeren en waarom we dat doen:
- git | Om repositories te kunnen clonen
- screen | Om AtlaNode te kunnen laten runnen zonder een actieve terminal
- python2.7 | AtlaNode draait (nog) niet op Python 3 en daarom gebruiken we voor nu 2.7
- python-pip | Package manager voor bepaalde libraries
- libusb-1.0 | Drivers voor de SDR ontvanger
- cmake | Compiler
- build-essential | Compiler
- qt4-qmake | Compiler
- qt4-default | FVramework voor compiler
- libpulse-dev | Library
- libx11-dev | Library

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

Run je geen Raspberry Pi? Edit dan deze file:
```
sudo nano /etc/modprobe.d/blacklist.conf
```

Plaats in je blacklist deze 3 lijnen:
```
blacklist dvb_usb_rtl28xxu
blacklist rtl2832
blacklist rtl2830
```

Tijd voor een reboot om de boel door te voeren en correct in te laden.
```
sudo reboot now
```

Nu kunnen we testen of de ontvanger gedetecteerd wordt en of de rechten goed zijn ingesteld.
```
rtl_test
```

We verwachten deze output:
```
Found 1 device(s):
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

Je kunt de SDR ontvanger nu ook testen om te kijken of meldingen correct ontvangen worden.
```
rtl_fm -f 169.65M -M fm -s 22050 | multimon-ng -q -a FLEX -t raw /dev/stdin
```
Als het goed is zullen er na een paar seconden / minuten vanzelf meldingen in beeld komen.

Werkt de ontvanger? Top! Tijd om de AtlaNode repo te clonen:
```
cd ~
git clone https://github.com/jkctech/AtlaNode
```

Move nu naar de AtlaNode software repo en installeer de benodigde pip dependencies:
```
cd AtlaNode
pip install -r requirements.txt
```

## Configureren
In principe is de software nu ready to go. We moeten alleen de instellingen nog even veranderen.

Copy config/config_default.json naar config/config.json.
```
cp config/config_default.json config/config.json
```
Vul in de nieuwe config.json file de gegeven API key in.


Mocht je meerdere SDR ontvangers op 1 node hebben draaien, kun je in de config file onder "command" je device index aangeven:

"command": "rtl_fm -f 169.65M -M fm -s 22050 **-d X** | multimon-ng -q -a FLEX -t raw /dev/stdin"

Hierbij staat X voor je device index.

Zorg dat het run script uitvoerbaar is.
```
chmod +x run.sh
```

## Uitvoeren
Start een screen
```
screen -S monitor
```

Wanneer we ons binnen de screen bevinden, kunnen we op de normale manier de monitor starten.
```
chmod +x run.sh
./run.sh
```

Om de screen te verlaten drukken we op (CTRL + a) (CTRL + d).
Ctrl + a zal ons in de "command mode" zetten.
Ctrl + d is de command voor "detach".

Om later weer met je screen te kunnen connecten kun je reattach uitvoeren in je terminal:
```
screen -r
```

## Tracking
Nu kan er op de global map gezien worden dat je node is opgestart: [Node map](https://112centraal.nl/radiolocaties/)