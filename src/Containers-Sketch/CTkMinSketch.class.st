Class {
	#name : #CTkMinSketch,
	#superclass : #Object,
	#instVars : [
		'sketch',
		'rankings',
		'random',
		'wBlock'
	],
	#category : #'Containers-Sketch'
}

{ #category : #'instance creation' }
CTkMinSketch class >> k: k weightBlock: wBlock [

	^ self new
		  random: (RandomExponential seed: 11);
		  weightBlock: wBlock;
		  rankings: (1 to: k);
		  yourself
]

{ #category : #private }
CTkMinSketch >> asSet [

	^ Set withAll: sketch
]

{ #category : #accessing }
CTkMinSketch >> createSketch [

	sketch := (1 to: self k) collect: [ :each | 
		          Array with: Float infinity with: nil with: nil ]
]

{ #category : #private }
CTkMinSketch >> epsilon: universeSize [

	^ (universeSize ln / self k) sqrt
]

{ #category : #'as yet unclassified' }
CTkMinSketch >> instVarsNamesOrderedCollection [

	^ super instVarsNamesOrderedCollection , #( k size )
]

{ #category : #accessing }
CTkMinSketch >> k [

	^ rankings size
]

{ #category : #accessing }
CTkMinSketch >> random: anObject [

	random := anObject
]

{ #category : #accessing }
CTkMinSketch >> rankings: anObject [

	rankings := anObject.

	self createSketch
]

{ #category : #accessing }
CTkMinSketch >> size [

	^ self weightEstimation ceiling
]

{ #category : #accessing }
CTkMinSketch >> sketch [

	^ sketch copy
]

{ #category : #updating }
CTkMinSketch >> update: u [

	| w |
	w := wBlock value: u.
	random lambda: w.

	sketch do: [ :each | 
		| rank |
		rank := random next.

		rank < each first ifTrue: [ 
			each
				at: 1 put: rank;
				at: 2 put: w;
				at: 3 put: u ] ]
]

{ #category : #'as yet unclassified' }
CTkMinSketch >> weightBlock: aBlock [

	wBlock := aBlock
]

{ #category : #accessing }
CTkMinSketch >> weightEstimation [

	| ranksSum |
	ranksSum := sketch inject: 0 into: [ :sum :each | sum + each first ].
	^ self k - 1 / ranksSum
]
