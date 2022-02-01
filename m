Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529D22CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643679030; x=1675215030;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x/+CVNmCg+20u6CXmLmUAEQmMIJnmCBAMGyTTrXHWjc=;
  b=DH5Y8eGdQanhyc7oQowjOFP41P9uxI8F1uFg50XNyKqnVlPUofHn308t
   vs3v7YWeleFJU42K57Az0K97FV6CE12jOG5LsEYbTCCTN7YeybLA7k5Gk
   OgHPuyl50geNZUILvJZt/eYvC5s+iw9um9lk/d2TbUaScU20pQ7Tuxn7i
   87Da9ZyF/n8Sj9rHidu6ChWtlyGebKqzna7G72ttehB79LksCxVUTWwzm
   Q0FRdUln5ghFHymhJN2mJ2FIjVz2T0crz1Jnf5EE0wSlfIpHPqExj1V4B
   jvNLfTP4KlWeJC8Ug9jsCH+Tpwm7CT3avgQRgk1+7wR9Lydv4TcPIoeVc
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="246435126"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="246435126"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:30:23 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="522880714"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:30:23 -0800
Date: Mon, 31 Jan 2022 17:34:45 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
Message-ID: <20220201013445.GA913958@alison-desk>
References: <cover.1642535478.git.alison.schofield@intel.com>
 <e98fa18538c42c40b120d5c22da655d199d0329d.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4j4Nq1AAxH2CybQCH3pcBpCWgCsnY5i=OfKQXd_C_3xWA@mail.gmail.com>
 <20220127205009.GA894403@alison-desk>
 <CAPcyv4h5+sMSKh-seNbmmTVuNzs5-8FTWUoYHw=LWtSrSNq1=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h5+sMSKh-seNbmmTVuNzs5-8FTWUoYHw=LWtSrSNq1=g@mail.gmail.com>

> > snip
> > >
> > >
> > > I don't understand what this is for?
> > >
> > > Let's back up. In order to future proof against spec changes, and
> > > endianness, struct packing and all other weird things that make struct
> > > ABIs hard to maintain compatibility the ndctl project adopts the
> > > libabc template of just not letting library consumers see any raw data
> > > structures or bit fields by default [1]. For a situation like this
> > > since the command only has one flag that affects the mode of operation
> > > I would just go ahead and define an enum for that explicitly.
> > >
> > > enum cxl_setpartition_mode {
> > >     CXL_SETPART_NONE,
> > >     CXL_SETPART_NEXTBOOT,
> > >     CXL_SETPART_IMMEDIATE,
> > > };
> > >
> > > Then the main function prototype becomes:
> > >
> > > int cxl_cmd_new_setpartition(struct cxl_memdev *memdev, unsigned long
> > > long volatile_capacity);
> > >
> > > ...with a new:
> > >
> > > int cxl_cmd_setpartition_set_mode(struct cxl_cmd *cmd, enum
> > > cxl_setpartition_mode mode);
> > >
> >
> > I don't understand setting of the mode separately. Can it be:
> >
> > int cxl_cmd_new_setpartition(struct cxl_memdev *memdev,
> >                              unsigned long long volatile_capacity,
> >                              enum cxl_setpartition_mode mode);
> 
> It could be, but what happens when the specification defines a new
> flag for this command? Then we would have cxl_cmd_new_setpartition()
> and cxl_cmd_new_setpartition2()  to add the new parameters. A helper
> function after establishing the cxl_cmd context lets you have
> flexibility to extend the base command by as many new flags and modes
> that come along... hopefully none, but you never know.

Got it. Doing the 'new' followed by 'mode' set up you suggested.
(Sorry, I didn't update this thread after our offline chat.)
