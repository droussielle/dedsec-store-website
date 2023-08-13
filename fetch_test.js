async function test(){
    const res = await fetch('http://localhost:8000/product')
    let body = await res.json()
    // body = body['data']

    // let product = body[0]
    // let specs = JSON.parse(product['specs'])

    // // Get short_description
    // let short_description = product['short_description'];
    // let featuresList = short_description.split('\r\n');
    // featuresList = featuresList.filter(feature => feature.trim() !== '');

    // // print out
    // console.log(featuresList);
    // console.log(specs['Graphics'])

    // console.log(body.length)
    console.log(body)
}
// test()
async function logout(){

    const data = {
       "quantity": 1
    }
    const res = await fetch('http://localhost:8000/cart',
        {
            method: 'GET',
            headers: {
                "Authorization": `Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZW1haWwiOiJjbGllbnQyQGdtYWlsLmNvbSIsInJvbGUiOiJBRE1JTiJ9.XTLrx5QwtPdIOdLAH6klcqCmlCsclci7RbxJ-F5cvk4`
            },
            // body: JSON.stringify(data)
        }
    );
    const body = await res.json();
    console.log(body);
}

logout();