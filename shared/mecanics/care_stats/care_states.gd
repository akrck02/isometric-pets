class_name CareEnums
enum State {
	ANGRY = 0, 
	HAPPY = 1,
	HUNGRY = 2,
	SAD = 3
}


static func mood_name_for(mood : CareEnums.State) -> String:
	match mood:
		CareEnums.State.HAPPY : return "happy"
		CareEnums.State.ANGRY : return "angry"
		CareEnums.State.HUNGRY : return "hungry"
		CareEnums.State.SAD :  return "sad"
	return ""
