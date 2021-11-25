Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB12C81
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 14:23:28 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1637850207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQ2bCdqH2OWTnCq9dRGfDttoaw3mgzWgtaks8W3QzoU=;
	b=X5rGMH9fGLL72+i0bcqpoKBfob/pBENUReyPjsje2kn1dCJQ2QnYXpMZ2TjkO/MRY2hzOd
	0z3nOx+AYEnyl2QN4Ae9Ces48L4E2DTpz0e6ijDQJzeA4vtYWsylVYol9uYomr5HWkEw+p
	POi9tobxDMSQNHyI31/yWwDM9v8JIQsAwhlFXKPIBrz7j4Ezm3llb3BsASUJcy2UVsAxb0
	FOCx04UMK3DF1yPAyV0Uv1YMixvtCGiXTFAj/mMK1yDZy2vrtnScsXO/9zx4KAjrW/9v/U
	mdwAO2gxHeMy1mP7DZ/iQqVvtHVibtOLEOKGAte1U7z0/vnQumxrl35KVQnD+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1637850207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eQ2bCdqH2OWTnCq9dRGfDttoaw3mgzWgtaks8W3QzoU=;
	b=Tor0usITTklzqMNh1fcPJSwNhqrJHtMWH+Cg6TRO9PKK1xsYCuf1+kbYFQ/sbez5V01JPS
	cjWRZZKeujPOJjBg==
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, Dan
 Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy
 Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Fenghua Yu
 <fenghua.yu@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-mm@kvack.org
Subject: Re: [PATCH V7 02/18] x86/fpu: Refactor arch_set_user_pkey_access()
In-Reply-To: <20210804043231.2655537-3-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-3-ira.weiny@intel.com>
Date: Thu, 25 Nov 2021 15:23:26 +0100
Message-ID: <87o868l3fl.ffs@tglx>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
> +/*
> + * Replace disable bits for @pkey with values from @flags
> + *
> + * Kernel users use the same flags as user space:
> + *     PKEY_DISABLE_ACCESS
> + *     PKEY_DISABLE_WRITE
> + */
> +u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)

pkey_.... please.

> +{
> +	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
> +
> +	/*  Mask out old bit values */
> +	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
> +
> +	/*  Or in new values */
> +	if (flags & PKEY_DISABLE_ACCESS)
> +		pk_reg |= PKR_AD_BIT << pkey_shift;
> +	if (flags & PKEY_DISABLE_WRITE)
> +		pk_reg |= PKR_WD_BIT << pkey_shift;
> +
> +	return pk_reg;

Also this code is silly.

#define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)

u32 pkey_update_pkval(u32 pkval, int pkey, u32 accessbits)
{
	int shift = pkey * PKR_BITS_PER_PKEY;

        if (WARN_ON_ONCE(accessbits & ~PKEY_ACCESS_MASK))
        	accessbits &= PKEY_ACCESS_MASK;

        pkval &= ~(PKEY_ACCESS_MASK << shift);
	return pkval | accessbit << pkey_shift;
}

See? It does not even need comments because it's self explaining and
uses sensible argument names matching the function name.


