
**Quick guide to install Multiple RepMe Masternodes on a Ubuntu 16.04 VPS**

This is my first activity on GitHub ever, so.... ;-). I'm running my VPS at Contabo (good specs for good pricing), but installed the RepMe masternodes manually. I have tested this on a Vultr VPS and it seemed to work. If you install mutliple nodes on a VPS you have to enable ipv6. In this guide i am assuming you know how to connect to a VPS and update it etc and know how to get things done on your wallet side, else you could look that up here: https://github.com/w00dstuck/vps
</br>
</br>
Clone the GitHub repo:

```
git clone https://github.com/w00dstuck/vps.git
```

</br>
Eh... i didnt know how to change permissions on GitHub (LOL!) so change them on the VPS:

```
chmod 777 vps/install-repme.sh
```

</br>
Coz there is no RepMe repo yet, download the pre-compiled RepMe wallet for Ubuntu 16.04 and extract it on your VPS (its the official dropbox link taken from the RepMe helpsite):

```
cd ~/vps && ./install-repme.sh
```

</br>
</br>
Now that that the repmed, repme-cli and rempe-tx are installed we are going to create the datadirs/configs/services, using the nodemaster script, for your nodes. If there is no swapfile on the VPS, this script will do that too for you :-). 
Below command shows it for 2 nodes, change this (-c 2) in the amount you want and add the genkeys for them. If you just want to install 1 remove the -c 2 and just add 1 key:

```
cd ~/vps && ./install.sh -p repme -c 2 --key **GENKEY1** --key2 **GENKEY2**
```

When the script is done, you activate the nodes (script tells you to do so too):

```
sudo /usr/local/bin/activate_masternodes_repme
```

</br>
Now we need to let them fully sync and do the rest on your wallet side! Create an address for your node, send exactly 20m RPM to that adress and use the tx id for the MN config string. You can check the config files on the VPS for the IP-address and masternode key (change n1 for n2 etc for the number of the node):

```
cat /etc/masternodes/repme_n1.conf
```

</br>
</br>
</br>
To check the blockheight etc on the VPS:

```
/usr/local/bin/repme-cli -conf=/etc/masternodes/repme_n1.conf getinfo
```

To check if syncing is done (true):

```
/usr/local/bin/repme-cli -conf=/etc/masternodes/repme_n1.conf mnsync status
```

After you started the node on the wallet side, you should get a message "Masternode successfully started":

```
/usr/local/bin/repme-cli -conf=/etc/masternodes/repme_n1.conf masternode status
```

</br>
</br>
</br>
</br>

**If you wish to donate some of your RPM masternode rewards ;-)**

```
RVmUQVEyk9sMNFwBtqPjkoeWkdsfSMgb3W
```
