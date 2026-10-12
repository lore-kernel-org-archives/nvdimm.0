Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16FD40BCB4;
	Mon, 12 Oct 2026 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805662; cv=none; b=YIpWiXnDiBORjGm7CgK21gAgM6B6HuIj/Tcy4HSFBCEllf3eVIyzkdVjxwR8DngTXawsQGxrgLm8s1LJa960crF7SrzoSTuY25PP0nsbEdimAaYZeJ720wD5iK8Fs7c+Lmk5vvxeY2LkeEqcLG8y8MUJ/9nkoJU6Ry6TrkMKFNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805662; c=relaxed/simple;
	bh=XbHq762k3/9t3hNa57Y4Kz3aN+yIAuLnRC+BPMiIObE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/VMhoztxHvXWC4mUBweg7DxJXuZZSua1Sa3FoXC7f/Soe8F5McT3hf53s58mNF0wCh7a/ja9xM+lLlVfi7x7fll1I4ai4dEismMVxFggs+drzKxALkVgCtllWWT/a1Z5ex+mYFnhFKLqqg0VgtCvEIv6wbrtfcPTFIdNIHGIhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWVNoIoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWVNoIoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA781F0089B;
	Mon, 12 Oct 2026 11:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791805658;
	bh=7oM78ce5BGAkXeG6yuIhoGfsr+uXGfD+/j4Z4HuOqhs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iWVNoIoHHb5pYemoB2sx9JfU9tmHxPaaqTHF+wufIFZ8fwdbmDeJAuJMnWa6knI2s
	 /poSd/d2KzgTO+nCpu04FCx9tOW5vs6e2x7fRBOHs7Tl6ZR/JeHu+bARIbbgnlfwF6
	 t0n9CqVtZqYFDd27mvnUFT/hu8/sB1lFwCpvLTaMQ0D9xDjRiQLpsCbyeIWBXk/oEN
	 p6f9iyJTybiLEnXr42zbip7lFlxW8biWTrT3/ncKhtd38TCRfJXq2k6Hfh5nB1hRmT
	 qF6YXtlZzyA8CqwM24X92wKTcdXOzIoIrgnTzGd+X8rlfv9i8AROVRUB7kKCB9w9js
	 SJ6xDTj654+Iw==
Date: Mon, 12 Oct 2026 12:47:14 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>, Vishal Verma
 <vishal.l.verma@intel.com>, Fan Ni <nifan.cxl@gmail.com>, Li Ming
 <ming.li@zohomail.com>, Benjamin Cheatham <benjamin.cheatham@amd.com>,
 Gregory Price <gourry@gourry.net>, Richard Cheng <icheng@nvidia.com>, Anisa
 Su <anisa.su@samsung.com>
