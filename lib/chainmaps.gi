########################################
#
# Representations, families and types
#
########################################


DeclareRepresentation( "IsChainMorphismRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfChainMorphisms",
            NewFamily( "chain morphisms" ) );

BindGlobal( "TheTypeOfChainMorphism",
            NewType( FamilyOfChainMorphisms, 
                     IsChainMorphism and IsChainMorphismRep ) );

DeclareRepresentation( "IsCochainMorphismRep",
                       IsComponentObjectRep and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "FamilyOfCochainMorphisms",
            NewFamily( "cochain morphisms" ) );

BindGlobal( "TheTypeOfCochainMorphism",
            NewType( FamilyOfCochainMorphisms, 
                     IsCochainMorphism and IsCochainMorphismRep ) );

#########################################
#
# (Co)chain morphisms constructors 
#
#########################################

BindGlobal( "CHAIN_OR_COCHAIN_MORPHISM_BY_LIST",
     function( C1, C2, morphisms )
     local map;

     map := rec( );

     if ForAll( [ C1, C2 ], IsChainComplex ) then 

           ObjectifyWithAttributes( map, TheTypeOfChainMorphism,

                           Source, C1,

                           Range, C2,

                           Morphisms, morphisms );
        
           if ForAll( [ C1, C2 ], IsFiniteChainComplex ) then 
          
              SetFilterObj( map, IsFiniteChainMorphism );

           fi;

     elif ForAll( [ C1, C2 ], IsCochainComplex ) then 

        ObjectifyWithAttributes( map, TheTypeOfCochainMorphism,

                           Source, C1,

                           Range, C2,

                           Morphisms, morphisms );

        if ForAll( [ C1, C2 ], IsFiniteCochainComplex ) then 
          
           SetFilterObj( map, IsFiniteCochainMorphism );

        fi;

     else

        Error( "first and second argument should be both chains or cochains" );

     fi;

     Add( CapCategory( C1 ), map );

     map!.ListOfComputedMorphisms := [ ];
     
     return map;

end );

BindGlobal( "CHAIN_OR_COCHAIN_MORPHISM_BY_DENSE_LIST",
  function( C1, C2, mor, n )
  local all_morphisms;
  
  all_morphisms := MapLazy( IntegersList, function( i )
                                           
                                              if i >= n and i <= n + Length( mor ) - 1 then 
           
                                                 return mor[ i - n + 1 ];
            
                                              else
  
                                                 return ZeroMorphism( C1[ i ], C2[ i ] );
                          
                                              fi;

                                           end, 1 );

  all_morphisms := CHAIN_OR_COCHAIN_MORPHISM_BY_LIST( C1, C2, all_morphisms );

  SetLowerBound( all_morphisms, n - 1 );

  SetUpperBound( all_morphisms, n + Length( mor ) );

  return all_morphisms;

end );

BindGlobal( "FINITE_CHAIN_OR_COCHAIN_MORPHISM_BY_THREE_LISTS",
   function( l1,m1, l2,m2, mor, n, string )
   local C1, C2, base_list, maps, zero, all_maps, cat, complex_category, complex_constructor, map_constructor, map;

   cat := CapCategory( l1[ 1 ] );

   if string = "chain_map" then 

      complex_category := ChainComplexCategory( cat );

      complex_constructor := FiniteChainComplex;

      map_constructor := ChainMorphism;

   else 

      complex_category := CochainComplexCategory( cat );

      complex_constructor := FiniteCochainComplex;

      map_constructor := CochainMorphism;

   fi;

   C1 := complex_constructor( l1, m1 );

   C2 := complex_constructor( l2, m2 );

   base_list := [ Minimum( ActiveLowerBound( C1 ), ActiveLowerBound( C2 ) ) + 1 .. Maximum( ActiveUpperBound( C1 ), ActiveUpperBound( C2 ) ) - 1 ];

   maps := List( base_list,      function( i )

                                 if i >= n and i <= n + Length( mor ) - 1 then 

                                        return mor[ i - n + 1 ];

                                 else 

                                        return ZeroMorphism( C1[ i ], C2[ i ] );

                                 fi;

                                 end );

   zero := ZeroMorphism( ZeroObject( cat ), ZeroObject( cat ) );

   zero := RepeatListN( [ zero ] );

   all_maps := Concatenate( zero, base_list[ 1 ], maps, zero );

   map := map_constructor( C1, C2, all_maps );

   if n > base_list[ Length( base_list ) ] then SetIsZero( map, true );fi;
   
   if n + Length( mor ) -1 < base_list[ 1 ] then SetIsZero( map, true ); fi;
   
   return map;

end );


##
InstallMethod( ChainMorphism,
               [ IsChainComplex, IsChainComplex, IsZList ],
CHAIN_OR_COCHAIN_MORPHISM_BY_LIST );

##
InstallMethod( CochainMorphism,
               [ IsCochainComplex, IsCochainComplex, IsZList ],
CHAIN_OR_COCHAIN_MORPHISM_BY_LIST );

##
InstallMethod( ChainMorphism,
               [ IsChainComplex, IsChainComplex, IsDenseList, IsInt ],
CHAIN_OR_COCHAIN_MORPHISM_BY_DENSE_LIST );

