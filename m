Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2EB374C2
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 02:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709174715; cv=none; b=dYCn9Nej9drF7vquYZI6QwB2CG9L128ZzVJ4kkAEK9c48GkzRCoHR8t5Je/P5QVX0xRYP59zKrlW2TIo3mjFwNyoZmdtk4pAbD6xuZ1+lohfJ4AXE3hf26rOO5/LDrGAuyPByx/YjrVZ1eZ5f4/fl/i1v9GigmcljCdVInkGMNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709174715; c=relaxed/simple;
	bh=BkRvayXX09joq1PwMzdVPUYYCUFeSScVRw3Y76mzN/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeqNfq2FnCgo3UZ4L5I9YDg77vltSHTGHGEanv7q6EQm7O2pGqnW+lmPXFGawOapAC8rgc8+pWYqSn4q7X16SLIRrhOR9kSdOUPe6NlMtN9XWreehvOwzidhVN1lkHRyjo35cyZIb5M7BsxKV34SxuMBoXfLtPzdstlk2L90TNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=meXdoC92; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meXdoC92"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709174713; x=1740710713;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BkRvayXX09joq1PwMzdVPUYYCUFeSScVRw3Y76mzN/M=;
  b=meXdoC92oXuzpqbpYQg4PpqvmgSyvtenRNiIi4xqSOZBlwZZ/oEl5Ibi
   A1B+FiUGVUeTYySMm0Tk2UjDYvhHaiscTsgRl3Hu+8SF0TjQC5bSMKWCE
   BobDNpIlERClQ1kJoTwlJiKRLns9dJEAWPDODH65iNrunXqtbz/v8eLe+
   VE431Efgej/D17WQBZQBlLuTn8PjWWXSfAKn05eLTFS/sav1JnPv4SUSI
   yKXU2/wmJ5TbJI1jhbnWuGo35JYn+o9YX75aI6geStqGxfXhKVB4YLNxK
   XQEYqx5VsBaN2cuMtWyJCP74l0rgIzUWKvlF7c3N4ddLD5Y8n3M7y2g1N
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="15033878"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="15033878"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 18:45:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="12217304"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.18.161])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 18:45:12 -0800
Date: Wed, 28 Feb 2024 18:45:09 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v7 5/7] cxl/list: collect and parse media_error
 records
Message-ID: <Zd/vtfjCoLvjTT1q@aschofie-mobl2>
References: <cover.1707351560.git.alison.schofield@intel.com>
 <566a2acff6a3f32a1d6af9d81fb0da8808e5b4ff.1707351560.git.alison.schofield@intel.com>
 <b3f23b92-99f6-404e-aed2-19a8f5ceb43f@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3f23b92-99f6-404e-aed2-19a8f5ceb43f@intel.com>

On Thu, Feb 08, 2024 at 09:50:27AM -0700, Dave Jiang wrote:
> 

Hi Dave,

Sorry I missed this in v8. Picking up for v9.  
See a question below -


snip
> 
> > +static const char *
> > +find_decoder_name(struct poison_ctx *ctx, const char *name, u64 addr)
> > +{
> > +	struct cxl_memdev *memdev = ctx->memdev;
> > +	struct cxl_memdev_mapping *mapping;
> > +	struct cxl_endpoint *endpoint;
> > +	struct cxl_decoder *decoder;
> > +	struct cxl_port *port;
> > +	u64 start, end;
> > +
> > +	if (memdev)
> > +		goto find_decoder;
> > +
> > +	cxl_mapping_foreach(ctx->region, mapping) {
> > +		decoder = cxl_mapping_get_decoder(mapping);
> > +		if (!decoder)
> > +			continue;
> > +
> > +		memdev = cxl_decoder_get_memdev(decoder);
> > +		if (strcmp(name, cxl_memdev_get_devname(memdev)) == 0)
> > +			break;
> > +
> > +		memdev = NULL;
> > +	}
> > +
> > +find_decoder:
> 
> Would it be cleaner to move this block into a helper function? Don't really care for goto blocks that are not error handling paths.

Done. Added a __find_memdev.

> 
> > +	if (!memdev)
> > +		return NULL;
> > +
> > +	endpoint = cxl_memdev_get_endpoint(memdev);
> > +	port = cxl_endpoint_get_port(endpoint);
> > +
> > +	cxl_decoder_foreach(port, decoder) {
> > +		start =  cxl_decoder_get_resource(decoder);
> > +		end = start + cxl_decoder_get_size(decoder) - 1;
> > +		if (start <= addr && addr <= end)
> > +			return cxl_decoder_get_devname(decoder);
> > +	}
> > +
> > +	return NULL;

And, with another look - cleaned up the above indented/hidden
successful return ;)


