// Small script to create a counter for the years to be displayed in the webapp


AFRAME.registerComponent("counter", {
  schema: {
    // Define Position of the counter
    position: { type: "vec3", default: { x: -0, y: 1.4, z: -2.2 } }, 
    // Defines Start Value
    value: { type: "int", default: 1211 }, 
  },

  init: function () {
    this.counter1 = document.createElement("a-text");
    this.el.appendChild(this.counter1);
    this.counter1.setAttribute("position", this.data.position);
    // Set the start time for the counter
    this.startTime = new Date().getTime();
  },
  // Every frame, update the counter
  tick: function () {
    this.counter1.setAttribute("value", this.getValue());
  },
  // Increase the Counter by one every second
  getValue: function () {
    // Get the current time
    let currentDate = new Date().getTime();
    // Calculate the current value of the counter based on the start time and current time
    let counter_value = parseInt(
      (this.startTime - currentDate) / -1000 + 1311
    );
    // The end of application only has data till the year 200 - that is why we ignore higher values
    if (counter_value > 2000) {
      return 2000;
    } else {
      // Otherwise, return the calculated counter value
      return counter_value;
    }
  },
});

