Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969D2C80
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 16:58:05 +0000 (UTC)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1637859483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WOKypu9+YuWWJOAfm6+J+ei1DcpdTnJhN0LbMq3CSG0=;
	b=vzJLcT7uiJpS9vreHdlK/D2976quDuf9ti4wYxxqLNMj0h2wetfIAt5Zf+5DUpe/zUpWF1
	NdcwlJFBRbknKy/FagWVQ+LA+h1M1QOrhCRpSrmIQsl0A9J9h9s3q+TSCz4Gm+q2zzRtDX
	tGLQq0xK/BENKSMb2770BKX1FMCV3EuJvQoymF+FVRQnyynJypPiiz11/MKAzZIervk1/6
	0yJLhEa9/CUWWMOXQ5WGX2gXor75vjWY79lRQaEaGUBcOW7+OyU69SrUi3vpXaA2tOjdVP
	hD2BHdX66V7Ogyg1B6Wy6eENRlW8/zxmCxDkQgPWLy3HYbOQAsgU8m52jk2Pxw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1637859483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WOKypu9+YuWWJOAfm6+J+ei1DcpdTnJhN0LbMq3CSG0=;
	b=RzQUjc8ysGU6e5x/jPEHv9T7bdnrbH5ffoiBIQ0jhjIfpPpoaA4PLwyjc1ZzcY9ADpL6mj
	yF3FqyOv487lLODQ==
To: ira.weiny@intel.com, Dave Hansen <dave.hansen@linux.intel.com>, Dan
 Williams <dan.j.williams@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
 Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Fenghua Yu <fenghua.yu@intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH V7 03/18] x86/pks: Add additional PKEY helper macros
In-Reply-To: <87lf1cl3cq.ffs@tglx>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
 <20210804043231.2655537-4-ira.weiny@intel.com> <87lf1cl3cq.ffs@tglx>
Date: Thu, 25 Nov 2021 17:58:02 +0100
Message-ID: <87czmokw9x.ffs@tglx>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Nov 25 2021 at 15:25, Thomas Gleixner wrote:
> On Tue, Aug 03 2021 at 21:32, ira weiny wrote:
>> @@ -200,16 +200,14 @@ __setup("init_pkru=", setup_init_pkru);
>>   */
>>  u32 update_pkey_val(u32 pk_reg, int pkey, unsigned int flags)
>>  {
>> -	int pkey_shift = pkey * PKR_BITS_PER_PKEY;
>> -
>>  	/*  Mask out old bit values */
>> -	pk_reg &= ~(((1 << PKR_BITS_PER_PKEY) - 1) << pkey_shift);
>> +	pk_reg &= ~PKR_PKEY_MASK(pkey);
>>  
>>  	/*  Or in new values */
>>  	if (flags & PKEY_DISABLE_ACCESS)
>> -		pk_reg |= PKR_AD_BIT << pkey_shift;
>> +		pk_reg |= PKR_AD_KEY(pkey);
>>  	if (flags & PKEY_DISABLE_WRITE)
>> -		pk_reg |= PKR_WD_BIT << pkey_shift;
>> +		pk_reg |= PKR_WD_KEY(pkey);
>
> I'm not seeing how this is improving that code. Quite the contrary.

Aside of that why are you ordering it the wrong way around, i.e.

   1) implement turd
   2) polish turd

instead of implementing the required helpers first if they are really
providing value.

Thanks,

        tglx


