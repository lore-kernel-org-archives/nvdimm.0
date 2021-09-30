Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21862FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 19:30:17 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e160042ff9e72dd33ffc9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:42ff:9e72:dd33:ffc9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1A34D1EC052C;
	Thu, 30 Sep 2021 21:30:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633030210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=f9Ivu15luncVYePLJ3FeECT/5aS35jZsM3dpXzvlkO8=;
	b=XIZDI/86Vd4gBc8Gv8ctZl39VRDjaQ6hz4gHqR10+5B2CigNaLlZgTy1T3Whrlj3Fku9V7
	1YI4l/vfOSFrWxm2HASUTSR9PSX0+rYKKrhgO0M3L6KnHDfMjGC5DELzHkr6dc8AQpFHbr
	fHpKWO8tA2irC3BRLI/4L5BEQRy7Hr8=
Date: Thu, 30 Sep 2021 21:30:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVYQPtQrlKFCXPyd@zn.tnic>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic>
 <3b3266266835447aa668a244ae4e1baf@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3b3266266835447aa668a244ae4e1baf@intel.com>

On Thu, Sep 30, 2021 at 05:28:12PM +0000, Luck, Tony wrote:
> > Question is, can we even access a hwpoisoned page to retrieve that data
> > or are we completely in the wrong weeds here? Tony?
> 
> Hardware scope for poison is a cache line (64 bytes for DDR, may be larger
> for the internals of 3D-Xpoint memory).

I don't mean from the hw aspect but from the OS one: my simple thinking
is, *if* a page is marked as HW poison, any further mapping or accessing
of the page frame is prevented by the mm code.

So you can't access *any* bits there so why do we even bother with whole
or not whole page? Page is gone...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
