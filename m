Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4225B2194EB65
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 16:31:34 -0700 (PDT)
Subject: Re: panics related to nfit_test?
References: <58E793E8.8070507@hpe.com>
 <CAPcyv4jfCZMpNAC=-vG0a_koAfe-Vrr_+xcHXw1=TD+3DsqN+Q@mail.gmail.com>
 <58E7C875.8050008@hpe.com> <58E7F689.8010709@hpe.com>
 <CAPcyv4gS+z_HiMrgvayDaQr2qNKtZ+6boMdDZj0hQrxJhc+U6g@mail.gmail.com>
 <58E80ABB.3040807@ymail.com>
 <CAPcyv4i7LURhWQvDtxu6Bdtr2sEEHqjPqaE6a7oBYX7raNqyCw@mail.gmail.com>
 <58F1494F.2080107@hpe.com>
 <CAPcyv4hYa2B8Zg9Tw1RfBFNwXX9+m+DnwytyxwqZwWsVW-o+Ug@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58F15BD0.9040708@hpe.com>
Date: Fri, 14 Apr 2017 19:31:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hYa2B8Zg9Tw1RfBFNwXX9+m+DnwytyxwqZwWsVW-o+Ug@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/14/2017 06:28 PM, Dan Williams wrote:
> 
> I have not, but I did send out a new patch that makes sure to shutdown
> the nfit_test trickery before freeing the test objects.  Does this
> patch cleanup any of the failures you are seeing?
> 
> https://patchwork.kernel.org/patch/9681861/
> 

I tried it and got similar results.  On my server, once it panicked in rmmod, once it
panicked when disabling the regions.  I got excited on my laptop because it survived
the rmmod, but then panicked a few seconds later.  I also got a panic that might
have been during the modprobe but I can't be sure because I don't get good information
when my laptop crashes.

I see people posting tests so it's working for some people.  Anyone else
interested in sharing what you're running on and exactly how you're building
and installing your kernel and these modules?

-- ljk

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
