import { Request, Response } from 'express';

export const getUsers = (req: Request, res: Response) => {
    const user = {
        name:"jhon",
        lastname:"Doe",
        email:"johndoe@exambple.com",
        age:30,
        active:true,
        subjets:[
            "Math",
            "Science",
            "History"
        ],
        address:{
            street:"123 main st",
            city:"anytown"
        },
        arreglodeobjetos: [
            {
                name: "john",
                lastname:"Doe"
            },
            {
                name:"john",
                lastname:"Doe"
            }
        ]
    }
    res.json({
        "status":"success",
        "data": {
            "user": user
        }
    });
};

export const getUsersById = (req:Request, res:Response) => {
    res.json({
        "status": "success",
        "data":{
            "id": req.params.id,
            "name":"john"
        }
    })
};