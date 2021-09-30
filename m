Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A8572
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 22:35:51 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e1600eca2e39a4f74093f.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:eca2:e39a:4f74:93f])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0EE781EC051F;
	Fri,  1 Oct 2021 00:35:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633041349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=FVYXq+G0q9o7GgWZLm/59AlEsy5qhCGuD0vOzupBVVk=;
	b=ismL1kSYpgX00E7kQDUQdcMyQdMF5NKSWJAiGO55CNkM696oeJReYu/lG5paY+IgS61bZX
	r3SLBlH1w5WfXWHhgEbe9ZoFwXSleJd1M+75MANN5swXZossDmnopD9oOVmbGz1uMn1H0r
	QHaJhWrOF78trxcgWXmkAUdjD2nxTvA=
Date: Fri, 1 Oct 2021 00:35:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVY7wY/mhMiRLATk@zn.tnic>
References: <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
 <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
 <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>

On Thu, Sep 30, 2021 at 02:41:52PM -0700, Dan Williams wrote:
> I fail to see the point of that extra plumbing when MSi_MISC
> indicating "whole_page", or not is sufficient. What am I missing?

I think you're looking at it from the wrong side... (or it is too late
here, but we'll see). Forget how a memory type can be mapped but think
about how the recovery action looks like.

- DRAM: when a DRAM page is poisoned, it is only poisoned as a whole
page by memory_failure(). whole_page is always true here, no matter what
the hardware says because we don't and cannot do any sub-page recovery
actions. So it doesn't matter how we map it, UC, NP... I suggested NP
because the page is practically not present if you want to access it
because mm won't allow it...

- PMEM: reportedly, we can do sub-page recovery here so PMEM should be
mapped in the way it is better for the recovery action to work.

In both cases, the recovery action should control how the memory type is
mapped.

Now, you say we cannot know the memory type when the error gets
reported.

And I say: for simplicity's sake, we simply go and work with whole
pages. Always. That is the case anyway for DRAM.

For PMEM, AFAIU, it doesn't matter whether it is a whole page or not -
the PMEM driver knows how to do those sub-pages accesses.

IOW, set_mce_nospec() should simply do:

	rc = set_memory_np(decoy_addr, 1);

and that's it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
