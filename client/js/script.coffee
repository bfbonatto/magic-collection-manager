#Auxiliary class that defines a dictionary
class Dictionary
	#creates empty dictionary
	constructor: () ->
		@keys = []
		@data = []
	#adds key value pair to dictionary
	add: (key,data) ->
		@keys.push(key)
		@data.push(data)
	#returns the value associated with @key, requires that the arrays remain in order
	get: (key) ->
		return @data[i] for i in [0..@keys.length-1] when @keys[i] is key
	#sets the value associated with @key to @data, same as get 
	set: (key,data) ->
		@data[i] = data for i in [0..@keys.length-1] when @keys[i] is key
	#returns the list of all keys
	list_keys: () ->
		return @keys
		
class TRE_Node
	constructor: (@name,@qt) ->
		@next = new Dictionary
		@next.add(l,null) for l in ['a','b','c','d','e','f','g','h','i','j','k',
		'l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C',
		'D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U',
		'V','W','X','Y','Z',"'",' ',',']
		
class TRE_Tree
	constructor: () ->
		@root = new TRE_Node("",-1)
		
	get: (card_name) ->
		actual = @root
		for l in card_name
			if not actual.next.get(l)?
				new_node = new TRE_Node(actual.name+l,0)
				actual.next.set(l,new_node)
			actual = actual.next.get(l)
		return actual
	
	set: (card_name,card_qt) ->
		@get(card_name).qt = card_qt
	
	add: (card_name,card_qt) ->
		console.log card_name
		@get(card_name).qt += card_qt
		
	remove: (card_name,card_qt) ->
		aux = @get card_name
		aux.qt -= card_qt
		aux.qt = 0 if aux.qt < 0
		
	list_r: (current,sep) ->
		return [] if not current?
		result = []
		result.push(current.name + sep + current.qt) if current.qt > 0
		for c in current.next.list_keys()
			aux = @list_r(current.next.get(c),sep)
			result.push(e) for e in aux
		return result
		
	list: (card_prefix,sep,sp=' ') ->
		actual = @get(card_prefix)
		aux = ""
		aux += e + sep for e in @list_r(actual,sp)
		return aux
		

###
----------------------------------------
HTML Controller
----------------------------------------
###

$(document).ready(() ->
	
	tree = new TRE_Tree()
	
	socket = io()
	
	
	
	add_button = $("#add_button")
	remove_button = $("#remove_button")
	save_button = $("#save_button")
	load_button = $("#load_button")
	display = $("#collection_display")
	name_field = $("#card_name")
	login_button = $("#login_button")
	
	login_button_click = ()-> 
		username = prompt("Type in your username","username")
		$("#login").attr("logged_in","true")
		$("#login").attr("username",username)
		
	login_button.on("click",login_button_click)
		
	
	add_button_click = () ->
		card_name = name_field.val()
		console.log card_name
		tree.add(card_name,1)
		display.html(tree.list(name_field.val(),"<br>"))
	
	remove_button_click = () ->
		card_name = name_field.text
		tree.remove(card_name,1)
		display.html(tree.list(name_field.val(),"<br>"))
	
	
		
	add_button.on("click",add_button_click)
	remove_button.on("click",remove_button_click)
	
	save_button.on("click",() ->
		if $("#login").attr("logged_in") isnt "true"
			login_button_click()
		socket.emit("save",tree.list('',';',','),$("#login").attr("username")))
		
		
	load_button.on("click",() ->
		if $("#login").attr("logged_in") isnt "true"
			login_button_click()
		socket.emit("load",$("#login").attr("username")))
		
	
	name_field.on("keyup",() ->
		display.html(tree.list(name_field.val(),"<br>")))
		
		
	socket.on("return_load",(data) ->
		(cards = data.split(';')).pop()
		tree.set((card.split(',')[0]),parseInt(card.split(',')[1],10)) for card in cards
		display.html(tree.list('',"<br>")))
)