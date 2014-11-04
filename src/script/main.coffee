$ ->
	window.messages = new window.vtex.Messages.getInstance({ajaxError:true})

	message = 
		content: 
			title: 'Erro 1!'
			detail: 'Ocorreu um erro inesperado nos nossos servidores.'
		type: 'fatal'

	modalOpts = 
		'shown': (m) => 
			console.log("Mostrei", $('.btn',m.domElement))
			$('.btn',m.domElement).focus()
	
	window.message1 = messages.addMessage(message, modalOpts)

	message = 
		content: 
			title: 'Erro 2'
			detail: 'Ocorreu um erro inesperado nos nossos servidores.'
		type: 'error'
		time: 4000

	window.message2 = messages.addMessage(message, true)

	#$.ajax("http://staples.vtexlocal.com.br/Site/OutrasFormasPagamento.aspx?IdSku=2008124&PopupComum=true")