Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FDF2C81
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 14:25:11 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1637850309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TFMMjS5RkT+RI71yue1n3IxbBtVRj0GIoMvASrmcer0=;
	b=0/Y16YWJSS1Jp545yUC26yH6psBLPlGA34T7HX1kciK8drwSXp4FmTpWEMA+SwSqhmFpUZ
	L+qVpr2EHNBvtOV1QjNY1HkrFka4JYHIZMdrut/I0gGa6xZpSK2X3H8yJFKkl0hcSqnGxz
	1wtUOgcAMdwWPwUgKLjKmXvWD6QMnFAu5Wh6Uy3wag7Wxi4Zg4OKM6BbhBvedZyNNPbMin
	xc4bdy4lpSqK+QfwRBw3f0e0kVGabMNSrEZ5LOTAp7zrZ0yNkh7oiJNfYIL0y/bKpBsPCh
	zZxEV89Fu2AXzrIJFuAjpkhxAHvlSRW4yjcjn9vwHEM8gSn1R9oR20ijXwL3VQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1637850309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TFMMjS5RkT+RI71yue1n3IxbBtVRj0GIoMvASrmcer0=;
	b=j43w1IbkalIhzPTD2Fm6ml+1jb7PtzC55CNrQUfRnYUjgRJeL4L2Z76VAwjBm/vW75OJcx
	fphBSfpB9qW7jICQ==
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, Dan
 Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Fenghua Yu <fenghua.yu@intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH V7 03/18] x86/pks: Add additional PKEY helper macros
In-Reply-To: <20210804043231.2655537-4-ira.weiny@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-4-ira.weiny@intel.com>
Date: Thu, 25 Nov 2021 15:25:09 +0100
Message-ID: <87lf1cl3cq.ffs@tglx>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
> @@ -200,16 +200,14 @@ __setup("init_pkru=", setup_init_pkru);
>   */
>  u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
>  {
> -	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
> -
>  	/*  Mask out old bit values */
> -	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
> +	pk_reg &= ~PKR_PKEY_MASK(pkey);
>  
>  	/*  Or in new values */
>  	if (flags & PKEY_DISABLE_ACCESS)
> -		pk_reg |= PKR_AD_BIT << pkey_shift;
> +		pk_reg |= PKR_AD_KEY(pkey);
>  	if (flags & PKEY_DISABLE_WRITE)
> -		pk_reg |= PKR_WD_BIT << pkey_shift;
> +		pk_reg |= PKR_WD_KEY(pkey);

I'm not seeing how this is improving that code. Quite the contrary.

Thanks,

        tglx
