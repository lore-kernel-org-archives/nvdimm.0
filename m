Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34EC2C190
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 03:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709870306; cv=none; b=Im07OEqqg35i4YV1rtlGF1lnYD4xJcOgKIae2/PJEVJ8bYq+bY9tGngFjwH2tMD8FswKqybjF28Etzeyid+LWJ0bwtz76yDFw+xNpTetZmw2I0fSLKIqIBQV6nM8pJh5gMejsCA8Ut9vZwP5mxPZo+Bb+pafwjYwg6VkU80dgr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709870306; c=relaxed/simple;
	bh=op+zU/MmolUbrBHJoPw3I942ODKAF/0AmV9xzYojpbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TOaUN6orac+MnXmj3JyTyH3FmQYUCTq+xFohQlwPmrtor1+2FOuVrcnQYdVvX3Dwh4YlVts5Oo7yD+aVaivUmXoVslyubkO3R8LSwKXB5VxIvlgGVQhuHngzhYR/u/spYAE6jwHz6/MR7tn/J9MtCIJdJvn8s1gKFhjnhW9A1aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QODcTvCJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QODcTvCJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709870305; x=1741406305;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=op+zU/MmolUbrBHJoPw3I942ODKAF/0AmV9xzYojpbc=;
  b=QODcTvCJFq24Bd5qFbz8STCJ8z6xVEbMCY5J+A/LohFDS9on10Uvp94+
   oFiJrtX22CHAFSTNS30CQesOrcrZiG+AGKml+AKsuOV+F4upjnvLKJ9/D
   ju4SbW+fcwsayatapEfGXEyj8s7n1S/l2H5TzacEVTWcGyMGlWyxQpjDF
   JmwQd3lDnzFIfsB5MGsv6zl5ZTYDbq+8qB3xkcbLyMgVpG1mTI4C5lugk
   +bgf3tC5xuO/0fISVVYLtFAwQR1iTtZtXGJUhPUClMcyIKkRYVPs5jbnl
   fqx915zrFHmmZ+E9eU81QAUbYoQ4WCmE9vBZ7JnGoUiBK1AAs55mlSR+E
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4717055"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="4717055"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 19:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="14893677"
Received: from snlow-mobl1.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.57.195])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 19:58:23 -0800
Date: Thu, 7 Mar 2024 19:58:22 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v10 0/7] Support poison list retrieval
Message-ID: <ZeqM3uvPUNvOj//5@aschofie-mobl2>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <65e8f64c6c266_1271329483@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65e8f64c6c266_1271329483@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Wed, Mar 06, 2024 at 03:03:40PM -0800, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Changes since v9:
> > - Replace the multi-use 'name' var, with multiple descriptive
> >   flavors: memdev_name, region_name, decoder_name (DaveJ)
> > - Use a static string table for poison source lookup (DaveJ)
> > - Rebased on latest pending
> > Link to v9: https://lore.kernel.org/r/cover.1709253898.git.alison.schofield@intel.com/
> > 
> > 
> > Add the option to add a memory devices poison list to the cxl-list
> > json output. Offer the option by memdev and by region. Sample usage:
> > 
> > # cxl list -m mem1 --media-errors
> > [
> >   {
> >     "memdev":"mem1",
> >     "pmem_size":1073741824,
> >     "ram_size":1073741824,
> >     "serial":1,
> >     "numa_node":1,
> >     "host":"cxl_mem.1",
> >     "media_errors":[
> >       {
> >         "dpa":0,
> >         "length":64,
> >         "source":"Internal"
> >       },
> >       {
> >         "decoder":"decoder10.0",
> >         "hpa":1035355557888,
> >         "dpa":1073741824,
> >         "length":64,
> >         "source":"External"
> >       },
> >       {
> >         "decoder":"decoder10.0",
> >         "hpa":1035355566080,
> >         "dpa":1073745920,
> >         "length":64,
> >         "source":"Injected"
> >       }
> >     ]
> >   }
> > ]
> > 
> > # cxl list -r region5 --media-errors
> > [
> >   {
> >     "region":"region5",
> >     "resource":1035355553792,
> >     "size":2147483648,
> >     "type":"pmem",
> >     "interleave_ways":2,
> >     "interleave_granularity":4096,
> >     "decode_state":"commit",
> >     "media_errors":[
> >       {
> >         "decoder":"decoder10.0",
> >         "hpa":1035355557888,
> >         "dpa":1073741824,
> >         "length":64,
> 
> I notice that the ndctl --media-errors records are:
> 
> { offset, length }
> 
> ...it is not clear to me that "dpa" and "hpa" have much meaning to
> userspace by default. Physical address information is privileged, so if
> these records were { offset, length } tuples there is the possibility
> that they can be provided to non-root.
> 
> "Offset" is region relative "hpa" when listing region media errors, and
> "offset" is memdev relative "dpa" while listing memdev relative media
> errors.

Done. memdev relative dpa is just dpa right? Unless you are thinking
offset into a partition? I don't think so.



