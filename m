Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BAFBD21A0480E
 for <linux-nvdimm@lists.01.org>; Sun, 16 Apr 2017 11:55:58 -0700 (PDT)
Subject: Re: panics related to nfit_test?
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com> <58E7F689.8010709@hpe.com>
 <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g@mail.gmail.com>
 <58E80ABB.3040807@ymail.com>
 <CAPcyv4i7LURhWQvDtxu6Bdtr2sEEHqjPqaE6a7oBYX7raNqyCw@mail.gmail.com>
 <58F1494F.2080107@hpe.com>
 <CAPcyv4hYa2B8Zg9Tw1RfBFNwXX9+m+DnwytyxwqZwWsVW-o+Ug@mail.gmail.com>
 <58F15BD0.9040708@hpe.com>
 <CAPcyv4i2PiiRbUwcps0eb-1TK3gw2z1RMeFtAeB6FESfd05uxw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <f1eee168-3195-1eef-99a9-e9adcd8bacf3@hpe.com>
Date: Sun, 16 Apr 2017 14:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i2PiiRbUwcps0eb-1TK3gw2z1RMeFtAeB6FESfd05uxw@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 4/14/2017 7:42 PM, Dan Williams wrote:
> On Fri, Apr 14, 2017 at 4:31 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> On 04/14/2017 06:28 PM, Dan Williams wrote:
>>>
>>> I have not, but I did send out a new patch that makes sure to shutdown
>>> the nfit_test trickery before freeing the test objects.  Does this
>>> patch cleanup any of the failures you are seeing?
>>>
>>> https://patchwork.kernel.org/patch/9681861/
>>>
>>
>> I tried it and got similar results.  On my server, once it panicked in rmmod, once it
>> panicked when disabling the regions.  I got excited on my laptop because it survived
>> the rmmod, but then panicked a few seconds later.  I also got a panic that might
>> have been during the modprobe but I can't be sure because I don't get good information
>> when my laptop crashes.
>>
>> I see people posting tests so it's working for some people.  Anyone else
>> interested in sharing what you're running on and exactly how you're building
>> and installing your kernel and these modules?
>>
>
> So I reproduced it! ...but only once, and then it went away which is
> why I thought that fix might have been good. That at least tells us
> that it is something more fundamental and that even my build
> environment can hit this sometimes. I think it might be a case where
> we get false results from get_nfit_res() and that leads to random
> memory corruption.

I'm so happy to hear that you reproduced it, even once.  I was
perfectly willing to accept that I was doing something wrong, and still
might be since it is so reproducible for me, but maybe there's just
a race that I keep losing. :-)

-- ljk

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
