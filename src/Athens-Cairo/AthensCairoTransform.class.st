"
i implement AthensTransform protocol using cairo-specific functions.
"
Class {
	#name : #AthensCairoTransform,
	#superclass : #AthensTransform,
	#traits : 'TCairoLibrary',
	#classTraits : 'TCairoLibrary classTrait',
	#instVars : [
		'canvas'
	],
	#category : #'Athens-Cairo-Transforms'
}

{ #category : #'instance creation' }
AthensCairoTransform class >> for: cairoCanvas [
	^ self new canvas: cairoCanvas
]

{ #category : #initializing }
AthensCairoTransform >> canvas: aCairoCanvas [
	canvas := aCairoCanvas
]

{ #category : #primitives }
AthensCairoTransform >> loadIdentity [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_identity_matrix (AthensCairoCanvas canvas) )


]

{ #category : #transformations }
AthensCairoTransform >> moveTo: aPoint [
	self moveToX: aPoint x asFloat Y: aPoint y asFloat
]

{ #category : #primitives }
AthensCairoTransform >> moveToX: px Y: py [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_move_to (AthensCairoCanvas canvas,
                                                         double px,
                                                         double py))


]

{ #category : #primitives }
AthensCairoTransform >> primTransformX: x Y: y [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_user_to_device (AthensCairoCanvas canvas,
                                                         NBFloatPtr x,
                                                         NBFloatPtr y) )

]

{ #category : #primitives }
AthensCairoTransform >> restore [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^ self nbCall: #(void cairo_restore(AthensCairoCanvas canvas))

]

{ #category : #transformations }
AthensCairoTransform >> restoreAfter: aBlock [
	self save.
	aBlock ensure:  [ self restore ].
]

{ #category : #transformations }
AthensCairoTransform >> rotateByDegrees: angle [

	^ self rotateByRadians: angle degreesToRadians
]

{ #category : #primitives }
AthensCairoTransform >> rotateByRadians: angle [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_rotate (AthensCairoCanvas canvas,
                                                         double angle))


]

{ #category : #primitives }
AthensCairoTransform >> save [
	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^ self nbCall: #(void cairo_save (AthensCairoCanvas canvas))

]

{ #category : #transformations }
AthensCairoTransform >> scaleBy: aScalarOrPoint [
	| double |
	aScalarOrPoint isPoint
		ifTrue:[
			self
				scaleX: aScalarOrPoint x asFloat
				Y: aScalarOrPoint y asFloat ]
		ifFalse:[ 
			double := aScalarOrPoint asFloat.
			self scaleX: double Y: double ].

]

{ #category : #primitives }
AthensCairoTransform >> scaleX: fx Y: fy [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_scale (AthensCairoCanvas canvas,
                                                         double fx,
                                                         double fy))


]

{ #category : #'vector-transform' }
AthensCairoTransform >> transform: aPoint [
	| x y |
	x := ByteArray new: 8.
	y := ByteArray new: 8.
	x doubleAt: 1 put: aPoint x.
	y doubleAt: 1 put: aPoint y.
	self primTransformX: x Y: y.
	^ (x doubleAt: 1) @ (y doubleAt: 1)
]

{ #category : #transformations }
AthensCairoTransform >> translateBy: aPoint [
	self translateX: aPoint x Y: aPoint y

]

{ #category : #primitives }
AthensCairoTransform >> translateX: px Y: py [

	<primitive: #primitiveNativeCall module: #NativeBoostPlugin>
	
	^self nbCall: #(
		void cairo_translate (AthensCairoCanvas canvas,
                                                         double px,
                                                         double py))


]
