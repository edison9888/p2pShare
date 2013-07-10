p2pShare


p2p sharing ways :

1. users in same Wifi environment ,might be company , school , government 
first, use NSNetservice to publish , browse , connect with each other , but android can't connect with iOS
second , use mDNS cross-platform solution to register service , and find each other , then use TCP/IP custom way to share data

2. users stand closed to each other , but no wifi connections 
try bluetooth , using GameKit P2P function , but iOS can't communication with android devices


3. users all over the world
use GameCenter to start P2P connection , but this must show as a game function , or won't pass the apple app store principle.
use P2P network library to share without any servers , but library is still under developing.


========
