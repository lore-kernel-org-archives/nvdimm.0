Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B424634F
	for <nvdimm@lists.linux.dev>; Wed, 26 Feb 2025 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740599005; cv=none; b=LQCedS73YNCkDQp2tujLhXexVDXbgeHQaMQPf4/J7Qky8j84YeI1VEr5SU2uXEBTH1/Jrs4LkOcrPYAmD9EHm49Ye3QBIdCu4NKEGEW88CTxXSs9ajzuRiAqg7XySihXVwcq/0HV44CljETdfpFK+OXaAwKvQfExMP74C07BqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740599005; c=relaxed/simple;
	bh=Wiact1PmQyLV9FcNeFLwddpDs8vywuoYBZDdPSVZWys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZlSj5Qh2qwIaEE81+VBgJtmo7et508FwdBKwj4fmq0ul3LNJueLz1h6n29aT9qg//HrR/ZICUl9SgdXMCRKOkQIRvwpHO7o5nKrD8uL4Q6maQxPKEDD28K6M6ke30h0lV4Eo0Y26HqYDP7VM7sSdgy+HSoAHGuXRKU7AFZjYhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIapd+SP; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIapd+SP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740599004; x=1772135004;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wiact1PmQyLV9FcNeFLwddpDs8vywuoYBZDdPSVZWys=;
  b=aIapd+SPSVuRW+isVIOhkvNiU9g8BSDyig85D3+zSE6O5UGQNWq/Zl/6
   cSyRGCHU42GuhRhoL65u/4n2rkG9MEUMEIFlwmrl6du8+EVBvj0/ZZPdV
   H7R9IdnpwCGlt53hy3L6rFnQ51/dXONupLcupfvUKL6rRES+RzuA22g5j
   z5eJwnBRC2zg0LeOO+mKvbZa+Yl10kHTQZZyf39TYIfOO7ZWJuuRLfThr
   uUmgUAOws3+whc/AcEVGMuS643rJIHw3pTerpZA1Vr/2IukB4iqCO7qBP
   guHeHccxNiH7wuN6h4MV8/mzc3wJkAoPc8DkdIonbFsmqMa8SKpf7eqJF
   g==;
X-CSE-ConnectionGUID: FOnUkcX7RdujobFp3zqZFg==
X-CSE-MsgGUID: j4WiIY+LQP6Ovw903tLrWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="66840627"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="66840627"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 11:43:23 -0800
X-CSE-ConnectionGUID: 8QurermzSTi7rxR6DbgKCw==
X-CSE-MsgGUID: bxJROP+kRNaA05GzTMSzAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="121806596"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.13])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 11:43:22 -0800
Date: Wed, 26 Feb 2025 11:43:21 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Donet Tom <donettom@linux.vnet.ibm.com>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH] [ndctl PATCH v2] ndctl/list: display region caps for any
 of BTT, PFN, DAX
Message-ID: <Z79u2ZEkbO5DNnMC@aschofie-mobl2.lan>
References: <20250220062029.9789-1-donettom@linux.vnet.ibm.com>
 <x49y0y0oi1g.fsf@segfault.usersys.redhat.com>
 <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f43cf6e-a3b7-4746-be15-d354cc6dd699@linux.ibm.com>

On Wed, Feb 26, 2025 at 11:32:30AM +0530, Donet Tom wrote:
> 
> On 2/20/25 19:05, Jeff Moyer wrote:
> > > diff --git a/ndctl/json.c b/ndctl/json.c
> > > index 23bad7f..7646882 100644
> > > --- a/ndctl/json.c
> > > +++ b/ndctl/json.c
> > > @@ -381,7 +381,7 @@ struct json_object *util_region_capabilities_to_json(struct ndctl_region *region
> > >   	struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
> > >   	struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
> > > -	if (!btt || !pfn || !dax)
> > > +	if (!btt && !pfn && !dax)
> > >   		return NULL;
> > >   	jcaps = json_object_new_array();
> > Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> > 
> Thanks Jeff
> 
> 
> Hi Alison
> 
> Should I send a v3 with Reviewed-by tag or will you take the patch with the
> tag?

No need. The tags with gather automagically upon applying.
I'll also rm the text meant for below the --- like Zhijian noted.

Thanks for the patch!


> 
> Thanks
> Donet
> 
> > 
