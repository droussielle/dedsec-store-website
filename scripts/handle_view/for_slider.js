const navBoxes = document.querySelectorAll(".pg-nav-box");
const myCarousel = new bootstrap.Carousel(document.getElementById("mySlider"));

// Add event listener for slide change
myCarousel._element.addEventListener("slide.bs.carousel", function (event) {
    // Remove 'bg-black' class from all boxes
    navBoxes.forEach((box) => {
        box.classList.remove("bg-black");
    });

    // Get the index of the active slide and add 'bg-black' class to the corresponding box
    const activeSlideIndex = event.to;
    navBoxes[activeSlideIndex].classList.add("bg-black");
});