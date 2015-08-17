Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1439850198.11296.5.camel@linux.intel.com>
Subject: Re: [PATCH v3 5/7] pmem: add copy_from_iter_pmem() and clear_pmem()
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Mon, 17 Aug 2015 16:23:18 -0600
In-Reply-To: <20150817191016.GC6752@lst.de>
References: <1439836211-4719-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1439836211-4719-6-git-send-email-ross.zwisler@linux.intel.com>
	 <20150817191016.GC6752@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-08-17 at 21:10 +0200, Christoph Hellwig wrote:
> >  #include <linux/uaccess.h>
> > +#include <linux/uio.h>
> > +
> 
> Can we keep this in linux/pmem.h?  I'm pretty sure the stubs would need
> it as well, and even if they don't it'll keep the includes consistent.

Sure.

> > +{
> > +	size_t len;
> > +
> > +	len = copy_from_iter_nocache((void __force *)addr, bytes, i);
> > +
> > +	/*
> > +	 * copy_from_iter_nocache() on x86 only uses non-temporal stores for
> > +	 * iovec iterators, so for other types (bvec & kvec) we must do a
> > +	 * cache write-back.
> 
> Shouldn't we fi that?

I'm not sure - When Al make copy_from_iter_nocache() it was just a copy of
copy_from_iter(), with the iovec case changed to use
__copy_from_user_nocache().  The other cases use memcpy_from_page() and
memcpy().  To have everything do non-temporal stores we'd probably need to
make non-temporal versions of each of those (alluded to by Al's comment in the
copy_from_iter_nocache() commit: "BTW, do we want memcpy_nocache()?").

> > +	 */
> > +	if (iter_is_iovec(i) == false)
> > +		__arch_wb_cache_pmem(addr, bytes);
> 
> And if not and iter_needs_pmem_wb helper to encode this knowledge would
> be useful.

Maybe this should be the short-term solution, and I'll add a TODO to fix the
copy_from_iter_nocache() implementation as described above so we can always
have non-temporal stores?

> > +static inline void arch_clear_pmem(void __pmem *addr, size_t size)
> > +{
> > +	/* TODO: implement the zeroing via non-temporal writes */
> > +	if (size == PAGE_SIZE && ((unsigned long)addr & ~PAGE_MASK) == 0)
> > +		clear_page((void __force *)addr);
> > +	else
> > +		memset((void __force *)addr, 0, size);
> > +
> > +	__arch_wb_cache_pmem(addr, size);
> 
> Please add a local vaiable so that the __force casting is only needed
> once.  Same for other functions with this pattern.

Sure.


