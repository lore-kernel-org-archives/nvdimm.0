Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3521EA77
	for <nvdimm@lists.linux.dev>; Thu, 18 Jan 2024 23:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705620880; cv=none; b=WAR5uCS+RRMXPQKVlLC/t0Xj5T+EyayNmqI1T/WHhOLZOP4IlpH4GXdeM83coqzCUx1zaSPI7svdITnJN8WiI3+n8DFM9kJGpUbn4PxceViiefYzOrzsGto5apRzO7so9/79DYGHninGgPN79DQXEtnEj0bGWetG8zPbghppd4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705620880; c=relaxed/simple;
	bh=Yri73MmAuRMqqlrqIhwKmNea/WT71pv3w1FPxK9M8x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2rmsnQ6BQe5+tPoTOz6aJ2GFrTRVmvIFlKMKlpmJEbsNjfldniv2iJq6Zo9UC7PcdIbOsNew1vFrqI6RXCACdNr49xVNKinVfmfKiqi0p8WJRV/iks9lzz7A7BmrKn6yEAi3KHS6L+X++g5yieieCt95Bnnwa6PeEZjybEHq40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWzG3/4X; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWzG3/4X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705620878; x=1737156878;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Yri73MmAuRMqqlrqIhwKmNea/WT71pv3w1FPxK9M8x0=;
  b=dWzG3/4Xj8Q6zwSmFuqk+jdY7mz20PfprB0hME+ZYij7vNHJp6C7or0s
   xd2x+SggyOZo1DrEx3qHHfWmydRkJz/BOjlSnHa/mlPwERr/LZRvSZjQY
   ONVJnEd7h8Rdiih6EwwqyX03rYWSIqbLpHufVG7L5E2Z08tzZeL7zt/fh
   HF3vBs24xhOVUc3z5oEeae9uza422OepgEbWH/V+xgdZShUnLMi+Z2cDt
   CzkM4fxnB9FiLy/gMdTV3Yf70+vDVtqma0KGMiN3wyoescv2Vw2QMOG1k
   c1d9ZKmdvjPLABuG6JM0K9kWQIe5OTN//spc9/TPyBXyPfSDhH6CRrq5c
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="7298914"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="7298914"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 15:34:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="875221941"
X-IronPort-AV: E=Sophos;i="6.05,203,1701158400"; 
   d="scan'208";a="875221941"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.34.120])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2024 15:34:35 -0800
Date: Thu, 18 Jan 2024 15:34:32 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v6 0/7] Support poison list retrieval
Message-ID: <Zam1iPjxXA9iiUOl@aschofie-mobl2>
References: <cover.1705534719.git.alison.schofield@intel.com>
 <65a99ea31393a_2d43c29454@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65a99ea31393a_2d43c29454@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Thu, Jan 18, 2024 at 01:56:51PM -0800, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Changes since v5:
