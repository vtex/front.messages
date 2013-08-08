$.mockjax({
  url: '/restful/api',
  // Server 500 error occurred
  status: 500,
  responseText: "Aconteceu um erro no Rates and Benefits"
  ,headers: {
  	"x-vtex-operation-id": "123",
		"x-vtex-error-message": "Rates and Benefits error 456"
  }
});