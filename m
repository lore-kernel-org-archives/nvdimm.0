Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003643A2E08
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 08:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780906579; cv=none; b=JmKHgl8S8L77MC4p+u5IeLiML2M1NEYNVPOnDE9rCmDyZJrmTThO6nXlG6QcepqZbjSX3Vt26/Dvi9d8KvRuNY9nYv46BKzOaH3eImq2MpF+nbpEYAftZGSwsrGXmQu8nsdTZxc7bdagqAO42omElFFXjIScpycZCzPwPZLuqvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780906579; c=relaxed/simple;
	bh=2vKaBxTvz9jzeINMZsZsLZHSkx1hCtUNqNqQFAN63mo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NkDIcz1YaRxQ1AV6lS83FxG/t22PdyEp9+HXTLRPbbRYf/MnOolFoh4nD5SUu+Gflxjuf/SxMDIC4RxCnecY0te5zAdtPtX0wcfZAjiNSS6ItBv10HHqZaGiIgYqvfipSwF1VD5dXnjbLJU6XVPc1igX/bS7bYaXVoKjnDIDiZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yz5qlz22; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yz5qlz22"
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-30759632453so5432008eec.1
        for <nvdimm@lists.linux.dev>; Mon, 08 Jun 2026 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780906575; x=1781511375; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OsPExAFKo3RFUEYD1/zQ0f2f7dBwpkCxxAcFxkQBUYM=;
        b=Yz5qlz22ebFOMV9Dbxaw7HnvmuSvk6H3WRyFw8qhVv223VqWsdugSuaKI43yp40bXz
         TyPRPm0N1n6GeIuoKetwD9fVswIxhSByPoEaeKpQdtmMNahqVBkAPm5XF6prhIhIvvNa
         EKPp5HAaCDYXfspv5IOWyL4bVjrytMb5lq4BPIp/JicaI0WYi6OY2CaqSCEFnileGI4B
         ldJMCLwMBAeDVryCrpdoApVOBPKSiwLrszULStTfkJERdwkbRPqt5XmH0hGHY7TatNxM
         8VvIqzDk9hy0de8IbWNrIx1DX/bYsLAWNQjoHzI31pQvVq5HZhgTJjwgb3RPeEdvzkpq
         3feQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780906575; x=1781511375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OsPExAFKo3RFUEYD1/zQ0f2f7dBwpkCxxAcFxkQBUYM=;
        b=CbV8Aq2LSQ0wyDB60l2sfbZJ1MZIa6xWP9KvTnIMzegB9yNnNBagkvvsC3e6SC9a1Q
         Jm6GhDz38y7B68RNZz21lG9bqrij9d3hlbGuH2TT5sSkfOE7EiRtnJaf5j7bjOu2n6If
         Lgw1fufeXWU2+v9MsCSZOz75c9TOAVoNLi5GV+277k7pChHXEGxffz/eGWhkN8+G7NDT
         dt3DwUFUZEo+SmCpVF7PCoUbrYxQuNWZBjVdr6Idicg5O3YxIjz9k+PNWZs7GqKOnkAI
         DHiYWo1Uw6vomdM9TfA001IdP4ZvVR+Q7FKxM7J7nmJb5ExW7kYE9ocTIgaDwncYXy8j
         q1DQ==
X-Forwarded-Encrypted: i=1; AFNElJ+EL8ZjlLKkYpkyuYkVbsYQTmb2j02NvoyXBZgkv8gRNILgg5slNihriU2uWoK2qInr+Ax9ajw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyyt39ZXzJA3VHDuL0Zc6Hirc9u7et/RJQW0NBaVUuu92MgP57A
	I6wyeQC25JrtGY2lHb5meOGHWIDwT23DkICTUxixVoziaHzSp+BV4tFn
