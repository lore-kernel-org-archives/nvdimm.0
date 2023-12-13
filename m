Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D9D10EA
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 02:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WicJ5l2q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702432973; x=1733968973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GrsDuNirVTBEMKyNq4B7JXEW2IrZZwFdE9aoOYJ90uY=;
  b=WicJ5l2qfVlVaVtb4JaZi0mqSTWJ3bkjGbyVGK7NIuYZzYGHoLuHGu0m
   gnsU9x8SS6++fquKsRHaU+qYvf7UjVok6V1siShAwGP3Pxp65CSL8/lH/
   jKrFcT+hFOKhawBWXsaY4X+r2V5OEyxwJnWmyFarj56h3jNninv+7cfWj
   mYtG0Ir8Sz6dkfmczYs7nI3TD0LQHhYwyQnRaEa1xnNnyA37uafpWbY0Q
   ZIwWL7NKYkVmBVzDoz2HgxuiHZV/YrjR+D2BdtZ+JvgUHIBRdfbg1/XCv
   +8DBAQiG2j2OD0V91MNJuRRV6Rm+q29GSxeTHczS9GvrzC3vBzBaUCqPw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="398742336"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="398742336"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 18:02:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="844126476"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="844126476"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.111.12])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 18:02:52 -0800
Date: Tue, 12 Dec 2023 18:02:50 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v5 4/5] cxl/list: add --poison option to cxl list
Message-ID: <ZXkQysAY9PAmbsHG@aschofie-mobl2>
References: <cover.1700615159.git.alison.schofield@intel.com>
 <216ab396ab0c34fc391d1c3d3797a0d832a8d563.1700615159.git.alison.schofield@intel.com>
 <657148ae35bce_b9912945d@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657148ae35bce_b9912945d@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Wed, Dec 06, 2023 at 08:23:10PM -0800, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > The --poison option to 'cxl list' retrieves poison lists from
> > memory devices supporting the capability and displays the
> > returned poison records in the cxl list json. This option can
> > apply to memdevs or regions.
> > 
> > Example usage in the Documentation/cxl/cxl-list.txt update.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  Documentation/cxl/cxl-list.txt | 58 ++++++++++++++++++++++++++++++++++
> >  cxl/filter.h                   |  3 ++
> >  cxl/list.c                     |  2 ++
> >  3 files changed, 63 insertions(+)
> > 
> > diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> > index 838de4086678..ee2f1b2d9fae 100644
> > --- a/Documentation/cxl/cxl-list.txt
> > +++ b/Documentation/cxl/cxl-list.txt
> > @@ -415,6 +415,64 @@ OPTIONS
> >  --region::
> >  	Specify CXL region device name(s), or device id(s), to filter the listing.
> >  
> > +-L::
> > +--poison::
> > +	Include poison information. The poison list is retrieved from the
> > +	device(s) and poison records are added to the listing. Apply this
> > +	option to memdevs and regions where devices support the poison
> > +	list capability.
> 
> While CXL calls it "poison" I am not convinced that's the term that end
> users can universally use for this. This is why "ndctl list" uses -M,
> but yeah, -M and -P are already taken. Even -E is taken for "errors".
> 
> > +
> > +----
> > +# cxl list -m mem11 --poison
> > +[
> > +  {
> > +    "memdev":"mem11",
> > +    "pmem_size":268435456,
> > +    "ram_size":0,
> > +    "serial":0,
> > +    "host":"0000:37:00.0",
> > +    "poison":{
> > +      "nr_records":1,
> > +      "records":[
> 
> One cleanup I want to see before this goes live... drop nr_records and
> just make "poison" an array object directly. The number of records is
> trivially determined by the jq "len" operator.

The poison nr_records count is a convenience for the cmdline user,
not for the user doing their own jq parsing. It also intends to
explicitly show nr_records:0 when no poison is found.

Say NAK again and I'll rm it all.

> 
> Also, per above rename "poison" to "media_errors". I believe "poison" is
> an x86'ism where "media_error" is a more generic term.

OK

> 
> > +        {
> > +          "dpa":0,
> > +          "dpa_length":64,
> > +          "source":"Internal",
> > +        }
> > +      ]
> > +    }
> > +  }
> > +]
> > +# cxl list -r region5 --poison
> > +[
> > +  {
> > +    "region":"region5",
> > +    "resource":1035623989248,
> > +    "size":2147483648,
> > +    "interleave_ways":2,
> > +    "interleave_granularity":4096,
> > +    "decode_state":"commit",
> > +    "poison":{
> > +      "nr_records":2,
> > +      "records":[
> > +        {
> > +          "memdev":"mem2",
> > +          "dpa":0,
> > +          "dpa_length":64,
> 
> Does length need to be prefixed with "dpa_"?
>

Nope. Will remove.

> > +          "source":"Internal",
> 
> I am not sure what the end user can do with "source"? I have tended to
> not emit things if I can't think of a use case for the field to be
> there.
Erwin followed w a comment on this one. Yeah, I think folks want to 
know if error was injected at least.

Alison

