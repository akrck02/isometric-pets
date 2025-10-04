extends Node
class_name DependencyDatabase

var _id : String = "runtime"
var _dependencies = {}


## Create a dependency database for a node
static func for_node(id : String) -> DependencyDatabase:
	var guard = DependencyDatabase.new()
	guard._id = id
	return guard


## Add a dependency
func add(key : String, value) -> void:
	_dependencies[key] = value


## Delete a dependency
func remove(key : String) -> void:
	_dependencies.erase(key)


## Check if dependencies are present
func check() -> bool:
	var ok = true
	for dependency_name in _dependencies: 
		if not _dependencies[dependency_name]:
			push_error("Dependency No {name} was not found on {id}".format({ "name": dependency_name, "id" : _id }))
			ok = false
	
	return ok
