Return-Path: <owner-linux-mm@kvack.org>
Date: Sat, 17 Jun 2017 07:22:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 1/2] mm: introduce bmap_walk()
Message-ID: <20170617052212.GA8246@lst.de>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com> <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 16, 2017 at 06:15:29PM -0700, Dan Williams wrote:
> Refactor the core of generic_swapfile_activate() into bmap_walk() so
> that it can be used by a new daxfile_activate() helper (to be added).

No way in hell!  generic_swapfile_activate needs to day and no new users
of ->bmap over my dead body.  It's a guaranteed to fuck up your data left,
right and center.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
