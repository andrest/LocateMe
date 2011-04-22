//
//  NSSingleton.m
//  TimecodeCalculatorIPhone
//  ©Jean-Luc Pedroni
//
//  Created by Jean-Luc Pedroni on 12/05/08.
//  Mail: jeanluc.pedroni AT free.fr
//
//  Code provided as is, without warranty.
//  You can use it as you wish,
//  but please keep this header.
//

#import "NSSingleton.h"
#import <objc/runtime.h>

@implementation NSSingleton

typedef struct _Singleton {
	id   _class;
	id   _instance;
} Singleton;

#define  MAX_BLOC 5

static BOOL _fromInternalCall = NO; // In order to call [alloc] [dealloc] via NSSingelton.
static struct {
	int        n;
	int        capacity;
	Singleton *array;
	
} _singletonArray = {0};

static Singleton *FindSingleton(id class)
{
	Singleton *ptr = _singletonArray.array;
	Singleton *end = _singletonArray.array + _singletonArray.n;
	
	while (ptr < end) {
		if (class == ptr->_class) {
			return (ptr);
		}
		ptr++;
	}
	return (NULL);
}

static BOOL AddSingleton(id class, id instance)
{
	BOOL success = YES;
	
	if (_singletonArray.n >= _singletonArray.capacity) {
		Singleton *array = realloc(_singletonArray.array, (_singletonArray.capacity + MAX_BLOC) * sizeof(Singleton));
		
		if (array == NULL) success = NO;
		else {
			_singletonArray.array    = array;
			_singletonArray.capacity += MAX_BLOC;
		}
	}
	
	if (success == YES) {
		_singletonArray.array[_singletonArray.n]._class     = class;
		_singletonArray.array[_singletonArray.n]._instance = instance;
		_singletonArray.n++;
	}
	return (success);
}

+(void)cleanup
{
	@synchronized([NSSingleton class]) {
		_fromInternalCall = YES;
		
		// Call via 'NSSingelton' to free all singletons.
		//
		if ([self class] == [NSSingleton class]) {
			int i;
			
			for (i = 0; i < _singletonArray.n; i++) {
				[_singletonArray.array[i]._instance dealloc]; // Don't call [release] because [retainCount] is set to NSUIntegerMax so [dealloc] would never be called.
			}
			free(_singletonArray.array);
			memset(&_singletonArray, 0, sizeof(_singletonArray));
		}
		//
		// Call via inherited class, free class instance.
		//
		else {
			Singleton *singleton = FindSingleton(self);
			
			if (singleton != NULL) {
				[singleton->_instance dealloc];
				memmove(singleton, singleton + 1, ((_singletonArray.array + _singletonArray.n) - (singleton + 1)) * sizeof(_singletonArray.array[0]));
				_singletonArray.n--;
				if ((_singletonArray.capacity - _singletonArray.n) > MAX_BLOC) {
					_singletonArray.capacity -= MAX_BLOC;
					
					// Memory reduction, no failure corruption.
					//
					_singletonArray.array = realloc(_singletonArray.array, _singletonArray.capacity * sizeof(Singleton));
					
#if DEBUG
					assert(_singletonArray.array != NULL);
#endif
				}
			}
		}
		_fromInternalCall = NO;
	}
}

+(id)sharedInstance
{
	id sharedInstance = nil;
	
	@synchronized([NSSingleton class]) {
		if ([self class]  == [NSSingleton class]) [NSException raise:NSInternalInconsistencyException format:@"+[NSSingleton sharedInstance] - Abstract class instantiation -"];
		else {
			Singleton *singleton = FindSingleton(self);
			
			if (singleton != NULL) sharedInstance = singleton->_instance;
			else {
				_fromInternalCall = YES;
				id instance  = [super alloc];
				
				sharedInstance = [instance init];
				if (sharedInstance == nil) [instance dealloc];  // Don't call [release] because [retainCount] is set to NSUIntegerMax so [dealloc] would never be called.
				else if (AddSingleton(self, sharedInstance) == NO) {
					[sharedInstance dealloc];
					sharedInstance = nil;
				}
				_fromInternalCall = NO;
			}
		}
	}
	return (sharedInstance);
}

+(id)allocWithZone:(NSZone *)zone
{
	id instance = nil;
	
	@synchronized([NSSingleton class]) {
		if (_fromInternalCall == YES) instance = [super allocWithZone:zone];
		else                          [NSException raise:NSInternalInconsistencyException format:@"+[NSSingleton allocWithZone] - invalid call -"];
	}
	return (instance);
}

-(id)copyWithZone:(NSZone *)zone
{
	return (self);
}

-(id)retain
{
	return (self);
}

- (NSUInteger)retainCount
{
	return (NSUIntegerMax);  // l'objet ne peut être libéré.
}

-(void)release
{
	// Do nothing.
}

-(id)autorelease
{
	return (self);
}

-(void)dealloc
{
	// Thread safe dealloc in case of multi threading context
	//
	@synchronized([NSSingleton class]) {
		if (_fromInternalCall == YES) [super dealloc];
		else                          [NSException raise:NSInternalInconsistencyException format:@"-[NSSingleton dealloc] - invalid call -"];
	}
}
@end