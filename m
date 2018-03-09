Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AFDEF224DCA3F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 19:20:04 -0800 (PST)
Date: Thu, 8 Mar 2018 22:26:17 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-writecache
In-Reply-To: <20180308145153.GB23262@infradead.org>
Message-ID: <alpine.LRH.2.02.1803082213080.2200@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 8 Mar 2018, Christoph Hellwig wrote:

> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6/drivers/md/dm-writecache.c	2018-03-08 14:23:31.059999000 +0100
> > @@ -0,0 +1,2417 @@
> > +#include <linux/device-mapper.h>
> 
> missing copyright statement, or for those new-fashioned SPDX statement.
> 
> > +#define WRITEBACK_FUA			true
> 
> no business having this around.

It's the default setting of the flag wc->writeback_fua (it can be changed 
with target parameters). The flag selects whether the target uses FUA 
requests when doing writeback or whether it uses non-FUA requests and 
FLUSH afterwards. For some block devices, FUA is faster, for some 
nonFUA+FLUSH is faster.

What's wrong with this? Why can't default settings be #defined at the 
beginning of a file?

> > +#ifndef bio_set_dev
> > +#define	bio_set_dev(bio, dev)	((bio)->bi_bdev = (dev))
> > +#endif
> > +#ifndef timer_setup
> > +#define timer_setup(t, c, f)	setup_timer(t, c, (unsigned long)(t))
> > +#endif
> 
> no business in mainline.

People removed dax support for ramdisk in 4.15.

If I need to test it on non-x86 architecture, I need ramdisk as a fake dax 
device - and that only works up to 4.14. These defines are for 4.14 
compatibility.

> > +/*
> > + * On X86, non-temporal stores are more efficient than cache flushing.
> > + * On ARM64, cache flushing is more efficient.
> > + */
> > +#if defined(CONFIG_X86_64)
> > +#define NT_STORE(dest, src)				\
> > +do {							\
> > +	typeof(src) val = (src);			\
> > +	memcpy_flushcache(&(dest), &val, sizeof(src));	\
> > +} while (0)
> > +#define COMMIT_FLUSHED()	wmb()
> > +#else
> > +#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
> > +#define FLUSH_RANGE		dax_flush
> > +#define COMMIT_FLUSHED()	do { } while (0)
> > +#endif
> 
> Please use proper APIs for this, this has no business in a driver.
> 
> And that's it for now.  This is clearly not submission ready, and I
> should got back to my backlog of other things.

Why is memcpy_flushcache and dax_flush "improper"? What should I use 
instead of them?

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
