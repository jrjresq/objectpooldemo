extends Node
# object pool class

var instances : Dictionary = {}

func instance(scene : PackedScene) -> Node:
	var existing_instances = instances.get(scene, null)

	if existing_instances:
		var new_instance = existing_instances.pop_back()

		# if the instance is invalid, keep popping back until it is valid. otherwise, make a new instance
		if not is_instance_valid(new_instance):
			if existing_instances.size() <= 0:
				instances.erase(scene)
			return instance(scene)

		if existing_instances.size() <= 0:
			instances.erase(scene)
			
		if "prepare" in new_instance:
			new_instance.prepare()
		
		if "pool_handle" in new_instance:
			new_instance.pool_handle = scene

		return new_instance

	else:
		var new_instance = scene.instantiate()
		
		if "prepare" in new_instance:
			new_instance.prepare()
			
		if "pool_handle" in new_instance:
			new_instance.pool_handle = scene
			
		return new_instance

func free_instance(old_instance : Node, pool_handle : PackedScene = null) -> void:
	if "scrub" in old_instance:
		old_instance.scrub()

	
	var scene : PackedScene
	
	if "pool_handle" in old_instance:
		scene = old_instance.pool_handle
	else:
		assert(pool_handle, "Pool handle not provided")
		scene = pool_handle
	
	var existing_instances = instances.get(scene, null)

	if existing_instances:
		existing_instances.append(old_instance)
	else:
		instances[scene] = [old_instance]
