Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B3240851
	for <nvdimm@lists.linux.dev>; Tue, 18 Jun 2024 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718725896; cv=none; b=BvTYD4bsg1Fi59dkNAOthuLTO9YDdxv/Tm7hWxXlP479saXYPqgp9+Y2QUq3+C5/mchh+Sck6O+y24z97rAA+QwnXdHTOF/iNw/TTZ8kqruElMZo8mjnOQARHgBviw+LAC8VDfscFs8X10dRnFUigxLTcANIkb7QDeB2PrUPgTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718725896; c=relaxed/simple;
	bh=FctRNyLMVCXApM+zZ0hjS0VrXYFC+wVXydecSREV5uo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jYjB5vRMiFbk2JQs05xoZRvYr3IdvTHxw+nTskRDGfr8x5AA6Wd7/XNa61Ju5dtEzQXqWs1ik6+BwPn0IyMzwq1wKGKFe7/PHRmbU561awuN7HzKLgmXFczObUEoApdNVXKJNqapx1wTreRbd+Dq+jxa8+XEO8cTvf+wUi5MizI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=WacNiq9z; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="WacNiq9z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1718725286;
	bh=FctRNyLMVCXApM+zZ0hjS0VrXYFC+wVXydecSREV5uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WacNiq9z+yhx9wZepGion63OStdao/cmKMlYCKm67HDIvEhchEczlFxFJ2tQQTwjU
	 h6PS+ZyBPgGmpw08s7aW1taZ9RIbDzGUgoOswYRsbapzcGJcwxaDN6qHb+zJ0oFWYA
	 2RI5cE30TiGkGQZEeBqKJR5vFwUZRgOdYH+zDGjGQLejuDOOJT5PkjmuTTvH75dHwu
	 qjsvd05m+ujXNlZ/GzCkHRrEUqU7uPA4TXi6MeKuhosWsrs6xnDi/XFiZou8g5w4Qo
	 ZhyqhYIGuN4g6EJ0hsFI0Kx/re1sbFzccoI03pfENXRQq1TUxYsPWErkC/gW7tbdIP
	 i7uV1nwBsFbOQ==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4W3WFK6N1Vz16w4;
	Tue, 18 Jun 2024 11:41:25 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 2/4] nvdimm/pmem: Flush to memory before machine restart
Date: Tue, 18 Jun 2024 11:41:55 -0400
Message-Id: <20240618154157.334602-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240618154157.334602-1-mathieu.desnoyers@efficios.com>
References: <20240618154157.334602-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register pre-restart notifiers to flush pmem areas from CPU data cache
to memory on reboot, immediately before restarting the machine. This
ensures all other CPUs are quiescent before the pmem data is flushed to
memory.

I did an earlier POC that flushed caches on panic/die oops notifiers [1],
but it did not cover the reboot case. I've been made aware that some
distribution vendors have started shipping their own modified version of
my earlier POC patch. This makes a strong argument for upstreaming this
work.

Use the newly introduced "pre-restart" notifiers to flush pmem data to
memory immediately before machine restart.

Delta from my POC patch [1]:

Looking at the panic() code, it invokes emergency_restart() to restart
the machine, which uses the new pre-restart notifiers. There is
therefore no need to hook into panic handlers explicitly.

Looking at the die notifiers, those don't actually end up triggering
a machine restart, so it does not appear to be relevant to flush pmem
to memory there. I must admit I originally looked at how ftrace hooked
into panic/die-oops handlers for its ring buffers, but the use-case it
different here: we only want to cover machine restart use-cases.

Link: https://lore.kernel.org/linux-kernel/f6067e3e-a2bc-483d-b214-6e3fe6691279@efficios.com/ [1]
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: nvdimm@lists.linux.dev
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/nvdimm/pmem.c | 29 ++++++++++++++++++++++++++++-
 drivers/nvdimm/pmem.h |  2 ++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 598fe2e89bda..bf1d187a9dca 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -26,12 +26,16 @@
 #include <linux/dax.h>
 #include <linux/nd.h>
 #include <linux/mm.h>
+#include <linux/reboot.h>
 #include <asm/cacheflush.h>
 #include "pmem.h"
 #include "btt.h"
 #include "pfn.h"
 #include "nd.h"
 
+static int pmem_pre_restart_handler(struct notifier_block *self,
+		unsigned long ev, void *unused);
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -423,6 +427,7 @@ static void pmem_release_disk(void *__pmem)
 {
 	struct pmem_device *pmem = __pmem;
 
+	unregister_pre_restart_notifier(&pmem->pre_restart_notifier);
 	dax_remove_host(pmem->disk);
 	kill_dax(pmem->dax_dev);
 	put_dax(pmem->dax_dev);
@@ -575,9 +580,14 @@ static int pmem_attach_disk(struct device *dev,
 			goto out_cleanup_dax;
 		dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	}
-	rc = device_add_disk(dev, disk, pmem_attribute_groups);
+	pmem->pre_restart_notifier.notifier_call = pmem_pre_restart_handler;
+	pmem->pre_restart_notifier.priority = 0;
+	rc = register_pre_restart_notifier(&pmem->pre_restart_notifier);
 	if (rc)
 		goto out_remove_host;
+	rc = device_add_disk(dev, disk, pmem_attribute_groups);
+	if (rc)
+		goto out_unregister_reboot;
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
@@ -589,6 +599,8 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "'badblocks' notification disabled\n");
 	return 0;
 
+out_unregister_pre_restart:
+	unregister_pre_restart_notifier(&pmem->pre_restart_notifier);
 out_remove_host:
 	dax_remove_host(pmem->disk);
 out_cleanup_dax:
@@ -751,6 +763,21 @@ static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 	}
 }
 
+/*
+ * For volatile memory use-cases where explicit flushing of the data cache is
+ * not useful after stores, the pmem reboot notifier is called on preparation
+ * for restart to make sure the content of the pmem memory area is flushed from
+ * data cache to memory, so it can be preserved across warm reboot.
+ */
+static int pmem_pre_restart_handler(struct notifier_block *self,
+		unsigned long ev, void *unused)
+{
+	struct pmem_device *pmem = container_of(self, struct pmem_device, pre_restart_notifier);
+
+	arch_wb_cache_pmem(pmem->virt_addr, pmem->size);
+	return NOTIFY_DONE;
+}
+
 MODULE_ALIAS("pmem");
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_IO);
 MODULE_ALIAS_ND_DEVICE(ND_DEVICE_NAMESPACE_PMEM);
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index 392b0b38acb9..b8a2a518cf82 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -4,6 +4,7 @@
 #include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
+#include <linux/notifier.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
 #include <linux/fs.h>
@@ -27,6 +28,7 @@ struct pmem_device {
 	struct dax_device	*dax_dev;
 	struct gendisk		*disk;
 	struct dev_pagemap	pgmap;
+	struct notifier_block	pre_restart_notifier;
 };
 
 long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
-- 
2.39.2

