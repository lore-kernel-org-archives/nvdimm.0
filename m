Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433DB173
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641586983; x=1673122983;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=sFft1/EOmBMZw4fgNz9ww5b/Em9YHY9qTt5HGYs9I9Y=;
  b=VOpxMBWKKmwRG/1fNncfFSPbbD2yd10WENAQ4ZLEnCeC4vP5w1dDify5
   6rP+nkEs8I3OFthlbZfrNYqFst+ORoBNmWW1Sx8ws64Tlq6aS/aD6/Pll
   2eh43iUm7uOouSZOsnp8wmJtHus5b/wBxucgIZPTCxAg5LFqwCc52S+rh
   0kn31hYGQQih/N9oIrXn52SX6zxURLafx7oqhRJ9IYEnk25rsTuUqMAn1
   a6aecd9XsQmYxQPTOyc71mwEONmKKfU0QcpzSsHn6DGC5bEKa9P33q0IQ
   VRH3a0RH4EviUVqtkRObReSvxnvTOcezOwv9BlVARD16VcAT0+0+xBeqZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="230277998"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="230277998"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:20:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="527492991"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:20:27 -0800
Date: Fri, 7 Jan 2022 12:25:37 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 2/7] libcxl: add accessors for capacity fields of
 the IDENTIFY command
Message-ID: <20220107202537.GC803588@alison-desk>
References: <cover.1641233076.git.alison.schofield@intel.com>
 <577012d59f5b6b9754d2ce1147585ce5f91a3108.1641233076.git.alison.schofield@intel.com>
 <20220106203639.GC178135@iweiny-DESK2.sc.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106203639.GC178135@iweiny-DESK2.sc.intel.com>

On Thu, Jan 06, 2022 at 12:36:39PM -0800, Ira Weiny wrote:
> On Mon, Jan 03, 2022 at 12:16:13PM -0800, Schofield, Alison wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Add accessors to retrieve total capacity, volatile only capacity,
> > and persistent only capacity from the IDENTIFY mailbox command.
> > These values are useful when partitioning the device.
> 
> Reword:
> 
> The total capacity, volatile only capacity, and persistent only capacity are
> required to properly formulate a set partition info command.
> 
> Provide functions to retrieve these values from the IDENTIFY command.  Like the
> partition information commands these return the values in bytes.
> 

Will reword. Thanks.

> > 
> > +
> > +CXL_EXPORT unsigned long long
> > +cxl_cmd_identify_get_total_capacity(struct cxl_cmd *cmd)
> 
> Is there someplace that all the libcxl functions are documented?  Like the
> other functions I would like to ensure the user knows these are returning
> values in bytes.

There is a libcxl manpage, source at:
ndctl/Documentation/cxl/lib/libcxl.txt

Synopsis is:
#include <cxl/libcxl.h>
cc ... -lcxl

It describes how to use libcxl, ie alloc, submit, and get info back from
a command. I believe the intent is the user references cxl/libcxl.h to
find the accessors available. Along that line, it doesn't make any
sweeping statements about formats of data returned and I believe, based
on Dan's comments about the long descriptive names, that is by design.
ie. the name should say it all.

I'll rename these all to be _bytes instead of _capacity, as you
suggested in the prior patch.

> 
> Ira
> 
snip
> > +{
