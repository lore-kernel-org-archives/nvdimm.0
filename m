Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24277212542;
	Tue,  4 Aug 2026 00:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785802077; cv=none; b=NqRk4bhDmfdaNhWopLEDQl+1v1NEYLgaLZQgr9RTp+bqQs+ADSa63p2votgGELCVMn5Il5kRBzIWkwoIAS7NOF4XUCEoSD0PlomOngOMcladWJY/dnFjjVD2JHWyuGsUEGeHFQBpS6wgYMjNIyImLtgzRRBPJq6jZVCyXydUPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785802077; c=relaxed/simple;
	bh=+UgZRJOUlb2wkaGO3sSNzO9rV3gJGatJwDWAKNnSV7k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2uTdprBJgt28enW42ja2hU2JnDo1OXTSI0Fvo7AYP73dgSIiC7zQ+SaHzVt0fqDBOV1TTnOYD9CbMC2DhT0u/IH4AVzPetfycfBhy2h4BWm4Qtv0iOyn4AO7t0ANOZO8tBO0u4J0b4OLuk6U0mNdNKLxRkPudx5/+QsBMBKAAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmYBA+Bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmYBA+Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D041F000E9;
	Tue,  4 Aug 2026 00:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785802075;
	bh=GOt7zxUu6npV50dZ09FBcEPjIvGg5YF6Sq46LCf/WXA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jmYBA+BdsVK7YKUEEBLHzEczO+L6nBOA+BXCMUo7Y80NH1G3nSfK1Sfj19ttGBsE9
	 eMuz3dIedbLeqpldZutSS9T7K7z4Z6KN6uqHGsuFspG0teVOpdeOCVRswkZN0gb7kQ
	 88vlTIoBZgun4u7JRtbZgL4koKdB2P/vo4sigZECfy4/+yEaA0qGSyLUHnrGku7aMq
	 S+9YD8YhVG2Ty2ahLD8WJKBM2GqkfJO4NV+cyR3R1CgjFghGAorSls/6HI3Fe3UvKM
	 P76TPSd935YJ4jb51JplycCneFsNTxWw78z4wWovqSZtlc76FhRVQW0p+QkfAbumgx
	 W71umeXEbf/Gg==
Date: Tue, 4 Aug 2026 01:07:48 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, "Anisa Su" <anisa.su887@gmail.com>,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <20260804010748.7f9f8174@jic23-huawei>
In-Reply-To: <20260731090250.0C8DE1F000E9@smtp.kernel.org>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-4-anisa.su@samsung.com>
	<20260731090250.0C8DE1F000E9@smtp.kernel.org>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 09:02:49 +0000
sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] The commit message claims to extract and store the 'read only' attribute from DSMAS tables, but this logic is completely missing from the code.

Given it will make a lot of difference to a user if they think they have writeable
memory that isn't - I think we probably do want to have readonly here.

> [ ... ]
> > @@ -266,15 +268,26 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
> >  		bool found = false;
> >  
> >  		for (int i = 0; i < cxlds->nr_partitions; i++) {
> > +			enum cxl_partition_mode mode = cxlds->part[i].mode;
> >  			struct resource *res = &cxlds->part[i].res;
> > +			u8 handle = cxlds->part[i].handle;
> >  			struct range range = {
> >  				.start = res->start,
> >  				.end = res->end,
> >  			};
> >  
> >  			if (range_contains(&range, &dent->dpa_range)) {
> > +				if (mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
> > +				    dent->handle != handle) {
> > +					dev_warn(dev,
> > +						 "Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
> > +						 &range, handle, &dent->dpa_range,
> > +						 dent->handle);
> > +					continue;
> > +				}  
> 
> [Severity: Medium]
> Could this trigger spurious warnings on valid hardware configurations?
> 
> The CDAT specification allows overlapping DSMAS ranges with different handles
> to support multiple memory types or sharing characteristics for the same DPA
> space. 

Huh?  Where did it get that from.  I'm 99% sure you can't have overlapping
DSMAS entries for the same DPA space.

> 
> If a compliant device provides multiple valid DSMAS entries that overlap
> the partition's range but have different handles, won't iterating over them 
> incorrectly flag the unselected ones as a perf mismatch?
> 
