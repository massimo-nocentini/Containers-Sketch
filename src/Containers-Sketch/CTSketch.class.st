Class {
	#name : #CTSketch,
	#superclass : #Object,
	#instVars : [
		'sketch',
		'rankings'
	],
	#category : #'Containers-Sketch'
}

{ #category : #'instance creation' }
CTSketch class >> onCollection: aCollection epsilon: e [

	^ self
		  onCollection: aCollection
		  kMin: (aCollection size ln / e squared) ceiling
]

{ #category : #'instance creation' }
CTSketch class >> onCollection: aCollection kMin: k [

	| rankings random shuffling size |
	random := Random seed: 11.
	shuffling := aCollection asArray copy.
	size := aCollection size.

	rankings := (1 to: k) collect: [ :i | 
		            | rank |
		            rank := Dictionary new.
		            (shuffling shuffleBy: random) withIndexDo: [ :each :index | 
			            rank at: each put: index / size ].
		            rank ].

	^ self new
		  rankings: rankings;
		  yourself
]

{ #category : #private }
CTSketch >> asSet [

	^ Set withAll: sketch
]

{ #category : #accessing }
CTSketch >> createSketch [

	sketch := Array new: self k
]

{ #category : #private }
CTSketch >> epsilon [

	^ (rankings first size ln / self k) sqrt
]

{ #category : #'as yet unclassified' }
CTSketch >> instVarsNamesOrderedCollection [

	^ #( rank ) , super instVarsNamesOrderedCollection
	  , #( k size  )
]

{ #category : #accessing }
CTSketch >> k [

	^ rankings size
]

{ #category : #'as yet unclassified' }
CTSketch >> rank [

	^ sketch collect: [ :each | 
		  each -> (rankings collect: [ :rank | rank at: each ]) ]
]

{ #category : #accessing }
CTSketch >> rankings: anObject [

	rankings := anObject.

	self createSketch
]

{ #category : #accessing }
CTSketch >> size [

	| sum |
	sum := 0.
	sketch
		with: rankings
		do: [ :a :rank | sum := sum + (rank at: a ifAbsent: [ 0 ]) ].

	^ sum isZero
		  ifTrue: [ 0 ]
		  ifFalse: [ (self k / sum - 1) ceiling ]
]

{ #category : #accessing }
CTSketch >> sketch [

	^ sketch copy
]

{ #category : #updating }
CTSketch >> update: u [

	1 to: self k do: [ :i | 
		| a rank |
		a := sketch at: i.
		rank := rankings at: i.

		(rank at: a ifAbsent: [ Float infinity ])
		> (rank at: u ifAbsent: [ Float infinity ]) ifTrue: [ 
			sketch at: i put: u ] ]
]
