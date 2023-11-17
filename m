Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310BA171BB
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gccEF4kv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700239497; x=1731775497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vtzkO79yDpqsymnBPi+oAs1gOWK/B86Cv1Ti3VkxHDg=;
  b=gccEF4kvBkOJr2W2iOPmoFUmz3IBTD6bxAMLC4+7nFckKHlEk6GFEgXa
   p/4zzTW8FVxwWvXpMfFqUnYcblB8EGuFx6mMiFq5tjZtkW8I/R6tpjy2U
   3LXlWeA9yn3Pt4HBRCNahU2YUNNUKltjz2Rd4m40M3johk+RHAWEbN1nG
   VzLmpgJqH+4dHzXM2PdR/M8eBEkrtQz8grQojeiPjY8hZCL/PT9c2HhxL
   KlbcL00P1S2eGdFDgsYUPiNMFlIq5xpsslbPsgDyb27A1ikjcqfjXjKqf
   TKTW4oS7AGhLsRoCnPAa94NCDr7m7hiuiI5yW73LmMhqKdif8pbaGOYZn
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="388478693"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="388478693"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:44:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="856389139"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="856389139"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.86.159])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 08:44:56 -0800
Date: Fri, 17 Nov 2023 08:44:54 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 3/5] cxl/list: collect and parse the poison list
 records
Message-ID: <ZVeYhkyoWhCacC0l@aschofie-mobl2>
References: <cover.1696196382.git.alison.schofield@intel.com>
 <80f60f513ced74bc5eed7d0082faf74783fa41d7.1696196382.git.alison.schofield@intel.com>
 <40bfee841cfcaaf5fe139f53fafe74ca394ebc54.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40bfee841cfcaaf5fe139f53fafe74ca394ebc54.camel@intel.com>

On Wed, Nov 15, 2023 at 02:09:15AM -0800, Vishal Verma wrote:
> On Sun, 2023-10-01 at 15:31 -0700, alison.schofield@intel.com wrote:

snip

> >
> > +/* CXL 8.2.9.5.4.1 Get Poison List: Poison Source */
> 
> These usually have a spec version too - "CXL 3.0 8.2.9... "

Got it. Fixed up the two like this and also a commit log reference.
Moved them all to the now released CXL 3.1 spec.

> > +static struct json_object *
> > +util_cxl_poison_events_to_json(struct tracefs_instance *inst, bool is_region,
> > +                              unsigned long flags)
> > +{
> > +       struct json_object *jerrors, *jmedia, *jobj = NULL;
> 
> Since everything else is now 'poison', might be good to also
> s/jmedia/jpoison/ everywhere.

Done.

> > +
> > +       list_for_each_safe(&ectx.jlist_head, jnode, next, list) {
> > +               struct json_object *jval = NULL;
> > +               struct json_object *jp = NULL;
> 
> Are the NULL assignments needed? At least for @jp, it is
> unconditionally assigned below, and isn't used before that. I suspect
> json-c probably doesn't care about what's in @jval either before
> writing it.
>

jp init, obvious not init needed.
For jval init, I guess I worried about garbage in jval, but the way the
trace event is built, it's not a concern.

Removed both those inits.

snip

> > +               if (json_object_object_get_ex(jnode->jobj, "source", &jval)) {
> > +                       source = json_object_get_int(jval);
> > +                       if (source == CXL_POISON_SOURCE_UNKNOWN)
> > +                               jobj = json_object_new_string("Unknown");
> > +                       else if (source == CXL_POISON_SOURCE_EXTERNAL)
> > +                               jobj = json_object_new_string("External");
> > +                       else if (source == CXL_POISON_SOURCE_INTERNAL)
> > +                               jobj = json_object_new_string("Internal");
> > +                       else if (source == CXL_POISON_SOURCE_INJECTED)
> > +                               jobj = json_object_new_string("Injected");
> > +                       else if (source == CXL_POISON_SOURCE_VENDOR)
> > +                               jobj = json_object_new_string("Vendor");
> > +                       else
> > +                               jobj = json_object_new_string("Reserved");
> 
> Minor nit, but maybe 'switch (source) ...' would look a bit cleaner?

Done.

> 
> > +
> > +       /* Always include the count. If count is zero, no records follow. */
> > +       jobj = json_object_new_int(count);
> > +       if (jobj)
> > +               json_object_object_add(jmedia, "nr_poison_records", jobj);
> > +       if (count)
> > +               json_object_object_add(jmedia, "poison_records", jerrors);
> 
> Since these are already nested under a 'poison' JSON object, I'm
> tempted to say these can just be 'nr_records' and 'records'
> respectively.
> 

Done.

> > +
> > +       return jmedia;
> > +}
> > +
> > +struct cxl_poison_ctx {
> > +       void *dev;
> > +       bool is_region;
> > +};
> 
> This structure is a bit awkward - what do you think about creating
> different wrappers for the memdev and region case -
> 
>   util_cxl_memdev_poison_list_to_json(), and
>   util_cxl_region_poison_list_to_json() that are called respectively by
> 
> util_cxl_{memdev,region}_to_json(), and internally they can call:
> 
>   util_cxl_poison_list_to_json(NULL, memdev, flags), or
>   util_cxl_poison_list_to_json(region, NULL, flags)
> 
> For the next level down, i.e. poison_events_to_json, the @is_region
> bool passed in directly is fine as it doesn't need the memdev or region
> objects passed in via void *.

Thanks! I did something like this but didn't actually add wrappers.
Please look in v3 and let me know.

> 
snip

> > +       if (pctx->is_region)
> > +               rc = cxl_region_trigger_poison_list(pctx->dev);
> > +       else
> > +               rc = cxl_memdev_trigger_poison_list(pctx->dev);
> > +       if (rc) {
> > +               fprintf(stderr, "Failed write of sysfs attribute: %d\n", rc);
> 
> This would be incorrect if the memdev trigger reported an ENOMEM, and
> then this reported a sysfs write failure.
> 
> It should at least be something like 'failed to trigger poison" - but
> since the memdev trigger helper has prints for every failure case,
> maybe this can just be omitted?

Removed it.

>
snip

> > diff --git a/util/json.h b/util/json.h
> > index ea370df4d1b7..3ae4074a95c3 100644
> > --- a/util/json.h
> > +++ b/util/json.h
> > @@ -21,6 +21,7 @@ enum util_json_flags {
> >         UTIL_JSON_TARGETS       = (1 << 11),
> >         UTIL_JSON_PARTITION     = (1 << 12),
> >         UTIL_JSON_ALERT_CONFIG  = (1 << 13),
> > +       UTIL_JSON_POISON_LIST   = (1 << 14),
> 
> There's already a UTIL_JSON_MEDIA_ERRORS, can we just reuse that (in
> spite of the name :))

Since it's not visible to user, changed it.

Thanks for the review Vishal!

> 
