Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73FF62264D25F
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 00:44:09 -0700 (PDT)
Date: Mon, 12 Mar 2018 00:50:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm-writecache
Message-ID: <20180312075029.GC30695@infradead.org>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <alpine.LRH.2.02.1803082213080.2200@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803082213080.2200@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 08, 2018 at 10:26:17PM -0500, Mikulas Patocka wrote:
> > no business having this around.
> 
> It's the default setting of the flag wc->writeback_fua (it can be changed 
> with target parameters). The flag selects whether the target uses FUA 
> requests when doing writeback or whether it uses non-FUA requests and 
> FLUSH afterwards. For some block devices, FUA is faster, for some 
> nonFUA+FLUSH is faster.

So just use true as the default flag, adding a name for it in addition
to the field it is assigned to makes no sense at all.

> > > +#ifndef bio_set_dev
> > > +#define	bio_set_dev(bio, dev)	((bio)->bi_bdev = (dev))
> > > +#endif
> > > +#ifndef timer_setup
> > > +#define timer_setup(t, c, f)	setup_timer(t, c, (unsigned long)(t))
> > > +#endif
> > 
> > no business in mainline.
> 
> People removed dax support for ramdisk in 4.15.
> 
> If I need to test it on non-x86 architecture, I need ramdisk as a fake dax 
> device - and that only works up to 4.14. These defines are for 4.14 
> compatibility.

So add them when you backport, or use the existing automated backport
frameworks.  But do not add dead code to an upstream submission.

> > > +#if defined(CONFIG_X86_64)
> > > +#define NT_STORE(dest, src)				\
> > > +do {							\
> > > +	typeof(src) val = (src);			\
> > > +	memcpy_flushcache(&(dest), &val, sizeof(src));	\
> > > +} while (0)
> > > +#define COMMIT_FLUSHED()	wmb()
> > > +#else
> > > +#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
> > > +#define FLUSH_RANGE		dax_flush
> > > +#define COMMIT_FLUSHED()	do { } while (0)
> > > +#endif
> > 
> > Please use proper APIs for this, this has no business in a driver.
> > 
> > And that's it for now.  This is clearly not submission ready, and I
> > should got back to my backlog of other things.
> 
> Why is memcpy_flushcache and dax_flush "improper"? What should I use 
> instead of them?

They are proper and should be used directly instead of through your
hacky macros.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
