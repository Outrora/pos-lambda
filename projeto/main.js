const jwt = require("jsonwebtoken")
const {Client} = require("pg")

const SECRET_KEY = "minha_senha_super_secreta";

const generateToken = (user) => {
  return jwt.sign({id : user.id, cpf: user.cpf},SECRET_KEY,{expiresIn: "1h", algorithm: "HS256"})
}

const dbConfig = {
  user : process.env.DB_USER,
  host : process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432
}

exports.handler = async (event) => {
  const client = new Client(dbConfig)

  try {
      const body = event.body ? JSON.parse(event.body) : {};
      if (!body.cpf) {
        return { statusCode: 400, body: JSON.stringify({ message: "CPF é obrigatório" }) };
      }
      await client.connect();
      const res = await client.query("SELECT * FROM cliente where cpf = $1",[body.cpf])
      await client.end()
      if (!res.rowCount)  return { statusCode: 404, body: JSON.stringify({ message: "Usuario não encontrado" }) };
      const user = {cpf : res.rows[0].cpf, id : res.rows[0].id}
      const token = generateToken(user);
    return { statusCode: 200, body: JSON.stringify({ token }) };
  } catch (error) {
    return { statusCode: 500, body: JSON.stringify({ message: "Erro interno", error: error.message }) };
  }
 
  };
  