function create_news_card(img_link, header_new, description) {
    // Create a new card element
    const card = document.createElement('div');
    card.classList.add('card', 'pe-5', 'mb-5', 'border-0');
    card.style.background = '#DDD';

    // Create the card image element
    const img = document.createElement('img');
    img.src = img_link;
    img.classList.add('card-img-top');
    img.alt = '...';
    card.appendChild(img);

    // Create the card body element
    const cardBody = document.createElement('div');
    cardBody.classList.add('card-body', 'p-0');

    // Create the card header element
    const cardHead = document.createElement('div');
    cardHead.classList.add('card-head', 'my-2');
    cardHead.textContent = header_new;
    cardBody.appendChild(cardHead);

    // Create the card description element
    const cardDescription = document.createElement('div');
    cardDescription.classList.add('card-description');
    cardDescription.textContent = description;
    cardBody.appendChild(cardDescription);

    // Append the card body to the card
    card.appendChild(cardBody);

    return card;
}

let img_link = '../images/new-img/new-products-img-1.jfif' //The path must be suitable for the html not the js file
let header_new = 'Phone news'
let description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam id rhoncus augue, id bibendum magna. Nulla urna nibh, ornare sit amet lacinia vel, accumsan non diam."
const news_container = document.getElementsByClassName('latest-news')[0]
const num_news = 10

// Render all the card
function render_all_news(){
    for(let i = 0; i < num_news; i++){
        // Create the news card
        const card = create_news_card(img_link, header_new, description)

        // Append the card to the news_container
        news_container.appendChild(card)
    }
}

render_all_news()