root = exports ? window
window.vtex = window.vtex or {}

###
# Classe Message - representa uma mensagem
# @class Message
# @constructor
###
class Message
  constructor: (options = {}) ->
    @classes =
      TEMPLATEDEFAULT: '.vtex-front-messages-template.vtex-front-messages-template-default'
      MODALTEMPLATEDEFAULT: '.vtex-front-messages-modal-template.vtex-front-messages-modal-template-default'
      TEMPLATE: '.vtex-front-messages-template'
      TITLE: '.vtex-front-messages-title'
      SEPARATOR: '.vtex-front-messages-separator'
      DETAIL: '.vtex-front-messages-detail'
      TYPE: 'vtex-front-messages-type-'

    defaultProperties =
      id: _.uniqueId('vtex-front-message-')
      timeout: 30 * 1000
      template: @classes.TEMPLATE
      modalTemplate: @classes.MODALTEMPLATE
      prefixClassForType: @classes.TYPE
      content:
        title: ''
        detail: ''
      close: 'Close'
      type: 'info' # possible types are: ['success', 'info', 'warning', 'danger', 'fatal', 'error']
      usingModal: false
      usingDefaultTemplate: true
      domElement: $()
      insertMethod: 'append'
      timer: null

    _.extend(@, defaultProperties, options)

    if @type is 'fatal' then @usingModal = true
    @.timeout = @getTimeoutDefaults(options)

    modalDefaultTemplate = """
    <div class="vtex-front-messages-modal-template vtex-front-messages-modal-template-default modal hide fade">
      <div class="modal-header">
        <h3 class="vtex-front-messages-title"></h3>
      </div>
      <div class="modal-body">
        <p class="vtex-front-messages-detail"></p>
      </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal" aria-hidden="true">"""+@close+"""</button>
      </div>
    </div>
    """

    defaultTemplate = """
    <div class="vtex-front-messages-template">
      <span class="vtex-front-messages-title"></span><span class="vtex-front-messages-separator"> - </span><span 						class="vtex-front-messages-detail"></span>
    </div>
    """

    # Se usa modal
    if @usingModal
      if not $(vtex.Messages.getInstance().modalPlaceholder)[0] then throw new Error("Couldn't find placeholder for Modal Message")
      if @modalTemplate is @classes.MODALTEMPLATE
        @modalTemplate = modalDefaultTemplate
        @usingDefaultTemplate = true
      else
        if not $(@modalTemplate)[0] then throw new Error("Couldn't find specified template for Modal Message")
        @usingDefaultTemplate = false
      @domElement = $(@modalTemplate)
      $(@domElement).addClass(@id + " " + @classes.TYPE + @type)

    # Se não usa modal
    if !@usingModal
      if not $(vtex.Messages.getInstance().placeholder)[0] then throw new Error("Couldn't find placeholder for Message")
      if @template is @classes.TEMPLATE
        @template = defaultTemplate
        @usingDefaultTemplate = true
      else
        if not $(@template)[0] then throw new Error("Couldn't find specified template for Message")
        @usingDefaultTemplate = false
      @domElement = $(@template).clone(false, false)
      $(@domElement).addClass(@id + " " + @classes.TYPE + @type)

    $(@domElement).data('vtex-message', @)

    if @content.html
      if @content.title and @content.title isnt ''
        $(@classes.TITLE, @domElement).html(@content.title)
      else
        $(@classes.TITLE, @domElement).hide()
      $(@classes.DETAIL, @domElement).html(@content.detail)
    else
      if @content.title and @content.title isnt ''
        $(@classes.TITLE, @domElement).text(@content.title)
      else
        $(@classes.TITLE, @domElement).hide()
      $(@classes.DETAIL, @domElement).text(@content.detail)

    if !(@content.title and @content.title isnt '') or !(@content.detail and @content.detail isnt '')
      $(@classes.SEPARATOR, @domElement).hide()

    return

  ###
  # Configura o timeout da mensagem de acordo com o 'type' da mesma
  # @method getTimeoutDefaults
  # @return
  ###
  getTimeoutDefaults: (options) ->
    ONE_SECOND = 1000
    if options.timeout?
      timeout = options.timeout
    else
      switch @.type
        when 'success' then timeout = 10 * ONE_SECOND
        when 'info' then timeout = 15 * ONE_SECOND
        when 'warning' then timeout = 20 * ONE_SECOND
        when 'error' then timeout = 25 * ONE_SECOND
        when 'danger' then timeout = 30 * ONE_SECOND
        else timeout = 30 * ONE_SECOND
    if not @usingModal
      return timeout
    else
      return 0

  startTimeout: () ->
    if not @usingModal
      if @timer
        clearTimeout(@timer);
      @timer = window.setTimeout =>
        @hide()
      , @timeout

  ###
  # Exibe a mensagem da tela
  # @method show
  # @return
  ###
  show: () =>
    if @usingModal
      modalArray = vtex.Messages.getInstance().modalQueue
      if _.indexOf(modalArray, @) is -1
        $(@domElement).one 'hidden', =>
          @hide()
          modalArray.splice(0,1)
          if modalArray.length isnt 0
            $(modalArray[0].domElement).modal 'show'

        # Se o array está vazio, não há modal visível, logo, mostramos o modal
        if modalArray.length is 0
          $(@domElement).modal 'show'

        # Adiciona a mensagem no array
        if modalArray.indexOf(@) is -1
          modalArray.push @

    if !@usingModal
      @domElement.addClass('vtex-front-messages-template-opened');
      # se necessário, cria timer para a mensagem
      if @.timeout? and @.timeout isnt 0
        @startTimeout()

  ###
  # Esconde a mensagem da tela
  # @method hide
  # @return
  ###
  hide: () =>
    if @usingModal
      vtex.Messages.getInstance().removeMessage(@id)
    if !@usingModal
      @domElement.removeClass('vtex-front-messages-template-opened')
      if Modernizr? and Modernizr.csstransforms and Modernizr.csstransitions and Modernizr.opacity
        @domElement.bind("transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd", =>
          if not @domElement.hasClass('vtex-front-messages-template-opened')
            vtex.Messages.getInstance().removeMessage(@id)
        )
      else
        vtex.Messages.getInstance().removeMessage(@id)
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
        PLACEHOLDER: '.vtex-front-messages-placeholder'
        MODALPLACEHOLDER: 'body'

      defaultProperties =
        ajaxError: false
        messagesArray: []
        placeholder: @classes.PLACEHOLDER
        modalPlaceholder: @classes.MODALPLACEHOLDER
        modalQueue: []
      _.extend(@, defaultProperties, options)

      @buildPlaceholderTemplate()
      @registerEventListeners()
      @bindAjaxError() if @ajaxError

    ###
    # Adiciona uma mensagem
    # @method addMessage
    # @param {Object} Message
    # @return
    ###
    addMessage: (message) ->
      messageObj = new Message(message)
      if not @isMessageDuplicated(messageObj)
        @messagesArray.push messageObj
        # insere mensagem no DOM
        if messageObj.usingModal
          $(messageObj.domElement).on 'hidden', =>
            $(window).trigger('removeMessage.vtex', messageObj.id)
          $(@modalPlaceholder).append(messageObj.domElement)
        else
          $(@placeholder)[messageObj.insertMethod](messageObj.domElement)
          # show placeholder
          if (not $(vtex.Messages.getInstance().placeholder).hasClass('vtex-front-messages-placeholder-opened'))
            $(vtex.Messages.getInstance().placeholder).addClass('vtex-front-messages-placeholder-opened');
        messageObj.show()
      else if messageObj.timeout isnt 0 and not messageObj.usingModal
        @resetDuplicatedMessageTimeout(messageObj)

    ###
    # Remove uma mensagem
    # @method removeMessage
    # @param {String} messageId
    # @return
    ###
    removeMessage: (messageId) =>
      for i in [@messagesArray.length - 1..0] by -1
        currentMessage = @messagesArray[i]
        if (currentMessage.id is messageId)
          @messagesArray.splice(i,1)
          if not currentMessage.usingModal
            currentMessage.domElement.remove()
          else
            currentMessage.domElement.modal('hide')
            if (currentMessage.usingDefaultTemplate) # remove do DOM se tem um id default
              currentMessage.domElement.remove()

    ###
    # Reseta o timeout da mensagem que foi duplicada
    # @method resetDuplicatedMessageTimeout
    # @param {Object} messageObj objeto Message contra o qual as outras mensagens devem ser testadas
    # @return
    ###
    resetDuplicatedMessageTimeout: (messageObj) =>
      _.each @messagesArray, (message) =>
        if (message.content.title is messageObj.content.title) and (message.content.detail is messageObj.content.detail) and (message.usingModal is messageObj.usingModal) and (message.type is messageObj.type)
          message.startTimeout()

    ###
    # Verifica se existem mensagens duplicadas
    # @method isMessageDuplicated
    # @param {Object} messageObj objeto Message contra o qual as outras mensagens devem ser testadas
    # @return
    ###
    isMessageDuplicated: (messageObj) ->
      isMessageDuplicated = false
      _.each @messagesArray, (message) =>
        if (message.content.title is messageObj.content.title) and (message.content.detail is messageObj.content.detail) and (message.usingModal is messageObj.usingModal) and (message.type is messageObj.type)
          if (messageObj.id.substr(0,19) is 'vtex-front-message-') # se a mensagem tem um id default basta as condições anteriores
            isMessageDuplicated = true
          else if (message.id isnt messageObj.id) # se a mensagem tem um id customizado e é diferente é outra
            isMessageDuplicated = false
          else if (message.id is messageObj.id) # se a mensagem tem um id customizado e é igual é a mesma
            isMessageDuplicated = true
      return isMessageDuplicated

    ###
    # Esconde todas as mensagens
    # @method removeAllMessages
    # @param {Boolean} usingModal Flag que indica se as mensagems modais também devem ser escondidas
    # @return
    ###
    removeAllMessages: (usingModal = false) ->
      for i in [@messagesArray.length - 1..0] by -1
        message = @messagesArray[i]
        if (message.usingModal is false) || (usingModal is true)
          message.hide();
      @.changeContainerVisibility(true)

    ###
    # Verifica se o container deve ser escondido, ele será escondido caso não hajam mensagens sendo exibidas
    # @method changeContainerVisibility
    # @param
    # @return
    ###
    changeContainerVisibility: (isRemovingAll = false) ->
      notModalMessages = _.filter @messagesArray, (message) =>
        message.usingModal is false
      if (notModalMessages.length <= 1 or isRemovingAll) and $(vtex.Messages.getInstance().placeholder).hasClass('vtex-front-messages-placeholder-opened')
        $(vtex.Messages.getInstance().placeholder).removeClass('vtex-front-messages-placeholder-opened');

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

        globalUnknownError = if window.i18n then window.i18n.t('global.unkownError') else 'An unexpected error ocurred.'
        globalError = if window.i18n then window.i18n.t('global.error') else 'Error'
        globalClose = if window.i18n then window.i18n.t('global.close') else 'Close'

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

        @addMessage(messageObj)

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
      $(".vtex-front-messages-placeholder").append("""<button type="button" class="vtex-front-messages-close-all close">×</button>""");

    ###
    # Inicia a API de eventos
    # @method registerEventListeners
    # @param
    # @return
    ###
    registerEventListeners: ->
      if window
        $(window).on "addMessage.vtex", (evt, message) =>
          @addMessage(message)
        $(window).on "removeMessage.vtex", (evt, messageId) =>
          for i in [@messagesArray.length - 1..0] by -1
            currentMessage = @messagesArray[i]
            if (currentMessage.id is messageId)
              return currentMessage.hide()
        $(window).on "removeAllMessages.vtex", (evt, usingModal = false) =>
          @removeAllMessages(usingModal)
        $(".vtex-front-messages-close-all").on "click", (evt, usingModal = false) =>
          @removeAllMessages(usingModal)

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