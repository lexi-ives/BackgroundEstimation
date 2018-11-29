# BackgroundEstimation

### Objective
- Remove objects from image(s)
- Fill the hole(s) with information extracted from the image(s)
- Filled region should look realistic to the human eye

### Methods
- Capture a sequence of grayscale images from a static camera
- Perform clustering on each frame
- Largest cluster with the mode intensity is chosen as the initial background
- Perform edge detection to estimate features of remaining image
- Estimate remaining background using a distance algorithm to determine pixels that haven’t been assigned to a specific cluster
