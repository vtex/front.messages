root = exports ? window
window.vtex = window.vtex or {}

###*
# Classe Message, que representa uma mensagem
# @class Message
# @constructor
###
class Message
	constructor: (options = {}) ->
		@classes =			
			TEMPLATEDEFAULT: '.vtex-message-template.vtex-message-template-default'
			MODALTEMPLATEDEFAULT: '.vtex-message-template.vtex-message-template-modal-default'
			TEMPLATE: 'vtex-front-messager-container'
			TITLE: '.vtex-front-message-title'
			SEPARATOR: '.vtex-front-message-separator'
			DETAIL: '.vtex-front-message-detail'
			TYPE: 'vtex-front-message-type-'
			MESSAGEINSTANCE: 'vtex-front-message-instance'

		defaultProperties =
			id: _.uniqueId('vtex-message-')
			template: @classes.TEMPLATE
			timeout: 0
			modalTemplate: @classes.MODALTEMPLATE
			prefixClassForType: @classes.TYPE
			content:
				title: ''
				detail: ''
			close: 'Close'
			type: 'info'
			visible: false
			usingModal: false
			domElement: $()
			insertMethod: 'append'
		_.extend(@, defaultProperties, options)

		modalDefaultTemplate = """
		<div class="vtex-message-template vtex-message-template-modal-default modal hide fade">
			<div class="modal-header">
				<h3 class="vtex-message-title"></h3>
			</div>
			<div class="modal-body">
				<p class="vtex-message-detail"></p>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">"""+@close+"""</button>
			</div>
		</div>
		"""

		defaultTemplate = """
		<div class="vtex-front-message-container">
		<div class="vtex-front-message-template vtex-front-message-template-default static-front-message-template">
			<span class="vtex-front-message-title"></span><span class="vtex-front-message-separator"> - </span><span 			class="vtex-front-message-detail"></span>
		</div>
		</div>
		"""

		if @type is 'fatal' then @usingModal = true

		if @usingModal
			if not $(vtex.Messages.getInstance().placeholder)[0] then throw new Error("Couldn't find placeholder for modal Message")
			
			if @modalTemplate is @classes.MODALTEMPLATE
				@modalTemplate = modalDefaultTemplate
			else
				if not $(@modalTemplate)[0] then throw new Error("Couldn't find specified template for modal Message")

			@domElement = $(@modalTemplate)
		else
			if not $(vtex.Messages.getInstance().placeholder)[0] then throw new Error("Couldn't find placeholder for Message")

			if @template is @classes.TEMPLATE
				@template = defaultTemplate
			else
				if not $(@template)[0] then throw new Error("Couldn't find specified template for Message")

			@domElement = $(@template).clone(false, false)
			$(@domElement).bind 'closed', => @visible = false

		#$(@domElement).removeClass(@classes.TEMPLATE)
		$(@domElement).find(".vtex-front-message-template").addClass(@id + " " + @classes.MESSAGEINSTANCE + " " + @classes.TYPE + @type)
		$(@domElement).hide()
		$(@domElement).data('vtex-message', @)
		if @content.html
			if @content.title and @content.title isnt ''
				$(@classes.TITLE, @domElement).html(@content.title)
			else
				$(@classes.TITLE, @domElement).hide()
				$(@classes.SEPARATOR, @domElement).hide()
			$(@classes.DETAIL, @domElement).html(@content.detail)
		else		
			if @content.title and @content.title isnt ''
				$(@classes.TITLE, @domElement).text(@content.title)
			else
				$(@classes.TITLE, @domElement).hide()
				$(@classes.SEPARATOR, @domElement).hide()
			$(@classes.DETAIL, @domElement).text(@content.detail)

		if @usingModal
			$(@domElement).on 'hidden', => @visible = false
			$(vtex.Messages.getInstance().modalPlaceholder).append(@domElement)
		else
			$(vtex.Messages.getInstance().placeholder)[@insertMethod](@domElement)

		if @visible then @show()

		return

	###*
	# Exibe a mensagem da tela
	# @method show
	# @param {Object|Number} options será passado como parametro para o método 
	# [fadeIn do jQuery](http://api.jquery.com/fadeIn/). Caso seja Modal, será tratado os 
	# [eventos de modal do Bootstrap](http://twitter.github.io/bootstrap/javascript.html#modals)
	# @return 
	###
	show: (options) =>
		if @usingModal
			if typeof options is 'object'
				for eventName in ['show', 'shown', 'hide', 'hidden'] when typeof options[eventName] is 'function'
					do (eventName) => $(@domElement).on eventName, => options[eventName](@)

			flagVisibleSet = false
			for modal in $('.modal.'+@classes.MESSAGEINSTANCE)
				modalData = $(modal).data('vtex-message')
				if modalData.visible is true and modalData.domElement isnt @domElement[0]
					flagVisibleSet = true
					$(modal).one 'hidden', =>
						$(@domElement).modal('show')
						@visible = true
			
			if not flagVisibleSet
				$(@domElement).on 'show', => @visible = true
				$(@domElement).modal('show')

			vtex.Messages.getInstance().changeContainerVisibility()
			return

		if typeof options is 'object' and options.complete? and typeof options.complete is 'function'
			userDone = options.complete
			options.complete = =>
				@visible = true
				userDone(@)
			@domElement.fadeIn(options)
		else if typeof options is 'number'
			@domElement.fadeIn(options, => @visible = true)
		else
			@domElement.show()
			@visible = true
			if typeof options is 'object' and options.timeout? and options.timeout isnt 0
				window.setTimeout =>
					@hide(options)
				, options.timeout

		vtex.Messages.getInstance().changeContainerVisibility()

	###
	# Esconde a mensagem da tela
	# @method hide
	# @param {Object|Number} options caso preenchido, será passado como parametro para o método 
	#[fadeOut do jQuery](http://api.jquery.com/fadeOut/)
	# @return 
	###
	hide: (options) =>
		if @usingModal
			@domElement.modal('hide')
			@visible = false
			vtex.Messages.getInstance().changeContainerVisibility()
			return

		if typeof options is 'object' and options.complete? and typeof options.complete is 'function'
			userDone = options.complete
			options.complete = =>
				@visible = false
				userDone(@)
			@domElement.fadeOut(options)
		else if typeof options is 'number'
			@domElement.fadeOut(options, => @visible = false)
		else
			@domElement.hide()
			@visible = false

		vtex.Messages.getInstance().changeContainerVisibility()

