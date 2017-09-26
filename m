Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D889121EC8CE2
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 10:27:45 -0700 (PDT)
Date: Tue, 26 Sep 2017 11:30:57 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926173057.GB20159@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
 <20170926093548.GB13627@quack2.suse.cz>
 <20170926110957.GR10955@dastard> <20170926143743.GB18758@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170926143743.GB18758@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 04:37:43PM +0200, Christoph Hellwig wrote:
> On Tue, Sep 26, 2017 at 09:09:57PM +1000, Dave Chinner wrote:
> > Well, quite frankly, I never wanted the mount option for XFS. It was
> > supposed to be for initial testing only, then we'd /always/ use the
> > the inode flags. For a filesystem to default to using DAX, we
> > set the DAX flag on the root inode at mkfs time, and then everything
> > inode flag based just works.
> 
> And I deeply fundamentally disagree.  The mount option is a nice
> enough big hammer to try a mode without encoding nitty gritty details
> into the application ABI.
> 
> The per-inode persistent flag is the biggest nightmare ever, as we see
> in all these discussions about it.
> 
> What does it even mean?  Right now it forces direct addressing as long
> as the underlying media supports that.  But what about media that
> you directly access but you really don't want to because it's really slow?
> Or media that is so god damn fast that you never want to buffer?  Or
> media where you want to buffer for writes (or at least some of them)
> but not for reads?
> 
> It encodes a very specific mechanism for an early direct access
> implementation into the ABI.  What we really need is for applications
> to declare an intent, not specify a particular mechanism.

I agree that Christoph's idea about having the system intelligently adjust to
use DAX based on performance information it gathers about the underlying
persistent memory (probably via the HMAT on x86_64 systems) is interesting,
but I think we're still a ways away from that.

FWIW, as my patches suggest and Jan observed I think that we should allow
users to turn on DAX by treating the inode flag and the mount flag as an 'or'
operation.  i.e. you get DAX if either the mount option is specified or if the
inode flag is set, and you can continue to manipulate the per-inode flag as
you want regardless of the mount option.  I think this provides maximum
flexibility of the mechanism to select DAX without enforcing policy.

In the end, though, I think what's really important is that we figure out what
the various options mean, have the same story for both XFS and ext4, and
document it as hch suggested in response to my patch 7 in this series.

Does it make sense at this point to just start a "dax" man page that can
contain info about the mount options, inode flags, kernel config options, how
to get PMDs, etc?  Or does this documentation need to be sprinkled around more
in existing man pages?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
