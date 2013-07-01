# VTEX Message


Exemplo de uso:
```javascript
$(document).ready(function(){
	var messsages, messageObj, message;
	messages = new window.vtex.Messages();

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

<h4 id="Messages()"><code>window.vtex.Messages()</code></h4>
<p>Retorna uma instância de Messages.</p>

<h4 id="messagesArray"><code>.messagesArray</code></h4>
<p>Array onde é guardado todas as mensagens.</p>

<h4 id="addMessage"><code>.addMessage(message, visible)</code></h4>
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
			<td></td>
		</tr>
		<tr>
			<td>visible</td>
			<td>boolean</td>
			<td><code>true</code></td>
			<td></td>
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



<br>

Dependências:
- jQuery
- Bootstrap
- Underscore

------

VTEX - 2013