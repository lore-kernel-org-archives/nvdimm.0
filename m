Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8565F29CA
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641588841; x=1673124841;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=2VdpZtptkMgSPHv7GumfnJEg19dMuq63YzkBEOmPIn0=;
  b=IpCCcpUQPWkeuQd1YgLlQq4FdujI+OWjn+7mwkfkhQR1v4bhdH8p+0gJ
   eWBVDnA6Xjx40DMRJ20X64zCpHCSBYUi3oCDbl1BIUu3UZ/VPBl7h681D
   iVN/CwN0YJxC4OJZzMji5uh1t8O/n1W5n317CCFOixTxwNuvFrHELVxfN
   Q9w0MWS3YzKvBDWVIH2IsIY7d0fclKjg1hYgkQHEN4lq8XxxCZ/9gwHrN
   4Ihs96m9ErZQyvzj9YYC29SHIZfDTXjNkXQShCsXqj3+yowdFsMPK8aIU
   077MhKGX4f/QVw7KCnpZw+/9BWBOvLBcFMzEOYYeSnWjsYEa+eNdXm064
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242893001"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242893001"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:54:01 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="557379491"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:54:01 -0800
Date: Fri, 7 Jan 2022 12:59:11 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 6/7] ndctl, util: use 'unsigned long long' type in
 OPT_U64 define
Message-ID: <20220107205911.GA803891@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <4653004cf532c2e14f79a45bddf0ebaac09ef4e6.1641233076.git.alison.schofield@intel.com>
 <20220106205454.GG178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106205454.GG178135@iweiny-DESK2.sc.intel.com>

On Thu, Jan 06, 2022 at 12:54:54PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:17PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > The OPT_U64 define failed in check_vtype() with unknown 'u64' type.
> > Replace with 'unsigned long long' to make the OPT_U64 define usable.
> 
> I feel like this should be the first patch in the series.

I felt like it was a fixup, that should go right before I use it.

Now that the -size parameter is getting changed to a string,
(next patch feedback), this isn't needed.

I'll drop this patch from the set and save it for trivial cleanup
day.

more below...
> 
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  util/parse-options.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/util/parse-options.h b/util/parse-options.h
> > index 9318fe7..91b7932 100644
> > --- a/util/parse-options.h
> > +++ b/util/parse-options.h
> > @@ -124,7 +124,7 @@ struct option {
> >  #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
> >  #define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
> >  #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
> > -#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
> > +#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned long long *), .help = (h) }
> 
> Why can't this be uint64_t?

I don't know. ULL worked so I didn't look further.
Is uint64_t more suitable?

> 
> Ira
> 
> >  #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
> >  #define OPT_FILENAME(s, l, v, a, h) { .type = OPTION_FILENAME, .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
> >  #define OPT_DATE(s, l, v, h) \
> > -- 
> > 2.31.1
> > 
