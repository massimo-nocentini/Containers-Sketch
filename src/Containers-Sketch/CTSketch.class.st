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

	| sketch rankings random |
	random := Random seed: 11.

	sketch := self new.

	rankings := (1 to: k) collect: [ :i | Dictionary new ].

	aCollection withIndexDo: [ :each :size | 
		rankings do: [ :rank | 
			rank at: each put: (random nextInteger: size) reciprocal ] ].

	^ sketch
		  rankings: rankings;
		  yourself
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
