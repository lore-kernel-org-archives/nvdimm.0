Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E81B39B969
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791672576; cv=none; b=BZbyHIWciNGCh+o5loOM2ohWLZfTfPb+xqxs9UZRxtROMSqdKIjAPBfXLXonJicVM28aT4h8amyXwzEq5lQet0eDSGz6Z9Y61ciBy69yynznSVfzNabS1s54HuckxELwWjj0sebwdSMHWFKBarTCl8gVpVgZ2dWPoWWytGeXo1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791672576; c=relaxed/simple;
	bh=gPVcUP98gM5Dvn3zx3GJ/vdcF8EMsg9Nxy1p8uGoq38=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oXaav2lsXjQWd5gfSuwP0e8PBG53GdnNEd+r0imq/QZtmMoZyIHr2OeI44o3e1Cdo4irgFqlA5fWYWxTJGLaAxZ8tTh1nOsA1iMLAxOgFg5tZPJGehsXUtCXxCpAlGZSryavcZLEGHr8G7BLBYsngMAJ0WCWNc4feuw4pl2m+dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=exARStpm; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="exARStpm"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso518945a12.3
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791672566; x=1792277366; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1mnDa+aZgReQpqzXYXzgAIzUS2VPT7UvGdW0Dbt7mR8=;
        b=exARStpmiM7jOYH9U7FWnJ2tH9gSW2ovLOx6Vy9v3hOO94VJIfcIhhg0vp4xZmwkT2
         AoWz35OGBCLNDluL6RQDxkM5Fqm/DZMJebu4opjoGUtqBpU5PoeS9SBs+ofQxHKApSBV
         Lh9Ug08dTrft5LDb+Z30zQMCep2zV4nmj1RyCTPHDBvSbshmhUIp9sCyT7JTot8Hn1Qa
         MlplU8xEhJdXXZSBo52reMhQXJrN1Pzw+pBeq8ETFDeZJGbk1Txvr5AF5tMnjD1NQUlD
         Bk3/0HqrZX538kG5zx55Mwn2XaXUvb1HXIpJ1VInbXTzmT3rGambXKFa+1PMq7/NdO+P
         +4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791672566; x=1792277366;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1mnDa+aZgReQpqzXYXzgAIzUS2VPT7UvGdW0Dbt7mR8=;
        b=LqR3laeYxJFm11BrByvn196XaG590hikwA0EZMISHF7VkZp//+u5tpnBD/ZrJ0NJtG
         y2y+ok93JbX2J1amSuoNrjt/hZ9FRaihyt8opW1HljIhwXG3mRZCqHm+24SbyiPE1dM5
         mGHDVTx5TOC46YWauv3G2xyi/S889Vfaz0CgSO9c+Yjau3jW+0djyFO4I8wDdXeIJ6l1
         VSSs6GtH6yK3N87zBtVWZGQWu0psp1X88Iewy1FDqvLzpSBYkP8hQnA+7MMQij8tdSWp
         Hr+G/wzw3nQgQTlJvbqINMY2lCHZmU/tjWpj7ehv+zup7h/Ql/IoLk5CYRM7ynvrCGJJ
         vxTw==
X-Forwarded-Encrypted: i=1; AKwUvBwlmxbTLPgb5SnYMSMJm0+JdK3xz+T5d03yXLgYcBbpVFIUFpoQ9ltTg41NJlecgRYz0octkBE=@lists.linux.dev
X-Gm-Message-State: AFq9FYKJ5RT26ue/hXPADQaHVdu777dBbxl1bIFGUgygwiWDZtEOd5FB
	3VjPK4KdVIGD9MpwlZ+tJmYq5/RarQkZdgzY+H8+7gvqn/+XaHSrdjwm
