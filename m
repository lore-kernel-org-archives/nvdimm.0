Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58507437136
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 09:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785837253; cv=none; b=FpnHENC6N5ihUtBZnxCDKPR67z2Sxk42pS+BBZO6ALKLCO1OC4bpVTJnNy7m3jxVaQISrEwWcpqP+d34EwvI+FUZUKxAzUcjTGE4yi+PO+JY9XC7fZobOmTnRPhyk26y/1eB9yWCTLKf8ckEMtvWHtAse96s0b26Rdj37Qi+Po4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785837253; c=relaxed/simple;
	bh=AHfsnOFC2AS5u/XxLaDu2XTKosKXy6ByffHyafLqWmQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhuoaS+mpd7LqiBrHNhJNBBh/OUGyhlPQxyv2ZJp8hu/MKHe1h7uIrlcXHXz+jNLNkKAzksZC/6Q9Jk+IQFs5YDX75b6C8wNZ37jP0wB9hyy7iMHKQ/MtHM762AD4iXefawphF6ACnQlV4bCPX0tTCVejuPebms8JLLzgkUGS8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Idw7w8Po; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Idw7w8Po"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cf27856f9cso43923845ad.2
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 02:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785837249; x=1786442049; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1Afs63KtzqwY1jV3RU1yPpFiCQtMPoQQlCP9xxFLzzc=;
        b=Idw7w8PoyG0ynEjiSw1Eaz4xcxDvBNNS6WPRSzOmJK7ejIno6RWJ1ZKF5l8cig6/28
         J+D+tG5QMtcZpMkKTgrHqUw5PbrTFikyCLc+Lb1wsR9xU6fytmBk0SKe5gZIsdbZPWNO
         9Tji+SoLKTQ6/7HlIFsrt3C15+90UsPBtXdvASqToG2VAwa4ngcE7YXx/5s9hv2a6CBQ
         okOhaN0Rf8K0+Lcc8R33vwf0dgpxvGHZ+4GzySTI2D+oJsShvvVBWe8xg9EDchaYw/ui
         gNeJWfGJZ4e0MMdXVy0X9PIr6Lx3Az3Dv9Ne3QBrHfY0YQFjp0Wbz5uysw8cd+61Esu4
         Lj5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785837249; x=1786442049;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Afs63KtzqwY1jV3RU1yPpFiCQtMPoQQlCP9xxFLzzc=;
        b=m/ojq28HsNJusrAdPHxYxlRB5PZQE6eC38y8OZqHCaq+oJTsyt2rtJSUEJXFUC+idR
         I/KWnf8YsCYSxiG98nGXGLKew1dIqlcOxlCnmQyFHqJqMtLui2/IVssEQWn16KtxK3xE
         wnl5ColdY7a/Ml3VGC+vBv7IJSy0W2nuVb6Cmyan6gC8B+a/DShU+B6dimQ7UKloLA4e
         BaQ1wALiHwzZuPop4S0KpCNVSqIonjNozVh6CGFT2zf9U78oOu+JuwTxwvUHUNb2c+WX
         7EbwNnN+1ezYdgkJzCLUS6GxGAgDRpgNMpMaBwv8t31vihNiTZiNPPUuUKln4NNETZTN
         UOwQ==
X-Forwarded-Encrypted: i=1; AHgh+RoIQfcV565HFWDoLTMNlJqlS2TZMO0IUH7LtQdJqKOtW2vkPxzuFuqmqrJXUTCuMriGbgwPBuk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwHu3S9ppMK6CFn+u/V/KirCT8w2aC4Tirv6zpI1eqZ71ER3lFe
	l13KI5FI7Q3lS2PraqtjQJQrALI7hCIbgKvP5TwvcqA2WZYx1JtrhSHt
