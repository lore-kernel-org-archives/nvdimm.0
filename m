Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFE42D1916;
	Thu, 25 Jun 2026 18:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411398; cv=none; b=OqginbBG1Bl41qlZJ6XFnc4V0deTPzqndYG+CNvcFLpvqlXRvnwRr6uGvZpvQBsvAhyXLP0vVZUZcpqYjb3EP13He/ZNowDuHuevJAPSfxgKWApw59pEPxbxph3TSR8MeAfijpGXku9zmLswwvJQp9Jy5a+p7/+nh0Gng/VEYeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411398; c=relaxed/simple;
	bh=nKtKH++GDCQ3O0nWan6D7cDvcnXH78ltPp9d5ju0fIQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aKiu79coaMXQJCMvRo8c80h7+/Cca/O1Ksnq2OCQARAl0Ey1Kh8ezBYvkpHOPmINDlqz4mK8dHC3mHgv348UHc7CLsxLUGEOUY2JJcfR33fSSpDIZWQdTZJsOEkOXcQPBZjBtDX6DIrD+PvPn9LDjeVQdpNt4a49dGXDbfv/e7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvwRY8qO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvwRY8qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59BD1F00A3A;
	Thu, 25 Jun 2026 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411397;
	bh=J134Doi1Icgfnp+jhatvuvWwQ1r5w7UWZ22Dqsal5eE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HvwRY8qOOxVd6WSLqr1cRRoaV1Mip9A1c4GK+E0DGjQIS8zIbbCgzBgbIZfawzjhp
	 jQ2TBxT4FdckLclkBHsmv5PNc4Ks7yKl6vngK3QGfb+25eEYS3kBfL3Khy6z2h9Mts
	 A19yGXBgyC1ePiZnGA6MsrPLzOzRkKVEW2iHUSciKaofDHR8ARqM20poDEvXPU7P6p
	 9wenPiIz/x2y/Fc9u64PcTNjhR4R41QwQabHsEnNctFFLKyk7CxL/FlrV6ih2PBCu8
	 cCOUw5b6SUJe0eE/ngvTQ/daiodpQKM4riOtt9AMb+gA5rrVGG81pBJjmcpN84p+1X
	 OE4aTxVSn+hug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 02/31] cxl/mem: Read dynamic capacity configuration
 from the device
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-3-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:16:36 +0000
Message-Id: <20260625181636.E59BD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Mailbox payload size statically requests too many partitions, fail=
ing initialization on devices with small mailboxes.
- [High] Incorrect unit conversion of DC partition decode_length causes sev=
ere integer overflow.
- [High] Logic Error in DPA Skip Check mathematically guarantees failure, b=
reaking DCD on all devices.
- [Medium] Valid CXL devices configured with 0 Dynamic Capacity partitions =
are erroneously treated as having an I/O error.
--

commit cbb0f735b5888cbb19cb493b31cc330ef3afdadf
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Read dynamic capacity configuration from the device

This commit implements the mailbox commands to read Dynamic Capacity
partition configurations from CXL devices. It validates the partitions
and configures the first partition as dynamic RAM.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 07aba6f0b7194..2932bbd67e550 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -1347,6 +1347,188 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u1=
6 cmd)

[ ... ]

> +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info=
 *part_array,
