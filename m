Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150617235452.12943.27817.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617235452.12943.27817.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 18 Jun 2015 12:25:37 -0700
Message-ID: <CAPcyv4jcc7oA5xZLB3Jh5bnvqiufjpxOCFH8_aOmBvA6vH3SWg@mail.gmail.com>
Subject: Re: [PATCH 01/15] block: introduce an ->rw_bytes() block device operation
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 17, 2015 at 4:54 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Why do we need a new method in block_device_operations?
>
> The capacities of persistent memory make it too large to map as RAM (no
> struct page coverage by default), so Linux arranges for it to be managed
> as a block device. The bio interface to a block device enforces sector
> at a time i/o and has infrastructure for asynchronous completion of i/o.
> The ->rw_page() interface is closely tied to the page cache and also
> carries asynchronous i/o completion assumptions.  NVDIMM devices are
> fast enough to complete i/o's synchronously (memcpy) and some in kernel
> applications can take advantage of the byte-aligned (as opposed to
> sector-aligned) nature of the media.  The ->rw_bytes() operation is
> added to fill this role that does not fit into any existing access
> method.
>
> It could be argued that a ->rw_bytes() method makes a struct
> block_device not a *block* device.  However, the applications for
> persistent memory as storage devices makes them more "block" devices
> than "character" devices.
>
> The first consumer of the ->rw_bytes() capability is a stacked
> block_device driver (BTT - block translation table) that adds atomic
> sector update semantics on top of an nvdimm storage device.
>
> Why enable drivers like BTT on top of a new globally visibly
> block_device_operations op rather than an internal detail of nvdimm
> drivers?
>
> 1/ We want ->rw_bytes() consumers to be enabled on either a per-disk or
> per-partition basis.  Consider the case of enabling DAX+XFS on a single
> persistent memory disk whereby the metadata needs atomic sector update
> guarantees, but the data would like to be DAX capable.  Solution is to
> create two partitions and enable BTT on the "metadata/XFS-logdev"
> partition.
>
> 2/ We want this configuration topology to be visible to the sysfs device
> model, and not an internal detail of nvdimm drivers requiring special
> tooling.  For example if you ever wanted to "fsck" BTT metadata that
> could be carried out on the raw nvdimm device directly rather than
> require custom tooling / mechanisms to access the raw media.
>
> 3/ It becomes trivial to add new BTT like drivers without touching the
> nvdimm drivers to add is_btt_mode(), is_foo_mode(), etc... checks in the
> fast path.
>

Acked-by: Jens Axboe <axboe@fb.com> ...off list.

Christoph, I assume that satisfies your primary concern with the BTT
infrastructure and implementation?
