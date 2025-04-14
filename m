Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DF525229C
	for <nvdimm@lists.linux.dev>; Mon, 14 Apr 2025 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744644048; cv=none; b=fOxLTa5ToTczdPiP4a3MGEoauhH5gjQ94RnLdd/g0svaNm8O+EVLEm+obP/2ZqDy8v62D/oYzdZ67shE0J+ZeDNeEO/KAplhgD8vvh0RFHchCcs29WyMNyh8HmzsRQOS3l37JBd4jSIZ3bQ9Fdvdy3BCw9paWH/tZMH8FRS95Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744644048; c=relaxed/simple;
	bh=2DLeYDiU9aMJvpHOH65rG7xU1M123aWe98w7HiRWwTs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ouZXOGP5K/+TlqLAKAKrIenHPysPxEMcvRM4Zf7thtFPCPcjfRXeNWPmXsLwzUePG9kXbBJsNjHW+yO8svAVBF9iJeobqf0kI7eRtSSQDMSvEoIqys0ir8fo5j4OA0lzy5MkwzAhBgPYKbET1e8EdKOiErCinr76Q0kTrvylrxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZbrYW434Pz6FGQC;
	Mon, 14 Apr 2025 23:19:27 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A03B71400D9;
	Mon, 14 Apr 2025 23:20:42 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 14 Apr
 2025 17:20:42 +0200
Date: Mon, 14 Apr 2025 16:20:40 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, "Dan
 Williams" <dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 02/19] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20250414153519.0000677a@huawei.com>
In-Reply-To: <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
	<20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)
Message-ID: <20250414152040.n8gqWjlInASPZGqMAZ3b7mwoy8DJSt5ujbjGLEMdpUE@z>

On Sun, 13 Apr 2025 17:52:10 -0500
Ira Weiny <ira.weiny@intel.com> wrote:

> Devices which optionally support Dynamic Capacity (DC) are configured
> via mailbox commands.  CXL 3.2 section 9.13.3 requires the host to issue
> the Get DC Configuration command in order to properly configure DCDs.
> Without the Get DC Configuration command DCD can't be supported.
> 
> Implement the DC mailbox commands as specified in CXL 3.2 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information.  Disable DCD if an invalid configuration is found.
> 
> Linux has no support for more than one dynamic capacity partition.  Read
> and validate all the partitions but configure only the first partition
> as 'dynamic ram A'. Additional partitions can be added in the future if
> such a device ever materializes.  Additionally is it anticipated that no
> skips will be present from the end of the pmem partition.  Check for an
> disallow this configuration as well.
> 
> Linux has no use for the trailing fields of the Get Dynamic Capacity
> Configuration Output Payload (Total number of supported extents, number
> of available extents, total number of supported tags, and number of
> available tags).  Avoid defining those fields to use the more useful
> dynamic C array.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
Hi Ira,

This ended up with a slightly odd mix of the nice flexible code which
we had before to handle multiple regions and just handing one.

Whilst I don't mind keeping the multiple region handling you could further
simplify this if you didn't...

Jonathan

> ---
> Changes:
> [iweiny: rebase]
> [iweiny: Update spec references to 3.2]
> [djbw: Limit to 1 partition]
> [djbw: Avoid inter-partition skipping]
> [djbw: s/region/partition/]
> [djbw: remove cxl_dc_region[partition]_info->name]
> [iweiny: adjust to lack of dcd_cmds in mds]
> [iweiny: remove extra 'region' from names]
> [iweiny: remove unused CXL_DYNAMIC_CAPACITY_SANITIZE_ON_RELEASE_FLAG]
> ---

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 58d378400a4b..866a423d6125 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1313,6 +1313,153 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
>  	return -EBUSY;
>  }
>  
> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)

I'd be tempted to pass in both this part and the previous one (or NULL) directly rather
than passing in the array.  Seems like it would end up slightly simpler in here.
Mind you we only support the first one anyway so maybe we don't need the prev_part
stuff for now...

> +{
> +	size_t blk_size, len;
> +
> +	part_array[index].start = le64_to_cpu(dev_part->base);
> +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> +	len = le64_to_cpu(dev_part->length);
> +	blk_size = le64_to_cpu(dev_part->block_size);

For these, might as well do it at declaration and save a line.

	size_t blk_size = le64_to_cpu(dev_part->length);
	size_t len = le64_to_cpu(dev_part->length);

> +
> +	/* Check partitions are in increasing DPA order */
> +	if (index > 0) {

If you pass the prev_part in as a parameter, this just becomes
	if (prev_part)

> +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> +
> +		if ((prev_part->start + prev_part->size) >
> +		     part_array[index].start) {
> +			dev_err(dev,
> +				"DPA ordering violation for DC partition %d and %d\n",
> +				index - 1, index);
> +			return -EINVAL;
> +		}
> +	}

Rest of the checks look good to me.

> +}
> +
> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = CXL_MAX_DC_PARTITIONS,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		.min_out = 1,

Why 1?  If a device oddly supported 0 regions I think it would still be 8
to cover the first two fields and the reserved space before region configuration
structure.

> +	};
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> +	return dc_resp->partitions_returned;
> +}
> +
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
> + *         on error only dynamic_bytes is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	size_t dc_resp_size = mbox->payload_size;
> +	struct device *dev = mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
> +					kvmalloc(dc_resp_size, GFP_KERNEL);

Could we size this one for max possible? (i.e. 8 partitions) with a struct
size and avoid needing vmalloc.  Maybe it is worth the bother.

> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/* Read and check all partition information for validity and potential

Multi line comment syntax isn't this for this file.

> +	 * debugging; see debug output in cxl_dc_check() */
> +	start_partition = 0;
Could set at declaration  (up to you)
> +	do {
> +		int rc, i, j;
> +
> +		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		num_partitions += rc;

Initialization missing I think.

> +
> +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
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

I'm not against keeping the complexity above but if all we are going to do is
use the first partition, maybe just ask for that in the first place?
We don't need to check for issues in things we aren't turning on.

> +	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");



> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 394a776954f4..057933128d2c 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> +
> +struct cxl_mem_dev_info {
> +	u64 total_bytes;
> +	u64 volatile_bytes;
> +	u64 persistent_bytes;
> +};

So far I'm not seeing any use of this. Left over from previous patch
or something that gets used later in the series and so should get
introduced with first use?



