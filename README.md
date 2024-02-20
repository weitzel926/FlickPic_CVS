# FlickPic

![Screenshot 2024-02-19 at 7 59 00 PM](https://github.com/weitzel926/FlickPic_CVS/assets/3514194/8a8568d3-d790-4d46-8f26-f876f9c4e733)  ![Screenshot 2024-02-19 at 8 00 01 PM](https://github.com/weitzel926/FlickPic_CVS/assets/3514194/9b8e3e63-cb69-4a58-ac9a-8448cf3d3c5c)

**FlickPic** is a take home interview assignment.  It is an iPhone application that calls a known Flickr API.  This API returns the last twenty or so photos uploaded to Flickr that match the tags entered by the customer in the text edit field.  Each time a character is entered, the API is called and a spinny is displayed while the code retrieves the data.  Images are loaded asyncronously into a photo grid and display a solid gray placeholder while the image is being loaded or if it fails.  If the customer taps on an image, they are taken to a details page.  The details page shows the image title (trimmed off at two lines because there are some really long titles out there), the image itself, the author, the published date, and the description.

It includes unit tests for non-UI code except for the remote call.  I did not have time to pull in a mocking framework for that.  

Things to note:
- Images on the grid are square and handled with an aspect fill
- Accessibility is not included.  We would want to turn off any non-relevant call outs in Voice Over and add an accessibility label to each image cell that reads the description of that particular photo.
- The description is a chunk of HTML text.  This is loaded into a WKWebView for display.  The need for the web view to scroll meant that I did not implement landscape mode, as the dual scrolling would be problematic.  Swift can convert HTML into an attributed string out of the box, but it loses styling.  The "correct" solution is to import a library that converts it to an attributed string and display that in a text field with proper scrolling.

## Video
![Simulator Screen Recording - iPhone 15 Pro - 2024-02-19 at 19 52 02](https://github.com/weitzel926/FlickPic_CVS/assets/3514194/9035f82a-07fc-412f-917e-2edd30679dd5)
