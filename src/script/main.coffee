$ ->
  window.messages = new window.vtex.Messages.getInstance({ajaxError:true})

#  modalMessage =
#    content:
#      title: 'Erro 1!'
#      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
#    type: 'fatal'

  errorMessage =
    content:
      title: 'Error'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'error'

  warningMessage =
    content:
      title: 'Warning'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'warning'

  successMessage =
    content:
      title: 'Success'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'success'
    timeout: 0

  infoMessage =
    content:
      title: 'Info'
      detail: 'Ocorreu um erro inesperado nos nossos servidores.'
    type: 'info'

  #$(window).trigger('addMessage', modalMessage);
  $(window).trigger('addMessage', errorMessage);
  $(window).trigger('addMessage', warningMessage);
  $(window).trigger('addMessage', successMessage);
  $(window).trigger('addMessage', infoMessage);

  #$.ajax("http://staples.vtexlocal.com.br/Site/OutrasFormasPagamento.aspx?IdSku=2008124&PopupComum=true")