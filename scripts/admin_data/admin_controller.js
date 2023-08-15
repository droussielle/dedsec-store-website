//navigate to login site if user's not logged in
if(!(localStorage.getItem('user'))){
    alert("Please login to use this features");
    window.location.href='../../pages/sign.php'
}

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
        if(data.data.role !== "ADMIN" || !localStorage.getItem('user')){
            alert("You cannot access this page");
            window.location.href="../../index.php";
        }
    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });

