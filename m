Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9D2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 20:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641501168; x=1673037168;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GXF6BJSarj3ahDGp46Juf8e1oH4VIlJSdGA4D7o3jG8=;
  b=XywdgwP2X6biamVdMLPf297smnkk6sY5Z29Khw76OJSBOCafpatcJy3J
   XulvQjbWca/0RUtI2Qxzs2Wwpmj3eQW1FArtQiruw9BhL/6qgaZ4zJJAA
   GvTFyogN1VgLtOHBhoyhffwkcPevLSGH0vviHoFdAaHk/r7mQK0rUgaZX
   D+Th5DuRtQtV5l2rHYa3HxE3pYh5ifPeAMii/YLg0DJjwXASOVWDqCziB
   Vg+VG2bAt4VQpVTw+MiCs79T3g2V1sne/IbVZs0FWJJ5AxpFerwHdvVOP
   FMjs9gAYhb9UG2bic55W1T/jiWzv6Oxx/r/QmqkYLgx6cvmD05xeZ/nd8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223421573"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="223421573"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:32:46 -0800
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="689536740"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 12:32:46 -0800
Date: Thu, 6 Jan 2022 12:32:46 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: alison.schofield@intel.com
Cc: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 0/7] Add partitioning support for CXL memdevs
Message-ID: <20220106203246.GB178135@iweiny-DESK2.sc.intel.com>
Mail-Followup-To: alison.schofield@intel.com,
	Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
References: <cover.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1641233076.git.alison.schofield@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Mon, Jan 03, 2022 at 12:16:11PM -0800, Schofield, Alison wrote:
> From: Alison Schofield <alison.schofield@intel.com>
 
First, thanks for taking this on!  :-D

> To support changing partitions on CXL memdevs, first provide access to device
> partitioning info.
>

How about:

Users will want to configure CXL memdevs on CXL devices which support
partitioning.  CXL provides get and set partition info mailbox command to do
this.

Add support to retrieve partition info and set partition info.

...

>
>
> The first 4 patches add accessors to all
> the partition info a CXL command parser needs in order to validate
> the command. This info is added to cxl list to assist the user in
> creating valid partition requests.

Great but what is a valid partition request?

> 
> # cxl list -MP
> [
>   {
>     "memdev":"mem0",
>     "pmem_size":0,
>     "ram_size":273535729664,
>     "partition":{
>       "active_volatile_capacity":273535729664,
>       "active_persistent_capacity":0,
>       "next_volatile_capacity":268435456,
>       "next_persistent_capacity":273267294208,
>       "total_capacity":273535729664,
>       "volatile_only_capacity":0,
>       "persistent_only_capacity":0,
>       "partition_alignment":268435456
>     }
>   }
> ]
> 
> Next introduce libcxl ioctl() interfaces for the SET_PARTITION_INFO
> mailbox command and the new CXL command. cxl-cli does the constraints
> checking. It does not offer the IMMEDIATE mode option since we do not
> have driver support for that yet.

How about something like 'cxl-cli restricts the use of the IMMEDIATE flag until
such time as the driver supports it'?

But we probably should just let the command through and rely on the driver to
do what it does...

> 
> # cxl set-partition-info
>  usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]
> 
>     -v, --verbose         turn on debug
>     -s, --volatile_size <n>
>                           next volatile partition size in bytes
> 
> Guessing that
  ^^^^^^^^^^^^^
  Delete

'A libcxl user can...'

>
> a libcxl user could send the SET_PARTITION_INFO mailbox
> command outside of cxl-cli tool, so a kernel patch that disables the
> immediate bit, on the receiving end of the ioctl, follows.

cool!

> 
> It may be simpler to block the immediate bit in the libcxl API today,
> (and as I write this cover letter I'm wondering just how far this goes
> astray ;)) However, the kernel patch to peek in the payload sets us on
> the path of inspecting set-partition-info mailbox commands in the future,
> when immediate mode support is required.

I'd just delete this.  I think it is best to leave the kernel to the
enforcement and not complicate the user space.

Ira

> 
> Testing - so far I've only tested w one memdev in a Simics env. So,
> next will be growing that Simics config, using cxl_test env, and 
> adding a unit test.
> 
> Alison Schofield (7):
>   libcxl: add GET_PARTITION_INFO mailbox command and accessors
>   libcxl: add accessors for capacity fields of the IDENTIFY command
>   libcxl: apply CXL_CAPACITY_MULTIPLIER to partition alignment field
>   cxl: add memdev partition information to cxl-list
>   libcxl: add interfaces for SET_PARTITION_INFO mailbox command
>   ndctl, util: use 'unsigned long long' type in OPT_U64 define
>   cxl: add command set-partition-info
> 
>  Documentation/cxl/cxl-list.txt               |  23 ++++
>  Documentation/cxl/cxl-set-partition-info.txt |  27 +++++
>  Documentation/cxl/partition-description.txt  |  15 +++
>  Documentation/cxl/partition-options.txt      |  19 +++
>  Documentation/cxl/Makefile.am                |   3 +-
>  cxl/builtin.h                                |   1 +
>  cxl/lib/private.h                            |  19 +++
>  cxl/libcxl.h                                 |  12 ++
>  util/json.h                                  |   1 +
>  util/parse-options.h                         |   2 +-
>  util/size.h                                  |   1 +
>  cxl/cxl.c                                    |   1 +
>  cxl/lib/libcxl.c                             | 117 ++++++++++++++++++-
>  cxl/lib/libcxl.sym                           |  11 ++
>  cxl/list.c                                   |   5 +
>  cxl/memdev.c                                 |  89 ++++++++++++++
>  util/json.c                                  | 112 ++++++++++++++++++
>  17 files changed, 455 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
>  create mode 100644 Documentation/cxl/partition-description.txt
>  create mode 100644 Documentation/cxl/partition-options.txt
> 
> -- 
> 2.31.1
> 
