Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911176EE8
	for <nvdimm@lists.linux.dev>; Wed, 28 Feb 2024 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161183; cv=none; b=hLhWx8iBgFULtXCbQgrYdWsQb2gd5LEIIPc11+5bD5t1T/fs+tnK/rNqOmwfTTrY77CtWAzmZciJPecdvTSd/cbEQwI8LJX3ZkkIZIrfZC+LVBappEWgKKZcEJDRhm4gj/BOqFUMOngCpmJOZc8VdY2RqpK/YAExgX00zj+pY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161183; c=relaxed/simple;
	bh=2OT10Kh4ofV6zBCgWJMe0v8GiLRxgQAE6QkYcL6uwBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuy6IIRVixQHkH3hLfLEn+o7VSmzbPLTbauxeRkI+bZ7YT49P9apZbcjs6+iWd6oR5Scrcgw0B9fgtgRc89O/g9AW/iCmXNZ6An/8+lliQ/tC/vwqjDSEnFWG8UNcZUvCp00wuzZoFHVX62LwMLGfyEsvEhtnKW0aAzbUvnfxJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WkVafseQ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WkVafseQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709161180; x=1740697180;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=2OT10Kh4ofV6zBCgWJMe0v8GiLRxgQAE6QkYcL6uwBs=;
  b=WkVafseQmri3t6V5h5+NGyIAACFyx30/8Seax0hvPI0EgPzLK9cU3tRs
   8S7hNmjgIvGx60gKEYP/SMZqeOvBbtH4fdM4IJchLKHY5ojOj5toUFWyu
   1gE6tK1Iu568KjDbK5gzQ6TbVaVYriqcD1Hoip+yghBYf8IBqJ2+Ka7+j
   9mz2s83zWv/qbSIPHOQQfE5iYTnA6ZA5xtDK9dOx2V8gRYYRxqFfWn75i
   Kk7P57S8n/jVv3aT073R9VA2DC23PrGOsvOh3f/LIVOFwMDNF0+bq6rME
   s6KAtdNb0Owk4q3L+OZYMpOIS2sZOzWue7oiK18iem4NU2dbj1++KnQAr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="7379900"
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7379900"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 14:59:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,191,1705392000"; 
   d="scan'208";a="7541604"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.18.161])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 14:59:39 -0800
Date: Wed, 28 Feb 2024 14:59:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>
Subject: Re: [ndctl PATCH] cxl/event_trace: parse arrays separately from
 strings
Message-ID: <Zd+62Upfj/JIVMYp@aschofie-mobl2>
References: <20240216060610.1951127-1-alison.schofield@intel.com>
 <7871c5c424338b7f7cf766f77a6cb7b21d4c7a10.camel@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7871c5c424338b7f7cf766f77a6cb7b21d4c7a10.camel@intel.com>

On Wed, Feb 28, 2024 at 01:52:11PM -0800, Vishal Verma wrote:
> On Thu, 2024-02-15 at 22:06 -0800, alison.schofield@intel.com wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Arrays are being parsed as strings based on a flag that seems like
> > it would be the differentiator, ARRAY and STRING, but it is not.
> >
> > libtraceevent sets the flags for arrays and strings like this:
> > array:  TEP_FIELD_IS_[ARRAY | STRING]
> > string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]
> >
> > Use TEP_FIELD_IS_DYNAMIC to discover the field type, otherwise arrays
> > get parsed as strings and 'cxl monitor' returns gobbledygook in the
> > array type fields.
> >
> > This fixes the "data" field of cxl_generic_events and the "uuid"
> > field
> > of cxl_poison.
> >
> > Before:
> > {"system":"cxl","event":"cxl_generic_event","timestamp":3469041387470
> > ,"memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-
> > abcd-efeb-a55a-
> > a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_ha
> > ndle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0
> > ,"data":"Þ­¾ï"}
> 
> When applying, b4 complains of these in the commit message as
> "suspicious unicode control characters". I'm also not a huge fan of the
> super long lines, perhaps we can just drop the before/after examples?

Yes - that got silly long!  Can you drop on applying please?

> 
> >
> > After:
> > {"system":"cxl","event":"cxl_generic_event","timestamp":312851657810,
> > "memdev":"mem0","host":"cxl_mem.0","log":0,"hdr_uuid":"ba5eba11-abcd-
> > efeb-a55a-
> > a55aa5a55aa5","serial":0,"hdr_flags":8,"hdr_handle":1,"hdr_related_ha
> > ndle":42422,"hdr_timestamp":0,"hdr_length":128,"hdr_maint_op_class":0
> > ,"data":[222,173,190,239,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
> > 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
> > ,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
> >
> > Before:
> > {"system":"cxl","event":"cxl_poison","timestamp":3292418311609,"memde
> > v":"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"regi
> > on5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length
> > ":64,"uuid":"�Fe�c�CI�����2�]","source":0,"flags":0}
> >
> > After:
> > {"system":"cxl","event":"cxl_poison","timestamp":94600531271,"memdev"
> > :"mem1","host":"cxl_mem.1","serial":1,"trace_type":2,"region":"region
> > 5","overflow_ts":0,"hpa":1035355557888,"dpa":1073741824,"dpa_length":
> > 64,"uuid":[139,200,184,22,236,103,76,121,157,243,47,110,243,11,158,62
> > ],"source":0,"flags":0}
> >
> > That cxl_poison uuid format can be further improved by using the
> > trace
> > type (__field_struct uuid_t) in the CXL kernel driver. The parser
> > will
> > automatically pick up that new type, as illustrated in the "hdr_uuid"
> > of cxl_generic_media event trace above.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/event_trace.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/cxl/event_trace.c b/cxl/event_trace.c
> > index db8cc85f0b6f..1b5aa09de8b2 100644
> > --- a/cxl/event_trace.c
> > +++ b/cxl/event_trace.c
> > @@ -109,7 +109,13 @@ static int cxl_event_to_json(struct tep_event
> > *event, struct tep_record *record,
> >               struct tep_format_field *f = fields[i];
> >               int len;
> >
> > -             if (f->flags & TEP_FIELD_IS_STRING) {
> > +             /*
> > +              * libtraceevent differentiates arrays and strings
> > like this:
> > +              * array:  TEP_FIELD_IS_[ARRAY | STRING]
> > +              * string: TEP_FIELD_IS_[ARRAY | STRING | DYNAMIC]
> > +              */
> > +             if ((f->flags & TEP_FIELD_IS_STRING) &&
> > +                 ((f->flags & TEP_FIELD_IS_DYNAMIC))) {
> >                       char *str;
> >
> >                       str = tep_get_field_raw(NULL, event, f-
> > >name, record, &len, 0);
> >
> > base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
> 
