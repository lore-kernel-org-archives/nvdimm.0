Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BAA38736F
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529445; cv=none; b=SgDuNoThvz2WGbomcuU7uGOL12+QIiPL0+mBieD78BA3c2dQcCEQIXiYw+DKFyvZ4vyRsxzd5vhGZdm6lM6q6/1uX4i3cQu/oE7kmwz3VH911VHmK95drX3akGXlplf65aoBF2yryTomYcFPk00v4lD/7rHCqkAF3IrV4kx/Pp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529445; c=relaxed/simple;
	bh=n4DApGBlS1c3NISduAouPH4YcExjkm0CRhua22eLWWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+0up2cOtJkAM765N9rUCfvgzy5ayX8TzZb6AjY/PTW3jxFmab9JmKs5rdu7E8HuNIAGfBiU8eMxMe953a5TW7BFO6BPunFLiXKnrQ/Ez0KGkCDk7ndEuZmYj1XmaWhW8WmGoRbtSuMcAUc8DRdn1ND3VdioX2rc28l5z8lE14I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNczXCPR; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNczXCPR"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1334825de43so7175041c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529443; x=1780134243; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qsDcrfyiYGHg2D0fltIuIiuRF5pesiJjHjMKkWGxFPI=;
        b=kNczXCPRRxTiVnbgQvetkr24TBVpeXcZGhkUWU1SLt5sreEePfRHFd20UojoYOQVTK
         vwF9mGk2CPHCKdJ4d2TUfQSZyWbYIYIRCwZOmCsfBJ/hpI8WUOX6/Cj3q0/LjMqeUt92
         zbMxEpx+IqaWEI891W4BJNB6/lz/Pg+1jtD9S/4SKb4q48VEJ8aKcCBtkH0cXJObRKWQ
         SULL4qnFWEiWkOCYFBgiByrmdHfsyICP+h1roNJZJaYGkPCjj2eHB+deDs5oq9rXpnYd
         E7JAwB7C3WNJN3gNEFRtq7VWzpzqpZZZPsuyAujVp3N1XypSEyTem4viElRm9kT5K6Xm
         xPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529443; x=1780134243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qsDcrfyiYGHg2D0fltIuIiuRF5pesiJjHjMKkWGxFPI=;
        b=hPCGmxjQVL/iYTiH1FnWDrqGwgUpVnozyQWpLxRxjj7B8zZFOWmZ+pWo7kOIFBPVlg
         kelK2oPDN4602pFZGuRAnywVReriEMCYVXNnmrann1bnBnwqm+JB8wbyZID7qLK6L/69
         j5Pil8q2FCTbMKoA5NESMzD8LzyclcVcsf1ICdQ1ePhgLoPdchocKYI1cn5/U+5vPTi8
         T5S8bplU9Q19ObbsP0o02xDgueG+1klHwXbcxEVxGnzssuuxFIXRWBu2xZu0agAH9f5x
         eKzInzYNcu8uUsOk7sUpYqgV7lyvU3ZV5696dFbaQDeeV/U8YYpMSIdAXa6PqWuokMDp
         fR3w==
X-Gm-Message-State: AOJu0YwUjhU4RS/KEIFrT9KeAbqTJaJFyQss79sVIOFBOrF60PbmMv/s
	w4uilk5YIXFJK73GmwsIrgNBiuE3aIGGdVJTXvXc1vnnhFitk1lC8evz
