Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F2F3DA7D1
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386922; cv=none; b=VjRC7jr1UYyFKpLPBsFqc8GEWjYS1uuyRaAQgViP3MBD4NPhDTf7iz6ACz2rdJAnOgXjhHGFTphAo4P36T+kK39o/pVUVGUANh8JIvzkhBhcArZr53GxBbE9MWNuNPr4y4krFfz91bNU5b2+QQPFM7+VAqUVcihKAnqGt0zEDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386922; c=relaxed/simple;
	bh=9E5FkLyzk9V+/ACKBT/VHdJCdTVMUTuKk7oKGTmtmKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRRTftCg2UVDGBYT2e97ln5axQDd0pdBYyfNhEuUg6W9UdwOTwK3sJCHbf0+mO9he5a4S6JGXWQkP5w2AZT+6dpiTg8wNW7Hl/6yHh90xhI9OZ/HBOp4zkgYL8JzhoD7ZwqNnlRcbrgnFQcVuJWEWoNzls+Ml8YX8rkXO/+OWg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e2kTBazs; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e2kTBazs"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30c52f96f60so4046602eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386919; x=1782991719; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=px5EgeugJ96+TLyit79Tt48vl836/egeDWRUV2Bckak=;
        b=e2kTBazsix4Ue7YrbtvLblWfzBhdnrM5jf6MR3H2d4gqvMaTnnpR91xHdIAi1pkI9z
         HxrwF4dLTXJQutiLXuYL4+dkPpj6YTsO8bswhwttrFDP2o7SiRvRVGRmZi+tRmR5zWEj
         TdalqVCjsPuhCRV0aJNiDgqZm3h3I2YZOK2C/wHnhPefAYNHqaWmMH1WkboMOdqceacS
         OJZTmyW/9vK7ZgAQAjHSTbN33jhUuGCXg8fSJ2zNf5MaZyvLzUoMbx3AYXzaMItCMEBN
         OfvZsBBkCF58+yYVh8/ZZjgn8DbIhR+ntC21YpyAlx7pYJsnLgOjbMBR/W8Ps9wcdoZu
         ggRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386919; x=1782991719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=px5EgeugJ96+TLyit79Tt48vl836/egeDWRUV2Bckak=;
        b=T+CQ64pbyVoENHbwln5ktjxlXVvfy4BrMYEOD7gE7qe26VY7D1BBlXqJMUwd5Hb9fw
         e7IHllh8GlhPme4UPWjoKrJNFvoHJpxCDh4WATNzNSYUkaHCNCOkM2pj2g4JCq2cB9BS
         f84Ox40t4p1xXmGCIQp2pEh5zA/T5ENB6Qm7Um3GQHejjISbl1UYpoy+KGOmEnfygQMS
         YZTVBeZEeVPM8BqWN0SqllPzDt9Jg9DW6P50h9aKNnxzfBpsw1+5eqnzIPOCUml5KK3A
         cWAw2M575rxIZZn6JWZrpGT88ZAG0Imc1Dkvm+3It8mpB/9jcue7OPREYpgGmnU/fx6W
         EtgQ==
X-Gm-Message-State: AOJu0Yx2rk0BOOsil4Dy9C2Z74pzC0iqbF6KOynC03GHUQpbGReT8qD8
	0aY9zFyp0FRhvwST8gFfDdKvptT+d2262dkFJu62a2JXZ3c+KMHoTpT6
X-Gm-Gg: AfdE7clHcGoLosKJEFM9y+qwb2z6yocrNecrZBCKxaTbws69X3CwhRmR61Ib+jMhqJ2
	TvV7PVb12vcsE6gDyJOgnNZnenQp5GsqpF7uUOH4jPovRX2FvaHO0fOVykOcjlK+05+UUaVIZMG
	zx3M8/rXZnTE5gLHnAqf3Xf8aXKOL7gZVP9TwOSMasGSGoyN+Vi8GC9E591CpIC+eyFm4uFMmm+
	gd7b0pMVlzosChPbL9wjhFqfWeC692uIt/85MNcb504AnG8mzjelBcxaNMGLaDPL1ciE5Fi7qJw
	oNGfn7Kd1SHUHpI8/knmfm17vr2jJ5XRfUkl/laNLyJuae2WEb94aYPw14NucZ1NuHO23z2wSpb
	htOb1q64LgsmovLfA/3vE7aaVlom0GFS3L+HaBu/5IZS/DwBWtdy+ovJ3ZzMu1FEC7Jfjy8L2VN
	YRQN1l4FiT5uJY5sKL6YUaUF789r+ELt/o9+Poyq+3A5EJlA/SD7RacGAks4+ZeKwayc0BoThwZ
	ZErGtg=
