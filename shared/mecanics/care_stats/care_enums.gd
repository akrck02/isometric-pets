class_name CareEnums
enum Mood {
	ANGRY = 0, 
	HAPPY = 1,
	HUNGRY = 2,
	SAD = 3
}


static func mood_name_for(mood : CareEnums.Mood) -> String:
	match mood:
		CareEnums.Mood.HAPPY : return "happy"
		CareEnums.Mood.ANGRY : return "angry"
		CareEnums.Mood.HUNGRY : return "hungry"
		CareEnums.Mood.SAD :  return "sad"
	return ""
