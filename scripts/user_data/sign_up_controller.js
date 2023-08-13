//User hit sign-in button
var sign_in=document.querySelector("#sign-up-button").addEventListener('click', (event)=>{
    let name = document.querySelector('#sign-up-name').value;
    let email = document.querySelector("#sign-up-email").value;
    let password = document.querySelector("#sign-up-password").value;
    let passwordConfirmation = document.querySelector("#sign-up-password-confirm").value;
    let correctPassword= (password===passwordConfirmation);
    
    // Check if anyfield is empty
    if (name.length ===0 || email.length === 0 || password.length ===0 || passwordConfirmation.length===0){
        window.alert("You cannot leave any field empty, please try again");
        return;

    }
    
    //Check if password is correct
    if (!correctPassword) {
        window.alert("Password does not match, please try again");
        document.getElementById("sign-up-password").value="";
        document.getElementById("sign-up-password-confirm").value="";
        document.getElementById("sign-up-email").value="";
        return;
    } 
    


    let logInInformation= `
        {
            "email": "${email}",
            "password": "${password}",
            "name": "${name}",
            "image_url": "https://images.unsplash.com/photo-1683129384918-684af5f77d6d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHVtYmF8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=600&q=60",
            "birth_date": null
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
            window.location.href = '../index.php';
            
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


