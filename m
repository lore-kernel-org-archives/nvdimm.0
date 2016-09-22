From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/9] ext4: allow DAX writeback for hole punch
Date: Thu, 22 Sep 2016 11:51:03 -0400
Message-ID: <20160922155103.xqxdxum3rq7i4sqa@thunk.org>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-2-ross.zwisler@linux.intel.com>
 <20160921152244.GB10516@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160921152244.GB10516@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@ml01.01.org, Matthew Wilcox <mawilcox@microsoft.com>, stable@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Wed, Sep 21, 2016 at 09:22:44AM -0600, Ross Zwisler wrote:
> 
> Ted & Jan,
> 
> I'm still working on the latest version of the PMD work which integrates with
> the new struct iomap faults.  At this point it doesn't look like I'm going to
> make v4.9, but I think that this bug fix at least should probably go in alone?

Thanks, applied.

						- Ted

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
