Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEE655C1A
	for <nvdimm@lists.linux.dev>; Wed, 14 Feb 2024 21:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707947351; cv=none; b=VOhHI31r2bHNbVbFOXCTM3NBsF2ZJiC/wLlr3xdCNef8DIjKXfySggibdNMVvdQPG2//EMBTWKyxCzBKRhOwdCcksXFwN6fZ9utc2FgumIkhJDl8aHYL8vvU5dgEw1/0zhHkcUPU2Tc2BefYg5n81sH0umEpn+BjscqvYNDJ95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707947351; c=relaxed/simple;
	bh=HmCzQDPafKuoCeTvxTWUi7Y6UVUqFSDXU7PJ2/LmmcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvjedyDknBKIWbcQJ6LFdUsPo4SWXv7nyRVocvOXv7UTtYy0QtqYcywb3xBU2NWvRboEwTUTXvH2KqvTXnYb2O+A7SREIBicvB8uDtuvLkUH6rmDbJnYhpxPeL+aUUwMi9tmmLLBeqCbS9z4esqVplmVGH+s2T3BurR4gsJ6iSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L1VuPl24; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L1VuPl24"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707947350; x=1739483350;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HmCzQDPafKuoCeTvxTWUi7Y6UVUqFSDXU7PJ2/LmmcM=;
  b=L1VuPl24WtXLpNAzzjBRhwVp3nCCy2PnoLu/ZtpU3au0Zm3pQGu44+ii
   FvLfsDz63g1EuKJj5bT+PfogfoNl3oubnunb6mHY+Ulk5Za+JbsnLdjjG
   xv08XTaB/XbOY5OglzJ2xw0jt0zh+xSFuRzb0BCSqqjCUNilVloN4vfxR
   +UTxlBIjLcGgjbz6hWxkGkgMJMGoSiKdgZFD7JfCW1sXF0ZzWNUMRSZkj
   bWSG7wURurxQJuFFU6PR6UtOTsSeasVaNnI0ZgDdqTLwpwlxas5qGkGcm
   ZVCIudCybPIX7O1GvzH8wPrslPFqlo3PeIrPxwm2jLE1if3BJgmGRon8O
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10984"; a="1889312"
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="1889312"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 13:49:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,160,1705392000"; 
   d="scan'208";a="7935697"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.27.144])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2024 13:49:09 -0800
Date: Wed, 14 Feb 2024 13:49:07 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] cxl/test: Add 3-way HB interleave testcase to
 cxl-xor-region.sh
Message-ID: <Zc01UzUBAKdZdAK9@aschofie-mobl2>
References: <20240214071447.1918988-1-alison.schofield@intel.com>
 <3740aad81564f41c7d4e175682a1881253fc2cd6.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3740aad81564f41c7d4e175682a1881253fc2cd6.camel@intel.com>

On Wed, Feb 14, 2024 at 11:28:45AM -0800, Vishal Verma wrote:
> On Tue, 2024-02-13 at 23:14 -0800, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > cxl-xor-region.sh includes test cases for 1 & 2 way host bridge
> > interleaves. Add a new test case to exercise the modulo math
> > function the CXL driver uses to find positions in a 3-way host
> > bridge interleave.
> >
> > Skip this test case, don't fail, if the new 3-way XOR decoder
> > is not present in cxl/test.
> >
> > Add the missing check_dmesg helper before exiting this test.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  test/cxl-xor-region.sh | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
> > index 117e7a4bba61..2f3b4aa5208a 100644
> > --- a/test/cxl-xor-region.sh
> > +++ b/test/cxl-xor-region.sh
> > @@ -86,11 +86,44 @@ setup_x4()
> >          memdevs="$mem0 $mem1 $mem2 $mem3"
> >  }
> >
> > +setup_x3()
> > +{
> > +        # find an x3 decoder
> > +        decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
> > +          select(.pmem_capable == true) |
> > +          select(.nr_targets == 3) |
> > +          .decoder")
> 
> Are these lines..
> 
> > +
> > +     if [[ ! $decoder ]]; then
> > +             echo "no x3 decoder found, skipping xor-x3 test"
> > +             return
> > +     fi
> > +
> > +        # Find a memdev for each host-bridge interleave position
> > +        port_dev0=$($CXL list -T -d "$decoder" | jq -r ".[] |
> > +            .targets | .[] | select(.position == 0) | .target")
> > +        port_dev1=$($CXL list -T -d "$decoder" | jq -r ".[] |
> > +            .targets | .[] | select(.position == 1) | .target")
> > +        port_dev2=$($CXL list -T -d "$decoder" | jq -r ".[] |
> > +            .targets | .[] | select(.position == 2) | .target")
> 
> ..and these mis-indented?

Thanks for calling it out. I'll tidy up white space in a new revision.

snip

> 
