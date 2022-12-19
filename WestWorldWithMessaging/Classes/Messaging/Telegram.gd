class_name Telegram

const smallest_delate: float = 0.25

var sender: int
var receiver: int
var message: int
var dispatch_time: float
var additional_info

func init():
	sender = -1
	receiver = -1
	message = -1
	dispatch_time = -1
	
func init_v(s, r, m, d_t, a_i):
	sender = s
	receiver = r
	message = m
	dispatch_time = d_t
	additional_info = a_i
