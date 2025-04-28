resourceName = null;
deathScreenOpen = false;
clickTimer = 5;
deathcause = null
accent_colour = ""
window.addEventListener('message', function(event) {
    ed = event.data;
	if (ed.action === "DSMenu") {
		if (ed.open === true) {
			resourceName = ed.resourceName;
			deathScreenOpen = true;
            showElement()
            deathcause = ed.deadtype
            if (deathcause === "knockout") {
                document.getElementById("MDDeathText").innerHTML="You are Knocked Out. Please wait for Someone, everything will be fine.";
                document.getElementById("DeathTitle").innerHTML="You are Knocked Out";
                startTimer(30);
                } else {
                    document.getElementById("MDDeathText").innerHTML="You are incapacitated. Please wait for doctors, everything will be fine.";
                    document.getElementById("DeathTitle").innerHTML="You are incapacitated.";
                    startTimer(80);
                }
		} else {
			deathScreenOpen = false;
            hideElement()
            if (deathcause === "knockout") {
            document.getElementById("MDDeathText").innerHTML="You are Knocked Out. Please wait for Someone, everything will be fine.";
            document.getElementById("DeathTitle").innerHTML="You are Knocked Out";
            } else {
                document.getElementById("MDDeathText").innerHTML="You are incapacitated. Please wait for doctors, everything will be fine.";
                document.getElementById("DeathTitle").innerHTML="You are incapacitated.";
            }
            clearInterval(timerInt);
            deathcause = null
		}
	} else if (ed.action === "res") {
        document.getElementById("MDDeathText").innerHTML="Press <span style='color: #1e81db;'>E</span> <span id='MDDTResText' style='color: #1e81db;'>(5)</span> to respawn or wait for the <span style='color: #1e81db;'>EMS</span>";
    } else if (ed.action === "updateRes") {
        document.getElementById("MDDTResText").innerHTML=`(${ed.time})`;
        if (ed.time === 0) {
            deathScreenOpen = false;
            hideElement()
            if (deathcause === "knockout") {
                document.getElementById("MDDeathText").innerHTML="You are Knocked Out. Please wait for Someone, everything will be fine.";
                } else {
                    document.getElementById("MDDeathText").innerHTML="You are incapacitated. Please wait for doctors, everything will be fine.";
                }
                deathcause = null
            clearInterval(timerInt);
        }
    } else if (ed.action === "updatecolor") {
        var deathTitle = document.getElementById("DeathTitle");

        function lightenColor(rgb, percent) {
            var r = Math.min(255, Math.floor(rgb.r + (255 - rgb.r) * percent));
            var g = Math.min(255, Math.floor(rgb.g + (255 - rgb.g) * percent));
            var b = Math.min(255, Math.floor(rgb.b + (255 - rgb.b) * percent));
            return { r: r, g: g, b: b };
        }

        var rgbString = ed.color;
        var rgbValues = rgbString.match(/\d+/g);
        var color = {
            r: parseInt(rgbValues[0]),
            g: parseInt(rgbValues[1]),
            b: parseInt(rgbValues[2])
        };
    
        var lightColor = lightenColor(color, 0.5);
    
        deathTitle.style.textShadow = "0px 0px 20px rgb(" + lightColor.r + "," + lightColor.g + "," + lightColor.b + ")";
        deathTitle.style.background = "linear-gradient(90deg, rgb(" + lightColor.r + "," + lightColor.g + "," + lightColor.b + ") 25.87%, rgb(" + (lightColor.r - 30) + "," + (lightColor.g - 30) + "," + (lightColor.b - 30) + ") 56.93%, rgb(" + (lightColor.r - 60) + "," + (lightColor.g - 60) + "," + (lightColor.b - 60) + ") 86.71%)";
        deathTitle.style.backgroundClip = "text";
        deathTitle.style.webkitBackgroundClip = "text";
        deathTitle.style.webkitTextFillColor = "transparent";
        accent_colour = "rgb(" + lightColor.r + "," + lightColor.g + "," + lightColor.b + ")";

        var imageElement = document.getElementById("DeathImage");
        recolorImage(imageElement, color)
    }
})

function recolorImage(imageElement, targetColor) {
    var canvas = document.createElement('canvas');
    var ctx = canvas.getContext('2d');
    
    // Set canvas dimensions
    canvas.width = imageElement.width;
    canvas.height = imageElement.height;
    
    // Draw the image on the canvas
    ctx.drawImage(imageElement, 0, 0);
    
    var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    var data = imageData.data;

    // Recolor the image
    for (var i = 0; i < data.length; i += 4) {
        data[i] = targetColor.r;
        data[i + 1] = targetColor.g;
        data[i + 2] = targetColor.b;
    }

    ctx.putImageData(imageData, 0, 0);
    imageElement.src = canvas.toDataURL();
}

function showElement() {
    var element = document.getElementById("body");
    element.style.display = "block";
    setTimeout(function() {
      element.style.opacity = 1;
    }, 10);
  }
  
  function hideElement() {
    var element = document.getElementById("body");
    element.style.opacity = 0;
    setTimeout(function() {
      document.getElementById("body").style.display = "none";
    }, 800);
  }
  
function startTimer(duration) {
    var timer = duration, minutes, seconds;
    timerInt = setInterval(function() {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        document.getElementById("MDCDivMinuteFirst").innerHTML=minutes.toString()[0];
        document.getElementById("MDCDivMinuteSecond").innerHTML=minutes.toString()[1];
        document.getElementById("MDCDivSecondFirst").innerHTML=seconds.toString()[0];
        document.getElementById("MDCDivSecondSecond").innerHTML=seconds.toString()[1];
        if (--timer < 0) {
            clearInterval(timerInt);
            if (deathcause === "knockout") {
                document.getElementById("MDDeathText").innerHTML="Press <span style='color: "+accent_colour+";'>Q</span> to revive or wait for someone to <span style='color: "+accent_colour+";'>help</span> you up.";
            } else {
                document.getElementById("MDDeathText").innerHTML="Press <span style='color: "+accent_colour+";'>E</span> to respawn or wait for the <span style='color: "+accent_colour+";'>EMS</span>";
            }
            
            fetch(`https://${GetParentResourceName()}/response`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                }
            })

        }
    }, 1000);
}