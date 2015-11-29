//
//  GNEIntegerCountedSet.h
//  GNETextSearch
//
//  Created by Anthony Drendel on 11/14/15.
//  Copyright © 2015 Gone East LLC. All rights reserved.
//

#ifndef GNEIntegerCountedSet_h
#define GNEIntegerCountedSet_h

#include <stdint.h>

#ifndef GNEInteger
    #define GNEInteger int64_t
#endif

typedef struct GNEIntegerCountedSet * GNEIntegerCountedSetPtr;

extern GNEIntegerCountedSetPtr GNEIntegerCountedSetCreate(void);
extern GNEIntegerCountedSetPtr GNEIntegerCountedSetCreateWithInteger(GNEInteger integer);
extern void GNEIntegerCountedSetDestroy(GNEIntegerCountedSetPtr ptr);

extern size_t GNEIntegerCountedSetGetCount(GNEIntegerCountedSetPtr ptr);

/// Returns 1 if the counted set includes the integer, otherwise 0.
extern int GNEIntegerCountedSetContainsInteger(GNEIntegerCountedSetPtr ptr, GNEInteger integer);

/// Returns the count for the specified integer. Returns 0 if the integer is not in the set.
extern size_t GNEIntegerCountedSetGetCountForInteger(GNEIntegerCountedSetPtr ptr, GNEInteger integer);

/// Creates an array of all of the integers in the specified counted set in descending order
/// (the integer with the largest count is returned first). On return, the specified outIntegers
/// pointer points at the array, which must be freed by the caller.
extern int GNEIntegerCountedSetCopyIntegers(GNEIntegerCountedSetPtr ptr, GNEInteger **outIntegers, size_t *outCount);

/// Adds the specified integer to the counted set. Returns 1 if successful, otherwise 0.
extern int GNEIntegerCountedSetAddInteger(GNEIntegerCountedSetPtr ptr, GNEInteger integer);

/// Removes the specified integer from the counted set. Returns 1 if successful, otherwise 0.
/// Success is unrelated to whether or not the integer exists in the counted set.
int GNEIntegerCountedSetRemoveInteger(GNEIntegerCountedSetPtr ptr, GNEInteger integer);

/// Adds each integer and its count in the other counted set to specified set.
extern int GNEIntegerCountedSetUnionSet(GNEIntegerCountedSetPtr ptr, GNEIntegerCountedSetPtr otherPtr);

/// Removes from the specified counted set each integer that isn’t a member of the other set.
/// If an integer is present in both sets, its counts are added together.
extern int GNEIntegerCountedSetIntersectSet(GNEIntegerCountedSetPtr ptr, GNEIntegerCountedSetPtr otherPtr);

/// Removes each integer in the other counted set from the specified set, if present.
extern int GNEIntegerCountedSetMinusSet(GNEIntegerCountedSetPtr ptr, GNEIntegerCountedSetPtr otherPtr);

#endif /* GNEIntegerCountedSet_h */
