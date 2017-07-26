Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
 by ml01.01.org (Postfix) with ESMTP id 47F3121AEB0A0
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 02:21:10 -0700 (PDT)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site>
Date: Wed, 26 Jul 2017 18:23:08 +0900
In-Reply-To: <20170726082159.GE4039@linux-x5ow.site> (Johannes Thumshirn's
 message of "Wed, 26 Jul 2017 10:21:59 +0200")
Message-ID: <87d18neemb.fsf@devron>
MIME-Version: 1.0
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

"Kani, Toshimitsu" <toshi.kani@hpe.com> writes:

>  kernel BUG at fs/buffer.c:3305!
>  invalid opcode: 0000 [#1] SMP
>   :
>  Workqueue: writeback wb_workfn (flush-259:0)
>  task: ffff8d02595b8000 task.stack: ffffa22242400000
>  RIP: 0010:try_to_free_buffers+0xd2/0xe0
>  RSP: 0018:ffffa22242403830 EFLAGS: 00010246
>  RAX: 00afffc000001028 RBX: 0000000000000008 RCX: ffff8d012dcf19c0
>  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffc468e3b52b80
>  RBP: ffffa22242403858 R08: 0000000000000000 R09: 000000000002067c
>  R10: ffff8d027ffe6000 R11: 0000000000000000 R12: 0000000000000000
>  R13: ffff8d022fccdbe0 R14: ffffc468e3b52b80 R15: ffffa22242403ad0
>  FS:  0000000000000000(0000) GS:ffff8d027fd40000(0000)

The locking of this path seems to be broken. The guy familiar to
bdev_write_page() path will made real fix though, The following patch
should be explaining enough what is wrong.

In short, clean_buffers() must be called before unlocking lock_page().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/block_dev.c |    2 --
 fs/mpage.c     |    1 +
 mm/page_io.c   |    1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/mpage.c~bdev_write_page-fix fs/mpage.c
--- linux/fs/mpage.c~bdev_write_page-fix	2017-07-26 18:05:53.078204737 +0900
+++ linux-hirofumi/fs/mpage.c	2017-07-26 18:07:03.960043665 +0900
@@ -605,6 +605,7 @@ alloc_new:
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
 								page, wbc)) {
 				clean_buffers(page, first_unmapped);
+				unlock_page(page);
 				goto out;
 			}
 		}
diff -puN mm/page_io.c~bdev_write_page-fix mm/page_io.c
--- linux/mm/page_io.c~bdev_write_page-fix	2017-07-26 18:06:16.807150810 +0900
+++ linux-hirofumi/mm/page_io.c	2017-07-26 18:06:23.425135771 +0900
@@ -308,6 +308,7 @@ int __swap_writepage(struct page *page,
 
 	ret = bdev_write_page(sis->bdev, swap_page_sector(page), page, wbc);
 	if (!ret) {
+		unlock_page(page);
 		count_vm_event(PSWPOUT);
 		return 0;
 	}
diff -puN fs/block_dev.c~bdev_write_page-fix fs/block_dev.c
--- linux/fs/block_dev.c~bdev_write_page-fix	2017-07-26 18:08:53.490794861 +0900
+++ linux-hirofumi/fs/block_dev.c	2017-07-26 18:08:58.375783767 +0900
@@ -714,8 +714,6 @@ int bdev_write_page(struct block_device
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, true);
 	if (result)
 		end_page_writeback(page);
-	else
-		unlock_page(page);
 	blk_queue_exit(bdev->bd_queue);
 	return result;
 }
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
