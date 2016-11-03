From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/11] ext4: Allow unaligned unlocked DAX IO
Date: Fri, 4 Nov 2016 00:55:44 +0100
Message-ID: <20161103235544.GG24234@quack2.suse.cz>
References: <1478034381-19037-1-git-send-email-jack@suse.cz>
 <1478034381-19037-3-git-send-email-jack@suse.cz>
 <20161102142746.GA18387@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161102142746.GA18387@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ted Tso <tytso@mit.edu>, linux-nvdimm@ml01.01.org
List-Id: linux-nvdimm@lists.01.org

On Wed 02-11-16 07:27:46, Christoph Hellwig wrote:
> On Tue, Nov 01, 2016 at 10:06:12PM +0100, Jan Kara wrote:
> > Currently we don't allow unaligned writes without inode_lock. This is
> > because zeroing of partial blocks could cause data corruption for racing
> > unaligned writes to the same block. However DAX handles zeroing during
> > block allocation and thus zeroing of partial blocks cannot race. Allow
> > DAX unaligned IO to run without inode_lock.
> 
> DAX writes should always take the inode lock.  Without that you break
> the expectations of existing applications that did not specify O_DIRECT.

Yeah, actually this patch has no practical effect since later iomap
conversion just effectively reverts this patch and I didn't realize it.
I'll just drop it. Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
