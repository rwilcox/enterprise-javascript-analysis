"
I model a simple package.json dependency.
"
Class {
	#name : #PackageModel,
	#superclass : #Object,
	#instVars : [
		'name',
		'version'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #accessing }
PackageModel >> = what [
"compares two PackageModels

TODO: compare version numbers too"
	^ (what name) = (self name).
]

{ #category : #accessing }
PackageModel >> name [
	^ name
]

{ #category : #accessing }
PackageModel >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PackageModel >> version [
	^ version
]

{ #category : #accessing }
PackageModel >> version: anObject [
	version := anObject
]
