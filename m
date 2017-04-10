Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 94BA121A04802
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 15:48:07 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: [PATCH v2] x86, pmem: fix broken __copy_user_nocache cache-bypass
 assumptions
Date: Mon, 10 Apr 2017 22:47:02 +0000
Message-ID: <CS1PR84MB0294132B3BE2597C54A8778382010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
References: <149161025237.38725.13508986873214668503.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CS1PR84MB029453C33D46D4049E1B0F0982010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4hJcj-iJpRd2hvTCmCwyMjWgqpiEjGv1migquZ4PQH_8w@mail.gmail.com>
 <CS1PR84MB029468AEA8FE98ED315B51DB82010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4gO0NWRLs0_A7L+2pX+v0ohoYRSgvtw_VXmBesgOnQyUw@mail.gmail.com>
 <CS1PR84MB029438D4A6A2B49E2023ACEE82010@CS1PR84MB0294.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jjMAc94KNrwzWnkJ9z34bvyYN65HY7UyTEnVKVyozKHA@mail.gmail.com>
In-Reply-To: <CAPcyv4jjMAc94KNrwzWnkJ9z34bvyYN65HY7UyTEnVKVyozKHA@mail.gmail.com>
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

> >> > The clflush here flushes for the cacheline size.  So, we do not need to
> flush
> >> > the same cacheline again when the unaligned tail is in the same line.
> >>
> >> Ok, makes sense. Last question, can't we reduce the check to be:
> >>
> >>         if ((bytes > flushed) && ((bytes - flushed) & 3))
> >>
> >> ...since if 'bytes' was 4-byte aligned we would have performed
> >> non-temporal stores.
> >
> > That is not documented behavior of copy_user_nocache, but as long as the
> pmem
> > version of copy_user_nocache follows the same implemented behavior, yes,
> that
> > works.
> 
> Hmm, sorry this comment confuses me, I'm only referring to the current
> version of __copy_user_nocache not the new pmem version. The way I
> read the current code we only ever jump to the cached copy loop
> (.L_1b_cache_copy_loop) if the trailing byte-count is 4-byte
> misaligned.

Yes, you are right and that's how the code is implemented.  I added this trailing
4-byte handling for the >=8B case, which is shared with <8B case, since it was 
easy to do.  But I considered it a bonus.  This function also needs to handle 
4B-aligned destination if it is to state that it handles 4B alignment for the >=8B
case as well.   Otherwise, it's inconsistent.  Since I did not see much point of supporting
such case, I simply documented in the Note that 8 byte alignment is required for
the >=8B case.

Thanks,
-Toshi
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