X-Gm-Gg: AYBFou3w6FHAtGowa2mAB3fnDJ9qk0v2BdIlquiNX5jBLJDKzBMx7nmcc0fUg3QRn78
	Ia0lOWu6qwFmf33JAfi69g3AP0rQXDk5jACBmVsfrd8VyBwgft1wwOX4WeGmcHNDXam7lg/k9uA
	vYLbZnnIUzgl2bmuoTHG8XsqE9/wY42wAtbRiIReTYEr42564Lb8+NOt45bb2d22sU02kUc6kcx
	XCs73FPf9resPD5DRQQv8XyBClOeuFs2RWSUBQPjHdfd+MaID8H+2h1Dz6J1tUpUrtFziaTVkMT
	Owl29R56e4a6We5kXkNxPJRKTrHMqPxAYV4yv7AWPf8KASElYHxYU69FWJT8b3/467SfIcsnHMw
	pSomIBdKjMriDau5E/WoteYuj76pok0LOpx1fPdj12fSAJoO/BmJgs97nZAtJ2H7fDgz4DEyNng
	l0qWO+Px1gsf+H0NVt0htwFHuIbo1sUGTODtk6Znucv+2dzzFVKoRpLe51heG652ZJmwN07B0/1
	21P0smlsXm9BQC4orTu6U9TrA==
X-Received: by 2002:a05:6300:83:b0:3d3:ae50:97c8 with SMTP id adf61e73a8af0-3e16bdd36damr4627580637.21.1791672566160;
        Sat, 10 Oct 2026 15:49:26 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3dc6bf8sm2513617b3a.34.2026.10.10.15.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:49:25 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Sun, 11 Oct 2026 07:51:17 +0900
To: Richard Cheng <icheng@nvidia.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v15 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <asrBZX_uYcynSHZy@cxlqual>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-7-anisa.su@samsung.com>
 <asdaKGr4Rpwz4nih@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asdaKGr4Rpwz4nih@MWDK4CY14F>

