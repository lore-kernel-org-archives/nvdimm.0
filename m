Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A22355F42;
	Mon, 12 Oct 2026 11:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791804389; cv=none; b=c6stFY+jRaKyQvTCno5cjlLx3ihdgC+Vs5Cbz9ztqggJqqsVHQF3DOp/++gbA9JOxPLE+lKBou53APyQzfv9mN1JkZGjDaKfmkJ0jgRNf72O9laddOfw1JVaAc6QCeAuXSeCAyWWB8Wbz4xxmkd6gUKZ2ddsfr3/mM71JLPuspo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791804389; c=relaxed/simple;
	bh=RaPMbH9HBGK8Gvdpc2qB78HHMcmqWSXamHE+N116ywU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrdH5eiNVA1a+QmPCy98P2OIj6eys+IY6osk4Hp9GBqYC3mrgivt+Rlx6mmDk3BGz69dDFPguv6ahU6REH0nWrKXeLjRnrP221cGZsORtNrkD+CPZnrnmvy0mVAUEXkYlleP+ZbeFBYo4qgXpV6wnMacpEUfkWZU6HAbDXF5nso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ye9TSphQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ye9TSphQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FDE1F0089B;
	Mon, 12 Oct 2026 11:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791804388;
	bh=1oHJQSoxYyxiwgFYTb/YJ3RLFHms1wutckFxzTUtbI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ye9TSphQp8z6zYA2f1LHn8vYECX3nHgd51QCLZl+oGMyMWD/cquUreM41X7nUMlNz
	 1czVfMlC8vCQSTLXyJYRtJ2NQJZBteOucQZmqwHXCvm+9CGjjH6dXgFa663cD2QXmh
	 1eNCgwfJ64Vz5MdIXPtLJwWWx5aCg5Jly0nDspCr1rwzVLarL4eYm4VJZ/N3prjX0Y
	 /01hxkRI1iXA/qdEhkuEetQ6tt5Yq3cYvyw3wS5Yl9EkMYVB+R/M+mW+UtJeUU9M8X
	 tbmTtebcLtr9HeRHktovUm1skJYdG7LJWiBT2KlmSJY4O3JGVbT2ub7Ud1ssSUL8Tk
	 1paBxLxJKkq2Q==
Date: Mon, 12 Oct 2026 12:26:03 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: Richard Cheng <icheng@nvidia.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, Dan Williams
 <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>, Alison Schofield
 <alison.schofield@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, Ira
 Weiny <iweiny@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, Fan Ni
 <nifan.cxl@gmail.com>, Li Ming <ming.li@zohomail.com>, Benjamin Cheatham
 <benjamin.cheatham@amd.com>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v15 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <20261012122603.06c71c62@jic23-hlaptop>
In-Reply-To: <asrBsS556W6ijUMH@cxlqual>
References: <20261007201828.952-1-anisa.su@samsung.com>
	<20261007201828.952-3-anisa.su@samsung.com>
	<asdRsFS-Amd6IDws@MWDK4CY14F>
	<asrBsS556W6ijUMH@cxlqual>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Please remember to crop down to only the context you need!
(grumpy as on a train and the pagedown key on my laptop requires pressing far too
many things at once!)

> > > diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> > > index b3419df586b9..def26c490dfe 100644
> > > --- a/drivers/cxl/core/memdev.c
> > > +++ b/drivers/cxl/core/memdev.c
> > > @@ -643,6 +643,53 @@ int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(cxl_mem_dpa_fetch, "CXL");
> > >  
> > > +int cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > > +{
> > > +	struct cxl_dc_partition_info dc_info = { };
> > > +	struct device *dev = mds->cxlds.dev;
> > > +	u64 total;
> > > +	int rc;
> > > +
> > > +	if (!mds->cxlds.media_ready)
> > > +		return 0;
> > > +
> > > +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> > > +	if (rc) {
> > > +		dev_warn(dev,
> > > +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> > > +		return rc;
> > > +	}
> > > +
> > > +	if (dc_info.start < info->size) {
> > > +		dev_err(dev,
> > > +			"DC partition 0 base %#llx overlaps static capacity ending at %#llx\n",
> > > +			dc_info.start, info->size);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/* A gap between static capacity and the DC partition is not supported */
> > > +	if (dc_info.start > info->size) {
> > > +		dev_warn(dev,
> > > +			 "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n",
> > > +			 dc_info.start, info->size);
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	if (check_add_overflow(info->size, dc_info.size, &total)) {
> > > +		dev_err(dev,
> > > +			"DC partition 0 size %#llx overflows DPA space ending at %#llx\n",
> > > +			dc_info.size, info->size);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	info->size = total;
> > > +	dev_dbg(dev, "Adding dynamic ram partition; %#llx size %#llx\n",
> > > +		dc_info.start, dc_info.size);
> > > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> > >   
> > 
> > Hi Anisa,
> > 
> > This function uses info->size, which is Total Capacity, as the end of static
> > capacity, but now we require DC partition to start at the end of the last
> > static partition, which is RAM + PMEM. CXL r4.0 8.2.10.9.1.1 "Identify Memory
> > Device" only requires Total Capacity to be >= the sum of RAM + PMEM.
> > If they differ and device place DCD region base at Total, we can pass the check
> > here but cxl_dpa_setup() fails probe with -EINVAL, so a DCD config
> > quirk costs the whole memdev instead of just DCD.
> > 
> > Think of an example, Total capacity 12G, RAM has 8G, PMEM has 2G, now if
> > DC starts at 12G, this function check will be passed, but cxl_dpa_setup()
> > will see PMEM end at 10G, DC start at 12G, think of it as a hole.
> > If the DC start at 10G, we can pass cxl_dpa_setup(), but the test here will see
> > 10G < 12 G and think DC region start inside the device memory and print
> > "overlaps"
> > 
> > Maybe derive the static end from info->part[nr_partitions - 1] and size
> > info->size from DC partition end ?
> >   
> Oh you're right.... fixed.

For this sort of thing where you are fully agreeing. 
Just fix it and acknowledge in change log!  That way there is no email
for others to get grumpy scrolling through :)

Jonathan
