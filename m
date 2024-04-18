Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D33181B8E
	for <nvdimm@lists.linux.dev>; Thu, 18 Apr 2024 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713471165; cv=none; b=F3A8i0x7m60OqO0T9ZOHJXcxGEXmjSDmK8KBNz2Xs+gBgmBxw83kxsXQbnk9GHwl97otsjpk8NWrNqNbkhv7vnfMfMczFBspwIjmFfu7aveJhj97frqwLI/oy5EEJDSPH7ta4s7gL+r1SjC7RHCReIuJ6ij1pzG6kMAfsd4bE9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713471165; c=relaxed/simple;
	bh=8tAaCEnXrkMiicNFZ+Pyl0gDn8ScRGopoyh8mm9onGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BQ3jnZ01OTgAsmbzCMmchjawtrC04g6pRHdZGDFeivRvNS98e0EOI3au3DXMyiqh2LJsyhWhwBEnBT/xdDqeBmGhYqfg+I04gmryld7cmc4DHxIlIf1ktj4sDxGaNbMBk386jz1sfi0e71caCFx+jaIQ6/VkSwz8AwkiH4QFTHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ioVx/Ool; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ioVx/Ool"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713471164; x=1745007164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=8tAaCEnXrkMiicNFZ+Pyl0gDn8ScRGopoyh8mm9onGs=;
  b=ioVx/OolOs4OOW2MJaFYwQg9xT9LJxPLExs2/kR/gD6NYGsTtdwPw0oq
   xjRNVyx4OYyz7fP9XA9RuZD8IRf1Dy5wWYHmpG6YuuM8wad/WalT7kEGO
   L1N391NmWiD1TwBvL6MLJkl6gsGbdCKIyaF4R2RctpbNEhFBpXoZ9C6n4
   3ImNFDZFonjEb3sB7mDgRvX+nMaQ/rklVpnQk5mJMEks+AZxaS2aaV2U4
   Xt5aV2J7by3ulUoUdGbsgxa4t3npl+WYp3CkY910cyeXeGfDXPsfMp9Jx
   DTO7oCs+avscjW0hD9q4nUvZwcvp9nwUJ7DE7pyWFOmoYkQCrT68wv1OX
   g==;
X-CSE-ConnectionGUID: 1eNsZkbvTyCoCtgSvFuTRA==
X-CSE-MsgGUID: abMvPOwlTCqpwgaERrc6bw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20470116"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20470116"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 13:12:43 -0700
X-CSE-ConnectionGUID: 8D/G87JJS5aIfHxESANk6g==
X-CSE-MsgGUID: h88kKEwyRMmUls4GJLL2hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23177745"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.7.105])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 13:12:41 -0700
Date: Thu, 18 Apr 2024 13:12:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Wonjae Lee <wj28.lee@samsung.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Hojin Nam <hj96.nam@samsung.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH v11 6/7] cxl/list: add --media-errors option to cxl
 list
Message-ID: <ZiF+t0sVPOdE0X1K@aschofie-mobl2>
References: <a6933ba82755391284368e4527154341bc4fd75f.1710386468.git.alison.schofield@intel.com>
 <cover.1710386468.git.alison.schofield@intel.com>
 <CGME20240314040548epcas2p3698bf9d1463a1d2255dc95ac506d3ae8@epcms2p4>
 <20240315010944epcms2p4de4dee2e69a2755aeab739152417d65b@epcms2p4>
 <ZfO0JPhdY6dp+nnq@aschofie-mobl2>
 <65f3c1e5448b2_aa222949e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ZgR3/AWytkKwX9u4@aschofie-mobl2>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgR3/AWytkKwX9u4@aschofie-mobl2>

Hi Dan,

Here's where I believe we last left off.

I thought we had closure on the json format of the media error records,
and on the fact that those objects are appended to memdev or region
objects.

The open is on how to use 'cxl list' to view the poison records.

Can we pick up that discussion below in this v11 thread?

The v12 that I refer to below is here:
https://lore.kernel.org/cover.1711519822.git.alison.schofield@intel.com/

-- Alison


