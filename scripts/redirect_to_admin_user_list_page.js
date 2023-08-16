// MAKE SURE USER IS ADMIN
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
    if(data.data.role ==="ADMIN"){
        createButton();
    }
})
.catch((error) => {
    console.error("Error:", error);
    alert(error);
});


function createButton(){
    var navbar = document.getElementById("navbar");
    var userList = document.createElement("button");
    userList.className="btn btn-primary";
    userList.id="user-list-button";
    userList.innerHTML="User list";
    userList.type="button";
    userList.setAttribute('onclick','navigate()');
    navbar.appendChild(userList);
}

function navigate(){
    window.location.href="pages/admin/user-list.php";

}

