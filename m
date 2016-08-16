Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 6A7E61A1DF4
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 15:52:39 -0700 (PDT)
Date: Tue, 16 Aug 2016 16:52:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] ext2: tell DAX the size of allocation holes
Message-ID: <20160816225227.GA632@linux.intel.com>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <20160815190918.20672-2-ross.zwisler@linux.intel.com>
 <20160816091025.GA27284@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160816091025.GA27284@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 16, 2016 at 11:10:25AM +0200, Jan Kara wrote:
> On Mon 15-08-16 13:09:12, Ross Zwisler wrote:
> > When DAX calls ext2_get_block() and the file offset points to a hole we
> > currently don't set bh_result->b_size.  When we re-enable PMD faults DAX
> > will need bh_result->b_size to tell it the size of the hole so it can
> > decide whether to fault in a 4 KiB zero page or a 2 MiB zero page.
> > 
> > For ext2 we always want DAX to use 4 KiB zero pages, so we just tell DAX
> > that all holes are 4 KiB in size.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > ---
> >  fs/ext2/inode.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> > index d5c7d09..c6d9763 100644
> > --- a/fs/ext2/inode.c
> > +++ b/fs/ext2/inode.c
> > @@ -773,6 +773,12 @@ int ext2_get_block(struct inode *inode, sector_t iblock, struct buffer_head *bh_
> >  	if (ret > 0) {
> >  		bh_result->b_size = (ret << inode->i_blkbits);
> >  		ret = 0;
> > +	} else if (ret == 0 && IS_DAX(inode)) {
> 
> I'd just drop the IS_DAX() check and set
> 
> 	bh_result->b_size = 1 << inode->i_blkbits;
> 
> IMO it's better to have things consistent between DAX & !DAX whenever
> possible.

Agreed, this is better.  Fixed for v2, thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
