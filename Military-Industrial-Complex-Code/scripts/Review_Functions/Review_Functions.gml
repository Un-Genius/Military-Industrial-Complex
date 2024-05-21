
function func_review_theory(_inst){
	var _chat_history	=	"This is the chat history to a simulated interaction in a game: " +
							string(_inst.chatHistory);
		
	var _system =	"You're a mentor to the missionary named \"" +
					global.gender + " " + global.name + "\". " +
					"This is the chat history to a simulated interaction in a game. " +
					"Give advice on their sales pitch / discussion approach. " +
					"Keep a max of 200 words. Respond in JSON with the key \"review\".";
		
	send_gpt(_system, _chat_history);
		
	func_update_review_text("theory");
}

function func_review_language(_inst){
	var _chat_history	=	"This is the chat history to a simulated interaction in a game: " +
							string(_inst.chatHistory);
		
	var _system =	"You're a mentor to the missionary \"" +
					global.gender + " " + global.name + "\". " +
					"Your primary goal is to identify and correct areas that could lead to confusion for the character. " +
					"Follow these steps to answer the user queries. In all these steps, review only from \"" + global.gender + " " + global.name + "\". " +
					"Step 1 - Give a summary on the spelling, grammar, clarity, and sentence structure." +
					"Step 2 - Show examples and advice on where they could focus or study next. " +
					"Keep a max of 200 words. Respond in JSON with the key \"review\".";
		
	send_gpt(_system, _chat_history);
	
	func_update_review_text("language");
}

function func_review_questions(_inst){
	var _chat_history	=	"This is the chat history from a simulated interaction: " +
							string(_inst.chatHistory);
		
	var _system =	"You're a mentor to the missionary \"" + global.gender + " " + global.name + "\". " +
					"The following are examples of good questions you can suggest to the player: " +
					"'''What do you believe about God? " +
					"How would feeling closer to God help you? " +
					"What do you know about Jesus Christ? How have His life and teachings influenced you? " +
					"How do you find reliable answers in today’s confusing world? " +
					"How would it help you to know that there is a living prophet on the earth today? " +
					"Have you heard of the Book of Mormon? May we share why it is important? " +
					"Would you share your beliefs about prayer? May we share our beliefs about prayer?''' " +
						
					"Follow these steps to create an answer:" +
					"Step 1 - Give a summary of the quality of the questions asked. " +
					"Step 2 - Teach " + global.name + " how they could improve his questions using some examples." +
					"Keep a max of 200 words. Respond in JSON with the key \"review\".";
		
	send_gpt(_system, _chat_history);
	
	func_update_review_text("questions");
}

function func_update_review_text(_review_topic){
	with(obj_dialogueSystem)
	{
		var _elementObject = array_last(menu_elements);
		_elementObject.text = "Reviewing for " + _review_topic + ". Just give it a moment to evaluate and load. This will depend on your internet.";
		_elementObject.alarm[0] = 5;
	}
}