X-Gm-Gg: Acq92OHPOBT7H8ALt4wlMG/4M4c4Jm9u8OSOqrGz8T6ItELZwTws8MQp/1lEVjDYS3S
	lXqIL2fDYSZMFOPK7AslOBxILUy+AC3zz+ESgbksu6GnlcwYjuVvq1sihrWnXaAAjrJ5xEEgPlV
	+foywCA9lc9Dom2FhEkGqrRFYf3eKRiLRC0FhahT9qtU/FGffV7r90imd+xB4uo7EGK3P76KhF/
	Q8qRjJRJNmh8RjM3BcsgaRNABkp6YJEdHSE0BxvtLvATzNq/WwYA42FX95RJvzEcCTbLfGvR7kP
	p0uijHrREnU7enquUbbkCsbk5AmqZlYc0AICmLhTfHErUubUxX6WtsVM9wtNrQAYOhhTcUbKw+2
	Sqsat+PZ3D3kDJlX8mGVwfSgbKiPQ6lzzr/DsMEFJEXvR8O6I6ceOdEsokha3okJGYjavA0B7Lh
	a/gcDnHU86LyYqkGlnw/6Zf9t+lMwHWKWRAx+HMI5b3JYgcvLf1+Hgm1L3c4TlVsYfJEu+quJMi
	+/eyf7c1ZQvMXhhNg==
X-Received: by 2002:a05:7022:218:b0:12a:6a64:81ee with SMTP id a92af1059eb24-1365f5f2f3amr2607953c88.3.1779529442484;
        Sat, 23 May 2026 02:44:02 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:02 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v10 13/31] cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains
Date: Sat, 23 May 2026 02:43:07 -0700
Message-ID: <68caa60e758cb8ad5c9d0870cace911829ac965d.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A DC_ADD_CAPACITY event can span multiple event records grouped together
by the CXL_DCD_EVENT_MORE flag. Extents are staged in the pending list until
the last event record ('More'=0) is received, at which point the pending
list is processed. If the device opens such a chain (More=1) but never
sends the closing record, the staged list sits indefinitely.

Add a delayed-work watchdog that, on expiry, refuses the chain with an
empty ADD_DC_RESPONSE and drops the staged list.

The 20s timeout is a conservative upper bound and may be tightened
later. The timeout is purely defensive — the spec does not require it,
but prevents issues from a lost mailbox response or a crashed fabric manager.

Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 drivers/cxl/core/mbox.c | 73 ++++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxlmem.h    | 23 ++++++++++---
 2 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 1b38f34538f3..c376492fa166 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1219,6 +1219,48 @@ static void clear_pending_extents(void *_mds)
 	mds->add_ctx.group = NULL;
 }
 
