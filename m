Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F3020B7E0
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741301819; cv=none; b=pGk1aBotiEBKqBhSl2kdGZwL6ZPA0+g9ziS8bnP2VGNw/2a5H7nXC1ILSOAVFkGtsODqhGRm+FgEvotNxIC7O+xRAmu56QEhXkjnOHIMR9bO6kKf5rOP+3LDVVl8p0I9VB32mCpIr53e82jwCfQnEfFdqaCk5azGlDRA1490p+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741301819; c=relaxed/simple;
	bh=xXA+KoKP59YNgQ6Rkvk4X99ki2VwPQj2lMPQVmJHny8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+iylfDDCM8JdO6jlu2xOsREnxhTrthaVZgmw+/lq+oMkD7D1aPBW9E+zitG0WudXj0V9mjjNl7Pffy5NwVx0MlFZuiCKuKkgUJQ5qBoW9apMNVLo1SsysfXRU6V6nH97E0PB4sl/+3C1rkvQ5hFXIAFTUtSrNKcDzze2gEJvps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cHnHP9Fz; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cHnHP9Fz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741301818; x=1772837818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xXA+KoKP59YNgQ6Rkvk4X99ki2VwPQj2lMPQVmJHny8=;
  b=cHnHP9Fzf/jxBiH9lrDy2QtKttGxdOq22sez7oVQ3nVTZUdQUihtbn94
   2zFFuYPw6CVTruMckBQl2eZUZ7a05+OtoaYYkT+FioLu7E+Wiu5FZ8RsW
   XAmwCrQOL0fLocjZEBvoBNPxw8T9ANlQTHYGjPNoxf6Y9SaJ9I9jguYGa
   D6vN8HVYASERNjqfiWKdqyIejyANrXI+XzF1LeC1e6CRl6lysvU5pn0AH
   7+FCBB1/O/Ae7geBCg+JISGSj00ASRCUYlDU7xn7G11zCIPGKwKTN2HFS
   RiZarNiztsv2ZEhz7T+Za8uqgu0mpLVq5T6SGpCgAQs4cZ1azDNqgw4Go
   Q==;
X-CSE-ConnectionGUID: z7xB5zjITkK8MjBTAygOJA==
X-CSE-MsgGUID: 3dck7plMSMWKKoiSZYqfwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="46115678"
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="46115678"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 14:56:57 -0800
X-CSE-ConnectionGUID: 2s67KF4dS3GRYTMimAvZkQ==
X-CSE-MsgGUID: zr5jcBI1TAKG0tzOGW3YjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,227,1736841600"; 
   d="scan'208";a="124091727"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.63])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 14:56:57 -0800
Date: Thu, 6 Mar 2025 14:56:55 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 3/5] ndctl/dimm: do not increment a ULLONG_MAX slot
 value
Message-ID: <Z8ooNxjYx80_OCMU@aschofie-mobl2.lan>
References: <cover.1741047738.git.alison.schofield@intel.com>
 <6f3f15b368b1d2708f93f00325e009747425cef0.1741047738.git.alison.schofield@intel.com>
 <45c58eac-422d-4c19-ac2a-483eabb8579a@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c58eac-422d-4c19-ac2a-483eabb8579a@intel.com>

On Wed, Mar 05, 2025 at 09:38:31AM -0700, Dave Jiang wrote:
> 
> 
> On 3/3/25 5:37 PM, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > A coverity scan higlighted an overflow issue when the slot variable,
> > an unsigned integer that is initialized to -1, is incremented and
> > overflows.
> > 
> > Initialize slot to 0 and move the increment statement to after slot
> > is evaluated. That keeps the comparison to a u32 as is and avoids
> > overflow.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  ndctl/dimm.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> > index 889b620355fc..c39c69bfa336 100644
> > --- a/ndctl/dimm.c
> > +++ b/ndctl/dimm.c
> > @@ -97,7 +97,7 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
> >  	struct json_object *jlabel = NULL;
> >  	struct namespace_label nslabel;
> >  	unsigned int nsindex_size;
> > -	unsigned int slot = -1;
> > +	unsigned int slot = 0;
> >  	ssize_t offset;
> >  
> >  	if (!jarray)
> > @@ -115,7 +115,6 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
> >  		struct json_object *jobj;
> >  		char uuid[40];
> >  
> > -		slot++;
> >  		jlabel = json_object_new_object();
> >  		if (!jlabel)
> >  			break;
> > @@ -127,8 +126,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
> >  		if (len < 0)
> >  			break;
> >  
> > -		if (le32_to_cpu(nslabel.slot) != slot)
> > +		if (le32_to_cpu(nslabel.slot) != slot) {
> > +			slot++;
> >  			continue;
> > +		}
> > +		slot++;
> 
> Wonder if you can just increment the slot in the for() since it's not being used after this. 

Nice - thanks!
Changing to: for (offset = nsindex_size * 2; offset < size;
		  offset += ndctl_dimm_sizeof_namespace_label(dimm), slot++)


> 
> >  
> >  		uuid_unparse((void *) nslabel.uuid, uuid);
> >  		jobj = json_object_new_string(uuid);
> 
