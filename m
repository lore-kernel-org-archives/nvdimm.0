Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C925930100D
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 06:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784096816; cv=none; b=QINz8mHfThv9taBuVZ4IkwVjdwI6CHVdYOq3ASAiW+xLZQuHqPTtHiAU89e0fTtU4hODnMsySFBzBEM3/lf2WRPVj1PAOBHM+grAE0peIQYR7bBVSIvnMKmt6yK5AXWDY0cE1LKnn/xr67GyQP4PfJGbK523G0AsakgPRpoFTgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784096816; c=relaxed/simple;
	bh=XZFtM14MtZhwFjDpfZO9/a88x840ePr2yxhaphV/+sE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abDZQg2lDxZTJRPTXU/PMUeHzunBOMk1AVFsNZfyIVatGEtciOFSKaC4ghvUHDDWVgiuIieBUhqaJFtZQUvEJyHSaOXN9IqrS/ut9heikI6sNalQEdfeiGLTWP5CgtOurwfFHLHTY2ThL05cKR5DGa6CcOjsTav96/gzKkXFzn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c0TcZZyF; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c0TcZZyF"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38759bcd877so4426762a91.2
        for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 23:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784096814; x=1784701614; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RNjB/18ZjX1BoG8WcSx8UlkekMWL3ErJWmxvHjaYP4s=;
        b=c0TcZZyFMwvD50THkExmiZ/SvBEngdvwggR8rqcySwyEIu08uNKqkXnUJw0src9bnF
         Fs9JYgJDuSS0BgfyEK5QLfSXCUa9/+wP8OTL7bYD0zgUWQeB/oYjwPfes57wmml+lKm5
         e20rEIWu71vm1RELEPGrmUQaqNQq2xM9gpqjK5zIIKiJbzLhYYFOPQv/7E4zG5hbir5r
         Eh8qZ8CY32OxQNdpz+Obul43vilHTXZRutERvkoloHxIFM55cFvWfD8QM2fmmrjjpAsM
         18FnmE5/ALoAzYTawPIYy6ree+KpCqjGRsSpuiPE953f5i8NrhNVnsxHmQCdZHwh0E/T
         mJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784096814; x=1784701614;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RNjB/18ZjX1BoG8WcSx8UlkekMWL3ErJWmxvHjaYP4s=;
        b=V5+PC6q/Fy9Z3XHs+vuzpg+qQ/qEmwHlXoomj91k3LF8zgqjF4GrNFk/AiA4p5Z4dZ
         ZKxUpfKo9XON7pJwz2NFHjVOhv7x7X8IHG01MvXGbsj03elHP0To5qwA7sSMjyhI8Pdq
         d/YwEj3U6n/aMa65mA5V9HP7+aKlZGAlpl6D4SRHPAAtkK0KP36h9mQl+JabNxetGS7F
         p+4ezto/x0B5GEZ0fJZ+I8GslKqRZhtDp87HIXADveNflpVLbeXGFOo67rOZj9pJ6YYN
         hY7MA4XpWuBTo567Lec12PJxxuyuAJi15GBmINI/ppjlQfdHzFBFiV5DASsnyuP97dbV
         GTEQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp6UWOpBufiawgvv2ONMJLc44IYJE4Mbx2t49a3sNhm3VM01P1keBJLrncP+Iz+i6e7mYdOP40=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZn/WBFf+S/WT1pJSnEJ9mBVTKfqTZnWSzLepoFkT0+BclMaKN
	lhlgUnsVBpTzpGhuud7ugvpKvmnLxI18tywyjxxu48Qcw/4TTjOHl9jE
X-Gm-Gg: AfdE7ckJxgl+3TfHFQYOD9d/nfrcPVmq3VDYWQmyatefViJGBqLDzThaPcJwa3BkMcR
	vWZuVtvc+V6ncPR4NOcIE/7losCVwSWt/4Uq1v6MovFJ+FagEyoZMbyZrYZF5919/x8ptaDkwDx
	3unVyS35k3RyxN2QPAMrpDameg7jePvBYsr+K0zSDnnDqO/7rG1EwMu+04VIcpyBkyhQyHbCdaY
	lTIDA/6bmCJ9OmBzgQ+E7BR2wPTt8GGBzB2tb00hJyEwf6PA1aQsrj/bx7AQyL3RIN9aqUS74ix
	xDh0XkUPPDTe+VYChRGbKBI5x3Pj4Wf+qxSg0geCIkWOToHm39SnIFinrolrGsUUs+/MZ9GXkIV
	pBOsqX2/x4NqrSgtbLtT9QqnVuteHQpn3eE1wECc9yca9UiJpfZB44wh8xanWRBZVbB5XlZJX7x
	2Wz6/RknJTRwES6qJj2I1dNvSf5WNlERmotY2Xd2BPOotvAGKwLHn8BeaT1fadLTZL+QCR
X-Received: by 2002:a05:6a20:9183:b0:3bf:d62f:44e1 with SMTP id adf61e73a8af0-3c36c35d250mr1891705637.53.1784096813979;
        Tue, 14 Jul 2026 23:26:53 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31189cd8234sm79742519eec.9.2026.07.14.23.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 23:26:53 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 14 Jul 2026 23:26:53 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v11 02/31] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <alcoLW9717L-GuLN@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-3-anisa.su@samsung.com>
 <20260625181636.E59BD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625181636.E59BD1F00A3A@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:16:36PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Mailbox payload size statically requests too many partitions, failing initialization on devices with small mailboxes.

