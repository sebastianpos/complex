DeclareCategory( "IsChainOrCochainComplex", IsCapCategoryObject );
DeclareCategory( "IsChainComplex", IsChainOrCochainComplex );
DeclareCategory( "IsCochainComplex", IsChainOrCochainComplex );
DeclareCategory( "IsChainOrCochainComplexCategory", IsCapCategory );
DeclareCategory( "IsChainComplexCategory", IsChainOrCochainComplexCategory );
DeclareCategory( "IsCochainComplexCategory", IsChainOrCochainComplexCategory );

DeclareGlobalVariable( "ComplexSingleAssertions" );
DeclareGlobalVariable( "ComplexDoubleAssertions" );

###################################################
#
#  Constructors of (Co)chain complexes categories
#
###################################################

DeclareAttribute( "ChainComplexCategory", IsCapCategory );
DeclareAttribute( "CochainComplexCategory", IsCapCategory );

DeclareAttribute( "UnderlyingCategory", IsChainOrCochainComplexCategory );

#########################################
#
#  Constructors of (Co)chain complexes 
#
#########################################

#n
DeclareOperation( "ChainComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ChainComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );

DeclareOperation( "CochainComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "CochainComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
##

#c
# The following two operations are exactly the same as ChainComplexByDifferentialList.
# I 
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList, IsBool ] );
DeclareOperation( "ComplexByDifferentialList", [ IsAbelianCategory, IsZList ] );
##


DeclareOperation( "FiniteComplex", [ IsAbelianCategory, IsDenseList ] );
DeclareOperation( "StalkComplex", [ IsAbelianCategory, IsObject ] );
DeclareOperation( "ZeroComplex", [ IsAbelianCategory ] );
DeclareOperation( "ShortExactSequence", [ IsAbelianCategory, IsObject, IsObject ] );
DeclareOperation( "InductiveComplex", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Resolution", [ IsAbelianCategory, IsObject, IsFunction ] );
DeclareOperation( "Coresolution", [ IsAbelianCategory, IsObject, IsFunction ] );

DeclareOperation( "Shift", [ IsChainComplex, IsInt ] );
DeclareOperation( "ShiftUnsigned", [ IsChainComplex, IsInt ] );
DeclareOperation( "YonedaProduct", [ IsChainComplex, IsChainComplex ] );

DeclareOperation( "GoodTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "GoodTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "BrutalTruncationBelow", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncationAbove", [ IsChainComplex, IsInt ] );
DeclareOperation( "BrutalTruncation", [ IsChainComplex, IsInt, IsInt ] );
DeclareOperation( "SyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "CosyzygyTruncation", [ IsChainComplex, IsInt ] );
DeclareOperation( "SyzygyCosyzygyTruncation", [ IsChainComplex, IsInt, IsInt ] );
#DeclareOperation( "CutComplexAbove", [ IsChainComplex ] );
#DeclareOperation( "CutComplexBelow", [ IsChainComplex ] );

DeclareAttribute( "CatOfComplex", IsChainComplex );
DeclareOperation( "ObjectOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "DifferentialOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "\^", [ IsChainComplex, IsInt ] );
DeclareOperation( "\[\]", [ IsChainComplex, IsInt ] );
DeclareAttribute( "DifferentialsOfComplex", IsChainComplex );
DeclareAttribute( "ObjectsOfComplex", IsChainComplex );
DeclareOperation( "CyclesOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "BoundariesOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "HomologyOfComplex", [ IsChainComplex, IsInt ] );
DeclareOperation( "UpperBound", [ IsChainComplex ] );
DeclareOperation( "LowerBound", [ IsChainComplex ] );
#DeclareOperation( "IsFiniteComplex", [ IsChainComplex ] );
DeclareOperation( "IsBoundedComplex", [ IsChainComplex ] );
DeclareOperation( "LengthOfComplex", [ IsChainComplex ] );
DeclareOperation( "HighestKnownDegree", [ IsChainComplex ] );
DeclareOperation( "LowestKnownDegree", [ IsChainComplex ] );
DeclareProperty( "IsExactSequence", IsChainComplex );
DeclareOperation( "IsExactInDegree", [ IsChainComplex, IsInt ] );
DeclareProperty( "IsShortExactSequence", IsChainComplex );
DeclareOperation( "ForEveryDegree", [ IsChainComplex, IsFunction ] );
