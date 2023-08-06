function generateItem(name='laptop', price=9999, description='flexible|reasonable price|best price/performance|good battery life'){
    
    var container=document.getElementById('items');
    //product name
    var title=name+'<span id="price" style="float:right">$'+price+'</span>';

    //add to description
    var descriptionCollection=description.split("|");
    var descriptions = '';
    for (var i in descriptionCollection){
        descriptions+=`
            <li>`+descriptionCollection[i]+ `</li>
        `;
    }

    var cardBlock=document.createElement('div');
    cardBlock.className="col-lg-10 col-sm-12 card border-0 bg-light";
    var cardBlockHTML =`
        <div class="row">
            <div class="col-2"><img src="img/laptop-image.png" alt="img" class="rounded" style="width: 9rem;"></div>
            <div class="col-9">
                <div class="card-body ">
                    <h5 class="card-title" id="product-name-price">`+title+`</h5>
                    <ul id="descriptions">
                    `+descriptions+`
                    </ul>
                </div>
                <button type="button" class="btn btn-primary" style="float:right;">Add to cart</button>
            </div>
        </div>
        <hr>

    `;
    cardBlock.innerHTML=cardBlockHTML;
    container.appendChild(cardBlock);

}