fine... I fixed it but I find it unlikely for a DCD to have the minimum 256B
mailbox size

> - [High] Incorrect unit conversion of DC partition decode_length causes severe integer overflow.

false pos
explained below

> - [High] Logic Error in DPA Skip Check mathematically guarantees failure, breaking DCD on all devices.
false pos
explained below

> - [Medium] Valid CXL devices configured with 0 Dynamic Capacity partitions are erroneously treated as having an I/O error.

false pos. Partition info is only requested if mds->dcd_supported, which is set
to true if the device supports the full set of DCD commands. If the
device supports the commands and has 0 partitions that is an error.

> --
> 
> commit cbb0f735b5888cbb19cb493b31cc330ef3afdadf
> Author: Ira Weiny <iweiny@kernel.org>
> 
> cxl/mem: Read dynamic capacity configuration from the device
> 
> This commit implements the mailbox commands to read Dynamic Capacity
> partition configurations from CXL devices. It validates the partitions
> and configures the first partition as dynamic RAM.
> 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 07aba6f0b7194..2932bbd67e550 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1347,6 +1347,188 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
> 
> [ ... ]
> 
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
> [Severity: High]
> Is it correct to multiply decode_length by CXL_CAPACITY_MULTIPLIER here?
> 
it is.

> The CXL specification provides the decode length in bytes, similar to the 
> base and length fields. Multiplying this by 256MB will cause a 64-bit 

r4.0 8.3.10.9.9.1 Table 8-347 "Region Decode Length" The
device-assigned number of bytes of DPA that this region consumes, in
multiples of 256MB"

decode length is provided in multiples of 256B. This conversion is
necessary to get actual # of bytes.

> integer overflow for capacities of 64GB or larger. This overflow can wrap 
> around to a small value, bypassing the later DPA ordering checks and 
> registering a corrupted partition size.
> 
> [ ... ]
> 
> > +/* Returns the number of partitions in dc_resp or -ERRNO */
> > +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> > +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> > +			     size_t dc_resp_size)
> > +{
> > +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> > +		.partition_count = CXL_MAX_DC_PARTITIONS,
> > +		.start_partition_index = start_partition,
> > +	};
> > +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> > +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> > +		.payload_in = &get_dc,
> > +		.size_in = sizeof(get_dc),
> > +		.size_out = dc_resp_size,
> > +		.payload_out = dc_resp,
> > +		.min_out = 8,
> > +	};
> 
> [ ... ]
> 
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info)
> > +{
> > +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> > +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree);
> > +	struct device *dev = mbox->host;
> > +	u8 start_partition;
> > +	u8 num_partitions;
> > +	size_t dc_resp_size = struct_size(dc_resp,
> > +					  partition,
> > +					  CXL_MAX_DC_PARTITIONS);
> 
> [Severity: High]
> Can this static size calculation cause initialization failures on devices 
> with small mailboxes?
> 
> The code requests CXL_MAX_DC_PARTITIONS (8 partitions), resulting in an 
> expected response payload size of 328 bytes (an 8-byte header plus 8 
> 40-byte partition entries). However, the CXL specification allows a minimum 
> mailbox payload size of 256 bytes. 
> 
> If a device has a mailbox smaller than 328 bytes, cxl_internal_send_cmd() 
> will unconditionally fail with -E2BIG. Should the requested number of 
> partitions be dynamically bounded by the device's negotiated payload size?
> 
Fixed. # of partitions requested per iteration of the loop
capped to mailbox size.

> > +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> > +	if (!dc_resp)
> > +		return -ENOMEM;
> > +
> > +	/**
> > +	 * Read and check all partition information for validity and potential
> > +	 * debugging; see debug output in cxl_dc_check()
> > +	 */
> > +	start_partition = 0;
> > +	num_partitions = 0;
> > +	do {
> > +		int rc, i, j;
> > +
> > +		rc = cxl_get_dc_config(mbox, start_partition, dc_resp, dc_resp_size);
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
> 
> [Severity: Medium]
> Does this unintentionally fail on valid devices configured with 0 Dynamic 
> Capacity partitions?
> 
> If a device supports DCD but is configured with zero partitions, 
> avail_partition_count is 0, and cxl_get_dc_config() legitimately returns 0. 
> This path treats it as a hard error and returns -EIO, logging a confusing 
> error message instead of cleanly disabling DCD and proceeding.
> 
> [ ... ]
> 
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > +{
> > +	struct cxl_dc_partition_info dc_info = { 0 };
> > +	struct device *dev = mds->cxlds.dev;
> > +	int rc;
> > +
> > +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> > +	if (rc) {
> > +		dev_warn(dev,
> > +			 "Failed to read Dynamic Capacity config: %d\n", rc);
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
> > +	}
> 
> [Severity: High]
> Is it intended to compare dc_info.start against info->size here?
> 
> Because cxl_mem_dpa_fetch() initializes info->size to mds->total_bytes, 
> it already includes the dynamic capacity. 

no it doesn't. it only includes ram and pmem partitions.

> This means dc_info.start will 
> always be strictly less than info->size, causing this skip check to falsely 
> fail on every valid device with a DC partition and breaking DCD entirely.
> 
> > +
> > +	info->size += dc_info.size;
> 
> [Severity: High]
> Does this inadvertently double-count the dynamic capacity?
> 
no.

> Since info->size already includes the total device capacity, adding 
> dc_info.size here will inflate the total DPA span incorrectly.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=2
