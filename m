Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EA3266D4
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750380; cv=none; b=pu4iHlJbeOptCcL+CUjcaHTDjli6rQ4U/ePxtwB3t1rUVZfuyJVeXDFnoEwUYelhgUJMFGT9jZ8wIPT65f7c2eNkJMmUz3TKJByjAR1q3clbpTcrrXamZ2z2zl8Lhe7r1JWs5woeQQeUZEQx+mHYQIlhZnFEgYiOj7+0fvvrJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750380; c=relaxed/simple;
	bh=xb7JvkEju0Mcu4tPfFmUTTwajxgqXxRL8GT8RZczl1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iiinNjzR3fqSsdQzXNEXokqbCAGhxX6kxNKOEtWvYrn70lMwGsMHToleiPiiUuiFSklwr9055tTGfcSQN+rWIkevFemCgU5IJ4JEonV/AGxuWAuUGSOITzi+6aySpHsOkrsf8Vk1wQeCNFElGcHwB4X+gHeZP/UQuanUcWKQ6wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FxzfvLTK; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FxzfvLTK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750378; x=1741286378;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xb7JvkEju0Mcu4tPfFmUTTwajxgqXxRL8GT8RZczl1E=;
  b=FxzfvLTKFzwzDznr8bEharLfm+0D9fkJK6nzTUneF2WOK3GJ3YAa68Bv
   d2y+OkQXSYm8Xe7W+AUdfaxS7ejsws89yRH72hvgtEFSwRJ8AHMS7FD9C
   L5JN4s/HbtuuIwINvbVWHlnYTchR2VSM/h0W0RJXKnGvbpnYCqFFOpRq5
   wKvzdeSfeWUCxz0ou70Md73p81TG9BHUCZ+4DnlF+mQ8iHa/9P2sm/mGp
   6juh1L3twKcJ6V3HytVIWF9vr52nk8XkT4J09Q+RSd13iWkiYdoOFsGnN
   Q92dOP8WYeQiO2Mi+jpv0+CAOY5OhAsW8nPlm/ePBqES2E8zcQSWoRwKk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4562463"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="4562463"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:39:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40823372"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.251.9.155])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:39:37 -0800
Date: Wed, 6 Mar 2024 10:39:35 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v9 5/7] cxl/list: collect and parse media_error
 records
Message-ID: <Zei4Z9sukWIEqkAn@aschofie-mobl2>
References: <cover.1709253898.git.alison.schofield@intel.com>
 <9a6be3fd24b22661ec39ea614f75266b594026b3.1709253898.git.alison.schofield@intel.com>
 <85f2763b-6665-4f76-9175-d7c5acaf2a3d@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f2763b-6665-4f76-9175-d7c5acaf2a3d@intel.com>

On Mon, Mar 04, 2024 at 01:03:55PM -0700, Dave Jiang wrote:
> 
> 
> On 2/29/24 6:31 PM, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Media_error records are logged as events in the kernel tracing
> > subsystem. To prepare the media_error records for cxl list, enable
> > tracing, trigger the poison list read, and parse the generated
> > cxl_poison events into a json representation.
> > 
> > Use the event_trace private parsing option to customize the json
> > representation based on cxl-list calling options and event field
> > settings.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/json.c | 271 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 271 insertions(+)
> > 

snip

> > +static int poison_event_to_json(struct tep_event *event,
> > +				struct tep_record *record, void *ctx)
> > +{
> > +	struct poison_ctx *p_ctx = (struct poison_ctx *)ctx;
> > +	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
> > +	unsigned long flags = p_ctx->flags;
> > +	char flag_str[32] = { '\0' };
> > +	bool overflow = false;
> > +	u8 source, pflags;
> > +	const char *name;
> > +	u64 addr, ts;
> > +	u32 length;
> > +	char *str;
> > +
> > +	jp = json_object_new_object();
> > +	if (!jp)
> > +		return -ENOMEM;
> > +
> > +	/* Skip records not in this region when listing by region */
> > +	name = p_ctx->region ? cxl_region_get_devname(p_ctx->region) : NULL;
> > +	if (name)
> > +		str = cxl_get_field_string(event, record, "region");
> > +
> > +	if ((name) && (strcmp(name, str) != 0)) {
> > +		json_object_put(jp);
> > +		return 0;
> > +	}
> > +
> > +	/* Include endpoint decoder name with hpa, when present */
> > +	name = cxl_get_field_string(event, record, "memdev");
> > +	addr = cxl_get_field_u64(event, record, "hpa");
> > +	if (addr != ULLONG_MAX)
> > +		name = find_decoder_name(p_ctx, name, addr);
> > +	else
> > +		name = NULL;
> 
> Why assign name a few lines above and then reassign here without using?

name is used as a param to find_decoder_name(). I'll move that to
only retrieve from the record if we're doing find_decod_name().


> Also I noticed the name gets reassigned for different purposes a few times. Can we have separate variables in order to make the code cleaner to read? I think maybe a region_name and a decoder_name.

Yes, done in v10.

> > 

snip

> > +
> > +	source = cxl_get_field_u8(event, record, "source");
> > +	switch (source) {
> > +	case CXL_POISON_SOURCE_UNKNOWN:
> > +		jobj = json_object_new_string("Unknown");
> > +		break;
> > +	case CXL_POISON_SOURCE_EXTERNAL:
> > +		jobj = json_object_new_string("External");
> > +		break;
> > +	case CXL_POISON_SOURCE_INTERNAL:
> > +		jobj = json_object_new_string("Internal");
> > +		break;
> > +	case CXL_POISON_SOURCE_INJECTED:
> > +		jobj = json_object_new_string("Injected");
> > +		break;
> > +	case CXL_POISON_SOURCE_VENDOR:
> > +		jobj = json_object_new_string("Vendor");
> > +		break;
> > +	default:
> > +		jobj = json_object_new_string("Reserved");
> > +	}
> 
> Seems like you can have a static string table here? Then you can do something like:
> if (source < CXL_POISON_SOURCE_MAX)
> 	jobj = json_object_new_string(cxl_poison_source[source]);
> else
> 	jobj = json_object_new_string("Reserved");
> 
> DJ

Nice! Please take a look at in v10.

Thanks for the review!

snip
