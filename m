Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA43E3612D8
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 06:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780123542; cv=none; b=TUEWsUxrBdvbicd1QrpsgGa7Nupbyxfo2sY+CztMnvQWyI0LtM9LWTTVd/H97QLXUFZnNO+4s5dsDC38KUDnwOFb6j+lWO9i9JEbv/4o9D+0sbwrFzH+Sk0i3dmPs7hjG5pMxFlLqa0WKM0osnjQvitL4uz3vVSY5ZC7Xrdzcso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780123542; c=relaxed/simple;
	bh=S2lWALuPgPUK20DzGZy1kJhIuHanRJaHCvEsgDwAp+4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=daG4izPXKZlKMvFxmouCz0vTmFaui86r87q1qaHTzLX/ijCXK6H7H6pQdNuuqqWbfNqd9FK/7gNl5mZbe6kHd2uNnuLs4TRM3NldBu8GFZryL1qQ9l48pFUQsub3HcqRM0PAl723KUHMADceUL/tkAmM+2f+hFKVtPdOVPTDlqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W6OPOsSK; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W6OPOsSK"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-137bd9ed2b1so506559c88.1
        for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 23:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780123539; x=1780728339; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mY5RbX4anurEYoD9W9BJTA9JhZ4j7j2Rd9Id1gFS9bM=;
        b=W6OPOsSKotFZDbQNBgC7Kj8uBv2TZy/LPDvCQG3Mxckin7OnT7XLfGf0dWZY7+JILE
         KQ1bdk0T5YvRZcEP9ofD7i+MmfU+CZ2F+mNePvNelOW0/GvzCLxKW5I4qPZRSq4yCM6I
         FIhJelNnide8TGcdXrDjp84V/qRQFvU5GOBugWLrWCHHR4EwlUqU9oPh6u64m54pSrEb
         uMVacJgrlIPPQHJFEzZPDPAMePm2LRyT2Rs64GFDv95XcaJ5XL/5uDLnDGppsy+dfSNB
         wze8tkvdR6Ujf0Uqlqh4xVUcr1/Ked2GVt2B5vJr9jmKriSUulP4SV/4I1OJXnMluIrx
         t5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780123539; x=1780728339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mY5RbX4anurEYoD9W9BJTA9JhZ4j7j2Rd9Id1gFS9bM=;
        b=Kl8ODMEost/sr+nMinXZOjRgcsH2D/BhYCa1Nti+AHGsYWsfmbbIPXNB8+T9a92M01
         eJ5btepBejt/YiEXaA+oUCtnKhRUp0yjG0aWa2yoE/nM+wGkuDu+RQ7zt0phHE3tRE31
         ylC8UOJYMIIDCPA3bLx9L7Nc90E7vhAtzobe8MsMYrfxE9KZERxaYtaKnWmA87AQ3Qks
         LgaEIFM6OrNUrnyFwEVQH0PxvicI1N4xWJafzzxoArtg2272HIYwKwOWPocYT7NXTbFM
         aVfCVQIxpDhjx2wcmDRVxtnoZPxBdwuYduS9G9pkWRObcfaS5aYN7hx/aTxYzgtbgM0Y
         cNLw==
X-Forwarded-Encrypted: i=1; AFNElJ/ERQe8kd1PY92H0cdVJP/MihY25NN7eFhtsJW8lJFUP9soKKg1QlFHpDx83I+10BFLMF1LIWI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwRuio+Dxn1PA4/8dia37XQvnyZA/qkpylPFn0nuNBnGKCx/f2
	zjA7XhBtEN622jB3kRqT7bHlxQvfRN/Pk46LNb6KOhD1O2yp2vhDhRY7
X-Gm-Gg: Acq92OF9HLj9NE/0MJWe+HCFc5mEUZBPeyPriR96cmZ75tWS1vK8lXBMf/1ZxJdExZf
	6yDhewvDhyJ58JzKygtnA9IFq/nZIL6LByz/k2v0aNNBPvkbBadNFr5vby68iwGnR0VtpuRHQSR
	NzlF+XEmc3e883IAifSJuIs9n9Yb4DkGYqoxvwPBC53J9DpEpt8nQSf8k+YyNCe0N4N4KtBSLoZ
	YoqIiXCCJEWvJjTGEzGrdYtyeGpW4lHdGjMPcMlHNjeCDMc7pkq5SR/3tNT+wmUbMs3ZsTKQKTT
	6Vg9Xdkhby3txipRfoNf7W1ay5i7f+jeUToBlBB5dvHDJBzgLNmbLh1ou5GXy5ndN4QwaIjlWTQ
	xJDleMCPQ2wV3OGgZC194KxFSslbkjYtM+AhOnkGzLmXTgmJhWi50diH4y7t8H8uSDGSyaJkwA2
	1cAQbC+0ztTkzI8C18Q8Ywxms+rnregzOoNcQBrRQ0Trd46PerWJjKFvXdUVLsPJOgdEOCE1vq2
	RnORFTWgjMl23iBQQ==
