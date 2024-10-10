Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D221EABD3
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584720; cv=none; b=Gh3oZBehENB6RLck2zENqoltsyfCwnnNl880Tzb1hxoDqNgvJ2cUru7FO/RWz0VBkUaI2G2m6uZbtYvK33hcVakQGgQbEnNaHj6t1VLeHMQKV9vqaxGzqFBVMeKgm5b4W2t4NDKGTXHDOBCq0cC0BsVA4z+XRDJCzzi+sYx2WUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584720; c=relaxed/simple;
	bh=2rGxLzL4a1zBXPkYNtUom2nw03PtlluwPsJOr68+WtY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0A1CGvShOsh5fw/E/BJxq6wuHUt6oILMHHQaP4exUyZzZt/6uhsUk0hK5iMYCLtzrpJEM+kEAazk0cFR776kmf3YSy8GD8xAgZrT6m8e/0xSEqsjHm+WFZv9x4hFlu33dS8XuTvLGozsZMSEZ3ErINAlMDV2Fu6xuP7Ej16wqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=On9DKox4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="On9DKox4"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20b90ab6c19so12398575ad.0
        for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728584717; x=1729189517; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FCZKAEGut2Fz9y7VqNxcbBwx+dx2pjvlA/aSvDU2Nhg=;
        b=On9DKox4K8Swh88+n2I6R/ISPB+x1g5pXzJ+wnswu0+Qx/3vVCtNWVMn2fJ+aUUQ7s
         XWeu8xRfYaInfXQh5/hhRPYZZUfVu5vVcvTwd3RnMd/am36slKlTX3LEXECWcx6Plo4A
         b6AzGLXsC0BK+3igKsnApjcjoYoT+biHPRtmERPoCkxkiLbQtQeMjMnxhjUbRHeyUMgR
         It6aEE2FmmDH2cQfVlgFu6Fi+4wEWKhsV8sTaEqSj9ercd+I/e14Bj8McbNkWMp4BN1C
         FMhB6srf5IxdLL/Y0eT/nV48TFSt5ecMdOs60llSZ3/WOSuEG8MEdu7jT35Qkxh78WpC
         vXMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584717; x=1729189517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FCZKAEGut2Fz9y7VqNxcbBwx+dx2pjvlA/aSvDU2Nhg=;
        b=Qwk6QzPmsKK+8FBqdPc07k8dv7BQFF50a3LYWloBoX32ZDJAbGGvf2TZ8mfXrdkZB8
         AEaa3BefRLXVcBLDnjLaiLq1/KQM1wp1yNCGfMGc9jpHz4uB16evewoAoRa1ZP7yTcCc
         w6viZcsv5VWAlXx3jrPC3BJPL3WeJPLghYfZ4kQRKlG9YWWRNBQfmSL9YQxeWQBd3IBZ
         iRAQ7+hJ4eJijUVduG0BBPF4dRvUZ4drrO+nFG+4h9aBNAffVtkKX+iWhNjjODPuLw5+
         lJNNHhqDD+VohiHgabiaUFZV3pcutv0KNtU4w5EwQMPngxIq4hqrefHNNBfp6ds06KVu
         St6w==
X-Forwarded-Encrypted: i=1; AJvYcCULRcKAuiYXzx97IhQ4Zhx1ceSzkzCdFXrSOFOWXbUC8cqDxJSyTJETlq9KktIguXKFvvtQC6o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCyT9xsuvWBF+CR6FIFX4CIHV8gKjJ4kewii3OFUSorgBc9APl
	pjGLw124OBIZoVKlpgDCpw01hOWhCPUpZrluMfARzzDSpO+jUhbm
X-Google-Smtp-Source: AGHT+IHc42Q5P+w1wk3Fgq7/XkeeKpbIEIscynXSdbvC3/s2GAAsoEzVIy0pSdpH3PtVv2yfyyf8lA==
X-Received: by 2002:a17:902:d548:b0:20b:8325:5a1e with SMTP id d9443c01a7336-20c9d905c2fmr7134325ad.36.1728584717333;
        Thu, 10 Oct 2024 11:25:17 -0700 (PDT)
