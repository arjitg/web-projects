//Name: Arjit Gupta
const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const app = express();
const db = require('./dbConnExec');
const config = require('./config');
const auth = require("./middleware/authenticate");
app.use(express.json());

const PORT = 1332;

app.listen(PORT, ()=>{
    console.log(`app is running on port ${PORT}`);
})

app.get("/", (req, res)=>{
    res.send("A node REST api is created!!")
})

app.get("/pa", (req, res)=>{
    res.send("A node REST api is created from the pa endpoint!!")
})

app.get("/films", (req, res)=>{
    db.executeQuery(`
        select *
        from Film f 
        join FilmRating r
        on f.RatingFK = r.RatingPK
        order by f.MovieTitle
    `).then(result=>{
        res.status(200).send(result);
    }).catch(err=>{
        console.log(err);
        res.status(500).send("Please check console for error")
    })
});

app.get("/films/:id", (req, res)=>{
    db.executeQuery(`
        select *
        from Film f 
        join FilmRating r
        on f.RatingFK = r.RatingPK
        where f.FilmPK = ${req.params.id}
    `).then(result=>{
        if(result[0]){
            res.status(200).send(result[0]);
        }
        else{
            res.status(404).send("Bad request");
        }
    }).catch(err=>{
        console.log(err);
        res.status(500).send("Please check console for error");
    })
});

app.post("/register", async (req, res)=>{
    let firstName = req.body.firstName;
    let lastName = req.body.lastName;
    let email = req.body.email;
    let userPassword = req.body.userPassword;

    // console.log(firstName, lastName, email, userPassword);

    if(!firstName || !lastName || !email || !userPassword){
        return res.status(400).send("Bad request");
    }

    firstName = firstName.replace("'", "''");

    let emailCheckQuery = `select email from contact where email = '${email}'`;
    let duplicateEmail = await db.executeQuery(emailCheckQuery);
    // console.log(duplicateEmail);
    if(duplicateEmail && duplicateEmail[0]){
        return res.status(409).send("Please enter a different email");
    }

    let hashedPassword = bcrypt.hashSync(userPassword);

    let insertQuery = `
        insert into contact(FirstName, LastName, Email, UserPassword)
        values ('${firstName}', '${lastName}', '${email}', '${hashedPassword}')
    `;

    db.executeQuery(
        insertQuery
    ).then(()=>{
        // console.log("testttt");
        res.status(201).send("Registration successful");
    }).catch(err=>{
        console.log("Error in POST/register. Error: ", err);
        res.status(500).send("Please check console for error");
    })
})

app.post("/login", async(req, res)=>{
    let email = req.body.email;
    let userPassword = req.body.userPassword;

    console.log(email, userPassword);

    if(!email || !userPassword){
        return res.status(400).send("Bad request");
    }

    let emailCheckQuery = `select * from contact where email = '${email}'`;
    let result;
    try {
        result = await db.executeQuery(emailCheckQuery);
    } catch (err) {
        console.log("Error in /login. Error: ", err);
        return res.status(500).send();
    }
    console.log(result);

    if(!result[0]){
        return res.status(400).send("Invalid credentials");
    }

    let contact = result[0];
    if(!(await bcrypt.compareSync(userPassword, contact.UserPassword))){
        return res.status(400).send("Invalid credentials");
    }

    let token = jwt.sign({pk: contact.ContactPK}, config.JWT, {expiresIn: '60 minutes'});
    console.log(token);

    let updateTokenInContact = `
        update contact set Token = '${token}' 
        where ContactPK = '${contact.ContactPK}'
    `;
    try {
        result = await db.executeQuery(updateTokenInContact);
        res.status(200).send({
            token: token,
            contact: {
                FirstName: contact.FirstName,
                LastName: contact.LastName,
                Email: contact.Email,
                ContactPK: contact.ContactPK
            }
        });
    } catch (err) {
        console.log("Error in /login. Error: ", err);
        return res.status(500).send();
    }
})

app.post("/reviews/add", auth, async(req, res)=>{
    try {
        let filmFK = req.body.filmFK;
        let summary = req.body.summary;
        let rating = req.body.rating;

        if(!filmFK || !summary || !Number.isInteger(rating)){
            res.status(400).send("Bad Request");
        }

        summary = summary.replace("'", "''");

        let insertReviewQuery = `
            insert into FilmReview (ReviewSummary, ReviewRating, FilmFK, ContactFK)
            Output inserted.ReviewPK, inserted.ReviewSummary, inserted.ReviewRating, inserted.FilmFK
            values ('${summary}', ${rating}, ${filmFK}, ${req.contact.ContactPK})
        `;

        let insertedReview = await db.executeQuery(insertReviewQuery);

        res.status(201).send(insertedReview[0])
    } catch (err) {
        console.log("error in POST /reviews/add ", err);
        res.status(500).send();        
    }    
})

app.post("/logout", auth, (req, res)=>{
    db.executeQuery(
        `update Contact set Token = null where ContactPK = ${req.contact.ContactPK}`
    ).then(()=>{
        res.status(200).send("Signed Out!")
    }).catch((err)=>{
        console.log("Error in POST /logout", err);
        res.status(500).send("Failed /logout. Check console for errors");
    })
})