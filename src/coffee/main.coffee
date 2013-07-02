$ ->
	window.messages = new window.vtex.Messages({ajaxError:true})

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

	$.ajax("http://staples.vtexlocal.com.br/Site/OutrasFormasPagamento.aspx?IdSku=2008124&PopupComum=true")
