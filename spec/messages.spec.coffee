
jasmine.getFixtures().fixturesPath = "base/build/spec/fixtures"
jasmine.getJSONFixtures().fixturesPath = "base/build/spec/fixtures"

describe "Messages", ->

	beforeEach ->
		loadFixtures "base.html"

	it "should have jQuery and Underscore", ->
		expect($).toBeDefined()
		expect(_).toBeDefined()

	it "should create Message obj", ->
		# Arrange		
		# Act
		messages = new window.vtex.Messages()
		
		# Assert
		expect(messages).toBeDefined()

	describe "-", ->
		messages = undefined

		beforeEach ->
			messages = new window.vtex.Messages()

		it "should add a Message type object to messagesArray", ->
			# Arrange

			# Act
			wrap = =>
				messages.addMessage()
			
			# Assert
			expect(wrap).not.toThrow()
			expect(messages.messagesArray.length).toBe(1)

		it "should remove a specific Message using a map of properties", ->
			# Arrange
			propId = "vtex-id-specific"
			propType = "warning"
			mes1 = messages.addMessage({id: propId})
			mes2 = messages.addMessage({type: propType})

			# Act
			filter =
				id: propId
			messages.removeMessage(filter)
			filter =
				type: propType
			messages.removeMessage(filter)
			
			# Assert
			expect(messages.messagesArray.length).toBe(0)

		it "should return a Message object after adding a new Message", ->
			# Arrange
		
			# Act
			message = messages.addMessage({id: "messageId"})

			# Assert
			expect(message.id).toEqual("messageId")
			expect(message.type).toEqual("info")
			expect($(message.domElement, message.placeholder)).not.toBeVisible()

		it "should show a Message", ->
			# Arrange
			message = messages.addMessage()

			# Act
			message.show()
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement, message.placeholder)).toExist()
			expect($(message.domElement, message.placeholder)).toBeVisible()

		it "should place many Messages in one placeholder", ->
			# Arrange
			message = messages.addMessage()
			message2 = messages.addMessage()

			# Act
			message.show()
			message2.show()
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(">", message.placeholder).length).toBe(2)

		it "should add and show Message when adding a new message with show equals true", ->
			# Arrange
		
			# Act
			message = messages.addMessage({}, true)
		
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement, message.placeholder)).toExist()
			expect($(message.domElement, message.placeholder)).toBeVisible()

		it "should callback when fading in Message is done", ->
			# Arrange
			foo = { duration: 0 }
			callback = jasmine.createSpy("callback")
			foo.complete = callback
					
			# Act
			message = messages.addMessage({}, foo)
		
			# Assert
			expect(callback).toHaveBeenCalled()

		it "should callback when fading out Message is done", ->
			# Arrange
			foo = { duration: 0 }
			callback = jasmine.createSpy("callback")
			foo.complete = callback
					
			# Act
			message = messages.addMessage({}, true)
			message.hide(foo)
		
			# Assert
			expect(callback).toHaveBeenCalled()

		it "should fade in Message when passing integer", ->
			# Arrange
			message = messages.addMessage()
			duration = 10

			# Act
			runs ->
				message.show(duration)
			
			# Assert
			runs ->
				expect(message.visible).toBe(false)
				expect($(message.domElement,message.placeholder)).toHaveCss({opacity: "0"})

			waitsFor ->
				return message.visible
			, "Fade out was not completed", duration+1
			
			runs ->
				expect(message.visible).toBe(true)
				expect($(message.domElement,message.placeholder)).toBeVisible()

		it "should fade out Message when passing integer", ->
			# Arrange
			message = messages.addMessage()
			message.show()
			duration = 10

			# Act
			runs ->
				message.hide(duration)
			
			# Assert
			runs ->
				expect(message.visible).toBe(true)
				expect($(message.domElement,message.placeholder)).toHaveCss({opacity: "1"})

			waitsFor ->
				return message.visible is false
			, "Fade out was not completed", duration+1
			
			runs ->
				expect(message.visible).toBe(false)
				expect($(message.domElement,message.placeholder)).not.toBeVisible()

		it "should show as modal when type is fatal", ->
			# Arrange
			opts = 
				type: "fatal"
				usingModal: false
		
			# Act
			message = messages.addMessage(opts)
		
			# Assert
			expect(message.usingModal).toBe(true)

		it "should show message when adding with visible true", ->
			# Arrange
		
			# Act
			message = messages.addMessage({visible: true})
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement,message.placeholder)).toBeVisible()

		it "should call event functions when it is a modal message", ->
			# Arrange
			opts = { type: "fatal" }
			
			shownFn = jasmine.createSpy("shownFn")
			showOptions = { shown: shownFn }

			$.support.transition = false

			# Act
			message = messages.addMessage(opts, showOptions)

			# Assert
			expect(showOptions.shown).toHaveBeenCalled()
			expect(showOptions.shown.mostRecentCall.args[0]).toEqual(message)
			expect(message.visible).toBe(true)

		it 'should hide the title if it is and empty string', ->
			# Arrange
			opts =
				content:
					title: ''
					detail: 'foo'

			# Act
			message = messages.addMessage(opts, true)
			
			# Assert
			expect($(message.classes.TITLE, message.domElement)).not.toBeVisible()
			expect($(message.classes.DETAIL, message.domElement)).toBeVisible()

		it 'should show the message contents inside the elements specified', ->
			# Arrange
			opts =
				content:
					title: 'foo'
					detail: 'bar'

			# Act
			message = messages.addMessage(opts, true)
			
			# Assert
			expect($(message.classes.TITLE, message.domElement)).toBeVisible()
			expect($(message.classes.DETAIL, message.domElement)).toBeVisible()
			expect($(message.classes.TITLE, message.domElement).html()).toMatch('foo')
			expect($(message.classes.DETAIL, message.domElement).html()).toMatch('bar')

	describe "AJAX", ->

		ajaxResponses = {}
		messages = undefined

		beforeEach ->
			#loadJSONFixtures("messages-api.json")
			#responseJSON = fixtures["messages-api.json"]
			messages = new window.vtex.Messages({ajaxError: true})
			jasmine.Ajax.useMock()
			ajaxResponses = {
				"success": {
					"status": 200,
					"responseText": '{
						"messages": [
							{
								"code": "123",
								"text": "oi",
								"status": "fatal"
							}
						]
					}'
				},
				"fatalError": {
					"status": 500,
					"responseHeaders": {
						"x-vtex-operation-id": "123",
						"x-vtex-error-message": "Rates and Benefits error 456"
					},
					"responseText": "An unexpected error."
				},
				"notFound": {
					"status": 404,
					"responseText": '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/><title>404 - File or directory not found.</title><style type="text/css"><!-- body{margin:0;font-size:.7em;font-family:Verdana, Arial, Helvetica, sans-serif;background:#EEEEEE;}fieldset{padding:0 15px 10px 15px;} h1{font-size:2.4em;margin:0;color:#FFF;}h2{font-size:1.7em;margin:0;color:#CC0000;} h3{font-size:1.2em;margin:10px 0 0 0;color:#000000;} #header{width:96%;margin:0 0 0 0;padding:6px 2% 6px 2%;font-family:"trebuchet MS", Verdana, sans-serif;color:#FFF;background-color:#555555;}#content{margin:0 0 0 2%;position:relative;}.content-container{background:#FFF;width:96%;margin-top:8px;padding:10px;position:relative;}--></style></head><body><div id="header"><h1>Server Error</h1></div><div id="content"> <div class="content-container"><fieldset>  <h2>404 - File or directory not found.</h2>  <h3>The resource you are looking for might have been removed, had its name changed, or is temporarily unavailable.</h3> </fieldset></div></div></body></html>'
				}
			}	

		it "should show a modal Message when an AJAX error occurs", ->
			# Arrange			
			$.support.transition = false

			# Act
			$.ajax("http://httpstat.us/500")
			request = mostRecentAjaxRequest()
			request.response(ajaxResponses.fatalError)

			# Assert
			expect(messages.messagesArray.length).toBe(1)
			message = messages.messagesArray[0]
			expect(message.usingModal).toBe(true)
			expect(message.content.title).toMatch("123")

		it "should not show a modal Message when a non-error AJAX occurs", ->
			# Arrange
					
			# Act
			$.ajax("http://httpstat.us/200")
			request1 = mostRecentAjaxRequest()
			request1.response(ajaxResponses.success)
		
			# Assert
			expect(messages.messagesArray.length).toBe(0)