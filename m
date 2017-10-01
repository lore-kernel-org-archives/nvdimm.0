Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6669E21F303EB
 for <linux-nvdimm@lists.01.org>; Sun,  1 Oct 2017 01:13:46 -0700 (PDT)
Date: Sun, 1 Oct 2017 10:17:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20171001081702.GC11895@lst.de>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard> <20170926093548.GB13627@quack2.suse.cz>
 <20170926110957.GR10955@dastard> <20170926143743.GB18758@lst.de>
 <20170926173057.GB20159@linux.intel.com>
 <20170927064001.GA27601@infradead.org>
 <20170927161510.GB24314@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170927161510.GB24314@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Dan Williams <dan.j.williams@intel.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 27, 2017 at 10:15:10AM -0600, Ross Zwisler wrote:
> Well, I don't know if platforms that support HMAT + PMEM are widely available,
> but we have all the details in the ACPI spec, so we could begin to code it up
> and things will "just work" when platforms arrive.

Then again currently all actually shipping NVDIMMs are battery backed
dram and DAX mode should work just fine for them.  Things will get
interesting once companies start shipping actually persistent technologies
that will be significantly slower than DRAM.  And we sould make sure
we have the infrastruture for that in place.

> Hum, I wonder if maybe we need/want three different mount modes?  What about:
> 
> autodax (the default): the filesystem is free to use DAX or not, as it sees
> fit and thinks is optimal.  For the time being we can make this mean "don't
> use DAX", and phase in DAX usage as we add support for the HMAT, etc.

What does "use DAX" really mean anyway?

I think we are conflating a few things:

 a) use a block device or use a dax_device for accessing the device
 b) use the pagecache for caching data in DRAM or not.

Now we actually have a really nice way to control a) already, it's
called O_DIRECT.  Currently O_DIRECT only works with read/write I/O,
but with a byte addressable scheme we now can implement it for mmap
as well, which is what the DAX mmap path does.

b) right now is implied by a), but it's really an implementation
detail.

So the modes would be more like two options to:

 a) disallow any byte-level access.  The right way to do that would
    be to mount the /dev/dax* device instead of the block device
    to allow byte access, and disallow any DAXish operation if you
    mount the block device in the long run.
 b) have a mode to always force an O_DIRECT-like mode for devices
    that are fast enough.  We should always do that with the right
    HMAT entries if mounting the /dev/dax devices, and maybe have
    a mount option to force it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
