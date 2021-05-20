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

	| sketch rankings random shuffling size |
	random := Random seed: 11.
	shuffling := aCollection asArray copy.
	size := aCollection size.
	sketch := self new.

	rankings := (1 to: k) collect: [ :i | 
		            | rank |
		            rank := Dictionary new.
		            (shuffling shuffleBy: random) withIndexDo: [ :each :index | 
			            rank at: each put: index / size ].
		            rank ].

	^ sketch
		  rankings: rankings;
		  yourself
]

{ #category : #private }
CTSketch >> asSet [

	^ Set withAll: sketch
]

{ #category : #private }
CTSketch >> epsilon [

	^ (rankings first size ln / self k) sqrt
]

{ #category : #accessing }
CTSketch >> k [

	^ rankings size
]

{ #category : #accessing }
CTSketch >> rankings: anObject [

	rankings := anObject.

	sketch := Array new: self k
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
