async function Get_Blog_List(){

    const res = await fetch(`http://localhost:8000/blog`);
    let data = await res.json();
    
    return {status: res.ok, message: data.message, data: data.data};
}

function formatText(inputText) {
    const paragraphs = inputText.split('\r\n\r\n');
    const formattedText = paragraphs.map(paragraph => `<p>${paragraph.replace(/\r\n/g, ' ')}</p>`).join('\n');
    return formattedText;
}

function formatAndTruncate(inputText, maxWords) {
    const words = inputText.split(/\s+/);
    const truncatedWords = words.slice(0, maxWords);
    const formattedAndTruncated = `<p>${truncatedWords.join(' ')}...</p>`;
    return formattedAndTruncated;
}

function create_news_card(id, img_link, title, description){

    let card = document.createElement('div');
    card.classList = 'card pe-5 mb-5 border-0';
    card.style.background = '#DDD';
    card.id = `${id}`;

    description = formatAndTruncate(description, 28);

    let card_body = `
        <img src="${img_link}" class="card-img-top" alt="news-img" id="news-img-${id}">
        <div class="card-body p-0">
            <div class="card-head my-2" id="news-title-${id}">${title}</div>
            <div class="card-description" id="news-content-${id}">${description}</div>
        </div>
    `;

    card.innerHTML = card_body;
    return card;
}

document.addEventListener('DOMContentLoaded', async ()=>{

    let news = await Get_Blog_List();
    let news_container = document.getElementById('news-container');

    if(!(news.status)){
        news_container.innerHTML = 'There is no latest news!';
        return;
    }

    let news_cards = news.data;
    for(let i = 0; i < news_cards.length; i++){
        let card = news_cards[i];
        let card_child = create_news_card(card.id, card.image_url, card.title, card.content);
        news_container.appendChild(card_child);
    }

    let childs = news_container.children;
    for(let i = 0; i < childs.length; i++){
        let id = childs[i].id;
        
        childs[i].addEventListener('click', ()=>{
            localStorage.setItem('news_detail', `${id}`);
            window.location.href = '/pages/news-details.php';
        });
    }

});
