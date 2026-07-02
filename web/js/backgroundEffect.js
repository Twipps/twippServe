const bgCanvas = document.getElementById("backgroundCanvas");
const ctx = bgCanvas.getContext("2d");
bgCanvas.style.background = "#212121";

// if the context returns false that means the browser doesnt support the canvas object
if (bgCanvas.getContext) {

    console.log("-- Canvas Supported --")
    // begins execution of the infinite loop
    window.requestAnimationFrame(drawFrame);
} else {
    console.log("-- Canvas Unsupported --")
}

// array that contains all the items to be displayed at the foreground of the canvas
var fgObjects = [];
var bgObjects = [];

// seperate from particles, organicly shaped background elements for spacial feeling;
class organic{
    constructor(x, y, colour, gradientColor){
       this.x = x;
       this.y = y;
       this.colour = colour; 
       this.gradientColor = gradientColor;
    }
}

// each particle type will have its own collider type; defining the bounds
class collider{

}
class particle{
    constructor(x, y, 
        rotationUnitVector, rotationSpeed, angleDegree, 
        velocityX, velocityY, mass, gravity, accelerationX, accelerationY, 
        amplitudeX, amplitudeY){

        // position on the screen
        this.x = x;
        this.y = y;

        // values to define rotational movement
        this.rotationUnitVector = rotationUnitVector;
        this.rotationSpeed = rotationSpeed;
        this.angleDegree = angleDegree;

        // values to define general movement
        this.velocityX = velocityX;
        this.velocityY = velocityY;
        this.accelerationX = accelerationX;
        this.accelerationY = accelerationY;
        this.mass = mass;
        this.gravity = gravity;

        // tragectory amplitude; I want each tragecotry to have a settable sin() offset
        this.amplitudeX = amplitudeX;
        this.amplitudeY = amplitudeY;
    }
}

// these will have different collision boxes maybe.
// with collisions i want there to be hard collids and 
// a soft collide that slowly changes the tragectory, 
// if a particle crosses into a html padding or marigins
class swirlyCollider extends collider{

}
class swirly extends particle(width, height, colour){
    constructor(width, height, colour){
       super();

       this.width = width;
       this.height = height;
       this.colour = colour; 
    }

    // draws the particle based on its internal values;
    drawParticle(){};
    // this will be used to update the stored values of the particle when things happen
    updateParticle(){};
}

class plusCollider extends collider{
    
}
class plus extends particle{
    drawParticle(){};
    updateParticle(){};
}

class halfSwirlyCollider extends collider{

}
class halfSwirly extends particle{
    drawParticle(){};
    updateParticle(){};
}

// an object that's has properties to push back on particles getting close to is; like reversed polarity
class forceField{

}

var activeCollisions = [];
var nearForceField = [];

// an algorithm for collision detection; gets activeCollisions;
function sortSweep(){}

// calculates the numbers for the collisions taking place; updates the particles for their next draw
function settleCollisions(){}

// depending on how close an object is to a force field determinds how much it pushes the velocity back in the other direction
function settleForceFields(){}

// when a particle is clicked on and dragged around
function settleDrag(){}

// while the user scrolls the particles will stay consitent to their position on the canvas, but the canvas will scroll
function scrollOffset(){}

// adds or removes particles depending on the size of the screen; maybe new particles can fade in
function objectBalance() {}

// first init at start up; generation depends on the current size of the screen
function objectsInit(){
    var objectStructure = [];

    var rect = new swirly(
        window.innerWidth/2 - 50, 
        window.innerHeight/2 - 50, 
        100, 100, "#fff", 1, 
        0, 0);

    objectStructure.push(rect);

    console.log("Display objects initialized")

    return objectStructure;
}

// responsible for executing everything necessariy to draw a frame
function drawFrame() {
    // this may have to be on a loop
    bgCanvas.width = window.innerWidth;
    bgCanvas.height = window.innerHeight;

    // clear the screen
    //ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

    if (fgObjects.length == 0) {
        // initialize the current items on screen
        // this will also need an evaluation function
        fgObjects = objectsInit();
    }

    window.requestAnimationFrame(drawFrame);
}

// will need to do checks periodically to see if objects 
// need to be added to mantain effect; gens a varying amount
// of objects on the screen depending on the current size of 
// the screen.

/*
have two object structures renders. swirls in the front, then darker backrgound
shapes in the background that scroll slower with the page
*/

/* [first rotation and drawing test]
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
*/