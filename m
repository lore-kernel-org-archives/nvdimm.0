Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6A6218592
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 06:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097442; cv=none; b=hoS7xhn+Y22iatZ48mn5whN3SsduLxiiStTyK3b2MeqdIgVn/CcVS0144LAGDf5iyUGe7cJeARsirhY67HeWRyOaRWI85u4O5FP2R/5aej0IUpBZXhJByYESsVzEQJn190GdSFACYWwKy9u4XzBOSff/1TdEHDTkddrXs544qYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097442; c=relaxed/simple;
	bh=9IYPWh7jlJjYRetf9rLy7KHw+ESF6AmIcmvLhtfkusE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohx0oaR0rMqZQhptRIzlHV7wDjoFEGT8ajCqlzm14rY45mlBfUVN+ZrW8ip8iTD3aWWPLgXPZZ87WG06J4zWyyIj6iHMsvKJl+8IDRlZpXSrv4tJlXw1GdCMVwua8JCEimxI3mOR4MsdbwSxpE2mDo45GiAVf7Nt8VoG9SV5SCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6tEoiR+; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6tEoiR+"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceab75934dso45093005ad.2
        for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 23:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784097439; x=1784702239; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DyL2Tyh+t/pX/AeTsP1Bs1IVFQ4a60IkdxMtcs3NiWs=;
        b=N6tEoiR+1bAAxreqFXYYURvNW29fXQ3Tlj6sO3Hn/s4rUYmr8MLiOev30AwmtTR9RW
         9J9MMHlb9ZzGtcW+trwnsZiAQD/eW321KiDm+dOiwFvD4JEv4aCsUpnJ9/LAYMJvMzf/
         prq+tNQpfeqq23caZp5VzPtlzvBu7puvqHTd3dw8y1BYe9esRK0/vs3TMCz6JRNz1cq4
         yeDbCa3MFcs66YGljJJJMpHxoPy4IVjdrRF2M69jYLS0bYJYTYJMzooxw1kEPVntWMcX
         y3OU+/R+M98iHIOTGIzJMYC2+1k8l6pTwsn1SDcPPFrKOvO0WoJ6J39V6vzRPGz6EInt
         jmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784097439; x=1784702239;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DyL2Tyh+t/pX/AeTsP1Bs1IVFQ4a60IkdxMtcs3NiWs=;
        b=e5KLlZuk1UMF/dnxun2q6BLHn4C1omzYmTT1oJHwgEgWmTroTChF7lSjQfIqH2E0b6
         J+27lbOIxEQnDEaIn9f1gJVGbfJn5/EPgTrUCq/WVfJd/bTLobtaK8JakEOOvl052s8Z
         RUOVUGXCmhIe7txusD75SAkjR2CYlzSxeKGMWp68TRmuhL7Dp1/5+AbklWuSt4xGEgc0
         84jnRoJgG1oKJwujwAVvW/goMu7uXqedoNGYgoTtLqXppWkAmz2utntQzYBrdz5pNLh9
         JB6BSwBif95sff5CJBRlyftYeDsp+lTjohP1JRTgLdBIHHJVv4HiQ+YA+LyVg7SHbemW
         ZXDg==
X-Forwarded-Encrypted: i=1; AHgh+RrdvfEhTLZ5FxHtnIuxsM9shfbCZ1NP2EX18j/+YH4EFAIUSFuw4ACBVYl7s4aCzEAMw5gHR+E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdLDRmaHCseqTX8FWD3eU0Hi7EASFUVKMwvOUR93r8P6YPeyc+
	7cSs600e5g8jAaPyjHiX9GLnp9Jb78jT3TqTtZsUbRcTHTaNnKQkiaps
