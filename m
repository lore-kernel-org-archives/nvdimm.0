Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 21 Oct 2015 11:01:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: what's in nvdimm.git for v4.4?
Message-ID: <20151021000103.GA19199@dastard>
References: <1445383903.6611.39.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1445383903.6611.39.camel@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 20, 2015 at 11:31:45PM +0000, Williams, Dan J wrote:
> Here is a status summary of the topic-branches nvdimm.git is tracking
> for v4.4.  Unless indicated these branches are not present in -next.
> Please ACK, NAK, or ask for a re-post of any of the below to disposition
> it for the merge window.
> 
> ===
> for-4.4/dax-fixes:
> ===
...
>         Dave Chinner (5):
>               xfs: fix inode size update overflow in xfs_map_direct()
>               xfs: introduce BMAPI_ZERO for allocating zeroed extents
>               xfs: Don't use unwritten extents for DAX
>               xfs: DAX does not use IO completion callbacks
>               xfs: add ->pfn_mkwrite support for DAX

Please drop these. They have not been reviewed yet, and because
the changes affect more than just DAX (core XFS allocator
functionality was changed) these need to go through the XFS tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
