Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAFA357CE6
	for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 18:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781201995; cv=none; b=ZpitwL3mIxfEU/u3qcI/uR6SyiEx726eLTT07pc8s4LeNCd/igkn10Rl50tjIvneuKPWlBd8oslm2XoJSHxrFz4/MAYL0FXY9g6lEhP2xgK2YFQG92sXueCiNRGiyZ3Q93h2DZSaES1ssPAULVIM8BrA4r2gtqlBBYfpk/iAmHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781201995; c=relaxed/simple;
	bh=1omX2rC5hpD8TszoQX/iIoOUdNYlcNz3F7LNrVXmo3Y=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsOpI+nCh2J8x8wsP2c3lFf0132+tAapyw74dSXFkKeOetExI6lOW16dI3hwauR4JITXVM0hWEDDXWjZS1coE5N0xthmShWzZ5VKD6JC0jDJnixMIGtGSNUyCjDhBdUXUfPAWTdB8VPv5FfQ/n/wv1IQTpw/jOQOJwhLZ9tbBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFK1Gl/1; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFK1Gl/1"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7dfceeaf168so2081677b3.0
        for <nvdimm@lists.linux.dev>; Thu, 11 Jun 2026 11:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781201993; x=1781806793; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ddH+eXH24NtmehhRI7L/9GO3TOPMJUuuZMHBikOY13M=;
        b=QFK1Gl/1b7LGG0EI+VAsdyh1nE2xipLyJ/joeu6va6+63OXYaOzuSAJX6laqQ5QARu
         msX7HjGWbM7Kbs9qU3qHOSjobhxHbgMhUA95rcZXDKg5HoG+IONup9Ave8CPc0awE+Wa
         KvqF37LHga/2lhwdLMnd4uE8k4jflfeM4vxCrj2Y5wLFFIzzLe33LzU4xl4ogBUm0XIm
         Im6JTE/rtEReByImTY2drxWvtANWlBctGe6LnRV4LbUs7uPXFRuZyynk6AZhqVWe8oWn
         y/b9Z6dvqT/9Y861sAUjcbsL3rWw/L2bjnuOUrhFfso6SYFGDHvx1UorA7UoHdcm2NW0
         rhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781201993; x=1781806793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddH+eXH24NtmehhRI7L/9GO3TOPMJUuuZMHBikOY13M=;
        b=SZ8UJUZggGZnrSvOm26XTyeb+U4U0scQHdlSnJqFfcyIE+0GjewdBuaxqM2/kXmZ4l
         45w9N9R2afcw7Kn26jT/YZ7H7oe9PHiIFCC63fXp7tdilfgebofMaTrQOS89xj1kcQ4I
         Xjt+rXFp1hc/JCYJuQRyvNbgpmhfuXurXm+pYQd6GbS7wure6lR6QMn6EpOZNEqNJY6F
         9ibsR65O8V0GMT6Tk2J2+O4x1AxCR96cVN2RFw4oNuy8Wc/LLaJ7ZdbRU6s9xkxRnwcb
         DSmvHSkl/Q0kMZphuKqqj+1pCflLD8uMGW46CB0PQHdhmu25SJwgw/5KZrf8YlWKyJQT
         LGgw==
X-Forwarded-Encrypted: i=1; AFNElJ+oeS0Ui7H1swpZ1dukLQANA9eOHlcPBkG937FLb7VzcGybUfM9aGmqblADfzxlSP6czGeHXPE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5XM09tV5grV+WIOaPKhvC+vj83JjU458WGaceRWmZE8UAC8iE
	ZFnMOddMpDcG46vt8Y3T0Z4TbgfVQ3J2cMZj0YrCguIAVcpDJeQKUwIG
X-Gm-Gg: Acq92OGycrK37/apG2sAWiEtWfZBBC+Cmdq2Vf2khvbM4NmJpFhj2dCAY2csyPC6+Oh
	bZuV27mlfTHuhlUkb4GFpFNYl2g1Tw2+D/LLQT6Btfypnbpymo99uyeB+4nPNXAykvlvpdQUZuC
	T16XmPf1BQC2vtznxy1VYttw5nhIjzTbKead8kHDb9Dz6y5gjpZYUmfn6T9Ssy0HG7IFRNmdcQX
	/tMg+kUtN6C8PrxajnjHuFsoIuCCVZd3VUMMfvHI2vURcBlEpkvvo5sMyhV7fwV+bIHERi4Gz9U
	PztJnw67TS09AyZ70KwNOaI7QK/sc217DJwAAyzdTkJRx/YhI17gBatvsew8Td0YpKXtHBgnZVH
	dp97hYQFfGPttr4ZZj9i6KSZGVOixd6H8BXsWQxxNPlyeNaHi20MQzZyT91Ut0eVV/Ki5qmuHhp
	k4VJ9GFydTg5gKD8nSoJOT0Uk2CerV/vTfHAH0Gc6XeA==