X-Gm-Gg: Acq92OG4kBPYm29bSNvnGbGGF/RMCd5jnJ7sEpL5r/TgrMpDSWEOko+Jf9zL7BtGqh3
	X+I+jw8+MBoDBouv3V4U15gAS6qlWnyPkh5WFpX8sUizI1gA4bo0tQhhzpQYtgZ+XRqSLFfvjuA
	ktUhZwimiAda7dTSkQytk0M7meDJBfVhfmugcpQidap8V4PbsFme303QaCnOjtIKP936kcWPidX
	mYtX3yaoQYqqgp2HQDx3ZRt+gwGUUp70x7o8XErUBTAwp0JXz7g7jeFCG/CdfpYfPA8lEq/MUXl
	d02xUCyZwn0sW7ZLWg3wU2jgwJ9IMlcKdwmIOTpCY1eiZ8ehuyt76RoRLHM39LzWWdT+KsvP62U
	dUfIKC0AwLJ+tJIaqQP0uovBdZISE4YcldkHXFVMUWX1xN/FRv+AUd0lCgSZNIQzMCKc/NbMN+i
	i19HWRihmQthOSWeTJLLr/F0jZMpqRe1AAtj75mxwTpnqb2jnu66Xic7Wy9Nse3gddaRSpyiOqV
	Z2vepU3gJ0OSepRzwnrTkwrZAhE
X-Received: by 2002:a05:7301:9bca:b0:2ee:ade0:e0bf with SMTP id 5a478bee46e88-3077b311132mr6994119eec.30.1780906575005;
        Mon, 08 Jun 2026 01:16:15 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074dea8e8csm16061190eec.16.2026.06.08.01.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:16:13 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Mon, 8 Jun 2026 01:16:12 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v10 10/31] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <aiZ6TLUwI11Yg1jh@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <7f2e4fe385415e0b77b58f4bd988bc5895557dcf.1779528761.git.anisa.su@samsung.com>
 <28a8e58d-5bf8-438e-b337-76944d67e297@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28a8e58d-5bf8-438e-b337-76944d67e297@intel.com>

