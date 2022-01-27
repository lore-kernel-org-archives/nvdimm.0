Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9341B2CA0
	for <nvdimm@lists.linux.dev>; Thu, 27 Jan 2022 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643316340; x=1674852340;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iW3AE0TXTvU4wk8QfsMipZ1jcNRQkRmBhEPy1lUEpyQ=;
  b=ZmdnGOfrefHcRWe8oAYqhJjx5SGSR1vWnHGPqT+Tc2uJAg9wvMKiwyML
   guUT2/TlZelfO1oZUt34L+VhvIAQxqRSTNkSAKBvqDSYwRv7ugz6HMydY
   ssVRYQ8+zOdPdNb/FLFCbFpLby9te1haHVDhhoQmeXxdESqyQ6Cupto8v
   PxzqgY0ma0R0X8WUtzkHYfZlC2LUjZVpj0CG0LyopIG8aFQAw/94eK6Ol
   tYLrgOvoMu7CKrsFXfPpkoQK5fsLI6dbOyOEMp1AzlCo7zjiePYBy0b/q
   m9xNFktn+OcrN01CQ/q86GytFeesVGb/8+8tKI8GNUEKWF+3x8+/K/aS0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="247181130"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="247181130"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 12:45:39 -0800
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="618467759"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 12:45:39 -0800
Date: Thu, 27 Jan 2022 12:50:09 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
Message-ID: <20220127205009.GA894403@alison-desk>
References: <cover.1642535478.git.alison.schofield@intel.com>
 <e98fa18538c42c40b120d5c22da655d199d0329d.1642535478.git.alison.schofield@intel.com>
 <CAPcyv4j4Nq1AAxH2CybQCH3pcBpCWgCsnY5i=OfKQXd_C_3xWA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4j4Nq1AAxH2CybQCH3pcBpCWgCsnY5i=OfKQXd_C_3xWA@mail.gmail.com>

Hi Dan,
Thanks for the review. I'm still working thru this, but a clarifying
question below...

On Wed, Jan 26, 2022 at 03:41:14PM -0800, Dan Williams wrote:
> On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
> >
> > From: Alison Schofield <alison.schofield@intel.com>
> >
> > Users may want the ability to change the partition layout of a CXL
> > memory device.
> >
> > Add interfaces to libcxl to allocate and send a SET_PARTITION_INFO
> > mailbox as defined in the CXL 2.0 specification.
> >
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > ---
> >  cxl/lib/libcxl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym |  5 +++++
> >  cxl/lib/private.h  |  8 ++++++++
> >  cxl/libcxl.h       |  5 +++++
> >  4 files changed, 68 insertions(+)
> >
snip
> 
> 
> I don't understand what this is for?
> 
> Let's back up. In order to future proof against spec changes, and
> endianness, struct packing and all other weird things that make struct
> ABIs hard to maintain compatibility the ndctl project adopts the
> libabc template of just not letting library consumers see any raw data
> structures or bit fields by default [1]. For a situation like this
> since the command only has one flag that affects the mode of operation
> I would just go ahead and define an enum for that explicitly.
> 
> enum cxl_setpartition_mode {
>     CXL_SETPART_NONE,
>     CXL_SETPART_NEXTBOOT,
>     CXL_SETPART_IMMEDIATE,
> };
> 
> Then the main function prototype becomes:
> 
> int cxl_cmd_new_setpartition(struct cxl_memdev *memdev, unsigned long
> long volatile_capacity);
> 
> ...with a new:
> 
> int cxl_cmd_setpartition_set_mode(struct cxl_cmd *cmd, enum
> cxl_setpartition_mode mode);
>

I don't understand setting of the mode separately. Can it be:

int cxl_cmd_new_setpartition(struct cxl_memdev *memdev,
			     unsigned long long volatile_capacity,
			     enum cxl_setpartition_mode mode);



> ...and it becomes impossible for users to pass unsupported flag
> values. If the specification later on adds more flags then we can add
> more:
> 
> int cxl_cmd_setpartition_set_<X>(struct cxl_cmd *cmd, enum
> cxl_setpartition_X x);
> 
> ...style helpers.
> 
> Note, I was thinking CXL_SETPART_NONE is there to catch API users that
> forget to set a mode, but I also don't mind skipping that and just
> defaulting cxl_cmd_new_setpartition() to CXL_SETPART_NEXTBOOT, up to
> you.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/kay/libabc.git/tree/README#n99
