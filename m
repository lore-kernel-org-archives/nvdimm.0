Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2EA19D07E
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 07:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762501164; cv=none; b=ADTTqamkMXZ6cr8n2eZh9zY1LmEO2iXDJkNKWMTEIWuoq/oUted34hCMvSaHnKje4tI4zC9wOjxVljmWUvwdmUUYOlUtxvM6kqn1EtRHu9h9Br+dQQnLbfwLGHOJouN1ifkuh2U8yKAPgFHsByZ2zWoWaNI/bRNLbGFbkAWQQCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762501164; c=relaxed/simple;
	bh=F7X6D2bFuRGSi9b8DsU3MEjvlXD2IHMPAsoG2KIu+yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYHOWeApL9XhIanHpRm5xhvMDMXgZ9Ez5wb+t0xptUNcL2nvJIuHzr/1Ncn694hNK9gP17+iehdJys/h0ud0M+9gyJHqNzIjA11NUWSCSpcnwkloSOQ5/E2G60PXJe2Kh8D3WbQfyn9kaOAfborGhq8YEj0CLPmW2UCI0XOdv7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k57Yasxl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k57Yasxl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762501162; x=1794037162;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F7X6D2bFuRGSi9b8DsU3MEjvlXD2IHMPAsoG2KIu+yY=;
  b=k57YasxlpJLLaIXNjB/XuZ0hVq0cHR6jJcQEPmv5tZc3KWyFWcgep0H/
   b9HtReDiQ+0H3LH0rnoCj3y7t4bRbUq9I70/evtY2T4Cty9gTLqiMiR5s
   wC5CDqQ/xHkSqaxip5HuW68T4sGss93EOs54IAZtevLJwysYnyuHkKbIY
   w4+oLgyonCXrzqnSiBd+X9h7kQvdalp3iVjXx2UCLdBpnPOwE7WwVeLaI
   4AGZVjyg3eWuuTywvlMkCtl+2ns6JUTdnsO40O6XUieVz+9d3OgF6M42S
   wdwpV5ZFqk5oqtfXLAEVetBfelCzphe7UM3bPS384CsO6kviNqZOzWGES
   g==;
X-CSE-ConnectionGUID: YuuGp7UkSXmULPqaqiF9jQ==
X-CSE-MsgGUID: UIIPM5tFQtqiq1Q+THMr4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="64565085"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="64565085"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:39:21 -0800
X-CSE-ConnectionGUID: gp7xzaDERJ+J8pgaa4uZug==
X-CSE-MsgGUID: xQQJIxsKRPOLXQCJnaY7iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="188411125"
Received: from vpanait-mobl.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.27])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 23:39:20 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1vHH41-00000006OEC-2iuS;
	Fri, 07 Nov 2025 09:39:17 +0200
Date: Fri, 7 Nov 2025 09:39:17 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v1 1/1] libnvdimm/labels: Get rid of redundant 'else'
Message-ID: <aQ2iJUZUDf5FLAW-@smile.fi.intel.com>
References: <20251105183743.1800500-1-andriy.shevchenko@linux.intel.com>
 <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <690d4178c4d4_29fa161007f@iweiny-mobl.notmuch>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Nov 06, 2025 at 06:46:48PM -0600, Ira Weiny wrote:
> Andy Shevchenko wrote:
> > In the snippets like the following
> > 
> > 	if (...)
> > 		return / goto / break / continue ...;
> > 	else
> > 		...
> > 
> > the 'else' is redundant. Get rid of it.
> 
> I still need a why to in this commit message.

Sure.

[snip]

...

> > -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> > -		/*
> > -		 * If we're modifying a namespace for which we don't
> > -		 * know the claim_class, don't touch the existing guid.
> > -		 */
> > -		return target;
> > -	} else
> > +	if (claim_class == NVDIMM_CCLASS_NONE)
> >  		return &guid_null;
> > +
> > +	/*
> > +	 * If we're modifying a namespace for which we don't
> > +	 * know the claim_class, don't touch the existing guid.
> > +	 */
> > +	return target;
> 
> This is not an equivalent change.

It's (okau. almost. later on that). The parameter to the function is enum and
the listed values of the enum is all there. The problematic part can be if
somebody supplies an arbitrary value here. Yes, in such a case it will change
behaviour and I think it is correct in my case as UNKNOWN is unknown, and NONE
is actually well known UUID.

...

> > -	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
> > -		/*
> > -		 * If we're modifying a namespace for which we don't
> > -		 * know the claim_class, don't touch the existing uuid.
> > -		 */
> > -		return target;
> > -	} else
> > +	if (claim_class == NVDIMM_CCLASS_NONE)
> >  		return &uuid_null;
> > +
> > +	/*
> > +	 * If we're modifying a namespace for which we don't
> > +	 * know the claim_class, don't touch the existing uuid.
> > +	 */
> > +	return target;
> 
> This is not an equivalent change.

Same explanation as above. I'll put it into the commit message.

-- 
With Best Regards,
Andy Shevchenko


