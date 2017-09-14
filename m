Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C65521E87979
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 23:54:45 -0700 (PDT)
Date: Thu, 14 Sep 2017 14:57:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v2] xfs: add regression test for DAX mount option
 usage
Message-ID: <20170914065741.GH8034@eguan.usersys.redhat.com>
References: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
 <20170911200103.28226-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170911200103.28226-1-ross.zwisler@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J.  Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Ross,

On Mon, Sep 11, 2017 at 02:01:03PM -0600, Ross Zwisler wrote:
> This adds a regression test for the following kernel patch:
> 
>   xfs: always use DAX if mount option is used
> 
> This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> DAX I/O mount option has been disabled (but not removed), so the
> "chattr -x" to turn off DAX doesn't actually do anything.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> ---
> 
> Changes since v1:
>  - Use perf instead of tracepoints to detect whether DAX is used. (Dan)

Thanks for the test! But I agreed with Dave here, it doesn't seem like a
good idea to depend on the kernel tracepoints in a test, but I can't
think of a better solution either, so I didn't get to this patch
earlier..

Before XFS disabled the ability to switch on & off per-inode DAX flag,
the x flag was only shown after an explicit 'chattr +x', even if XFS was
mounted with dax option, e.g.

# mkfs -t xfs -f /dev/ram0
# mount -o dax /dev/ram0 /mnt/xfs
# echo "test" > /mnt/xfs/testfile
# xfs_io -c "lsattr" /mnt/xfs/testfile
---------------- /mnt/xfs/testfile
# xfs_io -c "chattr +x" /mnt/xfs/testfile
# xfs_io -c "lsattr" /mnt/xfs/testfile
---------------x /mnt/xfs/testfile

I'm wondering if it makes sense to make lsattr print the x flag by
default when XFS is mounted with dax option, that way, we have a method
to know whether dax is used or not on a particular file too.

Thanks,
Eryu
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
