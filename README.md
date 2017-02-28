# blogscripts
![alt text](https://consolechars.files.wordpress.com/2015/07/cropped-zrzuty-ekranu2.jpg) "consolechars.wordpress.com LOGO")
# Nord Vpn importer (importnordvpn.sh)

Script for batch importing ovpn files fron NordVPN provider .
## Example
Get Configuration files from current dir.

```./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd"````
or

Get configuration form local direcotry "-d"

          
```./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/```
         
Get configuration from nordvpn.com
          
```./importnordvpn -u "myemail@exampl.com" -p "P44SSwoRd" -g```
            
if you want clean configuration
          
``` ./importnordvpn -c```
            
clean configuration (remove all vpn's from nmcli ). and load new
          
```./importnordvpn -c -u "myemail@exampl.com" -p "P44SSwoRd" -d Download/configs/```
       
##effect :
![alt tag](https://consolechars.files.wordpress.com/2017/02/nordvpn-gnome.gif)
