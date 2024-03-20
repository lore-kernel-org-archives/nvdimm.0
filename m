Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772181B7F5
	for <nvdimm@lists.linux.dev>; Wed, 20 Mar 2024 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710967211; cv=none; b=LTb5YjhZS8WBDjbY10FdFpzIGg3upNtjYyCgnMbAt9MtnbL1DXVgeITrsljmI/4cd4oxEo2O024HQRXqEZFkZ668g7ABigbw9zuoR+vFyUwk5G0x+WMw6Ife9YAHizgXxvK0bgThzuxADfFAeXEV+zzA0ct/pX5OBjwTffJk4Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710967211; c=relaxed/simple;
	bh=qanR800EeCIsTwGTk75GIXgRLlDsdYbXgy73MQicGbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzhuSGySv5n1Cg5CxV0iAxa7LmFrrGCDNJ6RsUVRlibpLgx0w/p/8TsZc0AD1fuxqBHez6N6QgLGp8Oueax+IJ/l6oMkUxCfnvxjjApERFkcRkXLpz1ytpu3LW5Vate5Ek/m7e4vvLMu3EI4mjrYc00bh2wHANUJ9JFL0CsrFAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ADK3PGvz; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ADK3PGvz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710967210; x=1742503210;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=qanR800EeCIsTwGTk75GIXgRLlDsdYbXgy73MQicGbM=;
  b=ADK3PGvzfRBfRjP3Jvcy7q0fp5gmhgSGWS8iCNWkbMieyk8sqFkiYeFs
   xZv+EIS3e8MflaZCbZI/9Mer1XPbAn7389QPQoLLIOeXvASV4Hq8ZLFiU
   vvXUJ4KzM8BjNKGJZnVzMjC6UdeioSOYAeKd+mD/l4j983Bk8OKu+YwMq
   iMWicLNXQun14V01YyyBZtW+DY9zYnPcGeD/1PC7mjy2pJXevg2cHXbO5
   t+rc0z9MyAIIzoOBK2rIhhwgyWUafVgL4nVKEXWiWUYVl+QJ82vT7CFR+
   G1gPW09nWHNj1u4CrmG1nbPFkNdQPdmmdpyNG8qH33HcI7oSJmFf5GSe8
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6050826"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6050826"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:40:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14343283"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.72.188])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 13:40:08 -0700
Date: Wed, 20 Mar 2024 13:40:06 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Wonjae Lee <wj28.lee@samsung.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <ZftJpvjxH/El2QUU@aschofie-mobl2>
References: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
 <cover.1710386468.git.alison.schofield@intel.com>
 <CGME20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8@epcms2p4>
 <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>
 <ZfO0JPhdY6dp+nnq@aschofie-mobl2>
 <65f3c1e5448b2_aa222949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65f3c1e5448b2_aa222949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Thu, Mar 14, 2024 at 08:35:01PM -0700, Dan Williams wrote:
> Alison Schofield wrote:
> > On Fri, Mar 15, 2024 at 10:09:44AM +0900, Wonjae Lee wrote:
> > > alison.schofield@intel.com wrote:
> > > > From: Alison Schofield <alison.schofield@intel.com>
> > > >
> > > > The --media-errors option to 'cxl list' retrieves poison lists from
> > > > memory devices supporting the capability and displays the returned
> > > > media_error records in the cxl list json. This option can apply to
> > > > memdevs or regions.
> > > >
> > > > Include media-errors in the -vvv verbose option.
> > > >
> > > > Example usage in the Documentation/cxl/cxl-list.txt update.
> > > >
> > > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > > ---
> > > > Documentation/cxl/cxl-list.txt 62 +++++++++++++++++++++++++++++++++-
> > > > cxl/filter.h                    3 ++
> > > > cxl/list.c                      3 ++
> > > > 3 files changed, 67 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > > > index 838de4086678..6d3ef92c29e8 100644
> > > > --- a/Documentation/cxl/cxl-list.txt
> > > > +++ b/Documentation/cxl/cxl-list.txt
> > > 
> > > [snip]
> > > 
> > > +----
> > > +In the above example, region mappings can be found using:
> > > +"cxl list -p mem9 --decoders"
> > > +----
> > > 
> > > Hi, isn't it '-m mem9' instead of -p? FYI, it's also on patch's
> > > cover letter, too.
> > 
> > Thanks for the review! I went with -p because it gives only
> > the endpoint decoder while -m gives all the decoders up to
> > the root - more than needed to discover the region.
> 
> The first thing that comes to mind to list memory devices with their
> decoders is:
> 
>     cxl list -MD -d endpoint
> 
> ...however the problem is that endpoint ports connect memdevs to their
> parent port, so the above results in:
> 
>   Warning: no matching devices found
> 
> I think I want to special case "-d endpoint" when both -M and -D are
> specified to also imply -E, "endpoint ports". However that also seems to
> have a bug at present:
> 
> # cxl list -EDM -d endpoint -iu
> {
>   "endpoint":"endpoint2",
>   "host":"mem0",
>   "parent_dport":"0000:34:00.0",
>   "depth":2
> }
> 
> That needs to be fixed up to merge:
> 
> # cxl list -ED -d endpoint -iu
> {
>   "endpoint":"endpoint2",
>   "host":"mem0",
>   "parent_dport":"0000:34:00.0",
>   "depth":2,
>   "decoders:endpoint2":[
>     {
>       "decoder":"decoder2.0",
>       "interleave_ways":1,
>       "state":"disabled"
>     }
>   ]
> }
> 
> ...and:
> 
> # cxl list -EMu
> {
>   "endpoint":"endpoint2",
>   "host":"mem0",
>   "parent_dport":"0000:34:00.0",
>   "depth":2,
>   "memdev":{
>     "memdev":"mem0",
>     "pmem_size":"512.00 MiB (536.87 MB)",
>     "serial":"0",
>     "host":"0000:35:00.0"
>   }
> }
> 
> ...so that one can get a nice listing of just endpoint ports, their
> decoders (with media errors) and their memdevs.
> 
> The reason that "cxl list -p mem9 -D" works is subtle because it filters
> the endpoint decoders by an endpoint port filter, but I think most users
> would expect to not need to enable endpoint-port listings to see their
> decoders the natural key to filter endpoint decoders is by memdev.

Wonjae, Dan,

This feedback inspires me to seek more input from future users. This
tool should be adding a convenience and I don't want to proceed without
more user feedback confirming this implementation is more convenient
than the currently available method (trace & trigger). We also want to
avoid working with or around some awkward json output for eternity.

I'm following this response with a reply to the cover letter seeking
more inputs.

Thanks,
Alison


