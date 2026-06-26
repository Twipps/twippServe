const bgCanvas = document.getElementById("backgroundCanvas");

// checking for support from the browser
if (bgCanvas.getContext) {
    // getting a 2d canvas context
    const ctx = bgCanvas.getContext("2d");

    bgCanvas.style.background = "#212121";

    // this may have to be on a loop
    bgCanvas.width = window.innerWidth;
    bgCanvas.height = window.innerHeight;

    ctx.fillStyle = "rgb(200 0 0)";
    ctx.fillRect(10, 10, 50, 50);
}