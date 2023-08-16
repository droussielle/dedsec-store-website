
// Handle form
function ValidateEmail(email) 
{
    let email_regx = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    return email_regx.test(email);
}


//User hit sign-in button
var sign_in=document.querySelector("#sign-up-button").addEventListener('click', (event)=>{
    let name = document.querySelector('#sign-up-name').value;
    let email = document.querySelector("#sign-up-email").value;
    let password = document.querySelector("#sign-up-password").value;
    let passwordConfirmation = document.querySelector("#sign-up-password-confirm").value;
    let phoneNumber = document.querySelector("#sign-up-phone").value;
    let address = document.querySelector("#sign-up-address").value;
    // phoneNumber=toString(phoneNumber);
    // password = toString(password);
    // passwordConfirmation = toString(passwordConfirmation);
    let correctPassword= (password===passwordConfirmation);
    
    // Check if anyfield is empty
    if (name.length ===0 || email.length === 0 || password.length ===0 || passwordConfirmation.length===0 || phoneNumber.length == 0 ||address.length==0){
        window.alert("You cannot leave any field empty, please try again");
        return;
    }

    // Check if name format is correct
    if (name.length <2){
        window.alert("Invalid name format, please try again");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        document.getElementById("sign-up-name").value="";
        document.getElementById("sign-up-phone").value="";
        document.getElementById("sign-up-address").value="";
        return;     
    }

    // Check if phone number is correct
    if(phoneNumber.length !== 10){
        window.alert("Your phone number must be exact 10 numbers");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        document.getElementById("sign-up-name").value="";
        document.getElementById("sign-up-phone").value="";
        document.getElementById("sign-up-address").value="";
        return;

    }
    
    // Email validation
    if(!ValidateEmail(email)){
        window.alert("Invalid email format, please try again");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        document.getElementById("sign-up-name").value="";
        document.getElementById("sign-up-phone").value="";
        document.getElementById("sign-up-address").value="";
        return;
    }
    
    //Password must be longer than 6 characters
    if (password.length <6){
        window.alert("Your password must be more than 6 characters long, please try again");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        document.getElementById("sign-up-name").value="";
        document.getElementById("sign-up-phone").value="";
        document.getElementById("sign-up-address").value="";

        return;
    }

    //Check if password is correct
    if (!correctPassword) {
        window.alert("Password does not match, please try again");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        document.getElementById("sign-up-name").value="";
        document.getElementById("sign-up-phone").value="";
        document.getElementById("sign-up-address").value="";
        return;
    } 
    


    let logInInformation= `
        {
            "email": "${email}",
            "password": "${password}",
            "name": "${name}",
            "image_url": "https://images.unsplash.com/photo-1683129384918-684af5f77d6d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHVtYmF8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60",
            "phone": "${phoneNumber}",
            "address":"${address}",
            "birth_date": "2000-01-01"
        }
    `;

    fetch("http://localhost:8000/auth/register", { method: "POST", 
    headers:{
        "Content-Type": "application/json",
    },
    body: logInInformation,
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        //regist successfully
        if (data.token){
            //login processes
            localStorage.setItem("user",JSON.stringify(data));
            window.location.href = '/index.php';
            
        }   else{
            alert(data.message);       
            return;     
        }

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });

    

});