X-Received: by 2002:a05:7301:2f8a:b0:304:6d18:3646 with SMTP id 5a478bee46e88-30c8489175amr2710590eec.0.1782386919330;
        Thu, 25 Jun 2026 04:28:39 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:39 -0700 (PDT)
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
Subject: [PATCH v11 12/31] cxl/mem: Set up framework for handling DC Events
Date: Thu, 25 Jun 2026 04:04:49 -0700
Message-ID: <20260625112638.550691-13-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Adds the support for receiving DC event records but defers
the real add/release logic to subsequent commits. Simply refuse all
extents for DC_ADD and ack all DC_RELEASE events for now. Forced
release is currently unsupported.

In order, this commit adds the following:

1. Learn about DC Event Records and how to respond to them

* cxl_mem_get_event_records() learns about the DC Event record.
Records of that type are routed to cxl_handle_dcd_event_records().

* cxl_handle_dcd_event_records() switches on event_type:
	- DCD_ADD_CAPACITY     -> handle_add_event()
	- DCD_RELEASE_CAPACITY -> cxl_rm_extent()
	- DCD_FORCED_CAPACITY_RELEASE is logged and ignored (FM/device-only).

* cxl_send_dc_response() sends the reply mailbox commands
ADD_DC_RESPONSE / RELEASE_DC

2. Add stubs for DC_ADD and DC_RELEASE logic

* handle_add_event() stages incoming extents onto
mds->add_ctx.pending_extents and, when More=0 closes the chain,
replies with an empty ADD_DC_RESPONSE — refusing all extents for now

* cxl_rm_extent() acks the release via memdev_release_extent() so the
device's view stays consistent; we can ack all releases because
we currently don't accept/use any extents offered.

3. Structural setup for later commits:

* struct dc_extent, struct cxl_dc_tag_group, and pending_add_ctx
set up the stage for the real DC_ADD path, which will enforce
tag/grouping semantics

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
1. mbox.c: fix leaking var node in add_to_pending_list()
2. mbox.c: clear previously staged extents in handle_add_event()
  if add_to_pending_list() returns an error
3. mbox.c memdev_release_extent(): alloc cxl_extent_list_node
 on stack instead of using kzalloc because if kzalloc fails,
 it would prevent the release DC rsp from being sent. Avoid
 that possibility altogether.
---
 drivers/cxl/core/mbox.c | 245 +++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h       |  69 +++++++++++
 drivers/cxl/cxlmem.h    |  45 ++++++++
 include/cxl/event.h     |  38 +++++++
 4 files changed, 396 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 2ab400788824..7dd40fb8d613 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -5,6 +5,7 @@
 #include <linux/ktime.h>
 #include <linux/mutex.h>
 #include <linux/unaligned.h>
+#include <linux/list.h>
 #include <cxlpci.h>
 #include <cxlmem.h>
 #include <cxl.h>
@@ -1098,6 +1099,237 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
 	return rc;
 }
 
