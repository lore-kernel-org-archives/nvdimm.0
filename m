Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5E5168
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643214804; x=1674750804;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p4MAtAySV+/cOqYZqDJI7JxuklTsTLp/8YkISCKNiSI=;
  b=QzN8s43WNOMxclvsD3S34DHPyhlmjfNYTDcSrqLjkaTnYSMiw8F52bWi
   fGLCQ+rMQyQZE7Zb0PFXK1v52s3j1fpuJrwAfPkY9hxWS49o61HS4tvAT
   ehfbIZtfSxCVmUJ8OrJUojb/zWklojSMhxH4JzRpHHo6jeWXvdeIS0qHT
   LJsKzF06ETJ7gluXl5J/1YeheXkK5ot6848NKi45YTE6Q1E2Itg0zh3Cx
   5K5OJP4NgurjDndQWNOfQW1ul7BkL4/OyRwWH/o3WW0cuUbpf5VpMUBOz
   ERbfRlvNrAORZTLwpr9UdZPT3H1bYhkobsRACuSZOG+30TeOuCA+RDPEU
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244188339"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244188339"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 08:33:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="628355956"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 08:33:23 -0800
Date: Wed, 26 Jan 2022 08:37:56 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
Message-ID: <20220126163756.GA887955@alison-desk>
References: <cover.1642535478.git.alison.schofield@intel.com>
 <2072a34022dabcc92e3cc73b16c8008656e1084e.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4jde6kd1oT2ZEoGWDiB1E6QX2pYzSHWr=38jtY6XB5ATA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jde6kd1oT2ZEoGWDiB1E6QX2pYzSHWr=38jtY6XB5ATA@mail.gmail.com>

On Wed, Jan 26, 2022 at 08:07:17AM -0800, Dan Williams wrote:
> On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
> >
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Users need access to the CXL GET_PARTITION_INFO mailbox command
> > to inspect and confirm changes to the partition layout of a memory
> > device.
> >
> > Add libcxl APIs to create a new GET_PARTITION_INFO mailbox command,
> > the command output data structure (privately), and accessor APIs to
> > return the different fields in the partition info output.
> >
> > Per the CXL 2.0 specification, devices report partition capacities
> > as multiples of 256MB. Define and use a capacity multiplier to
> > convert the raw data into bytes for user consumption. Use byte
> > format as the norm for all capacity values produced or consumed
> > using CXL Mailbox commands.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Looks good to me, you might want to also add a short note about the
> "cxl_cmd_new_get_partition_info()" API in the "=== MEMDEV: Commands"
> section of Documentation/cxl/lib/libcxl.txt that I started here:
> 
> https://lore.kernel.org/r/164298557771.3021641.14904324834528700206.stgit@dwillia2-desk3.amr.corp.intel.com

Will do.

> 
> Note that I'm not adding every single API there, but I think each
> cxl_cmd_new_<command_type>() API could use a short note.
> 
> That can be a follow on depending on whether Vishal merges this first
> or the topology enumeration series.

Vishal - I think this should follow the topology enumeration series
because it wants to use the cxl_filter_walk() that the topo series
introduces. (to spit out the updated partition info upon completion
of the set-partition-info cmd.)

So, a v4 posting will apply after topo series.

> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>




