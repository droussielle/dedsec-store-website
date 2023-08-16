function formatText(inputText) {
    const paragraphs = inputText.split('\r\n\r\n');
    const formattedText = paragraphs.map(paragraph => `<p>${paragraph.replace(/\r\n/g, ' ')}</p>`).join('\n');
    return formattedText;
}

async function Get_Blog_List(){

    const res = await fetch(`http://localhost:8000/blog`);
    let data = await res.json();
    
    return {status: res.ok, message: data.message, data: data.data};
}

// async function Get_Blog(id){

//     const res = await fetch(`http://localhost:8000/blog`);
//     let data = await res.json();
    
//     return {status: res.ok, message: data.message, data: data.data};
// }

document.addEventListener('DOMContentLoaded', async ()=>{

    let id = parseInt(localStorage.getItem('news_detail'));
    let new_list = await Get_Blog_List();

    if(!(new_list.status)){
        let news_container = document.getElementById('news-container');
        news_container.innerHTML = `This news is expired!`;
        return;
    }
    
    let current_new;
    // for(let i = 0; i < new_list.data.length; i++){
    //     if(id == new_list.data[i].id){
    //         current_new = new_list.data[i];
    //         break;
    //     }
    // }
    new_list.data.forEach(element => {
        if(id == element.id){
            current_new = element;
            return;
        }
    });


    let news_img = document.getElementById('news-img');
    let news_header = document.getElementById('news-header');
    let news_content = document.getElementById('news-content');
    // posted_date = document.getElementById('posted-date');
    // updated_date = document.getElementById('updated-date');

    news_img.src = current_new.image_url;
    news_header.innerHTML = current_new.title;
    news_content.innerHTML = `${formatText(current_new.content)}`;
    // posted_date.innerHTML = `Posted ${current_new.created_at}`;
    // updated_date.innerHTML = `Updated ${current_new.updated_at}`;

})