"
A very very basic ""I have some things that depend on each other that I need to graph"".

Smalltalk (can) make this look reasonably DSL-ish, see this example:

| t |

t := GraphModal withName: 'Travel' andChildren: { 
    GraphModal withName: 'pack suitcase' andChildren: { 
      GraphModal withName: 'find suitcase' }.
    GraphModal withName: 'find wallet' andChildren: { 
      GraphModal withName: 'buy tickets with credit card in wallet'
    }
 }

It also gives the ability to graph this...
"
Class {
	#name : #GraphModal,
	#superclass : #Object,
	#instVars : [
		'name',
		'externalRef',
		'children',
		'cachedCompositeShape'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'instance creation' }
GraphModal class >> withName: inName [
	^ (self) withName: inName andChildren: nil.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName andChildren: inChildren [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	out := self new.
	out name: inName.
	out children: inChildren  .
	^ out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName childContext: resultsFromThisBlockWillBeAddedAsChildren [
	"comment stating purpose of message"

  |out|

  out := (self ) withName: inName.
  out children: (resultsFromThisBlockWillBeAddedAsChildren value).

  ^out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName childen: children andExternalRef: exRef [
	"comment stating purpose of class-side message"
	"scope: class-variables  &  class-instance-variables"	
			
	| out |
	
   out := self new.
   out name: name
   out children: children.
   out externalRef: exRef.

   ^ out.
]

{ #category : #'as yet unclassified' }
GraphModal class >> withName: inName make: blockWillBeCalledWithConstructedObject [
	"comment stating purpose of message"

	| out |
	out := self withName: inName.
	
	blockWillBeCalledWithConstructedObject value: out.
	^ out.

]

{ #category : #Roassal }
GraphModal >> asRSCompositeShape [
	| output box rslabel |
	rslabel := RSLabel new text: name yourself.
	box := RSBox new
		withBorder;
		extent: rslabel extent + 10;
		color: Color white.
	output := RSComposite new
		draggable;
		model: self;
		shapes:
			{box.
			rslabel}.
	^ output
]

{ #category : #Roassal }
GraphModal >> asRTCompositeShape [
	| rslabel output outModal box |
	
	^ cachedCompositeShape 
	    ifNotNil: [ cachedCompositeShape  ]
	    ifNil: [ 	
			rslabel := RTLabel new text: name yourself.
	      box := RTBox new.	"extent: rslabel extent + 10;"	"color: (Color white)"
	      output := RTCompositeShape new.
	      "output add: box."
	      output add: rslabel.
	      output setAutomaticRelayout.
	      outModal := output elementOn: self.
	      outModal @ RTDraggable.
	
	     cachedCompositeShape := outModal.
	     cachedCompositeShape.
	    ].

]

{ #category : #accessing }
GraphModal >> children [
	^ children
]

{ #category : #accessing }
GraphModal >> children: anObject [
	children := anObject
]

{ #category : #accessing }
GraphModal >> externalRef [
	^ externalRef
]

{ #category : #accessing }
GraphModal >> externalRef: anObject [
	externalRef := anObject
]

{ #category : #printing }
GraphModal >> gtDisplayOn: stream [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	^ self name printOn: stream.
]

{ #category : #'as yet unclassified' }
GraphModal >> gtInspectorSubtopicsIn: composite [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	<gtInspectorPresentationOrder: 1000>
	
	composite roassal3 
	  title: 'Graph';
	  initializeCanvas: [ |canvas|
	    canvas := RSCanvas new.
	    canvas @ RSCanvasController.
	    self toRSCompositeOnCanvas: canvas.
	    self layoutOnCanvas: canvas.
	
	    canvas.
	  ].
]

{ #category : #Roassal }
GraphModal >> layoutOnCanvas: canvas [
	"Subclasses could redefine this if you prefer another layout.
	 This current impl tries to be smart for what version of Roassal you have.
	"
	|cls|
	cls := Smalltalk at: ('RSDominanceTreeLayout' asSymbol) ifAbsent: [ 
		Smalltalk at: ('RTDominanceTreeLayout' asSymbol) ] .		
				
	cls new on: (canvas nodes).
]

{ #category : #accessing }
GraphModal >> name [
	^ name
]

{ #category : #accessing }
GraphModal >> name: anObject [
	name := anObject
]

{ #category : #Roassal }
GraphModal >> toRSCompositeOnCanvas: canvas [
	| output childrenNodes |
	
	output := self asRSCompositeShape.
	canvas add: output.
	
	self children
		ifNotNil: [ childrenNodes := self children
				collect: [ :curr | 
					| childShape line |
					childShape := curr toRSCompositeOnCanvas: canvas.
					line := RSLine new
						from: childShape;
						to: output.
					canvas add: line ] ].
	^ output
]

{ #category : #Roassal }
GraphModal >> toRTCompositeOnCanvas: canvas [
	"version of toRSCompositeOnCanvas but for Roassal2 (not 3)"

	| outModal childrenNodes |
	"extent: rslabel extent + 10;"
	"color: (Color white)"
	"output add: box."
	outModal := self asRTCompositeShape.
	canvas add: outModal.
	self children
		ifNotNil: [ childrenNodes := self children
				collect: [ :curr | 
					| childShape line |
					childShape := curr toRTCompositeOnCanvas: canvas.
					line := RTEdge from: outModal to: childShape.
					line + (RTLine new color: Color black) + RTSimpleArrowHead new.
					canvas add: line ] ].
	^ outModal
]