On Thu, Oct 08, 2026 at 04:58:28PM +0800, Richard Cheng wrote:
> On Wed, Oct 07, 2026 at 01:16:39PM +0800, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Dynamic Capacity Devices (DCD) support extent change notifications
> > through the event log mechanism. The interrupt mailbox commands were
> > extended in CXL 3.1 to support these notifications. Firmware can't
> > configure DCD events to be FW controlled but can retain control of
> > memory events.
> > 
> > Configure DCD event log interrupts on devices supporting dynamic
> > capacity. Disable DCD if interrupts are not supported.
> > 
> > The DCD event log is not drained here. cxl_event_drain_mask() reports
> > only the logs the driver can service, and the DCD bit is added by
> > the patch introducing DCD event handling. Until then a DCD interrupt
> > wakes the event thread, which finds no log it owns and returns.
> > 
> > Care is taken to preserve the interrupt policy set by the FW if FW first
> > has been selected by the BIOS.
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Co-developed-by: Anisa Su <anisa.su@samsung.com>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > 1. cxl.h: add CXLDEV_EVENT_STATUS_STANDARD_LOGS for the four logs whose
> >    ownership follows native_cxl_error, and use it in
> >    cxl_event_drain_mask() and the cxl_test mock instead of spelling the
> >    mask out in both places.
> >    [Dave, Richard, Jonathan]
> > 2. On platforms where BIOS owns the event logs, a failed Get/Set Event
> >    Interrupt Policy disables DCD instead of failing probe. Before DCD
> >    this path never reached the mailbox there; now DCD is the only
> >    reason it does, so its failure costs DCD, not the memdev.
> >    [Sashiko]
> > ---
> >  drivers/cxl/cxl.h            |  14 ++--
> >  drivers/cxl/cxlmem.h         |   2 +
> >  drivers/cxl/pci.c            | 143 +++++++++++++++++++++++++++++------
> >  tools/testing/cxl/test/mem.c |   2 +-
> >  4 files changed, 133 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index cab8ce39f465..15356d25369d 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -192,11 +192,15 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
> >  #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
> >  #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
> >  #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
> > -
> > -#define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
> > -				 CXLDEV_EVENT_STATUS_WARN |	\
> > -				 CXLDEV_EVENT_STATUS_FAIL |	\
> > -				 CXLDEV_EVENT_STATUS_FATAL)
> > +#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
> > +/*
> > + * Logs whose ownership follows native_cxl_error; the DCD log is always
> > + * OS owned.
> > + */
> > +#define CXLDEV_EVENT_STATUS_STANDARD_LOGS	(CXLDEV_EVENT_STATUS_INFO | \
> > +						 CXLDEV_EVENT_STATUS_WARN | \
> > +						 CXLDEV_EVENT_STATUS_FAIL | \
> > +						 CXLDEV_EVENT_STATUS_FATAL)
> >  
> >  /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
> >  #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 9fd5af2e41d4..9106affd7c81 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -240,7 +240,9 @@ struct cxl_event_interrupt_policy {
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
> > index 7b754af2168d..d2bed92be30d 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -510,11 +510,22 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
> >  	return true;
> >  }
> >  
> > +/* Event logs the driver drains: standard logs when native_cxl */
> > +static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
> > +{
> > +	if (host_bridge->native_cxl_error)
> > +		return CXLDEV_EVENT_STATUS_STANDARD_LOGS;
> > +	return 0;
> > +}
> > +
> >  static irqreturn_t cxl_event_thread(int irq, void *id)
> >  {
> >  	struct cxl_dev_id *dev_id = id;
> >  	struct cxl_dev_state *cxlds = dev_id->cxlds;
> >  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> > +	struct pci_host_bridge *host_bridge =
> > +		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
> > +	u32 mask = cxl_event_drain_mask(host_bridge);
> >  	u32 status;
> >  
> >  	do {
> > @@ -523,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
> >  		 * ignore the reserved upper 32 bits
> >  		 */
> >  		status = readl(cxlds->regs.status + CXLDEV_DEV_EVENT_STATUS_OFFSET);
> > -		/* Ignore logs unknown to the driver */
> > -		status &= CXLDEV_EVENT_STATUS_ALL;
> > +		/* Ignore logs unknown to the driver or owned by BIOS */
> > +		status &= mask;
> >  		if (!status)
> >  			break;
> >  		cxl_mem_get_event_records(mds, status);
> > @@ -551,42 +562,62 @@ static int cxl_event_req_irq(struct cxl_dev_state *cxlds, u8 setting)
> >  }
> >  
> >  static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
> > -				    struct cxl_event_interrupt_policy *policy)
> > +				    struct cxl_event_interrupt_policy *policy,
> > +				    size_t *policy_size)
> >  {
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> >  	struct cxl_mbox_cmd mbox_cmd = {
> >  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
> >  		.payload_out = policy,
> >  		.size_out = sizeof(*policy),
> > +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
> > +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
> >  	};
> >  	int rc;
> >  
> >  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> > -	if (rc < 0)
> > +	if (rc < 0) {
> >  		dev_err(mds->cxlds.dev,
> >  			"Failed to get event interrupt policy : %d", rc);
> > +		return rc;
> > +	}
> >  
> > +	if (policy_size)
> > +		*policy_size = mbox_cmd.size_out;
> >  	return rc;
> >  }
> >  
> >  static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> > -				    struct cxl_event_interrupt_policy *policy)
> > +				    struct cxl_event_interrupt_policy *policy,
> > +				    bool native_cxl, size_t policy_size)
> >  {
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
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
> > +	/*
> > +	 * A CXL 3.0+ device can carry dcd_settings field without DCD command
> > +	 * support, so size the request by the device's policy_size and only
> > +	 * enable the DCD interrupt when DCD commands are supported.
> > +	 */
> > +	if (cxl_dcd_supported(mds))
> > +		policy->dcd_settings = CXL_INT_MSI_MSIX;
> >  
> >  	mbox_cmd = (struct cxl_mbox_cmd) {
> >  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
> >  		.payload_in = policy,
> > -		.size_in = sizeof(*policy),
> > +		.size_in = policy_size,
> >  	};
> >  
> >  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> > @@ -597,7 +628,7 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
> >  	}
> >  
> >  	/* Retrieve final interrupt settings */
> > -	return cxl_event_get_int_policy(mds, policy);
> > +	return cxl_event_get_int_policy(mds, policy, NULL);
> >  }
> >  
> >  static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
> > @@ -633,6 +664,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
> 
> Hi Anisa,
> 
> If I didn't understand wrong, the interrupt has devicce half and host half.
> When cxl_event_req_irq() fails for DCD log, cxl_irqsetup() disable DCD and
> return 0, but still dcd_settings = MSI/MSI-X, so the device keeps signalling
> a vector with no handler while driver consider DCD off.
> 
> Should we match the state together ?
> 
Yeah.

