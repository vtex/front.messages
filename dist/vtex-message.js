(function() {
  var Message, Messages, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  window.vtex || (window.vtex = {});

  /**
  # Classe Message, que representa uma mensagem
  # @class Message
  # @constructor
  */


  Message = (function() {
    function Message(options) {
      var defaultProperties, defaultTemplate, modalDefaultTemplate,
        _this = this;
      if (options == null) {
        options = {};
      }
      this.hide = __bind(this.hide, this);
      this.show = __bind(this.show, this);
      this.classes = {
        TEMPLATEDEFAULT: '.vtex-message-template.vtex-message-template-default',
        MODALTEMPLATEDEFAULT: '.vtex-message-template.vtex-message-template-modal-default',
        PLACEHOLDER: '.vtex-message-placeholder',
        MODALPLACEHOLDER: 'body',
        TEMPLATE: 'vtex-message-template',
        TITLE: '.vtex-message-title',
        DETAIL: '.vtex-message-detail',
        TYPE: 'alert-',
        MESSAGEINSTANCE: 'vtex-message-instance'
      };
      defaultProperties = {
        id: _.uniqueId('vtex-message-'),
        placeholder: this.classes.PLACEHOLDER,
        modalPlaceholder: this.classes.MODALPLACEHOLDER,
        template: this.classes.TEMPLATE,
        modalTemplate: this.classes.MODALTEMPLATE,
        prefixClassForType: this.classes.TYPE,
        content: {
          title: '',
          detail: ''
        },
        close: 'Close',
        type: 'info',
        visible: false,
        usingModal: false,
        domElement: $(),
        insertMethod: 'append'
      };
      _.extend(this, defaultProperties, options);
      modalDefaultTemplate = "<div class=\"vtex-message-template vtex-message-template-modal-default modal hide fade\">\n	<div class=\"modal-header\">\n		<h3 class=\"vtex-message-title\"></h3>\n	</div>\n	<div class=\"modal-body\">\n		<p class=\"vtex-message-detail\"></p>\n	</div>\n	<div class=\"modal-footer\">\n		<button class=\"btn\" data-dismiss=\"modal\" aria-hidden=\"true\">" + this.close + "</button>\n	</div>\n</div>";
      defaultTemplate = "<div class=\"vtex-message-template vtex-message-template-default static-message-template alert\">\n	<button type=\"button\" class=\"close\" data-dismiss=\"alert\">&times;</button>\n	<h4 class=\"alert-heading vtex-message-title\"></h4>\n	<p class=\"message-text vtex-message-detail\"></p>\n</div>";
      if (this.type === 'fatal') {
        this.usingModal = true;
      }
      if (this.usingModal) {
        if (!$(this.modalPlaceholder)[0]) {
          throw new Error("Couldn't find placeholder for modal Message");
        }
        if (this.modalTemplate === this.classes.MODALTEMPLATE) {
          this.modalTemplate = modalDefaultTemplate;
        } else {
          if (!$(this.modalTemplate)[0]) {
            throw new Error("Couldn't find specified template for modal Message");
          }
        }
        this.domElement = $(this.modalTemplate);
      } else {
        if (!$(this.placeholder)[0]) {
          throw new Error("Couldn't find placeholder for Message");
        }
        if (this.template === this.classes.TEMPLATE) {
          this.template = defaultTemplate;
        } else {
          if (!$(this.template)[0]) {
            throw new Error("Couldn't find specified template for Message");
          }
        }
        this.domElement = $(this.template).clone(false, false);
        $(this.domElement).bind('closed', function() {
          return _this.visible = false;
        });
      }
      $(this.domElement).removeClass(this.classes.TEMPLATE);
      $(this.domElement).addClass(this.prefixClassForType + this.type + " " + this.id + " " + this.classes.MESSAGEINSTANCE);
      $(this.domElement).hide();
      $(this.domElement).data('vtex-message', this);
      if (this.content.title && this.content.title !== '') {
        $(this.classes.TITLE, this.domElement).html(this.content.title);
      } else {
        $(this.classes.TITLE, this.domElement).hide();
      }
      $(this.classes.DETAIL, this.domElement).html(this.content.detail);
      if (this.usingModal) {
        $(this.domElement).on('hidden', function() {
          return _this.visible = false;
        });
        $(this.modalPlaceholder).append(this.domElement);
      } else {
        $(this.placeholder)[this.insertMethod](this.domElement);
      }
      if (this.visible) {
        this.show();
      }
      return;
    }

    /**
    	# Exibe a mensagem da tela
    	# @method show
    	# @param {Object|Number} options será passado como parametro para o método 
    	# [fadeIn do jQuery](http://api.jquery.com/fadeIn/). Caso seja Modal, será tratado os 
    	# [eventos de modal do Bootstrap](http://twitter.github.io/bootstrap/javascript.html#modals)
    	# @return
    */


    Message.prototype.show = function(options) {
      var eventName, flagVisibleSet, modal, modalData, userDone, _i, _j, _len, _len1, _ref, _ref1,
        _this = this;
      if (this.usingModal) {
        if (typeof options === 'object') {
          _ref = ['show', 'shown', 'hide', 'hidden'];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            eventName = _ref[_i];
            if (typeof options[eventName] === 'function') {
              (function(eventName) {
                return $(_this.domElement).on(eventName, function() {
                  return options[eventName](_this);
                });
              })(eventName);
            }
          }
        }
        flagVisibleSet = false;
        _ref1 = $('.modal.' + this.classes.MESSAGEINSTANCE);
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          modal = _ref1[_j];
          modalData = $(modal).data('vtex-message');
          if (modalData.visible === true && modalData.domElement !== this.domElement[0]) {
            flagVisibleSet = true;
            $(modal).one('hidden', function() {
              $(_this.domElement).modal('show');
              return _this.visible = true;
            });
          }
        }
        if (!flagVisibleSet) {
          $(this.domElement).on('show', function() {
            return _this.visible = true;
          });
          $(this.domElement).modal('show');
        }
        return;
      }
      if (typeof options === 'object' && (options.complete != null) && typeof options.complete === 'function') {
        userDone = options.complete;
        options.complete = function() {
          _this.visible = true;
          return userDone(_this);
        };
        return this.domElement.fadeIn(options);
      } else if (typeof options === 'number') {
        return this.domElement.fadeIn(options, function() {
          return _this.visible = true;
        });
      } else {
        this.domElement.show();
        return this.visible = true;
      }
    };

    /**
    	# Esconde a mensagem da tela
    	# @method hide
    	# @param {Object|Number} options caso preenchido, será passado como parametro para o método 
    	#[fadeOut do jQuery](http://api.jquery.com/fadeOut/)
    	# @return
    */


    Message.prototype.hide = function(options) {
      var userDone,
        _this = this;
      if (this.usingModal) {
        this.domElement.modal('hide');
        this.visible = false;
        return;
      }
      if (typeof options === 'object' && (options.complete != null) && typeof options.complete === 'function') {
        userDone = options.complete;
        options.complete = function() {
          _this.visible = false;
          return userDone(_this);
        };
        return this.domElement.fadeOut(options);
      } else if (typeof options === 'number') {
        return this.domElement.fadeOut(options, function() {
          return _this.visible = false;
        });
      } else {
        this.domElement.hide();
        return this.visible = false;
      }
    };

    return Message;

  })();

  /**
  # Classe Messages, que agrupa todas as mensagens
  # @class Messages
  # @constructor
  */


  Messages = (function() {
    /*
    	# Construtor
    	# @param {Object} options propriedades a ser extendida pelo plugin
    	# @return {Object} Messages
    */

    var getCookie;

    function Messages(options) {
      var defaultProperties;
      if (options == null) {
        options = {};
      }
      this.removeMessage = __bind(this.removeMessage, this);
      this.addMessage = __bind(this.addMessage, this);
      defaultProperties = {
        ajaxError: false,
        messagesArray: []
      };
      _.extend(this, defaultProperties, options);
      if (this.ajaxError) {
        this.bindAjaxError();
      }
    }

    /**
    	# Adiciona uma mensagem ao objeto Messages, exibe na tela imediatamente caso passado param show como true
    	# @method addMessage
    	# @param {Object} message
    	# @param {Boolean} show caso verdadeiro, após a criação da mensagem, ela será exibida 
    	# @return {Object} retorna a instancia da Message criada
    */


    Messages.prototype.addMessage = function(message, show) {
      var messageObj;
      if (show == null) {
        show = false;
      }
      messageObj = new Message(message);
      this.messagesArray.push(messageObj);
      if (show !== false) {
        messageObj.show(show);
      }
      return messageObj;
    };

    /**
    	# Remove uma mensagem
    	# @method removeMessage
    	# @param {Object} messageProperty objeto Message ou objeto com alguma propriedade da mensagem a ser removida
    	# @return
    */


    Messages.prototype.removeMessage = function(messageProperty) {
      var i, message, res, results, _i, _j, _len, _len1, _ref;
      results = _.where(this.messagesArray, messageProperty);
      _ref = this.messagesArray;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        message = _ref[i];
        for (_j = 0, _len1 = results.length; _j < _len1; _j++) {
          res = results[_j];
          if (message.id === res.id) {
            message.domElement.remove();
            this.messagesArray.splice(i, 1);
            return;
          }
        }
      }
    };

    /**
    	# Bind erros de Ajax para exibir modal de erro
    	# @method bindAjaxError
    	# @return
    */


    Messages.prototype.bindAjaxError = function() {
      var _this = this;
      return $(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
        var addIframeLater, errorMessage, globalClose, globalError, globalUnknownError, iframe, isContentJson, messageObj, showFullError, _ref, _ref1;
        if (xhr.status === 401 || xhr.status === 403) {
          return;
        }
        if (xhr.readyState === 0 || xhr.status === 0) {
          return;
        }
        if (window.i18n) {
          globalUnknownError = window.i18n.t('global.unkownError');
          globalError = window.i18n.t('global.error');
          globalClose = window.i18n.t('global.close');
        } else {
          globalUnknownError = "An unexpected error ocurred.";
          globalError = "Error";
          globalClose = "Close";
        }
        if (xhr.getResponseHeader('x-vtex-operation-id')) {
          globalError += ' <small class="vtex-operation-id-container">(Operation ID ';
          globalError += '<span class="vtex-operation-id">';
          globalError += decodeURIComponent(xhr.getResponseHeader('x-vtex-operation-id'));
          globalError += '</span>';
          globalError += ')</small>';
        }
        if (xhr.getResponseHeader('x-vtex-error-message')) {
          isContentJson = ((_ref = xhr.getResponseHeader('Content-Type')) != null ? _ref.indexOf('application/json') : void 0) !== -1;
          if (isContentJson && (((_ref1 = xhr.responseText.error) != null ? _ref1.message : void 0) != null)) {
            errorMessage = decodeURIComponent(xhr.responseText.error.message);
          } else {
            errorMessage = decodeURIComponent(xhr.getResponseHeader('x-vtex-error-message'));
            showFullError = getCookie("ShowFullError") === "Value=1";
            if (showFullError) {
              errorMessage += '<div class="vtex-error-detail-container">\n	<a href="javascript:void(0);" class="vtex-error-detail-link" onClick="$(\'.vtex-error-detail\').show()">\n		<small>Details</small>\n	</a>\n	<div class="vtex-error-detail" style="display: none;"></div>\n</div>';
              iframe = document.createElement('iframe');
              iframe.src = 'data:text/html;charset=utf-8,' + decodeURIComponent(xhr.responseText);
              $(iframe).css('width', '100%');
              $(iframe).css('height', '900px');
              addIframeLater = true;
            }
          }
        } else {
          errorMessage = globalUnknownError;
        }
        messageObj = {
          type: 'fatal',
          content: {
            title: globalError,
            detail: errorMessage
          },
          close: globalClose
        };
        _this.addMessage(messageObj, true);
        if (addIframeLater) {
          $('.vtex-error-detail').html(iframe);
          return addIframeLater = null;
        }
      });
    };

    /**
    	# Get cookie
    	# @private
    	# @method getCookie
    	# @param {String} name nome do cookie
    	# @return {String} valor do cookie
    */


    getCookie = function(name) {
      var cookie, cookieValue, cookies, i;
      cookieValue = null;
      if (document.cookie && document.cookie !== "") {
        cookies = document.cookie.split(";");
        i = 0;
        while (i < cookies.length) {
          cookie = (cookies[i] || "").replace(/^\s+|\s+$/g, "");
          if (cookie.substring(0, name.length + 1) === (name + "=")) {
            cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
            break;
          }
          i++;
        }
      }
      return cookieValue;
    };

    return Messages;

  })();

  root.vtex.Messages = Messages;

}).call(this);
