Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C845015A5
	for <nvdimm@lists.linux.dev>; Wed, 20 Sep 2023 05:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695188462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JPvYYcPhjWeV3sjsl+HTsL4s2pW0eDFFBqik8BbkWtM=;
	b=GgUbSOkg+/XQwUEaiiyvIGubqR01t+hfOgVjxmWsudFsfbILf/+rpg8mz32687qTCRtMfw
	wLacSzQDiw7M1uuj0o3wTfwa4jnJNY+t2VNEzxsVK0LZecFhp2Qigf1A3taX1lb7V+MDvp
	dRhMKQMO10t6mXT9sJHjlAtDKXSc50M=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-KFFniR2wPjyu-NwNfVMjzw-1; Wed, 20 Sep 2023 01:40:57 -0400
X-MC-Unique: KFFniR2wPjyu-NwNfVMjzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 398A61C05AA2;
	Wed, 20 Sep 2023 05:40:57 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.66])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A25F52156701;
	Wed, 20 Sep 2023 05:40:55 +0000 (UTC)
From: Tomas Glozar <tglozar@redhat.com>
To: nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	Tomas Glozar <tglozar@redhat.com>
Subject: [PATCH v2] nd_btt: Make BTT lanes preemptible
Date: Wed, 20 Sep 2023 07:37:12 +0200
Message-ID: <20230920053712.499439-1-tglozar@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6

nd_region_acquire_lane uses get_cpu, which disables preemption. This is
an issue on PREEMPT_RT kernels, since btt_write_pg and also
nd_region_acquire_lane itself take a spin lock, resulting in BUG:
sleeping function called from invalid context.

Fix the issue by replacing get_cpu with smp_process_id and
migrate_disable when needed. This makes BTT operations preemptible, thus
permitting the use of spin_lock.

BUG example occurring when running ndctl tests on PREEMPT_RT kernel:

BUG: sleeping function called from invalid context at
kernel/locking/spinlock_rt.c:48
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4903, name:
libndctl
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
Preemption disabled at:
[<ffffffffc1313db5>] nd_region_acquire_lane+0x15/0x90 [libnvdimm]
Call Trace:
 <TASK>
 dump_stack_lvl+0x8e/0xb0
 __might_resched+0x19b/0x250
 rt_spin_lock+0x4c/0x100
 ? btt_write_pg+0x2d7/0x500 [nd_btt]
 btt_write_pg+0x2d7/0x500 [nd_btt]
 ? local_clock_noinstr+0x9/0xc0
 btt_submit_bio+0x16d/0x270 [nd_btt]
 __submit_bio+0x48/0x80
 __submit_bio_noacct+0x7e/0x1e0
 submit_bio_wait+0x58/0xb0
 __blkdev_direct_IO_simple+0x107/0x240
 ? inode_set_ctime_current+0x51/0x110
 ? __pfx_submit_bio_wait_endio+0x10/0x10
 blkdev_write_iter+0x1d8/0x290
 vfs_write+0x237/0x330
 ...
 </TASK>

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
---
 drivers/nvdimm/region_devs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 0a81f87f6f6c..e2f1fb99707f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -939,7 +939,8 @@ unsigned int nd_region_acquire_lane(struct nd_region *nd_region)
 {
 	unsigned int cpu, lane;
 
-	cpu = get_cpu();
+	migrate_disable();
+	cpu = smp_processor_id();
 	if (nd_region->num_lanes < nr_cpu_ids) {
 		struct nd_percpu_lane *ndl_lock, *ndl_count;
 
@@ -958,16 +959,15 @@ EXPORT_SYMBOL(nd_region_acquire_lane);
 void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane)
 {
 	if (nd_region->num_lanes < nr_cpu_ids) {
-		unsigned int cpu = get_cpu();
+		unsigned int cpu = smp_processor_id();
 		struct nd_percpu_lane *ndl_lock, *ndl_count;
 
 		ndl_count = per_cpu_ptr(nd_region->lane, cpu);
 		ndl_lock = per_cpu_ptr(nd_region->lane, lane);
 		if (--ndl_count->count == 0)
 			spin_unlock(&ndl_lock->lock);
-		put_cpu();
 	}
-	put_cpu();
+	migrate_enable();
 }
 EXPORT_SYMBOL(nd_region_release_lane);
 
-- 
2.39.3

