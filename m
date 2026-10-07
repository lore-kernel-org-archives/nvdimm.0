Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A53D9DD6
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 21:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791408322; cv=none; b=e/X3L6xeD7l72TVqaSi8Thn+pbXY81sahZUwTmg//lZLPJkOLhNwkKU8wcSOCQSXMSKteCs7APvM3y2Ov2wDQwWFMLlTzjtHUAE/JjGGBzL4jdLyr1bs404L+20/fuJSSjb6lkTlKScBXpOvJ6nYiDchyQ0JEYXzE1M7icwv3Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791408322; c=relaxed/simple;
	bh=SXwEfB0YrpC+Z0z4zEHdjXlvVK90EgkZyDvExIl9Ajk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FUYeTP4NLksVVJ6/A5J6j0ohtYxoRfdO+sft1zExgxN+vdOPIQsLMzUXzg+2uF3w9sfERmmGxar7lyaRw34bBH5qwzlpMAJYggtMBXW+br4aeOMBnkvPxRKcvNPsx8OsUqA+Jp144xO4TCsuDp8muedM5cLClK5wA04LK7hw3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVsxStXS; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVsxStXS"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cbee846deecso3269211a12.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 14:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791408320; x=1792013120; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TLc7Zcf3JAoMm0kGaKtX3+RBEoj68Ac29TOBrDveylo=;
        b=HVsxStXSZ18cabRVw5Qdj7Gf6JlGHhLm1eoA5I+RiyBd7iZbt4HUhyp/vAY3I+mrke
         mJySgcgVvsyhHQ0eeJ6xuXuQ7KmhBkYjjQqJXFgR8JdgsRn1S7StcJ9QFVTrUPr1mdyy
         2YcIQiAHRDcOLNyNsPP4JFa9JK8V+xvPH6kbKumS+W5vGbWZK7496uj9svhAR1iWBg20
         MirU53CMGC46MMK6z+6nbFhQuIfBIxhWg3AaIMFKIjSc3BtDXpQRrnfMIChkVMLjoBJC
         6E8pYG2ZoeDzpji0d4gUXHO2Mjo2kjCu2Sj9Yz/SsAx0AbUvBrNrqPVY+6rDe+lHUHJq
         GZAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791408320; x=1792013120;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TLc7Zcf3JAoMm0kGaKtX3+RBEoj68Ac29TOBrDveylo=;
        b=oEl8ZJWiV3L2Ff5gS1UOVknAhL0NabWtYK52WUofb60afnmOvLdV5kAZpi4kQUrCqE
         HojZSPiXkOu1zo72bAREMBBmJ9twUgXMwcdT1ZhUroPZDIjW8Z5TxwAVADWJHaIY7gYb
         JZojYuCeotQnJv9ROOFnHibdI+20w1OZYVrR4aK9qY63Z8LkfRz3YdWoLsRqRIlPfmwa
         Fjr4/o61Wa5Sqt+mATU4Bb4rtGWRfhQ6Xc8DNj5WbDCKWk8bXbH1Uhb7P4wyau8xuoWS
         zbZ5XpwgfmvdBoO8cM/8Ug+OVU1TVyek5IkbB/kKsOkslOyzQDNm1klmdW9NZRxG+ZIQ
         GTFw==
X-Forwarded-Encrypted: i=1; AKwUvBymwYOlycJRNYmy1KWZuySMd3l/nv7saAkNpba079WkVwGWut0JCXjyhFpQqsKdqIy8e9zeNsw=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ7Y9Rm0/3y4cNTkmtpPpN/FSUBwRxNW4pEXtbKZ+j4lALpxApY
	Lwh6a0m0Ja3puE/NX781wANoxEXsvLEieN5z3jWMofq1kw59JhYA57OU/ILPMw==
