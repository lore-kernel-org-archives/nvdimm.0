Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFEB55E46
	for <nvdimm@lists.linux.dev>; Mon, 18 Mar 2024 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710782894; cv=none; b=S61/w+ySGGs6LkiT/sxzd4bN3nO1GprKI9u3J9+Dan+Npzg1nxKuQI2MjnwEeCLqwLazydWHLh8T5x0x4vV21pMLfXrSdWXJJsKw8DzeYBh2hRvgPpWM3RoUUhXLmyW6APsW9scghvtDu+1TVFe+KJblGA/YmqQ+YNzl32rkLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710782894; c=relaxed/simple;
	bh=MAo4xDqmoPcOgEOpUacsHVSs07f+0Tp4zMmL3tmkYs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X1v/PHqfnwLMl625B1qjnpIP/jqn1iSNwt4xboksCZqtuKcEDHpckwyPN18BECYm/8Gj5eE0YGNGGNnXipOrdXjO5oml4bt4tQV6VnbckX8ecAlqgAJV3T4xxkV3r/ljxSypMvZHKgRCTrJ0c20UoK1Rua14l8hopCjqSQmKclY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BBCyf/CQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BBCyf/CQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710782891; x=1742318891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MAo4xDqmoPcOgEOpUacsHVSs07f+0Tp4zMmL3tmkYs0=;
  b=BBCyf/CQ5IhXmyftGE0GeDX5CsP0+Guej37QUneloBrBxtX36q7Q2wG4
   AeIS+p7rC5JHz+2Y4I8PZHUrtFF68JHDHpzxXif7ES7mTzU39j2GJEl9/
   iYxAEzUH26hZcMaSpNCxWJLmbbYOKQ7FTpwYhqnA76HQL0WMb8mccMcDK
   t1a0MsesM1RblD5pbXahLW9SYCYNzgdNCNqa5vniYkT1sTven4YXu31M5
   yyBTWP+xqwuQnjxVoWFkKrEF3EhHL7TKtDiyNk9XjJixVW/5DOZgoP09/
   sPbq50lRokjqw800wMV1c0q4/MURsh9VfLDyKDqvJ87dEosSNfvEwpLod
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11017"; a="17012676"
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="17012676"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:28:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,134,1708416000"; 
   d="scan'208";a="18144905"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.83.98])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2024 10:28:10 -0700
Date: Mon, 18 Mar 2024 10:28:08 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v11 4/7] cxl/event_trace: add helpers to retrieve
 tep fields by type
Message-ID: <Zfh5qOrTB/ijMGBQ@aschofie-mobl2>
References: <cover.1710386468.git.alison.schofield@intel.com>
 <0dbf9557aaf5e8047440cb74f7df84ae404c11ba.1710386468.git.alison.schofield@intel.com>
 <65f487e9fbfa_aa222949f@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65f487e9fbfa_aa222949f@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Fri, Mar 15, 2024 at 10:39:53AM -0700, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Add helpers to extract the value of an event record field given the
> > field name. This is useful when the user knows the name and format
> > of the field and simply needs to get it. The helpers also return
> > the 'type'_MAX of the type when the field is
> > 
> > Since this is in preparation for adding a cxl_poison private parser
> > for 'cxl list --media-errors' support those specific required
> > types: u8, u32, u64.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/event_trace.c | 37 +++++++++++++++++++++++++++++++++++++
> >  cxl/event_trace.h |  8 +++++++-
> >  2 files changed, 44 insertions(+), 1 deletion(-)
> > 
> > diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> > index 640abdab67bf..324edb982888 100644
> > --- a/cxl/event_trace.c
> > +++ b/cxl/event_trace.c
> > @@ -15,6 +15,43 @@
> >  #define _GNU_SOURCE
> >  #include <string.h>
> >  
> > +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> > +		      const char *name)
> > +{
> > +	unsigned long long val;
> > +
> > +	if (tep_get_field_val(NULL, event, name, record, &val, 0))
> > +		return ULLONG_MAX;
> > +
> > +	return val;
> > +}
> 
> Hm, why are these prefixed "cxl_" there is nothing cxl specific in the
> internals. Maybe these event trace helpers grow non-CXL users in the
> future. Could be "trace_" or "util_" like other generic helpers in the
> codebase.

All the helpers in cxl/event_trace.c are prefixed "cxl_". The cxl
special-ness is only that ndctl/cxl is the only user of trace events
in ndctl/.  cxl/monitor.c and now cxl/json.c (this usage)

I can move: ndctl/cxl/event_trace.h,c to ndctl/utils/event_trace.h,c.
and update cxl/monitor.c to find.

Yay?

