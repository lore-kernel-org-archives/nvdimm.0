Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBC4421EC8CE7
 for <linux-nvdimm@lists.01.org>; Tue, 26 Sep 2017 11:46:56 -0700 (PDT)
Date: Tue, 26 Sep 2017 12:50:08 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170926185008.GA31146@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
 <20170925233812.GM10955@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925233812.GM10955@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 26, 2017 at 09:38:12AM +1000, Dave Chinner wrote:
> On Mon, Sep 25, 2017 at 05:13:58PM -0600, Ross Zwisler wrote:
> > Before support for the per-inode DAX flag was disabled the XFS the code had
> > an issue where the user couldn't reliably tell whether or not DAX was being
> > used to service page faults and I/O when the DAX mount option was used.  In
> > this case each inode within the mounted filesystem started with S_DAX set
> > due to the mount option, but it could be cleared if someone touched the
> > individual inode flag.
> > 
> > For example (v4.13 and before):
> > 
> >   # mount | grep dax
> >   /dev/pmem0 on /mnt type xfs
> >   (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)
> > 
> >   # touch /mnt/a /mnt/b   # both files currently use DAX
> > 
> >   # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
> >   ----------e----- /mnt/a
> >   ----------e----- /mnt/b
> > 
> >   # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a
> > 
> >   # xfs_io -c "lsattr" /mnt/*
> >   ----------e----- /mnt/a
> >   ----------e----- /mnt/b
> 
> That's really a bug in the lsattr code, yes? If we've cleared the
> S_DAX flag for the inode, then why is it being reported in lsattr?
> Or if we failed to clear the S_DAX flag in the 'chattr -x' call,
> then isn't that the bug that needs fixing?

No, I think lsattr/chattr are working correctly.  In both the examples above
the DAX inode flag (which is represeted by an 'x') is never set.  S_DAX is the
in-memory inode flag (not the on-media inode flag) which is not manipulated
directly by lsattr/chattr, but instead reflects whether the inode is actually
using DAX or not.

Manipulating and displaying the on-media inode flag works as expected with
lsattr/chattr:

  # xfs_io -c "lsattr" ./a 
  ---------------- ./a 
  
  # xfs_io -c "chattr +x" ./a 
  
  # xfs_io -c "lsattr" ./a 
  --------------x- ./a 

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
