extends Node

# Visual effects
@warning_ignore("unused_signal") signal notification_shown(message : String)
@warning_ignore("unused_signal") signal notification_hidden()
@warning_ignore("unused_signal") signal outline(value:bool)
@warning_ignore("unused_signal") signal environment_changed(type : Environments.Type)

# Camera signals
@warning_ignore("unused_signal") signal camera_movement_updated(value : bool)