X-Gm-Gg: AfdE7cnk8JC6S+383bs55dORKqN7hbkDb/5+nNUjfLw8WpjbAUtTLvcZnaJ2DFfMsc+
	Q/p6GVdAKB6y91ITgMnJrlIzrEl+OeVo8DV0rO5BiQO+xU9VRyreKGPTTVXrnaV3KEuVi3Qukz5
	YHKZA5tTeCaiJAUdOR204lek5RNbCmn+QvXqCxiVgmpMWO/v3u1wUBYasoX6M85aGmVkPP3zt0I
	5+XFx31boRUogSCo3/qCKRO2mfXQKpEGXeB17hwgplJBKliTX00UkJK8ip7nZxv22z7ta4mhae5
	A9/zTYLm8lBh75gtgkJEY2b3bxkdrbXTneszV+iZOuyNplE1555VO/IjwnPnig6AQDua2pIidca
	oH3SyeHuz784Xp+56Q2Jc9cFiJgQvjjjVnee4nuglZCeVUajLU4vPCRLAu3gW8LNJ3t2aDL2MLh
	BOUhFno8syzzUU8R0xjcJT8eiJS3W6I9z0GbvCH1dZSD8ZS6NuvajbOO6Np9KAN7w7Dr6S
X-Received: by 2002:a17:903:4683:b0:2ca:f8ef:33e4 with SMTP id d9443c01a7336-2cf03cdb2f7mr13224025ad.17.1784097439433;
        Tue, 14 Jul 2026 23:37:19 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb746sm126574145ad.7.2026.07.14.23.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 23:37:19 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 14 Jul 2026 23:37:18 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	djbw@kernel.org, jic23@kernel.org, dave@stgolabs.net,
	vishal.l.verma@intel.com, iweiny@kernel.org,
	alison.schofield@intel.com, gourry@gourry.net