X-Received: by 2002:a05:7022:220c:b0:12d:c9b6:bbdc with SMTP id a92af1059eb24-137d4251f74mr1358671c88.30.1780123538889;
        Fri, 29 May 2026 23:45:38 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3c69c0asm2801409c88.11.2026.05.29.23.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 23:45:38 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Fri, 29 May 2026 23:45:36 -0700
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
Subject: Re: [PATCH v10 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <ahqHkPFqTZSD5mb1@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <f7800561164a891513a20381378f2ff052d29288.1779528761.git.anisa.su@samsung.com>
 <700377ba-af02-4a40-b7d1-0b3f28c064c4@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700377ba-af02-4a40-b7d1-0b3f28c064c4@intel.com>

On Wed, May 27, 2026 at 04:16:05PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:42 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Additional DCD partition (AKA region) information is contained in the
> > DSMAS CDAT tables, including performance, read only, and shareable
> > attributes.
> > 
> > Match DCD partitions with DSMAS tables and store the meta data.
> 
> DCD handle needs to be propogated. 
> 
> add_part() needs to copy over the handle
Fixed: add_part() function signature gains u8 handle parameter.

Call site from cxl_mem_dpa_fetch() for RAM and PMEM partitions passes in
0 for handle.
Call site from cxl_configure_dcd() passes in dc_info->handle.

> cxl_dpa_setup() also needs to copy the handle
Fixed
> 
> 
> Would be good to get this checked against actual hardware.
> 
Yes, we are coordinating with another team within Samsung to validate.
> 
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > 
> > ---
> > Changes:
> > [anisa: rebase]
> > [jonathan: core/mbox.c: error if there are non-zero reserved bits in DSMAD
> > handle in cxl_dc_check]
> > ---
> >  drivers/cxl/core/cdat.c | 11 +++++++++++
> >  drivers/cxl/core/mbox.c |  7 +++++++
> >  drivers/cxl/cxlmem.h    |  2 ++
> >  include/cxl/cxl.h       |  4 ++++
> >  4 files changed, 24 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> > index 5c9f07262513..c5f3d2ebea55 100644
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
> > @@ -244,6 +246,7 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
> >  		dpa_perf->coord[i] = dent->coord[i];
> >  		dpa_perf->cdat_coord[i] = dent->cdat_coord[i];
> >  	}
> > +	dpa_perf->shareable = dent->shareable;
> >  	dpa_perf->dpa_range = dent->dpa_range;
> >  	dpa_perf->qos_class = dent->qos_class;
> >  	dev_dbg(dev,
> > @@ -266,13 +269,21 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
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
> > +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
> > +				    dent->handle != handle)
> > +					dev_warn(dev,
> > +						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> > +						&range, handle, &dent->dpa_range, dent->handle);
> 
> Should it 'continue' here since it mismatches?
> 
Fixed!
> DJ
> 
Thanks,
Anisa
> > +
> >  				update_perf_entry(dev, dent,
> >  						  &cxlds->part[i].perf);
> >  				found = true;
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 71b29cd6abfe..f9a5e21f5d09 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1356,10 +1356,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
> >  {
> >  	size_t blk_size = le64_to_cpu(dev_part->block_size);
> >  	size_t len = le64_to_cpu(dev_part->length);
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
> > @@ -1494,6 +1500,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> >  	/* Return 1st partition */
> >  	dc_info->start = partitions[0].start;
> >  	dc_info->size = partitions[0].size;
> > +	dc_info->handle = partitions[0].handle;
> >  	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
> >  		dc_info->start, dc_info->size);
> >  
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 87386488ad10..cee936fb3d03 100644
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
> > @@ -818,6 +819,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> >  struct cxl_dc_partition_info {
> >  	size_t start;
> >  	size_t size;
> > +	u8 handle;
> >  };
> >  
> >  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index bb1df0cef863..51685a01d19c 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -122,12 +122,14 @@ struct cxl_register_map {
> >   * @coord: QoS performance data (i.e. latency, bandwidth)
> >   * @cdat_coord: raw QoS performance data from CDAT
> >   * @qos_class: QoS Class cookies
> > + * @shareable: Is the range sharable
> >   */
> >  struct cxl_dpa_perf {
> >  	struct range dpa_range;
> >  	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
> >  	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
> >  	int qos_class;
> > +	bool shareable;
> >  };
> >  
> >  enum cxl_partition_mode {
> > @@ -141,11 +143,13 @@ enum cxl_partition_mode {
> >   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
> >   * @perf: performance attributes of the partition from CDAT
> >   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> > + * @handle: DSMAS handle intended to represent this partition
> >   */
> >  struct cxl_dpa_partition {
> >  	struct resource res;
> >  	struct cxl_dpa_perf perf;
> >  	enum cxl_partition_mode mode;
> > +	u8 handle;
> >  };
> >  
> >  #define CXL_NR_PARTITIONS_MAX 3
> 
