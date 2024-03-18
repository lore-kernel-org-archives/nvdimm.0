Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9504957327
	for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 20:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710792705; cv=none; b=HK2m9dcltBChRma9c7HVqBcd5u7V4OtzpTJpP6kQPer1cbNdjF76MNv9jXyGer66Wk7zyqzwHnu0vVE7FaL6ZG1PR8MCZ6aaN2YELsi/7aNRfdI6uyOUBuq58qDIlK4aWK0KTHC7aFpeHTy6k2HsvFo4SKFj0d3uoA0yC+6EVbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710792705; c=relaxed/simple;
	bh=dY8gMFPLtLVkyJdHC2aaWdNSzyo1U2DAcs8oDBai1HQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/GyG1+cR7XUDBFAfye95GBLoSVetjXFxoQvSE1/H5/SxBAeQKdZ+vXG8xQ4/HUKoAQv9Cu8bklnRqQlVRbgRRvLNm4ASailmRfxHijh6czAAQxMBvUKxaW7NR1rJLAQencoou37P4xVZ38mUDC0UTBjWtwH5kyN16h35JjH/dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmFTjAGm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmFTjAGm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710792703; x=1742328703;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dY8gMFPLtLVkyJdHC2aaWdNSzyo1U2DAcs8oDBai1HQ=;
  b=jmFTjAGmRWGwMjtPxobRvO5G7Rv5OPRydxa0sq32nJOUQea2QRMIB3rh
   PF4tR5KbXJJuhYdpqDdHmgJzLDHpLASIwQH4hlweivhqvf7MDGACt/qQV
   mcQLG8IXT5/rISXijvG8v/GKd3By1G4tWXbXGfCeR6e4m7oY9oYMCxs1Z
   L3kvyPPGTlF3Wv7Cz65wHTKrc7chsQv4MKR+4r2dZnXg158CckpTLioMH
   Mcptso/ifld9R12o9xROAzUP3OnCaw+j5gkFsfjU6ooANsa1CrYRplqU6
   50MkKjJxpgY9UEwItaAF1lNFKQMHWu9Adg9yy9kWucykbqB63MmG62Kug
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="9397965"
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="9397965"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 13:11:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,135,1708416000"; 
   d="scan'208";a="13611061"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.83.98])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 13:11:39 -0700
Date: Mon, 18 Mar 2024 13:11:38 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: fan <nifan.cxl@gmail.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v11 1/7] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <Zfif+rGM+GbJmBvv@aschofie-mobl2>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1710386468.git.alison.schofield@intel.com>
 <Zfh_EYPNeRJl8Qio@debian>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zfh_EYPNeRJl8Qio@debian>

On Mon, Mar 18, 2024 at 10:51:13AM -0700, fan wrote:
> On Wed, Mar 13, 2024 at 09:05:17PM -0700, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > CXL devices maintain a list of locations that are poisoned or result
> > in poison if the addresses are accessed by the host.
> > 
> > Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> > List as a set of  Media Error Records that include the source of the
> > error, the starting device physical address and length.
> > 
> > Trigger the retrieval of the poison list by writing to the memory
> > device sysfs attribute: trigger_poison_list. The CXL driver only
> > offers triggering per memdev, so the trigger by region interface
> > offered here is a convenience API that triggers a poison list
> > retrieval for each memdev contributing to a region.
> > 
> > int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > int cxl_region_trigger_poison_list(struct cxl_region *region);
> > 
> > The resulting poison records are logged as kernel trace events
> > named 'cxl_poison'.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym |  2 ++
> >  cxl/libcxl.h       |  2 ++
> >  3 files changed, 51 insertions(+)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index ff27cdf7c44a..73db8f15c704 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1761,6 +1761,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
> >  	return 0;
> >  }
> >  
> > +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> > +{
> > +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > +	char *path = memdev->dev_buf;
> > +	int len = memdev->buf_len, rc;
> > +
> > +	if (snprintf(path, len, "%s/trigger_poison_list",
> > +		     memdev->dev_path) >= len) {
> > +		err(ctx, "%s: buffer too small\n",
> > +		    cxl_memdev_get_devname(memdev));
> > +		return -ENXIO;
> > +	}
> > +	rc = sysfs_write_attr(ctx, path, "1\n");
> > +	if (rc < 0) {
> > +		fprintf(stderr,
> > +			"%s: Failed write sysfs attr trigger_poison_list\n",
> > +			cxl_memdev_get_devname(memdev));
> 
> Should we use err() instead of fprintf here? 

Thanks Fan,

How about this?

- use fprintf if access() fails, ie device doesn't support poison list,
- use err() for failure to actually read the poison list on a device with
  support

Alison


> 
> Fan
> 
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
> > +{
> > +	struct cxl_memdev_mapping *mapping;
> > +	int rc;
> > +
> > +	cxl_mapping_foreach(region, mapping) {
> > +		struct cxl_decoder *decoder;
> > +		struct cxl_memdev *memdev;
> > +
> > +		decoder = cxl_mapping_get_decoder(mapping);
> > +		if (!decoder)
> > +			continue;
> > +
> > +		memdev = cxl_decoder_get_memdev(decoder);
> > +		if (!memdev)
> > +			continue;
> > +
> > +		rc = cxl_memdev_trigger_poison_list(memdev);
> > +		if (rc)
> > +			return rc;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
> >  {
> >  	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> > index de2cd84b2960..3f709c60db3d 100644
> > --- a/cxl/lib/libcxl.sym
> > +++ b/cxl/lib/libcxl.sym
> > @@ -280,4 +280,6 @@ global:
> >  	cxl_memdev_get_pmem_qos_class;
> >  	cxl_memdev_get_ram_qos_class;
> >  	cxl_region_qos_class_mismatch;
> > +	cxl_memdev_trigger_poison_list;
> > +	cxl_region_trigger_poison_list;
> >  } LIBCXL_6;
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index a6af3fb04693..29165043ca3f 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -467,6 +467,8 @@ enum cxl_setpartition_mode {
> >  
> >  int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
> >  		enum cxl_setpartition_mode mode);
> > +int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > +int cxl_region_trigger_poison_list(struct cxl_region *region);
> >  
> >  int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
> >  							   int threshold);
> > -- 
> > 2.37.3
> > 
