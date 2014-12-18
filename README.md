# SceneKit — OpenGL Shaders

This is a project demo to test adding shader fragments to models rendered in
SceneKit, using the [`shaderModifiers` attribute in the SCNShadable protocol](https://developer.apple.com/library/mac/documentation/SceneKit/Reference/SCNShadable_Protocol/index.html). It's a small and digestable, a good starting point for adding new shader fragments or copying setup / shader bits into another project.


Some of the shaders are taken/modified from the WWDC 2014 SceneKit Slides. A couple have been slightly modified to work on iOS (uniform values were disallowed in the iOS version to my knowledge).

This was the final project for the Computer Graphics class at [Southern Adventist University](http://www1.southern.edu/academics/computing.html). [The original class presentation slides](http://beisiegel.me/files/SceneKitShaders.pdf) are a good introduction to SceneKit and  `shaderModifiers`, aimed at intermediate level graphics / OpenGL students.

![GL Shaders ScreenShot](https://cloud.githubusercontent.com/assets/1911028/5490362/ec5cde5e-869e-11e4-9d68-334688702f58.PNG)

## Extending the demo

Simply include more models and shaders by including in the project and modifying the Settings.swift file with another appropriate settings object.

### Model

Provide a new `ModelSettingItem` in the `ModelSettings` array with either a SceneKit node or grab a node from an included `.dae` file.

```
// SceneKit node (using class function to generate)
ModelSettingItem(modelData: ModelData(name: "Cube", node: AllSettings.cubeNode()))

// Grab a node in a .dae file from art.scnassets
ModelSettingItem(modelData: ModelData(filename: "ship", nodeName: "shipMesh"))
```

### Shaders

Add a shader fragment with extension `.shader` and include it in the appropriate shader settings array.

```
// Include sm_geom.shader file and make setting object for it
ShaderSettingItem(shaderData: ShaderData(filename: "sm_geom"))
```
