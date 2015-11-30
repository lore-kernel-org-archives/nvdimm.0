Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151125183736.12508.86178.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151125183656.12508.52212.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151125183736.12508.86178.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 30 Nov 2015 14:03:44 -0800
Message-ID: <CAPcyv4i6gvjzEEb0+ZdoRFGUDPXKj=_NLdyaZZi2pwXdyBUK9Q@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] mm, dax: unmap dax mappings at bdev shutdown
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 25, 2015 at 10:37 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Currently dax mappings leak past / survive block_device shutdown.  While
> page cache pages are permitted to be read/written after the block_device
> is torn down this is not acceptable in the dax case as all media access
> must end when the device is disabled.  The pfn backing a dax mapping is
> permitted to be invalidated after bdev shutdown and this is indeed the
> case with brd.
>
> When a dax capable block_device driver calls del_gendisk_queue() in its
> shutdown path it needs to ensure that all DAX pfns are unmapped, and
> that no new mappings can be established.  This is different than the
> pagecache backed case where the disk is protected by the queue being
> torn down which ends I/O to the device.  Since dax bypasses the page
> cache we need to unconditionally unmap the inode.
>
> Cc: Jan Kara <jack@suse.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> [honza: drop changes to truncate_inode_pages_final]
> [honza: ensure mappings can't be re-established]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Dave, can this patch move forward while we figure out ->shutdown() for
super_operations?
