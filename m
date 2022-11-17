Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B497A464
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 23:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668728748; x=1700264748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1/Dh243fiVQwbSaM6zFNkxlION/gsKpB6WGJfjGpBtI=;
  b=mGRsAaQo1qkulqah5AcDRoA8dts0FMMvksJtBxLPpaICMJsifWOl0Jot
   CptajacsOkvSZheHnQCFkY2wsetpya+9K5IrtxdWKzYU0mX+7udxW305n
   AHWOCxDwv4/qxXvymZH6JAQ6TH6mJ/1vjYd/9MV+3yonpOdgSeTeu7xf4
   t53qWS95Zxc6V6VkbtSTRNZ/1vwIN9lb9Fdo65BJ0Ra/lWA7QHyUvlDTE
   yMOzi4tCTe028eq8RBrssrr4wRtxWEzwdU0um+MV1qc391z4qjtnpOou0
   fLohbaCKZR+rhQUmdleAgdWPOKuGtVj14eoEYiztC6AMII0gTAF777AjG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="292707707"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="292707707"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:45:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="642294828"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="642294828"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.84.12])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 15:45:36 -0800
Date: Thu, 17 Nov 2022 15:45:34 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/5] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <Y3bHnnt3j/tDrcyN@aschofie-mobl2>
References: <cover.1668133294.git.alison.schofield@intel.com>
 <73b2edf5ded979cb3164bcf2b76c4f300cdf2250.1668133294.git.alison.schofield@intel.com>
 <20221116125640.00006a68@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116125640.00006a68@Huawei.com>

On Wed, Nov 16, 2022 at 12:56:40PM +0000, Jonathan Cameron wrote:
> On Thu, 10 Nov 2022 19:20:04 -0800
> alison.schofield@intel.com wrote:
> 
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > CXL devices maintain a list of locations that are poisoned or result
> > in poison if the addresses are accessed by the host.
> > 
> > Per the spec (CXL 3.0 8.2.9.8.4.1), the device returns this Poison
> > list as a set of  Media Error Records that include the source of the
> > error, the starting device physical address and length.
> > 
> > Trigger the retrieval of the poison list by writing to the device
> > sysfs attribute: trigger_poison_list.
> > 
> > Retrieval is offered by memdev or by region:
> > int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > int cxl_region_trigger_poison_list(struct cxl_region *region);
> > 
> > This interface triggers the retrieval of the poison list from the
> > devices and logs the error records as kernel trace events named
> > 'cxl_poison'.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Trivial comment inline + I haven't been tracking closely development
> of this tool closely so hopefully this will get other eyes on it who
> are more familiar.  With that in mind:
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks Jonathan!
I cleaned up the ugly line breaks and I'll carry your Reviewed-by
forward.

> 
> > ---
> >  cxl/lib/libcxl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym |  6 ++++++
> >  cxl/libcxl.h       |  2 ++
> >  3 files changed, 52 insertions(+)
> > 
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index e8c5d4444dd0..1a8a8eb0ffcb 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1331,6 +1331,50 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
> >  	return 0;
> >  }
> >  
> > +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> > +{
> > +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > +	char *path = memdev->dev_buf;
> > +	int len = memdev->buf_len, rc;
> > +
> > +	if (snprintf(path, len, "%s/trigger_poison_list", memdev->dev_path) >=
> > +	    len) {
> 
> Ugly line break choice to break mid argument..
> 	if (snprintf(path, len, "%s/trigger_poison_list",
> 		     memdev->dev_path) >= len) {
> would be better.
> 
> > +		err(ctx, "%s: buffer too small\n",
> > +		    cxl_memdev_get_devname(memdev));
> > +		return -ENXIO;
> > +	}
> > +	rc = sysfs_write_attr(ctx, path, "1\n");
> > +	if (rc < 0) {
> > +		fprintf(stderr,
> > +			"%s: Failed write sysfs attr trigger_poison_list\n",
> > +			cxl_memdev_get_devname(memdev));
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> > +CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
> > +{
> > +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> > +	char *path = region->dev_buf;
> > +	int len = region->buf_len, rc;
> > +
> > +	if (snprintf(path, len, "%s/trigger_poison_list", region->dev_path) >=
> > +	    len) {
> as above.
> 
> > +		err(ctx, "%s: buffer too small\n",
> > +		    cxl_region_get_devname(region));
> > +		return -ENXIO;
> > +	}
> > +	rc = sysfs_write_attr(ctx, path, "1\n");
> > +	if (rc < 0) {
> > +		fprintf(stderr,
> > +			"%s: Failed write sysfs attr trigger_poison_list\n",
> > +			cxl_region_get_devname(region));
> > +		return rc;
> > +	}
> > +	return 0;
> > +}
> > +
> >  CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
> >  {
> >  	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> > index 8bb91e05638b..ecf98e6c7af2 100644
> > --- a/cxl/lib/libcxl.sym
> > +++ b/cxl/lib/libcxl.sym
> > @@ -217,3 +217,9 @@ global:
> >  	cxl_decoder_get_max_available_extent;
> >  	cxl_decoder_get_region;
> >  } LIBCXL_2;
> > +
> > +LIBCXL_4 {
> > +global:
> > +	cxl_memdev_trigger_poison_list;
> > +	cxl_region_trigger_poison_list;
> > +} LIBCXL_3;
> > diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> > index 9fe4e99263dd..5ebdf0879325 100644
> > --- a/cxl/libcxl.h
> > +++ b/cxl/libcxl.h
> > @@ -375,6 +375,8 @@ enum cxl_setpartition_mode {
> >  
> >  int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
> >  		enum cxl_setpartition_mode mode);
> > +int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > +int cxl_region_trigger_poison_list(struct cxl_region *region);
> >  
> >  #ifdef __cplusplus
> >  } /* extern "C" */
> 