> +			u8 index, struct cxl_dc_partition *dev_part)
> +{
> +	u64 blk_size =3D le64_to_cpu(dev_part->block_size);
> +	u64 len =3D le64_to_cpu(dev_part->length);
> +
> +	part_array[index].start =3D le64_to_cpu(dev_part->base);
> +	part_array[index].size =3D le64_to_cpu(dev_part->decode_length);
> +	part_array[index].size *=3D CXL_CAPACITY_MULTIPLIER;

[Severity: High]
Is it correct to multiply decode_length by CXL_CAPACITY_MULTIPLIER here?

The CXL specification provides the decode length in bytes, similar to the=20
base and length fields. Multiplying this by 256MB will cause a 64-bit=20
integer overflow for capacities of 64GB or larger. This overflow can wrap=20
around to a small value, bypassing the later DPA ordering checks and=20
registering a corrupted partition size.

[ ... ]

> +/* Returns the number of partitions in dc_resp or -ERRNO */
> +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partitio=
n,
> +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> +			     size_t dc_resp_size)
> +{
> +	struct cxl_mbox_get_dc_config_in get_dc =3D (struct cxl_mbox_get_dc_con=
fig_in) {
> +		.partition_count =3D CXL_MAX_DC_PARTITIONS,
> +		.start_partition_index =3D start_partition,
> +	};
> +	struct cxl_mbox_cmd mbox_cmd =3D (struct cxl_mbox_cmd) {
> +		.opcode =3D CXL_MBOX_OP_GET_DC_CONFIG,
> +		.payload_in =3D &get_dc,
> +		.size_in =3D sizeof(get_dc),
> +		.size_out =3D dc_resp_size,
> +		.payload_out =3D dc_resp,
> +		.min_out =3D 8,
> +	};

[ ... ]

> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info)
> +{
> +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree);
> +	struct device *dev =3D mbox->host;
> +	u8 start_partition;
> +	u8 num_partitions;
> +	size_t dc_resp_size =3D struct_size(dc_resp,
> +					  partition,
> +					  CXL_MAX_DC_PARTITIONS);

[Severity: High]
Can this static size calculation cause initialization failures on devices=20
with small mailboxes?

The code requests CXL_MAX_DC_PARTITIONS (8 partitions), resulting in an=20
expected response payload size of 328 bytes (an 8-byte header plus 8=20
40-byte partition entries). However, the CXL specification allows a minimum=
=20
mailbox payload size of 256 bytes.=20

If a device has a mailbox smaller than 328 bytes, cxl_internal_send_cmd()=20
will unconditionally fail with -E2BIG. Should the requested number of=20
partitions be dynamically bounded by the device's negotiated payload size?

> +	dc_resp =3D kmalloc(dc_resp_size, GFP_KERNEL);
> +	if (!dc_resp)
> +		return -ENOMEM;
> +
> +	/**
> +	 * Read and check all partition information for validity and potential
> +	 * debugging; see debug output in cxl_dc_check()
> +	 */
> +	start_partition =3D 0;
> +	num_partitions =3D 0;
> +	do {
> +		int rc, i, j;
> +
> +		rc =3D cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
> +		if (rc < 0) {
> +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> +			return rc;
> +		}
> +
> +		if (rc =3D=3D 0) {
> +			dev_err(dev,
> +				"Device reported %u partitions available but returned none at index =
%u\n",
> +				dc_resp->avail_partition_count, start_partition);
> +			return -EIO;
> +		}

[Severity: Medium]
Does this unintentionally fail on valid devices configured with 0 Dynamic=20
Capacity partitions?

If a device supports DCD but is configured with zero partitions,=20
avail_partition_count is 0, and cxl_get_dc_config() legitimately returns 0.=
=20
This path treats it as a hard error and returns -EIO, logging a confusing=20
error message instead of cleanly disabling DCD and proceeding.

[ ... ]

> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info=
 *info)
> +{
> +	struct cxl_dc_partition_info dc_info =3D { 0 };
> +	struct device *dev =3D mds->cxlds.dev;
> +	int rc;
> +
> +	rc =3D cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> +	if (rc) {
> +		dev_warn(dev,
> +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> +		cxl_disable_dcd(mds);
> +		return;
> +	}
> +
> +	/* Skips between pmem and the dynamic partition are not supported */
> +	if (dc_info.start !=3D info->size) {
> +		dev_warn(dev,
> +			 "Dynamic Capacity skip from pmem not supported\n");
> +		cxl_disable_dcd(mds);
> +		return;
> +	}

[Severity: High]
Is it intended to compare dc_info.start against info->size here?

Because cxl_mem_dpa_fetch() initializes info->size to mds->total_bytes,=20
it already includes the dynamic capacity. This means dc_info.start will=20
always be strictly less than info->size, causing this skip check to falsely=
=20
fail on every valid device with a DC partition and breaking DCD entirely.

> +
> +	info->size +=3D dc_info.size;

[Severity: High]
Does this inadvertently double-count the dynamic capacity?

Since info->size already includes the total device capacity, adding=20
dc_info.size here will inflate the total DPA span incorrectly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D2
