Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E0444999E
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 22:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783634933; cv=none; b=p/ptCOyemgKhrti8tL7yeuOrG9cFan47aCU+GEkRlPXzBJqqNCal/jq++SE46D5asKpc4GFLUQTyq3Mb6jV1p/B1eyAr/TzrvSP5Uf+VePShrDPrAz/gY1l62/Ql0MukJQpo6j9g1MUvKOEXz/YZc3Fhs1DlMtK62j8P1Glgd1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783634933; c=relaxed/simple;
	bh=6RBF0jp09O3guB5Q86RDVYGXWp7JXTcPagL5/X5HeO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucA83JSM47m5nKXm7VCS8egKpApjX44H7RYJQA/65E1z8XYI0zU2oXxHykWapxLsKsHFoQRUpxEX8QTD/YUYg7QWtFRyeSaIwkjqCRXfi10G+6rVjj1HEUrPtSTArMvMqBcEdYeDahV5k+Ok2EpHQDxEt7/R122qwQgzVN991VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rh6d+9UA; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rh6d+9UA"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-902e4af2d9dso80936d6.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783634931; x=1784239731; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y5hy/40qOWrDje+rO1HwX24k6GcjiBFx+d8whX1kHrQ=;
        b=rh6d+9UAioqtUzV/5d8kIjd5zdntdTBoOBf7HHbCVbVzPvR6nax5cmwirxlZsmfNxH
         LuuWaoujccgH4cz4aNEZy/Mr0uInfkapfZrkDosq3bXzj7myONNyJK/XqY8NfXjlZoGj
         HN8NgJhuzkmqMm/a6hshpXyyNRZ3H8jLtQ4qSi7K+YKZq9kurDWPVwkYF7MS3I+f5FgV
         rmcKZOeDS0jeX9GpyoVlJ2Ld2DqkjOrfaNhOgNd0bINqWEq4kzhCfDQbsNo/Xgz7W9s7
         9aw02ykG8sZPWJSBvBdypdKWQZ13Y4b2A6Qu7aZ1IxYGLThzKas3jU2a5obb2vT6NzRW
         pGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783634931; x=1784239731;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y5hy/40qOWrDje+rO1HwX24k6GcjiBFx+d8whX1kHrQ=;
        b=K1ahKMBdK14l0RUVvj0/Q9NphicXJd5DFxQK3It9pmo+7R184v0fXeuOgWRQtcj7fs
         m6ZjtkAzp7KL4KzrXYOJrxRLifJ0jkvrelorNYaPYNuPaLWcswFD7zzyPHWlAYhWM4GX
         smF/Rtexx/jsIRfrj1AKzLroWggE3wHCCTAWusXi6mWj9ylUyYvKh40bxkKs81DTH3Sg
         33avG0jYu9O+JPORCfFkFWQJSnUx1koWnUsokC5NZtqreXfFGDEu9aHD1T7JyNyLvyJR
         snbiXpk8/KkzQG5qtrOTaYd0R9Q6dAx+UZDz/E0RnQ8N72f1tYKkETEMowoLdGwNKckR
         Jicg==
X-Forwarded-Encrypted: i=1; AHgh+RphemP4akvPa22V/oiggPbNUUuprkH4v6OP5NOma2Xayt4RoX591OOWPjHxoYDfTngD7hfvPnA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8RW8AErGKfYtcXUfVXdJzEhlhFT/7eXH3TvDaQkKBrpi3zCRp
	11+qKDCvbE1lebdlt01Cksz0fjwOJAV3qIqgRT7s68pc+75GQkdtXfKvx9Wvx248imR/fkqATVE
	hjdfk
X-Gm-Gg: AfdE7cnCDMIBlxogKzf4bCOOg+s8G8rk8X4E/USUAbWoxoQ8b6tFVqjb/LEQIiSvsQD
	UffsS3dqR6L+eZ1QrscIjqiGas71FjLIvd1ER0Mv4wXZSMVlkhwyGPBJu9VFDUHxFelT81wOxGm
	DGO+nmpIl6Z9wHs7AdCXQsYeCVG4SHx54bwXIb+2CAF4mjd5sP6cDWvOkqME2cfADU7e/8Ea4S8
	vvjSxRXyR+low5LrGZEZnzWJhQvl2SbIA4w/t7bXiPyW+MTB4H5ofxJwqQvP11XJ1pZGddn/GbO
	RvEFyoSjH5XtsxlunHeUxewAAxGz9wKY5yBve0kKNcgvG1bvcEAtxHgKolKeyT1AWUTabwBXfBk
	OGYXAgp1IE6uzjoOdeTNlmIVWuuv5CbwNSHE8Kzm8tC/wo4nAsXWyh7DGrwRQ6nZueWk8thlrf1
	ZSpjHQXuklCWvCT09HP+jx0H6uU+bfmmP7q7xuJ0rZUcqc+pIISABjDZHVjyse8fk3lff4
X-Received: by 2002:a05:6214:1306:b0:8ef:1840:2bd8 with SMTP id 6a1803df08f44-9024204ca5cmr14984856d6.33.1783634930620;
        Thu, 09 Jul 2026 15:08:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87cacb8sm26797256d6.49.2026.07.09.15.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 15:08:49 -0700 (PDT)
Date: Thu, 9 Jul 2026 18:08:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>

On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > There is no way for drivers leveraging dax_kmem to plumb through a
> > preferred auto-online policy - the system default policy is forced.
> > 
> > Add 'enum mmop' field to DAX device creation path to allow drivers
> > to specify an auto-online policy when using the kmem driver.
> > 
> > Capturing the system default would otherwise break the ABI, because
> > the system default can change - but we would be statically assigning
> > the value at device creation time.
> > 
> > To resolve this we add DAX_ONLINE_DEFAULT, which defaults devices to
> > the current behavior, while providing a clean way to override it.
> > 
> > No behavioural change for existing callers (still the system default).
> 
> So I know you have some future usage for this ability, but it is not
> present in this set. The only piece that *is* used is that the
> online-type from the new sysfs interface gets plumbed through to
> __add_memory_driver_managed().
> 

Correct.

I didn't want to cross three subsystems in one go, I do intend to follow
this up with at least a CXL build option to override the global hotplug
policy by plumbing it through to the existing cxl auto-probe process.

Some of the accelerator stuff is still a bit up in the air but the base
driver can still benefit from this as well.

> Are these touches:
> 
> >  drivers/dax/cxl.c         |  1 +
> >  drivers/dax/hmem/hmem.c   |  1 +
> >  drivers/dax/pmem.c        |  1 +
> 
> ...premature until the first user arrives that with the background story
> about how it knows to set the policy?
>

This was more a matter of having the DEFAULT set consistently across
the dax driver variant probe() functions to make the behavior explicit.
I didn't want an un-set value bug to creep in here somehow.

Happy to drop them if you think that's unneeded.

> If DAX_ONLINE_DEFAULT is a sentinel for "default" should
> DAX_KMEM_UNPLUGGED be a different sentinel than (-1)?
> 

They don't actually run into each other.  DAX_ONLINE_DEFAULT is
overwritten at probe time with the system default policy, so
`dax/state` can never perceive it (even if the values are the same).

But this is visually confusing i suppose, so I'll just swap it for -2.

> Feel free to add:
> 
> Reviewed-by: Dan Williams <djbw@kernel.org>
> 
> ...to this and the previous patches when that is fixed up.

Thank you!
