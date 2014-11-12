$ ->
  window.messages = new window.vtex.Messages.getInstance({ajaxError:true})

  modalMessage =
    content:
      title: 'Erro 1!'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'fatal'

  $(window).trigger('addMessage', modalMessage);

  regularMessage =
    content:
      title: 'Erro 2'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'error'
    timeout: 10 * 1000

  $(window).trigger('addMessage', regularMessage);

  #$.ajax("http://staples.vtexlocal.com.br/Site/OutrasFormasPagamento.aspx?IdSku=2008124&PopupComum=true")