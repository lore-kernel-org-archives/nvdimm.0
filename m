Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
Date: Wed, 22 Apr 2015 19:06:35 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A8BE846@G9W0745.americas.hpqcorp.net>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Ingo Molnar <mingo@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, Robert Moore <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dan Williams
> Sent: Friday, April 17, 2015 8:35 PM
> To: linux-nvdimm@lists.01.org
> Subject: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
> 
...
>  create mode 100644 drivers/block/nd/acpi.c
>  create mode 100644 drivers/block/nd/blk.c
>  create mode 100644 drivers/block/nd/bus.c
>  create mode 100644 drivers/block/nd/core.c
...

The kernel already has lots of files with these names:
 5 acpi.c
10 bus.c
66 core.c

I often use ctags like this:
	vim -t core.c
but that doesn�t immediately work with common filenames - it 
presents a list of all 66 files to choose from.

Also, blk.c is a name one might expect to see in the block/ 
directory (e.g., next to blk.h).

An nd_ prefix on all the filenames would help.

