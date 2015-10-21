Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: what's in nvdimm.git for v4.4?
Date: Wed, 21 Oct 2015 22:36:46 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295BDD2000@G9W0745.americas.hpqcorp.net>
References: <1445383903.6611.39.camel@intel.com>
 <20151021000103.GA19199@dastard>
 <CAPcyv4hBV=tsEmNajuMXr8Jj7-+ovT7FP3yWrfDLZVWejgA2ig@mail.gmail.com>
 <20151021090800.GA2939@quack.suse.cz>
In-Reply-To: <20151021090800.GA2939@quack.suse.cz>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Jan Kara
> Sent: Wednesday, October 21, 2015 4:08 AM
...
> On Tue 20-10-15 17:31:18, Dan Williams wrote:
> > On Tue, Oct 20, 2015 at 5:01 PM, Dave Chinner <david@fromorbit.com>
...
> > I'm wondering if we can take a conservative step forward with those
> > patches for 4.4.  if XFS and EXT4 interactions need more time to get
> > worked out, which I believe they do, I can conceive just turning on
> > get_user_pages() support for DAX-mappings of the raw block device.
> > This would be via the new facility I posted yesterday:
> > https://lists.01.org/pipermail/linux-nvdimm/2015-October/002512.html.
> > While not very functional for applications it makes testing base DAX
> > mechanisms straightforward.
> 
> I had a look at the patch and I miss one thing: Why do we need bd_mutex
> to protect faults? I see a comment there:
> 
> /* check that the faulting page hasn't raced with bdev resize */
> 
> Is it really possible that bdev gets shrunk under us? Hum, looking into
> fs/block_dev.c, probably it is. But there are other places - like DIO path
> - assuming that block device mapping cannot just disappear from under us.
> I wonder how that would cope with bdev size change...

DIO_IGNORE_TRUNCATE was added to eliminate an awful lot of CPU
time incrementing and decrementing i_dio_count for direct IO
to block devices, especially at pmem type speeds.  I hope 
that kind of accounting doesn't need to be brought back.

https://lkml.org/lkml/2015/4/3/557
https://lkml.org/lkml/2015/4/15/590

---
Robert Elliott, HPE Persistent Memory