Received: from fan ([2601:646:8f03:9fee:c165:c800:4280:d79b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c0eb470sm12140735ad.126.2024.10.10.11.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 11:25:17 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 10 Oct 2024 11:25:13 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 19/28] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <ZwgcCRTl3x2H8Ze5@fan>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
 <20241007-dcd-type2-upstream-v4-19-c261ee6eeded@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007-dcd-type2-upstream-v4-19-c261ee6eeded@intel.com>

On Mon, Oct 07, 2024 at 06:16:25PM -0500, ira.weiny@intel.com wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> Dynamic Capacity Devices (DCD) support extent change notifications
> through the event log mechanism.  The interrupt mailbox commands were
> extended in CXL 3.1 to support these notifications.  Firmware can't
> configure DCD events to be FW controlled but can retain control of
> memory events.
> 
> Configure DCD event log interrupts on devices supporting dynamic
> capacity.  Disable DCD if interrupts are not supported.
> 
> Care is taken to preserve the interrupt policy set by the FW if FW first
> has been selected by the BIOS.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [iweiny: rebase on 6.12]
> ---
>  drivers/cxl/cxlmem.h |  2 ++
>  drivers/cxl/pci.c    | 72 +++++++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 62 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index c3b889a586d8..2d2a1884a174 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -226,7 +226,9 @@ struct cxl_event_interrupt_policy {
>  	u8 warn_settings;
>  	u8 failure_settings;
>  	u8 fatal_settings;
> +	u8 dcd_settings;
>  } __packed;
> +#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
>  
>  /**
>   * struct cxl_event_state - Event log driver state
> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index c6042db0653d..2ba059d313c2 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -672,23 +672,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
>  }
>  
>  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> -				    struct cxl_event_interrupt_policy *policy)
> +				    struct cxl_event_interrupt_policy *policy,
> +				    bool native_cxl)
>  {
>  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> +	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
>  	struct cxl_mbox_cmd mbox_cmd;
>  	int rc;
>  
> -	*policy = (struct cxl_event_interrupt_policy) {
> -		.info_settings = CXL_INT_MSI_MSIX,
> -		.warn_settings = CXL_INT_MSI_MSIX,
> -		.failure_settings = CXL_INT_MSI_MSIX,
> -		.fatal_settings = CXL_INT_MSI_MSIX,
> -	};
> +	/* memory event policy is left if FW has control */
> +	if (native_cxl) {
> +		*policy = (struct cxl_event_interrupt_policy) {
> +			.info_settings = CXL_INT_MSI_MSIX,
> +			.warn_settings = CXL_INT_MSI_MSIX,
> +			.failure_settings = CXL_INT_MSI_MSIX,
> +			.fatal_settings = CXL_INT_MSI_MSIX,
> +			.dcd_settings = 0,
> +		};
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		policy->dcd_settings = CXL_INT_MSI_MSIX;
> +		size_in += sizeof(policy->dcd_settings);
> +	}
>  
>  	mbox_cmd = (struct cxl_mbox_cmd) {
>  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
>  		.payload_in = policy,
> -		.size_in = sizeof(*policy),
> +		.size_in = size_in,
>  	};
>  
>  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> @@ -735,6 +746,31 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
>  	return 0;
>  }
>  
> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> +			struct cxl_event_interrupt_policy *policy,
> +			bool native_cxl)
> +{
> +	struct cxl_dev_state *cxlds = &mds->cxlds;
> +	int rc;
> +
> +	if (native_cxl) {
> +		rc = cxl_event_irqsetup(mds, policy);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
> +		if (rc) {
> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> +			cxl_disable_dcd(mds);
> +			return rc;

If the device has both static and dynamic capacity, return an error code
here will cause cxl_event_config() return early, and
cxl_mem_get_event_records() will not be called, will it be an issue?

Fan

> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static bool cxl_event_int_is_fw(u8 setting)
>  {
>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> @@ -761,17 +797,25 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
>  	struct cxl_event_interrupt_policy policy = { 0 };
> +	bool native_cxl = host_bridge->native_cxl_error;
>  	int rc;
>  
>  	/*
>  	 * When BIOS maintains CXL error reporting control, it will process
>  	 * event records.  Only one agent can do so.
> +	 *
> +	 * If BIOS has control of events and DCD is not supported skip event
> +	 * configuration.
>  	 */
> -	if (!host_bridge->native_cxl_error)
> +	if (!native_cxl && !cxl_dcd_supported(mds))
>  		return 0;
>  
>  	if (!irq_avail) {
>  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
> +		if (cxl_dcd_supported(mds)) {
> +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
> +			cxl_disable_dcd(mds);
> +		}
>  		return 0;
>  	}
>  
> @@ -779,10 +823,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	if (!cxl_event_validate_mem_policy(mds, &policy))
> +	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
>  		return -EBUSY;
>  
> -	rc = cxl_event_config_msgnums(mds, &policy);
> +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
>  
> @@ -790,12 +834,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  	if (rc)
>  		return rc;
>  
> -	rc = cxl_event_irqsetup(mds, &policy);
> +	rc = cxl_irqsetup(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
>  
>  	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
>  
> +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> +		native_cxl ? "OS" : "BIOS",
> +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> +
>  	return 0;
>  }
>  
> 
> -- 
> 2.46.0
> 

-- 
Fan Ni
