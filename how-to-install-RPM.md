
**Quick guide to install Multiple RepMe Masternodes on a Ubuntu 16.04 VPS**

This is my first activity on GitHub ever, so.... ;-)

Clone the GitHub repo:
```
git clone https://github.com/w00dstuck/vps.git
```

Eh... i didnt know how to change permissions on GitHub (LOL!) so change them on the VPS:
```
chmod 777 /vps/install-repme.sh
```

Coz there is no RepMe repo yet, download the pre-compiled repme wallet for Ubuntu 16.04 and extract:
```
cd ~/vps && ./install-repme.sh
```

Now we are going to create the datadirs and configs for you nodes, below command shows it for 2 nodes, change this in the amount you want and add the genkeys for them:
```
cd ~/vps && ./install.sh -p repme -c 2 --key **GENKEY1** --key2 **GENKEY2**
```
When the script is done, you activate the nodes (script tells you to do so too):
```
sudo /usr/local/bin/activate_masternodes_repme
```

Let them sync and do the rest in your wallet!



To check the blockheight etc on the VPS end (change n1 for n2 etc for the number of the node):

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



**If you wish to donate some of your RPM masternode rewards ;-)**
```
RVmUQVEyk9sMNFwBtqPjkoeWkdsfSMgb3W
```
