Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421303FC9
	for <nvdimm@lists.linux.dev>; Sat,  2 Oct 2021 10:17:06 +0000 (UTC)
Received: from zn.tnic (p200300ec2f1da300fd384e36289cf098.dip0.t-ipconnect.de [IPv6:2003:ec:2f1d:a300:fd38:4e36:289c:f098])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 625101EC0608;
	Sat,  2 Oct 2021 12:17:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633169824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=U5swqrM58d+ksRq5QB2mxFpSgXQzWwDCi9QtvHCzYTI=;
	b=Ira+/LKxt19MytpLI4eiMY7ycxSXN8fVqhIB3r1QSRw98S8oTE5+VAC06QxS/sNlgpwKm5
	SAQslVw87qYaunhWg4/nxkSUhXS002X6fkFl/J7mWmLzSAZ0hP9IASycJS3EvAwuVlOjSi
	2KB9lKCAbyW999AQs9fZ6XaBX1OD+80=
Date: Sat, 2 Oct 2021 12:17:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVgxnPWX2xCcbv19@zn.tnic>
References: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic>
 <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic>
 <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic>
 <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>

On Fri, Oct 01, 2021 at 11:29:43AM -0700, Dan Williams wrote:
> My read is that the guest gets virtual #MC on an access to that page.
> When the guest tries to do set_memory_uc() and instructs cpa_flush()
> to do clean caches that results in taking another fault / exception
> perhaps because the VMM unmapped the page from the guest? If the guest
> had flipped the page to NP then cpa_flush() says "oh, no caching
> change, skip the clflush() loop".

... and the CLFLUSH is the insn which caused the second MCE because it
"appeared that the guest was accessing the bad page."

Uuf, that could be. Nasty.

> Yeah, I thought UC would make the PMEM driver's life easier, but if it
> has to contend with an NP case at all, might as well make it handle
> that case all the time.
> 
> Safe to say this patch of mine is woefully insufficient and I need to
> go look at how to make the guarantees needed by the PMEM driver so it
> can handle NP and set up alias maps.
> 
> This was a useful discussion.

Oh yeah, thanks for taking the time!

> It proves that my commit:
> 
> 284ce4011ba6 x86/memory_failure: Introduce {set, clear}_mce_nospec()
> 
> ...was broken from the outset.

Well, the problem with hw errors is that it is always very hard to test
the code. But I hear injection works now soo... :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
