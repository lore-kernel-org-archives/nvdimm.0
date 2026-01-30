Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E03074BA
	for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769811175; cv=none; b=hofxHIcZfb9LsY1cCVMnTXc4VGCucIq1Kt6v1cGsLDttIMCoie//GF6sLxPw5AH8e/fVnogPvF8iAtxdQ9+Uy8RSbKxd1R7OY72Vw5R4BAvG7UiTDuN/3+XahwW1rr5rGFJnfyGYTfXKDryENHXfCCibgrfnNfmRPoXiSddIQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769811175; c=relaxed/simple;
	bh=EE75EBg/m8/QKw8DcaNmQh/kzwsKHHG6eLPdctJoZDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuzWL8Qm5gbPNX+pa0bsz5FVuzh6Rs5TgyuijMxvVmvFOe+mkP1a0OiaIcVYkZLv6zeQr4cx3yUpxf/q0FTE+jF1brxH+D6ZkvRjlZwhj+rdTwpoSyH+mD16MuVJIo+qLOUPewaXT6kOMRsyV6/Kds9Trb29+B+xFOC5IJ6nPXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qBE6tYuc; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qBE6tYuc"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c70c6b2bcaso266601085a.3
        for <nvdimm@lists.linux.dev>; Fri, 30 Jan 2026 14:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769811173; x=1770415973; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WcwIl3uOXu5+/SwXKBFd7tJC/YnUbnTLiMTfGdoJxgA=;
        b=qBE6tYucZJk6qTpaUnhbmDa0Ck5KltrIqR8plN1I/lRWB61SXKUK/kNDOqfSVRwz+N
         WsL6/xTgKRtb7DJEcjmC1rSzWjYVVuTZWRYhx6IVCLMVrSU2VdEu11/e55sKk/N/jNJt
         7RqqDhI9SOiNYM9V49mS6q3A08CvmXlWh5K0aEwIKO2MlkRsB5j/RqzO1LMSeH4ClVav
         CwX16nGLAI/k/PveN1Do7yWOa4ZyVrNIRaFLoJrqkNl/Tti6ZuFKoB175Sh/JU4+IMZG
         N7bdbhxqJIqF3BHoko/hypR5mDKtY7rk7W1Kxvx+q1m1LqOQ/R3Mfi+vPnJ2KcDn6lyA
         h9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769811173; x=1770415973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WcwIl3uOXu5+/SwXKBFd7tJC/YnUbnTLiMTfGdoJxgA=;
        b=vMnZn0/praLUnMe49Gq7K+1QEZqdD28dRH5r7Wdobusz0uzuEiDedLVOcxUmTYzyj8
         x4/COHD7aIrA2Xbw/zWn9/Geh9FbQyqLelhtMi+IKtVLfKfhxt805ZOgSkyJB/GcKT9f
         Cm1vp2xrY2l2765lgixkJ3gjvny4+/eFCbrIIy2PB3EKOkbjztQY1UzHDwPKQyOXh3Dd
         MaA//zmguaijN4VAiWXw/sveXSESPAqTVZROrPOiqMCulBObBn46i/yNp+Qud7FwMFrz
         dOUAfE4ao6nmnAafe+6qvCTLlJsVT5sstYk2A5/KSBXFfFzyXFIlFRYkyUvZkOXHVeOQ
         cbbw==
X-Forwarded-Encrypted: i=1; AJvYcCW9g3Sobrov+QYVqh+nNTrn8hviMMZ0L0yWwGzIMp4hczSpnYc7ReOH+TuBlML/CbVkyVyMcpY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyO7LsxQi6O3ip49l58g5uTBykEc9SukWsPyML1rcpu1ASh5BY
	JQ1CHOLD30sL0K357kPsT1Gt3NtWP7CP5kX1yVT5IDtSsfGuw8jBphI2cnwBwPx7QmM=
X-Gm-Gg: AZuq6aLLVTVpm08Ij73e0/HnZpeERhHO45Ri0NNx3hFaDLQSPFPflSZ8D4xluXdVNNR
	chJemcSBV2z+kbkXQ5u5NYLXiBXHbsf9LuVbKY2Yw8u9l9coMTbyz7PPfT16VEJa5eNh/awWYBp
	fhGubRNJqh96b67eJ6FrxUdeGgzbtO+Mu7HxiQrTlrjdiZSD7XJKj7InexB7LdmB8+Ol4ZFwgmj
	AuMsyPc0Gb4sjyNZpOgyqVhNFFNxl31fKnX0z5DExPBYSoh2m2fSKk0DXyq/LVuPCiO9pWBy0iu
	sdSMKlrZ1P19Y5nm0TExjizfdZGD0iaYCf7kH1ybl+oLneFZq/qSSafQoh111WMMB3ycfx20SNT
	5ZbwyLRzWCKYLYWhE0kEltEHAOm7jyDDTRBunuplqGE9zxURmcio12WQlMrxU8/3yIldwrkO+h/
	xdnV8qJAwGR+CGXh1UCakOKrrebo7rehcr8NpElbJ68B84mTCim26nPfFHMmmMJ+oZ10f3cIBPz
	6fOI+iW
