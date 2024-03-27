Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4468E14F102
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711568898; cv=none; b=VjldIvevZbguvAJ06AHO15tLQC3Kdq+8L+U9PCohGyJiiHN2fPeL5V1FRgAzW+uQ2fBQvM1KyuqLgh0Acpy5UhKEcjS7KnKGP54Ujh4YC4yFy95yCQe6SHu6W+KAGPP+O3kGUeD2hCOn60kP1bVNbS4w98yd8KrtNdIzQKBBTXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711568898; c=relaxed/simple;
	bh=9tUY4ZB8TxZ7JLRX7DRh6KpXkGNY0fj6k5IPHZbmVpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFn69LkldQizgf7RvnREZtDOfaKL40xzxupLMUW9zVcn1rSwpLCDBTF1sPQ7O75Boxl3iG7AL8e6jL+EECZEKLd1PZYTNVp+SvYZ9JIYt/clwIGJ7pGSKLcIM7FHkk7d0TmyjjcgbKxVIjZklnVvbWRmpOH/a6NQoEXwQa0i4eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2UaYLjW; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2UaYLjW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711568896; x=1743104896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=9tUY4ZB8TxZ7JLRX7DRh6KpXkGNY0fj6k5IPHZbmVpA=;
  b=m2UaYLjWMH46Yz8FdpjCs5ONEix5lg2geqX6SS7cWOL7PSEcmjFlz+o2
   Xg0Xq3aafCacmxX+beG3Ojax1O4LU2mT8UIO+f1cUdTBNGZx9MnwmaQwy
   Xd6lK9keNJeUkpeNww1voVl1Pm9ycut20vVyaR3rPkNn8c8034jPO8TTZ
   ZpIuFw/L7ytKFX2h9n9Zj3OvaCr5UptZEiUMVFNt21Vw6POSnFU76qnO9
   ptiLPs6Xa/OZXE3xEAF2Kpx9XuPUquS8f7kvF3OmY9gynq7VlC27U3Rey
   BHSEkbd1DCWsL971eHf1I9nWcSr8gI6PoPefbBWbf/XC9xEzN9G+uR9y7
   w==;
X-CSE-ConnectionGUID: nStx6c1iTG6efyeDQsSgTQ==
X-CSE-MsgGUID: p2g+TH4GQ6GA4YGJsbdnVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="17838770"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="17838770"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:48:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="20932052"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.82.250])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:48:14 -0700
Date: Wed, 27 Mar 2024 12:48:12 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Wonjae Lee <wj28.lee@samsung.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <ZgR3/AWytkKwX9u4@aschofie-mobl2>
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

What's to fix up? Doesn't filtering by '-d endpoint' exclude the
objects you specified in -EDM.  It becomes the equivalent of
of 'cxl list -E'

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

Some of the examples above that use "-d endpoint", filtering on endpoint
decoders, and so are, by design, excluding memdev info.  Filtering on
endpoint ports, ie -p endpoint, supports a listing of the endpoint
memdevs and decoders. 

> ...so that one can get a nice listing of just endpoint ports, their
> decoders (with media errors) and their memdevs.
> 

Dissecting the above sentence:
"of just endpoint ports"  --> -p endpoint
"their decoders" --> -DE
"their memdevs"  --> -M
"(with media errors)" --media-errors

Yields this query:
cxl list -p endpoint -DEM --media-errors

You wrote (with media errors) after 'decoders' and that is of concern,
but maybe just a typo?  ATM --media-errors applies to memdev or region
objects, not to decoder objects.

> The reason that "cxl list -p mem9 -D" works is subtle because it filters
> the endpoint decoders by an endpoint port filter, but I think most users
> would expect to not need to enable endpoint-port listings to see their
> decoders the natural key to filter endpoint decoders is by memdev.

Not following this subtle comment. I find it to be an exacting filter
targeting exactly a memdev that may be of interest and supplying
the decoder and region mappings. It would be best suggested in one
step, and that's is an update in the v12 man page:
cxl list -p mem9 -DEM --media-errors

I don't understand the desire to use endpoint decoders as a filter when
using endpoint ports which have memdevs and endpoint decoders as
children works, and flows with the whole top down cxl list filtering 
design. I also don't see a need to special case, and 'imply' endpoint
ports, when use can explicitly add -p endpoint to their query.
(the special case seems like it would add confusion to the cxl list
usage)

I'm following this w a v12 that does update the man page suggestions.
Let's continue this conversation there.

Thanks,
Alison




