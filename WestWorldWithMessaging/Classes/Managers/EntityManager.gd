extends Node

class_name EntityManager

var entity_map

func init():
	entity_map = {}
	
func get_entity_from_id(id: int):
	return entity_map[id]
	
func remove_entity(entity: BaseGameEntity):
	entity_map.erase(entity.get_id())
	
func register_entity(new_entity: BaseGameEntity):
	entity_map[new_entity.get_id()] = new_entity
