Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C423C415E
	for <nvdimm@lists.linux.dev>; Wed,  5 Aug 2026 06:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785913139; cv=none; b=YDGDTpU6gB9gRo6a+MKdH6rZCHvQOlDXFADOoueu6NlzzB8OvkO1Tu2/HXLWopomUBXVEHyVzRlo/Fevd9vxMvR5laQyZkXOMMisZ4N6XsQXFww1SXqueKGTyNZtTuo0eljbgXVuL6pj7Pkgr+dCO51eTRKGoKylat9PQuepyF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785913139; c=relaxed/simple;
	bh=3KcgLZZuDH2ZLw1M6378ryuGKsm4lC4ThdkiZ5DL50g=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlMhRhcuopj+zrU8E9l5Meza3k/TSKmNc4eYm5pQawzPH2zXs2xZaZz5bvyMSEpCrWDu/AXTSB7/kMSKkqaHXXYpcMhsJ9QnxGOnph5LdNhOZtQ41rY/ZAAK13Pb7vKl8OtMOBgp9HzodM5YcSnEu8bisNtCMsdLmrHExaJlRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cpambWQ6; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cpambWQ6"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-ca957432c7fso594923a12.1
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 23:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785913134; x=1786517934; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xF0jzajFRXfVi/0POloqM0mH9boLzzG9lMdGT4OfrFE=;
        b=cpambWQ64X3CJBA9UgXDMkhfKpQ4NBQMa4x1EmkRDROCbPlwYADWCeXeHJHltwed28
         jRKCeRZRRVFqjR/Y7UEm1DUykwHiHihpnZYAV4d7oR7C3Gwn/eAye3oET1I3fduysFBM
         TvCJf+2m+vEY8Hf8+XzTS7T9Yj+fmWyZzDDOq/XP5XlbJbuEahQF+1hn2sBXQVUNKbW+
         27uPq5X3y+l0ILCbAndRG0N0Xo3mORud8T7S0Y+n7FSII+wg8E7MIpTWKIAv5yIR7ASD
         FXxs/aG2jFtQDEK5bXKC4wfuMGRRB9VWl8ka6WMD9lYZCLzQhunKvjsKm1EwlxHQnzED
         Tjow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785913134; x=1786517934;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xF0jzajFRXfVi/0POloqM0mH9boLzzG9lMdGT4OfrFE=;
        b=on0AnkjfD+8hKNPJEz2OnO2CiLfIvtB3x1M4/N4iJhy3RpLfTJ6lmZJMkb4hwxdD5n
         R0B13QTmdW44MnrT6vkLQaJGS2z5cnX1jCkDEsh7URo83eoVo3LwnAkl6a0Z+QvjJFJs
         +gKQ24Foh0q4lHkrJyZAFpPQTuzLaLph/JANZyHjMq+XEhg+PkWgDvREGkrE5QZoSXyh
         ZwPmP0MUFox6j6WMsXK0xhGblyCaZOkBG7jJ7Aj9XKKeW0VJ3ESeGVm+MisgXnW9Mk/m
         xzE8BYfMSt0WvxFSM3rKaRQbw0F7Sar8o35+Ac3+8ELuMd8krwNviAuCWGONOPWa5AkS
         APFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr73bQbpN31eITurtBlBzoU6rUKdgLu8E8R4mzwdCHopoGPAmEpBZ48ZByGlq2oOrukAavP078=@lists.linux.dev
X-Gm-Message-State: AOJu0YwePAQrUmMMu7KBXA6ST0EB+zTn2a5IcUV3hngSNIbB3EZukhRx
	83NGdc/lSlbmWQzVPkOG2esUQlz11vibWILVQX/fwD0xqOxPZ724Zsn9
