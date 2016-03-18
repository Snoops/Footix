//
//  FTWeakReferenceMutableArray.swift
//  FootixSlack
//
//  Created by Adrien Caranta on 2016-03-18.
//  Copyright © 2016 Footix. All rights reserved.
//

import Foundation

//====================================
//MARK: - FTWeakReferenceWrapper
//====================================

/** This wrapper is used so that a strong pointer to a weak reference can exist.
Mainly used so that a week pointer to an object can be stored in an array. */
public class FTWeakReferenceWrapper : NSObject {
    
    /** Pointer to a weak object.  Nil if the object was released or did not exist in the first place.. */
    weak var weakReference:NSObject? = nil
}

//====================================
//MARK: - FTWeakReferenceMutableArray
//====================================

/** Mutable array of weak referenced pointers.  Allows to keep an array of weak references. */
public class FTWeakReferenceMutableArray : NSObject {
    
    //====================================
    //MARK: Public Properties
    //====================================
    
    /** If this array ignores duplicate instances of objects or not.  Can only be set via constructor when
    the array is created.  If this is set to true, objects that already exist in the list will not be added again.*/
    private(set) var ignoresDuplicateObjects:Bool = false;
    
    /** How many objects are in the array.  Includes nil objects. */
    public var count:Int { get { return self.weakReferenceWrappers.count; } }
    
    //====================================
    //MARK: Private Properties
    //====================================
    
    /** Mutable array of weak reference wrappers. */
    private var weakReferenceWrappers:Array<FTWeakReferenceWrapper> = Array<FTWeakReferenceWrapper>()
    
    //====================================
    //MARK: Constructors
    //====================================
    
    /** Convenience constructor.  Can set if this array will ignore duplicate instance of objects. */
    convenience init(ignoresDuplicateObjects:Bool) {
        
        //Initialize self
        self.init()
        
        //Set if this array ignores duplicate objects or not.
        self.ignoresDuplicateObjects = ignoresDuplicateObjects;
    }
    
    /** Default contructor.  Creates an array that allows duplicate instance of objects. */
    override init() {
        
        //Call the base
        super.init()
    }
    
    //====================================
    //MARK: Public Methods
    //====================================
    
    /** Adds an object to the array.  If property 'ignoreDuplicateObjects' is true, and the object is
    already inthe list, the object is not added again.
    - Parameter object: The object to add to the array.
    */
    func addObject(object:NSObject) {
        
        //If duplicate objects are not allowed, check to see if it already exists in the list.
        if self.ignoresDuplicateObjects == true {
            
            //Get if the object is already in the list.
            let alreadyInList = self.objectIsInList(object)
            
            //If the object already exists in the list do nothing.
            if alreadyInList == true {
                return;
            }
        }
        
        //Create a weak reference wrapper for the object and add it to the array.
        let weakReferenceWrapper = FTWeakReferenceWrapper();
        weakReferenceWrapper.weakReference = object;
        self.weakReferenceWrappers.append(weakReferenceWrapper)
    }
    
    /** Removes an object from the array.
     - Parameter object: The object to add to the array.
     */
    func removeObject(object:NSObject) {
        
        //Index of object to remove
        var indexOfObjectToRemove:Int? = nil;
        
        //Loop through all of the weak reference wrappers
        for (index, weakReferenceWrapper) in self.weakReferenceWrappers.enumerate() {
            
            //If the itterated weak reference is nil, continue to the next one.
            if weakReferenceWrapper.weakReference == nil {
                continue;
            }
            
            //If the object is found, set as the wrapper to remove and break out of for loop.
            if weakReferenceWrapper.weakReference == object {
                indexOfObjectToRemove = index
                break;
            }
        }
        
        //If a wrapper was flagged to remove, do it
        if indexOfObjectToRemove != nil {
            self.weakReferenceWrappers.removeAtIndex(indexOfObjectToRemove!);
        }
    }
    