> > - Use a private parser for cxl_poison events. (Dan)
> >   Previously used the default parser and re-parsed per the cxl-list
> >   needs. Replace that with a private parsing method for cxl_poison.
> > - Add a private context to support private parsers. 
> > - Add helpers to use with the cxl_poison parser.
> > - cxl list json: drop nr_records field (Dan)
> > - cxl list option: replace "poison" w "media-errors" (Dan)
> > - cxl list json: replace "poison" w "media_errors" (Dan)
> > - Link to v5: https://lore.kernel.org/linux-cxl/cover.1700615159.git.alison.schofield@intel.com/
> > 
> > 
> > Begin cover letter:
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
> >         "dpa_length":64,
> >         "source":"Injected"
> >       },
> >       {
> >         "region":"region5",
> 
> It feels odd to list the region here. I feel like what really matters is
> to list the endpoint decoder and if someone wants to associate endpoint
> decoder to region, or endpoint decoder to memdev there are other queries
> for that.
> 
> Then this format does not change between the "region" listing and
> "memdev" listing, they both just output the endpoint decoder and leave
> the rest to follow-on queries.
> 
> For example I expect operations software has already recorded the
> endpoint decoder to region mapping, so when this data comes in the
> endpoint decoder is a key to make that association. Otherwise:
> 
>     cxl list -RT -e $endpoint_decoder
> 
> ...can answer follow up questions about what is impacted by a given
> media error record.

I see it as a convenience offering, but I'm starting to see that your
stance is probably that a cxl-list option should only list additional
info provided by the option, and not include info that can be retrieved
elsewhere w cxl-list.

I plan to make this change to endpoint as you suggest.

> 
> >         "dpa":1073741824,
> >         "dpa_length":64,
> 
> The dpa_length is also the hpa_length, right? So maybe just call the
> field "length".
> 

No, the length only refers to the device address space. I don't think
the hpa is guaranteed to be contiguous, so only the starting hpa addr
is offered.

hmm..should we call it 'size' because that seems to imply less
contiguous-ness than length?

Which should it be 'dpa_length' or 'size' (or 'length')

> >         "hpa":1035355557888,
> >         "source":"Injected"
> >       },
> >       {
> >         "region":"region5",
> >         "dpa":1073745920,
> >         "dpa_length":64,
> >         "hpa":1035355566080,
> >         "source":"Injected"
> 
> This "source" field feels like debug data. In production nobody is going
> to be doing poison injection, and if the administrator injected it then
> its implied they know that status. Otherwise a media-error is a
> media-error regardless of the source.

From CXL Spec Tabel 8-140 Sources can be: 

Unknown.
External. Poison received from a source external to the device.
Internal. The device generated poison from an internal source.
Injected. The error was injected into the device for testing purposes.
Vendor Specific.

On the v5 review, Erwin commented:
>> This is how I would use source.
>> "external" = don't expect to see a cxl media error, look elsewhere like a UCNA or a mem_data error in the RP's CXL.CM RAS.
>> "internal" = expect to see a media error for more information.
>> "injected" = somebody injected the error, no service action needed except to maybe tighten up your security.
>> "vendor" = see vendor

If it's not presented here, user can look it up in the cxl_poison trace
event directly.

I think we should keep this as is.

> 
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
> >         "memdev":"mem1",
> >         "dpa":1073741824,
> >         "dpa_length":64,
> >         "hpa":1035355557888,
> >         "source":"Injected"
> >       },
> >       {
> >         "memdev":"mem1",
> >         "dpa":1073745920,
> >         "dpa_length":64,
> >         "hpa":1035355566080,
> >         "source":"Injected"
> >       }
> >     ]
> >   }
> > ]
> > 
> > Alison Schofield (7):
> >   libcxl: add interfaces for GET_POISON_LIST mailbox commands
> >   cxl: add an optional pid check to event parsing
> >   cxl/event_trace: add a private context for private parsers
> >   cxl/event_trace: add helpers get_field_[string|data]()
> >   cxl/list: collect and parse media_error records
> >   cxl/list: add --media-errors option to cxl list
> >   cxl/test: add cxl-poison.sh unit test
> > 
> >  Documentation/cxl/cxl-list.txt |  71 +++++++++++
> >  cxl/event_trace.c              |  53 +++++++-
> >  cxl/event_trace.h              |   9 +-
> >  cxl/filter.h                   |   3 +
> >  cxl/json.c                     | 218 +++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.c               |  47 +++++++
> >  cxl/lib/libcxl.sym             |   6 +
> >  cxl/libcxl.h                   |   2 +
> >  cxl/list.c                     |   2 +
> >  test/cxl-poison.sh             | 133 ++++++++++++++++++++
> >  test/meson.build               |   2 +
> >  11 files changed, 543 insertions(+), 3 deletions(-)
> >  create mode 100644 test/cxl-poison.sh
> > 
> > 
> > base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> > -- 
> > 2.37.3
> > 
> > 
> 
> 
