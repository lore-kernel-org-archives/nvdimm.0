Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19576233722
	for <nvdimm@lists.linux.dev>; Sun, 21 Jun 2026 10:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782037444; cv=none; b=Hu1AjXNl3hyg9wqdTxBU5SaJ240LNUSMv7t24n+NBOgFb5GE/5PCLV3GRzr8jHtRgJebVSYEFer/Aj3LLPSZo6yhf393LtzD/6ER40Y/ntWpq/zUQvtRY+95cRJqWJu0WbEIL4ng1tzbc+XNnzFiCAlfo4a0RZxf9BcjMfkvRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782037444; c=relaxed/simple;
	bh=ywfWqiioRSMVXSoicXy7pHEdlVNNT3ATJpOSLq5TwFc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gX6XEf5iLBudoIk43NKm4A1jc3+rD6Ab2rGHp6jDn/Ped72IxheTEsNdvP4dZamGRQaZFxXdaOl5pjAD0PTaB4I5AobmajdMkb5SOCuRhV4OoG/BJnxZ5BRjCuifBVwehC/sQJt5fUC8n5I44z9Dr5jlPKhQcewn2y19Ld9gJUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bbzqN4Fa; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbzqN4Fa"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490b613a17bso27157985e9.3
        for <nvdimm@lists.linux.dev>; Sun, 21 Jun 2026 03:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782037441; x=1782642241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YArF8gKOdruQVzdzXc/NwPAF4gYYVy3RGU/L1AprjhI=;
        b=bbzqN4FaywxD0+Zqv6HMYD26qx3XatDBhDMYu7dxOYDFte9c/px3IuWOc+4qARg5lH
         0/mUNiZnKvDz6+MrBsjye1exJX0R2z/pTaKIRoVnObIXns1PB/jPOE90/lh/f1uzNR1Y
         Gkny6Wmkhuhdnkz0K2O3h3lwQZrBpmt8INY+Y0WwfwcRc6TNh+f25Lzrw8SnHI+Ujb7h
         PsqSd5A9Y6eo2RlIRC+EXHC9POyfNfP91mB6xj3BDlGsSoLexkjV7f2FitwWXRnbNydA
         VpmfwTjZ6OWAv3UHrOIC/I6Br2ZFJ9AOO00P5ZXWzhJaZGp3JYr6ZJDtnFh06twaXs5U
         +Iyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782037441; x=1782642241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YArF8gKOdruQVzdzXc/NwPAF4gYYVy3RGU/L1AprjhI=;
        b=V6sRKx+5kB/fFnWa8V/qEkdw6ZOdedFpTL1zhN877q9IA9Y9iZtPBAVstkgpNcw7iL
         onNWnPORvK2fsRA5+eujPyCAnYN204IOj9xV7h7wb8Ry8kqduv9FxD0fXesVCb4tLrek
         unp7ecSJfFZtsT1Jtwep/BAy10rTjOmI7DNGlysVM7cZ60wznDTbboSRyPPqPgwUZaKK
         MRjin2vWsjJHxoUfWD8UIo7kxdGy7yPfzl6SHlW5br9LHG5wL6dpPovbTa8wlV/jBXEQ
         3ffIv/pelHussIOLbW/hqBresDTYbmjGJ58lVain1kXUxrChFktYDvgFho/xg8z3YK+o
         0uQg==
X-Forwarded-Encrypted: i=1; AFNElJ8JKSoOwqvR7R6dalFXf99SrCRutgl42ihxIsmJ0wow5i/EG5yf3mdX4nw9hloNVglo1pMKgnA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+ZtNvXp9nmzT6MF0Zyo0ApK4e8JcN7LCCHVMJE7qomkD7mSvc
	nbX1j2vIJ4ov5W6PwGGAFjWeV2vKQ8428zT63APmUUARqdKqF1+HGPNf
X-Gm-Gg: AfdE7ckT2z1hLpEM6YjH1fjJ3BPyKxrP3XeUQp0K19RRKdMUVMGzzLHnIcahQRCDw+s
	qi8f4FZ7+p9kxc6AIWpvPfXnCzEDGGhaAEK9WTyp/t5YXoHIU9SvQXTQpoZr6vH+UbW9fAEZpnh
	ivXwo+a2TvwE7vrOs+GprfeAPJsCXJ1NyT+CAcW139NSqy4XiogBQsRFoLjKng1wzM9nr5ad5y4
	FNlITquTJ/IpmrN/OhsDkibAdS90D4Arkyf8EaeqmLhJu8ujw7TBp+X/lLLGUQwrA06edPVsEym
	ZNnbWPgaddDSbBa3OHUfNjCUOO3sozRntInmbOrK76HlBJ+13pc4YcCeYocTrTIsWx4JARyIhfq
	WrEnWPrSKJ2xrY0QvcCoCms+flR/b6s3Y1ByqpKzaTf3jgXeX6O5VbGLaIcC3cA0uqzrHut2Fk5
	zgD2c6x4fvxzex4aaQZfFlwVh5u6R3iMZ+mFImCUC0OSJmUH+LVA==
