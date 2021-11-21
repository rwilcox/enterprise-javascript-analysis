"
Gives you an OK API to declare microservice dependencies, helped a bit by Backstage's design
"
Class {
	#name : #ServiceDefinition,
	#superclass : #Object,
	#instVars : [
		'serviceName',
		'dependsOn',
		'provides'
	],
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'as yet unclassified' }
ServiceDefinition class >> bigHerdExample [
	"comment stating purpose of class-side method"
	"scope: class-variables  &  class-instance-variables"	
			
	| output a b c d e f g  |
	
   output := OrderedCollection new.

   a := ServiceDefinition new.
   a serviceName: 'user-auth'; appendProvidesApi: 'user-api'.

  b := ServiceDefinition new.
  b serviceName: 'user-accounts'; appendProvidesApi: 'user-panda'.
  b appendConsumesApi: 'user-api' fromDependency: a.

  c := ServiceDefinition new.
  c serviceName: 'dashboard'; appendProvidesApi: 'dashboard-api'.
  c appendConsumesApi: 'user-panda' fromDependency: b.

  d := ServiceDefinition new.
  d serviceName: 'user-notifications'; appendProvidesApi: 'user-notifications'.
  c appendConsumesApi: 'user-notifications' fromDependency: d.

  e := ServiceDefinition new.
  e serviceName: 'documents'; appendProvidesApi: 'user-documents'; appendProvidesApi: 'documents-panda'.
  c appendConsumesApi: 'user-documents' fromDependency: e.

  f := ServiceDefinition new.
  f serviceName: 'dbgraphql'; appendProvidesApi: 'dbgraphql-api'.
  e appendConsumesApi: 'dbgraphql-api' fromDependency: f.

  c appendConsumesApi: 'dbgraphql-api' fromDependency: f.

  g := ServiceDefinition new.
  g serviceName: 'user-preferences'; appendProvidesApi: 'user-preferences-panda'.
  g appendConsumesApi: 'user-panda' fromDependency: b.
  g appendConsumesApi: 'dbgraphql-api' fromDependency: f.

  output add: a.
  output add: b.
  output add: c.
  output add: d.
  output add: e.
  output add: f.
  output add: g.

  ^ output.
]

{ #category : #accessing }
ServiceDefinition >> appendConsumesApi: apiName fromDependency: dep [
  dependsOn ifNil: [ dependsOn := Dictionary new].
  
  dependsOn at: apiName put: dep. 
]

{ #category : #accessing }
ServiceDefinition >> appendProvidesApi: apiName [
  provides ifNil: [ provides := OrderedCollection new].
  
  provides add: apiName.
]

{ #category : #accessing }
ServiceDefinition >> appendServiceObjectAsDependency: dep [
  dependsOn at: (dep serviceName) put: dep.
]

{ #category : #accessing }
ServiceDefinition >> bigOlHerd [

  |output a b c d e f g h i j k|
  output := OrderedCollection new.
  
  a := ServiceDefinition new.
  a serviceName: 'auth-panda'.
  a provides: 'auth-api'.
  
  b := ServiceDefinition new.
  b serviceName: 'dashboard summary'; provides: 'dashboard-api'.
  
  c := ServiceDefinition new.
  c serviceName: 'accounts-panda'; provides: 'accounts-panda-api'.
  
  b appendConsumesApi: 'accounts-panda-api' fromDependency: c.
  
  d := ServiceDefinition new.
  d serviceName: 'user-accounts' provides: 'user-accounts-api'.
  
  c appendConsumesApi: 'user-accounts-api' fromDependency: d.
  
  e := ServiceDefinition new.
  e serviceName: 'dbgraphql' provides: ''

]

{ #category : #accessing }
ServiceDefinition >> dependsOn [
    ^dependsOn ifNil: [ #() asDictionary] ifNotNil: [dependsOn]
]

{ #category : #accessing }
ServiceDefinition >> dependsOn: inDepends [
  dependsOn := inDepends.
]

{ #category : #accessing }
ServiceDefinition >> dependsOnAsCollectionOfNames [
  ^ self dependsOn keys.
]

{ #category : #accessing }
ServiceDefinition >> provides [
 ^provides.
]

{ #category : #accessing }
ServiceDefinition >> provides: newProvider [
  provides := newProvider.
]

{ #category : #accessing }
ServiceDefinition >> serviceName [
  ^serviceName.
]

{ #category : #accessing }
ServiceDefinition >> serviceName: inName [
  serviceName := inName.
]
