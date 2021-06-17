Class {
	#name : #CTSketch,
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
CTSketch class >> k: k weightBlock: wBlock [

	^ self new
		  random: (RandomExponential seed: 11);
		  weightBlock: wBlock;
		  rankings: (1 to: k);
		  yourself
]

{ #category : #private }
CTSketch >> asSet [

	^ Set withAll: sketch
]

{ #category : #accessing }
CTSketch >> createSketch [

	sketch := (1 to: self k) collect: [ :each | 
		          Array with: Float infinity with: nil with: nil ]
]

{ #category : #private }
CTSketch >> epsilon: universeSize [

	^ (universeSize ln / self k) sqrt
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

{ #category : #accessing }
CTSketch >> random: anObject [

	random := anObject
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

	^ self weightEstimation ceiling
]

{ #category : #accessing }
CTSketch >> sketch [

	^ sketch copy
]

{ #category : #updating }
CTSketch >> update: u [

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
CTSketch >> weightBlock: aBlock [

	wBlock := aBlock
]

{ #category : #accessing }
CTSketch >> weightEstimation [

	| ranksSum |
	ranksSum := sketch inject: 0 into: [ :sum :each | sum + each first ].
	^ self k - 1 / ranksSum
]