On Wed, Mar 27, 2024 at 12:48:12PM -0700, Alison Schofield wrote:
> On Thu, Mar 14, 2024 at 08:35:01PM -0700, Dan Williams wrote:
> > Alison Schofield wrote:
> > > On Fri, Mar 15, 2024 at 10:09:44AM +0900, Wonjae Lee wrote:
> > > > alison.schofield@intel.com wrote:
> > > > > From: Alison Schofield <alison.schofield@intel.com>
> > > > >
> > > > > The --media-errors option to 'cxl list' retrieves poison lists from
> > > > > memory devices supporting the capability and displays the returned
> > > > > media_error records in the cxl list json. This option can apply to
> > > > > memdevs or regions.
> > > > >
> > > > > Include media-errors in the -vvv verbose option.
> > > > >
> > > > > Example usage in the Documentation/cxl/cxl-list.txt update.
> > > > >
> > > > > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > > > > ---
> > > > > Documentation/cxl/cxl-list.txt 62 +++++++++++++++++++++++++++++++++-
> > > > > cxl/filter.h                    3 ++
> > > > > cxl/list.c                      3 ++
> > > > > 3 files changed, 67 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > > > > index 838de4086678..6d3ef92c29e8 100644
> > > > > --- a/Documentation/cxl/cxl-list.txt
> > > > > +++ b/Documentation/cxl/cxl-list.txt
> > > > 
> > > > [snip]
> > > > 
> > > > +----
> > > > +In the above example, region mappings can be found using:
> > > > +"cxl list -p mem9 --decoders"
> > > > +----
> > > > 
> > > > Hi, isn't it '-m mem9' instead of -p? FYI, it's also on patch's
> > > > cover letter, too.
> > > 
> > > Thanks for the review! I went with -p because it gives only
> > > the endpoint decoder while -m gives all the decoders up to
> > > the root - more than needed to discover the region.
> > 
> > The first thing that comes to mind to list memory devices with their
> > decoders is:
> > 
> >     cxl list -MD -d endpoint
> > 
> > ...however the problem is that endpoint ports connect memdevs to their
> > parent port, so the above results in:
> > 
> >   Warning: no matching devices found
> > 
> > I think I want to special case "-d endpoint" when both -M and -D are
> > specified to also imply -E, "endpoint ports". However that also seems to
> > have a bug at present:
> > 
> > # cxl list -EDM -d endpoint -iu
> > {
> >   "endpoint":"endpoint2",
> >   "host":"mem0",
> >   "parent_dport":"0000:34:00.0",
> >   "depth":2
> > }
> > 
> > That needs to be fixed up to merge:
> 
> What's to fix up? Doesn't filtering by '-d endpoint' exclude the
> objects you specified in -EDM.  It becomes the equivalent of
> of 'cxl list -E'
> 
> > 
> > # cxl list -ED -d endpoint -iu
> > {
> >   "endpoint":"endpoint2",
> >   "host":"mem0",
> >   "parent_dport":"0000:34:00.0",
> >   "depth":2,
> >   "decoders:endpoint2":[
> >     {
> >       "decoder":"decoder2.0",
> >       "interleave_ways":1,
> >       "state":"disabled"
> >     }
> >   ]
> > }
> > 
> > ...and:
> > 
> > # cxl list -EMu
> > {
> >   "endpoint":"endpoint2",
> >   "host":"mem0",
> >   "parent_dport":"0000:34:00.0",
> >   "depth":2,
> >   "memdev":{
> >     "memdev":"mem0",
> >     "pmem_size":"512.00 MiB (536.87 MB)",
> >     "serial":"0",
> >     "host":"0000:35:00.0"
> >   }
> > }
> >
> 
> Some of the examples above that use "-d endpoint", filtering on endpoint
> decoders, and so are, by design, excluding memdev info.  Filtering on
> endpoint ports, ie -p endpoint, supports a listing of the endpoint
> memdevs and decoders. 
> 
> > ...so that one can get a nice listing of just endpoint ports, their
> > decoders (with media errors) and their memdevs.
> > 
> 
> Dissecting the above sentence:
> "of just endpoint ports"  --> -p endpoint
> "their decoders" --> -DE
> "their memdevs"  --> -M
> "(with media errors)" --media-errors
> 
> Yields this query:
> cxl list -p endpoint -DEM --media-errors
> 
> You wrote (with media errors) after 'decoders' and that is of concern,
> but maybe just a typo?  ATM --media-errors applies to memdev or region
> objects, not to decoder objects.
> 
> > The reason that "cxl list -p mem9 -D" works is subtle because it filters
> > the endpoint decoders by an endpoint port filter, but I think most users
> > would expect to not need to enable endpoint-port listings to see their
> > decoders the natural key to filter endpoint decoders is by memdev.
> 
> Not following this subtle comment. I find it to be an exacting filter
> targeting exactly a memdev that may be of interest and supplying
> the decoder and region mappings. It would be best suggested in one
> step, and that's is an update in the v12 man page:
> cxl list -p mem9 -DEM --media-errors
> 
> I don't understand the desire to use endpoint decoders as a filter when
> using endpoint ports which have memdevs and endpoint decoders as
> children works, and flows with the whole top down cxl list filtering 
> design. I also don't see a need to special case, and 'imply' endpoint
> ports, when use can explicitly add -p endpoint to their query.
> (the special case seems like it would add confusion to the cxl list
> usage)
> 
> I'm following this w a v12 that does update the man page suggestions.
> Let's continue this conversation there.
> 
> Thanks,
> Alison
> 
> 
> 
> 
> 
