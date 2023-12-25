# GPU-Pathfinding
Radiosity-Based GPU distance/vewctor field for pathfinding using modified Global Illumination techniques.

<p align="center">
  <img src="https://i.imgur.com/kXftpc0.gif" />
</p>

### Radiosity Based GPU Pathfinding
The goal of this pathfinding method is to leverage the GPU for pathfinding tasks, usually when you have a low GPU overhead and a high CPU overhead. This is a radiosity-based method, mimicking GI using its wave propogation properties. Instead of spreading light throughout the scene we spread out the "nearest distance" to the target. This is performed in passes using jumpflooding.

Here are the steps:
```
1. Create 6 render images/textures/surfaces (whatever your engine calls them).
  1.1. Jumpflood, Transfer, WorldScene, WorldScene_SDF, Pathfind_SDF[0], Pathfind_SDF[1].
  1.2. Define a BOOL variable "swapframe". This will toggle on and off each iteration of the algorithm to swap render images between Pathfind_SDF[0] and Pathfind_SDF[1].
2. Render all of your colliders to the WorldScene image as [BLACK, ALPHA 1.0] and then render your target as [COLOR, ALPHA 1].
    The distinction here is that BLACK is reserved for walls and non-black COLOR pixels are reserved for the pathfinding target.
3. Using the Shd_VectorFieldSeeding shader, draw your WorldScene image to the Pathfind_SDF[1 - swapframe] and Pathfind_SDF[swapframe] image.
    The shader uses the COLOR pixels from the WorldScene image to generate the pathfinding seed to look for.
4. DISABLE ALPHA BLENDING (this step is required, not optional).
5. Render the JFA of the Pathfind_SDF[1 - swapframe] image.
    Since the shader swaps-render targets we are rendering to the current target and using the previous (1 - swapframe) as our input target image.
6. Render the SDF of the PathFind_SDF[1 - swapframe] to the WorldSceneSDF image.
7. Using the Shd_VectorField shader, render the Pathfind_SDF[1 - swapframe] image to the output Pathfind_SDF[swapframe] image.
    Again the Pathfind_SDF[1 - swapframe] is always our input image from the previous frame.
8. Repeat steps 5, 6 and 7 for N iterations if you want to complete the pathfinding in a single game frame.
```
Okay so why does this work?

The point of JumpFlooding is that it generates an SDF (distance field) of the image we give it, where any pixel with zero alpha is empty space and pixels with one alpha are colliders.

This algorithm exploits this by performing raymarching from each pixel out in 4 directions (up/down/left/right) and looks for seeded target pixels. If the a pixel does find a seeded target pixel it turns itself into a seeded target pixel storing the distance of the target pixels + its distance to the target pixel encoded as a 2-byte RG color. Then on the next frame, the previous render is passed as our seeded input, when the JFA/SDF are generated from the previous scene. Our target pixels are now all of the pixels from the previous pass that located the target and turned themselves into targets. You can see this happen in the GIF above. We repeat this process some pre-defined N times until our pathfinding image is complete.

The pathfinding image is represented as an image of pixels where each pixel stores its manhatten distance away from the target. If you sample any 9 pixels, the distances will be oriented in a way that they point towards the target where pixels with larger distances being further away and pixels with smaller distances being closer.
