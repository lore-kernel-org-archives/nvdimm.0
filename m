Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150F3FC5
	for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 11:30:25 +0000 (UTC)
Received: from zn.tnic (p200300ec2f127e008eb9261aa740485d.dip0.t-ipconnect.de [IPv6:2003:ec:2f12:7e00:8eb9:261a:a740:485d])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BB38B1EC04D1;
	Fri, 17 Sep 2021 13:30:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1631878219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=kz340oLLW1OXGW+dC8d0wzplbyr1JWHig//GGVFPcLE=;
	b=Gg1vcytG7SXBKNOqPvo5s4llzQV7UJ2AZd1Vt6tk5p67I4Xmdx1mH+95zSLTqtI1cRph1C
	pFx43uiw3qwTq0XCztK/+B6bLKAM3csDXqsPkWQ5AV66/06lQjgwRcmYghsxRelMO2fEUs
	s2NJiD6nq8ramvSdAU9pZxeneVzW2vM=
Date: Fri, 17 Sep 2021 13:30:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>,
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YUR8RTx9blI2ezvQ@zn.tnic>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>

On Thu, Sep 16, 2021 at 01:33:42PM -0700, Dan Williams wrote:
> I am specifically talking about the memory_failure_dev_pagemap() path
> taken from memory_failure().
> 
> > But then I have no clue what the "DAX-memory_failure()" path is.
> 
> Sorry, I should not have lazily used {PMEM,DAX} memory_failure() to
> refer to the exact routine in question: memory_failure_dev_pagemap().
> That path is taken when memory_failure() sees that a pfn was mapped by
> memremap_pages(). It determines that the pfn does not represent a
> dynamic page allocator page and may refer to a static page of storage
> from a device like /dev/pmem, or /dev/dax.

Aaaha, that's that innocent-looking pfn_to_online_page() call there in
memory_failure() which would return NULL for pmem/dax pages.

> The zeroing of the poison comes optionally later if userspace
> explicitly asks for it to be cleared.

I see.

> Yes. The device driver avoids reconsumption of the same error by
> recording the error in a "badblocks" structure (block/badblocks.c).
> The driver consults its badblocks instance on every subsequent access
> and preemptively returns EIO. The driver registers for machine-check
> notifications and translates those events into badblocks entries. So,
> repeat consumption is avoided unless/until the babblocks entry can be
> cleared along with the poison itself.

Sounds good.

> I'll note that going forward the filesystem wants to be more involved
> in tracking and managing these errors so the driver will grow the
> ability to forward those notifications up the stack.

... which would save the ask-the-driver each time thing. Yap.

> It does. In addition to machine-check synchronous notification of
> poison, there are asynchronous scanning mechanisms that prepopulate
> the badblocks entries to get ahead of consumption events.

Probably something similar to patrol scrubbing on normal DRAM.

> ... Because the entire page is dead there is no need for UC because all
> the cachelines are gone, nothing to read-around in this page. In short
> DRAM and PMEM want to share the exact same policy here and use NP for
> whole_page() and UC for not. Just the small matter of ignoring the
> memtype by using _set_memory_uc().

Hmm, so looking at this more:

        else
                rc = set_memory_uc(decoy_addr, 1);

->  memtype_reserve(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,

->  memtype_reserve(__pa(addr), __pa(addr) + 1,

Looking at

  17fae1294ad9 ("x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned")

it says

    Fix is to check the scope of the poison by checking the MCi_MISC register.
    If the entire page is affected, then unmap the page. If only part of the
    page is affected, then mark the page as uncacheable.

so I guess for normal DRAM we still want to map the page uncacheable so
that other parts except that cacheline can still be read.

And PMEM should be excluded from that treatise here because it needs to
be WB, as you said earlier.

Right?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
