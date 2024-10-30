Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D53F1C5799
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 17:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311104; cv=none; b=nLiBT8osR1LVq/+gFGz7baGGa0JBoWSimzvSqwg+flkEvcgHPeorrgGkfqUacosDWFhXDLOl32R3ajLs8XdW0K0rVvuN91ybRy1bya6/D1QCVufpqJg+f06ApELOOnY0QQAjCDkWIduExqRZPSuyNyMmARyKwguOV6oZkiV87EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311104; c=relaxed/simple;
	bh=b2QWmDPGvrQQakZ3yyj92L5m0kvTMJEUresIXpcvjDE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SwW1G7QT5AKeU296LJEUn0v6y8V+b/i7hK28zAYhshhDMnQHhYqAeCH+IDBnNzY7Ugzv377gFMdr7j3Y4Igs1EePUCsvHxjy/fEbf94hgOJJEv1J4m2zAeyKW+VMVRYv13k1hAP3wQGJDhWVRVy7Y3kvQBUJ1rlyBEIyAvL0/yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JamnxPCl; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JamnxPCl"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e2bdbdee559so66336276.1
        for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 10:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730311101; x=1730915901; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0vN1h3O3dKUxA7JWosc/tJ5ea1bFUY9OVqyu23fqmKM=;
        b=JamnxPClxgSJ4UJOOjxGzXrSM2gSxXkdHR9S1aMnNSQk+xuGAYWBTK+oEVAPG2U8Ei
         fYXR0nrA8GfbWMkbvWEKdUWio2YxdYmN5rVk6ILR3F4s6KbLaxdnrCVDZW/rcevrbwlJ
         TOpPkqdwIvW4lPp384efhc3J72//Yeo5PhH1Osl4RIxfAz6FAWQv7sjCseggpVsNdrk9
         BODhKanQ/Oq4nZGaN3QX3QoI4RWqAL//XbyO9BYr3dJiv8DtkDkf+wGBdxKDX3A0lruJ
         rk2ha5n/txQlCqLyeBzBUmVwdrpyInU6/SCyn3HGyS0f23HsXeFiZSh0hSz3ZoNpl+Qr
         uasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730311101; x=1730915901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vN1h3O3dKUxA7JWosc/tJ5ea1bFUY9OVqyu23fqmKM=;
        b=wesAf527y1CVD+wlLy8JTz4i9T7qrxcATRnAkJrmTkY36Nf0xfF/yGXRe1WZejFZ4K
         CdRXJvpvIohC5j8zahOhz6u8yQxsninq3YxNrpkBxt4M5h2t5r9F9qhkcHw8hh9FTCRG
         Usn4qniEUKlWcl+p5s6Jt1AsR9jbLOjLGw9emkiSDjNoNesghAW1QG0frTbE63Y0NHTU
         7cjq/pK26LZBMOH2byOlnnmZXRgH6jsnDKCop3yUMFBqdm5aX7E4YkFJ/g3uevhHnjPf
         EV0CFPRIayceC+IwZkCYmRNigY/Tg8q9jwCB9ckY/MNv3n8yI0vV5z297kpGx0lkyBYI
         as8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsqFz7K6S3/hyPrQ2R0tSmGUgzxEgoZDNhS2bY2Z8N+kPjYjUma7RfRR+M3hO1KxFef5Hk2BU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeUCYy55Mpmg58Uw9yraH2eXVflRvNhzWak5O97NtHXQknl4UD
	Yowea7EClW4jck4XQ78nqmG+8qG7XmhpNiLfPSFN/9cve0oTGZ7a
X-Google-Smtp-Source: AGHT+IHYEO2eDakHW83hTPyVRwAd+bY9lmzGvwij7PUySr/auc7P4VzlKoZIXU0KuxL8gIkwRswRsA==
X-Received: by 2002:a05:6902:1ac6:b0:e30:d97a:d18c with SMTP id 3f1490d57ef6-e30d97ad2d6mr2275518276.42.1730311100975;
        Wed, 30 Oct 2024 10:58:20 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e3079d95e7dsm2411242276.25.2024.10.30.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 10:58:20 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Wed, 30 Oct 2024 10:58:14 -0700
To: ira.weiny@intel.com
Cc: Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Li Ming <ming4.li@intel.com>
Subject: Re: [PATCH v5 18/27] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <ZyJztpWolMiYFN-j@fan>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
 <20241029-dcd-type2-upstream-v5-18-8739cb67c374@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029-dcd-type2-upstream-v5-18-8739cb67c374@intel.com>

On Tue, Oct 29, 2024 at 03:34:53PM -0500, ira.weiny@intel.com wrote:
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
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Li Ming <ming4.li@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
> Changes:
> [Fan: Don't fail probe on DCD irq failure, just disable dcd and print error]

Reviewed-by: Fan Ni <fan.ni@samsung.com>

Fan
> [Jonathan: move zero'ing of policy to this patch]
> ---
>  drivers/cxl/cxlmem.h |  2 ++
>  drivers/cxl/pci.c    | 73 ++++++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 62 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index 204f7bd9197bd1a02de44ef56a345811d2107ab4..16e06b59d7f04762ca73a81740b0d6b2487301af 100644
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
> index ac085a0b4881fc4f074d23f3606f9a3b7e70d05f..13672b8cad5be4b5a955a91e9faaba0a0acd345a 100644
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
> @@ -735,6 +746,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static bool cxl_event_int_is_fw(u8 setting)
>  {
>  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> @@ -760,18 +795,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
>  			    struct cxl_memdev_state *mds, bool irq_avail)
>  {
> -	struct cxl_event_interrupt_policy policy;
> +	struct cxl_event_interrupt_policy policy = { 0 };
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
> @@ -779,10 +822,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
> @@ -790,12 +833,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
> 2.47.0
> 

-- 
Fan Ni
