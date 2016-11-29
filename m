Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 29 Nov 2016 15:17:57 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Message-ID: <20161129221757.GA16608@linux.intel.com>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
 <1479980796-26161-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479980796-26161-3-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Johannes Weiner <hannes@cmpxchg.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 10:46:32AM +0100, Jan Kara wrote:
> Currently invalidate_inode_pages2_range() and invalidate_mapping_pages()
> just delete all exceptional radix tree entries they find. For DAX this
> is not desirable as we track cache dirtiness in these entries and when
> they are evicted, we may not flush caches although it is necessary. This
> can for example manifest when we write to the same block both via mmap
> and via write(2) (to different offsets) and fsync(2) then does not
> properly flush CPU caches when modification via write(2) was the last
> one.
> 
> Create appropriate DAX functions to handle invalidation of DAX entries
> for invalidate_inode_pages2_range() and invalidate_mapping_pages() and
> wire them up into the corresponding mm functions.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

For the DAX bits:
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
