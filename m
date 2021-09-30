Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160FD2FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 20:08:38 +0000 (UTC)
Received: from zn.tnic (p200300ec2f0e160042ff9e72dd33ffc9.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1600:42ff:9e72:dd33:ffc9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 898D31EC052C;
	Thu, 30 Sep 2021 22:01:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1633032082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=/H3hg7AzGfujtQgVIBkOcZv2WAmL76IGNbhMpOyIHxs=;
	b=SrlXAiy/U2H/uWjvleOZnXk6GHHqQqKeaC5PS4SRH/X/it+bwdoVgcPE0x4s+hMZ610jdR
	XXUr+PsHE6Z1aGV7CJGwfshuyRRSeW3pKQr++eK108g4mLZ3DcAVXqyjTIKu6IbyTxh2bo
	PCXTIho7HYV4/SqvN9gn4HwSwndT0q8=
Date: Thu, 30 Sep 2021 22:01:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
Message-ID: <YVYXjoP0n1VTzCV7@zn.tnic>
References: <YT8n+ae3lBQjqoDs@zn.tnic>
 <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
 <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
 <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic>
 <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic>
 <33502a16719f42aa9664c569de4533df@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <33502a16719f42aa9664c569de4533df@intel.com>

On Thu, Sep 30, 2021 at 07:44:48PM +0000, Luck, Tony wrote:
> See the comment above set_mce_nospec() ...
> 
> /*
>  * Prevent speculative access to the page by either unmapping
>  * it (if we do not require access to any part of the page) or
>  * marking it uncacheable (if we want to try to retrieve data
>  * from non-poisoned lines in the page).
>  */
> static inline int set_mce_nospec(unsigned long pfn, bool unmap)

I've seen that comment - I've quoted it upthread...

> It's a choice as to whether the whole page is gone or not. The history for
> this is using pmem as storage. The filesystem block size may be less than
> the page size. An error in a "block" should only result in that block disappearing
> from the file, not the surrounding 4k.

So let me cut to the chase:

        if (!memory_failure(..))
                set_mce_nospec(pfn, whole_page...);

when memory_failure() returns 0, is a whole page marked as hwpoison or
not?

Because I see there close to the top of the function:

	if (TestSetPageHWPoison(p)) {
		...

after this, that whole page is hwpoison I'd say. Not a cacheline but the
whole thing.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
