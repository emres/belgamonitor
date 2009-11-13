
Description
============
belgamonitor is a small utility to monitor the Internet capacity already used for Belgacom Internet. 

Motivation 
----------
I have created this little piece of software because I'm a Belgacom customer and I have a monthly limit (25 GB). If I hit this limit before the last day of the month either I have to buy another 5 GB or suffer a very slow Internet connection. I was desparate to find a simple utility that shows me how much data I have used, preferably in a graphical way, but I couldn't find one (who knows maybe I haven't googled hard enough, anyway) so I decided it to roll up something myself using Ruby.


Dependencies 
------------
This program depends on the following software:

* Ruby 
* Watir
* Googlecharts
* IE or Firefox web browser

If you don't have any of these installed here are relevant links and 
documentation:

* [http://www.ruby-lang.org/en/downloads](http://www.ruby-lang.org/en/downloads)
* [http://watir.com](http://watir.com)
* [http://googlecharts.rubyforge.org/](http://googlecharts.rubyforge.org/)

Optional
--------
If you want to have a GUI, you can belgamonitor_gui however this adds 
another dependency:

* ActiveTcl 8.4

You may download ActiveState's Tcl/Tk GUI toolkit for Ruby from

* [https://www.activestate.com/activetcl/downloads/](https://www.activestate.com/activetcl/downloads/)

but please make *sure* that you download version *8.4* and not version 8.5
or 8.6


Installation
------------
If you were able to install the above software successfully then you are
very close to using the program. Here are the steps:

* Go the directory where you downloaded the program
  e.g. cd /belgamonitor
* Edit the config.yaml
  e.g. open it with a text editor (Notepad, VIM, Emacs, etc.) and
  in place of the username and password write your username and password.
  Then save the file.
* Now simply run the belgacom.rb file either using command line:
  ruby belgacom.rb
  Or simply by double clicking on the belgacom.rb file.

Important Notes 
---------------
If you ever receive an error similar to

   C:/Ruby/lib/ruby/gems/1.8/gems/watir-1.6.2/lib/watir/ie.rb:113:in `initialize':
     unknown OLE server: `AutoItX3.Control' (WIN32OLERuntimeError)
     	     HRESULT error code:0x800401f3
	     Invalid class string

Please run a command shell (e.g. cmd) as an Administrator, go to the 
directory where AutoItX3.dll is and run regsvr32 on it, e.g.:

	  cd C:\Ruby\lib\ruby\gems\1.8\gems\watir-1.6.2\lib\watir

	  regsvr32 AutoItX3.dll

And hopefully you'll get a nice pop-up telling you that the DLL file is
registered and now you can run the program without that error. 
Interestingly I found this solution at this address:

[http://wiki.openqa.org/display/WTR/FAQ#FAQ-HowdoItakescreenshotsandappendtoaWordfile%3F](http://wiki.openqa.org/display/WTR/FAQ#FAQ-HowdoItakescreenshotsandappendtoaWordfile%3F)

Don't ask me why.