On Thu, May 28, 2026 at 09:21:59AM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > Dynamic Capacity Devices (DCD) support extent change notifications
> > through the event log mechanism.  The interrupt mailbox commands were
> > extended in CXL 3.1 to support these notifications.  Firmware can't
> > configure DCD events to be FW controlled but can retain control of
> > memory events.
> > 
> > Configure DCD event log interrupts on devices supporting dynamic
> > capacity.  Disable DCD if interrupts are not supported.
> > 
> > Care is taken to preserve the interrupt policy set by the FW if FW first
> > has been selected by the BIOS.
> > 
> > Accept the 4-byte CXL 2.0 reply on GET Event Interrupt Policy by setting
> > min_out to CXL_EVENT_INT_POLICY_BASE_SIZE; pre-CXL 3.1 firmware omits
> > dcd_settings and would otherwise fail the size check.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: rebase]
> > [anisa: accept 4-byte CXL 2.0 GET reply via min_out]
> > [anisa: drop Reviewed-by tags now that the patch carries new changes]
> > ---
> >  drivers/cxl/cxlmem.h |  2 ++
> >  drivers/cxl/pci.c    | 75 ++++++++++++++++++++++++++++++++++++--------
> >  2 files changed, 64 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 10175ca3b7ee..65c009b02da6 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -218,7 +218,9 @@ struct cxl_event_interrupt_policy {
> >  	u8 warn_settings;
> >  	u8 failure_settings;
> >  	u8 fatal_settings;
> > +	u8 dcd_settings;
> >  } __packed;
> > +#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
> >  
> >  /**
> >   * struct cxl_event_state - Event log driver state
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 8d12c684d670..83617439bbd3 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -557,6 +557,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
> >  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
> >  		.payload_out = policy,
> >  		.size_out = sizeof(*policy),
> > +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
> > +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
> >  	};
> >  	int rc;
> >  
> > @@ -569,23 +571,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
> >  }
> >  
> >  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> > -				    struct cxl_event_interrupt_policy *policy)
> > +				    struct cxl_event_interrupt_policy *policy,
> > +				    bool native_cxl)
> >  {
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> > +	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
> >  	struct cxl_mbox_cmd mbox_cmd;
> >  	int rc;
> >  
> > -	*policy = (struct cxl_event_interrupt_policy) {
> > -		.info_settings = CXL_INT_MSI_MSIX,
> > -		.warn_settings = CXL_INT_MSI_MSIX,
> > -		.failure_settings = CXL_INT_MSI_MSIX,
> > -		.fatal_settings = CXL_INT_MSI_MSIX,
> > -	};
> > +	/* memory event policy is left if FW has control */
> > +	if (native_cxl) {
> > +		*policy = (struct cxl_event_interrupt_policy) {
> > +			.info_settings = CXL_INT_MSI_MSIX,
> > +			.warn_settings = CXL_INT_MSI_MSIX,
> > +			.failure_settings = CXL_INT_MSI_MSIX,
> > +			.fatal_settings = CXL_INT_MSI_MSIX,
> > +			.dcd_settings = 0,
> > +		};
> > +	}
> > +
> > +	if (cxl_dcd_supported(mds)) {
> > +		policy->dcd_settings = CXL_INT_MSI_MSIX;
> > +		size_in += sizeof(policy->dcd_settings);
> > +	}
> >  
> >  	mbox_cmd = (struct cxl_mbox_cmd) {
> >  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
> >  		.payload_in = policy,
> > -		.size_in = sizeof(*policy),
> > +		.size_in = size_in,
> >  	};
> >  
> >  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> > @@ -632,6 +645,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
> >  	return 0;
> >  }
> >  
> > +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> > +			struct cxl_event_interrupt_policy *policy,
> > +			bool native_cxl)
> > +{
> > +	struct cxl_dev_state *cxlds = &mds->cxlds;
> > +	int rc;
> > +
> > +	if (native_cxl) {
> > +		rc = cxl_event_irqsetup(mds, policy);
> > +		if (rc)
> > +			return rc;
> > +	}
> > +
> > +	if (cxl_dcd_supported(mds)) {
> > +		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
> > +		if (rc) {
> > +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> > +			cxl_disable_dcd(mds);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static bool cxl_event_int_is_fw(u8 setting)
> >  {
> >  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> > @@ -657,18 +694,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
> >  static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  			    struct cxl_memdev_state *mds, bool irq_avail)
> >  {
> > -	struct cxl_event_interrupt_policy policy;
> > +	struct cxl_event_interrupt_policy policy = { 0 };
> > +	bool native_cxl = host_bridge->native_cxl_error;
> >  	int rc;
> >  
> >  	/*
> >  	 * When BIOS maintains CXL error reporting control, it will process
> >  	 * event records.  Only one agent can do so.
> > +	 *
> > +	 * If BIOS has control of events and DCD is not supported skip event
> > +	 * configuration.
> >  	 */
> > -	if (!host_bridge->native_cxl_error)
> > +	if (!native_cxl && !cxl_dcd_supported(mds))
> >  		return 0;
> >  
> >  	if (!irq_avail) {
> >  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
> > +		if (cxl_dcd_supported(mds)) {
> > +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
> > +			cxl_disable_dcd(mds);
> > +		}
> >  		return 0;
> >  	}
> >  
> > @@ -676,10 +721,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  	if (rc)
> >  		return rc;
> >  
> > -	if (!cxl_event_validate_mem_policy(mds, &policy))
> > +	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
> >  		return -EBUSY;
> >  
> > -	rc = cxl_event_config_msgnums(mds, &policy);
> > +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
> >  	if (rc)
> >  		return rc;
> >  
> > @@ -687,12 +732,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = cxl_event_irqsetup(mds, &policy);
> > +	rc = cxl_irqsetup(mds, &policy, native_cxl);
> >  	if (rc)
> >  		return rc;
> >  
> >  	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> 
> Issue that was always there probably, should this check native_cxl so the BIOS owned events are not retrieved?
> 
> 	if (native_cxl)
> 		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> 
> 
That makes sense. Would you prefer the fix as a separate patch?

> Also, CXLDEV_EVENT_STATUS_ALL is missing bit 4 (Dynamic Capcity Event Log). CXL r4.0 8.2.9.3.1 Table 8-203.
> 
It was added in a later commit, but yeah it makes more sense to have it
in this one. Moved to this commit.
> 
> DJ
> 
Thanks,
Anisa
> 
> >  
> > +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> > +		native_cxl ? "OS" : "BIOS",
> > +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> > +
> >  	return 0;
> >  }
> >  
> 
