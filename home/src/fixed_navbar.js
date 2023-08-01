// Function to check if the header is out of view
function isHeaderOutOfView() {
    const header = document.getElementsByClassName('header')[0];
    const headerRect = header.getBoundingClientRect();
    return headerRect.bottom <= 0;
}

// Function to handle navbar position based on header visibility
function handleNavbarPosition() {
const navbar = document.getElementsByClassName('navbar')[0];
const isHeaderVisible = !isHeaderOutOfView();
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