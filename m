Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 20 Jun 2017 09:42:55 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Message-ID: <20170620154255.GA2536@linux.intel.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149766213493.22552.4057048843646200083.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170620052214.GA3787@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170620052214.GA3787@birch.djwong.org>
Sender: owner-linux-mm@kvack.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 19, 2017 at 10:22:14PM -0700, Darrick J. Wong wrote:
<>
> Fourth, the VFS entry points for things like read, write, truncate,
> utimes, fallocate, etc. all just bail out if S_IOMAP_FROZEN is set on a
> file, so that the block map cannot be modified.  mmap is still allowed,
> as we've discussed.  /Maybe/ we can allow fallocate to extend a file
> with zeroed extents (it will be slow) as I've heard murmurs about
> wanting to be able to extend a file, maybe not.

Read and write should still be allowed, right?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
