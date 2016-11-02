From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 34/37] docs: fix locations of several
 documents that got moved
Date: Wed, 02 Nov 2016 06:08:43 -0400
Message-ID: <5819BB2B.7010404@redhat.com>
References: <cover.1476801354.git.mchehab@s-opensource.com> <28c1f5d3867174a7017e3f3d9e9e4ebb096ceed8.1476801354.git.mchehab@s-opensource.com> <20161019103442.GD1461@amd> <20161019115918.1162d16e@vento.lan> <20161102093154.GC23350@amd>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <rtc-linux+bncBCWZZUED64BBBQ7W43AAKGQEGSPATFY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20161102093154.GC23350@amd>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Cc: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jean Delvare <jdelvare-IBi9RG/b67k@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steffen Klassert <klassert-H0bhvm5RIPI+B2oLq8eQJv4efur1V5z/s0AfqQuZ5sE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbon>
List-Id: linux-nvdimm@lists.01.org



On 11/02/2016 05:31 AM, Pavel Machek wrote:
> Hi!
> 
>>> Dunno, but kernel-parameters.txt was already quite long... for a file
>>> that is referenced quite often. Adding admin-guide/ into the path does
>>> not really help.
>>
>> The big string name starts with Documentation/ :) There are some discussions 
>> about changing it to doc/ (or docs/). Also, as you said, kernel-parameters
>> is already a big name. Perhaps we could use, instead,
>>> "kernel-parms".
> 
> cmdline?

You would not believe the number of users I've dealt with that have confused
"cmdline/command line" (aka prompt) with "kernel parameter".  I go back and edit
customer debug requests to make sure there's no use of cmdline in place of
kernel parameter.

For the love of every customer facing engineer out there, please stop using
cmdline ;).

P.

> 
>> If we rename kernel-parameters.rst to kernel-parms.rst, plus the doc/ rename,
>> then the string size will actually reduce:
>>
>> -		(see Documentation/kernel-parameters.txt), the minimum possible
>> +		(see doc/admin-guide/kernel-parms.rst), the minimum possible
>>
>>> Maybe admin-guide should go directly into Documentation/ , as that's
>>> what our users are interested in?
>>
>> There are several problems if we keep them at Documentation/ dir:
>>
>> - We'll end by mixing documents already converted to ReST with documents
>>   not converted yet;
>>
>> - A rename is needed anyway, as Sphinx only accepts ReST files that end
>>   with the extension(s) defined at Documentation/conf.py (currently,
>>   .rst);
>>
>> - A partial documentation build is made by sub-directory. If we put
>>   files under /Documentation, there's no way to build just one
>>   book.
> 
> Well, documentation is primarily for users. I'm sure tools can adapt...
> 
>>> Plus, I'm not sure how many developers will figure out that process/
>>> is what describes kernel patch submission process. We have processes
>>> in the kernel, after all...
>>
>> Do you have a better idea?
> 
> development/ ?
> 
> Best regards,
> 									Pavel
> 

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.