Subject: Re: [PATCH v16 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20261012124714.6556d6b4@jic23-hlaptop>
In-Reply-To: <20261010225852.10727-3-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
	<20261010225852.10727-3-anisa.su@samsung.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 11 Oct 2026 07:54:53 +0900
Anisa Su <anisa.su887@gmail.com> wrote:

> From: Ira Weiny <iweiny@kernel.org>
> 
> Devices which support Dynamic Capacity (DC) are configured via mailbox
> commands. CXL r4.0 section 9.13.3 describes the use of the Get DC
> Configuration command in order to obtain DCD partition characteristics.
> 
> Implement the DC mailbox commands as specified in CXL 4.0 section
> 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> information. Disable DCD if an invalid configuration is found.
> 
> Initial enablement for Linux only supports one dynamic capacity
> partition. Read all the partitions the device reports but validate
> only the first, and configure it as 'dynamic ram'.
> 
> The specification requires that volatile capacity starts at DPA 0 and
> pmem starts at the DPA immediately following it, but DC partitions only
> need to be 256MB aligned according to CXL r4.0 section 8.2.10.9.9.1
> Table 8-347. So a device could leave a gap between ram/pmem (static)
> capacity and its first DC partition, or between one DC partition and
> the next.
> 
> However, Linux chooses not to support gaps between static and dynamic
> capacity, and requires the first DC partition to begin at the DPA
> immediately following static capacity.
> 
> Based on an original patch by Navneet Singh.
> 
> Signed-off-by: Ira Weiny <iweiny@kernel.org>
> Co-developed-by: Anisa Su <anisa.su@samsung.com>
> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> Tested-by: Junhee Park <jh9934.park@samsung.com>
> Tested-by: Heesoo Kim <habil.kim@samsung.com>
> 

A couple of things inline.  Only one that matters I think is the
cleanup.h fragility  / readability thing about constructors and 
destructors needing to be near each other.  That bit of guidance
came from a specific (and I think correct) comment from Linus
that he really wanted them together and if that meant declaring
the variables inline rather than in old school c style, then so be
it.  That might be in category of things Dave could cleanup up whilst
applying if all else is ready but that's up to him.

Jonathan


> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 199bb986d674..72af23ba288e 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> +			     u8 partition_count,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> +		.partition_count = partition_count,
> +		.start_partition_index = start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in = &get_dc,
> +		.size_in = sizeof(get_dc),
> +		.size_out = dc_resp_size,
> +		.payload_out = dc_resp,
> +		/* The device must return at least the fixed header */
> +		.min_out = sizeof(*dc_resp),
> +	};
> +	size_t expected_sz;
> +	int rc;
> +
> +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	if (dc_resp->partitions_returned > partition_count) {
> +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> +			dc_resp->partitions_returned, partition_count);
> +		return -EIO;
> +	}
> +
> +	/* The trailing extent/tag counts (CXL r4.0 Table 8-346) are not read */
> +	expected_sz = struct_size(dc_resp, partition,
> +				  dc_resp->partitions_returned);
> +
> +	if (mbox_cmd.size_out < expected_sz) {
> +		dev_err(mbox->host,
> +			"Payload size %zu less than expected %zu for %u partitions\n",
> +			mbox_cmd.size_out,
> +			expected_sz,
> +			dc_resp->partitions_returned);

Not important, but if you do end up respinning, maybe don't have one parameter per line.
To me it doesn't really help with readability here.

> +		return -EIO;
> +	}
> +
> +/**
> + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> + *                         device.
> + * @mbox: Mailbox to query
> + * @dc_info: The dynamic partition information to return
> + *
> + * Read every partition the device reports, but validate only the first:
> + * Linux maps partition 0 and nothing else, so a defect in capacity the
> + * driver never touches is not a reason to refuse the device dynamic
> + * capacity.  The remaining partitions are read but not recorded.
> + *
> + * Return: 0 if identify was executed successfully, -ERRNO on error.
> + *         On error, @dc_info is left unchanged.
> + */
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS] = { };
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;

See the cleanup.h guidance.  This needs to move.

> +	struct device *dev = mbox->host;
> +	u8 avail_partitions = 0;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	u8 partition_count;
> +	size_t dc_resp_size;
> +
> +	/*
> +	 * Bound requested number of partitions by mailbox payload size. The
> +	 * 256 byte spec minimum, verified in cxl_pci_setup_mailbox(), keeps
> +	 * the subtraction below from underflowing.
> +	 */
> +	partition_count = min(CXL_MAX_DC_PARTITIONS,
> +			      (mbox->payload_size - sizeof(*dc_resp) -
> +			       sizeof(struct cxl_mbox_get_dc_config_tail)) /
> +			      sizeof(struct cxl_dc_partition));
> +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> +

	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) =
		kmalloc(dc_resp_size, GFP_KERNEL);
	if (!dc_resp)

Maybe if everything else is fine, Dave can tweak this whilst applying.

star> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	start_partition = 0;
> +	num_partitions = 0;
> +	do {
> +		int returned, rc;
> +
> +		returned = cxl_get_dc_config(mbox, start_partition,
> +					     partition_count, dc_resp,
> +					     dc_resp_size);
> +		if (returned < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", returned);
> +			return returned;
> +		}
> +
> +		if (returned == 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index %u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}
> +
> +		/* A DCD reports at least one partition (CXL r4.0 Table 8-346) */
> +		if (dc_resp->avail_partition_count == 0) {
> +			dev_err(dev, "Device reported no DC partitions\n");
> +			return -EIO;
> +		}
> +
> +		avail_partitions = min(dc_resp->avail_partition_count,
> +				       CXL_MAX_DC_PARTITIONS);
> +
> +		/*
> +		 * Only partition 0 is mapped, so it is the only one checked.
> +		 * The rest are read to complete the enumeration and dropped.
> +		 */
> +		if (start_partition == 0) {
> +			rc = cxl_dc_check(dev, &partitions[0],
> +					  &dc_resp->partition[0]);
> +			if (rc)
> +				return rc;
> +		}
> +
> +		num_partitions += returned;
> +		start_partition = num_partitions;

I may be missing something subtle, but do start_partition and num_partitions ever
differ in value? Far as I can spot they are both only updated here.  If they
change in later patches and this is churn reduction ignore this comment!


> +
> +	} while (num_partitions < avail_partitions);
> +
> +	/* Linux only supports the 1st partition; nothing to do if it is unavailable */
> +	if (partitions[0].size == 0)
> +		return -ENODEV;
> +
> +	*dc_info = partitions[0];
> +	dev_dbg(dev, "Returning partition 0 %#llx size %#llx\n",
> +		dc_info->start, dc_info->size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
