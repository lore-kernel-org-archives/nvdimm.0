Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE92C1A5
	for <nvdimm@lists.linux.dev>; Fri,  8 Mar 2024 04:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709870766; cv=none; b=ZM406OyzdmFS5lRWnoVsucFRfv6xwmJWryc7LSE1chrND/ghQdqHD/GIX5cR+AJsD3LTzClVn17T85wmPMjM8YnBcVQ2nTuJg9Qym8ViztRMgRJcQUhTZdiHZ5uCE4266OYPrfUhKSwfVUN1wDE36CcllEJ4VE8IwxyS63jWpmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709870766; c=relaxed/simple;
	bh=+mS1Eb4rrt7e5o458zEFgbRZQbqLzVyDHET6ud9Olis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFLalmXhTd/D5nDztUadjWPay/lrEiIKIEp8okqZgOhXcy/XspmInBpwIl/71Frs2G+iIzG9iirLVgccoap3Y7fWuZ11KwHoUKx7HhgIxRnuN4a28n9IvjPGfoliyC8XIi1aCCd4f5JuE1Z4Y5ZHUP2trVBj04CsGJ7annrcwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CaNJH0oP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CaNJH0oP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709870764; x=1741406764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+mS1Eb4rrt7e5o458zEFgbRZQbqLzVyDHET6ud9Olis=;
  b=CaNJH0oPSdiIP7OkyjuM2Ly7s1EvyGxyQ3fjdYt6g92WFQ3VmBTqZlPa
   cEdbKwDX5GDNL6hKYn/5L2gRkUh+8cECntoDTocOXjTi+0d4Rx4L6/Uty
   yES6xtC3BaHlmk+2Q9p1ToWM7264VF8k9TsOzbblPE+/apLHEkag8qHjH
   douhjXw7PTUlDSgRaYl+ZJ3GxV0Jfhq8Z6HM3ux3reXvDsLlU9u6roGLR
   eWPkBlXSNTfKn6L5tKlglQxAd+1Qon/4Zo70XjlKy3POB2RD07cn49my7
   gd43mFjkSbDUkBuE2o7iQIVwjQ1nBBRs32pDYQpn/CMWylJ/pdVf18Rrf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="15722325"
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="15722325"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:06:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,108,1708416000"; 
   d="scan'208";a="10272776"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.57.195])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 20:06:03 -0800
Date: Thu, 7 Mar 2024 20:06:01 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v10 4/7] cxl/event_trace: add helpers to retrieve
 tep fields by type
Message-ID: <ZeqOqcwjbdmTS1ij@aschofie-mobl2>
References: <cover.1709748564.git.alison.schofield@intel.com>
 <3d264f1fe4c92a90eabf9cd3365a2dc69caacc4e.1709748564.git.alison.schofield@intel.com>
 <65e902155a5b4_12713294e2@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65e902155a5b4_12713294e2@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Wed, Mar 06, 2024 at 03:53:57PM -0800, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Add helpers to extract the value of an event record field given the
> > field name. This is useful when the user knows the name and format
> > of the field and simply needs to get it.
> > 
> > Since this is in preparation for adding a cxl_poison private parser
> > for 'cxl list --media-errors' support, add those specific required
> > types: u8, u32, u64, char*
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > ---
> >  cxl/event_trace.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++
> >  cxl/event_trace.h | 10 ++++++-
> >  2 files changed, 84 insertions(+), 1 deletion(-)
> > 
> > diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> > index bdad0c19dbd4..6cc9444f3204 100644
> > --- a/cxl/event_trace.c
> > +++ b/cxl/event_trace.c
> > @@ -15,6 +15,81 @@
> >  #define _GNU_SOURCE
> >  #include <string.h>
> >  
> > +static struct tep_format_field *__find_field(struct tep_event *event,
> > +					     const char *name)
> > +{
> > +	struct tep_format_field **fields;
> > +
> > +	fields = tep_event_fields(event);
> > +	if (!fields)
> > +		return NULL;
> > +
> > +	for (int i = 0; fields[i]; i++) {
> > +		struct tep_format_field *f = fields[i];
> > +
> > +		if (strcmp(f->name, name) != 0)
> > +			continue;
> > +
> > +		return f;
> > +	}
> > +	return NULL;
> > +}
> 
> Is this open-coded tep_find_field()?

Yes it is and now it is gone.

> 
> > +
> > +u64 cxl_get_field_u64(struct tep_event *event, struct tep_record *record,
> > +		      const char *name)
> > +{
> > +	struct tep_format_field *f;
> > +	unsigned char *val;
> > +	int len;
> > +
> > +	f = __find_field(event, name);
> > +	if (!f)
> > +		return ULLONG_MAX;
> > +
> > +	val = tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> > +	if (!val)
> > +		return ULLONG_MAX;
> > +
> > +	return *(u64 *)val;
> > +}
> 
> Is this just open-coded tep_get_any_field_val()?

It's a bit more. It returns ULLONG_MAX and casts to the u64 which
makes the call site cleaner. 

I did change it to use tep_get_field_val(). Please look at next rev.

> 
> > +
> > +char *cxl_get_field_string(struct tep_event *event, struct tep_record *record,
> > +			   const char *name)
> 
> Return a 'const char *'?
> 
> > +{
> > +	struct tep_format_field *f;
> > +	int len;
> > +
> > +	f = __find_field(event, name);
> > +	if (!f)
> > +		return NULL;
> > +
> > +	return tep_get_field_raw(NULL, event, f->name, record, &len, 0);
> 
> Is this guaranteed to be a string? ...and guaranteed to be NULL
> terminated?
>
It's gone. Using tep_get_field_raw() directly for str.

Thanks for reviewing!
