Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CA4173
	for <nvdimm@lists.linux.dev>; Mon, 10 Jan 2022 21:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641850407; x=1673386407;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=brF3Tq3zcjUx/PTED0CDpHaBOQSHSlt3Gb1lZ7GTOvg=;
  b=E6sYQM/fdXnGIZYLsXq/HSKa0kD7079GFwzSb0uKT3pvtmpvvsdUILaw
   GlCRsDEfA1h2+PTVg7JggE0/buriQP/0nWBidRzbEHTw7v/bn2OIfj1py
   110YqUCx/qCFRWHE0JPsfPG1j7r1mw7tKIcMYyAN+6UyRCoThGB4ftXkE
   QnUpEIl1i41+Lg5A+cxZ6VdQHrnrSz2cS7ERUfCoaXUG1/i1eW4uebR7y
   XcOHiuQt7tmG8MC4o3DgV/xBiqztLkTNDVhY1ylvRTsi/+28ix7TWLoA5
   ZKnkBc8TXRa6bbua/iPKaa8WkG2tYy+oRzdXK7VN+JinotzP2y24laIuI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="230669185"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="230669185"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 13:31:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="669579275"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 13:31:57 -0800
Date: Mon, 10 Jan 2022 13:37:01 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
Message-ID: <20220110213701.GA817188@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
 <CAPcyv4gYjDo7vuFYqJgUL6mvOKosrzLRMxTA8tB0v86s08f_VA@mail.gmail.com>
 <20220107224515.GA804232@alison-desk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107224515.GA804232@alison-desk>

On Fri, Jan 07, 2022 at 02:45:15PM -0800, Alison Schofield wrote:
> On Thu, Jan 06, 2022 at 02:19:08PM -0800, Dan Williams wrote:
> > On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
> > >
> 
> snip
> 
> > 
> > One of the conventions from ndctl is that any command that modifies an
> > object should also emit the updated state of that object in JSON. For
> > example, "ndctl reconfigure-namespace" arranges for:
> > 
> >                 unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
> >                 struct json_object *jndns;
> > 
> >                 if (isatty(1))
> >                         flags |= UTIL_JSON_HUMAN;
> >                 jndns = util_namespace_to_json(ndns, flags);
> >                 if (jndns)
> >                         printf("%s\n", json_object_to_json_string_ext(jndns,
> >                                                 JSON_C_TO_STRING_PRETTY));
> > 
> > ...to dump the updated state of the namespace, so a similar
> > util_memdev_to_json() seems appropriate here. However, perhaps that
> > can come later. I have work-in-progress patches to move the core of
> > cxl/list.c to a cxl_filter_walk() helper that would allow you to just
> > call that to dump a listing for all the memdevs that were passed on
> > the command line.
> 
> Will add. Thanks!
Oops...should've said - 'Will wait for helper.'

