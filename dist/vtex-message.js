(function() {
  var Message, Messages, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof exports !== "undefined" && exports !== null ? exports : window;

  window.vtex = window.vtex || {};

  /*
  # Classe Message - representa uma mensagem
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
        TEMPLATEDEFAULT: '.vtex-front-messages-template.vtex-front-messages-template-default',
        MODALTEMPLATEDEFAULT: '.vtex-front-messages-modal-template.vtex-front-messages-modal-template-default',
        TEMPLATE: '.vtex-front-messages-template',
        TITLE: '.vtex-front-messages-title',
        SEPARATOR: '.vtex-front-messages-separator',
        DETAIL: '.vtex-front-messages-detail',
        TYPE: 'vtex-front-messages-type-',
        MESSAGEINSTANCE: 'vtex-front-messages-instance'
      };
      defaultProperties = {
        id: _.uniqueId('vtex-front-message-'),
        template: this.classes.TEMPLATE,
        timeout: 30 * 1000,
        modalTemplate: this.classes.MODALTEMPLATE,
        prefixClassForType: this.classes.TYPE,
        content: {
          title: '',
          detail: ''
        },
        close: 'Close',
        type: 'info',
        visible: true,
        usingModal: false,
        domElement: $(),
        insertMethod: 'append'
      };
      _.extend(this, defaultProperties, options);
      modalDefaultTemplate = "<div class=\"vtex-front-messages-modal-template vtex-front-messages-modal-template-default modal hide fade\">\n  <div class=\"modal-header\">\n    <h3 class=\"vtex-front-messages-title\"></h3>\n  </div>\n  <div class=\"modal-body\">\n    <p class=\"vtex-front-messages-detail\"></p>\n  </div>\n  <div class=\"modal-footer\">\n    <button class=\"btn\" data-dismiss=\"modal\" aria-hidden=\"true\">" + this.close + "</button>\n  </div>\n</div>";
      defaultTemplate = "<div class=\"vtex-front-messages-template\">\n  <span class=\"vtex-front-messages-title\"></span><span class=\"vtex-front-messages-separator\"> - </span><span 						class=\"vtex-front-messages-detail\"></span>\n</div>";
      if (this.type === 'fatal') {
        this.usingModal = true;
      }
      if (this.usingModal) {
        if (!$(vtex.Messages.getInstance().modalPlaceholder)[0]) {
          throw new Error("Couldn't find placeholder for Modal Message");
        }
        if (this.modalTemplate === this.classes.MODALTEMPLATE) {
          this.modalTemplate = modalDefaultTemplate;
        } else {
          if (!$(this.modalTemplate)[0]) {
            throw new Error("Couldn't find specified template for Modal Message");
          }
        }
        this.domElement = $(this.modalTemplate);
        $(this.domElement).addClass(this.id + " " + this.classes.MESSAGEINSTANCE + " " + this.classes.TYPE + this.type);
      }
      if (!this.usingModal) {
        if (!$(vtex.Messages.getInstance().placeholder)[0]) {
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
        $(this.domElement).addClass(this.id + " " + this.classes.MESSAGEINSTANCE + " " + this.classes.TYPE + this.type);
      }
      $(this.domElement).hide();
      $(this.domElement).data('vtex-message', this);
      if (this.content.html) {
        if (this.content.title && this.content.title !== '') {
          $(this.classes.TITLE, this.domElement).html(this.content.title);
        } else {
          $(this.classes.TITLE, this.domElement).hide();
          $(this.classes.SEPARATOR, this.domElement).hide();
        }
        $(this.classes.DETAIL, this.domElement).html(this.content.detail);
      } else {
        if (this.content.title && this.content.title !== '') {
          $(this.classes.TITLE, this.domElement).text(this.content.title);
        } else {
          $(this.classes.TITLE, this.domElement).hide();
          $(this.classes.SEPARATOR, this.domElement).hide();
        }
        $(this.classes.DETAIL, this.domElement).text(this.content.detail);
      }
      if (this.usingModal) {
        $(this.domElement).on('hidden', function() {
          _this.visible = false;
          return $(window).trigger('removeMessage.vtex', _this.id);
        });
        $(vtex.Messages.getInstance().modalPlaceholder).append(this.domElement);
      } else {
        $(vtex.Messages.getInstance().placeholder)[this.insertMethod](this.domElement);
      }
      this.show();
      return;
    }

    /*
    # Exibe a mensagem da tela
    # @method show
    # @return
    */


    Message.prototype.show = function() {
      var flagVisibleSet, modal, modalData, _i, _len, _ref,
        _this = this;
      if (this.usingModal) {
        flagVisibleSet = false;
        _ref = $('.modal.' + this.classes.MESSAGEINSTANCE);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          modal = _ref[_i];
          modalData = $(modal).data('vtex-message');
          if ((modalData.domElement[0] !== this.domElement[0]) && (modalData.visible === true)) {
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
      }
      if (!this.usingModal) {
        this.domElement.show();
        this.visible = true;
        if ((this.timeout != null) && this.timeout !== 0) {
          return window.setTimeout(function() {
            return _this.hide();
          }, this.timeout);
        }
      }
    };

    /*
    # Esconde a mensagem da tela
    # @method hide
    # @return
    */


    Message.prototype.hide = function() {
      if (this.usingModal) {
        this.domElement.modal('hide');
      }
      if (!this.usingModal) {
        this.domElement.hide();
        this.visible = false;
      }
      return $(window).trigger('removeMessage.vtex', this.id);
    };

    return Message;

  })();

  /*
  # Classe Messages, que agrupa todas as mensagens
  # @class Messages
  # @constructor
  # É um singleton que instancia VtexMessages
  */


  Messages = (function() {
    var VtexMessages, instance;

    function Messages() {}

    instance = null;

    Messages.getInstance = function(options) {
      if (options == null) {
        options = {};
      }
      return instance != null ? instance : instance = new VtexMessages(options);
    };

    VtexMessages = (function() {
      /*
      # Construtor
      # @param {Object} options propriedades a ser extendida pelo plugin
      # @return {Object} VtexMessages
      */

      var getCookie;

      function VtexMessages(options) {
        var defaultProperties;
        if (options == null) {
          options = {};
        }
        this.removeMessage = __bind(this.removeMessage, this);
        this.classes = {
          PLACEHOLDER: '.vtex-front-messages-placeholder',
          MODALPLACEHOLDER: 'body'
        };
        defaultProperties = {
          ajaxError: false,
          messagesArray: [],
          placeholder: this.classes.PLACEHOLDER,
          modalPlaceholder: this.classes.MODALPLACEHOLDER
        };
        _.extend(this, defaultProperties, options);
        this.buildPlaceholderTemplate();
        this.registerEventListeners();
        if (this.ajaxError) {
          this.bindAjaxError();
        }
      }

      /*
      # Adiciona uma mensagem
      # @method addMessage
      # @param {Object} Message
      # @return
      */


      VtexMessages.prototype.addMessage = function(message) {
        var messageObj;
        messageObj = new Message(message);
        this.deduplicateMessages(messageObj);
        this.messagesArray.push(messageObj);
        messageObj.show();
        if (!messageObj.usingModal) {
          return $(vtex.Messages.getInstance().placeholder).show();
        }
      };

      /*
      # Remove uma mensagem
      # @method removeMessage
      # @param {String} messageId
      # @return
      */


      VtexMessages.prototype.removeMessage = function(messageId) {
        var currentMessage, i, _i, _ref;
        for (i = _i = _ref = this.messagesArray.length - 1; _i >= 0; i = _i += -1) {
          currentMessage = this.messagesArray[i];
          if (currentMessage.id === messageId) {
            this.messagesArray.splice(i, 1);
            if (!currentMessage.usingModal) {
              currentMessage.domElement.remove();
            } else {
              currentMessage.domElement.modal('hide');
            }
          }
        }
        return this.changeContainerVisibility();
      };

      /*
      # Esconde mensagens duplicadas
      # @method deduplicateMessages
      # @param {Object} messageObj objeto Message contra o qual as outras mensagens devem ser testadas
      # @return
      */


      VtexMessages.prototype.deduplicateMessages = function(messageObj) {
        var _this = this;
        return _.each(this.messagesArray, function(message) {
          if ((message.content.title === messageObj.content.title) && (message.content.detail === messageObj.content.detail) && (message.usingModal === messageObj.usingModal) && (message.type === messageObj.type)) {
            return message.hide();
          }
        });
      };

      /*
      # Esconde todas as mensagens
      # @method removeAllMessages
      # @param {Boolean} usingModal Flag que indica se as mensagems modais também devem ser escondidas
      # @return
      */


      VtexMessages.prototype.removeAllMessages = function(usingModal) {
        var i, message, _i, _ref;
        if (usingModal == null) {
          usingModal = false;
        }
        for (i = _i = _ref = this.messagesArray.length - 1; _i >= 0; i = _i += -1) {
          message = this.messagesArray[i];
          if ((message.usingModal === false) || (usingModal === true)) {
            message.domElement.remove();
            this.messagesArray.splice(i, 1);
          }
        }
        return this.changeContainerVisibility();
      };

      /*
      # Verifica se o container deve ser escondido, ele será escondido caso não hajam mensagens sendo exibidas
      # @method changeContainerVisibility
      # @param
      # @return
      */


      VtexMessages.prototype.changeContainerVisibility = function() {
        var notModalMessages,
          _this = this;
        notModalMessages = _.filter(this.messagesArray, function(message) {
          return message.usingModal === false;
        });
        if (notModalMessages.length === 0) {
          return $(vtex.Messages.getInstance().placeholder).hide();
        }
      };

      /*
      # Bind erros de Ajax para exibir modal de erro
      # @method bindAjaxError
      # @return
      */


      VtexMessages.prototype.bindAjaxError = function() {
        var _this = this;
        return $(document).ajaxError(function(event, xhr, ajaxOptions, thrownError) {
          var addIframeLater, errorMessage, globalClose, globalError, globalUnknownError, iframe, isContentJson, messageObj, showFullError, _ref, _ref1;
          if (xhr.status === 401 || xhr.status === 403) {
            return;
          }
          if (xhr.readyState === 0 || xhr.status === 0) {
            return;
          }
          globalUnknownError = window.i18n ? window.i18n.t('global.unkownError') : 'An unexpected error ocurred.';
          globalError = window.i18n ? window.i18n.t('global.error') : 'Error';
          globalClose = window.i18n ? window.i18n.t('global.close') : 'Close';
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
                errorMessage += '<div class="vtex-error-detail-container">\n  <a href="javascript:void(0);" class="vtex-error-detail-link" onClick="$(\'.vtex-error-detail\').show()">\n    <small>Details</small>\n  </a>\n  <div class="vtex-error-detail" style="display: none;"></div>\n</div>';
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
              detail: errorMessage,
              html: true
            },
            close: globalClose
          };
          _this.addMessage(messageObj);
          if (addIframeLater) {
            $('.vtex-error-detail').html(iframe);
            return addIframeLater = null;
          }
        });
      };

      /*
      # Constrói o template do placeholder
      # @method buildPlaceholderTemplate
      # @param
      # @return
      */


      VtexMessages.prototype.buildPlaceholderTemplate = function() {
        return $(".vtex-front-messages-placeholder").append("<button type=\"button\" class=\"vtex-front-messages-close-all close\">×</button>");
      };

      /*
      # Inicia a API de eventos
      # @method registerEventListeners
      # @param
      # @return
      */


      VtexMessages.prototype.registerEventListeners = function() {
        var _this = this;
        if (window) {
          $(window).on("addMessage.vtex", function(evt, message) {
            return _this.addMessage(message);
          });
          $(window).on("clearMessages.vtex", function(evt, usingModal) {
            if (usingModal == null) {
              usingModal = false;
            }
            return _this.removeAllMessages(usingModal);
          });
          $(window).on("removeMessage.vtex", function(evt, messageId) {
            return _this.removeMessage(messageId);
          });
          return $(".vtex-front-messages-close-all").on("click", function(evt, usingModal) {
            if (usingModal == null) {
              usingModal = false;
            }
            return _this.removeAllMessages(usingModal);
          });
        }
      };

      /*
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

      return VtexMessages;

    })();

    return Messages;

  }).call(this);

  root.vtex.Messages = Messages;

}).call(this);
