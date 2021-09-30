Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853529CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 20:54:14 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e160070802fc87f5a5385.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:7080:2fc8:7f5a:5385])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1186A1EC051F;
	Thu, 30 Sep 2021 22:54:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633035252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=zA33qU6baIC2yz5YZOXb8z1I70t6eBI0PjHQ0KVyVVw=;
	b=IYz5ttivfdO/42agwoxRRco2m71h4zOd+62hJeZveCP+vT6KsrLYljDM1JaSrfQW4FAyqp
	0vMCYJPsOJJG4pEZqoPWMYkGDlBQLq/tIlqWUyuRVfnfMc/iSv9zSVuS3gLt+AstJGqZxa
	fnApTZKkPCdH23lqxsAN6SkvNFLQYjs=
Date: Thu, 30 Sep 2021 22:54:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVYj8PpzIIo1qu1U@zn.tnic>
References: <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic>
 <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>

On Thu, Sep 30, 2021 at 01:39:03PM -0700, Dan Williams wrote:
> Yes, that's a good way to think about it. The only way to avoid poison
> for page allocator pages is to just ditch the page. In the case of
> PMEM the driver can do this fine grained dance because it gets precise
> sub-page poison lists to consult and implements a non-mmap path to
> access the page contents.

Ok, good.

Now, before we do anything further here, I'd like for this very much
non-obvious situation to be documented in detail so that we know what's
going on there and what that whole_page notion even means. Because this
is at least bending the meaning of page states like poison and what that
really means for the underlying thing - PMEM or general purpose DIMMs.

And then that test could be something like:

	/*
	 * Normal DRAM gets poisoned as a whole page, yadda yadda...
	 /
	if (whole_page) {

	/*
	 * Special handling for PMEM case, driver can handle accessing sub-page ranges
	 * even if the whole "page" is poisoned, blabla
	} else {
		rc = _set_memory_uc(decoy_addr, 1);
	...

so that it is crystal clear what's going on there.

Thx!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
