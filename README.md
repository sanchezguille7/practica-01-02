# practica-01-02

# Actualizamos todo con
sudo dnf up

# Descargamos GitHub
sudo dnf search git

sudo dnf install git

# y ponemos nuestro repo
git clone https://github.com/sanchezguille7/practica-01-02.git

# Descargamos apache 
sudo dnf install httpd -y

# lo iniciamos
sudo systemctl start httpd

# Y habilitar el servicio para que se inicie automáticamente después de cada reinicio.
sudo systemctl enable httpd