X-Received: by 2002:a05:600c:6288:b0:490:e18f:d108 with SMTP id 5b1f17b1804b1-492490a7778mr84446065e9.19.1782037441272;
        Sun, 21 Jun 2026 03:24:01 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49245a69f81sm168379525e9.1.2026.06.21.03.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 03:24:00 -0700 (PDT)
Date: Sun, 21 Jun 2026 11:23:57 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: hexlabsecurity@proton.me, Dave Jiang <dave.jiang@intel.com>, Dan
 Williams <djbw@kernel.org>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
 <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev
Subject: Re: [PATCH] libnvdimm/labels: Prevent integer overflow in
 __nd_label_validate()
Message-ID: <20260621112357.56a290bc@pumpkin>
In-Reply-To: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me>
References: <20260620-b4-disp-7f43b155-v1-1-0cfd8017f7a0@proton.me>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 20 Jun 2026 15:54:39 -0500
Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org> wrote:

> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> The on-media namespace index field nslot is a u32 read from the DIMM
> label storage area.  __nd_label_validate() bounds it against the config
> area size, but sizeof_namespace_label() returns unsigned, so the product
> nslot * label_size is evaluated in 32-bit and wraps modulo 2^32 before
> the comparison.  A crafted nslot passes the bound and is then used as the
> loop trip count in nd_label_data_init(), whose memset() walks off the end
> of the config_size buffer: an out-of-bounds write.
> 
> The field is not trusted -- it comes from the medium, or from userspace
> via ND_CMD_SET_CONFIG_DATA.  Evaluate the product in 64-bit so the bound
> check is exact; conforming labels are unaffected.

Is this enough and/or a sane way to stop the overflow.
AFAICT label_size is either 128 or 258.
But I can't see where nsarea.config_size is set.
If it comes from a user ioctl there should be some associated sanity limits.
The same could be done for nslot - any value above 64k is pretty much
guaranteed to be garbage - I'd bet valid values are actually very small
integers.

	David

> 
> Fixes: 564e871aa66f ("libnvdimm, label: add v1.2 nvdimm label definitions")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
> ---
> The check was safe when introduced: 4a826c83db4e ("libnvdimm: namespace
> indices: read and validate") multiplied by sizeof(struct
> nd_namespace_label), a size_t, so the product was 64-bit.  564e871aa66f
> replaced that with sizeof_namespace_label(), which returns unsigned, when
> the label size became a runtime value -- narrowing the product to 32 bits.
> 
> The sibling multiply in sizeof_namespace_index() uses an nslot derived
> from config_size (nvdimm_num_label_slots()), not the on-media field, so it
> cannot overflow and is left unchanged.
> 
> Reproduced with an out-of-tree module that mirrors nd_label_data_init() --
> kvzalloc(config_size), the __nd_label_validate() bound check, and the
> memset loop -- since the defect is the wrapped arithmetic into the memset,
> not the DIMM-probe plumbing:
> 
> Build A (without this patch), nslot = 0x02000000, 128-byte labels:
>     the u32 product wraps to 0, the index is accepted, and the loop's
>     memset() writes past the kvzalloc'd buffer ->
>       right of the config_size region -> panic.
>   Build B (with this patch): the 64-bit product exceeds config_size, the
>     index is rejected, the loop never runs -> clean.
>   Control (legitimate small nslot): writes stay in bounds -> clean.
> 
> BUG: KASAN: slab-out-of-bounds, Write of size 128, 0 bytes to the
> ---
>  drivers/nvdimm/label.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 4218e3ac4a2a..ec12ce72cfe2 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -202,7 +202,7 @@ static int __nd_label_validate(struct nvdimm_drvdata *ndd)
>  		}
>  
>  		nslot = __le32_to_cpu(nsindex[i]->nslot);
> -		if (nslot * sizeof_namespace_label(ndd)
> +		if ((u64)nslot * sizeof_namespace_label(ndd)
>  				+ 2 * sizeof_namespace_index(ndd)
>  				> ndd->nsarea.config_size) {  
>  			dev_dbg(dev, "nsindex%d nslot: %u invalid, config_size: %#x\n",
> 
> ---
> base-commit: 8e65320d91cdc3b241d4b94855c88459b91abf66
> change-id: 20260620-b4-disp-7f43b155-92b84c904c08
> 
> Best regards,