##
InstallMethod( CochainMorphism,
               [ IsCochainComplex, IsCochainComplex, IsDenseList, IsInt ],
CHAIN_OR_COCHAIN_MORPHISM_BY_DENSE_LIST );

##
InstallMethod( FiniteChainMorphism,
               [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ],
   function( c1, m1, c2, m2, maps, n )
   return FINITE_CHAIN_OR_COCHAIN_MORPHISM_BY_THREE_LISTS( c1, m1, c2, m2, maps, n, "chain_map" );
end );

##
InstallMethod( FiniteCochainMorphism,
               [ IsDenseList, IsInt, IsDenseList, IsInt, IsDenseList, IsInt ],
   function( c1, m1, c2, m2, maps, n )
   return FINITE_CHAIN_OR_COCHAIN_MORPHISM_BY_THREE_LISTS( c1, m1, c2, m2, maps, n, "cochain_map" );
end );

#################################
#
# Operations
#
#################################

InstallMethod( \[\], 
          [ IsChainOrCochainMorphism, IsInt ], 

  function( map, i )
     local l, L;

     l := map!.ListOfComputedMorphisms;

     L := List( l, i->i[ 1 ] );

     if i in L then 

        return l[ Position( L, i ) ][ 2 ];

     fi;

     l := Morphisms( map )[ i ];

     Add( map!.ListOfComputedMorphisms, [ i, l ] );

     return l;

end );

#################################
#
# Display and View
#
#################################

InstallMethod( Display, 
               [ IsChainOrCochainMorphism, IsInt, IsInt ], 
   function( map, m, n )
   local i;

   for i in [ m .. n ] do

     Print( "\n-----------------------------------------------------------------\n" );

     Print( "In index ", String( i ) );

     Print( "\n\nMorphism is\n" );

     Display( map[ i ] );

     od;

end );

#################################
#
# Operations
#
#################################

InstallMethod( HasActiveLowerBound,
               [ IsChainOrCochainMorphism ],

  function( phi )

  if HasActiveLowerBound( Source( phi ) ) or HasActiveLowerBound( Range( phi ) ) then

     return true;

  fi;

  if IsBound( phi!.LowerBound ) then

     return true;

  fi;

  return false;

end );

InstallMethod( HasActiveUpperBound,
               [ IsChainOrCochainMorphism ],

  function( phi )

  if HasActiveUpperBound( Source( phi ) ) or HasActiveUpperBound( Range( phi ) ) then

     return true;

  fi;

  if IsBound( phi!.UpperBound ) then

     return true;

  fi;

  return false;

end );

##
InstallMethod( SetUpperBound,

              [ IsChainOrCochainMorphism, IsInt ],

   function( phi, upper_bound )

   if IsBound( phi!.UpperBound ) and phi!.UpperBound < upper_bound then

      Error( "There is already a smaller upper bound!" );

   fi;

   phi!.UpperBound := upper_bound;

end );

##
InstallMethod( SetLowerBound,

              [ IsChainOrCochainMorphism, IsInt ],

   function( phi, lower_bound )

   if IsBound( phi!.LowerBound ) and phi!.LowerBound > lower_bound then

      Error( "There is already a greater lower bound!" );

   fi;

   phi!.LowerBound := lower_bound;

end );

InstallMethod( ActiveLowerBound,
               [ IsChainOrCochainMorphism ],

  function( phi )
  local l;

  if not HasActiveLowerBound( phi ) then

     Error( "" );

  fi;

  if HasActiveLowerBound( Source( phi ) ) then

     if HasActiveLowerBound( Range( phi ) ) then

        l := Maximum( ActiveLowerBound( Source( phi ) ), ActiveLowerBound( Range( phi ) ) );

     else

        l := ActiveLowerBound( Source( phi ) );

     fi;

  elif HasActiveLowerBound( Range( phi ) ) then 

     l := ActiveLowerBound( Range( phi ) );

  else 

     l := NegativeInfinity;

  fi;

  if IsBound( phi!.LowerBound ) then

     SetLowerBound( phi, Maximum( l, phi!.LowerBound ) );

  else

     SetLowerBound( phi, l );

  fi;

  if IsBound( phi!.UpperBound ) and phi!.LowerBound > phi!.UpperBound then

        phi!.LowerBound := phi!.UpperBound;

  fi;

  return phi!.LowerBound;

end );

InstallMethod( ActiveUpperBound,
               [ IsChainOrCochainMorphism ],

  function( phi )
  local l;

  if not HasActiveUpperBound( phi ) then

     Error( "" );

  fi;

  if HasActiveUpperBound( Source( phi ) ) then

     if HasActiveUpperBound( Range( phi ) ) then

        l := Minimum( ActiveUpperBound( Source( phi ) ), ActiveUpperBound( Range( phi ) ) );

     else

        l := ActiveUpperBound( Source( phi ) );

     fi;

  elif HasActiveUpperBound( Range( phi ) )  then

     l := ActiveUpperBound( Range( phi ) );

  else 

     l := PositiveInfinity;

  fi;

  if IsBound( phi!.UpperBound ) then

     SetUpperBound( phi, Minimum( l, phi!.UpperBound ) );

  else

     SetUpperBound( phi, l );

  fi;

  if IsBound( phi!.LowerBound ) and phi!.UpperBound < phi!.LowerBound then

        phi!.UpperBound := phi!.LowerBound;

  fi;

  return phi!.UpperBound;

end );
