$ ->
  window.messages = new window.vtex.Messages.getInstance({ajaxError:true})

  modalMessage =
    content:
      title: 'Erro 1!'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'fatal'

  errorMessage =
    content:
      title: 'Erro 2'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'error'
    timeout: 0

  warningMessage =
    content:
      title: 'Erro 2'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'warning'
    timeout: 0

  successMessage =
    content:
      title: 'Erro 2'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'success'
    timeout: 30 * 1000

  infoMessage =
    content:
      title: 'Erro 2'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'info'
    timeout: 15 * 1000


  $(window).trigger('addMessage', modalMessage);
  $(window).trigger('addMessage', errorMessage);
  $(window).trigger('addMessage', warningMessage);
  $(window).trigger('addMessage', successMessage);
  $(window).trigger('addMessage', infoMessage);

  #$.ajax("http://staples.vtexlocal.com.br/Site/OutrasFormasPagamento.aspx?IdSku=2008124&PopupComum=true")