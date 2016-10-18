From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/20 v3] dax: Clear dirty bits after flushing caches
Date: Tue, 18 Oct 2016 11:49:31 +0200
Message-ID: <20161018094931.GM3359@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <20160930091418.GC24352@infradead.org>
 <20161003075902.GG6457@quack2.suse.cz>
 <20161003080337.GA13688@infradead.org>
 <20161003081549.GH6457@quack2.suse.cz>
 <20161003093248.GA27720@infradead.org>
 <20161003111358.GQ6457@quack2.suse.cz>
 <20161013203434.GD26922@linux.intel.com>
 <20161017084732.GD3359@quack2.suse.cz>
 <20161017185955.GA13782@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161017185955.GA13782@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Mon 17-10-16 12:59:55, Ross Zwisler wrote:
> On Mon, Oct 17, 2016 at 10:47:32AM +0200, Jan Kara wrote:
> 
> > This week I plan to rebase both series on top of rc1 + your THP patches so
> > that we can move on with merging the stuff.
> 
> Yea...so how are we going to coordinate merging of these series for the v4.10
> merge window?  My series mostly changes DAX, but it also changes XFS, ext2 and
> ext4.  I think the plan right now is to have Dave Chinner take it through his
> XFS tree.
> 
> Your first series is mostly mm changes with some DAX sprinkled in, and your
> second series touches dax, mm and all 3 DAX filesystems.  
> 
> What is the best way to handle all this?  Have it go through one central tree
> (-MM?), even though the changes touch code that exists outside of that trees
> normal domain (like the FS code)?  Have my series go through the XFS tree and
> yours through -MM, and give Linus a merge resolution patch?  Something else?

For your changes to go through XFS tree is IMO fine (changes outside of XFS
& DAX are easy). Let me do the rebase first and then discuss how to merge
my patches after that...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
