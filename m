Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A833A1BE
	for <nvdimm@lists.linux.dev>; Sun, 10 Mar 2024 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710098503; cv=none; b=or3GitLilfuKlv9XFgLy+mT6vcBbYNGf20C9wq9krO/BYdFwiTdxEeWWWeLyljjiaFDXIvoFFbh6GFJMo2YrSrtW2D0Knudr6BVXI9jwr3JpcOn4+hrAWEtPwI8QyVL7Smq5crY6geXqa9bDCQ6WIhE/4VgGeKZgseW5/dPHYGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710098503; c=relaxed/simple;
	bh=zVoqIf49b+xTRTYakoVBdcvZJGI9YJdzmyYr31+3U28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUcxZJruMOmwsEZTPJ4RObAqCwzkYWxfX8+MfVA8fqexr3+mAQjrilZ7bjqkHR1OcJLLfHTo1Wabhs4xKf4QcqSLxMk6rQRETZj7GntQFRGGpk87zin819ymG3/Bv1HLxrQiJ8zYj/Rhz7Sz/uCp2LolX8r6c5vSvT2lodU+aAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WzVjgZWT; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WzVjgZWT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710098502; x=1741634502;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zVoqIf49b+xTRTYakoVBdcvZJGI9YJdzmyYr31+3U28=;
  b=WzVjgZWTGvyzEO6OzFom4wnc9Wv/V80p7qswK0mwChrSJ71PewnHvBz5
   c4zL0gBVOCIqxuQV1tv8w5lnHoLrGuDqtKSJh/aKAFXaQN+JfiY8s+P9u
   qTHAwb/c0qVnlmQff5pOfFjqJqXRwjXarFDl3QmaYSuEyzPRK/ePmNfHl
   aN4Xkj7sNubjh8F0uoSqOstPFxT9ybEm46HT5aDRwCaH2x+X/piL3Tew/
   0qoUMdZYlkwouoKbvBcXSXY+fzgBhPh0oFOJYGO7xook5c3TccfYwI3MP
   R/vB05qmxYO0qhnkzYvwNqef5+DPRsfeP3PmyLgBtRi/at1FQPf4eaVLI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="22214805"
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="22214805"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 12:21:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,115,1708416000"; 
   d="scan'208";a="11366018"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.25.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2024 12:21:41 -0700
Date: Sun, 10 Mar 2024 12:21:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v10 0/7] Support poison list retrieval
Message-ID: <Ze4IQ+wxAhCdBa2d@aschofie-mobl2>
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

Dan,

In cleaning up the man pages, I need to follow up on this offset, length
notation.

A default by memdev list now looks like this-

{
 "offset" :
 "length" :
 "source" :
}

Which means dropping the 'decoder' even if it can be discovered from
the trace event. Recall previously a region was listed if present,
then we changed that to a decoder is listed if present.  Now, with
no 'hpa' listing I've dropped the decoder too. That leaves no hint
in the by memdev listing that this poison is in a region. 

Decoders will only be included in the by region list:
{
 "decoder":
 "offset" :
 "length" :
 "source" :
}

OK ?


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
