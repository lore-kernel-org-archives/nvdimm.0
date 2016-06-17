From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] Initial support for badblock checking in xfs
Date: Thu, 16 Jun 2016 19:09:42 -0700
Message-ID: <20160617020942.GB11810@birch.djwong.org>
References: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466125419-17736-1-git-send-email-vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Jun 16, 2016 at 07:03:37PM -0600, Vishal Verma wrote:
> These are early/RFC patches to add badblock support in xfs.
> 
> Patch 1 should be relatively straightforward - it adds a notifier chain
> to badblocks that filesystems can register with.
> 
> Patch 2 is the beginnings of xfs support. So far, I have the notifier
> registration and building the initial badblock list happening in
> xfs_mountfs. The next steps (and I may need some help with this as I'm
> no (x)fs developer :)) are to add this badblocks info to the reverse
> mapping tree, and then to check for it before accessing the media.
> 
> Right now, this just prints the sector numbers/counts/{added, removed}
> to the kernel log, for both the initial list, and subsequent notifier
> hits.
> 
> While I've tested this with a fake pmem device using libnvdimm's
> nfit_test framework, it should also work using badblock injection with
> any block device:
> 
> # mkfs.xfs -f /dev/<device>
> # echo 122 1 > /sys/block/<device>/badblocks
> # echo 124 1 > /sys/block/<device>/badblocks
> # mount -t xfs /dev/<device> /mnt
> ... in log:
> [  +8.803776] XFS (pmem7): Mounting V4 Filesystem
> [  +0.009633] XFS (pmem7): Ending clean mount
> [  +0.001655] XFS (pmem7): got badblocks: sector 122, count 1
> [  +0.002018] XFS (pmem7): got badblocks: sector 124, count 1
> 
> # echo 132 5 | > /sys/block/<device>/badblocks
> [Jun16 18:56] XFS (pmem7): xfs badblock added sector 132 (count 5)
> 
> This is all based on Darrik's rmap work at:
> https://github.com/djwong/linux/tree/rmap-reflink-devel
> 
> Since this is based on a v4.5-rc kernel, it lacks pmem support for
> clearing badblocks on zeroing/writing, so those parts can't easily
> be tested yet. The clearing work is in 4.7-rs kernels, and once we
> rebase to that, that should also be available.

I'm assuming you got at least a few of the 300 patches I just sent.
IOW: The whole kit and kaboodle have been rebased to for-next, which
means the kernel patches are based on 4.7-rc3.

Will have a look at the other patches.

:)

--D

> 
> 
> Vishal Verma (2):
>   block, badblocks: add a notifier for badblocks
>   xfs: initial/partial support for badblocks
> 
>  block/badblocks.c         |  79 +++++++++++++++++++++++++++++++++--
>  fs/xfs/xfs_linux.h        |   1 +
>  fs/xfs/xfs_mount.c        | 104 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_mount.h        |   1 +
>  include/linux/badblocks.h |  19 +++++++++
>  5 files changed, 201 insertions(+), 3 deletions(-)
> 
> -- 
> 2.5.5
> 
> _______________________________________________
> xfs mailing list
> xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org
> http://oss.sgi.com/mailman/listinfo/xfs
