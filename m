Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBB42CA5
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 01:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643678448; x=1675214448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ez1ylP5/sNE3AQI7W7ZP7EPQXvQjhhiANmtj/NRaI9c=;
  b=gUVsYczKq1rLfzLwnq91ftAr1q2LHgMFQ8vKzZ1N6/886eAqeYdQqdcP
   vN2O8ZH835GwdkIS89Zr5dbjDLuUodhGHsjBuE3lxveR6wB+SfbCc/EXe
   h20x5zWnXOItFMUX8iUbhfb7t46jimaWCWIMxNncjqV0viyUUO+dsfPk3
   2AX6ee2Huw+ouKRm5SlF1iCuxAd5iIRGDhSpI7Kn9X8kQwvpVhHUvZu/g
   k9H3ybBjeF3cBbBAO3zxpuASw90uDRbfdBfX9t3HJ7cy4FOU9Cu7hm+tT
   oz7mblJICJoSI5WfNJD9gc+a4zJc5m4iiDsAFtzS9cOHnh2imtaiR0CEl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247551666"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="247551666"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:20:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="482016312"
Received: from alison-desk.jf.intel.com (HELO alison-desk) ([10.54.74.41])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 17:20:48 -0800
Date: Mon, 31 Jan 2022 17:25:09 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH v3 5/6] libcxl: add interfaces for
 SET_PARTITION_INFO mailbox command
Message-ID: <20220201012509.GA913535@alison-desk>
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

Dan, One follow up below...

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
> > diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> > index 5b1fc32..5a5b189 100644
> > --- a/cxl/lib/libcxl.c
> > +++ b/cxl/lib/libcxl.c
> > @@ -1230,6 +1230,21 @@ cxl_cmd_partition_info_get_next_persistent_bytes(struct cxl_cmd *cmd)
> >         cmd_partition_get_capacity_field(cmd, next_persistent_cap);
> >  }
> >
> > +CXL_EXPORT struct cxl_cmd *cxl_cmd_new_set_partition_info(struct cxl_memdev *memdev,
> > +               unsigned long long volatile_capacity, int flags)
> > +{
> > +       struct cxl_cmd_set_partition_info *set_partition;
> > +       struct cxl_cmd *cmd;
> > +
> > +       cmd = cxl_cmd_new_generic(memdev,
> > +                       CXL_MEM_COMMAND_ID_SET_PARTITION_INFO);
> > +
> > +       set_partition = (struct cxl_cmd_set_partition_info *)cmd->send_cmd->in.payload;
> 
> ->in.payload is a 'void *', no casting required.
> 

send_cmd->in.payload is a __u64 so this cast is needed.

Of course, I wondered what Dan was thinking ;) and I see that struct
cxl_cmd's input_payload is indeed a 'void *'.

I believe this is the correct payload here, umm..  because it works ;)

But - let me know if you suspect something is off here.

Thanks!




snip
>
