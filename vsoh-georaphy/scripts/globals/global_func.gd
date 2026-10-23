extends Node

func stack_trace():
	print_rich("[b]|----------STACK TRACE----------|[/b]")
	var stack = get_stack()
	for i in range(stack.size()):
		if i <= 0:
			continue
		print_rich("|	",i - 1, ".	", stack[i])

#func call_trace(): Это потом.
	#print_rich("[b]|----------CALL TRACE----------|[/b]")
	#var calls = get_signal_list()
