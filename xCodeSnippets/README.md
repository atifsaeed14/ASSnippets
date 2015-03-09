## NetworkManager 

### A NSOperation-based implementation of delegate-based NSURLSession

--

This is an demonstration of a `NSOperation`-based implementation of delegate-based `NSURLSession`.

Because the delegate-based `NSURLSession` object uses a single object as the delegate for both session and task delegate methods, one has to maintain a mapping between the `identifier` of the various `NSURLSessionTask` objects and the associated `NSOperation` subclass object. Once that is done, the `NSURLSessionTaskDelegate` object can use that cross reference to invoke the appropriate method in the `NSOperation` subclass.

This is for illustrative purposes only.

Developed in Xcode 5.1.1 for iOS 7.0+, also tested on Xcode 6.0 Beta.

## Class Reference

http://robertmryan.github.io/NetworkManager/Classes/NetworkManager.html

## License

Copyright &copy; 2014 Robert Ryan. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

--

10 June 2014

https://github.com/mattt/Xcode-Snippets

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
self = [super init];
if (!self) {
return nil;
}

<# sdffs  # then close this >
implementation

return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
<# implementation #>
}


HTML
http://designmodo.github.io/Flat-UI/#

Using the Snippets

Simply paste the snippets to ~/Library/Developer/Xcode/UserData/CodeSnippets/. Then use them with the defined shortcut or via the Code Snippets Library.

Snippets

Property declaration for Classes

Declare a strong property for classes with the shortcut propclass. The strong attribute has been left out, since it is a default attribute for an object.

The Snippet Identifier is B89FB628-39AD-4020-A3E4-377A55DADF04.

@property (nonatomic) <#class#> *<#name#>;