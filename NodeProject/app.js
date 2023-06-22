const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const app = express();
const db = require('./dbConnExec');
const config = require('./config');
const auth = require("./middleware/authenticate");
app.use(express.json());

const PORT = 1332;

const message500 = "Something went wrong. Please check console for error";

app.listen(PORT, ()=>{
    console.log(`Node Project App is running on port ${PORT}`);
})

app.get("/items", (req, res)=>{
    db.executeQuery(`
        select i.*, c.FullName
        from tabItem i
        join tabCustomer c on i.CreatedBy = c.CustomerID 
        order by i.Sold
    `).then(result=>{
        res.status(200).send(result);
    }).catch(err=>{
        console.log(err);
        res.status(500).send(message500);
    })
});

app.get("/items/:id", (req, res)=>{
    db.executeQuery(`
        select i.*, c.FullName
        from tabItem i
        join tabCustomer c on i.CreatedBy = c.CustomerID 
        where i.ItemID = ${req.params.id}
        order by i.Sold
    `).then(result=>{
        if(result[0]){
            res.status(200).send(result[0]);
        }
        else{
            res.status(404).send("Bad request");
        }
    }).catch(err=>{
        console.log(err);
        res.status(500).send(message500);
    })
});

function checkCardValidity(dateString){
    if(!dateString){
        return {
            isValid: false,
        }        
    }
    today = new Date();
    splitString = dateString.split("/");
    
    if(splitString.length != 2){
        return {
            isValid: false,
        }
    }

    mth = splitString[0];
    yr = splitString[1];
    if((mth>0 && mth<13 && mth>=today.getMonth()) && (yr>=today.getFullYear())){
        return {
            isValid: true,
            validityDate: `${yr}-${mth}-${01}`
        }
    }
    else{
        return {
            isValid: false,
        }
    }

}

app.post("/register", async (req, res)=>{

    let CardNumber = req.body.CardNumber; 
    let UserName = req.body.UserName; 
    let Email = req.body.Email; 
    let FullName = req.body.FullName;
    let BillingAddress = req.body.BillingAddress; 
    let CardName = req.body.CardName; 
    let CardValidity = req.body.CardValidity; 
    let CardCvv = req.body.CardCvv; 
    let UserPassword = req.body.UserPassword;

    console.log(req.body);

    //validate fields using regex
    cardNumberRegex = /^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/;
    userEmailRegex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    fullNameRegex = /^[a-zA-Z]+\s[a-zA-Z]+$/;
    invalidInputString = "";

    if(!(CardNumber && cardNumberRegex.test(CardNumber))){
        invalidInputString += "Invalid data for key CardNumber. Format required: 1234-1234-1234-1234.\n";
    }
    if(!(CardNumber && UserName.length<10)){
        invalidInputString += "Invalid data for key UserName. Limit 10 characters.\n";
    }
    if(!(CardNumber && userEmailRegex.test(Email))){
        invalidInputString += "Invalid data for key Email. Make sure to have a valid email.\n";
    }
    if(!(CardNumber && fullNameRegex.test(FullName))){
        invalidInputString += "Invalid data for key FullName. Need a first and last name with a space in between.\n";
    }
    if(!(CardNumber && fullNameRegex.test(CardName))){
        invalidInputString += "Invalid data for key CardName. Need a first and last name with a space in between.\n";
    }
    if(!(BillingAddress && BillingAddress.length < 40)){
        invalidInputString += "Invalid data for key BillingAddress. Limit to 40 characters.\n";
    }
    if(!(CardCvv && CardCvv>99 && CardCvv<1000)){
        invalidInputString += "Invalid data for key CardCvv. Required 3 digits.\n";
    }
    if(!UserPassword){
        invalidInputString += "Invalid data for key UserPassword. Required.\n";
    }

    Role = "Buyer";
    DoB = '1994-04-23';

    cardValidityChecker = checkCardValidity(CardValidity);
    if(!cardValidityChecker.isValid){
        invalidInputString += "Invalid data for key CardValidity. Format required: mm/yyyy in future."
    }
    else{
        CardValidity = cardValidityChecker.validityDate;
    }

    if(invalidInputString.length>0){
        return res.status(400).send(`Bad request.\n ${invalidInputString}`);
    }

    FullName = FullName.replace("'", "''");

    let duplicateUser = await db.executeQuery(`select 1 from tabCustomer where UserName = '${UserName}'`);
    if(duplicateUser && duplicateUser[0]){
        return res.status(409).send("Please enter a different username");
    }

    UserPassword = bcrypt.hashSync(UserPassword);    

    let insertQuery = `
        insert into tabCustomer
        (CardNumber, BillingAddress, CardName, CardValidity, CardCvv, UserName, UserPassword, Role, Email, DoB, FullName)
        values 
        ('${CardNumber}', '${BillingAddress}', '${CardName}', '${CardValidity}', '${CardCvv}', '${UserName}', '${UserPassword}', '${Role}', '${Email}', '${DoB}', '${FullName}')
    `;


    console.log(insertQuery)

    db.executeQuery(
        insertQuery
    ).then(()=>{
        res.status(201).send("Registration successful");
    }).catch(err=>{
        console.log("Error in POST/register. Error: ", err);
        res.status(500).send(message500);
    })
})

