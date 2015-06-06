Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sat, 6 Jun 2015 07:37:40 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v4 3/9] dax: drop size parameter to ->direct_access()
Message-ID: <20150606113739.GH2729@linux.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150605211918.20751.21557.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150605211918.20751.21557.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, linux-arch@vger.kernel.org, arnd@arndb.de, ross.zwisler@linux.intel.com, linux-nvdimm@lists.01.org, benh@kernel.crashing.org, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, hch@lst.de, tj@kernel.org, paulus@samba.org, hpa@zytor.com, schwidefsky@de.ibm.com, akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 05, 2015 at 05:19:18PM -0400, Dan Williams wrote:
> None of the implementations currently use it.  The common
> bdev_direct_access() entry point handles all the size checks before
> calling ->direct_access().

Interesting.  The reason it was still there, even after moving all
the size checks to bdev_direct_access() was to support the case of a
hypothetical future driver that exposed several discontiguous ranges as
a single block device.

But we don't actually need it for that, as long as the discontiguous
ranges are relatively large.  As the comment you deleted noted, the brd
driver could do this, but I certainly haven't taken the time to figure
out whether it'd be a performance win if the pages "just happen" to line
up right.

So I don't think I'm objecting to this patch (except that it conflicts
textually with my dynamic mapping patch that you've seen but hasn't been
posted publically yet).  Just something to think about.
