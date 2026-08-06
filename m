Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C11439F90
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 12:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786019267; cv=none; b=rpocldj2gue4nCLK71YfjiZpb8vdjH5GHlfYMnzjWh4KlgaPE3i+3R4qxw+oYGM4NcdSDV08NPzL/TuC9t4A9yAYfpxFpKf4/oWbM652UUOrlfC8dTomSkME8Aq2tWhDyXydoin1L8jv5LG97Id0dSzQfXYLkZMcbQEFOuTiw6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786019267; c=relaxed/simple;
	bh=zbxbgVABDpAz7Yl9dVLN94U6/Mw6TDrkPy4AolyE644=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYA+QE6xNLZLFoPx61hGczgLTnl8S3UII3DVdijVhlNEMu23sDzgDj4yb7SSb9NJi2iH+INX+6MxeU2sB/6NIeK35rBfni2Ptq8k9XlmC8AE07vbRt8gzR8CFgw38f+OwDK+FtiSa32nouCLWy9kP9WOsdJy/hReVhJIKCZ+iDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gRyJXSAd; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gRyJXSAd"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e347638adso2349329a91.0
        for <nvdimm@lists.linux.dev>; Thu, 06 Aug 2026 05:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786019266; x=1786624066; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8lGDFFRjFwi4B9aeNDvA48Sw9DPRqkHPcAQDd/V37v8=;
        b=gRyJXSAdr7nfq1XABZKNNCBK1CtQyUiOa5yzkty1GD3BFFqXor/6Qofsw1axyEe5ar
         YP8IMHU5HlocMW4JCkErmYbahlEJACa0DDobwyFG3AXERMcrjsGiv8PxctPxUBr9UuOX
         CqswMxrDDcNfDGe4Dl/F7r4IQGA/MD+Ybgwh8FJNksOvsG2qc918Se80qvqM2AsD8TPP
         7mNzHNA34kS9ZBI7OAFz4wofvAQq9Qds2Wjf0IAoyMtiSW8tlHou8dNmM52tzoGbxgqI
         93Oc7m/bZh4qvipUVn5iSs8G4V2iaxX86ZTFExwITBBLfix+TUyAKVZkRkerdCz8LIu9
         bQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786019266; x=1786624066;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8lGDFFRjFwi4B9aeNDvA48Sw9DPRqkHPcAQDd/V37v8=;
        b=mw0mD4GSxYpsOjnV7SdCjmxDkKMx+K/EXvySB1J8zKc+4mwIc7uzr/MoZzHLKUhXbH
         fLb62S7MJy5nGwjsP7VQ4G0KdKMJrNlD80+G1bX+MH1s2uNCiRxR+Q0FucSq7EAo9fxE
         hLesfb/HP1e8qlhVMQl8Mwaix5SeMvUFqudkhrC7TF4cRH1qpEzZDa1j+zRuodTL4/an
         s6cHfVYzv0zFb2vCEma415m0im5PKsS4xTR4TIjqcB2R79rn+hNC1wkTpzdmmiSyHhlI
         0SvRNHkr1kKOG1cHR7FnAKbjDlMnLQtBh53DA2T00iDVn2EGp8Sj2CfxQdVkjh8K8r9y
         taxw==
X-Forwarded-Encrypted: i=1; AHgh+RqpJrVZJdiuL0jRaFoEqxO+JhNoo+Ok2ewBD149n6by7T7zvwJuSC5gYgwrhUj4uHVqvUX0WOM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/wMI6175VPfHckf+31/w9cY6qYiFQEyrmFWfgUUtBHdG3tqey
	PP9xelk/d/Ql4azBOO7TQktSv/1o+LBb/EBOOXGOMHWBraSvVpJe0SAQ
X-Gm-Gg: AR+sD10NhzkcS64b2TFEhljdfHFistKA2ObDKxXQlRG73wvOjfvgkEkcxRtAcRQj4FQ
	XJi5DH+oGLr3llpYclGu6+YOUZQihpWY62nmjW7t7XfxuL/XgJ8FuPYH0crgUDq8mHNMFaQjfj3
	TxeUB9H9/2j5sBjhv2oVroOrGa0iYKm3+mV9AGFNEG6l1UF9jpFQiO3wRS8DNBf0vzAQlmaSfhb
	0z1ILVICPfW5A1pHukKJlPSya9lJcMZbnXZil8vbY0UMtWrVsdCQgcfCORTABoOPzLSz7rNwgv9
	S/CB5FisBn/FpCZUywXpLVlM50LcOJWpX4HKygDS/fmw7dB3RsM6xVJuNw8hQzZFXxGoueysq8l
	1QYZNOlxlObBpJR1v1rctz9xU+yxctgX7G0978P48uiHbEqTeW/kx8NiAdgnOdfENFTP4UC5lOB
	rMqAuWb4kvckDu9a81fKSqRxxGGM4SXp57h4eIAkM330LIqB8WEEPATTbHzYSLDQDzM1Su9zrFc
	huih/WhZSvch6m+8htbv1p+h559d1fkesGlB6qnFgGs