Fixed to set event interrupt policy with dcd_settings = CXL_INT_NONE if
DCD is disabled.

Refactored set event int policy out of cxl_event_config_msgnums() into a
separate helper.

If setting the new policy fails, just emit a warn.

> Best regards,
> Richard Cheng.
> 
Thanks,
Anisa
> 
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static bool cxl_event_int_is_fw(u8 setting)
> >  {
> >  	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
> > @@ -651,46 +706,90 @@ static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy
> >  static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  			    struct cxl_memdev_state *mds, bool irq_avail)
> >  {
> > -	struct cxl_event_interrupt_policy policy;
> > +	struct cxl_event_interrupt_policy policy = { 0 };
> > +	bool native_cxl = host_bridge->native_cxl_error;
> > +	size_t policy_size;
> > +	u32 mask;
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
> > -	rc = cxl_event_get_int_policy(mds, &policy);
> > +	rc = cxl_event_get_int_policy(mds, &policy, &policy_size);
> >  	if (rc)
> > -		return rc;
> > +		goto err;
> > +
> > +	/*
> > +	 * dcd_settings cannot be sent to a device whose policy is too short
> > +	 * to hold it, so the device would never accept the setting
> > +	 * cxl_irqsetup() arms the DCD interrupt with.
> > +	 */
> > +	if (cxl_dcd_supported(mds) && policy_size < sizeof(policy)) {
> > +		dev_warn(mds->cxlds.dev,
> > +			 "DCD supported but interrupt policy is only %zu bytes\n",
> > +			 policy_size);
> > +		cxl_disable_dcd(mds);
> > +		/* DCD was the only reason to be here */
> > +		if (!native_cxl)
> > +			return 0;
> > +	}
> >  
> > -	if (cxl_event_fw_owns_mem_logs(&policy)) {
> > +	if (native_cxl && cxl_event_fw_owns_mem_logs(&policy)) {
> >  		dev_err(mds->cxlds.dev,
> >  			"FW still in control of Event Logs despite _OSC settings\n");
> >  		return -EBUSY;
> >  	}
> >  
> > -	rc = cxl_event_config_msgnums(mds, &policy);
> > +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl, policy_size);
> >  	if (rc)
> > -		return rc;
> > +		goto err;
> >  
> >  	rc = cxl_mem_alloc_event_buf(mds);
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = cxl_event_irqsetup(mds, &policy);
> > +	rc = cxl_irqsetup(mds, &policy, native_cxl);
> >  	if (rc)
> >  		return rc;
> >  
> > -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> > +	mask = cxl_event_drain_mask(host_bridge);
> > +	if (mask)
> > +		cxl_mem_get_event_records(mds, mask);
> > +
> > +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> > +		native_cxl ? "OS" : "BIOS",
> > +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> >  
> >  	return 0;
> > +
> > +err:
> > +	/*
> > +	 * Failed to Get/Set interrupt policy for DCD while BIOS owns the
> > +	 * other logs. Disable DCD and continue.
> > +	 */
> > +	if (!native_cxl) {
> > +		dev_warn(mds->cxlds.dev,
> > +			 "Event interrupt policy failed (%d), disabling DCD\n", rc);
> > +		cxl_disable_dcd(mds);
> > +		return 0;
> > +	}
> > +	return rc;
> >  }
> >  
> >  static int cxl_pci_type3_init_mailbox(struct cxl_dev_state *cxlds)
> > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > index 7b756000a1a6..c740372bdaaa 100644
> > --- a/tools/testing/cxl/test/mem.c
> > +++ b/tools/testing/cxl/test/mem.c
> > @@ -1818,7 +1818,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  	if (rc)
> >  		dev_dbg(dev, "No CXL FWCTL setup\n");
> >  
> > -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> > +	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_STANDARD_LOGS);
> >  	cxl_mock_test_feat_init(mdata);
> >  
> >  	return 0;
> > -- 
> > 2.43.0
> > 
