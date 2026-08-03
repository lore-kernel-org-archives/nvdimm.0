Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348C3C0A11;
	Mon,  3 Aug 2026 23:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785801334; cv=none; b=eDZG806Pn9ypD4vLGeGfYhQn82UDd4H8c8LPzt8D/fzH3JhTVlhdXyJFn+2zZmuepokojPPffoQRtQrkj+OflcHmfwc0ERiWbgP101BWfAWae+kYlTpYmhEVx8G+u+Lavi+za09JZo1TiwRd1izW0MHFK7vrTGSiopctt0fbxSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785801334; c=relaxed/simple;
	bh=bIXlpmlxkFC2CfO8N1ZtPgJBEhpPL62msk9Y7zyZHMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDGFQpi8qQogmZ1+qAFeBfgraTZaY8s+pqUEy8PC0JHoWSl7ymoM9wXBaQ+V7Z2RIDgVy4pyFYX0x68N79MigdohBGBpnCXTDBR+MkLyZJ8kJNhu5jes0HCUt/1/xgaj9lSFrLIGHiLrdXFwuKorxelXl0k5PMcv+FX+Jo99Gi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeNJz8sI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeNJz8sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360671F000E9;
	Mon,  3 Aug 2026 23:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785801332;
	bh=NXoGvOija+rXoGc0jAreHQ2EQTEW2ojWrLo17SrbvGk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UeNJz8sIHRMelICJcz38RchACt/5z5vj8dURxe7nBJInBGIm0zww+5TNBtiTJ9/aG
	 5kZxvZTKT2JMqs1waa755tDMqavjZcItXKrIE0+tQMCtMY66XmN3i6Vrctzk1v3Vfu
	 lecWlr//+KYz9OGr6cCOgiwXHO+GyY1xAm214jlXhjE6eM8aqHIITI0XZlKZJ+yueN
	 IkyP5TF4vYpovLebZ42Vw0I52IeawvslQHnkgsFeIxok389vhO72TIqTxGtA9KRb7g
	 oe4Tchg5Sxg2Yi3cdbyhm9mwJd3Ml49J4x2wF9fiWW3+Mx8TFU2vGXIxG+ks1KlZRl
	 6uq7REbwdLJ5w==
Date: Tue, 4 Aug 2026 00:55:27 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li
 Ming <ming.li@zohomail.com>, Vishal Verma <vishal.l.verma@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
 Benjamin Cheatham <benjamin.cheatham@amd.com>, Wonjae Lee
 <wj28.lee@samsung.com>, Junhee Park <jh9934.park@samsung.com>, Heesoo Kim
 <habil.kim@samsung.com>, Anisa Su <anisa.su@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20260804005527.103b7a9f@jic23-huawei>
In-Reply-To: <20260731084901.1512819-3-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-3-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 01:48:07 -0700
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram 1'.  Additional partitions can be added in the future if
> such a device ever materializes.  Additionally it is anticipated that no
> skips will be present from the end of the pmem partition.  Check for and
> disallow this configuration as well.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>

Hi Anisa,

A few things to add to the reviews of others.

Jonathan
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 4790524c32a7..d79019fbd790 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> +	u64 len = le64_to_cpu(dev_part->length);
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;

I'd be tempted to make it clear you are setting whole structure with

	part_array[index] = (struct cxl_dc_partition_info) {
		.start = le64_to_cpu(dev_part->base),
		.size = le64_to_cpu(dev_part->decode_length) * CXL_CAPACITY_MULTIPLIER,
//This is a case where I think readability justifies the long line.

	};
> +
> +	/* Check partitions are in increasing DPA order */
> +	if (index > 0) {
> +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> +
> +		if ((prev_part->start + prev_part->size) >
> +		     part_array[index].start) {

I'd be tempted to put the above on one line.

> +			dev_err(dev,
> +				"DPA ordering violation for DC partition %d and %d\n",
> +				index - 1, index);
> +			return -EINVAL;
> +		}
> +	}

Alison's comments seem valid to me and apply to rest of this function at least so I'll
not add anything else on that.

> +
> +}

...

> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read Dynamic Capacity information from the device and return the partition
> + * information.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         on error only dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/* Bound requested number of partitions by mailbox payload size */
> +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> +				(mbox->payload_size - sizeof(*dc_resp) -
> +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +				sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +
> +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check()
> +	 */
> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int rc, i, j;
> +
> +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> +				       dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (rc == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		num_partitions += rc;
> +
> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {

How could num_partitions end up either 0 or negative given we added at least 1 and
I don't see a path by which it will get decremented. Roll over isn't a thing given
we would have failed the other check on a previous loop.


> +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> +				num_partitions);
> +			return -EINVAL;
> +		}
> +
> +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> +			rc = cxl_dc_check(dev, partitions, i,
> +					  &dc_resp->partition[j]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		start_partition = num_partitions;
> +
> +	} while (num_partitions < dc_resp->avail_partition_count);
> +
> +	/* Return 1st partition */
> +	dc_info->start = partitions[0].start;
> +	dc_info->size = partitions[0].size;
> +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}



> @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
>  
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> +{
> +	struct cxl_dc_partition_info dc_info = { 0 };

I think the preferred way of doing this is heading for the C23 option of

  = { };

but CXL has plenty of { 0 }; so fair enough if you prefer to keep it this
way.  For anyone concerned about older compilers there is a specific selftest
for { } doing what we expect even if the structure has holes.


> +	struct device *dev = mds->cxlds.dev;
> +	int rc;
> +
> +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);

Fun question on whether we consider a DCD capable device failing such
a basic thing as a warning level thing or a hard failure thing.

To me DCD is a important core device feature (unlikely maybe fwctl, features etc)
so we should be failing. 

We should definitely be returning an error from here, even if ultimate
we decide not to act on that error in cxl_pci_probe().

> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	/* Skips between pmem and the dynamic partition are not supported */
> +	if (dc_info.start != info->size) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported\n");
> +		cxl_disable_dcd(mds);
> +		return;

In this case not failing hard is probably fair if that is a specification
allowed feature we are just not choosing to support for now.

> +	}
> +
> +	info->size += dc_info.size;
> +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> +		dc_info.start, dc_info.size);
> +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");


