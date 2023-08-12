// Fetch list of products
async function Get_Product_Single(id){
    const res = await fetch('http://localhost:8000/product');
    let data = await res.json();
    data = data['data'];

    for (item in data){
        if(item['id'] === id){
            return item;
        }
    }

    return {};
}

document.addEventListener('DOMContentLoaded', async() =>{

    let id = localStorage.getItem('get_detail');
    let item = await Get_Product_Single(id);

    if (item == {}){
        document.getElementById('detail-body').innerHTML = 'No Product match!';
        return;
    }

    // Header
    let product_name = document.getElementById('product-name');
    let product_btn = document.getElementById('product-btn');

    product_name.innerText = item['name'];
    product_btn.addEventListener('click', async ()=>{
        const res = await fetch(`http://localhost:8000/product/${id}`);
        window.location.href = '/pages/cart.php';
    })

    // Slider
    for (let slide = 1; slide <= 4; slide++){
        for(let pic = 1; pic <= 2; pic++){
            let current_pic = document.getElementById(`product-slide${slide}-img${pic}`);
            current_pic.src = `../images/product-details_laptop-${pic}-image.png`;
        }
    }

    //Truly personal computing
    let truly_img = document.getElementById('truly-img');
    let truly_head = document.getElementById('truly-head');
    let truly_content = document.getElementById('truly-content');

    truly_img.src = '../images/product-details_overview-image-1.png';
    truly_head.innerText = 'Truly personal computing';
    truly_content = 'The DEDSEC Laptop 13 has an extremely modular design that gives you full control. Order the DIY Edition and build it yourself, or choose pre-built to have a system ready to go out of the box. Replace any part, upgrade key components, and customize like never before.';

    //Expansion Cards
    let expansion_img = document.getElementById('expansion-img');
    let expansion_head = document.getElementById('expansion-head');
    let expansion_content = document.getElementById('expansion-content');

    expansion_img.src = '../images/product-details_overview-image-2.png';
    expansion_head.innerText = 'Expansion Cards';
    expansion_content = 'External adapters are a thing of the past. The Framework Expansion Card system lets you choose exactly the ports you want and where you want them. With four bays, you can select from USB-C, USB-A, HDMI, DisplayPort, MicroSD, Ethernet, Audio, ultra fast storage, and more.'

    // Keyboard
    let keyboard_img = document.getElementById('keyboard-img');
    let keyboard_head = document.getElementById('keyboard-head');
    let keyboard_content = document.getElementById('keyboard-content');

    keyboard_img.src = '../images/product-details_overview-image-3.png';
    keyboard_head.innerText = 'Keyboard';
    keyboard_content = 'The DEDSEC Laptop has a great feeling keyboard with a toggleable backlight. While most compact notebooks have shrunk to between 0.8mm and 1.2mm travel, we’ve chosen a better balance of 1.5mm to deliver excellent feel while keeping the system highly portable. Available in 12 languages and clear and blank options. Plus, more coming soon!'


    ///////////////////////---SPECS---///////////////////////
    let specs = JSON.parse(item['specs']);
    const optionKeys = Object.keys(specs);

    let specs_options = document.getElementById('specs-options');
    specs_options.innerHTML = '';

    for (let i = 0; i <= specs.length; i++){
        
        // add head
        let head = document.createElement('h5');
        head.classList.add('fw-bolder');
        head.id = `specs-option-${i}-head`;
        head.innerText = optionKeys[i];

        //add list
        let list = document.createElement('ul');
        list.id = `specs-option-${i}-list`;

        for(const li_item in specs[i]){
            list.id.innerHTML += `<li>${li_item}<\li>`;
        }

        // add to options
        specs_options.appendChild(head);
        specs_options.appendChild(list);
    }

    ///////////////////////---BOX---///////////////////////
    let box_img = document.getElementById('box-img');
    let box_list = document.getElementById('box-list');

    box_img.src = `../images/product-details_whats-in-the-box.png`;
    box_list.innerHTML = `
        <li>DEDSEC Laptop DIY Edition </li>
        <li>Input Cover</li>
        <li>Bezel</li>
        <li>Memory (optional)</li>
        <li>Storage (optional)</li>
        <li>WiFi</li>
        <li>Expansion Cards (customizable)</li>
        <li>Power Adapter (optional)</li>
        <li>DEDSEC Screwdriver</li>
    `

    let support_list = document.getElementById('support-list');
    support_list.innerHTML = `
        <li>Quick start guide </li>
        <li>Recommend Linux distros</li>
        <li>Factory images</li>
        <li>Safety & Compliance</li>
        <li>User manual</li>
    `
});