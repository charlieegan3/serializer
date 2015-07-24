function keyDown(e) {
  if (e.keyCode == 16) { shift_down = true; }
}

function keyUp(e) {
  if (e.keyCode == 16) { shift_down = false; }
  if (e.keyCode == 65 && shift_down) {
    document.getElementsByClassName('log-button')[0].click();
  }
}

var shift_down = false;
document.addEventListener('keydown', keyDown, false);
document.addEventListener('keyup', keyUp, false);
