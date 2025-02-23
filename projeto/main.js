const jwt = require("jsonwebtoken")

const SECRET_KEY = "minha_senha_super_secreta";

const generateToken = (user) => {
  return jwt.sign({id : 1, cpf: 33333},SECRET_KEY,{expiresIn: "1h", algorithm: "HS256"})
}

exports.handler = async (event) => {
     try {
      const body = JSON.parse(event.body)
      const user = { id: 1, name: "Admin User", role: "admin" };
      const token = generateToken(user);
      return { statusCode: 200, body: JSON.stringify({ token }) };
     } catch (error) {
      return { statusCode: 500, body: JSON.stringify({ message: "Erro interno", error: error.message }) };
     }
 
  };
  