extends Node

# Engine signals
@warning_ignore("unused_signal") signal scene_change_requested(scene : String) 
@warning_ignore("unused_signal") signal tilemap_changed(tilemap : TileMap)

# Time signals
@warning_ignore("unused_signal") signal night_started()
@warning_ignore("unused_signal") signal day_started()
@warning_ignore("unused_signal") signal tick_reached()

# Visual effects
@warning_ignore("unused_signal") signal notification_shown(message : String)
@warning_ignore("unused_signal") signal notification_hidden()
@warning_ignore("unused_signal") signal outline(value:bool)
@warning_ignore("unused_signal") signal environment_changed(type : Environments.Type)

# Camera signals
@warning_ignore("unused_signal") signal camera_movement_updated(value : bool)

# Dino run minigame signals
@warning_ignore("unused_signal") signal dinorun_update_score
@warning_ignore("unused_signal") signal dinorun_finished