X-Gm-Gg: AYBFou3ozhL+lsuuonD7GSSs7MYrriuXEu9jKGdox4w/7DztVV+TaLes/52MAqdWnmU
	8bI/fS82b8Cif3+1EtOD0zvLm/6cgGaHqySD+1hQPeg1ioScX923oLiA6WqCuUgKhkxLepoEOnw
	PQRPYP8vQztMOBt3NBY1U1sC5hPxM1czWsx9jMzwplWS5oglYmZ8wyceW05kXKpDHuGENT2iQ7V
	b1p8ZPhC+lOEvYECpgmYMqBsgYvHtUy0ZVOuRUgY0zcW4CtQth+WYmDMdPQo/8a0oPal0uFCAuG
	tI+blyTPawuNlFVR/0O99tQfZKjbdETmPfFVqyORdoc9PbCEXYJJPZGi2iAsCgDz5Yn/P0c+PKi
	mqzuQB+CHT3f0wYygXVlBrK4or8APW/KcwOR7Xj6t0N29tqtWEWHODVuXIZpt2ENFrxFFTbgNd2
	vmcghLCH1qcqBZwzjLvLTer8gygn79e2TGUufMNfPf29l6V50/KqzPj31PN3VSdMSaROmluFr9H
	LVW+E0jqaXtJc7dS9kn+vaBuC59hmdn/94H3ReIeWQJHwYMTLOuf0v7BRnDUBFJAoQ5YBXJbIvd
	TK3D4eDm3W8soKChR5Z7fnn5
X-Received: by 2002:a17:90b:48c7:b0:398:b1eb:136c with SMTP id 98e67ed59e1d1-3a8a04ba071mr2767269a91.9.1791408320344;
        Wed, 07 Oct 2026 14:25:20 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1a7e9e4sm1196231a91.7.2026.10.07.14.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:25:19 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 7 Oct 2026 14:25:18 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <asa4vh2RaQyoVorj@4470NRD-ASU.ssi.samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-3-anisa.su@samsung.com>
 <sashiko-outbox-163339@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-163339@kernel.org>

On Wed, Oct 07, 2026 at 08:29:34PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] cxl: cxl_configure_dcd() falsely fails overlap check and double-counts total DPA capacity

False Positive
> --
> 
> commit e491a6175f0241ed507a397807a28860fd54aadf
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/mem: Read dynamic capacity configuration from the device
> 
> This commit implements Dynamic Capacity (DC) mailbox commands to read and
> store DCD configuration information. It validates the first dynamic capacity
> partition and configures it as dynamic ram, disabling DCD if the
> configuration is invalid.
> 
> > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > index b3419df586b9c..def26c490dfe4 100644
> > --- a/drivers/cxl/core/memdev.c
> > +++ b/drivers/cxl/core/memdev.c
> [ ... ]
> > @@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
> >  
> > +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > +{
> [ ... ]
> > +	if (dc_info.start < info->size) {
> > +		dev_err(dev,
> > +			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
> > +			dc_info.start, info->size);
> > +		return -EINVAL;
> > +	}
> 
> [Severity: High]
> Will this overlap check unconditionally fail for any valid DCD configuration?
> 
> Earlier in the execution flow, cxl_mem_dpa_fetch() initializes info->size to
> the total DPA capacity (including both static and dynamic capacity):
> 
info->size does not include dynamic capacity.

>     info->size = mds->total_bytes;
> 
> Since the DC partition is placed within this total space, dc_info.start will
> always be strictly less than the total info->size. This appears to cause a
> regression where cxl_pci_probe() silently disables DCD support.
> 
> [ ... ]
> > +	if (check_add_overflow(info->size, dc_info.size, &total)) {
> > +		dev_err(dev,
> > +			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
> > +			dc_info.size, info->size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	info->size = total;
> 
> [Severity: High]
> If the above overlap check were bypassed, would this assignment double-count
> the dynamic capacity size?
> 
> Since info->size already includes the dynamic capacity initialized from

info->size does not include dynamic capacity.

> cxl_mem_dpa_fetch(), adding dc_info.size again to the total could cause
> cxl_dpa_setup() to allocate a dpa_res root resource larger than the physical
> device limit.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261007201828.952-1-anisa.su@samsung.com?part=2
