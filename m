Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54590781.9070500@plexistor.com>
Date: Tue, 04 Nov 2014 19:06:09 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	 <1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	 <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>	 <100D68C7BA14664A8938383216E40DE04082985D@FMSMSX114.amr.corp.intel.com>	 <5458AC75.3030207@plexistor.com>	 <94D0CD8314A33A4D9D801C0FE68B40295936C4B1@G4W3202.americas.hpqcorp.net> <1415119296.26199.12.camel@theros.lm.intel.com>
In-Reply-To: <1415119296.26199.12.camel@theros.lm.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "Knippers, Linda" <linda.knippers@hp.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 11/04/2014 06:41 PM, Ross Zwisler wrote:
<>
> 
> The UEFI organization is in the process of defining a generic specification
> for platform non-volatile memory resources.  Essentially the thought was to
> wait until that was publicly available before adding any new device discovery
> capabilities to pmem.
> 
> What Boaz has suggested and coded up is certainly useful, but the worry is
> that it will end up being incompatible with what comes out of UEFI.  If we
> stay with the dead-simple module parameter method, we will have less code to
> unwind later.
> 

What ??
What I coded up is a exactly "dead-simple module parameter method"
that will not need to be changed in future, that is actually sane.

Actually your version of the code needs changing with the global parameters,
one range support, and same size devices.

My version of the code is specifically made very probe() ready and dynamic
ready. It was the point of it all. Including bugs and ugliness fixed.
(I have a small patch that dynamically addes/removes devices on the fly
 through the same module-param interface)

There is not a line in all of my patches that might be affected by
that UEFI comity. (Again actually fixing what needed changing). And in
addition to that comity and the new HW they will define, my system
also supports all the current NvDIMMs in the market.

I really can not understand what you guys are saying? Have you actually
looked at the code and used it, compared to the unusable thing you guys
have now ??
[Like you are saying "before adding any new device discovery capabilities"
 But I have not added any? All I did was fix and simplify the module-param
 interface. Which makes me think that you might not have looked at any of
 my fixes?
]

> Thanks,
> - Ross

Cheers
Boaz

