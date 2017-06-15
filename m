Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58C0B21A143CE
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 01:10:10 -0700 (PDT)
Date: Thu, 15 Jun 2017 10:11:24 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 08/14] x86, dax, libnvdimm: move wb_cache_pmem() to
 libnvdimm
Message-ID: <20170615081124.GD1764@quack2.suse.cz>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703986971.20620.10303247412197996310.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170614105425.GD21506@quack2.suse.cz>
 <CAPcyv4hNLkX9ct=Z9YQ8zaqAYPa_ab_+W+Z8By6=btJEkbrZag@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hNLkX9ct=Z9YQ8zaqAYPa_ab_+W+Z8By6=btJEkbrZag@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, dm-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 14-06-17 09:49:29, Dan Williams wrote:
> On Wed, Jun 14, 2017 at 3:54 AM, Jan Kara <jack@suse.cz> wrote:
> >> -/**
> >> - * arch_wb_cache_pmem - write back a cache range with CLWB
> >> - * @vaddr:   virtual start address
> >> - * @size:    number of bytes to write back
> >> - *
> >> - * Write back a cache range using the CLWB (cache line write back)
> >> - * instruction. Note that @size is internally rounded up to be cache
> >> - * line size aligned.
> >> - */
> >>  static inline void arch_wb_cache_pmem(void *addr, size_t size)
> >>  {
> >> -     u16 x86_clflush_size = boot_cpu_data.x86_clflush_size;
> >> -     unsigned long clflush_mask = x86_clflush_size - 1;
> >> -     void *vend = addr + size;
> >> -     void *p;
> >> -
> >> -     for (p = (void *)((unsigned long)addr & ~clflush_mask);
> >> -          p < vend; p += x86_clflush_size)
> >> -             clwb(p);
> >> +     clean_cache_range(addr,size);
> >>  }
> >
> > So this will make compilation break on 32-bit x86 as it does not define
> > clean_cache_range(). Do we somewhere force we are on x86_64 when pmem is
> > enabled?
> 
> Yes, this is enforced by:
> 
>     select ARCH_HAS_PMEM_API if X86_64
> 
> ...in arch/x86/Kconfig. We fallback to a dummy arch_wb_cache_pmem()
> implementation and emit this warning for !ARCH_HAS_PMEM_API archs:
> 
>     "nd_pmem namespace0.0: unable to guarantee persistence of writes"

Aha, right. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
