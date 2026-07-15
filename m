Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42203335064
	for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784151112; cv=none; b=d7SG11y5YfFTPu7uThwALarMcyj4d7I5t+VuYqOcUPK/OMHnD/Jr9u3PLJ8Gol5rIZvbsemWrIzG+cLbgLyIiiHkwJ6EGWq/89irV6NITowzktRcw9sioDSP7jHxM8Ig85hOBjo1gpr0WBq2ldl9bICm/B0HclVd2eyWp+wI3+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784151112; c=relaxed/simple;
	bh=7QTPVpJJhfGFyRYBrsLIJeplcw7EovnGQvuPkXS/zD0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7odDbeinSuMKu5te/zkXcgYzS9mXZAWs8JNYNWywha0n7QcG/RAIOuPDqo6PtmZnS23jpoa/jax7BTqVd5zLAS3JnvLPIJBjSiFwPRrexhJgm29vAijxI3Mh2yv1WUtmOnvCBR24cxdPweljzpbl6FmUG/jju9y7jZskfVxPEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qKzkDq0U; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qKzkDq0U"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8486ac3f347so1172028b3a.1
        for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 14:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784151110; x=1784755910; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RkllprxknGgtsAUtKcMYlWZnTeNJpDATGUEaLC+fkyk=;
        b=qKzkDq0U4RJAL8KmW/edyTKRStCAOWJ+tSWbt6SnIidn8WMql7pDjvaE5IrWrNZDWM
         uIZV16owbjrXIMSYwUgWfGQ9m3miwnrfs9XTkrY+i6M3NezNYU6X5gAtWfCvMaegmKC6
         wo50iIekAi2qe7H36/oayqRSeAbMdDfXAGWACC04GS7DmxY2F8W1pWwUOUKUaAdkvBHi
         VHJgCzZO/0lulM82wv0nsUnbGkFQ3J5JbmFVaCoK3V9pGZMayIZjZzTAgF83fHlmG2Ll
         ZF3gunZvBsljEBS5bZDxd96zG7L+BjegPb31Q7QSwTo0PlFNAIBHWYUOGrLwtfZPHvt8
         EKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784151111; x=1784755911;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RkllprxknGgtsAUtKcMYlWZnTeNJpDATGUEaLC+fkyk=;
        b=NQFKbA8j+wB0YCMxBa3Hq/vVrscrku3OAvPWif4hu0I8qzslPOSDruvnhb8zsNiW2O
         zVaVcQ6MnLzGUTLOETpTCIWggCQjpHjBdGYRRItUUz1t+fs3n2ahck3yc8D59qJkdcdQ
         E9LZ4hUIB5FiV5ZJvZbm3SJRnm0VxNzhRDys0Vm3sj5IMihHNNVVgfYu/AwOvIwxAdGT
         FzJIjnuAn5/JD4uV+uiv2wH+/SR6cLiOX1EN4e2n0JE/3QLP0JbHZLu4U/evJIvkqVAY
         3VtqcFHz2D8FqLZzjdqeWt6//1DJAa3YhRDHm3VyFY+CkPDttIj2hWk+M8Yd+cUQCCCq
         qg1g==
X-Forwarded-Encrypted: i=1; AHgh+RqDvGdecfJzDkXQanGaP22FXEpETbeKhvBtRf1Kx5/Q6/dWemf4KC9Za2p71FJsNa1KWLR8W5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhLaaGif6MxkqRr3tLi1qBoWTCwhrxAd9mynGLK0eYb596YWZL
	6wV6P46s8tEUyZZFMElFu7xhReUuALjdXo72kye205pRndSMob+gtPnc
X-Gm-Gg: AfdE7cmqQnqtWweSlJs/sIO25gELSOxrKoPgo7L4UyCACWdiBx4jl+CWfXZWWpuYCMC
	oZ04qBUidwWZOcxRH9Kh2slPyNbRa1hR1jxwPchcF2TiaxZKn+ABl2NM1jKUBXqRhktcopscek/
	LbiJepl22YE5b+xLPRv2Q3rM5R8OL/du6urxQXBq/hLIRwcS5KK0mcxDFd1Zmy4AJZ39pp4Yvp+
	+usumhN4FUDNT40kZyn0F/6Mj6uoY6jd8b+svUQNufsW8y2kJAJMSiNOz//TaEFYXE3tSEnmuJB
	N91bdLyti6u32xI/zpfxS/TVjBhGzjGeiJhRgTASY1/GFNlLp4DuQye4Od+BWOUO2+92hLNNYHQ
	3GiiOFbpUZprgblaVIcxmD+PHrVYbOaq6fyxtouFpcQ4XDHZp4g3npdSEEpMA67v0tKJavVgAMb
	2TdKF4jDspmDbE+gqjA0RCFmkStWk8Qqs5EYgek8M7C3IaG94U5A5R8bsX9g==
