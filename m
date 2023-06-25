Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D327F
	for <nvdimm@lists.linux.dev>; Sun, 25 Jun 2023 01:54:30 +0000 (UTC)
Received: from mail02.huawei.com (unknown [172.30.67.143])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QpYth4nDRz4f3v5P
	for <nvdimm@lists.linux.dev>; Sun, 25 Jun 2023 09:54:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgA30JNJnpdkw_XiMQ--.23029S4;
	Sun, 25 Jun 2023 09:54:19 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux-foundation.org,
	houtao1@huawei.com
Subject: [PATCH v3] virtio_pmem: add the missing REQ_OP_WRITE for flush bio
Date: Sun, 25 Jun 2023 10:26:33 +0800
Message-Id: <20230625022633.2753877-1-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <ZJL3+E5P+Yw5jDKy@infradead.org>
References: <ZJL3+E5P+Yw5jDKy@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA30JNJnpdkw_XiMQ--.23029S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1xZw1UKF4xWw17JFW8Zwb_yoW5Xr13pr
	90kayaqr47GF4I9anFya12gFyfX3WDGrZrKFWfuw4fZFZrAF1DGw1vgFyFqa4DGrW8Gaya
	yFWkJr1jqryUZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
	c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
	CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
	MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
	Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBI
	daVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected

From: Hou Tao <houtao1@huawei.com>

When doing mkfs.xfs on a pmem device, the following warning was
reported and :

 ------------[ cut here ]------------
 WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct
 Modules linked in:
 CPU: 2 PID: 384 Comm: mkfs.xfs Not tainted 6.4.0-rc7+ #154
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 RIP: 0010:submit_bio_noacct+0x340/0x520
 ......
 Call Trace:
  <TASK>
  ? asm_exc_invalid_op+0x1b/0x20
  ? submit_bio_noacct+0x340/0x520
  ? submit_bio_noacct+0xd5/0x520
  submit_bio+0x37/0x60
  async_pmem_flush+0x79/0xa0
  nvdimm_flush+0x17/0x40
  pmem_submit_bio+0x370/0x390
  __submit_bio+0xbc/0x190
  submit_bio_noacct_nocheck+0x14d/0x370
  submit_bio_noacct+0x1ef/0x520
  submit_bio+0x55/0x60
  submit_bio_wait+0x5a/0xc0
  blkdev_issue_flush+0x44/0x60

The root cause is that submit_bio_noacct() needs bio_op() is either
WRITE or ZONE_APPEND for flush bio and async_pmem_flush() doesn't assign
REQ_OP_WRITE when allocating flush bio, so submit_bio_noacct just fail
the flush bio.

Simply fix it by adding the missing REQ_OP_WRITE for flush bio. And we
could fix the flush order issue and do flush optimization later.

Fixes: b4a6bb3a67aa ("block: add a sanity check for non-write flush/fua bios")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v3:
 * adjust the overly long lines in both commit message and code

v2: https://lore.kernel.org/linux-block/20230621134340.878461-1-houtao@huaweicloud.com
 * do a minimal fix first (Suggested by Christoph)

v1: https://lore.kernel.org/linux-block/ZJLpYMC8FgtZ0k2k@infradead.org/T/#t

Hi Jens & Dan,

I found Pankaj was working on the optimization of virtio-pmem flush bio
[0], but considering the last status update was 1/12/2022, so could you
please pick the patch up for v6.4 and we can do the flush optimization
later ?

[0]: https://lore.kernel.org/lkml/20220111161937.56272-1-pankaj.gupta.linux@gmail.com/T/

 drivers/nvdimm/nd_virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c6a648fd8744..1f8c667c6f1e 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -105,7 +105,8 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 	 * parent bio. Otherwise directly call nd_region flush.
 	 */
 	if (bio && bio->bi_iter.bi_sector != -1) {
-		struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
+		struct bio *child = bio_alloc(bio->bi_bdev, 0,
+					      REQ_OP_WRITE | REQ_PREFLUSH,
 					      GFP_ATOMIC);
 
 		if (!child)
-- 
2.29.2

