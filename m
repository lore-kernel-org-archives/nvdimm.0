Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE67E2FAE
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 10:50:07 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e8e0006425ffdb1062ac0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:642:5ffd:b106:2ac0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 00B621EC05BB;
	Fri,  1 Oct 2021 12:50:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633085406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Fa5/YHzYhW52c3YQw/tIykXLtItNPDQZwrKlf9nDxLw=;
	b=PUInDgC6XF9Vu16fDfgya7m7BShimyZxhHzc5nDUyoZNqGnhG9P/WGyRbtk8+x7z70Z8nK
	u3z1vaN/8C7+yIhKl0g8xxSBPSxq6m/Rhaeet2Lec7Fvs0LRD6ZBbonhmok9dwAOH/SEDS
	VChAoHQ2lJKMg0eqNPnWtipBzFt7SAs=
Date: Fri, 1 Oct 2021 12:50:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVbn3ohRhYkTNdEK@zn.tnic>
References: <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
 <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>

On Thu, Sep 30, 2021 at 07:02:13PM -0700, Dan Williams wrote:
> If I understand the proposal correctly Boris is basically saying
> "figure out how to do your special PMEM stuff in the driver directly
> and make it so MCE code has no knowledge of the PMEM case".

I don't mind if it has to because of a good reason X - I'm just trying
to simplify things and not do stuff which is practically unnecessary.

> The flow
> is:
> 
> memory_failure(pfn, flags)
> nfit_handle_mce(...) <--- right now this on mce notifier chain
> set_mce_nospec(pfn) <--- drop the "whole page" concept
> 
> This poses a problem because not all memory_failure() paths trigger
> set_mce_nospec() or the mce notifier chain.

Hmm, so this sounds like more is needed than this small patch.

> If that disconnect happens, attempts to read PMEM pages that have been
> signalled to memory_failure() will now crash in the driver without
> workarounds for NP pages.
>
> So memory_failure() needs to ensure that it communicates with the
> driver before any possible NP page attribute changes. I.e. the driver
> needs to know that regardless of how many cachelines are poisoned the
> entire page is always unmapped in the direct map.

Ok, so those errors do get reported through MCE so MCE code does need to
know about them.

So the question is, how should MCE mark them so that the driver can deal
with them properly.

> Then, when the driver is called with the new RWF_RECOVER_DATA flag, it
> can set up a new UC alias mapping for the pfn and access the good data
> in the page while being careful to read around the poisoned cache
> lines.

See my other mail - that sounds good.

> In my mind this moves the RWF_RECOVER_DATA flag proposal from "nice to
> have" to "critical for properly coordinating with memory_failure() and
> mce expectations"

Right, so to reiterate: I don't mind if the MCE code knows about this -
in the end of the day, it is that code which does the error reporting.
My goal is to make that reporting and marking optimal so that the driver
can work with that marking and simplify and document *why* we're doing
that so that future MCE changes can keep that in mind.

So to sum up: it sounds to me like it should simply mark *whole* pages
as NC:

1. this should prevent the spec. access for DRAM.
2. PMEM can do UC alias mapping and do sub-page access to salvage data.

How's that?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
