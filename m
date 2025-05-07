Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D081B87D5
	for <nvdimm@lists.linux.dev>; Wed,  7 May 2025 17:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746639653; cv=none; b=niJT+acLwK4M9bzNpBPoNhRZkaSj7jeKGBnxBRHwnEGArGfNOq2N06LdzPTPKwJM0KEabPkDHDtpgmvg31YENQy9eaPyuOmcDZBwzwu4k9ZjCFTjWhSKplRRCkO4wJSEnpvDFMZ9GWQY3baTKxtPQsoXdv4ojGmK2sbStscr6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746639653; c=relaxed/simple;
	bh=Geqh+D5uJmrUbt0m4p6Vua5oZHF+A+a0M3ZiP1mG2Us=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tv3jU1KgCc13B9eSdoyQS9lnZ5JKOcSndVkWjxTKBZzZlMG9TsqOWe7N3jOltjs+Y53MBsK+Skjg1Y+RSY2ekNI6NsbH6zCA58XeDYsa6J2XgC4mWwfgOi3dc99nkJgmNPcwK5FZQlZd6AgMitesDiKI0Zc1noY8ZR6KAWNRWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RfnnHaF6; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RfnnHaF6"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-70a1f2eb39aso1090157b3.1
        for <nvdimm@lists.linux.dev>; Wed, 07 May 2025 10:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746639650; x=1747244450; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PrNi7Flwgq4EBMVYXIrmQJ3ObEoQDpAla3Oaux526gs=;
        b=RfnnHaF6hPH+DFoeBea1wagrceJy8qCsUfDmJKbJNMsgkbGbS3pPziudP5RbPndjOZ
         LiNOLyhqe+FtpBTA+4ZcD5nntcY9f+HefvmJbpmtgIk5LaOkuBKib+6TLfG/If3UPr3U
         N/kj/1OBUlrGq4uBirI7AfEFfL8sOGLy8+jxhytHw5RcCDqQqdtbQIQCOnDPSucFMmRC
         8NH5lJqqlO4yUROTV9BTpXQRKcepAFz36OvNkkNpnNGOYWS2qXtXbJw8SY4sI2mgMNUn
         3d+BX/D4HeJ6DlOtKMrb2IjtLgAT+rIpRDR99Tx0lJx9fz7RJTp3fG3dIep6CGCMg0gw
         f3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746639650; x=1747244450;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrNi7Flwgq4EBMVYXIrmQJ3ObEoQDpAla3Oaux526gs=;
        b=HMwnUisijzMEG5WnMB5NhAwvS1wB554C7qpumKPUR/tWmNRzGMqoPlS02M/j1/UeO0
         xnQNse+JDSsSw/5zku1YUJO/LNPBcAMiH35qpUNP5l9Fh4a7zWBBLAQTEAqhISfWEh3k
         BW29CYqqvFYYomV8QJOb1jgAVCppg5/vh0lyS6vKw8kbwsKhaMsQChJVoQTvxllmdRPD
         sYoz3V6eZ5AfEVOobWqMZKrG1weTfFCSXOTk+RGXJRZKg5wH+/aVUQPLYPbP27X5GK9l
         xLA2RgWUhQr4eiDQFnuKY+KR/yPP3MOQ/hLJ/2XxfshBIHNTlyulmjgrhiXctN9RBueO
         XSfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKfFRwcJlQJ/hNwGFrkybjOrSmQTEzWOlW3cpP73KKRf3EM/W8nH8cUTf+V6L5llwo9zq8FKg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFphz1KRVwwZ1XjlLNlrjkcv3M7XcPcSQeZP3HT53BfmWvARU0
	Z6E+uhQ8ztWp0sBinjO2X+cSAx7cs6KkeuRrQXrgBZ4x4UIovb1C
X-Gm-Gg: ASbGncualnNDhg8r86fiQ1PCiXhV3kDNYgfVr4y3AgNdfo2piO6TTrZOTB+1SKu3vE1
	BR7fw6m2cNnBJqpofjQNnPPfqGnGSf2Qyvhd0eg9O86fwXBPUNrx0O4awynYkotbs0/YCkXSgdR
	jXnfNuhiIHCH3v6CHJZhJDNDQdqj0ZFrtKjpXDtgW66vqdo/vGRJkDnUYT0nrg+2NKEvt9J+i2s
	oag/m10WxfVcXW7GBg3nlzb+M+PZJtQSqx7JDYnAdgGJyouwQi0B6EjN7zxRC4diZ9oMkJPu3np
	YvS+Y9WEId7bSpOCrSmFdTw0
X-Google-Smtp-Source: AGHT+IHwA2DWyR9RT5bJAp/f5MqkoySq95Z1ilqvT6eJXShFtI+LYdAuNTXzjUiKjw5FKah3AzLgLA==
X-Received: by 2002:a05:690c:46c8:b0:709:17e4:4d27 with SMTP id 00721157ae682-70a2d0b77d9mr5083347b3.23.1746639650373;
        Wed, 07 May 2025 10:40:50 -0700 (PDT)
Received: from lg ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-708c3f0825csm34282207b3.21.2025.05.07.10.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 10:40:49 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 7 May 2025 10:40:47 -0700
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 02/19] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <aBubH5ZDVPEE8N98@lg>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-2-1d4911a0b365@intel.com>

On Sun, Apr 13, 2025 at 05:52:10PM -0500, Ira Weiny wrote:
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
> as 'dynamic ram A'.  Additional partitions can be added in the future if
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
>  drivers/cxl/core/hdm.c  |   2 +
>  drivers/cxl/core/mbox.c | 179 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |   1 +
>  drivers/cxl/cxlmem.h    |  54 ++++++++++++++-
>  drivers/cxl/pci.c       |   3 +
>  5 files changed, 238 insertions(+), 1 deletion(-)
...
>  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
>  struct cxl_mbox_set_timestamp_in {
>  	__le64 timestamp;
> @@ -845,9 +871,24 @@ enum {
>  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
>  			  struct cxl_mbox_cmd *cmd);
>  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> +
> +struct cxl_mem_dev_info {
> +	u64 total_bytes;
> +	u64 volatile_bytes;
> +	u64 persistent_bytes;
> +};

Defined, but never used.

Fan

> +
> +struct cxl_dc_partition_info {
> +	size_t start;
> +	size_t size;
> +};
> +
> +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> +			struct cxl_dc_partition_info *dc_info);
>  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
>  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
>  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
>  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev);
>  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
>  				unsigned long *cmds);
> @@ -860,6 +901,17 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
>  			    const uuid_t *uuid, union cxl_event *evt);
>  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
>  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> +
> +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> +{
> +	return mds->dcd_supported;
> +}
> +
> +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> +{
> +	mds->dcd_supported = false;
> +}
> +
>  int cxl_set_timestamp(struct cxl_memdev_state *mds);
>  int cxl_poison_state_init(struct cxl_memdev_state *mds);
>  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 7b14a154463c..bc40cf6e2fe9 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -998,6 +998,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (rc)
>  		return rc;
>  
> +	if (cxl_dcd_supported(mds))
> +		cxl_configure_dcd(mds, &range_info);
> +
>  	rc = cxl_dpa_setup(cxlds, &range_info);
>  	if (rc)
>  		return rc;
> 
> -- 
> 2.49.0
> 

-- 
Fan Ni
