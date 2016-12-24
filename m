From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: LTP rwtest01 blocks on DAX mountpoint
Date: Sat, 24 Dec 2016 19:07:14 +0800
Message-ID: <20161224110714.mp2mevzwkhlxm7zw@xzhoul.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nk323sgs75burrk2"
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: jack-AlSwsSmVLrQ@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


--nk323sgs75burrk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi lists,

Since around 20161129 tag, LTP rwtest01 on dax mountpoint blocks
on linux-next tree, now on Linus tree.

In "normal", rwtest01 subcase ends in a few minutes, now it keeps
running for hours on dax mountpoint, both ext4 and xfs. Ctrl + c
can interrupt it.

It is always reproducible, blocking following tests.

It does not happen when mounting without dax option.
It does not happen on v4.9.

Bisect point to:

commit 4b4bb46d00b386e1c972890dc5785a7966eaa9c0
Author: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Date:   Wed Dec 14 15:07:53 2016 -0800

    dax: clear dirty entry tags on cache flush


Reverting this commit on top of Linus tree "fixes" this issue.

Reproducer:

sh-4.2# cat rwt
rwtest01 export LTPROOT; rwtest -N rwtest01 -c -q -i 60s  -f sync 10%25000:$TMPDIR/rw-sync-$$
sh-4.2# 
mkfs.xfs /dev/pmem0p1
mount -o dax /dev/pmem0p1 /daxmnt && \
/opt/ltp/runltp -q -d /daxmnt -f rwt -p -b /dev/pmem0p2 -B xfs
umount /daxmnt

Bisect log is attached.

Thanks,
Xiong

--nk323sgs75burrk2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bisect2

git bisect start
# bad: [50f6584e4c626b8fa39edb66f33fec27bab3996c] Merge tag 'leds_for_4.10_email_update' of git://git.kernel.org/pub/scm/linux/kernel/git/j.anaszewski/linux-leds
git bisect bad 50f6584e4c626b8fa39edb66f33fec27bab3996c
# good: [69973b830859bc6529a7a0468ba0d80ee5117826] Linux 4.9
git bisect good 69973b830859bc6529a7a0468ba0d80ee5117826
# good: [5266e70335dac35c35b5ca9cea4251c1389d4a68] Merge tag 'tty-4.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 5266e70335dac35c35b5ca9cea4251c1389d4a68
# bad: [6df8b74b1720db1133ace0861cb6721bfe57819a] Merge tag 'devicetree-for-4.10' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
git bisect bad 6df8b74b1720db1133ace0861cb6721bfe57819a
# good: [f4000cd99750065d5177555c0a805c97174d1b9f] Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect good f4000cd99750065d5177555c0a805c97174d1b9f
# bad: [e1e14ab8411df344a17687821f8f78f0a1e73cbb] radix tree test suite: delete unused rcupdate.c
git bisect bad e1e14ab8411df344a17687821f8f78f0a1e73cbb
# good: [f5b893c947151d424a4ab55ea3a8544b81974b31] scsi: qla4xxx: switch to pci_alloc_irq_vectors
git bisect good f5b893c947151d424a4ab55ea3a8544b81974b31
# good: [b9f98bd4034a3196ff068eb0fa376c5f41077480] Merge tag 'mmc-v4.10-2' of git://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc
git bisect good b9f98bd4034a3196ff068eb0fa376c5f41077480
# good: [4d1f0fb096aedea7bb5489af93498a82e467c480] kernel/watchdog: use nmi registers snapshot in hardlockup handler
git bisect good 4d1f0fb096aedea7bb5489af93498a82e467c480
# good: [5b56d49fc31dbb0487e14ead790fc81ca9fb2c99] mm: add locked parameter to get_user_pages_remote()
git bisect good 5b56d49fc31dbb0487e14ead790fc81ca9fb2c99
# bad: [cfa40bcfd6fed7010b1633bf127ed8571d3b607e] radix tree test suite: benchmark for iterator
git bisect bad cfa40bcfd6fed7010b1633bf127ed8571d3b607e
# good: [a41b70d6dfc28b9e1a17c2a9f3181c2b614bfd54] mm: use vmf->page during WP faults
git bisect good a41b70d6dfc28b9e1a17c2a9f3181c2b614bfd54
# bad: [4b4bb46d00b386e1c972890dc5785a7966eaa9c0] dax: clear dirty entry tags on cache flush
git bisect bad 4b4bb46d00b386e1c972890dc5785a7966eaa9c0
# good: [a19e25536ed3a20845f642ce531e10c27fb2add5] mm: change return values of finish_mkwrite_fault()
git bisect good a19e25536ed3a20845f642ce531e10c27fb2add5
# good: [a6abc2c0e77b16480f4d2c1eb7925e5287ae1526] dax: make cache flushing protected by entry lock
git bisect good a6abc2c0e77b16480f4d2c1eb7925e5287ae1526
# good: [2f89dc12a25ddf995b9acd7b6543fe892e3473d6] dax: protect PTE modification on WP fault by radix tree entry lock
git bisect good 2f89dc12a25ddf995b9acd7b6543fe892e3473d6
# first bad commit: [4b4bb46d00b386e1c972890dc5785a7966eaa9c0] dax: clear dirty entry tags on cache flush

--nk323sgs75burrk2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--nk323sgs75burrk2--
