Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 23 Apr 2015 07:43:27 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
Message-ID: <20150423054327.GA28898@gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A8BE846@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8BE846@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, Robert Moore <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


* Elliott, Robert (Server Storage) <Elliott@hp.com> wrote:

> > -----Original Message-----
> > From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> > Dan Williams
> > Sent: Friday, April 17, 2015 8:35 PM
> > To: linux-nvdimm@lists.01.org
> > Subject: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
> > 
> ...
> >  create mode 100644 drivers/block/nd/acpi.c
> >  create mode 100644 drivers/block/nd/blk.c
> >  create mode 100644 drivers/block/nd/bus.c
> >  create mode 100644 drivers/block/nd/core.c
> ...
> 
> The kernel already has lots of files with these names:
>  5 acpi.c
> 10 bus.c
> 66 core.c
> 
> I often use ctags like this:
> 	vim -t core.c
> but that doesn’t immediately work with common filenames - it 
> presents a list of all 66 files to choose from.
> 
> Also, blk.c is a name one might expect to see in the block/ 
> directory (e.g., next to blk.h).
> 
> An nd_ prefix on all the filenames would help.

It's really stupid to duplicate information that is present in the 
pathname.

To type:

  vim -t nd/core.c

should be the same as:

  vim -t nd_core.c

Thanks,

	Ingo
