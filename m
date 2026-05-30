Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DF2385D96
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 07:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780124835; cv=none; b=rYhcf+CGjXcs2nN2mlnpEWm1maP3jNI27zALWCrjI0lXcuH7GF1F8M59QS2MKpO9v+GPjjGxL2XO+TcfC5+7njBzXD+PVCvJUWgOK4HqvGeO+XNfcqr3EZqW6dbBZA8etjFrbarWvH785vwivPaNSEnuOXuPtPkEFABH50cqU5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780124835; c=relaxed/simple;
	bh=F91dfvq8Wah1bzf6BIEHBl3HSgTsKB9AizK2g94hAhc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NLddr2KP4R3tP6JZZSYA6WVEEkX4sU7jxuIUcI53LXn1qnj/x0HSMbGibVCCuUZnbDi2mJBmdKQ/PuCZoBALk1Kljglskqg2exg2xS9nHqxwAJn/HVns74lupwYt/FFeAHigpsyhPMdCRmA5hDqvXtXxT+nH7+ng6lfhV6bldZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKejsAX0; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKejsAX0"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3045c195251so8680742eec.1
        for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780124833; x=1780729633; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Om8vzyQy0h1ms6+E4uwwkVPBBpvGc4QDtMw8QpW1Ahc=;
        b=JKejsAX0QUjmedC1AOn8TMxno8ye+PuXhWm9EHZLyOmsdTz9Esi+XJUNHObSZAEGPQ
         uyZoU5kk803YqHstA3B6FkBxMWtcJ/VQjDujU2LRhOX0E0APW7Zzm0I0QqmUO8zonjp3
         RupWhoz9nWbLsF1lyj+68heNsK87hygvTtTohcajrjmiBzUziKgpUXHUQiYEl3nLzfpT
         lSMW8iZXjPkEZvU0OyDe2+egqpRh/Jz9cXJhTgbI1Wxna8czu7R0mgWPNJ+uxrs2SEtm
         YJdDEZuDSGBBAe5s7wTA4cxgaW9EmXWoQqfvFYefeKLK3iPYhTOllhBSOt+oCLI2B4UL
         3jCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780124833; x=1780729633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Om8vzyQy0h1ms6+E4uwwkVPBBpvGc4QDtMw8QpW1Ahc=;
        b=Wzld427lq4NlDG7nfphyJXARjFEIqHeNPHeFh+0lAMAp1FW31sWgOfUukrA/ATo0ZJ
         1BK9EnqB42loGnEWwwyQjRZHyurwdpq/t+cmd48BiE1uzlHf8U0sDAntKM/ab2h4afPM
         m1KsJp2M0A8YRFg5h/OVvaaggudQRkdo2HzDEtvAz1J940Yq4uqvSsuWjoKMGVDZUffT
         zYG5Nv8Lb716MsG9OSMUI83hiHGaW1ae5/O6joQmNkJGk33sFao+AsrdfcZKKL5Us21L
         Pbc9dQGk2lm3yxNtliRuLJk/AMGSjXqxRNt3If0E5pTCGXC/aNoR8TU505Xnqe8ScPyL
         K9/A==
X-Forwarded-Encrypted: i=1; AFNElJ+nqqzxHYc5Y15L2Qmd5MhFvSLX/K0icR65ryPXmfKli3h18hCqmN1vmtPeCrZeUypYaVmEOME=@lists.linux.dev
X-Gm-Message-State: AOJu0YwqPIyTiWYNTf2zSPl44g4cXpxvhIinD2dqfY9cldMRh6IPOMeE
	TvHCU9beVgPWboZQVVGKpNNd1DNTuWmL6OSqFPMsaSBesZ7Bssxd5wfi
X-Gm-Gg: Acq92OFefBCoLJcBXrevWGaNxQACWlNcUWDxYminM9TXXvgddxzWTWIo8ZbWX3IItgA
	ix0ZYY61gL2687q5dfoFgaprRO+DOoIR9RTtD+fjIltoFyKjNAU+1ei4+OrOLlx8Q569vJwm/Z9
	4FaKutRl+xICdtbhr5CR7llBNlCU3LX9KGcmeWhOLfhY+Io6G6y58lIBk8eDpAgnl/VlIVDtQAE
	bqXvtu3zCQ3cIQjUB5gcTyTp1ckc0ZuUrEuhA9+J8TulMK0Fp/rTosiUWCVErdOLUxQhOIew0be
	Auh695Hsjp9p8U/PvS6iUJNZhFuUZ95V6Yy6py/d1oZkWjxqXknVEdpX4t2TQ34XA2DgUCEvNlf
	QZLxZFfDmywBsDkFbrNBunIS3tkAEyJztEO3DQ5S96x3GKjR4849UbaX8DbMAGrc25QzKgXAb+x
	hme7r2ur9kfZXU1TEAjIImKmDmRfR2KAjMj4/Zb/GpvXH9Zf0y1qIQHJyyreQJdgAD/M3k8TPl+
	fkKnP4zMn3WDzf/gg==
