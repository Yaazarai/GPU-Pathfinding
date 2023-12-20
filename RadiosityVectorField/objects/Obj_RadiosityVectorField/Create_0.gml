mx = 0.0;
my = 0.0;

/// LIGHTING SETTINGS:
game_set_speed(144, gamespeed_fps);
global.rvfp_resolution = 1024.0;
global.rvfp_swapframe = 0.0;
global.rvfp_frametime = 0.0;
global.rvfp_usedebuginterface = true;
global.rvfp_iterations = 15;
/// LIGHTING SHADERS & INITIALIZATION:
rvfp_defaultshaders();
rvfp_initialize();

/// USER GAME WORLD SURFACES:
#macro INVALID_SURFACE -1

/// UTILITY SURFACES:
gameworld_transfer = INVALID_SURFACE;
gameworld_jumpflood = INVALID_SURFACE;

/// RENDER SURFACES
gameworld_worldscene = INVALID_SURFACE;
gameworld_worldsceneSDF = INVALID_SURFACE;
gameworld_rvfpsurface[0] = INVALID_SURFACE;
gameworld_rvfpsurface[1] = INVALID_SURFACE;