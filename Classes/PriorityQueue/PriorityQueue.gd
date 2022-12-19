extends Node

# The priority queue class
class_name PriorityQueue

# Initialize an empty queue
var queue = []

# Insert an item into the queue with a given priority
func insert(item, priority):
	var queue_item = QueueItem.new()
	queue_item.init(item, priority)
	queue.append(queue_item)
	
	# Sort the queue so that items with higher priority are at the front
	queue.sort_custom(CustomSorters.new(), "sort_priority_queue")
		
# Remove and return the next item in the queue (the one with the highest priority)
func pop():
	if queue.size() == 0:
		return
	else:
		return queue.pop_back().item

# Return the size of the queue
func size():
	return queue.size()
	
func next():
	return queue.back().item
