Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 29 Jan 2016 12:24:08 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] block: use DAX for partition table reads
Message-ID: <20160129192408.GD5224@linux.intel.com>
References: <20160129151835.18752.9423.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160129151846.18752.48460.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@fb.com, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 29, 2016 at 07:18:46AM -0800, Dan Williams wrote:
> Avoid populating pagecache when the block device is in DAX mode.
> Otherwise these page cache entries collide with the fsync/msync
> implementation and break data durability guarantees.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This solves the problem for me, thanks!

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
