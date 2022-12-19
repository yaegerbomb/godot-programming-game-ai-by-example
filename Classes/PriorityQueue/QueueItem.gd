extends Node

# A simple class to store an item and its priority
class_name QueueItem

var item
var priority

# Constructor for QueueItem
func init(i, p):
	self.item = i
	self.priority = p
