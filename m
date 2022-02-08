Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2642F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 20:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644352951; x=1675888951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6Hbe7SCFFi7aOilBmY9Td8U0nHyoptevwpwaEl6teRU=;
  b=mBMa64DQydoAkJ623i5pnE2JxBeIORwNBSWGToKahHj7Vq6Q/2fJqTlE
   99bSjXCmlykd7PZn8/y7NDvYWPCTJ47kXr08ckrmtTZ9BsdvnZYk6DPpU
   pvFCEby3Bh7I3D10xkjoIGU5tGB6gvW+IwLt1I3JDuxRoTcbUJlUjQgH6
   e+VLKtKNGNEtLAR33Eheec8Sq53A0qYQzn+3kuPgfvZOK3WCSlVjHb08m
   by+68d2pbfPT2Cjl+9V+c7SicmA7BDrKsw1TTPUeSHp3gVZVUA5Zl7iFU
   My8HWV7sA5SXwEVHxHM1671Jam2zDYq55EzArNnbQ1EHVGm7zNNqa0Gz/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="229019993"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="229019993"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 12:42:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="601370783"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 12:42:30 -0800
Date: Tue, 8 Feb 2022 12:46:36 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v4 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
Message-ID: <20220208204636.GA950445@alison-desk>
References: <cover.1644271559.git.alison.schofield@intel.com>
 <396ccc39525b3eb829acd4e06f704f6fb57a94a8.1644271559.git.alison.schofield@intel.com>
 <CAPcyv4gYbLGkd99fvKixAmLAhpkfQU8gNJ0e0BHrmVUZ3wWA_A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gYbLGkd99fvKixAmLAhpkfQU8gNJ0e0BHrmVUZ3wWA_A@mail.gmail.com>

Thanks Dan! Got it all.
<eom>

On Tue, Feb 08, 2022 at 12:20:56PM -0800, Dan Williams wrote:
> On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
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
> > ---
> >  Documentation/cxl/lib/libcxl.txt |  1 +
> >  cxl/lib/libcxl.c                 | 57 ++++++++++++++++++++++++++++++++
> >  cxl/lib/libcxl.sym               |  5 +++
> >  cxl/lib/private.h                | 10 ++++++
> >  cxl/libcxl.h                     |  5 +++
> >  util/size.h                      |  1 +
> >  6 files changed, 79 insertions(+)
> >
> > diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> > index 4392b47..a6986ab 100644
> > --- a/Documentation/cxl/lib/libcxl.txt
> > +++ b/Documentation/cxl/lib/libcxl.txt
> > @@ -131,6 +131,7 @@ int cxl_memdev_read_label(struct cxl_memdev *memdev, void *buf, size_t length,
> >                           size_t offset);
> >  int cxl_memdev_write_label(struct cxl_memdev *memdev, void *buf, size_t length,
> >                            size_t offset);
> > +struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev);
> >
> >  ----
> >
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index e0b443f..33cf06b 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1985,6 +1985,12 @@ static int cxl_cmd_validate_status(struct cxl_cmd *cmd, u32 id)
> >         return 0;
> >  }
> >
> > +static unsigned long long
> > +capacity_to_bytes(unsigned long long size)
> 
> If this helper converts an encoded le64 to bytes then the function
> signature should reflect that:
> 
> static uint64_t cxl_capacity_to_bytes(leint64_t size)
> 
> > +{
> > +       return le64_to_cpu(size) * CXL_CAPACITY_MULTIPLIER;
> > +}
> > +
> >  /* Helpers for health_info fields (no endian conversion) */
> >  #define cmd_get_field_u8(cmd, n, N, field)                             \
> >  do {                                                                   \
> > @@ -2371,6 +2377,57 @@ CXL_EXPORT ssize_t cxl_cmd_read_label_get_payload(struct cxl_cmd *cmd,
> >         return length;
> >  }
> >
> > +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_get_partition(struct cxl_memdev *memdev)
> > +{
> > +       return cxl_cmd_new_generic(memdev,
> > +                                  CXL_MEM_COMMAND_ID_GET_PARTITION_INFO);
> > +}
> > +
> > +static struct cxl_cmd_get_partition *
> > +cmd_to_get_partition(struct cxl_cmd *cmd)
> > +{
> 
> This could also check for cmd == NULL just to be complete.
> 
> > +       if (cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_GET_PARTITION_INFO))
> > +               return NULL;
> > +
> > +       return cmd->output_payload;
> > +}
> > +
> > +CXL_EXPORT unsigned long long
> > +cxl_cmd_partition_get_active_volatile_size(struct cxl_cmd *cmd)
> > +{
> > +       struct cxl_cmd_get_partition *c;
> > +
> > +       c = cmd_to_get_partition(cmd);
> > +       return c ? capacity_to_bytes(c->active_volatile) : ULLONG_MAX;
> 
> I'd prefer kernel coding style which wants:
> 
> if (!c)
>     return ULLONG_MAX;
> return cxl_capacity_to_bytes(c->active_volatile);
> 
> Otherwise, looks good to me:
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
