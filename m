Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 10 Sep 2014 15:16:42 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Linux-nvdimm] [PATCH 1/9] SQUASHME: pmem: Remove unused
 #include headers
Message-ID: <20140910191642.GI27730@localhost.localdomain>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
 <540F1EC6.4000504@plexistor.com>
 <540F1F6F.7090905@plexistor.com>
 <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 09, 2014 at 04:29:43PM -0600, Ross Zwisler wrote:
> On Tue, 2014-09-09 at 18:40 +0300, Boaz Harrosh wrote:
> > From: Boaz Harrosh <boaz@plexistor.com>
> > 
> > Removed:
> > -#include <linux/bio.h>
> > -#include <linux/fs.h>
> > 
> > These two are included in linux/blkdev.h

Woah, woah, woah, what is this craziness?  You shouldn't ever rely on
implicitly included files.

> > -#include <linux/highmem.h>
> I think this was present in the BRD code for flush_dcache_page(), but we
> should probably be direct and include <asm/cacheflush.h> instead.

Reasonable.

> > -#include <linux/major.h>
> Yep, not needed.

Agreed.

> > -#include <linux/uaccess.h>
> Yep, not needed.

I don't see a need for it either.

> > These 3 are not used anymore
> 
> I was under the impression that the philosophy regarding includes was that you
> should directly include header files for the things that you use, and not rely
> on headers that include other headers?  That way a change to a header file
> where you remove an unneeded #include doesn't cascade into a bunch of changes
> in .c files for now undefined symbols?

Correct.

> If we *should* directly include the header files for anything that we use, we
> can probably pare it down to this:
> 
> #include <asm/cacheflush.h>
> #include <linux/bio.h>
> #include <linux/blkdev.h>
> #include <linux/fs.h>
> #include <linux/hdreg.h>
> #include <linux/init.h>
> #include <linux/module.h>
> #include <linux/moduleparam.h>
> #include <linux/slab.h>

Looks reasonable.
