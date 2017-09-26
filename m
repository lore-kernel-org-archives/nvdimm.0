Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145])
 by ml01.01.org (Postfix) with ESMTP id EB5CC21F322B5
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 14:57:48 -0700 (PDT)
Date: Wed, 27 Sep 2017 08:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926220056.GA3666@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
 <20170926093548.GB13627@quack2.suse.cz>
 <20170926110957.GR10955@dastard> <20170926143743.GB18758@lst.de>
 <20170926173057.GB20159@linux.intel.com>
 <20170926194830.GI5020@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170926194830.GI5020@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 12:48:30PM -0700, Darrick J. Wong wrote:
> For the most part I'm in favor of Christoph's suggestion to let the
> kernel decide on its own, and I don't see the point in encoding details
> of the storage medium access strategy on the disk, particularly since
> filesystems are supposed to be fairly independent of storage.  But
> frankly, so many people have asked me over the years if there's some way
> to influence the decision-making that I won't quite let go of file hints
> as a way to influence the decisions XFS makes around storage media.

And that's pretty much it. The discussion here is not about whether
there should be a flag, but what semantics it should have when the
flag is not set. If "flag not set" means "kernel selects
automatically", then that's fine by me.

But history tells us that users and admins want a way to be able to
override the kernel's automatic behaviours because they are /never
100% correct/ for everyone. There are always exceptions, otherwise
we wouldn't have the great plethora of mkfs, mount, proc and sysfs
options for our filesystems or storage. Anyone who says "the kernel
will always do the right thing for everyone automatically" is living
in a dream world.

Note: I agree that the kernel should do the right thing w.r.t. DAX
automatically. We don't need a mount option for that - we can probe
for dax support automatically and use it automatically already.
However, in a world where the kernel automatically uses that
functionality when it is present, admins and users need a way to
solve the "default behaviour is bad for me, let me control this
manually" problem. That's where the inode flags come in....

i.e. What I'm advocating is a model DAX gets enabled automatically
if the underlying device supports is using whatever the kernel
thinks is optimal at the time the access is made, but the user can
override/direct behvaiour on a case by case basis via persistent
inode flags/xattrs/whatever.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