X-Gm-Gg: AR+sD12vNXmsJWbozebpEJpFbxfgMFUpz7wxj69kxFe0fuWtBqbqS/aFYZVPGARO99l
	NhvQJDC6awTxyUfOk3FVLG4JKgesRhvSVU9g4lHv7QVG+3fVqHUuYKBPOMTf8eU8HoAGo8l/E4o
	3gRmMI85x/FczN5yb0Vosd9OcJAxciF7Fn5oP8HPBLbmYkMIy8y7EM/eEu6PA7NtAziuVVz6uLh
	JIafVSRu9Ke5sjfnVFwbLtlWod45kokT1nfYIfSTi1h3UfYhxa7fQ9JivLV91L8bjSKrtAyF6KG
	l3IA/VHwbPF9gMlFmgnoUiFDewMXeA63kAAve3TIF3EltYhj71c/IfGDk8qZzM9F4L7RjqKgDeR
	Kf+vtty4o2QUKI87X2ofjjVbQeLi7cNZsDdqFCGKM8joliiMZJC+oo7iwWvPK0S2OCjW2oni6nT
	uD9eFIAqxTLTDYF94e5s+7QVd4uSWovGbCpotbpK6pjVOERMO3Zm4fcNHT5jeBegCU918diKyWy
	KVECsQFMLpvARLd5pCHL1qsBTMUlbiMcE+Cq+4iLX4wh5URqukgTjvRktIAu0bPn38=
X-Received: by 2002:a05:6a21:69c:b0:3b4:6a23:6ba with SMTP id adf61e73a8af0-3cb85efb370mr5595869637.26.1785913134059;
        Tue, 04 Aug 2026 23:58:54 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe707cd959sm864374a12.2.2026.08.04.23.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 23:58:53 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 4 Aug 2026 23:58:50 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <anLfKsOD7_9kR_BC@AnisaLaptop.localdomain>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-4-anisa.su@samsung.com>
 <anEcpHwmkbGWB9ej@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anEcpHwmkbGWB9ej@aschofie-mobl2.lan>

On Mon, Aug 03, 2026 at 03:56:36PM -0700, Alison Schofield wrote:
> On Fri, Jul 31, 2026 at 01:48:08AM -0700, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Additional DCD partition (AKA region) information is contained in the
> > DSMAS CDAT tables, including performance, read only, and shareable
> > attributes.
> > 
> > Match DCD partitions with DSMAS tables and store the meta data.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Co-developed-by: Anisa Su <anisa.su@samsung.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  drivers/cxl/core/cdat.c | 13 +++++++++++++
> >  drivers/cxl/core/hdm.c  |  1 +
> >  drivers/cxl/core/mbox.c | 22 ++++++++++++++++------
> >  drivers/cxl/cxlmem.h    |  2 ++
> >  include/cxl/cxl.h       |  4 ++++
> >  5 files changed, 36 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
> > index 5c9f07262513..37136b2cf7e4 100644
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
> > @@ -266,15 +268,26 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
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
> > +						 "Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> > +						 &range, handle, &dent->dpa_range,
> > +						 dent->handle);
> > +					continue;
> 
> Seems like the above message needs to say that the DSMAD handle from
> mbox disagrees w CDAT DSMAS handle. Those (%u) that are handles have
> no description.

Reworded to:

	dev_warn(dev,
		 "DSMAD handle mismatch: mailbox %u %pra, CDAT %u %pra\n",
		 part->handle, &range,
		 dent->handle, &dent->dpa_range);

which for example would read as:

	DSMAD handle mismatch: [range 0x100000000-0x1ffffffff] has 3, DSMAS [range 0x100000000-0x17fffffff] has 7

I applied it with your suggestion below to invert the range_contains()
and use a 'part' local pointer to reduce nesting and repeated indexing,
but the line is still quite long (99 chars), since it's still within the
xa_for_each(dsmas_xa...){} and the for loop. The message could
be clearer, but I wasn't sure how to do so without going over
100 chars, so I added a comment:

		/*
		 * part->handle is from Get DC Config, dent->handle
		 * from the CDAT DSMAS entry.
		 */
		if (part->mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
		    dent->handle != part->handle) {
			dev_warn(dev,
				 "DSMAD handle mismatch: %pra has %u, DSMAS %pra has %u\n",
				 &range, part->handle,
				 &dent->dpa_range, dent->handle);
			break;
		}


> With the above mismatch and continue, the loop exits w found still
> false. Is that really true?
> 
Good point. found is now set to true before the above check. So with the
inverted range_contains() suggestion:

	if (!range_contains(&range, &dent->dpa_range))
		continue;

	found = true;
	if (part->mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
	    dent->handle != part->handle) {
		dev_warn(...);
		break;
	}


