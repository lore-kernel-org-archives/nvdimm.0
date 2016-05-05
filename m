Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E08C41A1F6D
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 01:03:51 -0700 (PDT)
Date: Thu, 5 May 2016 10:03:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 3/3] xfs: Add alignment check for DAX mount
Message-ID: <20160505080346.GB1970@quack2.suse.cz>
References: <1462214578-27122-1-git-send-email-toshi.kani@hpe.com>
 <1462214578-27122-4-git-send-email-toshi.kani@hpe.com>
 <20160504231855.GA26977@dastard>
 <1462405286.27137.88.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462405286.27137.88.camel@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

On Wed 04-05-16 17:41:26, Toshi Kani wrote:
> On Thu, 2016-05-05 at 09:18 +1000, Dave Chinner wrote:
> > On Mon, May 02, 2016 at 12:42:58PM -0600, Toshi Kani wrote:
> > > 
> :
> > Please write a helper along the lines of:
> > 
> > 	error = blkdev_supports_dax(sb->s_bdev, sb->s_blocksize);
> > 
> > and encapsulate all this, including the specific error messages in the
> > helper (i.e. "Block device %s does not support DAX."). Then the rest
> > of the filesystem code looks something like this:
> > 
> > 	if (mp->m_flags & XFS_MOUNT_DAX) {
> > 		error = blkdev_supports_dax(sb->s_bdev, sb->s_blocksize);
> > 		if (error) {
> > 			xfs_alert(mp,
> > 		"DAX unsupported by block device. Turning off DAX.");
> > 			mp->m_flags &= ~XFS_MOUNT_DAX;
> > 		}
> > 	}
> > 
> > And each filesystem can choose to do what it wants with the error
> > without having to care exactly why DAX is not supported.
> 
> Yes, I had this change in mind and was wondering if you are OK with it
> since I am incline to keep the ext2/4 message style as majority rule. :)
> https://lkml.org/lkml/2016/5/3/543
> 
> Assuming that's OK, I will make this change.

Yeah, just send me ext2 changes on top of your v2 and I can pull it to my
tree.


								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