+static int send_one_response(struct cxl_mailbox *cxl_mbox,
+			     struct cxl_mbox_dc_response *response,
+			     int opcode, u32 extent_list_size, u8 flags)
+{
+	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
+		.opcode = opcode,
+		.size_in = struct_size(response, extent_list, extent_list_size),
+		.payload_in = response,
+	};
+
+	response->extent_list_size = cpu_to_le32(extent_list_size);
+	response->flags = flags;
+	return cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+}
+
+static int cxl_send_dc_response(struct cxl_memdev_state *mds, int opcode,
+				struct list_head *extent_list, int cnt)
+{
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct cxl_mbox_dc_response *p;
+	struct cxl_extent_list_node *pos, *tmp;
+	struct cxl_extent *extent;
+	u32 pl_index;
+
+	size_t pl_size = struct_size(p, extent_list, cnt);
+	u32 max_extents = cnt;
+
+	/* May have to use more bit on response. */
+	if (pl_size > cxl_mbox->payload_size) {
+		max_extents = (cxl_mbox->payload_size - sizeof(*p)) /
+			      sizeof(struct updated_extent_list);
+		pl_size = struct_size(p, extent_list, max_extents);
+	}
+
+	struct cxl_mbox_dc_response *response __free(kfree) =
+						kzalloc(pl_size, GFP_KERNEL);
+	if (!response)
+		return -ENOMEM;
+
+	/* Set __counted_by to capacity before populating; reset per response. */
+	response->extent_list_size = cpu_to_le32(max_extents);
+
+	if (cnt == 0)
+		return send_one_response(cxl_mbox, response, opcode, 0, 0);
+
+	pl_index = 0;
+	list_for_each_entry_safe(pos, tmp, extent_list, list) {
+		extent = pos->extent;
+		response->extent_list[pl_index].dpa_start = extent->start_dpa;
+		response->extent_list[pl_index].length = extent->length;
+		pl_index++;
+
+		if (pl_index == max_extents) {
+			u8 flags = 0;
+			int rc;
+
+			if (pl_index < cnt)
+				flags |= CXL_DCD_EVENT_MORE;
+			rc = send_one_response(cxl_mbox, response, opcode,
+					       pl_index, flags);
+			if (rc)
+				return rc;
+			cnt -= pl_index;
+			if (cnt < max_extents)
+				max_extents = cnt;
+			pl_index = 0;
+		}
+	}
+
+	if (!pl_index) /* nothing more to do */
+		return 0;
+	return send_one_response(cxl_mbox, response, opcode, pl_index, 0);
+}
+
+static void delete_extent_node(struct cxl_extent_list_node *node)
+{
+	list_del(&node->list);
+	kfree(node->extent);
+	kfree(node);
+}
+
+static void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range)
+{
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_extent extent = {
+		.start_dpa = cpu_to_le64(range->start),
+		.length = cpu_to_le64(range_len(range)),
+	};
+	struct cxl_extent_list_node node = { .extent = &extent };
+	LIST_HEAD(extent_list);
+
+	dev_dbg(dev, "Release response dpa %pra\n", range);
+
+	/*
+	 * Stack-allocated instead of kzalloc'ed to avoid potential -ENOMEM,
+	 * which would prevent sending the release DC rsp.
+	 */
+	list_add_tail(&node.list, &extent_list);
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
+		dev_dbg(dev, "Failed to release %pra\n", range);
+}
+
+static void clear_pending_extents(void *_mds)
+{
+	struct cxl_memdev_state *mds = _mds;
+	struct cxl_extent_list_node *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, &mds->add_ctx.pending_extents, list)
+		delete_extent_node(pos);
+	mds->add_ctx.group = NULL;
+}
+
+static int add_to_pending_list(struct list_head *pending_list,
+			       struct cxl_extent *to_add)
+{
+	struct cxl_extent_list_node *node = kzalloc(sizeof(*node), GFP_KERNEL);
+	struct cxl_extent *extent;
+
+	if (!node)
+		return -ENOMEM;
+	extent = kmemdup(to_add, sizeof(*extent), GFP_KERNEL);
+	if (!extent) {
+		kfree(node);
+		return -ENOMEM;
+	}
+
+	node->extent = extent;
+	list_add_tail(&node->list, pending_list);
+	return 0;
+}
+
+/*
+ * Stub: stage extents on the pending list and reply with an empty
+ * ADD_DC_RESPONSE on More=0 (refuse all).  A later commit replaces
+ * the no-op tail with the real Add pipeline that surfaces a dax
+ * device per accepted extent.
+ */
+static int handle_add_event(struct cxl_memdev_state *mds,
+			    struct cxl_event_dcd *event)
+{
+	struct device *dev = mds->cxlds.dev;
+	int rc;
+
+	rc = add_to_pending_list(&mds->add_ctx.pending_extents, &event->extent);
+	if (rc) {
+		clear_pending_extents(mds);
+		return rc;
+	}
+
+	if (event->flags & CXL_DCD_EVENT_MORE) {
+		dev_dbg(dev, "more bit set; delay the surfacing of extent\n");
+		return 0;
+	}
+
+	rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				  &mds->add_ctx.pending_extents, 0);
+	clear_pending_extents(mds);
+	return rc;
+}
+
+/*
+ * Stub: ack the release back to the device so it knows we are not
+ * using the range.  A later commit replaces this with the real
+ * teardown that walks the region's tag group and tears down the
+ * member dc_extent devices.
+ */
+static int cxl_rm_extent(struct cxl_memdev_state *mds,
+			 struct cxl_extent *extent)
+{
+	u64 start_dpa = le64_to_cpu(extent->start_dpa);
+	struct range dpa_range = {
+		.start = start_dpa,
+		.end = start_dpa + le64_to_cpu(extent->length) - 1,
+	};
+
+	memdev_release_extent(mds, &dpa_range);
+	return 0;
+}
+
+static char *cxl_dcd_evt_type_str(u8 type)
+{
+	switch (type) {
+	case DCD_ADD_CAPACITY:
+		return "add";
+	case DCD_RELEASE_CAPACITY:
+		return "release";
+	case DCD_FORCED_CAPACITY_RELEASE:
+		return "force release";
+	default:
+		break;
+	}
+
+	return "<unknown>";
+}
+
+static void cxl_handle_dcd_event_records(struct cxl_memdev_state *mds,
+					 struct cxl_event_record_raw *raw_rec)
+{
+	struct cxl_event_dcd *event = &raw_rec->event.dcd;
+	struct cxl_extent *extent = &event->extent;
+	struct device *dev = mds->cxlds.dev;
+	uuid_t *id = &raw_rec->id;
+	int rc;
+
+	if (!uuid_equal(id, &CXL_EVENT_DC_EVENT_UUID))
+		return;
+
+	dev_dbg(dev, "DCD event %s : DPA:%#llx LEN:%#llx\n",
+		cxl_dcd_evt_type_str(event->event_type),
+		le64_to_cpu(extent->start_dpa), le64_to_cpu(extent->length));
+
+	switch (event->event_type) {
+	case DCD_ADD_CAPACITY:
+		rc = handle_add_event(mds, event);
+		break;
+	case DCD_RELEASE_CAPACITY:
+		rc = cxl_rm_extent(mds, &event->extent);
+		break;
+	case DCD_FORCED_CAPACITY_RELEASE:
+		dev_err_ratelimited(dev, "Forced release event ignored.\n");
+		rc = 0;
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc)
+		dev_err_ratelimited(dev, "dcd event failed: %d\n", rc);
+}
+
 static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 				    enum cxl_event_log_type type)
 {
@@ -1134,9 +1366,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 		if (!nr_rec)
 			break;
 
-		for (i = 0; i < nr_rec; i++)
+		for (i = 0; i < nr_rec; i++) {
 			__cxl_event_trace_record(cxlmd, type,
 						 &payload->records[i]);
+			if (type == CXL_EVENT_TYPE_DCD)
+				cxl_handle_dcd_event_records(mds,
+							&payload->records[i]);
+		}
 
 		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
 			trace_cxl_overflow(cxlmd, type, payload);
@@ -1168,6 +1404,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
 {
 	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
 
+	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
+		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
 	if (status & CXLDEV_EVENT_STATUS_FATAL)
 		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
 	if (status & CXLDEV_EVENT_STATUS_FAIL)
@@ -1797,6 +2035,11 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 	}
 
 	mutex_init(&mds->event.log_lock);
+	INIT_LIST_HEAD(&mds->add_ctx.pending_extents);
+
+	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
+	if (rc)
+		return ERR_PTR(rc);
 
 	rc = devm_cxl_register_mce_notifier(dev, &mds->mce_notifier);
 	if (rc == -EOPNOTSUPP)
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 864f6d3c03d4..367c3d9e2147 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -12,6 +12,7 @@
 #include <linux/node.h>
 #include <linux/io.h>
 #include <linux/range.h>
+#include <linux/xarray.h>
 #include <cxl/cxl.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
@@ -308,6 +309,41 @@ enum cxl_decoder_state {
 	CXL_DECODER_STATE_AUTO_STAGED,
 };
 
+struct cxl_dc_tag_group;
+
+/**
+ * struct dc_extent - A single dynamic-capacity extent surfaced to the host.
+ *
+ * One per device-stamped extent.  Multiple dc_extents that share a tag
+ * (see &struct cxl_dc_tag_group) form a single logical allocation, but
+ * each dc_extent has its own HPA range and is the unit that the DAX
+ * layer sees as a backing dax_resource.
+ *
+ * @dev: device representing this extent; child of cxlr_dax->dev.
+ * @group: containing tag group (allocation); shared across siblings.
+ * @cxled: endpoint decoder backing the DPA range.
+ * @dpa_range: DPA range this extent covers within @cxled.
+ * @hpa_range: HPA range that @dpa_range decodes to, relative to
+ *	       cxlr_dax->hpa_range.start.
+ * @uuid: tag uuid (matches @group->uuid; kept for the release-path log).
+ * @seq_num: 0..n-1 assembly-order index within the tag group, assigned by the
+ *	     host in cxl_realize_group().  For a sharable partition the
+ *	     order follows the device-stamped shared_extn_seq (0..n-1 per
+ *	     CXL r4.0 Table 8-230); for a non-sharable partition, where
+ *	     shared_extn_seq is reserved, the order follows event arrival.
+ *	     Either way @seq_num is a dense 0..n-1 so the dax layer can
+ *	     assemble ranges in the right order regardless of source.
+ */
+struct dc_extent {
+	struct device dev;
+	struct cxl_dc_tag_group *group;
+	struct cxl_endpoint_decoder *cxled;
+	struct range dpa_range;
+	struct range hpa_range;
+	uuid_t uuid;
+	u16 seq_num;
+};
+
 /**
  * struct cxl_endpoint_decoder - Endpoint  / SPA to DPA decoder
  * @cxld: base cxl_decoder_object
@@ -520,12 +556,45 @@ struct cxl_pmem_region {
 	struct cxl_pmem_region_mapping mapping[];
 };
 
+/* See CXL 3.1 8.2.9.2.1.6 */
+enum dc_event {
+	DCD_ADD_CAPACITY,
+	DCD_RELEASE_CAPACITY,
+	DCD_FORCED_CAPACITY_RELEASE,
+	DCD_REGION_CONFIGURATION_UPDATED,
+};
+
 struct cxl_dax_region {
 	struct device dev;
 	struct cxl_region *cxlr;
 	struct range hpa_range;
 };
 
+/**
+ * struct cxl_dc_tag_group - A tagged dynamic-capacity allocation.
+ *
+ * Container for the &struct dc_extent siblings that share a tag.  The
+ * group has no sysfs identity; userspace sees the individual dc_extents
+ * directly under the parent dax_region device.  The group exists to
+ * keep tag-scoped invariants (atomic add, atomic release, ordered carve
+ * by seq_num) in one place.
+ *
+ * @cxlr_dax: back reference to parent region device.
+ * @uuid: tag identifying this allocation; same across all member dc_extents.
+ * @dc_extents: xarray of &struct dc_extent in this group, indexed by the
+ *		dc_extent's @seq_num (0..n-1, dense).  See &struct dc_extent
+ *		for how seq_num is sourced for sharable vs non-sharable
+ *		allocations.
+ * @nr_extents: live count of dc_extents in the group; the group is freed
+ *		when the last dc_extent device is released.
+ */
+struct cxl_dc_tag_group {
+	struct cxl_dax_region *cxlr_dax;
+	uuid_t uuid;
+	struct xarray dc_extents;
+	unsigned int nr_extents;
+};
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index bcf976829c3e..4ffa7bd1e5f1 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -7,6 +7,7 @@
 #include <linux/cdev.h>
 #include <linux/uuid.h>
 #include <linux/node.h>
+#include <linux/list.h>
 #include <cxl/event.h>
 #include <cxl/mailbox.h>
 #include "cxl.h"
@@ -404,6 +405,23 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
 	return dev_get_drvdata(cxl_mbox->host);
 }
 
