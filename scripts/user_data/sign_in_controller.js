//User hit sign-in button
var sign_in=document.querySelector("#sign-in-button").addEventListener('click', (event)=>{
    let email = document.querySelector("#sign-in-email").value;
    let password = document.querySelector("#sign-in-password").value;
    let logInInformation= `
        {
            "email": "${email}",
            "password": "${password}"
        }
    `;

    fetch("http://localhost:8000/auth/login", { method: "POST", 
    headers:{
        "Content-Type": "application/json",
    },
    body: logInInformation,
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);

        //login successfully
        if (data.token){
            // localStorage.setItem("token",data.token);
            // localStorage.setItem("name",data.data.name);
            // localStorage.setItem("email",data.data.email);
            // localStorage.setItem("isLoggedIn",'true');
            // let email=JSON.parse(localStorage.getItem('user')).data.email;

            localStorage.setItem("user",JSON.stringify(data));

            window.location.href = '/index.php';

            
        }   else{
            window.alert(data.message);        
            return;    
        }

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });

    

});


