//GET USER LIST
fetch("http://localhost:8000/user",{method:'GET',
headers:{
    "Authorization": `Bearer ${JSON.parse(localStorage.getItem('user')).token}`,
    "Content-Type":"application/json"
},
})
.then((response) => response.json())
.then((data) => {
    console.log("Response from backend:", data);
    localStorage.setItem("user-list",JSON.stringify(data));

})
.catch((error) => {
    console.error("Error:", error);
    alert(error);
});

function generateItem(name,id,email,role,phone,address){
    var list=document.getElementById("user-list");
    var item = document.createElement("row");
    item.className="p-5";
    item.innerHTML=`
        <p>User id: ${id}</p>
        <p>Email: ${email}</p>
        <p>Name: ${name}</p>
        <p>Role: ${role}</p>
        <p>Phone: ${phone}</p>
        <p>Address: ${address}</p>
        
    `
    list.appendChild(item);
    
}

var items=JSON.parse(localStorage.getItem("user-list")).data;
for (var i in items ){

    //Get phone and address of each user
    let phone="";
    let address="";
    fetch(`http://localhost:8000/user/${items[i].id}`,{method:'GET',
    headers:{
        "Authorization": `Bearer ${JSON.parse(localStorage.getItem('user')).token}`,
        "Content-Type":"application/json"
    },
})
    .then((response) => response.json())
    .then((data) => {
        console.log("Response from backend:", data);
        phone=data.data.info.phone;
        address=data.data.info.address;
        // generateItem(items[i].name,items[i].id,items[i].email,items[i].role,phone,address);
        generateItem(data.data.info.name,data.data.info.id,data.data.email,data.data.role,phone,address);
    })
    .catch((error) => {
        console.error("Error:", error);
        alert(error);
    });

    // window.location.reload();
    
}



