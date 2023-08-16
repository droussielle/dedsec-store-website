//Old password
var old_password = document.getElementById('old-password');

//New password
var new_password = document.getElementById('new-password');


var changePassword = document.querySelector('#change-password-button').addEventListener('click',(event)=>{
    if (new_password.value.length <6){
        window.alert("Your password must be more than 6 characters long, please try again");
        old_password.value="";
        new_password.value="";
        return;       
    }
    
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    fetch("http://localhost:8000/auth/password",{method:'PATCH',
    headers:{
        "Authorization": `Bearer ${myToken}`,
        "Content-Type":"application/json"
    },
    body: `
    {
        "oldPassword":"${old_password.value}",
        "newPassword":"${new_password.value}"
    }
    `,
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        alert(JSON.stringify(data.message));
        window.location.reload();

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });

})