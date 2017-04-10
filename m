Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1F1921A04802
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 14:28:54 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: [PATCH v2] x86, pmem: fix broken __copy_user_nocache cache-bypass
 assumptions
Date: Mon, 10 Apr 2017 21:28:40 +0000
Message-ID: <CS1PR84MB029468AEA8FE98ED315B51DB82010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
References: <149161025237.38725.13508986873214668503.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CS1PR84MB029453C33D46D4049E1B0F0982010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4hJcj-iJpRd2hvTCmCwyMjWgqpiEjGv1migquZ4PQH_8w@mail.gmail.com>
In-Reply-To: <CAPcyv4hJcj-iJpRd2hvTCmCwyMjWgqpiEjGv1migquZ4PQH_8w@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> > Thanks for the update.  I think the alignment check should be based on
> > the following note in copy_user_nocache.
> >
> >  * Note: Cached memory copy is used when destination or size is not
> >  * naturally aligned. That is:
> >  *  - Require 8-byte alignment when size is 8 bytes or larger.
> >  *  - Require 4-byte alignment when size is 4 bytes.
> >
> > So, I think the code may be something like this.  I also made the following
> changes:
> 
> Thanks!
> 
> >  - Mask with 7, not 8.
> 
> Yes, good catch.
> 
> >  - ALIGN with cacheline size, instead of 8.
> >  - Add (bytes > flushed) test since calculation with unsigned long still results
> in a negative
> >    value (as a positive value).
> >
> >         if (bytes < 8) {
> >                 if ((dest & 3) || (bytes != 4))
> >                         arch_wb_cache_pmem(addr, 1);
> >         } else {
> >                 if (dest & 7) {
> >                         dest = ALIGN(dest, boot_cpu_data.x86_clflush_size);
> 
> Why align the destination to the next cacheline? As far as I can see
> the ALIGN_DESTINATION macro in arch/x86/include/asm/asm.h only aligns
> to the next 8-byte boundary.

The clflush here flushes for the cacheline size.  So, we do not need to flush
the same cacheline again when the unaligned tail is in the same line.

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