Subject: Re: [PATCH v11 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <alcqnlIGlvDdqEqz@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625180028.965-1-anisa.su@samsung.com>
 <13b2ef5c-778c-4b8e-bb99-be2c86e3cfc8@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13b2ef5c-778c-4b8e-bb99-be2c86e3cfc8@intel.com>

On Fri, Jun 26, 2026 at 03:30:03PM -0700, Dave Jiang wrote:
> 
> 
> On 6/25/26 11:00 AM, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Additional DCD partition (AKA region) information is contained in the
> > DSMAS CDAT tables, including performance, read only, and shareable
> > attributes.
> > 
> > Match DCD partitions with DSMAS tables and store the meta data.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> 
> Maybe a co-developed-by tag since you are making changes with the shareable flag location?
> 
Ok, let me also update the add/release handling to have have that too + john's
co-developed by tag.

> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> > ---
> >  drivers/cxl/core/cdat.c | 12 ++++++++++++
> >  drivers/cxl/core/hdm.c  |  1 +
> >  drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
> >  drivers/cxl/cxlmem.h    |  2 ++
> >  include/cxl/cxl.h       |  4 ++++
> >  5 files changed, 35 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> > index 5c9f07262513..a280039e4cd1 100644
> > --- a/drivers/cxl/core/cdat.c
> > +++ b/drivers/cxl/core/cdat.c
> > @@ -17,6 +17,7 @@ struct dsmas_entry {
> >  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
> >  	int entries;
> >  	int qos_class;
> > +	bool shareable;
> >  };
> >  
> >  static u32 cdat_normalize(u16 entry, u64 base, u8 type)
> > @@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
> >  		return -ENOMEM;
> >  
> >  	dent->handle = dsmas->dsmad_handle;
> > +	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
> >  	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
> >  	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
> >  			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
> > @@ -266,15 +268,25 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
> >  		bool found = false;
> >  
> >  		for (int i = 0; i < cxlds->nr_partitions; i++) {
> > +			enum cxl_partition_mode mode = cxlds->part[i].mode;
> >  			struct resource *res = &cxlds->part[i].res;
> > +			u8 handle = cxlds->part[i].handle;
> >  			struct range range = {
> >  				.start = res->start,
> >  				.end = res->end,
> >  			};
> >  
> >  			if (range_contains(&range, &dent->dpa_range)) {
> > +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
> > +				    dent->handle != handle) {
> > +					dev_warn(dev,
> > +						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> > +						&range, handle, &dent->dpa_range, dent->handle);
> > +					continue;
> > +				}
> >  				update_perf_entry(dev, dent,
> >  						  &cxlds->part[i].perf);
> > +				cxlds->part[i].shareable = dent->shareable;
> >  				found = true;
> >  				break;
> >  			}
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 0ef076c08ed2..7f63b86887f4 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -477,6 +477,7 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
> >  
> >  		cxlds->part[i].perf.qos_class = CXL_QOS_CLASS_INVALID;
> >  		cxlds->part[i].mode = part->mode;
> > +		cxlds->part[i].handle = part->handle;
> >  
> >  		/* Require ordered + contiguous partitions */
> >  		if (i) {
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 2932bbd67e55..bdb908c6e7f3 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1352,10 +1352,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
> >  {
> >  	u64 blk_size = le64_to_cpu(dev_part->block_size);
> >  	u64 len = le64_to_cpu(dev_part->length);
> > +	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
> >  
> >  	part_array[index].start = le64_to_cpu(dev_part->base);
> >  	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> >  	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> > +	if (handle & ~0xFF) {
> > +		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);
> > +		return -EINVAL;
> > +	}
> > +	part_array[index].handle = handle;
> >  
> >  	/* Check partitions are in increasing DPA order */
> >  	if (index > 0) {
> > @@ -1522,6 +1528,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> >  	/* Return 1st partition */
> >  	dc_info->start = partitions[0].start;
> >  	dc_info->size = partitions[0].size;
> > +	dc_info->handle = partitions[0].handle;
> >  	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> >  		dc_info->start, dc_info->size);
> >  
> > @@ -1529,7 +1536,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> >  
> > -static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> > +static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
> > +		     enum cxl_partition_mode mode, u8 handle)
> >  {
> >  	int i = info->nr_partitions;
> >  
> > @@ -1541,6 +1549,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
> >  		.end = start + size - 1,
> >  	};
> >  	info->part[i].mode = mode;
> > +	info->part[i].handle = handle;
> >  	info->nr_partitions++;
> >  }
> >  
> > @@ -1558,9 +1567,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  	info->size = mds->total_bytes;
> >  
> >  	if (mds->partition_align_bytes == 0) {
> > -		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM);
> > +		add_part(info, 0, mds->volatile_only_bytes, CXL_PARTMODE_RAM, 0);
> >  		add_part(info, mds->volatile_only_bytes,
> > -			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM);
> > +			 mds->persistent_only_bytes, CXL_PARTMODE_PMEM, 0);
> >  		return 0;
> >  	}
> >  
> > @@ -1570,9 +1579,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  		return rc;
> >  	}
> >  
> > -	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM);
> > +	add_part(info, 0, mds->active_volatile_bytes, CXL_PARTMODE_RAM, 0);
> >  	add_part(info, mds->active_volatile_bytes, mds->active_persistent_bytes,
> > -		 CXL_PARTMODE_PMEM);
> > +		 CXL_PARTMODE_PMEM, 0);
> >  
> >  	return 0;
> >  }
> > @@ -1624,7 +1633,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> >  	info->size += dc_info.size;
> >  	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> >  		dc_info.start, dc_info.size);
> > -	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1,
> > +		 dc_info.handle);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> >  
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 6b548a1ec1e9..b29fb16725b4 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -118,6 +118,7 @@ struct cxl_dpa_info {
> >  	struct cxl_dpa_part_info {
> >  		struct range range;
> >  		enum cxl_partition_mode mode;
> > +		u8 handle;
> >  	} part[CXL_NR_PARTITIONS_MAX];
> >  	int nr_partitions;
> >  };
> > @@ -823,6 +824,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> >  struct cxl_dc_partition_info {
> >  	u64 start;
> >  	u64 size;
> > +	u8 handle;
> >  };
> >  
> >  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index e8a0899960d4..502d8333318b 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -141,11 +141,15 @@ enum cxl_partition_mode {
> >   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
> >   * @perf: performance attributes of the partition from CDAT
> >   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> > + * @handle: DSMAS handle intended to represent this partition
> > + * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
> >   */
> >  struct cxl_dpa_partition {
> >  	struct resource res;
> >  	struct cxl_dpa_perf perf;
> >  	enum cxl_partition_mode mode;
> > +	u8 handle;
> > +	bool shareable;
> >  };
> >  
> >  #define CXL_NR_PARTITIONS_MAX 3
> 
