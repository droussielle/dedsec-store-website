async function test(){
    const res = await fetch('http://localhost:8000/product')
    const body = await res.json();
    console.log(body['data'][0])
}
test()