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
      MODALTEMPLATEDEFAULT: '.vtex-front-messages-template.vtex-front-messages-template-modal-default'
      TEMPLATE: '.vtex-front-messages-container'
      TITLE: '.vtex-front-messages-title'
      SEPARATOR: '.vtex-front-messages-separator'
      DETAIL: '.vtex-front-messages-detail'
      TYPE: 'vtex-front-messages-type-'
      MESSAGEINSTANCE: 'vtex-front-messages-instance'

    defaultProperties =
      id: _.uniqueId('vtex-front-message-')
      template: @classes.TEMPLATE
      timeout: 30 * 1000
      modalTemplate: @classes.MODALTEMPLATE
      prefixClassForType: @classes.TYPE
      content:
        title: ''
        detail: ''
      close: 'Close'
      type: 'info'
      usingModal: false
      domElement: $()
      insertMethod: 'append'
    _.extend(@, defaultProperties, options)

    modalDefaultTemplate = """
    <div class="vtex-front-messages-template vtex-front-messages-template-modal-default modal hide fade">
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
    <div class="vtex-front-messages-container">
    <div class="vtex-front-messages-template vtex-front-messages-template-default static-front-messages-template">
      <span class="vtex-front-messages-title"></span><span class="vtex-front-messages-separator"> - </span><span 						class="vtex-front-messages-detail"></span>
    </div>
    </div>
    """

    if @type is 'fatal' then @usingModal = true

    # Se usa modal
    if @usingModal
      if not $(vtex.Messages.getInstance().modalPlaceholder)[0] then throw new Error("Couldn't find placeholder for Modal Message")
      if @modalTemplate is @classes.MODALTEMPLATE
        @modalTemplate = modalDefaultTemplate
      else
        if not $(@modalTemplate)[0] then throw new Error("Couldn't find specified template for Modal Message")
      @domElement = $(@modalTemplate)
      $(@domElement).addClass(@id + " " + @classes.MESSAGEINSTANCE + " " + @classes.TYPE + @type)

    # Se não usa modal
    if !@usingModal
      if not $(vtex.Messages.getInstance().placeholder)[0] then throw new Error("Couldn't find placeholder for Message")
      if @template is @classes.TEMPLATE
        @template = defaultTemplate
      else
        if not $(@template)[0] then throw new Error("Couldn't find specified template for Message")
      @domElement = $(@template).clone(false, false)
      $(@domElement).find(".vtex-front-messages-template").addClass(@id + " " + @classes.MESSAGEINSTANCE + " " + @classes.TYPE + @type)

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

    # Adiciona o Elemento no DOM
    if @usingModal
      $(@domElement).on 'hidden', => console.log 'modal hidden' # todo: remove message
      $(vtex.Messages.getInstance().modalPlaceholder).append(@domElement)
    else
      $(vtex.Messages.getInstance().placeholder)[@insertMethod](@domElement)

    @show()
    return

  ###
  # Exibe a mensagem da tela
  # @method show
  # @return
  ###
  show: () =>
    if @usingModal
      # tratamento para o caso de já haver um modal aberto
      flagVisibleSet = false
      for modal in $('.modal.' + @classes.MESSAGEINSTANCE)
        modalData = $(modal).data('vtex-message')
        if modalData.domElement isnt @domElement[0]
          flagVisibleSet = true
          $(modal).one 'hidden', =>
            $(@domElement).modal('show')

      if not flagVisibleSet
        $(@domElement).modal('show')

    if !@usingModal
      @domElement.show()

      # cria timer da mensagem
      if @.timeout? and @.timeout isnt 0
        window.setTimeout =>
          @hide()
        , @timeout

    vtex.Messages.getInstance().changeContainerVisibility()

  ###
  # Esconde a mensagem da tela
  # @method hide
  # @return
  ###
  hide: () =>
    if @usingModal
      @domElement.modal('hide')
    if !@usingModal
      @domElement.hide()

    # todo: remove message
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
      _.extend(@, defaultProperties, options)

      @buildPlaceholderTemplate()
      @registerEventListeners()
      @bindAjaxError() if @ajaxError

    ###
    # Adiciona uma mensagem ao objeto Messages, exibe na tela imediatamente caso passado param show como true
    # @method addMessage
    # @param {Object} message
    # @param {Boolean} show caso verdadeiro, após a criação da mensagem, ela será exibida
    # @return {Object} retorna a instancia da Message criada
    ###
    addMessage: (message) ->
      messageObj = new Message(message)
      #@deduplicateMessages(messageObj)
      @messagesArray.push messageObj
      messageObj.show()
      # show placeholder if not using modal
      if (!messageObj.usingModal)
        $(vtex.Messages.getInstance().placeholder).show();

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
    # @method removeAllMessages
    # @param {Boolean} usingModal Flag que indica se as mensagems modais também devem ser escondidas
    # @return
    ###
    removeAllMessages: (usingModal = false) ->
      _.each @messagesArray, (message, i) =>
        if (message.usingModal is false) || (usingModal is true)
          message.domElement.remove()
          @messagesArray.splice(i,1)
      @.changeContainerVisibility()

    ###
    # Verifica se o container deve ser escondido, ele será escondido caso não hajam mensagens sendo exibidas
    # @method changeContainerVisibility
    # @param
    # @return
    ###
    changeContainerVisibility: ->
      notModalMessages = _.filter @messagesArray, (message) =>
        message.usingModal is false
      if !notModalMessages
        $(vtex.Messages.getInstance().placeholder).hide();

    ###
    # Bind erros de Ajax para exibir modal de erro
    # @method bindAjaxError
    # @return
    ###
    bindAjaxError: ->
      console.log 'bindAjaxError'
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
        $(window).on "clearMessages.vtex", (evt, usingModal = false) =>
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