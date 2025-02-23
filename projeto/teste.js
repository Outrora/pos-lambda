const { handler } = require("./main");

const event = {teste: 1}; // Simule um evento aqui
handler(event).then(response => console.log(response));