app.post("/login", async (req, res)=>{
    let UserName = req.body.UserName;
    let UserPassword = req.body.UserPassword;

    console.log(UserName, UserPassword);

    if(!UserName || !UserPassword){
        return res.status(400).send("Bad request");
    }

    let UserNameCheckQuery = `select * from tabCustomer where UserName = '${UserName}'`;
    let result;
    try {
        result = await db.executeQuery(UserNameCheckQuery);
    } catch (err) {
        console.log("Error in /login. Error: ", err);
        return res.status(500).send();
    }
    console.log(result);

    if(!result[0]){
        return res.status(400).send("Invalid credentials");
    }

    let customer = result[0];
    if(!(await bcrypt.compareSync(UserPassword, customer.UserPassword))){
        return res.status(400).send("Invalid credentials");
    }

    let token = jwt.sign({pk: customer.CustomerID}, config.JWT, {expiresIn: '60 minutes'});
    console.log(token);

    let updateTokenQuery = `
        update tabCustomer set Token = '${token}' 
        where CustomerID = '${customer.CustomerID}'
    `;
    try {
        result = await db.executeQuery(updateTokenQuery);
        res.status(200).send({
            token: token,
            contact: {
                FullName: customer.FullName,
                UserName: customer.UserName,
                CustomerID: customer.CustomerID
            }
        });
    } catch (err) {
        console.log("Error in /login. Error: ", err);
        return res.status(500).send();
    }
})

app.post("/reviews/add", auth, async(req, res)=>{
    try {
        let review = req.body.review; 
        let today = new Date();
        let reviewDate = `${today.getFullYear()}-${today.getMonth()<10?"0"+today.getMonth():today.getMonth()}-${today.getDate()}`;
        let onItem = 20;
        let reviewBy = 25;

        if(!review){
            res.status(400).send("Bad Request");
        }

        review = review.replace("'", "''");

        let insertQuery = `
            insert into tabReview (Review, ReviewBy, Date, OnItem)
            Output inserted.ReviewID, inserted.Review, inserted.ReviewBy, inserted.OnItem
            values 
            ('${review}', '${req.contact.CustomerID}', '${reviewDate}', '${onItem}')
        `;

        let insertedReview = await db.executeQuery(insertQuery);

        res.status(201).send(insertedReview[0])
    } catch (err) {
        console.log("error in POST /reviews/add ", err);
        res.status(500).send(message500);
    }    
})

app.post("/logout", auth, (req, res)=>{
    db.executeQuery(
        `update tabCustomer set Token = null where CustomerID = ${req.contact.CustomerID}`
    ).then(()=>{
        res.status(200).send("Signed Out!")
    }).catch((err)=>{
        console.log("Error in POST /logout", err);
        res.status(500).send("Failed /logout. Check console for errors");
    })
})