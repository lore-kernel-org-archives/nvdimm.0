Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6D29CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 20:33:01 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e160070802fc87f5a5385.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:7080:2fc8:7f5a:5385])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D9DDB1EC052C;
	Thu, 30 Sep 2021 22:32:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633033979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=hLWVLOhBKjYZYuNUvu06Jmj0eX6tMAbfkWFKw74wvzY=;
	b=YcZtwTCb5ImI4rq8m0EeDINYqXjmBpRX27C9rIvlGBXIrvTt9dFwNZjd7Cn4W8MncdkCpX
	6iQJ1L+GnZThMTqrQn/krChrmbi7/1rzMQ54OhQ242XqrCw7VSXrY0W8ju1nmgwPe5hGbL
	0cMOkBFbPEdDlZYuAxc3t2Rg5yQq2s8=
Date: Thu, 30 Sep 2021 22:32:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVYe9xrXiwF3IqB2@zn.tnic>
References: <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic>
 <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic>
 <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>

On Thu, Sep 30, 2021 at 08:15:51PM +0000, Luck, Tony wrote:
> That may now be a confusing name for the page flag bit. Until the
> pmem/storage use case we just simply lost the whole page (back
> then set_mce_nospec() didn't take an argument, it just marked the
> whole page as "not present" in the kernel 1:1 map).
> 
> So the meaning of HWPoison has subtly changed from "this whole
> page is poisoned" to "there is some poison in some/all[1] of this page"

Is that that PMEM driver case Dan is talking about: "the owner of that
page, PMEM driver, knows how to navigate around that poison to maximize
data recovery flows."?

IOW, even if the page is marked as poison, in the PMEM case the driver
can access those sub-page ranges to salvage data? And in the "normal"
case, we only deal with whole pages anyway because memory_failure()
will mark the whole page as poison and nothing will be able to access
sub-page ranges there to salvage data?

Closer?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
