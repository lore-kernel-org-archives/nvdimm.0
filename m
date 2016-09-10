From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/9] ext2: tell DAX the size of allocation holes
Date: Sat, 10 Sep 2016 00:42:28 -0700
Message-ID: <20160910074228.GA23749@infradead.org>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
 <20160823220419.11717-3-ross.zwisler@linux.intel.com>
 <20160825075728.GA11235@infradead.org>
 <20160826212934.GA11265@linux.intel.com>
 <20160829074116.GA16491@infradead.org>
 <20160829125741.cdnbb2uaditcmnw2@thunk.org>
 <20160909164808.GC18554@linux.intel.com>
 <DM2PR21MB0089BCA980B67D8C53B25A1BCBFA0@DM2PR21MB0089.namprd21.prod.outlook.com>
 <20160910073012.GA5295@infradead.org>
 <DM2PR21MB0089FDEE0F0939010189EB99CBFD0@DM2PR21MB0089.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <DM2PR21MB0089FDEE0F0939010189EB99CBFD0@DM2PR21MB0089.namprd21.prod.outlook.com>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, Dave Chinner <david@fromorbit.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-Id: linux-nvdimm@lists.01.org

On Sat, Sep 10, 2016 at 07:33:18AM +0000, Matthew Wilcox wrote:
> > caller specific is unaceptable.  That being said your idea doesn't sounds
> > unreasonable, but will require a bit more work and has no real short-term
> > need.
> 
> So your proposal is to remove buffer_heads from ext2?

No, the proposal is to remove buffer_heads from XFS first, then GFS2
and then maybe others like ext4.  I'd like to remove buffer_heads from
the DAX path for ext2 and ext4 entitrely for sure (and direct I/O next).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
