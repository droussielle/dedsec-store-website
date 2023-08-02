// Function to check if the header is out of view
function isHeaderOutOfView() {
    const header = document.getElementsByClassName('header')[0];
    const headerRect = header.getBoundingClientRect();
    return headerRect.bottom <= 0;
}

function get_visible_header() {
    const header = document.getElementsByClassName('header')[0];
    const headerRect = header.getBoundingClientRect();
    return headerRect.bottom;
}

// Function to handle navbar position based on header visibility
function handleNavbarPosition() {
    const navbar = document.getElementsByClassName('big-navigation')[0];
    const isHeaderVisible = !isHeaderOutOfView();
    const length = get_visible_header();
    

    if (isHeaderVisible) {
        navbar.classList.remove('fixed-top');
    } else {
        navbar.classList.add('fixed-top');
    }
    
}

// Add event listener for scroll event to handle navbar position
document.addEventListener('scroll', handleNavbarPosition);

// Initially call the handleNavbarPosition function to set the initial position
handleNavbarPosition();


// Get fields
let search_fields = document.getElementById('search-fields')
let cart_fields = document.getElementById('cart-fields')
let toggle_fields = document.getElementById('navbarSupportedContent')

function close_expand_single(field1){

    const isExpand = field1.classList.contains('show')
    if (!isExpand) return
    field1.classList.remove('show')
}
function close_expand(field1, field2){
    close_expand_single(field1)
    close_expand_single(field2)
}

function getCurrentScreenSize() {
    const screenWidth = window.innerWidth;
    
    if (screenWidth >= 768) {
      return "md"; // Medium screens (>= 768px)
    } else if (screenWidth >= 576) {
      return "sm"; // Small screens (>= 576px)
    } else {
      return "xs"; // Extra Small screens (< 576px)
    }
} 

toggle_fields.addEventListener('show.bs.collapse', () => {
    close_expand(search_fields, cart_fields);
});

search_fields.addEventListener('show.bs.collapse', () => {
    close_expand(toggle_fields, cart_fields);

    const screenWidth = getCurrentScreenSize();
    if (screenWidth != "md"){
        close_expand_single(search_fields)
    }
});

cart_fields.addEventListener('show.bs.collapse', () => {
    close_expand(search_fields, toggle_fields);
});

