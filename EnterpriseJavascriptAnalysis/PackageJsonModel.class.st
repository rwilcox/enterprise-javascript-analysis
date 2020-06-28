"
I store information about a parsed package.json file.

I keep track of meta-information, as well as dependencies (devDependendencies or otherwise) in PackageModel objects.

Best way to create me is to use one of the factory functions in the class section.

Hint: you may use me to diagram or model out libraries your organization creates (vs those the org brings in from the open source community).
"
Class {
	#name : #PackageJsonModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'version',
		'dependencies',
		'devDependencies'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'as yet unclassified' }
PackageJsonModel class >> loadFromJsonFileReferences: arrayOfStreams [
	"Given an array of streams, returns an array of PackageJsonModels"
			
	^ arrayOfStreams collect: [ :current |
			PackageJsonModel loadFromJsonReadStream: (current readStream).
	].
]

{ #category : #'as yet unclassified' }
PackageJsonModel class >> loadFromJsonReadStream: stream [ 
	"Create a PackageJSONModel from a stream of package.json"
	
			
	| basicOutput output deps|
	basicOutput := STONJSON fromStream: stream.
	
	output := PackageJsonModel  new.
	output name: (basicOutput at: 'name');
	version: (basicOutput at: 'version').
	
	deps := OrderedCollection new.
	(basicOutput at: 'dependencies') associationsDo: [ :current || outputPackage |
		outputPackage := PackageModel new.
		outputPackage name: (current key); version: (current value).
		deps add:  outputPackage.
	].

	output dependencies: deps.
	deps := OrderedCollection new.
	((basicOutput at: 'devDependencies') associationsDo: [ :current || outputPackage |
		outputPackage := PackageModel new.
		outputPackage name: (current key); version: (current value).
		deps add: outputPackage.
	]).
	
	output devDependencies: deps.

	^ output.
]

{ #category : #converting }
PackageJsonModel >> asPackageModel [
	| output |
	
	output := PackageModel new.
	output name: (self name);
	version: (self version).
	
	^ output
]

{ #category : #accessing }
PackageJsonModel >> dependencies [
	^ dependencies
]

{ #category : #accessing }
PackageJsonModel >> dependencies: anObject [
	dependencies := anObject
]

{ #category : #accessing }
PackageJsonModel >> devDependencies [
	^ devDependencies
]

{ #category : #accessing }
PackageJsonModel >> devDependencies: anObject [
	devDependencies := anObject
]

{ #category : #accessing }
PackageJsonModel >> name [
	^ name
]

{ #category : #accessing }
PackageJsonModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PackageJsonModel >> version [
	^ version
]

{ #category : #accessing }
PackageJsonModel >> version: anObject [
	version := anObject
]