X-Received: by 2002:a05:6a20:c98b:b0:3b4:731e:6fad with SMTP id adf61e73a8af0-3c384aeb33dmr1101447637.16.1784151110450;
        Wed, 15 Jul 2026 14:31:50 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fc28dsm4621118eec.2.2026.07.15.14.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:31:50 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 15 Jul 2026 14:31:49 -0700
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v11 10/31] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <alf8RRJ3tcRWvBIR@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-11-anisa.su@samsung.com>
 <6d4b2c0e-5c05-4e92-9c9d-dba8cabe849b@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d4b2c0e-5c05-4e92-9c9d-dba8cabe849b@amd.com>

On Tue, Jul 07, 2026 at 04:51:23PM -0500, Cheatham, Benjamin wrote:
> On 6/25/2026 6:04 AM, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
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
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > 
> > ---
> > Changes:
> > [anisa: add CXLDEV_EVENT_STATUS_DCD (bit 4) to CXLDEV_EVENT_STATUS_ALL;
> > previously added in a later commit but moved to current commit]
> > 
> > [anisa: check native_cxl before cxl_mem_get_event_records]
> > ---
> >  drivers/cxl/cxl.h    |  4 +-
> >  drivers/cxl/cxlmem.h |  2 +
> >  drivers/cxl/pci.c    | 94 ++++++++++++++++++++++++++++++++++++--------
> >  3 files changed, 83 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> > index 1297594beaec..864f6d3c03d4 100644
> > --- a/drivers/cxl/cxl.h
> > +++ b/drivers/cxl/cxl.h
> > @@ -180,11 +180,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
> >  #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
> >  #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
> >  #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
> > +#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
> >  
> >  #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
> >  				 CXLDEV_EVENT_STATUS_WARN |	\
> >  				 CXLDEV_EVENT_STATUS_FAIL |	\
> > -				 CXLDEV_EVENT_STATUS_FATAL)
> > +				 CXLDEV_EVENT_STATUS_FATAL |	\
> > +				 CXLDEV_EVENT_STATUS_DCD)
> >  
> >  /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
> >  #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index afc195d8c090..bcf976829c3e 100644
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
> > index 8d12c684d670..95a4bf7c1e46 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -514,7 +514,19 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
> >  	struct cxl_dev_id *dev_id = id;
> >  	struct cxl_dev_state *cxlds = dev_id->cxlds;
> >  	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
> > +	struct pci_host_bridge *host_bridge =
> > +		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
> >  	u32 status;
> > +	u32 mask;
> > +
> > +	/*
> > +	 * Only drain logs the driver owns.  When BIOS owns event reporting
> > +	 * (!native_cxl) the driver is only here for the Dynamic Capacity log;
> > +	 * processing the standard logs would steal firmware-first events from
> > +	 * BIOS, so mask them out.
> > +	 */
> > +	mask = host_bridge->native_cxl_error ? CXLDEV_EVENT_STATUS_ALL
> > +					     : CXLDEV_EVENT_STATUS_DCD;
> >  
> >  	do {
> >  		/*
> > @@ -522,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
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
> > @@ -557,6 +569,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
> >  		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
> >  		.payload_out = policy,
> >  		.size_out = sizeof(*policy),
> > +		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
> > +		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
> >  	};
> >  	int rc;
> >  
> > @@ -569,23 +583,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
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
> 
> It seems there's a bug here that I found on one of our test machines. It's possible the card doesn't support
> DCD commands but does have the policy bit for DCD (i.e. CXL card is 3.0+), so the payload still needs to be
> large enough to include the DCD bit in that case. So, the size_in needs to always include dcd_settings but
> the actual policy setting should stay based on whether the card supports DCD. Hopefully that makes sense, let
> me know if it's not clear...
> 
Yes that makes sense. Thank you for reporting!

> 
> The first thing that I thought of for a solution is setting size_in based on the CXL card's DVSEC revision
> (i.e. size_in = 5 for CXL 3.0+, size_in = 4 otherwise). Not exactly a clean solution, but I'm not sure there's
> a way around it.
> 
> Thanks,
> Ben
> >  
Here is what I came up with:

In cxl_event_config(), we get the interrupt policy
from cxl_event_get_int_policy() before cxl_event_config_msgnums().

I added a return param to cxl_event_get_int_policy() to return the
actual size:

*policy_size = mbox_cmd.size_out

The value is passed through a new input parameter for policy_size in
cxl_event_config_msgnums() so it can use the actual size.

I am working my way through the reviews and hope to post v12 soon :3

Thanks,
Anisa

> >  	mbox_cmd = (struct cxl_mbox_cmd) {
> >  		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
> >  		.payload_in = policy,
> > -		.size_in = sizeof(*policy),
> > +		.size_in = size_in,
> >  	};
> >  
> >  	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
> > @@ -632,6 +657,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
> > @@ -657,18 +706,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
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
> > @@ -676,10 +733,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
> > @@ -687,11 +744,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = cxl_event_irqsetup(mds, &policy);
> > +	rc = cxl_irqsetup(mds, &policy, native_cxl);
> >  	if (rc)
> >  		return rc;
> >  
> > -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> > +	if (native_cxl)
> > +		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> > +
> > +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> > +		native_cxl ? "OS" : "BIOS",
> > +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> >  
> >  	return 0;
> >  }
> 
