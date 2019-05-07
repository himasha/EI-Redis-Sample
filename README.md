
Prerequisites

1. Download WSO2 Enterprise Integrator binary from https://wso2.com/integration/install/.
2. Download the jedis-2.1.0.jar file from https://mvnrepository.com/artifact/redis.clients/jedis/2.1.0 and copy it to the <EI_Home>/lib directory.
3. Download the Redis server from http://redis.io/download, and start it.
4. Download Redis connector from https://store.wso2.com/store/assets/esbconnector/details/c44f0cdf-47c6-4000-8544-8e16e457c5c4 .
5. Enable downloaded Redis connector in WSO2 Enterprise Integrator as explained in https://docs.wso2.com/display/EI611/Working+with+Connectors+via+the+Management+Console.
6. Mysql (to use as the backend database )


Sample Preparation

1. Add an API in WSO2 Enterprise Integrator by using the content of EI-resources/UserInfoAPI.xml.
2. In this sample, a ballerina service is used as the backend service which simply connects to a Mysql database and retrieve user name for a given user ID. In order to use this, install Ballerina (https://ballerina.io/learn/getting-started/) and run UserInfoService like below.

ballerina run UserInfoService.bal

3. Execute the queries in EI-resources/dbscript.txt to create the Mysql database,table and to insert some sample records.
==================
Create a databse and a table in Mysql as below.

Create database userdb;
use userdb;
CREATE TABLE user ( id int,name varchar(255));

4. Insert some sample data to the created table as below. 

insert into user(id,name)values(1001,'john');
insert into user(id,name)values(1002,'emma');
insert into user(id,name)values(1003,'peter');
insert into user(id,name)values(1004,'Sam');
insert into user(id,name)values(1005,'Danny');
===================

5. Update the username/password of mysql client definition (as below) in UserInfoService.bal based on your mysql setup configurations.

mysql:Client userDB = new({
        host: "localhost",
        port: 3306,
        name: "userdb",
        username: "xxxx",
        password: "xxxxxx",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });

Sample Execution

1. Start Redis server, WSO2 Enterprise Integrator and ballerina service.
2. Execution commands,
To invoke UserInfoAPI (API request format:  curl http://HOST:8280/userinfo/user/USERID)
Sample request 
 curl http://localhost:8280/userinfo/user/1001

 3. For the first invocation, it will access the backend database directly and fetch the result. This could be observed through the logs printed in EI console.
 4. For the next immediate invocation for the same user ID would result in fetching the response from Redis cache. This could be observed through the logs printed. 
 5. Next try stopping the ballerina (backend service) and perform the same invocation and you could see that the cached response is still fetched. 

 