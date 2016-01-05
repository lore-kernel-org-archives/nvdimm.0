Return-Path: <owner-linux-mm@kvack.org>
Date: Tue, 5 Jan 2016 10:41:01 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 2/7] dax: support dirty DAX entries in radix tree
Message-ID: <20160105094101.GB2724@quack.suse.cz>
References: <1450899560-26708-1-git-send-email-ross.zwisler@linux.intel.com>
 <1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450899560-26708-3-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, x86@kernel.org, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-12-15 12:39:15, Ross Zwisler wrote:
> Add support for tracking dirty DAX entries in the struct address_space
> radix tree.  This tree is already used for dirty page writeback, and it
> already supports the use of exceptional (non struct page*) entries.
> 
> In order to properly track dirty DAX pages we will insert new exceptional
> entries into the radix tree that represent dirty DAX PTE or PMD pages.
> These exceptional entries will also contain the writeback sectors for the
> PTE or PMD faults that we can use at fsync/msync time.
> 
> There are currently two types of exceptional entries (shmem and shadow)
> that can be placed into the radix tree, and this adds a third.  We rely on
> the fact that only one type of exceptional entry can be found in a given
> radix tree based on its usage.  This happens for free with DAX vs shmem but
> we explicitly prevent shadow entries from being added to radix trees for
> DAX mappings.
> 
> The only shadow entries that would be generated for DAX radix trees would
> be to track zero page mappings that were created for holes.  These pages
> would receive minimal benefit from having shadow entries, and the choice
> to have only one type of exceptional entry in a given radix tree makes the
> logic simpler both in clear_exceptional_entry() and in the rest of DAX.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

The patch looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
