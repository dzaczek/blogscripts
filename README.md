# blogscripts

# Nord Vpn importer 

Script for batch importing ovpn files fron NordVPN provider .
## Example
:
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd"
          or
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/
          Get configuration from nordvpn.com
            ./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -d
          if you want clean configuration
             ./importnordvpn -c
          clean configuration (remove all vpn's from nmcli ). and load new
            ./importnordvpn -c -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/
       
##effect :
![alt tag](https://consolechars.files.wordpress.com/2017/02/nordvpn-gnome.gif)