X-Gm-Gg: AR+sD103zMuNbyBbkz/qJVFfs1xPlXbx2H6RjxmbdKktOE4aaiIPFJ3aXYsC4anv0mV
	Hs4YAPOmdQeXC+nQFI5Rsk2HGessicN3Q8vAZYVHuz7S3BzO9lJfx7+sgpswwJEcZqKWERphDce
	KLHDAmcQbUvgmd+VhXQ6x6rN+ElcYzpYRUOSNWcyKua0xfgkX2pNBlWdJuzZn4qPnWLpRMuJynR
	ZmVAs7QEslElGvLFADlp/NKuc2kIp+Y13+4Zg27DuNvqE52sLOvSLZ4KoPYjGuQFZTiyEjPC0Mh
	VC/VRMe3efk4LIJKR4UUF/u3MUC8WDW15B+1MZcz8wgepQSkEaF98ymJ0x8nZiFdJ5t6K3/r511
	qmx8lK2O7lDjAIeBXMiw4QXE3B2wuyiTGH+uExiMGofobn7iKfydulek8avowSJ+Esi9/uz1vvD
	mGoW8XnmdKByeaiZ/UU4X8mpQ8Kspm9DvATixZvIClxrVUTIqjnYPJd0riL0nlqe6ymjVfn7LGx
	blTS0gQH66iDLng807ASRyS69EbZMXj6QbNHJ3MsQ8C
X-Received: by 2002:a17:903:184e:b0:2d0:401c:2ebb with SMTP id d9443c01a7336-2d0521e93a3mr138027585ad.4.1785837249357;
        Tue, 04 Aug 2026 02:54:09 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315867a68fdsm4673072eec.25.2026.08.04.02.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 02:54:08 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 4 Aug 2026 02:54:07 -0700
To: Jonathan Cameron <jic23@kernel.org>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anG2vz3Ybp715TkW@AnisaLaptop.localdomain>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
 <20260804005527.103b7a9f@jic23-huawei>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804005527.103b7a9f@jic23-huawei>

On Tue, Aug 04, 2026 at 12:55:27AM +0100, Jonathan Cameron wrote:
> On Fri, 31 Jul 2026 01:48:07 -0700
> Anisa Su <anisa.su887@gmail.com> wrote:
> 
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Devices which optionally support Dynamic Capacity (DC) are configured
> > via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> > the Get DC Configuration command in order to properly configure DCDs.
> > Without the Get DC Configuration command DCD can't be supported.
> > 
> > Implement the DC mailbox commands as specified in CXL 4.0 section
> > 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > information.  Disable DCD if an invalid configuration is found.
> > 
> > Linux has no support for more than one dynamic capacity partition.  Read
> > and validate all the partitions but configure only the first partition
> > as 'dynamic ram 1'.  Additional partitions can be added in the future if
> > such a device ever materializes.  Additionally it is anticipated that no
> > skips will be present from the end of the pmem partition.  Check for and
> > disallow this configuration as well.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 
> Hi Anisa,
> 
> A few things to add to the reviews of others.
> 
Thanks Jonathan! Details below.

