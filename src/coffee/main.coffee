$ ->
	window.messages = new window.vtex.Messages()

	message = 
		content: 
			title: 'Erro 1!'
			detail: 'Ocorreu um erro inesperado nos nossos servidores.'
		type: 'fatal'		
	window.message1 = messages.addMessage(message)

	message = 
		content: 
			title: 'Erro 2'
			detail: 'Ocorreu um erro inesperado nos nossos servidores.'
		type: 'info'		
	window.message2 = messages.addMessage(message)
