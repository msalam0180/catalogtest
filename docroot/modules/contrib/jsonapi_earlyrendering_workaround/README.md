JSON:API Early Rendering Workaround
=

The context
-

In Drupal 8, rendering is not supposed to take place in the controller layer
but only in the view/theme layer (so called "rendering layer"). This is so
all cachability metadata is properly handled and propagated back to the Drupal
Kernel, the HTTP response correctly populated with the right header, and the
cached data invalided when it needs to be.

Alas, many module implementation (even in core) rely on rendering things to
perform their actual business logic.

To overcome this situation, the core implement an event subscriber that wrap
the execution of the controller logic inside a specific RenderContext to detect
that so-called "leaked" metadata when it occurs.

The issue
-

If the requests generates a standard Drupal reponse (an HTML page or an Ajax
response), the wrapper is able to take care of reintegrating that data back to the 
response. In any other case, if the controller returned a cacheable response,
the wrapper throw an exception and halt the execution flow.

This is the so called 

    The controller result claims to be providing relevant cache metadata, 
    but leaked metadata was detected. Please ensure you are not rendering 
    content too early.

This a PITA when building projects massively relying on API provider such as
JSON:API because the controller response is not a standard  HTML response nor
an Ajax response but is still a cacheable response.

So whenever a module is doing something that trigger a render process without
propertly doing so in a render context to cache the metadata and either propagate
it correctly or discard it, the whole request fails.

This was triggered and fixed in several modules in the past. Metatag was on of
those strong showstoppers at some point. Pathauto still triggers some issue
when using complex Token-based replacement.

The workaround
-

Fortunately, Drupal having built-in Dependency Injection mechanisms, it's 
relatively easy to provide an alternative event subscriber which will
detect that the controller being invoked is from JSON:API and be more tolerant
when the issue occur. In every other cases, it'll simply pass the request to
the original implementation.