X-Received: by 2002:a05:620a:408d:b0:8b5:9fc7:812b with SMTP id af79cd13be357-8c9eb215f79mr587853885a.6.1769811173102;
        Fri, 30 Jan 2026 14:12:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d36ab208sm66770586d6.1.2026.01.30.14.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 14:12:52 -0800 (PST)
Date: Fri, 30 Jan 2026 17:12:50 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>

On Fri, Jan 30, 2026 at 03:27:12PM -0600, Cheatham, Benjamin wrote:
> On 1/29/2026 3:04 PM, Gregory Price wrote:
> > In the current kmem driver binding process, the only way for users
> > to define hotplug policy is via a build-time option, or by not
> > onlining memory by default and setting each individual memory block
> > online after hotplug occurs.  We can solve this with a configuration
> > step between region-probe and dax-probe.
> > 
> > Add the infrastructure for a two-stage driver binding for kmem-mode
> > dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
> > devices and creates cxl_dax_region with dax_driver=kmem.
> > 
> > This creates an interposition step where users can configure policy.
> > 
> > Device hierarchy:
> >   region0 -> sysram_region0 -> dax_region0 -> dax0.0
> 
> This technically comes up in the devdax_region driver patch first, but I noticed it here
> so this is where I'm putting it:
> 
> I like the idea here, but the implementation is all off. Firstly, devm_cxl_add_sysram_region()
> is never called outside of sysram_region_driver::probe(), so I'm not sure how they ever get
> added to the system (same with devdax regions).
> 
> Second, there's this weird pattern of adding sub-region (sysram, devdax, etc.) devices being added
> inside of the sub-region driver probe. I would expect the devices are added then the probe function
> is called. 

I originally tried doing with region0/region_driver, but that design
pattern is also confusing - and it creates differently bad patterns.

    echo region0 > decoder0.0/create_ram_region   -> creates region0

    # Current pattern
    echo region > driver/region/probe  /* auto-region behavior */

    # region_driver attribute pattern
    echo "sysram" > region0/region_driver
    echo region0 > driver/region/probe   /* uses sysram region driver */

https://lore.kernel.org/linux-cxl/20260113202138.3021093-1-gourry@gourry.net/

Ira pointed out that this design makes the "implicit" design of the
driver worse.  The user doesn't actually know what driver is being used
under the hood - it just knows something is being used.

This at least makes it explicit which driver is being used - and splits
the uses-case logic up into discrete drivers (dax users don't have to
worry about sysram users breaking their stuff).

If it makes more sense, you could swap the ordering of the names

    echo region0 > region/bind
    echo region0 > region_sysram/bind
    echo region0 > region_daxdev/bind
    echo region0 > region_dax_kmem/bind
    echo region0 > region_pony/bind

--- 

The  underlying issue is that region::probe() is trying to be a
god-function for every possible use case, and hiding the use case
behind an attribute vs a driver is not good.

(also the default behavior for region::probe() in an otherwise
 unconfigured region is required for backwards compatibility)

> What I think should be going on here (and correct me if I'm wrong) is:
> 	1. a cxl_region device is added to the system
> 	2. cxl_region::probe() is called on said device (one in cxl/core/region.c)
> 	3. Said probe function figures out the device is a dax_region or whatever else and creates that type of region device
> 	(i.e. cxl_region::probe() -> device_add(&cxl_sysram_device))
> 	4. if the device's dax driver type is DAXDRV_DEVICE_TYPE it gets sent to the daxdev_region driver
> 	5a. if the device's dax driver type is DAXDRV_KMEM_TYPE it gets sent to the sysram_region driver which holds it until
> 	the online_type is set
> 	5b. Once the online_type is set, the device is forwarded to the dax_kmem_region driver? Not sure on this part
> 
> What seems to be happening is that the cxl_region is added, all of these region drivers try
> to bind to it since they all use the same device id (CXL_DEVICE_REGION) and the correct one is
> figured out by magic? I'm somewhat confused at this point :/.
> 

For auto-regions:
   region_probe() eats it and you get the default behavior.

For non-auto regions:
   create_x_region generates an un-configured region and fails to probe
   until the user commits it and probes it.

auto-regions are evil and should be discouraged.

~Gregory
