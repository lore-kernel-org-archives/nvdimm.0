Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail01.adl2.internode.on.net (ipmail01.adl2.internode.on.net
 [150.101.137.133])
 by ml01.01.org (Postfix) with ESMTP id B742020945BC4
 for <linux-nvdimm@lists.01.org>; Mon, 25 Sep 2017 17:20:07 -0700 (PDT)
Date: Tue, 26 Sep 2017 09:38:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: always use DAX if mount option is used
Message-ID: <20170925233812.GM10955@dastard>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
 <20170925231404.32723-2-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170925231404.32723-2-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 25, 2017 at 05:13:58PM -0600, Ross Zwisler wrote:
> Before support for the per-inode DAX flag was disabled the XFS the code had
> an issue where the user couldn't reliably tell whether or not DAX was being
> used to service page faults and I/O when the DAX mount option was used.  In
> this case each inode within the mounted filesystem started with S_DAX set
> due to the mount option, but it could be cleared if someone touched the
> individual inode flag.
> 
> For example (v4.13 and before):
> 
>   # mount | grep dax
>   /dev/pmem0 on /mnt type xfs
>   (rw,relatime,seclabel,attr2,dax,inode64,sunit=4096,swidth=4096,noquota)
> 
>   # touch /mnt/a /mnt/b   # both files currently use DAX
> 
>   # xfs_io -c "lsattr" /mnt/*  # neither has the DAX inode option set
>   ----------e----- /mnt/a
>   ----------e----- /mnt/b
> 
>   # xfs_io -c "chattr -x" /mnt/a  # this clears S_DAX for /mnt/a
> 
>   # xfs_io -c "lsattr" /mnt/*
>   ----------e----- /mnt/a
>   ----------e----- /mnt/b

That's really a bug in the lsattr code, yes? If we've cleared the
S_DAX flag for the inode, then why is it being reported in lsattr?
Or if we failed to clear the S_DAX flag in the 'chattr -x' call,
then isn't that the bug that needs fixing?

Remember, the whole point of the dax inode flag was to be able to
override the mount option setting so that admins could turn off/on
dax for the things that didn't/did work with DAX correctly so they
didn't need multiple filesystems on pmem to segregate the apps that
did/didn't work with DAX...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
