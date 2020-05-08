Object subclass: #CuOOra
	questions add: aQuestion! !
	aUser addQuestion: aQuestion.
	questions add: aQuestion.! !
	users add: aUser 
! !
	topics add: aTopic 
! !
	users := OrderedCollection new.
	topics := OrderedCollection new.
	questions := OrderedCollection new! !
	^ description! !
	^ votes! !
	^ timestamp! !
	^ user! !
	timestamp := anObject! !
	user := anObject! !
	description := anObject! !
	^ votes select: [ :v | v isLike = false ].	! !
	^ votes select: [ :v | v isLike ].	! !
	question := aQuestion ! !
	^ self positiveVotes >=  ((question sum: [:answer | answer positiveVotes size ]) / question answer size ).! !
	^ self newUser: aUser description: anAnswer; question: aQuestion .
! !
	^topics ! !
	title := aTitle ! !
	^title ! !
	topics add: aTopic.
	aTopic addQuestion: self.
! !
	answers := OrderedCollection new.
	topics := OrderedCollection new.
! !
	^ self new
		title: title;
		description: aDescription;
		user: aUser;
		yourself.! !
	^ self new
		title: title;
		description: aDescription;
		addTopic: aTopic;
		user: aUser;
		yourself.! !
	| qRet temp followingCol topicsCol newsCol popularTCol averageVotes|
	qRet := OrderedCollection new.
	option = #social ifTrue:[
			followingCol := OrderedCollection new.
			aUser following do:[ :follow | followingCol addAll: follow questions ].
			temp := followingCol asSortedCollection:[ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size).
		].

	option = #topics ifTrue:[
			topicsCol := OrderedCollection new.
			aUser topics do:[ :topic | topicsCol addAll: topic questions ].
			temp := topicsCol asSortedCollection:[ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size).
		].
	
	option = #news ifTrue:[
			newsCol := OrderedCollection new.
			cuoora questions do:[:q | (q timestamp asDate = Date today) ifTrue: [newsCol add: q]].
			temp := newsCol asSortedCollection:[ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size).
		].

	option = #popularToday ifTrue:[
			popularTCol := OrderedCollection new.
			cuoora questions do:[:q | (q timestamp asDate = Date today) ifTrue: [popularTCol add: q]].
			averageVotes := (cuoora questions sum: [:q | q positiveVotes size ]) / popularTCol size.
			temp := (popularTCol select:[:q | q positiveVotes size >= averageVotes ]) asSortedCollection:[ :a :b | a positiveVotes size > b positiveVotes size ].
			qRet := temp last: (100 min: temp size).
		].
	
	^qRet reject:[:q | q user = aUser].! !
	option := #social! !
	cuoora := aCuooraInstance ! !
	option := anOption! !
	^ self new cuoora: cuoora! !
	^ self new cuoora: cuoora; option:aSymbol; yourself.! !
	^name! !
	^ questions! !
	name := anObject! !
	questions add: aQuetion ! !
	description := anObject! !
	^ description! !
	questions := OrderedCollection new.! !
	^ self new
		name: aName;
		description: aDescription;
		yourself! !
	password := anObject! !
	username := anObject! !
	questionRetriever := aQuestionRetriever.! !

	questions := OrderedCollection new.  
	answers := OrderedCollection new. 
	topics := OrderedCollection new. 
	following := OrderedCollection new. 
	votes := OrderedCollection new.! !
	^ questions! !
	^ votes! !
	votes add: aVote! !
	following add: aUser ! !
	^ questionRetriever! !
	^ topics! !
	^ username! !
	^ answers! !
	^ password! !
	^ following! !
	topics add: aTopic 
! !
	questions add: aQuestion! !
	answers add: anAnswer 
! !
	^ questionRetriever retrieveQuestions: self.! !
	^ self new
		username: aUsername;
		password: aPassword;
		questionRetriever: aQuestionRetriever;
		yourself! !
	isLike := true.
	timstamp := DateAndTime now.
	! !
	^ user! !
	^ publication! !
	^ isLike! !
	publication := anObject! !
	isLike := false.! !
	user := anObject! !
	isLike := true.! !
	^ self new
		user: aUser;
		publication: aPublication;
		yourself! !
	^ self new
		user: aUser;
		publication: aPublication;
		dislike;
		yourself! !