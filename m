Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62CA37104C;
	Thu, 26 Feb 2026 02:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772074672; cv=pass; b=krQsste0kkZsrHY3qb1Z55Nmhyxj0TsDaJ0bLShE4mmU3O8j0u+g/Luf6RuMYS5XKuxGXn0XbPCCqO2dmarZkU8TagJ8w5jL40/+Q1D7vy/VipTFSfDoDoQpes03OuGz62PgiFs72widG0u7by6+AOohBcfa5PyZOBoA5aoOPRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772074672; c=relaxed/simple;
	bh=O/LisHOxnvsb5Dqd5u8jcdfT+/3yN1d88jMC2Se/cfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1k/7qCHGeNXeguSutrxbkjowBqRCVWSJmnBmABc/zFp9Gn24W+wEnvdDQliV/KUTOF4CdQd2BQt+Hl9q6y2oPYGqv6jIMMk+AhtyqC03gAutfxKU5U/FHe34wDMeAICXVDtpNXbqs+g7AXbRnALnru1+H4Eh1HcnAYwlsXFkZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=tY+f45iX; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="tY+f45iX"
ARC-Seal: i=1; a=rsa-sha256; t=1772074661; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=O8M0QGr9gmlXX+Me3lzhusG/A0AdLs2mungSvq97ERHrZcJqhpwIZRBatnYwcQHZj7au5sgsJ5D/UfD/bfHiYBu97iof7u+j06Z5eXdgeSOY5KNLxnV6OpK/7pt8heFWVfqH+R1fybAZvgSxZgANi05+M9l0M6Y6hDwNvswTcLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772074661; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=lBU9qgcPvDyg8bOg8EfAruhG0zrehzJsYcTv4V658BY=; 
	b=db/sJUw/UBXzFcytzCCr5GBsD+e2mEsDGv9cmSjNXeZtgsD7JPCQN7IR6kpOp7/XtvKRSov6B7jLaIsYBLj33Oq/UrtNDQqlxCZy1p/CaOuQZFBojjrzTOg1N0FtNsFf02J5/yyhZ10NjBiDzBol0cMkqsDQHaxb9JyS1J9CcJI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772074661;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=lBU9qgcPvDyg8bOg8EfAruhG0zrehzJsYcTv4V658BY=;
	b=tY+f45iX4GAYSD4xX/WiyiR58IvYGxAEbQFdEEiC4RgS34RKdV75AsNW+mdoPo5x
	EYrq5IE1UxORGn09hNKBUc6mk3fZ+kQLDHEae9pIXj9ZPPE2iIPvXu1SkGjeiqubvc1
	w37WuE2hPh5mi+RA5cMDwe2A3aYs61SDQqPUrkkw=
Received: by mx.zohomail.com with SMTPS id 1772074658800313.4974609710948;
	Wed, 25 Feb 2026 18:57:38 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Cornelia Huck <cohuck@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Staron <jstaron@google.com>,
	virtualization@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Li Chen <me@linux.beauty>
Subject: [PATCH v3 3/5] nvdimm: virtio_pmem: refcount requests for token lifetime
Date: Thu, 26 Feb 2026 10:57:08 +0800
Message-ID: <20260226025712.2236279-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260226025712.2236279-1-me@linux.beauty>
References: <20260226025712.2236279-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

KASAN reports slab-use-after-free in __wake_up_common():
BUG: KASAN: slab-use-after-free in __wake_up_common+0x114/0x160
Read of size 8 at addr ffff88810fdcb710 by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
6.19.0-next-20260220-00006-g1eae5f204ec3 #4 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
1.17.0-2-2 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x6d/0xb0
 print_report+0x170/0x4e2
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __virt_addr_valid+0x1dc/0x380
 kasan_report+0xbc/0xf0
 ? __wake_up_common+0x114/0x160
 ? __wake_up_common+0x114/0x160
 __wake_up_common+0x114/0x160
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 __wake_up+0x36/0x60
 virtio_pmem_host_ack+0x11d/0x3b0
 ? sched_balance_domains+0x29f/0xb00
 ? __pfx_virtio_pmem_host_ack+0x10/0x10
 ? _raw_spin_lock_irqsave+0x98/0x100
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 vring_interrupt+0x1c9/0x5e0
 ? __pfx_vp_interrupt+0x10/0x10
 vp_vring_interrupt+0x87/0x100
 ? __pfx_vp_interrupt+0x10/0x10
 __handle_irq_event_percpu+0x17f/0x550
 ? __pfx__raw_spin_lock+0x10/0x10
 handle_irq_event+0xab/0x1c0
 handle_fasteoi_irq+0x276/0xae0
 __common_interrupt+0x65/0x130
 common_interrupt+0x78/0xa0
 </IRQ>

virtio_pmem_host_ack() wakes a request that has already been freed by the
submitter.

This happens when the request token is still reachable via the virtqueue,
but virtio_pmem_flush() returns and frees it.

Fix the token lifetime by refcounting struct virtio_pmem_request.
virtio_pmem_flush() holds a submitter reference, and the virtqueue holds an
extra reference once the request is queued. The completion path drops the
virtqueue reference, and the submitter drops its reference before
returning.

Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Cc: stable@vger.kernel.org
Signed-off-by: Li Chen <me@linux.beauty>
---
v2->v3:
- Add raw KASAN report to the patch description.

 drivers/nvdimm/nd_virtio.c   | 34 +++++++++++++++++++++++++++++-----
 drivers/nvdimm/virtio_pmem.h |  2 ++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index ada0c679cf2e..d0bf213d8caf 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -9,6 +9,14 @@
 #include "virtio_pmem.h"
 #include "nd.h"
 
+static void virtio_pmem_req_release(struct kref *kref)
+{
+	struct virtio_pmem_request *req;
+
+	req = container_of(kref, struct virtio_pmem_request, kref);
+	kfree(req);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -36,6 +44,7 @@ void virtio_pmem_host_ack(struct virtqueue *vq)
 		virtio_pmem_wake_one_waiter(vpmem);
 		WRITE_ONCE(req_data->done, true);
 		wake_up(&req_data->host_acked);
+		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 }
@@ -66,6 +75,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	if (!req_data)
 		return -ENOMEM;
 
+	kref_init(&req_data->kref);
 	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
@@ -83,10 +93,23 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	  * to req_list and wait for host_ack to wake us up when free
 	  * slots are available.
 	  */
-	while ((err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
-					GFP_ATOMIC)) == -ENOSPC) {
-
-		dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
+	for (;;) {
+		err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
+					GFP_ATOMIC);
+		if (!err) {
+			/*
+			 * Take the virtqueue reference while @pmem_lock is
+			 * held so completion cannot run concurrently.
+			 */
+			kref_get(&req_data->kref);
+			break;
+		}
+
+		if (err != -ENOSPC)
+			break;
+
+		dev_info_ratelimited(&vdev->dev,
+				     "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
 		WRITE_ONCE(req_data->wq_buf_avail, false);
 		list_add_tail(&req_data->list, &vpmem->req_list);
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -95,6 +118,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	}
+
 	err1 = virtqueue_kick(vpmem->req_vq);
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 	/*
@@ -110,7 +134,7 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-	kfree(req_data);
+	kref_put(&req_data->kref, virtio_pmem_req_release);
 	return err;
 };
 
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index f72cf17f9518..1017e498c9b4 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -12,11 +12,13 @@
 
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
+#include <linux/kref.h>
 #include <linux/libnvdimm.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 struct virtio_pmem_request {
+	struct kref kref;
 	struct virtio_pmem_req req;
 	struct virtio_pmem_resp resp;
 
-- 
2.52.0
