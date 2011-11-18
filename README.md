# Multimedia with FastPdfKit

![Map](http://reader.fastpdfkit.com/readme/map.jpg)

[FastPdfKit](http://fastpdfkit.com) is a framework to add PDF support to iOS apps and
it's available here on [github](https://github.com/mobfarm/fastpdfkit).

This document is the Readme for the [multimedia](https://github.com/mobfarm/multimedia) sample project available on [github](https://github.com/mobfarm/multimedia).

Since version 3.0 it supports multimedia overlays from native pdf annotations.

In this repository we are creating some sample classes to let you familiarize with the capabilities and create your customized overlays.

## Default FastPdfKit annotations

FastPdfKit supports internally some annotations, take a look at [this list](http://support.fastpdfkit.com/kb/faq-and-tips/multimedia-protocols-and-url).

## Custom pdf uri annotations

With the technique illustrated below you can create any kind of overlay:

* Show maps
* Show movies
* Show web pages
* Add sounds
* Image gallery
* Popup messages
* Popup web view
* Pupup images
* Include pools
* Get more informations
* Interact with the document
* Set some properties
* Lock the rotation
* Tweet some text
* 360° panorama
* Video popup
* Change page content
* Images carousels
* Send email
* ...

Download the **FastPdfKit Reader** app from the [App Store](http://itunes.com/apps/fastpdfkitreader) and look at the **Gliphit** pdf: it doesn't seems a pdf!

You can use the **FastPdfKit Reader** app to **get inspiration** for your **custom overlays**. [Here](http://support.fastpdfkit.com/kb/general/fastpdfkit-reader-and-multimedia-documents) there is the complete annotation parameters supported.

## Structure

In the `MFViewController` the method `actionOpenPlainDocument` instantiates all the classes.

For the pdf visualization we are using a `ReaderViewController` subclass called `ReaderViewControllerSubclass`.

To manage the overlay we've created an object that implements the `FPKOverlayViewDataSource` protocol called `OverlayDataSource`.

Then we have two classes `MFMapAnnotation` and `YouTubeView` to customize the overlay appearances.

## OverlayDataSource

The Protocol requires the [three methods](http://doc.fastpdfkit.com/Protocols/FPKOverlayViewDataSource.html):

	- (NSArray *)documentViewController:(MFDocumentViewController *)dvc overlayViewsForPage:(NSUInteger)page;

This method should return an array of views to be rendered over each page.

	- (CGRect)documentViewController:(MFDocumentViewController *)dvc rectForOverlayView:(UIView *)view onPage:(NSUInteger)page;

This method should return the `CGRect` for each annotation required to manage rotations and single/double page.

	- (void)documentViewController:(MFDocumentViewController *)dvc willAddOverlayView:(UIView *)view;
	
This last method let you perform some operations when the annotations are going to be displayed. By default FastPdfKit adds a fade-id and fade-out alpha animation on every added view.

### overlayViewsForPage

You have at least two ways to manage overlay sources: use the native pdf uri annotations or some external overlay data source.

In this example we are using standard pdf annotations.

With the [`MFDocumentManager`](http://doc.fastpdfkit.com/Classes/MFDocumentManager.html)'s method [`- (NSArray *)uriAnnotationsForPageNumber:(NSUInteger)pageNr`](http://doc.fastpdfkit.com/Classes/MFDocumentManager.html#//api/name/uriAnnotationsForPageNumber:) we are obtaining an array of [`FPKURIAnnotation`](http://doc.fastpdfkit.com/Classes/FPKURIAnnotation.html) with two properties: `(NSString *) uri` and `(CGRect) rect`.

The `uri` property will contain the full uri of the annotation created with Preview (or any other pdf editor). The `rect` is filled with page coordinates of the pdf annotation.

![Uri with Preview](http://reader.fastpdfkit.com/readme/uri.jpg)

The goal is to create a view that will use these informations to represent any content.

With the array of annotations from the pdf we call the custom method 

	- (UIView *)showAnnotationForOverlay:(BOOL)load withRect:(CGRect)rect andUri:(NSString *)uri onPage:(NSUInteger)page;

to parse the uri parameters and create the `UIView`.

### showAnnotationForOverlay:withRect:andUri:onPage:

The first lines are needed to parse the uri, splitting it in protocol (the part before **://**), resource (the part between **://** and **?**) and parameters (after **?** separated by **&**).

Protocol, resource and parameters are useful to define different overlays.

In the sample project we are supporting:

* utube://
* map://
* goto://

with many parameters listed at the end of this document.

For YouTube support we've created a `UIWebView` subclass called `YouTubeView` that contains just the embedded player.

In an if block we check with the `load` boolean value if the method is called when the page loads or when the user has tapped on the annotation. In this case we are interested to show the YouTube player immediately.

Then we instantiate the `YouTubeView` with movie id taken from the annotation `uri`.

	if ([uriType isEqualToString:@"utube"]){            
	    if (load){
	       	YouTubeView *youTubeView = [[YouTubeView alloc] 
                  initWithStringAsURL:[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@", uriResource]
                  frame:[documentViewController convertRect:rect toViewFromPage:page]];
            retVal = youTubeView;
        }
    }

### rectForOverlayView

The frame of the annotation is calculated from the one extracted from the pdf annotation and converted to `UIView` coordinate system.

To do that we are using the [`MFDocumentViewController`](http://doc.fastpdfkit.com/Classes/MFDocumentViewController.html)'s [`convertRect:toViewFromPage:`](http://doc.fastpdfkit.com/Classes/MFDocumentViewController.html#//api/name/convertRect:toViewFromPage:).

The very same frame should be passed when the view is created and in any moment the `MFDocumentViewController` calls the `rectForOverlayView:onPage:` method.

### YouTube Video

An overlay with a web view that contains the youtube player. The video id is something like `npawmHVaf-E` and you can take it from any YouTube video [http://www.youtube.com/watch?v=npawmHVaf-E](http://www.youtube.com/watch?v=npawmHVaf-E).

	utube://[VIDEO_ID]


### Map

Google map with overlay with multitouch and that redraws based on the zoom page level of the pdf itself.

The resource is the map type.

	map://[hybrid,satellite,standard]

**Parameters**

* Latitude

	`lat=[double]`

* Longitude

	`lon=[double]`

* Span latitude

	`latd=[float]`

* Span langitude

	`lond=[float]`
	
**Optional parameters**

* Pin latitude
	
	`pinlat=[double]`	


* Pin longitude
	
	`pinlon=[double]`	

* Pin title

	`pintitle=[TITLE]`

* Pin subtitle

	`pinsub=[SUBTITLE]`

* Pin color

	`pincolor=[red,green,purple]`

* Add user position
	
	`user=[YES/NO]`

**Sample**

	map://hybrid?lat=37.0&lon=-122.0&latd=0.11&lond=0.10&pinlat=37.0&pinlon=-122.0&pintitle=Title&pinsub=Subtitle&pincolor=red&user=YES


### Zoom on a page

Choose a page and the area where you want to zoom to.

	goto://

**Parameters**

* Page destination

	`page=[INT]`	

* Zoom level

	`zoom=[FLOAT]`

* Origin `x` of the area

	`x=[FLOAT]`

* Origin `y` of the area

	`y=[FLOAT]`

* Width of the area

	`w=[FLOAT]`

* Height of the area

	`h=[FLOAT]`


## Follow us

* [fastpdfkit.com](http://fastpdfkit.com)
* [support](http://support.fastpdfkit.com)
* [@FastPdfKit](http://twitter.com/fastpdfkit)
* [YouTube](http://youtube.com/mobfarm)