> > +}
> > +
> > +int poison_event_to_json(struct tep_event *event, struct tep_record *record,
> > +			 void *ctx)
> > +{
> > +	struct poison_ctx *p_ctx = (struct poison_ctx *)ctx;
> > +	struct json_object *jobj, *jp, *jpoison = p_ctx->jpoison;
> > +	unsigned long flags = p_ctx->flags;
> > +	bool overflow = false;
> > +	unsigned char *data;
> > +	const char *name;
> > +	int pflags;
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
> > +	data = cxl_get_field_data(event, record, "hpa");
> > +	if (*(uint64_t *)data != ULLONG_MAX)
> > +		name = find_decoder_name(p_ctx, name, *(uint64_t *)data);
> > +	else
> > +		name = NULL;
> > +
> > +	if (name) {
> > +		jobj = json_object_new_string(name);
> > +		if (jobj)
> > +			json_object_object_add(jp, "decoder", jobj);
> > +
> > +		jobj = util_json_object_hex(*(uint64_t *)data, flags);
> > +		if (jobj)
> > +			json_object_object_add(jp, "hpa", jobj);
> > +	}
> > +
> > +	data = cxl_get_field_data(event, record, "dpa");
> > +	jobj = util_json_object_hex(*(uint64_t *)data, flags);
> > +	if (jobj)
> > +		json_object_object_add(jp, "dpa", jobj);
> > +
> > +	data = cxl_get_field_data(event, record, "dpa_length");
> > +	jobj = util_json_object_size(*(uint32_t *)data, flags);
> > +	if (jobj)
> > +		json_object_object_add(jp, "length", jobj);
> > +
> > +	str = cxl_get_field_string(event, record, "source");
> > +	switch (*(uint8_t *)str) {
> 
> This causes reading confusion when it looks like the code is retrieving a string and then compare as an integer. Should this be done through cxl_get_field_data()?
> 

Did a couple of things here -
reworked the helpers to give exactly what is needed here,
ie int, u64 or string. That gets rid of all the casting.
It also led to a bit more error checking on return value,
so bonus goodness.


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
> > +	if (jobj)
> > +		json_object_object_add(jp, "source", jobj);
> > +
> > +	str = cxl_get_field_string(event, record, "flags");
> > +	pflags = *(uint8_t *)str;
> 
> Same as above comment here

Gone. All the values that can be held in "int" are fetched
using a cxl_get_field_int().

snip
> > +static struct json_object *
> > +util_cxl_poison_events_to_json(struct tracefs_instance *inst,
> > +			       struct poison_ctx *p_ctx)
> > +{
> > +	struct event_ctx ectx = {
> > +		.event_name = "cxl_poison",
> > +		.event_pid = getpid(),
> > +		.system = "cxl",
> > +		.private_ctx = p_ctx,
> > +		.parse_event = poison_event_to_json,
> > +	};
> > +	int rc = 0;
> > +
> > +	p_ctx->jpoison = json_object_new_array();
> > +	if (!p_ctx->jpoison)
> > +		return NULL;
> > +
> > +	rc = cxl_parse_events(inst, &ectx);
> > +	if (rc < 0) {
> > +		fprintf(stderr, "Failed to parse events: %d\n", rc);
> > +		json_object_put(p_ctx->jpoison);
> > +		return NULL;
> 
> Maybe a goto err here and the next error path may now be warranted?
> > +	}
> > +
> > +	if (json_object_array_length(p_ctx->jpoison) == 0) {
> > +		json_object_put(p_ctx->jpoison);
> > +		return NULL;
> > +	}
> > +
> > +	return p_ctx->jpoison;
> > +}

Not sure what you suggest here. I can combine the err cases like
this:

if ((rc < 0) || json_object_array_length(p_ctx->jpoison) == 0) {
	fprintf(stderr, "Failed to parse events: %d\n", rc);
	json_object_put(p_ctx->jpoison);
	return NULL;
}

Or (and) something else?

