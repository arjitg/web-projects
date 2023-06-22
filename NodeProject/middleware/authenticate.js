const jwt = require('jsonwebtoken');
const dbConnExec = require('../dbConnExec');
const config = require('../config');

const auth = async (req, res, next)=>{
    console.log(req.header('Authorization'))
    try{
        let aToken = req.header('Authorization').replace('Bearer ', '');
        let decodedToken = jwt.verify(aToken, config.JWT);
        let contactPK = decodedToken.pk;
        let checkTokenQuery = `
            select CustomerID, FullName, Email
            from tabCustomer
            where CustomerID = '${contactPK}' and Token = '${aToken}'
        `;
        let returnedContact = await dbConnExec.executeQuery(checkTokenQuery);

        if(returnedContact[0]){
            req.contact = returnedContact[0];
            next();
        }
        else{
            res.status(401).send('Authentication failed');
        }
    }
    catch(err){
        console.log(err);
        res.status(500).send('Server error during Authentication. Check console for traceback');
    }
}
module.exports = auth;