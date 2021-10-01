Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6702FAE
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 10:41:53 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e8e0006425ffdb1062ac0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:642:5ffd:b106:2ac0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0299C1EC05B9;
	Fri,  1 Oct 2021 12:41:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633084912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=dcikHcyXe/7/TSUAI8MjQnT4P3eZBZCNDHyq0whYCPc=;
	b=SijhU3onBhoAgrH/ZXUI/iAZaYh8bPDNU+nWpovHgf39EVR8g2FghMIAahWdpNLYEYKdxt
	3udk0UbaNhWx82cR2gWmEZqdBOnNlmgRAj8XnOCAAwvg6KybMe6u2HCxSBDgWNU8iIz+KI
	Zh+cIN4Pj5LuoU+wZ/7auJ6wz7fiJG8=
Date: Fri, 1 Oct 2021 12:41:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVbl6wkUvbk8vsn7@zn.tnic>
References: <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
 <CAPcyv4jV_8JCNSXg9W3ZNDhZEd=z2QyLWPgLUiVN92rp7zWReA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4jV_8JCNSXg9W3ZNDhZEd=z2QyLWPgLUiVN92rp7zWReA@mail.gmail.com>

On Thu, Sep 30, 2021 at 03:44:40PM -0700, Dan Williams wrote:
> The driver uses the direct-map to do the access. It uses the
> direct-map because it has also arranged for pfn_to_page() to work for
> PMEM pages. So if PMEM is in the direct-map is marked NP then the
> sub-page accesses will fault.

Well, the driver has special knowledge so *actually* it could go and use
the NP marking as "this page has been poisoned" and mark it NC only for
itself, so that it gets the job done. Dunno if that would end up being
too ugly to live and turn into a layering violation or so.

Or we can mark the page NC - that should stop the speculative access for
DRAM and the PMEM driver can do its job. The NC should take care so that
no cachelines are in the cache hierarchy.

> Now, the driver could set up and tear down page tables for the pfn
> whenever it is asked to do I/O over a potentially poisoned pfn. Is
> that what you are suggesting? It seems like a significant amount of
> overhead, but it would at least kick this question out of the purview
> of the MCE code.

Yeah, I'm looking for the simplest solution first which satisfies
everyone. Let's keep that one on the bag for now...

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
