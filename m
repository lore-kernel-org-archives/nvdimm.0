Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6A29CA
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 18:11:43 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e8e00070d8da89f0d865a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:8e00:70d:8da8:9f0d:865a])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 492411EC05D4;
	Fri,  1 Oct 2021 20:11:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633111901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=h6kS6sTKBKpGpAysZkGDRiWC9LpHn2il+ocOOQp21+M=;
	b=EmZA4nr3praQIZT91UGJZQnz1n9TNcVyql1lMlA9GcdK9t8iBJiBS+GENx6gBUaEsE8K1R
	LTsGSvw9EwZJek5/3GGJ/SaojDVvhV+/RxcZ86Gw7VN/tw5kr1oleHP69iMwm23Rj7OycM
	oqYgKyyGo8JJ+p+wWwTw6jVaP8koBsg=
Date: Fri, 1 Oct 2021 20:11:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVdPWcggek5ykbft@zn.tnic>
References: <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
 <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic>
 <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>

On Fri, Oct 01, 2021 at 09:52:21AM -0700, Dan Williams wrote:
> I think that puts us back in the situation that Tony fixed in:
> 
> 17fae1294ad9 x86/{mce,mm}: Unmap the entire page if the whole page is
> affected and poisoned
> 
> ...where the clflush in _set_memory_uc() causes more unwanted virtual
> #MC injection.

Hmm, lemme read that commit message again: so the guest kernel sees a
*second* MCE while doing set_memory_uc().

So what prevents the guest kernel from seeing a second MCE when it does
set_memory_np() instead?

"Further investigation showed that the VMM had passed in another machine
check because is appeared that the guest was accessing the bad page."

but then the beginning of the commit message says:

"The VMM unmapped the bad page from guest physical space and passed the
machine check to the guest."

so I'm really confused here what actually happens. Did the VMM manage to
unmap it or not really? Because if the VMM had unmapped it, then how was
the guest still accessing the bad page? ... Maybe I'm reading that wrong.

> I think that means that we have no choice but to mark the page NP
> unconditionally and do the work to ensure that the driver has updated
> its poisoned cacheline tracking for data recovery requests.

So a couple of emails earlier I had this:

|Well, the driver has special knowledge so *actually* it could go and use
|the NP marking as "this page has been poisoned" and mark it NC only for
|itself, so that it gets the job done. Dunno if that would end up being
|too ugly to live and turn into a layering violation or so.

So if we have marked the page NP, then nothing would be able to access
it anymore and it will be marked as hwpoison additionally, which will
prevent that access too.

Then, the PMEM driver would go and map the page however it wants to, it
could even remove it from the direct map so that nothing else accesses
it, even in the kernel, and then do all kinds of recovery.

Hmm?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
