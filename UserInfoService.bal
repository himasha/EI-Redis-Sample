import ballerina/http;
import ballerina/io;
import ballerina/mysql;

mysql:Client userDB = new({
        host: "localhost",
        port: 3306,
        name: "userdb",
        username: "root",
        password: "samplepw",
        poolOptions: { maximumPoolSize: 5 },
        dbOptions: { useSSL: false }
    });

service user on new http:Listener(9090) {
    
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/info/{id}"
    }
    resource function getInfo (http:Caller caller, http:Request request,int id) returns error? {
        // Create the Response object.
        json result = {"result": "0"};
        http:Response res = new;
        json  userResult = getUserInfoForID(id);
        if(userResult != ""){
        result = {"result": userResult } ; 
    }
        res.setJsonPayload(untaint result,contentType = "application/json");
        _ = check caller->respond(res);
        return;
   }
}

function getUserInfoForID(int|error id) returns (string) {
   string result = "user does not exist";
    if (id is int) {
var userName = userDB->select("SELECT name FROM user WHERE id = ?", (), id);
if (userName is table<record {}>) {
        io:println("\nConvert the table into xml");
        var xmlConversionRet = xml.convert(userName);
        if (xmlConversionRet is xml) {
             result = xmlConversionRet.getTextValue();
        } else {
            io:println("Error in table to xml conversion");
        }
    } else {
        io:println("Select data from student table failed: "
                + <string>userName.detail().message);
    }

} else {
error err = error("error occurred when retreiving data");
panic err;
}
return result;
}