    /** Removes all of the objects that have been released. */
    func removeReleasedObjects() {
        
        //Itterate backwards through the list and remove wrappers that have a nil weakReference.
        for(var i = self.weakReferenceWrappers.count - 1; i >= 0; i--) {
            
            //If the weak reference has an object, continue to next index.
            if self.weakReferenceWrappers[i].weakReference != nil {
                continue;
            }
            
            //Remove the object from the index
            self.weakReferenceWrappers.removeAtIndex(i)
        }
    }
    
    /** Checks to see if the object is in the list.
     - Parameter object: The object to add to the array.
     - Returns: If the object is in the list or not.
     */
    func objectIsInList(object:NSObject) -> Bool {
        
        //Loop through all of the weak reference wrappers
        for weakReferenceWrapper in self.weakReferenceWrappers {
            
            //If the itterated weak reference is nil, continue to the next one.
            if (weakReferenceWrapper.weakReference == nil) {
                continue;
            }
            
            //If the object exists, return true
            if (weakReferenceWrapper.weakReference == object) {
                return true;
            }
        }
        
        //If failed to find the object in the list, return false
        return false;
    }
    
    /** Get's an object at an index.  nil if the object was released.  Crashes if index is out of range.
     - Parameter index: The index of the object to return.
     - Returns: The object at the requested index.  Nil if the object was released.
     */
    func objectAtIndex(index:Int) -> NSObject? {
        
        //Assert that the index is valid
        assert(index >= 0 && index <= (self.weakReferenceWrappers.count - 1), "\(unsafeAddressOf(self)) FTWeakReferenceMutableArray | objectAtIndex | ERROR: Index out of range | RequestedIndex: \(index) | ObjectCount: \(self.weakReferenceWrappers.count)")
        
        return self.weakReferenceWrappers[index].weakReference;
    }
    
    /** removes an object at a given index. Crashes if index is out of range.
     - Parameter index: The index of the object to remove.
     */
    func removeObjectAtIndex(index:Int) {
        
        //Assert that the index is valid
        assert(index >= 0 && index <= (self.weakReferenceWrappers.count - 1), "\(unsafeAddressOf(self)) FTWeakReferenceMutableArray | removeObjectAtIndex | ERROR: Index out of range | RequestedIndex: \(index) | ObjectCount: \(self.weakReferenceWrappers.count)" )
        
        self.weakReferenceWrappers.removeAtIndex(index)
    }
    
    //====================================
    //MARK: - Debug
    //====================================
    
    func debugLogArray() {
        
        NSLOG("WeakReferenceMutableArray \(unsafeAddressOf(self)) | debugLogArray | Count: \(self.count)");
        
        for var i = 0; i < self.weakReferenceWrappers.count; i++ {
            
            let wrapper:FTWeakReferenceWrapper = self.weakReferenceWrappers[i];
            
            //let wrapperPointer = (wrapper.weakReference == nil ? "nil" : "\(unsafeAddressOf(wrapper))" )
            
            NSLOG("     index: \(i) | \(unsafeAddressOf(wrapper)) \( String(wrapper.weakReference))")
        }
        
    }
    
    static func test() {
        
        let array:FTWeakReferenceMutableArray = FTWeakReferenceMutableArray(ignoresDuplicateObjects: true)
        
        let object0 = NSObject()
        array.addObject(object0)
        
        array.addObjectThenReleaseIt()
        
        let object2 = NSObject()
        array.addObject(object2)
        
        array.addObjectThenReleaseIt()
        
        array.addObject(object2)
        
        array.addObjectThenReleaseIt()
        
        
        let object4 = NSObject()
        array.addObject(object4)
        
        array.addObjectThenReleaseIt()
        
        array.debugLogArray()
        
        NSLOG("Step 1");
        
        //array.removeReleasedObjects()
        
        //array.debugLogArray()
        
        let index = 6;
        let object = array.objectAtIndex(index)
        let pointOfObject = (object == nil ? "nil" : "\(unsafeAddressOf(object!))" )
        NSLOG("remove objectAtIndex: \(index) | \(pointOfObject)")
        
        //array.removeObjectAtIndex(index)
        
        array.removeObject(object2)
        
        array.debugLogArray()
    }
    
    func addObjectThenReleaseIt() {
        let object = NSObject()
        self.addObject(object)
    }
    
}
