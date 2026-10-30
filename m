Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336829;
	b=HAX8L+hvrUAWdqC0jyRmOivndmj3/dB9CQmRpd6tKgnJMbQ/usn+3GIvjArO8ZiTrkU5
	 yH6dx0vci9HSzxwYY3yv1krpdOguSb/V/pi4+UDRzNj04MA3zGUtEB5LJDyoS4OPKfxwJ
	 He5J3HjFzpDSQCmZK9MQ4ev/w2XCLNQETsVQ07ZkpYN8K0hgEgWTh3fI519z7a2qAWyA1
	 nQ+nCCxn/hXt1304aUfaARk9lxMmHT9tKjOorbgsk5nlNSlFge0TDJ/0t4q4Ky9tStr+U
	 cSISOrvbARQBv4BvxGtWS7D1h6JP4uaDqFGwA+8mMKOlj/fPk2m2PhehlIruzo5SSDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336829;
	h=DMARC-Filter:DKIM-Signature:Subject:Message-Id:X-Mailer:
	 X-Original-From:To:Cc:X-Lms-Return-Path:From:Mime-Version:
	 Content-Transfer-Encoding:Date:Content-Type;
	bh=jcSNaYPCn1WimfE35qeXbxFRPwK5oBQwa8QLonR06aQ=;
	b=1T1RdyZAZjOD/7IBMVSqct6S5BbHWRUbq2uKzmSS9AmGrOP39OhUZ0iJeuOACZfJdUaS
	 sRI+DvtG7Oaelh7HUh+NBO6CshFNdQJD1te+nwji14jY6juCQL1pAdVhBPIhRZCjewtyQ
	 PpGSD8gyMq/xG4JcZYbo3YPQlnCgrSHDUM1PObKGP9DqQ6WnZoW3OlKQwmd0YjptCSA/X
	 InWUCKEzVMuGOMNJl03cUCCVXixQSpf1wSXzNJN6yB1UHwA4Ig8RpswXafrxR6hPIpN8q
	 qa0sFgltjfbfzXb+bVE0W0xaux/NwJ1NpQGY50JeAIXDhAll7f/lOkzPIN4Nf2Zx2CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=M82WyujV;
	arc=none smtp.remote-ip=209.127.231.112
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E3B606A31E
	for <nvdimm@lists.linux.dev>; Fri, 30 Oct 2026 05:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90E3B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=M82WyujV
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793336822; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=jcSNaYPCn1WimfE35qeXbxFRPwK5oBQwa8QLonR06aQ=;
 b=M82WyujVrJ6StQUSgav+FYXzwM/696Zolg7xuox1J80rDIjSLtE0o3eAISwe7SQ2F8+mmv
 xZEN17aLOKSc8PL9kYNiTIPjAdWv9tfGfiGind/lXgonO3OPdrua991SRSXQG4/xwLKPmR
 T6HBavVmy2UiPB/bo4VB8/HZGAcVkt9S40JdPbD+QmL50ylAUzOVbSFAJN1O2BIW6Rcu5d
 Sz0CvmwOj1X/X+AcwcZVEmmFgfmjT17I+P7ZeZGl59Lp3exfhVGYxB6ziJbnKwoKoyG8Mw
 yyZyzKeu4v98LPvjSpPw62C8aKdKFc48i90b0n9M2Mx7bt1NOTTW2FKURRz1KA==
Subject: [PATCH] dax/bus: avoid deadlock when reading mapping attributes
Message-Id: <20261030050639.3462-2-weiguixiong@bytedance.com>
X-Mailer: git-send-email 2.55.0
X-Original-From: Guixiong Wei <weiguixiong@bytedance.com>
To: "Dan Williams" <djbw@kernel.org>
Cc: "Vishal Verma" <vishal.l.verma@intel.com>, 
	"Dave Jiang" <dave.jiang@intel.com>, 
	"Alison Schofield" <alison.schofield@intel.com>, 
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, 
	"Guixiong Wei" <weiguixiong@bytedance.com>, <stable@vger.kernel.org>
X-Lms-Return-Path: <lba+26ae425f4+22c98e+lists.linux.dev+weiguixiong@bytedance.com>
From: "Guixiong Wei" <weiguixiong@bytedance.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Oct 2026 13:06:40 +0800
Content-Type: text/plain; charset=UTF-8

Reading a mapping's start, end, or page_offset attribute takes
dax_region_rwsem while holding a kernfs active reference. When
size_store() shrinks a device, it holds the rwsem while unregistering
mappings. Unregistration waits in kernfs_drain() for active references
to be released, so a concurrent attribute read can deadlock:

  Reader                         size_store()
  kernfs_get_active()
                                 down_write(dax_region_rwsem)
                                 device_unregister(mapping)
                                 kernfs_drain()
  down_write(dax_region_rwsem)

Setting range_id to -1 before unregistering does not break the cycle
because get_dax_range() checks it only after acquiring the rwsem.

Use down_write_trylock() and restart the read on contention. Returning
from the show callback allows kernfs to drop the active reference, so
mapping unregistration can finish. Keep active protection throughout
the callback to preserve the existing teardown synchronization.

The same inversion existed with the region device lock before it was
replaced by dax_region_rwsem, so the problem dates back to the
introduction of mapping devices.

Fixes: 0b07ce872a9e ("device-dax: introduce 'mapping' devices")
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
---
 drivers/dax/bus.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index e40c25401cf06..823d60353fc83 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -3,6 +3,7 @@
 #include <linux/memremap.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/sched/signal.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
@@ -719,14 +720,17 @@ static struct dev_dax_range *get_dax_range(struct device *dev)
 {
 	struct dax_mapping *mapping = to_dax_mapping(dev);
 	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
-	int rc;
 
-	rc = down_write_killable(&dax_region_rwsem);
-	if (rc)
-		return NULL;
+	/*
+	 * Mapping removal drains this attribute with dax_region_rwsem held.
+	 * Restart the read on contention to release the kernfs active
+	 * reference without waiting for the rwsem.
+	 */
+	if (!down_write_trylock(&dax_region_rwsem))
+		return ERR_PTR(restart_syscall());
 	if (mapping->range_id < 0) {
 		up_write(&dax_region_rwsem);
-		return NULL;
+		return ERR_PTR(-ENXIO);
 	}
 
 	return &dev_dax->ranges[mapping->range_id];
@@ -744,8 +748,8 @@ static ssize_t start_show(struct device *dev,
 	ssize_t rc;
 
 	dax_range = get_dax_range(dev);
-	if (!dax_range)
-		return -ENXIO;
+	if (IS_ERR(dax_range))
+		return PTR_ERR(dax_range);
 	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.start);
 	put_dax_range();
 
@@ -760,8 +764,8 @@ static ssize_t end_show(struct device *dev,
 	ssize_t rc;
 
 	dax_range = get_dax_range(dev);
-	if (!dax_range)
-		return -ENXIO;
+	if (IS_ERR(dax_range))
+		return PTR_ERR(dax_range);
 	rc = sysfs_emit(buf, "%#llx\n", dax_range->range.end);
 	put_dax_range();
 
@@ -776,8 +780,8 @@ static ssize_t pgoff_show(struct device *dev,
 	ssize_t rc;
 
 	dax_range = get_dax_range(dev);
-	if (!dax_range)
-		return -ENXIO;
+	if (IS_ERR(dax_range))
+		return PTR_ERR(dax_range);
 	rc = sysfs_emit(buf, "%#lx\n", dax_range->pgoff);
 	put_dax_range();
 
-- 
2.55.0
