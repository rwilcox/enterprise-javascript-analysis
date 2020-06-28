"
I diagram the dependency relationships between modules package.json files.

The idea here is that your enterprise has a bunch of internal libraries you have implemented, but they may have - or have developed - explicit dependencies on each other, either accidentally or on purpose.

So, in the wake of these dependencies, if you update some module, you may want to update the most depended on module first, then go up the graph.

So.... what does that graph look like? (Now you know)
"
Class {
	#name : #PackageJsonDependencyGraph,
	#superclass : #Object,
	#category : #EnterpriseJavascriptAnalysis
}

{ #category : #'as yet unclassified' }
PackageJsonDependencyGraph >> drawCanvasWith: arrayOfPackageJsonModels [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	|canvas modelsAsDictionary|
	
	modelsAsDictionary := Dictionary new.
	
	arrayOfPackageJsonModels do: [ :current |
		modelsAsDictionary at: (current name) put: current. 
	].

	canvas := RSCanvas new.
	canvas addAll: (arrayOfPackageJsonModels  collect: [ :jsonModel || label box c|
		label:= RSLabel new text: (jsonModel name) yourself.
		box := 	RSBox new
		withBorder;
		extent: label extent + 10.
		
		c := RSComposite new draggable;
		model: jsonModel; shapes: { box. label }.
	
		c.
	 ]).

	" connect the dots. We ONLY care about connecting the dots to other PackageJsonModels, not every NPM package in the package.json file"
	arrayOfPackageJsonModels do: [ :currentJsonModel || dependenciesThatHavePackageModels |
		dependenciesThatHavePackageModels := currentJsonModel dependencies select: [ :currentDep |
			modelsAsDictionary includesKey: (currentDep name).
		]
		thenCollect: [ :currentDep|
			modelsAsDictionary at: (currentDep name).
		].
		
		RSEdgeBuilder arrowedLine color: Color black;
		shapes: canvas nodes;
		canvas: canvas;
		connectFrom:  [:_ | currentJsonModel ]
	 	toAll:        [:_ | dependenciesThatHavePackageModels]. 
			  
	].

	RSVerticalLineLayout new on: canvas nodes.
	canvas @ RSCanvasController.
	^ canvas.
]