X-Received: by 2002:a05:690c:e3ef:b0:7dc:a5a8:8b8 with SMTP id 00721157ae682-7f6553fa56amr44840507b3.7.1781201992856;
        Thu, 11 Jun 2026 11:19:52 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7f76e2b5564sm1275747b3.6.2026.06.11.11.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 11:19:52 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 11 Jun 2026 11:19:50 -0700
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
Message-ID: <air8RktfkGYm2fHp@4470NRD-ASU.ssi.samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <7f2e4fe385415e0b77b58f4bd988bc5895557dcf.1779528761.git.anisa.su@samsung.com>
 <28a8e58d-5bf8-438e-b337-76944d67e297@intel.com>
 <aiZ6TLUwI11Yg1jh@AnisaLaptop.localdomain>
 <9c3ab868-27b7-4d33-865b-9308269f764f@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3ab868-27b7-4d33-865b-9308269f764f@intel.com>

On Wed, Jun 10, 2026 at 09:57:35AM -0700, Dave Jiang wrote:
> 
> 
> On 6/8/26 1:16 AM, Anisa Su wrote:
> > On Thu, May 28, 2026 at 09:21:59AM -0700, Dave Jiang wrote:
> >>
> >>
> >> On 5/23/26 2:43 AM, Anisa Su wrote:
> >>> From: Ira Weiny <ira.weiny@intel.com>
> >>>
> >>> Dynamic Capacity Devices (DCD) support extent change notifications
> >>> through the event log mechanism.  The interrupt mailbox commands were
> >>> extended in CXL 3.1 to support these notifications.  Firmware can't
> >>> configure DCD events to be FW controlled but can retain control of
> >>> memory events.
> >>>
> >>> Configure DCD event log interrupts on devices supporting dynamic
> >>> capacity.  Disable DCD if interrupts are not supported.
> >>>
> >>> Care is taken to preserve the interrupt policy set by the FW if FW first
> >>> has been selected by the BIOS.
> >>>
> >>> Accept the 4-byte CXL 2.0 reply on GET Event Interrupt Policy by setting
> >>> min_out to CXL_EVENT_INT_POLICY_BASE_SIZE; pre-CXL 3.1 firmware omits
> >>> dcd_settings and would otherwise fail the size check.
> >>>
> >>> Based on an original patch by Navneet Singh.
> >>>
> >>> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> >>> Signed-off-by: Anisa Su <anisa.su@samsung.com>
> >>>
> >>> ---
> >>> Changes:
> >>> [anisa: rebase]
> >>> [anisa: accept 4-byte CXL 2.0 GET reply via min_out]
> >>> [anisa: drop Reviewed-by tags now that the patch carries new changes]
> >>> ---
[snip]
> >>>  static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >>>  			    struct cxl_memdev_state *mds, bool irq_avail)
> >>>  {
> >>> -	struct cxl_event_interrupt_policy policy;
> >>> +	struct cxl_event_interrupt_policy policy = { 0 };
> >>> +	bool native_cxl = host_bridge->native_cxl_error;
> >>>  	int rc;
> >>>  
> >>>  	/*
> >>>  	 * When BIOS maintains CXL error reporting control, it will process
> >>>  	 * event records.  Only one agent can do so.
> >>> +	 *
> >>> +	 * If BIOS has control of events and DCD is not supported skip event
> >>> +	 * configuration.
> >>>  	 */
> >>> -	if (!host_bridge->native_cxl_error)
> >>> +	if (!native_cxl && !cxl_dcd_supported(mds))
> >>>  		return 0;
> >>>  
> >>>  	if (!irq_avail) {
> >>>  		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
> >>> +		if (cxl_dcd_supported(mds)) {
> >>> +			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
> >>> +			cxl_disable_dcd(mds);
> >>> +		}
> >>>  		return 0;
> >>>  	}
> >>>  
> >>> @@ -676,10 +721,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >>>  	if (rc)
> >>>  		return rc;
> >>>  
> >>> -	if (!cxl_event_validate_mem_policy(mds, &policy))
> >>> +	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
> >>>  		return -EBUSY;
> >>>  
> >>> -	rc = cxl_event_config_msgnums(mds, &policy);
> >>> +	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
> >>>  	if (rc)
> >>>  		return rc;
> >>>  
> >>> @@ -687,12 +732,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >>>  	if (rc)
> >>>  		return rc;
> >>>  
> >>> -	rc = cxl_event_irqsetup(mds, &policy);
> >>> +	rc = cxl_irqsetup(mds, &policy, native_cxl);
> >>>  	if (rc)
> >>>  		return rc;
> >>>  
> >>>  	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> >>
> >> Issue that was always there probably, should this check native_cxl so the BIOS owned events are not retrieved?
> >>
> >> 	if (native_cxl)
> >> 		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> >>
> >>
> > That makes sense. Would you prefer the fix as a separate patch?
> 
> Yes please.
> 
> DJ
> 
Oops I was wrong; the issue wasn't there before. This function used to return 0
if !native_cxl at the top of the function but this patchset added
&& !cxl_dcd_supported() to the condition.

Added the fix to this commit.

Thanks,
Anisa