+/**
+ * struct pending_add_ctx - Staging state for an in-progress
+ *			    DCD_ADD_CAPACITY event chain
+ * @pending_extents: extents received so far in the chain; flushed when
+ *		     the chain closes (More=0)
+ * @group: tag group being assembled from the chain
+ *
+ * A DCD_ADD_CAPACITY notification can span multiple event records
+ * stitched together by the CXL_DCD_EVENT_MORE flag.  Records are staged
+ * here until the device clears More, at which point the staged batch is
+ * processed and responded to as a single Add_DC_Response.
+ */
+struct pending_add_ctx {
+	struct list_head pending_extents;
+	struct cxl_dc_tag_group *group;
+};
+
 /**
  * struct cxl_memdev_state - Generic Type-3 Memory Device Class driver data
  *
@@ -422,6 +440,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
  * @dcd_supported: all DCD commands are supported
+ * @add_ctx: state for an in-progress DCD_ADD_CAPACITY chain
+ *	     (see &struct pending_add_ctx)
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -442,6 +462,7 @@ struct cxl_memdev_state {
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
 	bool dcd_supported;
+	struct pending_add_ctx add_ctx;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -518,6 +539,21 @@ enum cxl_opcode {
 	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
+/*
+ * Add Dynamic Capacity Response
+ * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
+ */
+struct cxl_mbox_dc_response {
+	__le32 extent_list_size;
+	u8 flags;
+	u8 reserved[3];
+	struct updated_extent_list {
+		__le64 dpa_start;
+		__le64 length;
+		u8 reserved[8];
+	} __packed extent_list[] __counted_by(extent_list_size);
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
@@ -588,6 +624,14 @@ struct cxl_mbox_identify {
 	UUID_INIT(0xe71f3a40, 0x2d29, 0x4092, 0x8a, 0x39, 0x4d, 0x1c, 0x96, \
 		  0x6c, 0x7c, 0x65)
 
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1; Table 8-43
+ */
+#define CXL_EVENT_DC_EVENT_UUID                                             \
+	UUID_INIT(0xca95afa7, 0xf183, 0x4018, 0x8c, 0x2f, 0x95, 0x26, 0x8e, \
+		  0x10, 0x1a, 0x2a)
+
 /*
  * Get Event Records output payload
  * CXL rev 3.0 section 8.2.9.2.2; Table 8-50
@@ -613,6 +657,7 @@ enum cxl_event_log_type {
 	CXL_EVENT_TYPE_WARN,
 	CXL_EVENT_TYPE_FAIL,
 	CXL_EVENT_TYPE_FATAL,
+	CXL_EVENT_TYPE_DCD,
 	CXL_EVENT_TYPE_MAX
 };
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index ff97fea718d2..fa3cd895f656 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/workqueue_types.h>
+#include <linux/list.h>
 
 /*
  * Common Event Record Format
@@ -141,12 +142,49 @@ struct cxl_event_mem_sparing {
 	u8 reserved2[0x25];
 } __packed;
 
+/*
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-51
+ */
+struct cxl_extent {
+	__le64 start_dpa;
+	__le64 length;
+	u8 uuid[UUID_SIZE];
+	__le16 shared_extn_seq;
+	u8 reserved[0x6];
+} __packed;
+
+struct cxl_extent_list_node {
+	struct cxl_extent *extent;
+	struct list_head list;
+	int rid;
+};
+
+/*
+ * Dynamic Capacity Event Record
+ * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-50
+ */
+#define CXL_DCD_EVENT_MORE			BIT(0)
+struct cxl_event_dcd {
+	struct cxl_event_record_hdr hdr;
+	u8 event_type;
+	u8 validity_flags;
+	__le16 host_id;
+	u8 partition_index;
+	u8 flags;
+	u8 reserved1[0x2];
+	struct cxl_extent extent;
+	u8 reserved2[0x18];
+	__le32 num_avail_extents;
+	__le32 num_avail_tags;
+} __packed;
+
 union cxl_event {
 	struct cxl_event_generic generic;
 	struct cxl_event_gen_media gen_media;
 	struct cxl_event_dram dram;
 	struct cxl_event_mem_module mem_module;
 	struct cxl_event_mem_sparing mem_sparing;
+	struct cxl_event_dcd dcd;
 	/* dram & gen_media event header */
 	struct cxl_event_media_hdr media_hdr;
 } __packed;
-- 
2.43.0

