Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAA43E6388
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782336515; cv=none; b=i5lTPJahcPPjrJDcVug/Wo1+ehBStXN77Z9oRAg++wxuGlajTM70EWwHJyXj2hgPbfsFol8G530ubQXPPYKiOXLTLpTYJVkX1FeykeeP44zwzphgB7Lj5+HQeJywZlQC9BPnJcnQkQ/Ffitj3SEd9q87R2WdnTt2bYV8KSzqpvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782336515; c=relaxed/simple;
	bh=/7Bi2SP89UaVH+WNAX/JDNY8yTBbPafOtAVxlzBF7ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQwZ7m/9VvhCfByU5jkpVLvBO+qWzsNWTxGE3Un07y2xvYbzYIa2y8HYhfVjBAcqDOzboXYLXwBgMKs/ykCGOEXVcdrU4+s7SM90020tc5XRTwCn1Sj5HCOSFv0E4rnRE93HKQqQLt6x7YaW+LVtlQYDVIK8sR39ogLDGoUZZvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KYECt3oz; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KYECt3oz"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9204711e831so152779685a.2
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782336513; x=1782941313; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O6KvGnSeke+GyyXEP/Bx0FGRYD1wjPR1HoPpU93wagg=;
        b=KYECt3ozoyiN3MYkpZUGQnWH3YtuenAWTZqqlqADghLfAP3CwkWDzZoZBarof3NSHN
         g4qwyEAvQd8mQBuB6db+DHTXaP4iyc3qOstpEJN02iQcYoe5RmncUvnEhZZ7keUwVLh+
         LVfUmcD29pnzXRHyA7MeNoXIwHVPABX5t/CKJKovZZt9jQyjmzkCoyhAkGjQYR9Ot5AC
         T8e6brmzIruc88K5/tjBumqT+Wt7yHLnsKgLsZgVzughIcd9zXxLqBh02qS6k38VUvP6
         8wvJbXdrIwByn4aqDEdJ1rPEBFnIl6NvSHmAqouEb3S+Z6+qGyQwqLX1FMl9NTjpx0n4
         WISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782336513; x=1782941313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O6KvGnSeke+GyyXEP/Bx0FGRYD1wjPR1HoPpU93wagg=;
        b=DvMtAL4+svYGrEmOLOihVPGnUSxyhahYnHqd9avk5TC/TT0PnKlgdivmVtxqxpuBYu
         ZllmN/oRhc3DsdEwfcIqmVgD6Z+9LtXSVgtFwkB4plkywe+Nr+BMJi54qeR2xw52JpM9
         7Ol5L9UHkxm6tiJGNrN+OdshHNxs7lHaUCNx5hieZ6gNPRU4+8f63GKpWyjddYxQZSVe
         53x7pMBNRsIHwydpxigsFdUg7pGl6nbyW1OhSrskKpnrLw5i1NFoP0Z2wNXD5sK/NWn6
         zl0Z75q5OEM5nnE8eMYGA4g0XtIZaXkYdAQBhGEeV/w9Tx8EbmaPjTb8DAmC3+F2Wcgh
         MadA==
X-Gm-Message-State: AOJu0YzIPnBsJ3BctG3WzEGXrXpE43UANhTYoxoLaT29vSavxN/J9CJv
	cDvaDboqyyTmWDAvyX715O1+lKYDvFIB0BIaSIJIrw6w72opWuGB6SOumYRnd43ESRY=
X-Gm-Gg: AfdE7clMgNg5Vm8TrvavmN2e9itxS9N/6WDQIb5EFrdaQD3bSThhFKyd33Ldz3VUqQ1
	pq2BegAUoxmaWRDCtt4FjGx1MVdFVwHKxUhdSw2lqXdjMfkJTQ+Esr1bSYiwLJe0FB915eTIAwT
	BXCYzgxGoQd4TAYKaJ1sRF34icONs7r1yqeuQ8RI2MB1l+YPCbyYEDDHM3h0EQDYqY+4y2Bi4wz
	ahTltEPUQVbTIEcGgtPg0NQJaV5e34I96eBFPnrmHuY7XMmH1FopYQNJzn+GI4X6JOKgPs5ZSTD
	vphPCabSk/fsm2vicNc1ed0qc090Bpu+TdhELzelZ792Kz5xrR3Pw8pX5+TkmujmzWwpVerjDRm
	/R/FIORTH67u04M7xQbd/ezbqUFQ9ml+jlaH5jUMxt+8pSBy3QjrI/5gGidZa+k5uzI8+TyDVtE
	06yAf1G0rQY7HyfwGIZchhBZQENmo7Ptoe0yocmlb62sJpl2bHpxMlhq4V+9Lm4LicGqdD
X-Received: by 2002:a05:620a:c45:b0:915:abc4:b570 with SMTP id af79cd13be357-9277ea2e6e2mr831365785a.48.1782336512781;
        Wed, 24 Jun 2026 14:28:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fd39106asm630817585a.7.2026.06.24.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 14:28:32 -0700 (PDT)
Date: Wed, 24 Jun 2026 17:28:27 -0400
From: Gregory Price <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ajxL-5d3JUArPRyo@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <20260624151122.AFE551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624151122.AFE551F000E9@smtp.kernel.org>

On Wed, Jun 24, 2026 at 03:11:21PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The protection against deadlocks during driver unbind can be completely bypassed if the underlying memory blocks are manually onlined via the core memory sysfs, causing state desynchronization.
> 
> commit fa89899811083ada324ea3db8204b1c135005af5
> Author: Gregory Price <gourry@gourry.net>
> Subject: dax/kmem: add sysfs interface for atomic whole-device hotplug
> 
> > @@ -348,20 +490,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >  #ifdef CONFIG_MEMORY_HOTREMOVE
> >  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
> >  {
> 
> [ ... ]
> 
> > +	if (dax_kmem_state_is_online(data->state)) {
> > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > +		any_hotremove_failed = true;
> > +		return;
> > +	} else if (data->state == MMOP_OFFLINE &&
> > +	    dax_kmem_do_hotremove(dev_dax, data)) {
> > +		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
> >  		return;
> >  	}
> 
> [Severity: High]
> Can this deadlock during unbind if the memory state is desynchronized?
> 
> If the device is configured with auto_online_blocks=offline, data->state is
> initially MMOP_OFFLINE. If a user manually onlines the underlying memory
> blocks via the generic /sys/devices/system/memory/memoryX/state sysfs
> interface, data->state remains MMOP_OFFLINE.
> 
> During unbind, dev_dax_kmem_remove() will evaluate
> dax_kmem_state_is_online(data->state) as false and proceed to call
> dax_kmem_do_hotremove() instead of safely aborting. This attempts to offline
> the blocks while holding the device unbind lock, bypassing the intended
> deadlock protection.
> 

Pulling this feedback onto the list so you know i'm not going to address
both pieces here when it comes back in the next version.

1) dax/state and memoryN/state can become desynced.  We can't do
   anything about this without a memory notifier that prevents this
   desync by disallowing memoryN/state toggling for those blocks.

   https://lore.kernel.org/linux-mm/20260114235022.3437787-6-gourry@gourry.net/

   this unfortunately breaks existing userland tools.  I was told to
   drop the notifier path and explore deprecation at a later time.

2) What I will address: if state=UNPLUGGED we can safely proceed,
   otherwise we'll simply fall back to the old remove_memory() behavior
   where deadlocks are still possible.

   I'll add comments that address this.

~Gregory
