Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F9772
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 17:19:49 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e16001aa756a0ef3ae707.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:1aa7:56a0:ef3a:e707])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 124B61EC01CE;
	Thu, 30 Sep 2021 19:19:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633022387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=Zkfkj32ENfICBB5SZAF5w7uIcqys+GbxWBgIdY6cLEI=;
	b=oyq+fb0HfRBL6oT57Qfrb++ruumf1duv7igEVkAWEvpj+KRCz9ui8zD2FhppymFCyNc8KM
	7zMQI2ckWTbHUs4M+f/lnvmTVP5D/64WbTBAiOwMQPQgWEN6b7Z2zkbDj2lFVaiSdKAWIg
	gHTsDEKotzF1sT34izg81PZNPSvFw30=
Date: Thu, 30 Sep 2021 19:19:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dan Williams <dan.j.williams@intel.com>,
	Tony Luck <tony.luck@intel.com>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>,
	Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVXxr3e3shdFqOox@zn.tnic>
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>

On Mon, Sep 20, 2021 at 07:04:50PM -0700, Dan Williams wrote:
> Yes, although I believe that DRAM patrol scrubbing is being done from
> the host memory controller, these PMEM DIMMs have firmware and DMA
> engines *in the DIMM* to do this scrub work.

Oh great. Lemme guess, they even have small OSes inside ... <eyeroll>

> Perhaps, but I don't know how you do that if memory_failure() has
> "offlined" the DRAM page, in the case of PMEM you can issue a
> byte-aligned direct-I/O access to the exact storage locations around
> the poisoned cachelines.

Well, looking at the exactly two call sites of set_mce_nospec(), it
does:

	if (!memory_failure(..))
		set_mce_nospec(pfn, whole_page...);

so IINM, if that thing returns 0, then we have hwpoisoned the page. And
if that is the case, then why are we even diddling with reads around the
poisoned cacheline when the whole page has been poisoned and we can't
access it anymore?

Or am I missing something?

Because the comment over set_mce_nospec() says

"or marking it uncacheable (if we want to try to retrieve data from
non-poisoned lines in the page)."

Question is, can we even access a hwpoisoned page to retrieve that data
or are we completely in the wrong weeds here? Tony?

> PMEM can still go NP if the entire page is failed, so no need to
> exclude PMEM from the treatise because the driver's badblocks
> implementation will cover the NP page, and the driver can use
> clear_mce_nospec() to recover the WB mapping / access after the poison
> has been cleared.

Now I'm all confused again. ;-(

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
