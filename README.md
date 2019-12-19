# Password-Management-System
A simple password management system written by shell script


Password Management System
===

## Introduction:
This is a password management system offering a structural file system to store both login and password for many users. Also, in each user, multiple service can be allowed. You can have several categories of services with multiple account in each category, for example, a user called PaiHan can have a category "Bank", in the Bank folder, he can have AIB, BOI and other bank services. 

The system can be divided into two main parts, server side and client side. In server side, several functions listed below are built to manage the passwords for users:

- init: Register new user
- insert: Insert a new service
- show: Show the login and password of one service
- update: Update an existing service
- rm: Remove an existing service
- ls: Show the file path structurally
- shutdown: shutdown the server

As for the client side, the update function is "edit" which opens a temp file for user to edit the existing payload.

Details for each function will be discussed after. Also, semaphores are implemented in each function to ensure the data integrity if multiple clients access to the same users. That is, when a certain user is accessed by a client, no client can access to it at the same time, he or she needs to wait until the former client exit the user folder. 

For the client side, client can send different kind of requests to server which triggers the corresponding functions. After the job has been completed on the server, the server will send back the request to client, showing the execution result.

## Requirement:

In order to construct a password management system in a proper way, we need several scripts with different functions, and assemble together. The detail of all the scripts and brief instruction will be described below.

- init.sh: 
```=bash
./init.sh $user $service
```
It serves the function to create new user folder, different services with passwords and logins will be placed in the folder afterward. The $user parameter should be specified, and the name can contain space or special character, but the double quotes are needed to ensure everything runs properly.

- insert.sh:
```=bash
./insert.sh $user $service $payload
```
This script serves the function of inserting new service in an existing user folder with payload including login and password. $user, $service and $payload should be specified to run this script, also it can serve the function of edit or update new payload to an existing service by extra attribute "f" instead of "" to trigger this function. In the server and client side, we just need to use the commend to differentiate between inserting and updating in this function. Both insert and update will consider the effect of special character like \n will make the string to a new line. Like init function, if double quotes are need if the string contains space.

- show.sh:
```=bash
./show.sh $user $service
```
Show.sh can show the payload for specified $user and $service. We cannot ask the program to show a non-existing service.

- rm.sh:
```=bash
./rm.sh $user $service
```
We can remove a specified service in a user with $user and $service parameters inputted. We cannot ask the program to remove a non-existing service. 

- ls.sh:
```=bash
./ls.sh $user [$folder]
```
This script can list the file system structurally to help user who forgot what services they have registered in the password management system. The $user parameter must be specified, and the optional argument $folder which represents the child folder in that user.

- server.sh:
```=bash
./server.sh $req [args]
```
A server can read the commend from client and execute different script with different functions. When server start executing, it will create a pipe called server.pipe to receive the data from client side. There is a 2 second sleeping before receiving data, it can avoid the server from reading the same request multiple times.

The different commend can trigger different functions in the server as mentioned before. However, the "insert" and the "update" commend both call the insert.sh, and the difference is the pre-assign argument "" and "f" which stands for "insert" and "update" respectively. Also, the format of both commends were hardcoded, they only receive the two variables ($mylogin, $mypassword) from client side. The server can be shut down by the commend "shutdown", it can also be received from the client. If the server is closed, the server pipe will be removed, as well. The server should server multiple client at the same time, and the data integrity should be remained. When a client accesses a user, other entry for the same user should be rejected. Semaphore is implemented in each function to prevent the critical section, the user, to be accessed at the same time. For example, while user1 is updating the password, the commend "show" cannot be operated, or there will be uncertainty for the data showed. To build the semaphore, hard link between P.sh and the lock named by user name was applied. Also, concurrency is implemented to ensure the usage of multiple user. Therefore, there is a "&" standing for operating in the background when a script is called.

- client.sh
```=bash
./client.sh $clientId $req [args]
```
Client side is an interface to allow individuals to send request and parameters to the server side. The parameters are transmitted by server.pipe. After the commend being executed, the server will send back another message via $clientId.pipe which was created right after the client.sh was executed. It shows the result to the user. When the client sends the login or password to the server, both variables will be encrypted to ensure information security. In server side, all the personal information is showed as random characters. Once the server sends back the password and login information back to the client interface, the password and login will be decrypted to its original form.

The function in the client can be slightly different from the server side. When a client wants to insert a service, random password can be chosen to generate a password with combination of numbers and letters in lower and upper cases, or the user can set the password on their own. Space is not allowed in the password because space here serve as delimiter. In the client side, there is no "update" commend, but "edit". The "edit" request will first send "show" request to server and receiving the data from the server. The receiving information will be written in a temp file for user to edit. Since the format was specified, if the user changed the format, error may occur when reading through the pipe. The edited information will be encrypted and send back to the server.
