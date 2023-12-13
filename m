Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBFB10E2
	for <nvdimm@lists.linux.dev>; Wed, 13 Dec 2023 02:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cFTa/ycp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702433625; x=1733969625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1PMAyvKAy7zoBw3d0krkf1EWrCx1NHuXddCqDc8iX9o=;
  b=cFTa/ycpSJrkdyXHuevWz+L2ANfMw255RPUDrNclV7BPZjYY350ThjJp
   odSZTlYsebTnKwce5O9U7yTr6nwxwxJim1+72PtewPAMnDnGQ1ojibzkB
   KkdiOvRVub/N0lipqcyGWKTF/Os5VIVFVROtmWPRHNmZ71aQ/gCukWCMF
   mT1kqnlJ/N5L6dZpaiYuZNhoY0mtKcKc2BorbjU18VBwCqe1cay8sNbFS
   3e+nU7HvguRfQdbp955GGvedKRRomOw8bK/MJCQ0adOALePYPrQJO51KE
   2gjjjITVnIl18LZ8GwrdJhBManFG7fAiDmJFwf0VXtuu/DkmXU7wA8hKw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="459220433"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="459220433"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 18:13:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10922"; a="917496528"
X-IronPort-AV: E=Sophos;i="6.04,271,1695711600"; 
   d="scan'208";a="917496528"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.111.12])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 18:13:43 -0800
Date: Tue, 12 Dec 2023 18:13:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v5 3/5] cxl/list: collect and parse the poison list
 records
Message-ID: <ZXkTVgFroObfs4kW@aschofie-mobl2>
References: <cover.1700615159.git.alison.schofield@intel.com>
 <bf65d11d6388bcdce2e6dc35064edf4094c0c5a8.1700615159.git.alison.schofield@intel.com>
 <65714c6b472ee_269bd29417@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65714c6b472ee_269bd29417@dwillia2-mobl3.amr.corp.intel.com.notmuch>

On Wed, Dec 06, 2023 at 08:39:07PM -0800, Dan Williams wrote:
> alison.schofield@ wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 

snip

> > +	struct json_object *jerrors, *jpoison, *jobj = NULL;
> > +	struct jlist_node *jnode, *next;
> > +	struct event_ctx ectx = {
> > +		.event_name = "cxl_poison",
> > +		.event_pid = getpid(),
> > +		.system = "cxl",
> > +	};
> > +	int rc, count = 0;
> > +
> > +	list_head_init(&ectx.jlist_head);
> > +	rc = cxl_parse_events(inst, &ectx);
> 
> This pattern really feels like it wants a cxl_for_each_event() -style
> helper rather than require the end caller to open code list usage.
> Basically cxl_parse_events() is a helper that should stay local to
> cxl/monitor.c. This new cxl_for_each_event() would become used
> internally by cxl_parse_events() and let
> util_cxl_poison_events_to_json() do its own per-event iteration.
> 

snip & concat'ing your next comment:

> So we're building a json_object internal to cxl_parse_events() only to
> turn around and extract details out of that object that tell us this
> event was not of interest, or to create yet another json object?
> 
> I think this implementation has a chance to be significantly less
> complicated if the event list can be iterated directly without this
> temporary json_object parsing.

DaveJ actually already implemented a method to include a 'private'
parsing function in the event_ctx structure. I didn't use it, but
but rather used the generic cxl_event_to_json helper, and then
parsed that all over again to refine for poison list output.

I think reorganizing w a private event_ctx->parse_event will
streamline as you suggest.

Alison