> 
> > +				}
> >  				update_perf_entry(dev, dent,
> >  						  &cxlds->part[i].perf);
> > +				cxlds->part[i].shareable = dent->shareable;
> 
> 
> why is shareable assigned for every node, and not only DYNAMIC_RAM_1
> 
Fixed to only be assigned if the mode is DYNAMIC_RAM_1 now:

	update_perf_entry(dev, dent, &part->perf);
	if (part->mode == CXL_PARTMODE_DYNAMIC_RAM_1)
		part->shareable = dent->shareable;

Although we now have 2 places that gate on if (part->mode == CXL_PARTMODE_DYNAMIC_RAM_1),
I chose to keep this as a separate check. If we consolidate this with
the above part->handle != dent->handle check, it would add another level
of nesting and make the dev_warn message from above to over 100 cols.

> >  				found = true;
> >  				break;
> >  			}
> 
> Above nesting can be improved. Inverting range_contains() to unindent
> the main body. A 'part' local pointer would reduce repeated indexing.
> 
Done.

> 
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
> > index d79019fbd790..a6cdea9f4080 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1357,10 +1357,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
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
> 
> I don't see reserve bits for a DSMAD handle. I think this check is valid
> but the message has the wrong constraint. Expect it is a CDAT constraint.
> 
Yes, thank you for point it out. CXL r4.0 Table 8-347 gives DSMADHandle a
full 4 bytes and declares no reserved bits; the table's Reserved field
is the 3 bytes at 0x25, after Flags. The 8 bit limit comes from CDAT,
where struct acpi_cdat_dsmas has a u8 dsmad_handle, so a value above
0xFF cannot name a DSMAS entry that exists.

The driver stores the handle as u8 in cxl_dpa_partition, cxl_dc_partition_info and cdat.c's
dsmas_entry, so 0x100 would narrow to 0x00 and silently match whichever
DSMAS entry has handle 0. The mssage now reads:

	/* The CDAT DSMAD handle this refers to is 8 bits */
	if (handle & ~0xFF) {
		dev_warn(dev, "DSMAD handle 0x%x exceeds the 8 bit CDAT DSMAD handle\n",
			 handle);

> 
> > +		return -EINVAL;
> > +	}
> > +	part_array[index].handle = handle;
> >  
> >  	/* Check partitions are in increasing DPA order */
> >  	if (index > 0) {
> > @@ -1536,6 +1542,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> >  	/* Return 1st partition */
> >  	dc_info->start = partitions[0].start;
> >  	dc_info->size = partitions[0].size;
> > +	dc_info->handle = partitions[0].handle;
> >  	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> >  		dc_info->start, dc_info->size);
> >  
> > @@ -1543,7 +1550,8 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> >  
> > -static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> > +static void add_part(struct cxl_dpa_info *info, u64 start, u64 size,
> > +		     enum cxl_partition_mode mode, u8 handle)
> >  {
> >  	int i = info->nr_partitions;
> >  
> > @@ -1555,6 +1563,7 @@ static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_pa
> >  		.end = start + size - 1,
> >  	};
> >  	info->part[i].mode = mode;
> > +	info->part[i].handle = handle;
> >  	info->nr_partitions++;
> >  }
> >  
> > @@ -1572,9 +1581,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
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
> > @@ -1584,9 +1593,9 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
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
> > @@ -1638,7 +1647,8 @@ void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
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
> > index a9782939d82b..eb1e6f7a2038 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -140,6 +140,7 @@ struct cxl_dpa_info {
> >  	struct cxl_dpa_part_info {
> >  		struct range range;
> >  		enum cxl_partition_mode mode;
> > +		u8 handle;
> >  	} part[CXL_NR_PARTITIONS_MAX];
> >  	int nr_partitions;
> >  };
> > @@ -853,6 +854,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> >  struct cxl_dc_partition_info {
> >  	u64 start;
> >  	u64 size;
> > +	u8 handle;
> >  };
> >  
> >  int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index 87c2bd73df21..baf0132c70a3 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -141,11 +141,15 @@ enum cxl_partition_mode {
> >   * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
> >   * @perf: performance attributes of the partition from CDAT
> >   * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
> > + * @handle: DSMAS handle intended to represent this partition
> 
> What is with the 'intended'? Either it represents the partition
> or the match failed.
> 
Dropped, now says "DSMAS handle that represents this partition".

> 
> > + * @shareable: Is the partition sharable (from its CDAT DSMAS entry)
>                                    ^
> 				   shareable
> 
Fixed.

Thanks,
Anisa
> 
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
> > -- 
> > 2.43.0
> > 
