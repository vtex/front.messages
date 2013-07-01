
jasmine.getFixtures().fixturesPath = "base/build/spec/fixtures"

describe 'Messages', ->		

	beforeEach ->
		loadFixtures "base.html"

	it 'should have jQuery and Underscore', ->
		expect($).toBeDefined()
		expect(_).toBeDefined()

	it 'should create Message obj', ->
		# Arrange		
		# Act
		messages = new window.vtex.Messages()
		
		# Assert
		expect(messages).toBeDefined()

	describe '-', ->
		messages = undefined

		beforeEach ->
			messages = new window.vtex.Messages()

		it 'should add a Message type object to messagesArray', ->
			# Arrange

			# Act
			wrap = =>
				messages.addMessage()
			
			# Assert
			expect(wrap).not.toThrow()
			expect(messages.messagesArray.length).toBe(1)

		it 'should remove a specific Message using a map of properties', ->
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

		it 'should return a Message object after adding a new Message', ->
			# Arrange
		
			# Act
			message = messages.addMessage({id: 'messageId'})			

			# Assert
			expect(message.id).toEqual("messageId")
			expect(message.type).toEqual("info")
			expect($(message.domElement, message.placeholder)).not.toBeVisible()

		it 'should remove a specific Message using its object', ->
			# Arrange
			mes = messages.addMessage()
		
			# Act
			messages.removeMessage(mes)
		
			# Assert
			expect(messages.messagesArray.length).toBe(0)

		it 'should show a Message', ->
			# Arrange
			message = messages.addMessage()

			# Act
			message.show()
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement, message.placeholder)).toExist()
			expect($(message.domElement, message.placeholder)).toBeVisible()

		it 'should place many Messages in one placeholder', ->
			# Arrange
			message = messages.addMessage()
			message2 = messages.addMessage()

			# Act
			message.show()
			message2.show()
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(">", message.placeholder).length).toBe(2)

		it 'should add and show Message when adding a new message with show equals true', ->
			# Arrange
		
			# Act
			message = messages.addMessage({}, true)
		
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement, message.placeholder)).toExist()
			expect($(message.domElement, message.placeholder)).toBeVisible()

		it 'should callback when fading in Message is done', ->
			# Arrange
			foo = { duration: 0 }
			callback = jasmine.createSpy('callback')
			foo.complete = callback
					
			# Act
			message = messages.addMessage({}, foo)
		
			# Assert
			expect(callback).toHaveBeenCalled()

		it 'should callback when fading out Message is done', ->
			# Arrange
			foo = { duration: 0 }
			callback = jasmine.createSpy('callback')
			foo.complete = callback
					
			# Act
			message = messages.addMessage({}, true)
			message.hide(foo)
		
			# Assert
			expect(callback).toHaveBeenCalled()

		it 'should fade in Message when passing integer', ->
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

		it 'should fade out Message when passing integer', ->
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

		it 'should show as modal when type is fatal', ->
			# Arrange
			opts = 
				type: 'fatal'
				usingModal: false
		
			# Act
			message = messages.addMessage(opts)
		
			# Assert
			expect(message.usingModal).toBe(true)

		it 'should show message when adding with visible true', ->
			# Arrange
		
			# Act
			message = messages.addMessage({visible: true})
					
			# Assert
			expect(message.visible).toBe(true)
			expect($(message.domElement,message.placeholder)).toBeVisible()

		it 'should destroy a message dom element after removal', ->
			# Arrange
			messProp = messages.addMessage({}, true)
			message = messages.addMessage({}, true)		
			expect($(messProp.domElement,messProp.placeholder)).toBeVisible()
			expect($(message.domElement,message.placeholder)).toBeVisible()
		
			# Act
			messages.removeMessage(message)
		
			# Assert
			expect($(messProp.domElement,messProp.placeholder)).toExist()
			expect($(message.domElement,message.placeholder)).not.toExist()