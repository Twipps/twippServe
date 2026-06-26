const bgCanvas = document.getElementById("backgroundCanvas");
const ctx = bgCanvas.getContext("2d");
bgCanvas.style.background = "#212121";

// array that contains all the items to be displayed on the screen
var objectStructure = [];

// checking for support from the browser
if (bgCanvas.getContext) {

    console.log("-- Canvas Supported --")
    // begins execution of the infinite loop
    window.requestAnimationFrame(drawFrame);
} else {
    console.log("-- Canvas Unsupported --")
}

class twippSwirly{
    constructor(x, y, width, height, colour, rotationUnitVector, rotationSpeed, angleDegree){
        // despite what I was taught js uses this exclusively
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.colour = colour;
        this.rotationUnitVector = rotationUnitVector;
        this.rotationSpeed = rotationSpeed;
        this.angleDegree = angleDegree;
    }
}

// will need to do checks periodically to see if objects 
// need to be added to mantain effect; gens a varying amount
// of objects on the screen depending on the current size of 
// the screen.
function objectsInit(){
    var objectStructure = [];

    var rect = new twippSwirly(
        window.innerWidth/2 - 50, 
        window.innerHeight/2 - 50, 
        100, 100, "#fff", 1, 
        0, 0);

    objectStructure.push(rect);

    console.log("Display objects initialized")

    return objectStructure;
}

function drawFrame() {
    // this may have to be on a loop
    bgCanvas.width = window.innerWidth;
    bgCanvas.height = window.innerHeight;

    // clear the screen
    //ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

    if (objectStructure.length == 0) {
        // initialize the current items on screen
        // this will also need an evaluation function
        objectStructure = objectsInit();
    }

    // save old state before using it to make changes
    ctx.save();
    ctx.fillStyle = objectStructure[0].colour;
    
    // to rotate the rectangle we translate the canvas state to the
    //  center of the rect perform the rotation then reset
    if (objectStructure[0].angleDegree <= 360) {
        // centering the canvas origin with respect to the square
        ctx.translate(objectStructure[0].x + (0.5 * objectStructure[0].width), objectStructure[0].y + (0.5 * objectStructure[0].height));
        // conversion from degrees to radians and rotate the canvas
        ctx.rotate((Math.PI/180) * (0.2 + objectStructure[0].angleDegree));
        // adding degrees to the current rectangle value
        objectStructure[0].angleDegree += 0.2;
        // console.log(objectStructure[0].angleDegree);
        // returning the canvas to the original origin
        console.log(-(objectStructure[0].x + (0.5 * objectStructure[0].width)) + " " + -(objectStructure[0].y + (0.5 * objectStructure[0].height)));
        ctx.translate(-(objectStructure[0].x + (0.5 * objectStructure[0].width)), -(objectStructure[0].y + (0.5 * objectStructure[0].height)));
    } else {
        objectStructure[0].angleDegree = 0;
    }

    for (let i = 0; i < objectStructure.length; i++) {
        ctx.fillRect(objectStructure[i].x, objectStructure[i].y,
            objectStructure[i].width, objectStructure[i].height)
    }

    // restoring the previously saved state to prepare the canvas for the next change
    ctx.restore(); 

    window.requestAnimationFrame(drawFrame);
}