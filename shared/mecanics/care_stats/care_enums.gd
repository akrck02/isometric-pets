class_name CareEnums
enum Mood {
	ANGRY = 0, 
	HAPPY = 1,
	HUNGRY = 2,
	SAD = 3,
	TIRED = 4
}


static func mood_name_for(mood : CareEnums.Mood) -> String:
	match mood:
		CareEnums.Mood.HAPPY : return "happy"
		CareEnums.Mood.ANGRY : return "angry"
		CareEnums.Mood.HUNGRY : return "hungry"
		CareEnums.Mood.SAD :  return "sad"
		CareEnums.Mood.TIRED :  return "tired"
	return ""
