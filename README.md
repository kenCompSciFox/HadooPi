HadooPi
=======

Hadoop on Raspberry Pis and other platforms

==========================================
Some automated multiplatform Hadoop installation and configuration scripts for educational purposes.

Initial versions of code leave a lot to be desired.

For CS498 Big Data and Analytics Independent Study FA13 Drexel Univeristy, Philadelphia, PA 19104.



OPERATIONAL NOTES
(no particular order)

the NodeController system and account.

We made these assumptions:
  admin account to setup and configure the target machine as needed:
     An account on the target machine with sudo privleges
     An account on the NodeController system with the same name as above account
     ssh is installed and enabled
     The public key for the above acoount on the NodeCOntroller is in the authorized_keys file of the above account on the target machine such that this account can perform passwordless ssh and scp to the target.
     
     