> Jonathan
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 4790524c32a7..d79019fbd790 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
> >  	return -EBUSY;
> >  }
> >  
> > +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> > +			u8 index, struct cxl_dc_partition *dev_part)
> > +{
> > +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> > +	u64 len = le64_to_cpu(dev_part->length);
> > +
> > +	part_array[index].start = le64_to_cpu(dev_part->base);
> > +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> > +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> 
> I'd be tempted to make it clear you are setting whole structure with
> 
> 	part_array[index] = (struct cxl_dc_partition_info) {
> 		.start = le64_to_cpu(dev_part->base),
> 		.size = le64_to_cpu(dev_part->decode_length) * CXL_CAPACITY_MULTIPLIER,
> //This is a case where I think readability justifies the long line.
> 
Agreed, and it also improves readability of patch 3, which adds the DSMAD handle.
Originally handle verification came after setting start and size, and
before setting handle. Now, the handle verification goes once in front,
and all 3 fields set together. So the end result reads:

	if (handle & ~0xFF) {
		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);
		return -EINVAL;
	}

	part_array[index] = (struct cxl_dc_partition_info) {
		.start = le64_to_cpu(dev_part->base),
		.size = le64_to_cpu(dev_part->decode_length) * CXL_CAPACITY_MULTIPLIER,
		.handle = handle,
	};

> 	};
> > +
> > +	/* Check partitions are in increasing DPA order */
> > +	if (index > 0) {
> > +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> > +
> > +		if ((prev_part->start + prev_part->size) >
> > +		     part_array[index].start) {
> 
> I'd be tempted to put the above on one line.
> 
Done.
	if (prev_part->start + prev_part->size != part_array[index].start) {

The comparison changed from > to != because Alison pointed out this was
only an overlap check and gaps were passing. Since Linux requires
contiguous partitions I made it require exact contiguity.

One thing I mentioned in my reply to Alison: since only partiton 0 is
configured, a device with a valid partition 0 has DCD disabled if
a gap exists in subsequent partitions, even though the spec permits the
DPA gaps and we never use other partitions.

cxl_dpa_setup() is where partitions are configured and enforces the contiguity
rule. Is it more correct for cxl_dev_dc_identify() to check for spec compliance
only (no overlap) and defer the Linux-specific rule of no gaps between
partitions up to cxl_dpa_check()?

> > +			dev_err(dev,
> > +				"DPA ordering violation for DC partition %d and %d\n",
> > +				index - 1, index);
> > +			return -EINVAL;
> > +		}
> > +	}
> 
> Alison's comments seem valid to me and apply to rest of this function at least so I'll
> not add anything else on that.
> 

Agreed and worked through.

> > +
> > +}
> 
> ...
> 
> > +/**
> > + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> > + *                         device.
> > + * @mbox: Mailbox to query
> > + * @dc_info: The dynamic partition information to return
> > + *
> > + * Read Dynamic Capacity information from the device and return the partition
> > + * information.
> > + *
> > + * Return: 0 if identify was executed successfully, -ERRNO on error.
> > + *         on error only dc_info is left unchanged.
> > + */
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info)
> > +{
> > +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> > +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> > +	struct device *dev = mbox->host;
> > +	u8 start_partition;
> > +	u8 num_partitions;
> > +	u8 partition_count;
> > +	size_t dc_resp_size;
> > +
> > +	/* Bound requested number of partitions by mailbox payload size */
> > +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> > +				(mbox->payload_size - sizeof(*dc_resp) -
> > +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> > +				sizeof(struct cxl_dc_partition));
> > +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> > +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> > +
> > +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> > +	if (!dc_resp)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Read and check all partition information for validity and potential
> > +	 * debugging; see debug output in cxl_dc_check()
> > +	 */
> > +	start_partition = 0;
> > +	num_partitions = 0;
> > +	do {
> > +		int rc, i, j;
> > +
> > +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> > +				       dc_resp, dc_resp_size);
> > +		if (rc < 0) {
> > +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> > +			return rc;
> > +		}
> > +
> > +		if (rc == 0) {
> > +			dev_err(dev,
> > +				"Device reported %u partitions available but returned none at index %u\n",
> > +				dc_resp->avail_partition_count, start_partition);
> > +			return -EIO;
> > +		}
> > +
> > +		num_partitions += rc;
> > +
> > +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> 
> How could num_partitions end up either 0 or negative given we added at least 1 and
> I don't see a path by which it will get decremented. Roll over isn't a thing given
> we would have failed the other check on a previous loop.
> 
Good point, dropped. This leaves:
	
	if (num_partitions > CXL_MAX_DC_PARTITIONS) {

Alison separately asked for avail_partition_count to be range checked
against the 1 to 8 Table 8-346 requires, which is now done in
cxl_get_dc_config() before the count is used as the loop bound. So this
check is left as a defense against a faulty device that somehow returns
more partitions than advertised.

> 
> > +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> > +				num_partitions);
> > +			return -EINVAL;
> > +		}
> > +
> > +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> > +			rc = cxl_dc_check(dev, partitions, i,
> > +					  &dc_resp->partition[j]);
> > +			if (rc)
> > +				return rc;
> > +		}
> > +
> > +		start_partition = num_partitions;
> > +
> > +	} while (num_partitions < dc_resp->avail_partition_count);
> > +
> > +	/* Return 1st partition */
> > +	dc_info->start = partitions[0].start;
> > +	dc_info->size = partitions[0].size;
> > +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> > +		dc_info->start, dc_info->size);
> > +
> > +	return 0;
> > +}
> 
> 
> 
> > @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
> >  
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > +{
> > +	struct cxl_dc_partition_info dc_info = { 0 };
> 
> I think the preferred way of doing this is heading for the C23 option of
> 
>   = { };
> 
> but CXL has plenty of { 0 }; so fair enough if you prefer to keep it this
> way.  For anyone concerned about older compilers there is a specific selftest
> for { } doing what we expect even if the structure has holes.
> 
Switched to { }.

> 
> > +	struct device *dev = mds->cxlds.dev;
> > +	int rc;
> > +
> > +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> > +	if (rc) {
> > +		dev_warn(dev,
> > +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> 
> Fun question on whether we consider a DCD capable device failing such
> a basic thing as a warning level thing or a hard failure thing.
> 
> To me DCD is a important core device feature (unlikely maybe fwctl, features etc)
> so we should be failing. 
> 
> We should definitely be returning an error from here, even if ultimate
> we decide not to act on that error in cxl_pci_probe().
> 
Agreed, cxl_configure_dcd() returns int now. cxl_pci_probe() now
disables dcd if cxl_configure_dcd() fails:

	if (cxl_dcd_supported(mds)) {
		rc = cxl_configure_dcd(mds, &range_info);
		if (rc)
			cxl_disable_dcd(mds);
	}

The three paths return distinct errors:
1. the cxl_dev_dc_identify() err propagates,
2. -EINVAL for a DC partition overlapping static capacity
3. -EOPNOTSUPP for the gap below.

Re: should "we consider a DCD capable device failing such a basic thing as
a warning level thing or a hard failure thing":

I went with continuing the probe without DCD. Failing cxl_pci_probe()
costs the device its static capacity too, which seems a worse outcome than
running without dynamic capacity.
But I could be persuaded the other way -- if a DCD device that cannot report
its DC Config then it should not come up at all.

> > +		cxl_disable_dcd(mds);
> > +		return;
> > +	}
> > +
> > +	/* Skips between pmem and the dynamic partition are not supported */
> > +	if (dc_info.start != info->size) {
> > +		dev_warn(dev,
> > +			 "Dynamic Capacity skip from pmem not supported\n");
> > +		cxl_disable_dcd(mds);
> > +		return;
> 
> In this case not failing hard is probably fair if that is a specification
> allowed feature we are just not choosing to support for now.
> 
Agreed, so it stays a warning and returns -EOPNOTSUPP. From Alison's
review, I split it up to differentiate skip from overlap. Overlap
returns -EINVAL. So now we have:

	if (dc_info.start < info->size) {
		dev_err(dev, "DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
			dc_info.start, info->size);
		return -EINVAL;
	}

	/* A gap between static capacity and the DC partition is not supported */
	if (dc_info.start > info->size) {
		dev_warn(dev, "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n",
			 dc_info.start, info->size);
		return -EOPNOTSUPP;
	}

The old message also said "pmem" when the value it compares against is
info->size, ie mds->total_bytes, the whole static capacity from Identify
rather than the end of the pmem partition, which is not quite accurate
for a volatile-only device. Reworded.

Thanks,
Anisa

> > +	}
> > +
> > +	info->size += dc_info.size;
> > +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> > +		dc_info.start, dc_info.size);
> > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> 
> 
