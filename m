Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AECD2F80
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 21:20:43 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e160070802fc87f5a5385.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:7080:2fc8:7f5a:5385])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6990C1EC0409;
	Thu, 30 Sep 2021 23:20:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633036841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=4U+Nx+u5xKPdH+xKY+PBFOIUbnGn79epKHaIPOJMOgg=;
	b=VvMf5teIC/v3won5VO/kDSfdJq/liSIP54KdypscP84HyIb5BjaGZUI2cQJ7LgmH/jz2HW
	Liwyx+z4cPevoMekOnUs4tlCFlyK+jmi1MOl22QKnwT1Aw3rZFOYDAutGZNLYn1seiJtZ/
	Ho4DeTM/7TDnMop90bs6N12iWnlXCGY=
Date: Thu, 30 Sep 2021 23:20:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVYqJZhBiTMXezZJ@zn.tnic>
References: <YVXxr3e3shdFqOox@zn.tnic>
 <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>

On Thu, Sep 30, 2021 at 02:05:49PM -0700, Dan Williams wrote:
> I.e. it's fine

A lot of things are fine - question is, what makes sense and what makes
this thing as simple as required to be.

> if a DRAM page with a single cacheline error only gets marked UC.
> Speculation is disabled and the page allocator will still throw it
> away and never use it again.

Normal DRAM is poisoned as a whole page, as we established. So whatever
it is marked with - UC or NP - it probably doesn't matter. But since
the page won't be ever used, then that page is practically not present.
So I say, let's mark normal DRAM pages which have been poisoned as not
present and be done with it. Period.

> Similarly NP is fine for PMEM when the machine-check-registers
> indicate that the entire page is full of poison. The driver will
> record that and block any attempt to recover any data in that page.

So this is still kinda weird. We will mark it with either NP or UC but
the driver has some special knowledge how to tiptoe around poison. So
for simplicity, let's mark it with whatever fits best and be done with
it - driver can handle it just fine.

I hope you're cathing my drift: it doesn't really matter what's possible
wrt marking - it matters what the practical side of the whole thing
is wrt further page handling and recovery action. And we should do
here whatever does not impede that further page handling even if other
markings are possible.

Ok?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