+/*
+ * Bound on how long the host will wait for a device to finish a
+ * multi-record DC_ADD_CAPACITY chain (More=1 ... More=0) before
+ * refusing the chain.
+ * The timeout is not defined in the spec, but added for defensive purposes.
+ * Since there is no spec-defined timeout, 20s is chosen as a generous
+ * upper bound and matches the GPF timeout.
+ */
+#define CXL_DC_ADD_TIMEOUT	(20 * HZ)
+
+static void cxl_dc_add_timeout(struct work_struct *work)
+{
+	struct pending_add_ctx *ctx = container_of(to_delayed_work(work),
+						   struct pending_add_ctx,
+						   timeout_work);
+	struct cxl_memdev_state *mds = container_of(ctx,
+						    struct cxl_memdev_state,
+						    add_ctx);
+	struct device *dev = mds->cxlds.dev;
+
+	guard(mutex)(&ctx->lock);
+
+	if (!ctx->armed)
+		return;
+
+	dev_warn(dev, "DC add chain timed out; refusing staged extents\n");
+
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				 &ctx->pending_extents, 0))
+		dev_dbg(dev, "Failed to send empty ADD_DC_RESPONSE on timeout\n");
+
+	clear_pending_extents(mds);
+	ctx->armed = false;
+}
+
+static void cxl_cancel_dcd_add_chain_work(void *_mds)
+{
+	struct cxl_memdev_state *mds = _mds;
+
+	cancel_delayed_work_sync(&mds->add_ctx.timeout_work);
+}
+
 static int add_to_pending_list(struct list_head *pending_list,
 			       struct cxl_extent *to_add)
 {
@@ -1246,18 +1288,34 @@ static int add_to_pending_list(struct list_head *pending_list,
 static int handle_add_event(struct cxl_memdev_state *mds,
 			    struct cxl_event_dcd *event)
 {
+	struct pending_add_ctx *ctx = &mds->add_ctx;
 	struct device *dev = mds->cxlds.dev;
 	int rc;
 
-	rc = add_to_pending_list(&mds->add_ctx.pending_extents, &event->extent);
+	guard(mutex)(&ctx->lock);
+
+	rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
 	if (rc)
 		return rc;
 
 	if (event->flags & CXL_DCD_EVENT_MORE) {
 		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
+		mod_delayed_work(system_wq, &ctx->timeout_work,
+						 CXL_DC_ADD_TIMEOUT);
+		ctx->armed = true;
 		return 0;
 	}
 
+	/*
+	 * Chain is closing.  Disarm before flushing so a pending watchdog
+	 * (queued but blocked on @ctx->lock) sees !armed and bails out.
+	 * cancel_delayed_work() — not _sync — because handle_add_event()
+	 * itself runs on system_wq and a sync cancel of same-wq work can
+	 * deadlock.
+	 */
+	ctx->armed = false;
+	cancel_delayed_work(&ctx->timeout_work);
+
 	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
 				  &mds->add_ctx.pending_extents, 0);
 	clear_pending_extents(mds);
@@ -2009,11 +2067,24 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 
 	mutex_init(&mds->event.log_lock);
 	INIT_LIST_HEAD(&mds->add_ctx.pending_extents);
+	mutex_init(&mds->add_ctx.lock);
+	INIT_DELAYED_WORK(&mds->add_ctx.timeout_work,
+			  cxl_dc_add_timeout);
+	mds->add_ctx.armed = false;
 
 	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
 	if (rc)
 		return ERR_PTR(rc);
 
+	/*
+	 * Registered after clear_pending_extents so devm's reverse-order
+	 * unwind cancels (and waits for) the watchdog first, then the list
+	 * cleanup runs with the watchdog guaranteed not to refire.
+	 */
+	rc = devm_add_action_or_reset(dev, cxl_cancel_dcd_add_chain_work, mds);
+	if (rc)
+		return ERR_PTR(rc);
+
 	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
 	if (rc == -EOPNOTSUPP)
 		dev_warn(dev, "CXL MCE unsupported\n");
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 592c8e3b611c..d992cc9b7811 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -8,6 +8,8 @@
 #include <linux/uuid.h>
 #include <linux/node.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
 #include <cxl/event.h>
 #include <cxl/mailbox.h>
 #include "cxl.h"
@@ -402,19 +404,32 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
 
 /**
  * struct pending_add_ctx - Staging state for an in-progress
- *			    DCD_ADD_CAPACITY event chain
+ *							DCD_ADD_CAPACITY event chain
  * @pending_extents: extents received so far in the chain; flushed when
- *		     the chain closes (More=0)
+ *					 the chain closes (More=0)
  * @group: tag group being assembled from the chain
+ * @timeout_work: watchdog that fires if a chain is opened with
+ *				  CXL_DCD_EVENT_MORE but the closing record never arrives
+ * @lock: serialises updates to the chain state against the watchdog
+ * @armed: set when a More=1 chain opens; cleared when the chain closes,
+ *		   either by a More=0 event record or by the watchdog firing.
  *
  * A DCD_ADD_CAPACITY notification can span multiple event records
  * stitched together by the CXL_DCD_EVENT_MORE flag.  Records are staged
- * here until the device clears More, at which point the staged batch is
- * processed and responded to as a single Add_DC_Response.
+ * here until an event record with 'More'=0 is received, at which point the
+ * staged batch is processed and responded to as a single Add_DC_Response.
+ *
+ * If a chain is opened (More=1) but the device never sends the closing
+ * record, the staged list would otherwise sit indefinitely.  @timeout_work
+ * is a defensive watchdog that refuses such a chain with an empty response
+ * and drops the staged list.
  */
 struct pending_add_ctx {
 	struct list_head pending_extents;
 	struct cxl_dc_tag_group *group;
+	struct delayed_work timeout_work;
+	struct mutex lock;
+	bool armed;
 };
 
 /**
-- 
2.43.0

