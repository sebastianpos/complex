#############################################
#
#  Representations, families and types
#
#############################################


DeclareRepresentation( "IsChainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

DeclareRepresentation( "IsCochainComplexRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainComplexes",
            NewFamily( "chain complexes" ) );


BindGlobal( "FamilyOfCochainComplexes",
            NewFamily( "cochain complexes" ) );

BindGlobal( "TheTypeOfChainComplexes",
            NewType( FamilyOfChainComplexes,
                     IsChainComplex and IsChainComplexRep ) );

BindGlobal( "TheTypeOfCochainComplexes",
            NewType( FamilyOfCochainComplexes,
                     IsCochainComplex and IsCochainComplexRep ) );

###########################################
#
# Constructors of (Co)chain complexes
#
###########################################

BindGlobal( "CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST",
function( cat, diffs, make_assertions, type )
  local C, assertion, f, msg;

  C := rec( );

  if type = "TheTypeOfChainComplexes" then

     ObjectifyWithAttributes( C, ValueGlobal( type ),
                           CatOfComplex, cat,
                           Differentials, diffs );

     if make_assertions then
#        To Do: Take care of this code!
#        for assertion in ComplexSingleAssertions do
#        f := assertion[ 1 ];
#        msg := assertion[ 2 ];
#        AddAssertion( diffs, MakeSingleAssertion( C, f, msg ) );
#        od;
#        for assertion in ComplexDoubleAssertions do
#        f := assertion[ 1 ];
#        msg := assertion[ 2 ];
#        AddAssertion( diffs, MakeDoubleAssertion( C, f, msg ) );
#        od;
     fi;

     Add( ChainComplexCategory( cat ), C );

  elif type = "TheTypeOfCochainComplexes" then

     ObjectifyWithAttributes( C, ValueGlobal( type ),
                              CatOfComplex, cat,
                              Differentials, diffs );

     if make_assertions then
#         This code need to be modified for the case of cochain complexes.
#         for assertion in ComplexSingleAssertions do
#         f := assertion[ 1 ];
#         msg := assertion[ 2 ];
#         AddAssertion( diffs, MakeSingleAssertion( C, f, msg ) );
#         od;
#         for assertion in ComplexDoubleAssertions do
#         f := assertion[ 1 ];
#         msg := assertion[ 2 ];
#         AddAssertion( diffs, MakeDoubleAssertion( C, f, msg ) );
#         od;
     fi;

     Add( CochainComplexCategory( cat ), C );

  fi;

  C!.ListOfComputedDifferentials := [ ];

  C!.ListOfComputedObjects := [ ];

  return C;

end );

InstallMethod( ChainComplex, [ IsCapCategory, IsZList, IsBool ],
  function( cat, diffs, make_assertions )

  return CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST( cat, diffs, make_assertions, "TheTypeOfChainComplexes" );

end );

InstallMethod( ChainComplex, [ IsCapCategory, IsZList ],
  function( cat, diffs )

  return ChainComplex( cat, diffs, false );

end );

InstallMethod( CochainComplex, [ IsCapCategory, IsZList, IsBool ],
  function( cat, diffs, make_assertions )

  return CHAIN_OR_COCHAIN_COMPLEX_BY_DIFFERENTIAL_LIST( cat, diffs, make_assertions, "TheTypeOfCochainComplexes" );

end );

InstallMethod( CochainComplex, [ IsCapCategory, IsZList ],
  function( cat, diffs )

  return CochainComplex( cat, diffs, false );

end );

################################################
#
#  Constructors of inductive (co)chain complexes
#
################################################

##
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES",
  function( d0, negative_part_function, positive_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs;

  cat := CapCategory( d0 ); 

  if string = "chain" then 

     complex_constructor := ChainComplex;

  elif string = "cochain" then

     complex_constructor := CochainComplex;

  else

     Error( "string must be either chain or cochain" );

  fi;

  negative_part := InductiveList( negative_part_function( d0 ), negative_part_function );

  positive_part := InductiveList( d0, positive_part_function );

  diffs := Concatenate( negative_part, positive_part );

  return complex_constructor( cat, diffs );

end );

##
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE",
  function( d0, negative_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs, d1, zero_part, complex, upper_bound;

  cat := CapCategory( d0 ); 

  zero_part := RepeatListN( [ UniversalMorphismFromZeroObject( ZeroObject( cat ) ) ] );

  if string = "chain" then 

     complex_constructor := ChainComplex;

     d1 := UniversalMorphismFromZeroObject( Source( d0 ) );

     upper_bound := 1;

  elif string = "cochain" then

     complex_constructor := CochainComplex;

     d1 := UniversalMorphismIntoZeroObject( Range( d0 ) );

     upper_bound := 2;

  else

     Error( "string must be either chain or cochain" );

  fi;

  negative_part := InductiveList( negative_part_function( d0 ), negative_part_function );

  positive_part := Concatenate( [ d0, d1 ], zero_part );

  diffs := Concatenate( negative_part, positive_part );

  complex :=  complex_constructor( cat, diffs );

  SetUpperBound( complex, upper_bound );

  return complex;
  
end );

##
BindGlobal( "CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE",
  function( d0, positive_part_function, string )
  local complex_constructor, negative_part, positive_part, cat, diffs, d_minus_1, zero_part, complex, lower_bound;

  cat := CapCategory( d0 ); 

  zero_part := RepeatListN( [ UniversalMorphismFromZeroObject( ZeroObject( cat ) ) ] );

  if string = "chain" then 

     complex_constructor := ChainComplex;

     d_minus_1 := UniversalMorphismIntoZeroObject( Range( d0 ) );

     lower_bound := -2;

  elif string = "cochain" then

     complex_constructor := CochainComplex;

     d_minus_1 := UniversalMorphismFromZeroObject( Source( d0 ) );

     lower_bound := -1;

  else

     Error( "string must be either chain or cochain" );

  fi;

  positive_part := InductiveList( d0, positive_part_function );

  negative_part := Concatenate( [ d_minus_1 ], zero_part );

  diffs := Concatenate( negative_part, positive_part );

  complex :=  complex_constructor( cat, diffs );

  SetLowerBound( complex, lower_bound );

  return complex;

end );

##
InstallMethod( ChainComplexWithInductiveSides,
               [ IsCapCategoryMorphism, IsFunction, IsFunction ],
   function( d0, negative_part_function, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES( d0, negative_part_function, positive_part_function, "chain" );
end );

##
InstallMethod( CochainComplexWithInductiveSides,
               [ IsCapCategoryMorphism, IsFunction, IsFunction ],
   function( d0, negative_part_function, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_SIDES( d0, negative_part_function, positive_part_function, "cochain" );
end );

##
InstallMethod( ChainComplexWithInductiveNegativeSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, negative_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE( d0, negative_part_function, "chain" );
   end );

##
InstallMethod( ChainComplexWithInductivePositiveSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE( d0, positive_part_function, "chain" );
end );

##
InstallMethod( CochainComplexWithInductiveNegativeSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, negative_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_NEGATIVE_SIDE( d0, negative_part_function, "cochain" );
   end );

##
InstallMethod( CochainComplexWithInductivePositiveSide,
               [ IsCapCategoryMorphism, IsFunction ],
   function( d0, positive_part_function )
   return CHAIN_OR_COCHAIN_WITH_INDUCTIVE_POSITIVE_SIDE( d0, positive_part_function, "cochain" );
end );

########################################
#
# Upper and lower bounds of (co)chains
#
########################################

##
InstallMethod( SetUpperBound, 
              [ IsChainOrCochainComplex, IsInt ], 
   function( C, upper_bound )

   if IsBound( C!.UpperBound ) and C!.UpperBound < upper_bound then

      Error( "The input is bigger than the one that already exists!" );

   fi;

   C!.UpperBound := upper_bound;

end );


##
InstallMethod( SetLowerBound, 
              [ IsChainOrCochainComplex, IsInt ], 
   function( C, lower_bound )

   if IsBound( C!.LowerBound ) and C!.LowerBound > lower_bound then

      Error( "The input is smaller than the one that already exists!" );

   fi;

   C!.LowerBound := lower_bound;

end );

##
InstallMethod( ActiveUpperBound,
               [ IsChainOrCochainComplex ],
  function( C )

  if not IsBound( C!.UpperBound ) then

     Error( "The complex does not have yet an upper bound" );

  else

     return C!.UpperBound;

  fi;

end );

##
InstallMethod( ActiveLowerBound,
               [ IsChainOrCochainComplex ],
  function( C )

  if not IsBound( C!.LowerBound ) then

     Error( "The complex does not have yet an lower bound" );
   
  else

     return C!.LowerBound;

  fi;

end );

##
InstallMethod( HasActiveUpperBound,
               [ IsChainOrCochainComplex ],
  function( C )

  return IsBound( C!.UpperBound );

end );

##
InstallMethod( HasActiveLowerBound,
               [ IsChainOrCochainComplex ],
  function( C )

  return IsBound( C!.LowerBound );

end );

#########################################
#
# Components of a (co)chain complexes
#
#########################################

##
InstallMethod( Display, 
               [ IsChainOrCochainComplex, IsInt, IsInt ],
   function( C, m, n )

   local i;

   for i in [ m .. n ] do

   Print( "\n-----------------------------------------------------------------\n" );

   Print( "In index ", String( i ) );

   Print( "\n\nObject is\n" );

   Display( C[ i ] );

   Print( "\nDifferential is\n" );

   Display( C^i );

   od;

end );

#########################################
#
# Attributes of a (co)chain complexes
#
#########################################

##
InstallMethod( Objects, 
               [ IsChainOrCochainComplex ],
  function( C )

    return MapLazy( Differentials( C ), Source );

end );

##
InstallMethod( \^, 
               [ IsChainOrCochainComplex, IsInt ],
  function( C, i )
  local l, L;

  l := C!.ListOfComputedDifferentials;

  L :=  List( l, i->i[ 1 ] ); 

  if i in L then 

     return l[ Position( L, i ) ][ 2 ];

  fi;

  l := Differentials( C )[ i ];

  Add( C!.ListOfComputedDifferentials, [ i, l ] );

  return l;

end );

InstallMethod( CertainDifferential, [ IsChainOrCochainComplex, IsInt], \^ );

##
InstallMethod( \[\], 
               [ IsChainOrCochainComplex, IsInt ],
function( C, i )
  local l, L;

  l := C!.ListOfComputedObjects;

  L :=  List( l, i->i[ 1 ] ); 

  if i in L then 

     return l[ Position( L, i ) ][ 2 ];

  fi;

  l := Objects( C )[ i ];

  Add( C!.ListOfComputedObjects, [ i, l ] );

  return l;

end );

##
DeclareOperation( "CertainObject", [ IsChainOrCochainComplex, IsInt ] );


################################################
#
#  Constructors of finite (co)chain complexes
#
################################################

##
BindGlobal( "FINITE_CHAIN_OR_COCHAIN_COMPLEX",
   function( cat, list, index, string )
  local zero, zero_map, zero_part, n, diffs, new_list, complex, upper_bound, lower_bound;

  zero := ZeroObject( cat );

  zero_map := ZeroMorphism( zero, zero );

  zero_part := RepeatListN( [ zero_map ] );

  n := Length( list );

  if not ForAll( list, mor -> cat = CapCategory( mor ) ) then

     Error( "All morphisms in the list should live in the same category" );

  fi;

  if string = "chain" then

        new_list := Concatenation( [ ZeroMorphism( Range( list[ 1 ] ), zero ) ], list, [ ZeroMorphism( zero, Source( list[ n ] ) ) ] );

        diffs := Concatenate( zero_part, index - 1, new_list, zero_part );

        complex := ChainComplex( cat, diffs );

        SetFilterObj( complex, IsFiniteChainComplex );

        lower_bound := index - 2;

        upper_bound := index + Length( list );

  else

        new_list := Concatenation( [ ZeroMorphism( zero, Source( list[ 1 ] ) ) ], list, [ ZeroMorphism( Range( list[ n ] ), zero ) ] );

        diffs := Concatenate( zero_part, index - 1, new_list, zero_part );

        complex := CochainComplex( cat, diffs );

        SetFilterObj( complex, IsFiniteCochainComplex );

        lower_bound := index - 1;

        upper_bound := index + Length( list ) + 1;

  fi;

  SetLowerBound( complex, lower_bound );

  SetUpperBound( complex, upper_bound );

  return complex;

end );


#n
InstallMethod( FiniteChainComplex,
                   [ IsDenseList, IsInt ],
  function( diffs, n )
  local cat;

  cat := CapCategory( diffs[ 1 ] );

  return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "chain" );

end );

InstallMethod( FiniteCochainComplex,
                   [ IsDenseList, IsInt ],

  function( diffs, n )
  local cat;

  cat := CapCategory( diffs[ 1 ] );

  return FINITE_CHAIN_OR_COCHAIN_COMPLEX( cat, diffs, n, "cochain" );

end );

##
InstallMethod( FiniteChainComplex,
                   [ IsDenseList ],
  function( diffs )

  return FiniteChainComplex( diffs, 0 );

end );

##
InstallMethod( FiniteCochainComplex,
                   [ IsDenseList ],
   function( diffs )

   return FiniteCochainComplex( diffs, 0 );

end );

##
InstallMethod( StalkChainComplex,
                   [ IsCapCategoryObject ],
  function( obj )
  local zero, diffs, complex;

  zero := ZeroObject( CapCategory( obj ) );

  diffs := [ ZeroMorphism( obj, zero ) ];

  complex := FiniteChainComplex( diffs );

  SetLowerBound( complex, -1 );

  return complex;

end );

##
InstallMethod( StalkCochainComplex,
                   [ IsCapCategoryObject ],
  function( obj )
  local zero, diffs, complex;

  zero := ZeroObject( CapCategory( obj ) );

  diffs := [ ZeroMorphism( obj, zero ) ];

  complex := FiniteCochainComplex( diffs );

  SetUpperBound( complex, 1 );

  return complex;

end );

#############################################
##
## Homology and Cohomology computations
##
#############################################

##
InstallMethod( CertainCycle, [ IsChainOrCochainComplex, IsInt ],
  function( C, i )

  return KernelEmbedding( C^i );

end );

##
InstallMethod( CertainBoundary, [ IsChainOrCochainComplex, IsInt ],
  function( C, i )

  if IsChainComplex( C ) then

     return ImageEmbedding( C^( i + 1 )  );

  else

     return ImageEmbedding( C^( i - 1 )  );

  fi;

end );

##
BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX",
  function( C, i )
  local im, inc;

  im := CertainBoundary( C, i );

  inc := KernelLift( C^i, im );

  return CokernelObject( inc );

end );

##
# BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX_FUNCTORIAL",
#  function( map, i )
#  local C1, C2, im1, d1, inc1, im2, d2, inc2, cycle1, map_i, ker1_to_ker2;

#  C1 := Source( map );

#  C2 := Range( map );

#  im1 := CertainBoundary( C1, i );

#  d1 := DifferentialOfComplex( C1, i );

#  inc1 := KernelLift( d1, im1 );

#  im2 := CertainBoundary( C2, i );

#  d2 := DifferentialOfComplex( C2, i );

#  inc2 := KernelLift( d2, im2 );

#  cycle1 := CertainCycle( C1, i );

#  map_i := MorphismOfMap( map, i );

#  ker1_to_ker2 := KernelLift( d2, PreCompose( cycle1, map_i ) );

#  return CokernelColift( inc1, PreCompose( ker1_to_ker2, CokernelProjection( inc2 ) ) );

# end );

##
InstallMethod( CertainHomology, [ IsChainComplex, IsInt ], HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX );

##
InstallMethod( CertainCohomology, [ IsCochainComplex, IsInt ], HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX );

##
InstallMethod( DefectOfExactness, 
               [ IsChainOrCochainComplex, IsInt ],
  function( C, n )

  if IsChainComplex( C ) then 

     return CertainHomology( C, n );

  else

     return CertainCohomology( C, n );

  fi;

end );

##
InstallMethod( IsExactInIndex, 
               [ IsChainOrCochainComplex, IsInt ],
  function( C, n )

  return IsZeroForObjects( DefectOfExactness( C, n ) );

end );

######################################
#
# Shift using lazy methods
#
######################################

##
InstallMethod( ShiftLazy, [ IsChainOrCochainComplex, IsInt ],
  function( C, i )
  local newDifferentials, complex;

  newDifferentials := ShiftLazy( Differentials( C ), i );

  if i mod 2 = 1 then

    newDifferentials := MapLazy( newDifferentials, d -> -d );

  fi;

  if IsChainComplex( C ) then

     complex := ChainComplex( UnderlyingCategory( CapCategory( C ) ), newDifferentials );

  else

     complex := CochainComplex( UnderlyingCategory( CapCategory( C ) ), newDifferentials );

  fi;

  if HasActiveUpperBound( C ) then

     SetUpperBound( complex, ActiveUpperBound( C ) - i );

  fi;

  if HasActiveLowerBound( C ) then

     SetLowerBound( complex, ActiveLowerBound( C ) - i );

  fi;

  complex!.ListOfComputedDifferentials := List( C!.ListOfComputedDifferentials, l -> [ l[ 1 ] - i, (-1)^i*l[ 2 ] ] );

  complex!.ListOfComputedObjects := List( C!.ListOfComputedObjects, l -> [ l[ 1 ] - i, l[ 2 ] ] );

  return complex;

end );

##
InstallMethod( ShiftUnsignedLazy, [ IsChainOrCochainComplex, IsInt ],
  function( C, i )
  local newDifferentials, complex;

  newDifferentials := ShiftLazy( Differentials( C ), i );

  if IsChainComplex( C ) then 

     complex := ChainComplex( UnderlyingCategory( CapCategory( C ) ), newDifferentials );

  else

     complex := CochainComplex( UnderlyingCategory( CapCategory( C ) ), newDifferentials );

  fi;

  if HasActiveUpperBound( C ) then 

     SetUpperBound( complex, ActiveUpperBound( C ) - i );

  fi;

  if HasActiveLowerBound( C ) then 

     SetLowerBound( complex, ActiveLowerBound( C ) - i );

  fi;

  complex!.ListOfComputedDifferentials := List( C!.ListOfComputedDifferentials, l -> [ l[ 1 ] - i, l[ 2 ] ] );

  complex!.ListOfComputedObjects := List( C!.ListOfComputedObjects, l -> [ l[ 1 ] - i, l[ 2 ] ] );

  return complex;

end );
