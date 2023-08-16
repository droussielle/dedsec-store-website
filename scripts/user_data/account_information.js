// Name
var _name = document.getElementById("customer-infor-name");

// Phone number
var _phone=document.getElementById("customer-infor-phone");


// Address
var _address=document.getElementById("customer-infor-address");



//navigate to login site if user's not logged in
if(!(localStorage.getItem('user'))){
    alert("Please login to use this features");
    window.location.href='/pages/sign.php'
}

//Fetch user detail phone & address
const myToken = JSON.parse(localStorage.getItem('user')).token;
const myID = JSON.parse(localStorage.getItem('user')).data.id;
fetch(`http://localhost:8000/user/${myID}`,{method:'GET',
    headers:{
        "Authorization": `Bearer ${myToken}`,
        "Content-Type":"application/json"
    },
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);

        _name.value=data.data.info.name;
        _address.value=data.data.info.address;
        _phone.value=data.data.info.phone;

    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });


//User hit save button
var save=document.querySelector('#save-button').addEventListener('click', async (event)=>{

    let changes=`
        {
            "name" :"${_name.value}",
            "address":"${_address.value}",
            "phone":"${_phone.value}"
        }
    `
    const myToken = JSON.parse(localStorage.getItem('user')).token;
    let submit_infor = await fetch("http://localhost:8000/auth/profile",{method:'PATCH',
        headers:{
            "Authorization": `Bearer ${myToken}`,
            "Content-Type":"application/json"
        },
        body: changes,
    })
        .then((response) => response.json())
        .then((data) => {
            console.log("Response from backend:", data);
            window.alert("Your information has been changed");

            // Update localStorage
            var old_user = JSON.parse(localStorage.getItem('user'));
            old_user.data.name = _name.value;
            old_user.data.address = _address.value;
            old_user.data.phone = _phone.value;
            localStorage.setItem('user',JSON.stringify(old_user));

            window.location.reload();
        })
        .catch((error) => {
            console.error("Error:", error);
            alert(error);
        });


});

var cancel=document.querySelector('#cancel-button').addEventListener('click',(event)=>{
    window.location.href='/index.php';
});

