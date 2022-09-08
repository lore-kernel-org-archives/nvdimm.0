Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FC77C
	for <nvdimm@lists.linux.dev>; Thu,  8 Sep 2022 04:35:08 +0000 (UTC)
Received: from nazgul.tnic (unknown [84.201.196.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 555AE1EC0662;
	Thu,  8 Sep 2022 06:35:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1662611702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=yj0XiI5SAxZERNji8RCiam0EWrxhSX89yYeXkz7KJQA=;
	b=RHRF14JX2l4NKBH/yE9kk9zL5oVZILZ6zAdSSHwupFCSqyUtLh0x/fO0dHc+ZLCzuRhK5a
	uLq5fV4wL5E5aXmVC8K4wfSFPz4kqH3KKq3WM34LYZceSB5o5OZs0MElX+U4NRBL+eJd3b
	1YPYUH/yp2cWRLMRRkEtLHC+ZbfPx8s=
Date: Thu, 8 Sep 2022 06:35:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, x86@kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	peterz@infradead.org, akpm@linux-foundation.org,
	dave.jiang@intel.com, Jonathan.Cameron@huawei.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] memregion: Add arch_flush_memregion() interface
Message-ID: <YxlxAFgW65w8wgPy@nazgul.tnic>
References: <20220829212918.4039240-1-dave@stgolabs.net>
 <YxjBSxtoav7PQVei@nazgul.tnic>
 <20220907162245.5ddexpmibjbanrho@offworld>
 <6318cc415161f_166f2941e@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6318cc415161f_166f2941e@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Sep 07, 2022 at 09:52:17AM -0700, Dan Williams wrote:
> To be clear nfit stuff and CXL does run in guests, but they do not
> support secure-erase in a guest.
> 
> However, the QEMU CXL enabling is building the ability to do *guest
> physical* address space management, but in that case the driver can be
> paravirtualized to realize that it is not managing host-physical address
> space and does not need to flush caches. That will need some indicator
> to differentiate virtual CXL memory expanders from assigned devices.

Sounds to me like that check should be improved later to ask
whether the kernel is managing host-physical address space, maybe
arch_flush_memregion() should check whether the address it is supposed
to flush is host-physical and exit early if not...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
