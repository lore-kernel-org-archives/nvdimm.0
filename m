Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575E3FD6
	for <nvdimm@lists.linux.dev>; Mon, 13 Sep 2021 10:29:32 +0000 (UTC)
Received: from zn.tnic (p200300ec2f097300647bc1aeefdcee9f.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:7300:647b:c1ae:efdc:ee9f])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A9341EC0372;
	Mon, 13 Sep 2021 12:29:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1631528960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=IVIUZjL5dpInfeT4UHJ2BlG9ZIvelznW5/5tsIcMzEY=;
	b=Z9cYssIV96NSTCYklKwDw1ZTBAvDiSdiVJ37N30F7xAa/JaxtRnZ5TQQg6zHwfWkO4UNbt
	K31K3xe3mFSy2PwlmRg5KVQq4rXFIeh++6neo/pvu5Mme+fxx2xqPicvXxvYn891GBzkOv
	by8UbXWgBsOdqFTxSsoq10mycakcJ24=
Date: Mon, 13 Sep 2021 12:29:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev, Jane Chu <jane.chu@oracle.com>,
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YT8n+ae3lBQjqoDs@zn.tnic>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>

On Tue, Jul 06, 2021 at 06:01:05PM -0700, Dan Williams wrote:
> When poison is discovered and triggers memory_failure() the physical
> page is unmapped from all process address space. However, it is not
> unmapped from kernel address space. Unlike a typical memory page that
> can be retired from use in the page allocator and marked 'not present',
> pmem needs to remain accessible given it can not be physically remapped
> or retired.

I'm surely missing something obvious but why does it need to remain
accessible? Spell it out please.

> set_memory_uc() tries to maintain consistent nominal memtype
> mappings for a given pfn, but memory_failure() is an exceptional
> condition.

That's not clear to me too. So looking at the failure:

[10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types 1850600000-1850601000  uncached-minus<->write-back

set_memory_uc() marked it UC- but something? wants it to be WB. Why?

I guess I need some more info on the whole memory offlining for pmem and
why that should be done differently than with normal memory.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