###
# Classe Messages, que agrupa todas as mensagens
# @class Messages
# @constructor
# É um singleton que instancia VtexMessages
###
class Messages
	instance = null
	@getInstance: (options = {}) ->
		instance ?= new VtexMessages(options)

	class VtexMessages
		###
		# Construtor
		# @param {Object} options propriedades a ser extendida pelo plugin
		# @return {Object} VtexMessages
		###
		constructor: (options = {}) ->
			@classes =
				PLACEHOLDER: '.vtex-front-message-placeholder'
				MODALPLACEHOLDER: 'body'

			defaultProperties =
				ajaxError: false
				messagesArray: []
				placeholder: @classes.PLACEHOLDER
				modalPlaceholder: @classes.MODALPLACEHOLDER
			_.extend(@, defaultProperties, options)

			@buildPlaceholderTemplate()
			@startEventListeners()
			@bindAjaxError() if @ajaxError

		###
		# Adiciona uma mensagem ao objeto Messages, exibe na tela imediatamente caso passado param show como true
		# @method addMessage
		# @param {Object} message
		# @param {Boolean} show caso verdadeiro, após a criação da mensagem, ela será exibida
		# @return {Object} retorna a instancia da Message criada
		###
		addMessage: (message, show = false) ->
			messageObj = new Message(message)
			@deduplicateMessages(messageObj)
			@messagesArray.push messageObj
			messageObj.show(message) if show isnt false
			if (!messageObj.usingModal)
				$(vtex.Messages.getInstance().placeholder).show();

		###
		# Remove uma mensagem
		# @method removeMessage
		# @param {Object} messageProperty objeto Message ou objeto com alguma propriedade da mensagem a ser removida
		# @return
		###
		removeMessage: (messageProperty) ->
			results = _.where(@messagesArray, messageProperty)
			for message, i in @messagesArray
				for res in results
					if message.id is res.id
						message.domElement.remove()
						@messagesArray.splice(i,1)
						return

		###
		# Esconde mensagens duplicadas
		# @method deduplicateMessages
		# @param {Object} messageObj objeto Message contra o qual as outras mensagens devem ser testadas
		# @return
		###
		deduplicateMessages: (messageObj) ->
			_.each @messagesArray, (message) =>
				if (message.content.title is messageObj.content.title) and (message.content.detail is messageObj.content.detail) and (message.usingModal is messageObj.usingModal) and (message.type is messageObj.type)
					message.hide()

		###
		# Esconde todas as mensagens
		# @method hideAllMessages
		# @param {Boolean} usingModal Flag que indica se as mensagems modais também devem ser escondidas
		# @return
		###
		hideAllMessages: (usingModal) ->
			_.each @messagesArray, (message) =>
				if message.visible
					if message.usingModal is false || usingModal is true
						message.hide()
			@.changeContainerVisibility();

		###
		# Verifica se o container deve ser escondido, ele será escondido caso não hajam mensagens sendo exibidas
		# @method changeContainerVisibility
		# @param
		# @return
		###
		changeContainerVisibility: ->
			notModalMessages = _.filter @messagesArray, (message) =>
				message.usingModal is false
			hasMessages = _.find notModalMessages, (message) =>
				message.visible is true
			if !hasMessages
				$(vtex.Messages.getInstance().placeholder).hide();

		###
		# Bind erros de Ajax para exibir modal de erro
		# @method bindAjaxError
		# @return
		###
		bindAjaxError: ->
			$(document).ajaxError (event, xhr, ajaxOptions, thrownError) =>
				return if xhr.status is 401 or xhr.status is 403
				# If refresh in the middle of an AJAX
				if xhr.readyState is 0 or xhr.status is 0 then return

				if window.i18n
					globalUnknownError = window.i18n.t('global.unkownError')
					globalError = window.i18n.t('global.error')
					globalClose = window.i18n.t('global.close')
				else
					globalUnknownError = "An unexpected error ocurred."
					globalError = "Error"
					globalClose = "Close"


				if xhr.getResponseHeader('x-vtex-operation-id')
					globalError += ' <small class="vtex-operation-id-container">(Operation ID '
					globalError += '<span class="vtex-operation-id">'
					globalError += decodeURIComponent(xhr.getResponseHeader('x-vtex-operation-id'))
					globalError += '</span>'
					globalError += ')</small>'

				if xhr.getResponseHeader('x-vtex-error-message')
					isContentJson = xhr.getResponseHeader('Content-Type')?.indexOf('application/json') isnt -1
					if isContentJson and xhr.responseText.error?.message?
						errorMessage = decodeURIComponent(xhr.responseText.error.message)
					else
						errorMessage = decodeURIComponent(xhr.getResponseHeader('x-vtex-error-message'))
						showFullError = getCookie("ShowFullError") is "Value=1"
						if showFullError
							errorMessage += '''
								<div class="vtex-error-detail-container">
									<a href="javascript:void(0);" class="vtex-error-detail-link" onClick="$('.vtex-error-detail').show()">
										<small>Details</small>
									</a>
									<div class="vtex-error-detail" style="display: none;"></div>
								</div>
							'''
							iframe = document.createElement('iframe')
							iframe.src = 'data:text/html;charset=utf-8,' + decodeURIComponent(xhr.responseText)
							$(iframe).css('width', '100%')
							$(iframe).css('height', '900px')
							addIframeLater = true
				else
					errorMessage = globalUnknownError

				# Exibe mensagem na tela
				messageObj =
					type: 'fatal'
					content:
						title: globalError
						detail: errorMessage
						html: true
					close: globalClose

				@addMessage(messageObj, true)

				if addIframeLater
					$('.vtex-error-detail').html(iframe)
					addIframeLater = null

		###
		# Constrói o template do placeholder
		# @method buildPlaceholderTemplate
		# @param
		# @return
		###
		buildPlaceholderTemplate: ->
			$(".vtex-front-message-placeholder").append("""<button type="button" class="vtex-front-message-close-all close">×</button>""");

		###
		# Inicia a API de eventos
		# @method startEventListeners
		# @param
		# @return
		###
		startEventListeners: ->
			if window
				$(window).on "vtex.message.addMessage", (evt, message, show) =>
					@addMessage(message, if show? then show else true)
				$(window).on "vtex.message.clearMessage", (evt, usingModal = false) =>
					@hideAllMessages(usingModal)
				$(".vtex-front-message-close-all").on "click", (evt, usingModal = false) =>
					@hideAllMessages(usingModal)

		###
		# Get cookie
		# @private
		# @method getCookie
		# @param {String} name nome do cookie
		# @return {String} valor do cookie
		###
		getCookie = (name) ->
			cookieValue = null
			if document.cookie and document.cookie isnt ""
				cookies = document.cookie.split(";")
				i = 0
				while i < cookies.length
					cookie = (cookies[i] or "").replace(/^\s+|\s+$/g, "")
					if cookie.substring(0, name.length + 1) is (name + "=")
						cookieValue = decodeURIComponent(cookie.substring(name.length + 1))
						break
					i++
			cookieValue
		
# exports
root.vtex.Messages = Messages