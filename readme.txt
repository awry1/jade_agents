1) make sure the scripts are in the same directory as jade.jar

2) scripts can take parameters to start only certain container, for example:
./lab1.sh 0 - main container with gui
./lab1.sh 1 - federated container
./lab2.sh 0 - main container with gui
./lab1.sh 0 - backup container
./lab1.sh 2 - federated container

3) don't try to start lab2 with only encryption (unless you wanna waste hours)

4) to start lab2 with auth you need to first create keystores using provided scripts, for example:
./keygen.sh main
./keygen.sh fed
./keyimport.sh main fed
./keyimport.sh fed main
