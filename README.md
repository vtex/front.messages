# front.Messages

Exemplo de uso:
```javascript
$(document).ready(function(){
	var messsages, message;
	messages = new window.vtex.Messages.getInstance({ajaxError:true});

	message = {
		content: 
			title: 'Erro!',
			detail: 'Ocorreu um erro inesperado em nos nossos servidores.'
		type: 'error'
	};
	
	$(window).trigger('addMessage', message);	
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

<h4 id="Messages()"><code>window.vtex.Messages.getInstance(customOptions)</code></h4>
<p>Retorna a instância de Messages.</p>
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
			<td>{ajaxError:true, placeholder: '.message-placeholder', modalPlaceholder: '.modal-placeholder'}</td>
			<td>Passada a opção ajaxError como true, o plugin handle requests AJAX com erro, exibindo um modal de erro com as suas devidas mensagens de erro.</td>
		</tr>
	</tbody>
</table>

<h4 id="addMessage()"><code>$(window).trigger('addMessage', message, [messageId])</code></h4>
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
			<td>messageId</td>
			<td>String</td>
			<td><code>'Payment-Unauthorized'</code></td>
			<td>Parâmetro opcional, é um identificador para a mensagem, útil para o caso de ser necessário remover essa 
			mensagem no futuro, programaticamente</td>
		</tr>
	</tbody>
</table>

### Message

```javascript
// Modelo de Message
{
	id: 'id unico da Message',
  timeout: 'tempo que a mesagem será exibida, em milisegundos'
	template: 'seletor CSS do template da message',
	modalTemplate: 'seletor CSS do template da modal message',
	prefixClassForType: 'prefixo da classe a ser concatenada com o type'
	content:
		title: 'título da message',
		detail: 'detalhe da message'
	type: 'tipo da message (caso seja "fatal", sera exibida como modal, tipos disponíveis são ["success", "info", "warning", "danger", "fatal", "error"])',
	visible: 'caso true a message sera exibida apos ser adicionada',
	usingModal: 'caso seja true sera exibida como modal',
	domElement: 'propriedade que será preenchida com o elemento do DOM da message',
	insertMethod: 'método de inserção da mensagem no placeholder (ex: html, append, prepend, etc)'
}

// Default
{
	id: _.uniqueId('vtex-front-message-')
	template: '.vtex-front-messages-template'
	modalTemplate: '.vtex-front-messages-modal-template.vtex-front-messages-modal-template-default'
	prefixClassForType: 'vtex-front-messages-type-'
	content:
		title: ''
		detail: ''
	type: 'info'
	visible: true
	usingModal: false
	domElement: $()
	insertMethod: 'append'
}
```

<h4 id="removeMessage()"><code>$(window).trigger('removeMessage', messageId)</code></h4>
<p>Remove a mensagem com o id igual ao solicitado.</p>
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
			<td>messageId</td>
			<td>String</td>
			<td>$(window).trigger('removeMessage', 'Payment-Unauthorized')</td>
			<td>Remove a mensagem cujo id é igual ao messageId enviado como parâmetro</td>
		</tr>
	</tbody>
</table>

<h4 id="removeAllMessages()"><code>$(window).trigger('removeAllMessage' [, booleanIncluded])</code></h4>
<p>Remove todas as mensagens da lista.</p>
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
			<td>booleanIncluded</td>
			<td>Boolean</td>
			<td>$(window).trigger('removeAllMessage', true)</td>
			<td>O parâmetro booleanIncluded define se as mensagens exibidas em modais também devem ser excluídas</td>
		</tr>
	</tbody>
</table>

<br>

Dependências:
- jQuery
- Bootstrap
- Underscore

------

VTEX - 2014