Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A8BE846@G9W0745.americas.hpqcorp.net>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B40295A8BE846@G9W0745.americas.hpqcorp.net>
Date: Wed, 22 Apr 2015 12:39:19 -0700
Message-ID: <CAPcyv4ioeSdQZVQ7PczAOPqs5zCoWLbs+WG-mZgrBWsBZspeDQ@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, "Moore, Robert" <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 22, 2015 at 12:06 PM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
>> -----Original Message-----
>> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
>> Dan Williams
>> Sent: Friday, April 17, 2015 8:35 PM
>> To: linux-nvdimm@lists.01.org
>> Subject: [Linux-nvdimm] [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
>>
> ...
>>  create mode 100644 drivers/block/nd/acpi.c
>>  create mode 100644 drivers/block/nd/blk.c
>>  create mode 100644 drivers/block/nd/bus.c
>>  create mode 100644 drivers/block/nd/core.c
> ...
>
> The kernel already has lots of files with these names:
>  5 acpi.c
> 10 bus.c
> 66 core.c
>
> I often use ctags like this:
>         vim -t core.c
> but that doesn’t immediately work with common filenames - it
> presents a list of all 66 files to choose from.
>
> Also, blk.c is a name one might expect to see in the block/
> directory (e.g., next to blk.h).
>
> An nd_ prefix on all the filenames would help.
>

I picked up the "don't duplicate the directory name in the source file
name" approach from a review comment from Linus on a SCSI driver a
long time back (iirc).  I'm not motivated to stop that practice now.
