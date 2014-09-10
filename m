Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <541037D1.1040800@gmail.com>
Date: Wed, 10 Sep 2014 14:36:49 +0300
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/9] SQUASHME: pmem: Remove unused #include headers
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	 <540F1EC6.4000504@plexistor.com> <540F1F6F.7090905@plexistor.com> <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 09/10/2014 01:29 AM, Ross Zwisler wrote:
<>
> 
> I was under the impression that the philosophy regarding includes was that you
> should directly include header files for the things that you use, and not rely
> on headers that include other headers?  That way a change to a header file
> where you remove an unneeded #include doesn't cascade into a bunch of changes
> in .c files for now undefined symbols?
> 
> If this isn't the case, I think we can actually pare things down to just these
> three include files:
> 


> #include <linux/blkdev.h>
> #include <linux/hdreg.h>
> #include <linux/module.h>
> 

You are right I like this set + maybe add slab.h because we are
using kzalloc directly not regarding any driver API

> 
> Here are the other include files that you left:
>>  #include <linux/init.h>
> Included from include/linux/printk.h:5:0,
> 	 from include/linux/kernel.h:13,
> 	 from include/linux/sched.h:17,
> 	 from include/linux/blkdev.h:4
> 
>>  #include <linux/moduleparam.h>
> Included by <linux/module.h>
> 

I agree both init.h and moduleparam.h are implicit with being a "module".
I need them because that is what module needs, not for my own sake.
They are brought in by module.h APIs I am using types and defs from
these headers but because "module" API needs them

>>  #include <linux/slab.h>
> Included from include/linux/genhd.h:15:0,
> 	 from include/linux/blkdev.h:9
> 

slab.h I would leave that might theoretically change

> 
> If we *should* directly include the header files for anything that we use, we
> can probably pare it down to this:
> 
> #include <asm/cacheflush.h>

What ? why

> #include <linux/fs.h>
> #include <linux/bio.h>

Both fs.h && bio.h are a part of blkdev API. As a block device
API implementing driver we must use some of these types. It is
not possible that blkdev will ever "not use" bio or fs.h types
any more and the only fix to my code will be a missing include.

> #include <linux/blkdev.h>
> #include <linux/hdreg.h>

Yes

> #include <linux/init.h>
> #include <linux/moduleparam.h>

Again brought in by "module" I would drop them

> #include <linux/module.h>
> #include <linux/slab.h>
Yes

so I'd say our set should be:
#include <linux/blkdev.h>
#include <linux/hdreg.h>
#include <linux/module.h>
#include <linux/slab.h>

But it is such a trivial issue do what you decide

Thanks
Boaz