X-Received: by 2002:a05:7300:6da3:b0:304:3c33:7ad6 with SMTP id 5a478bee46e88-304fa4c7c30mr1461412eec.11.1780124833070;
        Sat, 30 May 2026 00:07:13 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed2c3121sm3461204eec.5.2026.05.30.00.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 00:07:12 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Sat, 30 May 2026 00:07:11 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 06/31] cxl/port: Add 'dynamic_ram_a' to endpoint
 decoder mode
Message-ID: <ahqMnx5sTWj96-y3@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <58e5e5007cd11e0b8e65016f126144f187badb39.1779528761.git.anisa.su@samsung.com>
 <e504359a-ff13-4ad1-a74c-337ede7f11c6@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e504359a-ff13-4ad1-a74c-337ede7f11c6@intel.com>

On Wed, May 27, 2026 at 05:01:44PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Endpoints can now support a single dynamic ram partition following the
> > persistent memory partition.
> > 
> > Expand the mode to allow a decoder to point to the first dynamic ram
> > partition.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> Need Anisa sign off
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> Just update kver and dates below.
> 
Updated!

Thanks,
Anisa
> > 
> > ---
> > Changes:
> > [anisa: rebase]
> > ---
> >  Documentation/ABI/testing/sysfs-bus-cxl | 18 +++++++++---------
> >  drivers/cxl/core/port.c                 |  4 ++++
> >  2 files changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> > index 3d95c325f6e0..c604c7ca6432 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-cxl
> > +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> > @@ -358,22 +358,22 @@ Description:
> >  
> >  
> >  What:		/sys/bus/cxl/devices/decoderX.Y/mode
> > -Date:		May, 2022
> > -KernelVersion:	v6.0
> > +Date:		May, 2022, May 2025
> 
> A later date
> 
> > +KernelVersion:	v6.0, v6.16 (dynamic_ram_a)
> 
> 7.3 maybe?
> 
> DJ
> 
> >  Contact:	linux-cxl@vger.kernel.org
> >  Description:
> >  		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
> >  		translates from a host physical address range, to a device
> >  		local address range. Device-local address ranges are further
> > -		split into a 'ram' (volatile memory) range and 'pmem'
> > -		(persistent memory) range. The 'mode' attribute emits one of
> > -		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
> > -		not actively decoding, or no DPA allocation policy has been
> > -		set.
> > +		split into a 'ram' (volatile memory) range, 'pmem' (persistent
> > +		memory), and 'dynamic_ram_a' (first Dynamic RAM) range. The
> > +		'mode' attribute emits one of 'ram', 'pmem', 'dynamic_ram_a' or
> > +		'none'. The 'none' indicates the decoder is not actively
> > +		decoding, or no DPA allocation policy has been set.
> >  
> >  		'mode' can be written, when the decoder is in the 'disabled'
> > -		state, with either 'ram' or 'pmem' to set the boundaries for the
> > -		next allocation.
> > +		state, with either 'ram', 'pmem', or 'dynamic_ram_a' to set the
> > +		boundaries for the next allocation.
> >  
> >  
> >  What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index 0c5957d1d329..a7f71f36531f 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -128,6 +128,7 @@ static DEVICE_ATTR_RO(name)
> >  
> >  CXL_DECODER_FLAG_ATTR(cap_pmem, CXL_DECODER_F_PMEM);
> >  CXL_DECODER_FLAG_ATTR(cap_ram, CXL_DECODER_F_RAM);
> > +CXL_DECODER_FLAG_ATTR(cap_dynamic_ram_a, CXL_DECODER_F_RAM);
> >  CXL_DECODER_FLAG_ATTR(cap_type2, CXL_DECODER_F_TYPE2);
> >  CXL_DECODER_FLAG_ATTR(cap_type3, CXL_DECODER_F_TYPE3);
> >  CXL_DECODER_FLAG_ATTR(locked, CXL_DECODER_F_LOCK);
> > @@ -222,6 +223,8 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
> >  		mode = CXL_PARTMODE_PMEM;
> >  	else if (sysfs_streq(buf, "ram"))
> >  		mode = CXL_PARTMODE_RAM;
> > +	else if (sysfs_streq(buf, "dynamic_ram_a"))
> > +		mode = CXL_PARTMODE_DYNAMIC_RAM_A;
> >  	else
> >  		return -EINVAL;
> >  
> > @@ -327,6 +330,7 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
> >  static struct attribute *cxl_decoder_root_attrs[] = {
> >  	&dev_attr_cap_pmem.attr,
> >  	&dev_attr_cap_ram.attr,
> > +	&dev_attr_cap_dynamic_ram_a.attr,
> >  	&dev_attr_cap_type2.attr,
> >  	&dev_attr_cap_type3.attr,
> >  	&dev_attr_target_list.attr,
> 
