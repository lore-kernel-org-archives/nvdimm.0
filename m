Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D57F9E5
	for <nvdimm@lists.linux.dev>; Tue, 19 Mar 2024 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710866625; cv=none; b=q7SleF4PcXj8kMi8v9GTWsVdKveg62/o6ZWR4TYO4S60ZqEagQMloyNnFtJfq8CjYzA37j+M2D/KPVqwxULI5PQc7wdi0vhYAGrGSwIToCpC2jhtmXdvug6EDVU41+MkfqduRiCeiLV08T18VLXINgl0/+ZuYvHVxufmgAweAqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710866625; c=relaxed/simple;
	bh=/hLt7roi2Gp9KHrhjatjGJjY8fbdiDimpOPsS6QdHck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDf651Ccc1WR/h/ybTcWrKdijwUPTAmJpTNZ3CSsVi+K/pKsqj1muQxe3jExIolsC29hU1RR/5SAIu8Z24WEobvkA7yQvQu9rZ1KoO3poaAzsyoQXl5MXo635AN1BmVWnmYH/HNglW6L0x5xq0FyPb7+nOUyRp6Razm5RQnWCZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CrxisTtN; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CrxisTtN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710866622; x=1742402622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/hLt7roi2Gp9KHrhjatjGJjY8fbdiDimpOPsS6QdHck=;
  b=CrxisTtN0HYZ+vZNZ5MoiwqLdkeov3ZhbEwoEoqZTJJmeEqfRaU4qqU/
   7rntJFju1SF9HEBuA6/rzuYvYBIyCExt8FIwMUfAIiDSIujSfJsn+JljN
   /HLSxiADhnTrM8h7AmiFBakQGYBNxn5+1mXd8vGDyrKWX5u4z6dUZP/44
   xwc1eLQ4PGqJbynQrsJjAPXxEWoUdaeSEiukZj0y5f/97iyqqEG7NEmWz
   AgR9AAWgj4Tua5Kfam3YRBVJBP32Thq0+2Y8J8T0tXMzCSUgnV/mbNCkh
   j+DqzLvTy57HCqJSHGQR7ZY40LS0wIEQogHUR7vAY9qu8kiuw6VhsDTOR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="16893880"
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="16893880"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:43:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,137,1708416000"; 
   d="scan'208";a="13784425"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.17.40])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 09:43:42 -0700
Date: Tue, 19 Mar 2024 09:43:40 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: fan <nifan.cxl@gmail.com>, Vishal Verma <vishal.l.verma@intel.com>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v11 1/7] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <ZfnAvHt5Vclv949x@aschofie-mobl2>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1710386468.git.alison.schofield@intel.com>
 <Zfh_EYPNeRJl8Qio@debian>
 <Zfif+rGM+GbJmBvv@aschofie-mobl2>
 <65f8abb2ee1ed_aa22294f5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65f8abb2ee1ed_aa22294f5@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Mon, Mar 18, 2024 at 02:01:38PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > On Mon, Mar 18, 2024 at 10:51:13AM -0700, fan wrote:
> > > On Wed, Mar 13, 2024 at 09:05:17PM -0700, alison.schofield@intel.com wrote:
> > > > From: Alison Schofield <alison.schofield@intel.com>
> > > > 
> > > > CXL devices maintain a list of locations that are poisoned or result
> > > > in poison if the addresses are accessed by the host.
> > > > 
> > > > Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
> > > > List as a set of  Media Error Records that include the source of the
> > > > error, the starting device physical address and length.
> > > > 
> > > > Trigger the retrieval of the poison list by writing to the memory
> > > > device sysfs attribute: trigger_poison_list. The CXL driver only
> > > > offers triggering per memdev, so the trigger by region interface
> > > > offered here is a convenience API that triggers a poison list
> > > > retrieval for each memdev contributing to a region.
> > > > 
> > > > int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> > > > int cxl_region_trigger_poison_list(struct cxl_region *region);
> > > > 
> > > > The resulting poison records are logged as kernel trace events
> > > > named 'cxl_poison'.
> > > > 
> > > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > > > ---
> > > >  cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  cxl/lib/libcxl.sym |  2 ++
> > > >  cxl/libcxl.h       |  2 ++
> > > >  3 files changed, 51 insertions(+)
> > > > 
> > > > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > > > index ff27cdf7c44a..73db8f15c704 100644
> > > > --- a/cxl/lib/libcxl.c
> > > > +++ b/cxl/lib/libcxl.c
> > > > @@ -1761,6 +1761,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> > > > +{
> > > > +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> > > > +	char *path = memdev->dev_buf;
> > > > +	int len = memdev->buf_len, rc;
> > > > +
> > > > +	if (snprintf(path, len, "%s/trigger_poison_list",
> > > > +		     memdev->dev_path) >= len) {
> > > > +		err(ctx, "%s: buffer too small\n",
> > > > +		    cxl_memdev_get_devname(memdev));
> > > > +		return -ENXIO;
> > > > +	}
> > > > +	rc = sysfs_write_attr(ctx, path, "1\n");
> > > > +	if (rc < 0) {
> > > > +		fprintf(stderr,
> > > > +			"%s: Failed write sysfs attr trigger_poison_list\n",
> > > > +			cxl_memdev_get_devname(memdev));
> > > 
> > > Should we use err() instead of fprintf here? 
> > 
> > Thanks Fan,
> > 
> > How about this?
> > 
> > - use fprintf if access() fails, ie device doesn't support poison list,
> > - use err() for failure to actually read the poison list on a device with
> >   support
> 
> Why? There is no raw usage of fprintf in any of the libraries (ndctl,
> daxctl, cxl) to date. If someone builds the library without logging then
> it should not chat on stderr at all, and if someone redirects logging to
> syslog then it also should emit messages only there and not stderr.

Why indeed :(

I'll remove the fprintf() and only use err() for both cases: device
doesn't support feature, or failure to read list.

