if (!surface_exists(gameworld_worldscene)) gameworld_worldscene = surface_create(global.rvfp_resolution,global.rvfp_resolution);
if (!surface_exists(gameworld_transfer)) gameworld_transfer = surface_create(global.rvfp_resolution,global.rvfp_resolution);
if (!surface_exists(gameworld_jumpflood)) gameworld_jumpflood = surface_create(global.rvfp_resolution,global.rvfp_resolution);
if (!surface_exists(gameworld_worldsceneSDF)) gameworld_worldsceneSDF = surface_create(global.rvfp_resolution,global.rvfp_resolution);
if (!surface_exists(gameworld_rvfpsurface[0])) gameworld_rvfpsurface[0] =  surface_create(global.rvfp_resolution,global.rvfp_resolution);
if (!surface_exists(gameworld_rvfpsurface[1])) gameworld_rvfpsurface[1] =  surface_create(global.rvfp_resolution,global.rvfp_resolution);