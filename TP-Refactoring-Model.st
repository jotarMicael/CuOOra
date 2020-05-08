Object subclass: #CuOOra	instanceVariableNames: 'users topics questions'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!CuOOra methodsFor: 'adding'!addQuestion: aQuestion
	questions add: aQuestion! !!CuOOra methodsFor: 'adding'!addQuestion: aQuestion forUser: aUser
	aUser addQuestion: aQuestion.
	questions add: aQuestion.! !!CuOOra methodsFor: 'adding'!addUser: aUser
	users add: aUser 
! !!CuOOra methodsFor: 'adding'!addTopic: aTopic
	topics add: aTopic 
! !!CuOOra methodsFor: 'initialize'!initialize
	users := OrderedCollection new.
	topics := OrderedCollection new.
	questions := OrderedCollection new! !Object subclass: #Post	instanceVariableNames: 'user description timestamp votes'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!Post methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 17:50'!description
	^ description! !!Post methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 17:51'!votes
	^ votes! !!Post methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 17:51'!timestamp
	^ timestamp! !!Post methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 17:51'!user
	^ user! !!Post methodsFor: 'private' stamp: 'VIsa 4/29/2020 17:51'!timestamp: anObject
	timestamp := anObject! !!Post methodsFor: 'private' stamp: 'VIsa 4/29/2020 17:51'!user: anObject
	user := anObject! !!Post methodsFor: 'private' stamp: 'VIsa 4/29/2020 17:55'!description: anObject
	description := anObject! !!Post methodsFor: 'adding' stamp: 'VIsa 4/29/2020 17:50'!addVote: aVote	votes add: aVote! !!Post methodsFor: 'as yet unclassified' stamp: 'VIsa 4/29/2020 17:51'!negativeVotes
	^ votes select: [ :v | v isLike = false ].	! !!Post methodsFor: 'as yet unclassified' stamp: 'VIsa 4/29/2020 17:51'!positiveVotes
	^ votes select: [ :v | v isLike ].	! !!Post methodsFor: 'initialization' stamp: 'VIsa 4/29/2020 18:29'!initializetimestamp:= DateAndTime now.votes:= OrderedCollection new.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Post class	instanceVariableNames: ''!!Post class methodsFor: 'instance creation' stamp: 'VIsa 4/29/2020 18:12'!newUser: unUser description: unaDesc	^ self new user: unUser ; description: unaDesc. ! !Post subclass: #Answer	instanceVariableNames: 'question'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!Answer methodsFor: 'private'!question: aQuestion
	question := aQuestion ! !!Answer methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 19:33'!isTopAnswer
	^ self positiveVotes >=  ((question sum: [:answer | answer positiveVotes size ]) / question answer size ).! !!Answer methodsFor: 'accessing' stamp: 'VIsa 4/29/2020 18:15'!question	^ question.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Answer class	instanceVariableNames: ''!!Answer class methodsFor: 'instance creation' stamp: 'VIsa 4/29/2020 18:39'!new: anAnswer conUser: aUser yQuestion: aQuestion
	^ self newUser: aUser description: anAnswer; question: aQuestion .
! !Post subclass: #Question	instanceVariableNames: 'title answers topics'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!Question methodsFor: 'accessing'!topics
	^topics ! !!Question methodsFor: 'accessing'!title: aTitle
	title := aTitle ! !!Question methodsFor: 'accessing'!title
	^title ! !!Question methodsFor: 'adding'!addTopic: aTopic
	topics add: aTopic.
	aTopic addQuestion: self.
! !!Question methodsFor: 'initalize-release' stamp: 'VIsa 4/29/2020 18:42'!initialize	super initialize.
	answers := OrderedCollection new.
	topics := OrderedCollection new.
! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Question class	instanceVariableNames: ''!!Question class methodsFor: 'instance creation'!newWithTitle: title description: aDescription user: aUser
	^ self new
		title: title;
		description: aDescription;
		user: aUser;
		yourself.! !!Question class methodsFor: 'instance creation'!newWithTitle: title description: aDescription user: aUser topic: aTopic
	^ self new
		title: title;
		description: aDescription;
		addTopic: aTopic;
		user: aUser;
		yourself.! !Object subclass: #QuestionRetriever	instanceVariableNames: 'option cuoora'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!QuestionRetriever methodsFor: 'retrieving'!retrieveQuestions: aUser
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
	
	^qRet reject:[:q | q user = aUser].! !!QuestionRetriever methodsFor: 'initializing'!initialize
	option := #social! !!QuestionRetriever methodsFor: 'accesing'!cuoora: aCuooraInstance
	cuoora := aCuooraInstance ! !!QuestionRetriever methodsFor: 'accesing'!option: anOption
	option := anOption! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!QuestionRetriever class	instanceVariableNames: ''!!QuestionRetriever class methodsFor: 'instance creation'!new: cuoora
	^ self new cuoora: cuoora! !!QuestionRetriever class methodsFor: 'instance creation'!new: cuoora and: aSymbol
	^ self new cuoora: cuoora; option:aSymbol; yourself.! !Object subclass: #Topic	instanceVariableNames: 'name description questions'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!Topic methodsFor: 'accessing'!name
	^name! !!Topic methodsFor: 'accessing'!questions
	^ questions! !!Topic methodsFor: 'accessing'!name: anObject
	name := anObject! !!Topic methodsFor: 'accessing'!addQuestion: aQuetion
	questions add: aQuetion ! !!Topic methodsFor: 'accessing'!description: anObject
	description := anObject! !!Topic methodsFor: 'accessing'!description
	^ description! !!Topic methodsFor: 'initialize'!initialize
	questions := OrderedCollection new.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Topic class	instanceVariableNames: ''!!Topic class methodsFor: 'intance creation'!name: aName description: aDescription
	^ self new
		name: aName;
		description: aDescription;
		yourself! !Object subclass: #User	instanceVariableNames: 'questionRetriever questions answers username password topics following votes'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!User methodsFor: 'private'!password: anObject
	password := anObject! !!User methodsFor: 'private'!username: anObject
	username := anObject! !!User methodsFor: 'private'!questionRetriever: aQuestionRetriever
	questionRetriever := aQuestionRetriever.! !!User methodsFor: 'initialize'!initialize

	questions := OrderedCollection new.  
	answers := OrderedCollection new. 
	topics := OrderedCollection new. 
	following := OrderedCollection new. 
	votes := OrderedCollection new.! !!User methodsFor: 'accessing'!questions
	^ questions! !!User methodsFor: 'accessing'!votes
	^ votes! !!User methodsFor: 'accessing'!addVote: aVote
	votes add: aVote! !!User methodsFor: 'accessing'!follow: aUser
	following add: aUser ! !!User methodsFor: 'accessing'!questionRetriever
	^ questionRetriever! !!User methodsFor: 'accessing'!topics
	^ topics! !!User methodsFor: 'accessing'!username
	^ username! !!User methodsFor: 'accessing'!answers
	^ answers! !!User methodsFor: 'accessing'!password
	^ password! !!User methodsFor: 'accessing'!following
	^ following! !!User methodsFor: 'accessing'!addTopic: aTopic
	topics add: aTopic 
! !!User methodsFor: 'accessing'!addQuestion: aQuestion
	questions add: aQuestion! !!User methodsFor: 'accessing'!addAnswer: anAnswer
	answers add: anAnswer 
! !!User methodsFor: 'accessing'!questionsOfInterest
	^ questionRetriever retrieveQuestions: self.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!User class	instanceVariableNames: ''!!User class methodsFor: 'instance-creation'!username: aUsername password: aPassword questionRetriever: aQuestionRetriever
	^ self new
		username: aUsername;
		password: aPassword;
		questionRetriever: aQuestionRetriever;
		yourself! !Object subclass: #Vote	instanceVariableNames: 'isLike timstamp publication user'	classVariableNames: ''	poolDictionaries: ''	category: 'TP-Refactoring-Model'!!Vote methodsFor: 'initialize'!initialize
	isLike := true.
	timstamp := DateAndTime now.
	! !!Vote methodsFor: 'accessing'!user
	^ user! !!Vote methodsFor: 'accessing'!publication
	^ publication! !!Vote methodsFor: 'accessing'!isLike
	^ isLike! !!Vote methodsFor: 'private'!publication: anObject
	publication := anObject! !!Vote methodsFor: 'private'!dislike
	isLike := false.! !!Vote methodsFor: 'private'!user: anObject
	user := anObject! !!Vote methodsFor: 'private'!like
	isLike := true.! !"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!Vote class	instanceVariableNames: ''!!Vote class methodsFor: 'instance creation'!user: aUser likesPublication: aPublication
	^ self new
		user: aUser;
		publication: aPublication;
		yourself! !!Vote class methodsFor: 'instance creation'!user: aUser dislikesPublication: aPublication
	^ self new
		user: aUser;
		publication: aPublication;
		dislike;
		yourself! !