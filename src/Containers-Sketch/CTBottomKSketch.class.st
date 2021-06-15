Class {
	#name : #CTBottomKSketch,
	#superclass : #CTSketch,
	#instVars : [
		'random',
		'wBlock'
	],
	#category : #'Containers-Sketch'
}

{ #category : #'instance creation' }
CTBottomKSketch class >> k: k weightBlock: wBlock [

	^ self new
		  random: (RandomExponential seed: 11);
		  weightBlock: wBlock;
		  rankings: (Array new: k);
		  yourself
]

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

{ #category : #'instance creation' }
CTBottomKSketch class >> onCollection: aCollection kMin: k weightBlock: wBlock [

	| rank random rankings |
	rankings := Array new: k.
	rank := rankings at: 1 put: Dictionary new.
	random := RandomExponential seed: 11.

	aCollection do: [ :each | 
		| w r |
		w := wBlock value: each.
		r := random
			     lambda: w;
			     next.
		rank at: each put: r ].

	^ self new
		  random: random;
		  weightBlock: wBlock;
		  rankings: rankings;
		  yourself
]

{ #category : #accessing }
CTBottomKSketch >> createSketch [

	sketch := (SortedCollection new: self k)
		          sortBlock: [ :a :b | a first < b first ];
		          yourself
]

{ #category : #updating }
CTBottomKSketch >> random [

	| sum k |
	k := self k min: sketch size.

	sum := 0.
	1 to: k do: [ :i | sum := sum + (sketch at: i) second ].

	^ random
		  lambda: sum;
		  yourself
]

{ #category : #accessing }
CTBottomKSketch >> random: anObject [

	random := anObject
]

{ #category : #accessing }
CTBottomKSketch >> rank [

	^ sketch asArray copyFrom: 1 to: self k
]

{ #category : #updating }
CTBottomKSketch >> size [

	| r |
	r := sketch last first.

	^ (sketch collect: [ :each | 
		   | w |
		   w := each second.
		   w / (1 - (w * r) negated exp) ]) sum ceiling
]

{ #category : #updating }
CTBottomKSketch >> update: u [

	| rank k w |
	k := self k.
	w := wBlock value: u.
	rank := random
		        lambda: w;
		        next.

	(sketch size < k or: [ rank < sketch lastButOne first ]) ifTrue: [ 
		| tuple |
		tuple := Array with: rank with: w with: u.
		sketch add: tuple.
		k + 1 < sketch size ifTrue: [ sketch removeLast ] ]
]

{ #category : #'as yet unclassified' }
CTBottomKSketch >> weightBlock: aBlock [

	wBlock := aBlock
]
