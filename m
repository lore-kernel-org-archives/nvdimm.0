Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 069E020958BFF
 for <linux-nvdimm@lists.01.org>; Sat, 16 Sep 2017 15:23:34 -0700 (PDT)
Date: Sun, 17 Sep 2017 08:26:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [fstests PATCH v2] xfs: add regression test for DAX mount option
 usage
Message-ID: <20170916222633.GA17782@dastard>
References: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
 <20170911200103.28226-1-ross.zwisler@linux.intel.com>
 <20170914065741.GH8034@eguan.usersys.redhat.com>
 <20170915224227.GA9020@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170915224227.GA9020@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, "Darrick J.  Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 15, 2017 at 04:42:27PM -0600, Ross Zwisler wrote:
> On Thu, Sep 14, 2017 at 02:57:41PM +0800, Eryu Guan wrote:
> > Hi Ross,
> > 
> > On Mon, Sep 11, 2017 at 02:01:03PM -0600, Ross Zwisler wrote:
> > > This adds a regression test for the following kernel patch:
> > > 
> > >   xfs: always use DAX if mount option is used
> > > 
> > > This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> > > DAX I/O mount option has been disabled (but not removed), so the
> > > "chattr -x" to turn off DAX doesn't actually do anything.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > > ---
> > > 
> > > Changes since v1:
> > >  - Use perf instead of tracepoints to detect whether DAX is used. (Dan)
> > 
> > Thanks for the test! But I agreed with Dave here, it doesn't seem like a
> > good idea to depend on the kernel tracepoints in a test, but I can't
> > think of a better solution either, so I didn't get to this patch
> > earlier..
> > 
> > Before XFS disabled the ability to switch on & off per-inode DAX flag,
> > the x flag was only shown after an explicit 'chattr +x', even if XFS was
> > mounted with dax option, e.g.

Of course. lsattr reports the *on-disk inode flag state*. It does
not report whether the file is using that feature or not, just
whether the flag is set on disk.

Remember, lsattr does not report a "sum of all config states for a
feature".  It reports on disk state and on disk state only. It
follows the same semantics as other flags that have equivalent mount
options like dirsync, sync, noatime, etc.

> > # mkfs -t xfs -f /dev/ram0
> > # mount -o dax /dev/ram0 /mnt/xfs
> > # echo "test" > /mnt/xfs/testfile
> > # xfs_io -c "lsattr" /mnt/xfs/testfile
> > ---------------- /mnt/xfs/testfile
> > # xfs_io -c "chattr +x" /mnt/xfs/testfile
> > # xfs_io -c "lsattr" /mnt/xfs/testfile
> > ---------------x /mnt/xfs/testfile
> 
> XFS actually still works this way, you just don't get dax now when you chattr
> +x. :-/  But the inode flag is actually still there, gets updated by chattr
> and can be listed with lsattr.
> 
> Actually, that feels like a really bad situation to be in - Christoph & Dave,
> should we do more to remove the flag as long as it's not working?  i.e. remove
> it from the lsattr output and make "chattr +x" fail with -EINVAL or similar?

How about we concentrate on fixing the problem that led us to
disable it temporarily in XFS? Then it can be re-enabled and
problems like this go away...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
