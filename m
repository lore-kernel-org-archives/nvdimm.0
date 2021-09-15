Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01643FC9
	for <nvdimm@lists.linux.dev>; Wed, 15 Sep 2021 10:41:43 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0d07000c3d48728178681f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:700:c3d:4872:8178:681f])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BA85A1EC0493;
	Wed, 15 Sep 2021 12:41:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1631702490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=DMSPVE3ps9SBVtM/8QmBc99ziCix9wq6T05rkqRlJW4=;
	b=eedSt5JXkJwiAqtVkdnbeORCH24XdU8o45HedKr509AsMkDZK3mIUFX3WwcKvsnIx9WImn
	rpfxAJ/EeVtmjiokN/Y5+85X8iPmJRykyg/YbmpnZq4LDPsV5DDvr8tWucNUAoy7l/dQKt
	JQQhJJrTntVQh6BoCOWcdKG0KoIAAA4=
Date: Wed, 15 Sep 2021 12:41:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>,
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YUHN1DqsgApckZ/R@zn.tnic>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>

On Tue, Sep 14, 2021 at 11:08:00AM -0700, Dan Williams wrote:
> Sure, I should probably include this following note in all patches
> touching the DAX-memory_failure() path, because it is a frequently
> asked question. The tl;dr is:
> 
> Typical memory_failure() does not assume the physical page can be
> recovered and put back into circulation, PMEM memory_failure() allows
> for recovery of the page.

Hmm, I think by "PMEM memory_failure()" you mean what pmem_do_write()
does with that poison clearing or?

But then I have no clue what the "DAX-memory_failure()" path is.

> The longer description is:
> Typical memory_failure() for anonymous, or page-cache pages, has the
> flexibility to invalidate bad pages and trigger any users to request a
> new page from the page allocator to replace the quarantined one. DAX
> removes that flexibility. The page is a handle for a fixed storage
> location, i.e. no mechanism to remap a physical page to a different
> logical address. Software expects to be able to repair an error in
> PMEM by reading around the poisoned cache lines and writing zeros,
> fallocate(...FALLOC_FL_PUNCH_HOLE...), to overwrite poison. The page
> needs to remain accessible to enable recovery.

Aha, so memory failure there is not offlining he 4K page but simply
zeroing the poison. What happens if the same physical location triggers
more read errors, i.e., the underlying hw is going bad? Don't you want
to exclude that location from ever being written again?

Or maybe such recovery action doesn't make sense for pmem?

> Short answer, PMEM never goes "offline" because it was never "online"
> in the first place. Where "online" in this context is specifically
> referring to pfns that are under the watchful eye of the core-mm page
> allocator.

Ok, so pmem wants to be handled differently during memory failure.
Looking at the patch again, you change the !unmap case to do
_set_memory_uc().

That bool unmap thing gets *not* set in whole_page():

	return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;

so I'm guessing that "Recoverable Address LSB (bits 5:0): The lowest
valid recoverable address bit." thing is < 12 for pmem.

But are you really saying that the hardware would never report a lower
than 12 value for normal memory?

If it does, then that is wrong here.

In any case, I'd prefer if the code would do an explicit check somewhere
saying "is this pmem" in order to do that special action only for when
it really is pmem and not rely on it implicitly.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