X-Received: by 2002:a17:90b:2807:b0:38e:3fdc:62e5 with SMTP id 98e67ed59e1d1-3903c5ee958mr15947483a91.19.1786019265685;
        Thu, 06 Aug 2026 05:27:45 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dbe349sm1485613a91.4.2026.08.06.05.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:27:45 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 6 Aug 2026 05:27:42 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>, Dan Williams <djbw@kernel.org>
Subject: Re: [PATCH v12 5/8] cxl/pci: Factor out interrupt policy check
Message-ID: <anR9vpMtUVuPaTM4@AnisaLaptop.localdomain>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-6-anisa.su@samsung.com>
 <anEqVU3-B3ab53eE@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anEqVU3-B3ab53eE@aschofie-mobl2.lan>

On Mon, Aug 03, 2026 at 04:55:01PM -0700, Alison Schofield wrote:
> On Fri, Jul 31, 2026 at 01:48:10AM -0700, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Dynamic Capacity Devices (DCD) require event interrupts to process
> > memory addition or removal.  BIOS may have control over non-DCD event
> > processing.  DCD interrupt configuration needs to be separate from
> > memory event interrupt configuration.
> > 
> > Factor out event interrupt setting validation.
> 
> Hi Anisa,
> 
> "Validation" seems like the wrong term here. The helper checks for
> firmware ownership of the memory event logs. It is not validating
> the event interrupt settings.
> 
Fixed. Commit message now reads

	Factor out the check for firmware ownership of the memory event logs.

> Which leads to my next comment -
> 
> snip
> > 
> >  
> > +static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
> > +					  struct cxl_event_interrupt_policy *policy)
> > +{
> > +	if (cxl_event_int_is_fw(policy->info_settings) ||
> > +	    cxl_event_int_is_fw(policy->warn_settings) ||
> > +	    cxl_event_int_is_fw(policy->failure_settings) ||
> > +	    cxl_event_int_is_fw(policy->fatal_settings)) {
> > +		dev_err(mds->cxlds.dev,
> > +			"FW still in control of Event Logs despite _OSC settings\n");
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> 
> Why such a general name here? This helper seems to have one very specific purpose.
> 
> cxl_event_validate_mem_policy() doesn't validate the policy. It checks whether
> firmware still owns the standard memory event logs despite _OSC granting OS
> control. I'd prefer naming it after that condition rather than "validate".
> Something like cxl_event_fw_owns_mem_logs() reads much closer to what the
> code actually does.
> 
Renamed -- Naming it after the condition means the return value
has to invert, since true now means firmware does own them:

static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy)
	{
		return cxl_event_int_is_fw(policy->info_settings) ||
		       cxl_event_int_is_fw(policy->warn_settings) ||
		       cxl_event_int_is_fw(policy->failure_settings) ||
		       cxl_event_int_is_fw(policy->fatal_settings);
	}

so the caller loses its '!':

	if (cxl_event_fw_owns_mem_logs(&policy)) {
		dev_err(mds->cxlds.dev,
			"FW still in control of Event Logs despite _OSC settings\n");
		return -EBUSY;
	}

and I moved the dev_err out to the caller so
cxl_event_fw_owns_mem_logs() only answers the question "Does the FW own
event logs?"

Thanks,
Anisa

> --Alison
> 
> 
> > +
> >  static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  			    struct cxl_memdev_state *mds, bool irq_avail)
> >  {
> > @@ -661,14 +676,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
> >  	if (rc)
> >  		return rc;
> >  
> > -	if (cxl_event_int_is_fw(policy.info_settings) ||
> > -	    cxl_event_int_is_fw(policy.warn_settings) ||
> > -	    cxl_event_int_is_fw(policy.failure_settings) ||
> > -	    cxl_event_int_is_fw(policy.fatal_settings)) {
> > -		dev_err(mds->cxlds.dev,
> > -			"FW still in control of Event Logs despite _OSC settings\n");
> > +	if (!cxl_event_validate_mem_policy(mds, &policy))
> >  		return -EBUSY;
> > -	}
> >  
> >  	rc = cxl_event_config_msgnums(mds, &policy);
> >  	if (rc)
> > -- 
> > 2.43.0
> > 
