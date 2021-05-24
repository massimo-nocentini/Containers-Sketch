Class {
	#name : #CTBottomKSketch,
	#superclass : #CTSketch,
	#category : #'Containers-Sketch'
}

{ #category : #'instance creation' }
CTBottomKSketch class >> onCollection: aCollection kMin: k [

	| rank size |
	size := aCollection size.
	rank := Dictionary new.

	(aCollection copy asArray shuffleBy: (Random seed: 11)) withIndexDo: [ 
		:each 
		:index | rank at: each put: index / size ].

	^ self new
		  rankings: (Array with: rank withAll: (1 to: k - 1));
		  yourself
]

{ #category : #updating }
CTBottomKSketch >> kth [

	| rank sorted |
	rank := rankings first.
	"^ rank at: sketch min negated"

	sorted := sketch heap sorted: [ :a :b | 
		          (rank at: a negated) < (rank at: b negated) ].
	^ rank at: sorted last negated
]

{ #category : #accessing }
CTBottomKSketch >> rank [

	| rank |
	rank := rankings first.
	^ (sketch heap sorted: [ :a :b | 
		   (rank at: a negated) < (rank at: b negated) ]) collect: [ :neach | 
		  | each |
		  each := neach negated.
		  each -> (rank at: each) ]
]

{ #category : #accessing }
CTBottomKSketch >> rankings: aCollection [

	rankings := aCollection.

	sketch := CTHeapQ new
]

{ #category : #updating }
CTBottomKSketch >> size [

	^ (self k - 1 / self kth) ceiling
]

{ #category : #updating }
CTBottomKSketch >> update: u [

	sketch size < self k
		ifTrue: [ sketch push: u negated ]
		ifFalse: [ 
			| max rank |
			rank := rankings first.
			max := sketch min negated.
			(rank at: max) > (rank at: u ifAbsent: [ Float infinity ]) ifTrue: [ 
				sketch popPush: u negated ] ]
]
