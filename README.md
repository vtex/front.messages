# Front Messages


Exemplo de uso:
```javascript
$(document).ready(function(){
	var messsages, messageObj, message;
	messages = new window.vtex.Messages({ajaxError:true});

	messageObj = {
		content: 
			title: 'Erro 1!',
			detail: 'Ocorreu um erro inesperado em nos nossos servidores.'
		type: 'fatal'
	};
	message1 = messages.addMessage(message, true);	
});
```
====

Baixe o repositório e instale as dependências:

```console
npm i -g grunt-cli
npm i
grunt
```

Você poderá vê-lo em ação em `http://localhost:9001/`.

## API

### Messages

<h4 id="Messages()"><code>window.vtex.Messages(customOptions)</code></h4>
<p>Retorna uma instância de Messages.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>customOptions</td>
			<td>object</td>
			<td>{ajaxError:true}</td>
			<td>Passada a opção ajaxError como true, o plugin handle requests AJAX com erro, exibindo um modal de erro com as suas devidas mensagens de erro.</td>
		</tr>
	</tbody>
</table>

<h4 id="messagesArray"><code>.messagesArray</code></h4>
<p>Array onde é guardado todas as mensagens.</p>

<h4 id="addMessage()"><code>.addMessage(message, visible)</code></h4>
<p>Adiciona uma mensagem nova ao objeto de Messages.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>message</td>
			<td>object</td>
			<td><a href="#message">message</a></td>
			<td>Objeto do tipo message descrito abaixo.</td>
		</tr>
		<tr>
			<td>visible</td>
			<td>boolean</td>
			<td><code>true</code></td>
			<td>Caso seja true a mensagem é exibida após a criação. Pode ser passado como param um objeto do tipo <a href="http://api.jquery.com/fadeIn/">fadeIn do jQUery</a></td>
		</tr>
	</tbody>
</table>

### Message

```javascript
// Modelo de Message
{
	id: 'id unico da Message',
	placeholder: 'seletor CSS do local onde será inserido a Message',
	modalPlaceholder: 'seletor CSS do local onde será inserido o Modal',
	template: 'seletor CSS do template da message',
	modalTemplate: 'seletor CSS do template da modal message',
	prefixClassForType: 'prefixo da classe a ser concatenada com o type'
	content:
		title: 'título da message',
		detail: 'mensagem da message'
	type: 'tipo da message (caso seja "fatal", sera exibida como modal)',
	visible: 'caso true a message sera exibida apos ser adicionada',
	usingModal: 'caso seja true sera exibida como modal',
	domElement: 'propriedade que será preenchida com o elemento do DOM da message',
	insertMethod: 'método de inserção da mensagem no placeholder (ex: html, append, prepend, etc)'
}

// Default
{
	id: _.uniqueId('vtex-message-')
	placeholder: '.vtex-message-placeholder'
	modalPlaceholder: 'body'
	template: '.vtex-message-template.vtex-message-template-default'
	modalTemplate: '.vtex-message-template.vtex-message-template-modal-default'
	prefixClassForType: 'alert-'
	content:
		title: ''
		detail: ''
	type: 'info'
	visible: false
	usingModal: false
	domElement: $()
	insertMethod: 'append'
}
```

<h4 id="show()"><code>.show(showOptions)</code></h4>
<p>Exibe a mensagem.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>showOptions</td>
			<td>object</td>
			<td>{duration:500, complete: function(message){console.log(message);}}</td>
			<td>Pode ser passado como parâmetro um objeto do tipo <a href="http://api.jquery.com/fadeIn/">fadeIn do jQuery</a>. Caso seja um Modal, pode ser passado como parâmetro um objeto com callbacks de  <a href="http://twitter.github.io/bootstrap/javascript.html#modals">eventos de Modal do Bootstrap</a>. Em ambos os casos, todas as funções de callback receberão como parametro a instância da message.</td>
		</tr>
	</tbody>
</table>

<h4 id="hide()"><code>.hide(hideOptions)</code></h4>
<p>Esconde a mensagem.</p>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th style="width: 90px;">Param</th>
			<th style="width: 50px;">tipo</th>
			<th style="width: 140px;">exemplo</th>
			<th>descrição</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>hideOptions</td>
			<td>object</td>
			<td>{duration:500, complete: function(message){console.log(message);}}</td>
			<td>Pode ser passado como parâmetro um objeto do tipo <a href="http://api.jquery.com/fadeOut/">fadeOut do jQuery</a>. Caso seja um Modal, pode ser passado como parâmetro um objeto com callbacks de <a href="http://twitter.github.io/bootstrap/javascript.html#modals">eventos de Modal do Bootstrap</a>. Em ambos os casos, todas as funções de callback receberão como parametro a instância da message.</td>
		</tr>
	</tbody>
</table>

<br>

Dependências:
- jQuery
- Bootstrap
- Underscore

------

VTEX - 2013
