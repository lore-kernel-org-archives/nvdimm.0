Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B049C385D7E
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529444; cv=none; b=QaC0B2mLnTS5S1Hez3U+eMzxWO6FFN/K7O2HSTSxRPECLEflw9zis22NS9koflpgv3Cdhh4NtDZDN6MznJFiaXU7Z3Rck04rq5XzQ0E8yoBTD4OErpdPv1X4sMWEhRb9dMhgU5rzgCqvsgNV841n4aJd3F0eyLR/YbdoKH9nFIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529444; c=relaxed/simple;
	bh=ddCesjgMJiZ0L05KYHUHodUsMxYo3WI3I9Caw7IL1k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXH8Mx5cu12gtGJFSGVq+IcTi0HAh/wXtHIhTItev7Jraq5/O0uzw8FP/YUqhPJlWo5iOrs0P2BS89oh3kTc8eqhZPpjwXcDV/SmbTm0MGg98kow97gejhshDyHZg0UMVHCF4/W8VQw76Ov0+xyHaID4POBAFTkQ8pMIlNLo1R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I3cZbcVB; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I3cZbcVB"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1309f4ee97fso9074483c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529441; x=1780134241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bt/WWLiVqvvMQTuiQC0nRMt3xEqd7NiaZ1OPEgjDEDo=;
        b=I3cZbcVBGiQbcUCZAMmStkD9BEXZwUL01Z/V1mjrCVKuHU7rIvh7cB3QX6M5VqhOCQ
         93ndLCTpu+NN9rvsmGzjZlQ+O1qeNA1LQKx1Nq6x7DqhjjlFPEEXU2PY6tdsbe0hbGF2
         znMF7zoXncHeaTQl7x5UQ8NwLWauyUEVQPRzuDcC6ChoB/3TYrQFE+U5Hr1LM2ncFryZ
         tl9+gxM94MdzjHbviyOIx6XR+E1YNMptnT6Ix6f6QUiyNoDu3qLh9n/sVpEtB8SHAMAm
         4mlEqR60XrXtYeqlaZy9XcE2WNPSe2pXubuXu9H3EISxqRHMeGm3k2yyAsUkmB5KLFWL
         Hviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529441; x=1780134241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bt/WWLiVqvvMQTuiQC0nRMt3xEqd7NiaZ1OPEgjDEDo=;
        b=P+lLjMaHUE+FsQtXHpEc59bfNC5bHM52wsD9xEX2nrurqyW0UGNIfbOnDiQqKAZA3z
         8b+ALW2HIQjRXl2ADf41SFEfaGCHLXvHd3C2P8OkOnk71wFoEHZUVxdkI5yuYT+zncy/
         /28lhYYE8swz0UTybZ/BKsaPNtU/dj9cJRT/Tnc+Y+sGGpCf5V1w8PZcrYP3AVdZg5wE
         muLD/udod3kPb7/nVo7ejpqO3v/8E5loYUMOpkqrNXJM/Izw1AHks1MmF6e1lz1QgLGF
         K9ipTwyiDwNaw4idnQcjuNbKroYU7A1QZzpgT0NTBaa7AZGnmaBd6W/zb6nkCUw9kyEH
         LvLg==
X-Gm-Message-State: AOJu0YyPFz7NY/bHr5zfcRHJmYZJtFW9a37gNMInaHbbI/o4+SnfYR24
	oqKamIfXkABF9Aoh2/MN8KlrPvRPtXeCceknKCeISdQbLGx9GK9h0SGL
X-Gm-Gg: Acq92OHvgXfxL/anYEXPwRGiQHkoCk2cpLXq2gZva/SuyWN9dC35hNc1rWO49O9I/+X
	xIK9+unmtVsaXXCXyelR2enRsfY+ZawR8CbP4AfU/gCeeuo6Ae10rmCZ1mvu1Sipy8ulNYHXeve
	7JcHcwD3N5CAqUfIA7Um9omOyi6nBFuFQwxw6ewx4jQ5XYTY2RAhmOb8A4RHCMmZQwTC0nY+UgC
	qE499ws5Fzmh62Oxu1J0O9Ci9vbc3UJ5bM+aN1iOBH58OqQdzjWKqfJAa+3qJ+paS1xUG4iNz+m
	MFrjEpSsNxhhmPJOhQs7370D1FVe1c3ddFUBPPruuhMvfYiKz2NgoFHV3BQ6g9EvgnVxGp8UYrL
	J0jGlpuFkDwvpZlOynBa/rQFR+IMIsnSTBSAOFKxp/02SC3jxKjBXtfUTmM0YsS/poJ49585ML4
	osNZfERBCtgndK7fqpki/DH/NPFNrJT9IB5vBlCVVGJyPVGa/T8ilmujnNp/BJgrFhG5Mu4QjMP
	qOh9lbGveVHJqR67g==
X-Received: by 2002:a05:7022:128a:b0:135:dd7c:7 with SMTP id a92af1059eb24-1365fc6db3dmr2572825c88.38.1779529440747;
        Sat, 23 May 2026 02:44:00 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:59 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 12/31] cxl/mem: Set up framework for handling DC Events
Date: Sat, 23 May 2026 02:43:06 -0700
Message-ID: <e11ff26899d6714878d955fcc2724732fb4a3d29.1779528761.git.anisa.su@samsung.com>
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

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: restructured from the original "Process dynamic partition
 events" monolith; this commit lands only the wire-level intake and
 dispatches the add/release logic to stubbed handlers. The handlers
 are fleshed out in subsequent commits.]
---
 drivers/cxl/core/mbox.c | 246 +++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/cxl.h       |  73 +++++++++++-
 drivers/cxl/cxlmem.h    |  45 ++++++++
 include/cxl/event.h     |  38 +++++++
 4 files changed, 400 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 01b1a318f34f..1b38f34538f3 100644
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
@@ -1102,6 +1103,238 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
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
+	struct cxl_extent_list_node *node;
+	LIST_HEAD(extent_list);
+
+	dev_dbg(dev, "Release response dpa %pra\n", range);
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return;
+
+	node->extent = kzalloc(sizeof(*node->extent), GFP_KERNEL);
+	if (!node->extent) {
+		kfree(node);
+		return;
+	}
+
+	node->extent->start_dpa = cpu_to_le64(range->start);
+	node->extent->length = cpu_to_le64(range_len(range));
+	list_add_tail(&node->list, &extent_list);
+
+	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))
+		dev_dbg(dev, "Failed to release %pra\n", range);
+
+	delete_extent_node(node);
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
+	struct cxl_extent_list_node *node;
+	struct cxl_extent *extent;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+	extent = kmemdup(to_add, sizeof(*extent), GFP_KERNEL);
+	if (!extent)
+		return -ENOMEM;
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
+	if (rc)
+		return rc;
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
@@ -1138,9 +1371,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
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
@@ -1172,6 +1409,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
 {
 	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
 
+	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
+		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
 	if (status & CXLDEV_EVENT_STATUS_FATAL)
 		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
 	if (status & CXLDEV_EVENT_STATUS_FAIL)
@@ -1769,6 +2008,11 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
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
index 1297594beaec..5ef2cf4d005b 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -12,6 +12,7 @@
 #include <linux/node.h>
 #include <linux/io.h>
 #include <linux/range.h>
+#include <linux/xarray.h>
 #include <cxl/cxl.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
@@ -180,11 +181,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
 #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
 #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
+#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
 
 #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
 				 CXLDEV_EVENT_STATUS_WARN |	\
 				 CXLDEV_EVENT_STATUS_FAIL |	\
-				 CXLDEV_EVENT_STATUS_FATAL)
+				 CXLDEV_EVENT_STATUS_FATAL |	\
+				 CXLDEV_EVENT_STATUS_DCD)
 
 /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
 #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
@@ -306,6 +309,41 @@ enum cxl_decoder_state {
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
+ * @seq_num: 1..n assembly-order index within the tag group.  For extents
+ *	     from a sharable partition this equals the device-stamped
+ *	     shared_extn_seq (CXL 3.1 Table 8-51).  For extents from a
+ *	     non-sharable partition the device leaves shared_extn_seq == 0
+ *	     and the host assigns @seq_num in event arrival order at
+ *	     cxl_add_pending() time.  Used by the dax layer to assemble
+ *	     ranges in the right order regardless of source.
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
@@ -518,12 +556,45 @@ struct cxl_pmem_region {
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
+ *		dc_extent's @seq_num (1..n, dense).  See &struct dc_extent
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
index 65c009b02da6..592c8e3b611c 100644
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
@@ -399,6 +400,23 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
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
@@ -417,6 +435,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
  * @dcd_supported: all DCD commands are supported
+ * @add_ctx: state for an in-progress DCD_ADD_CAPACITY chain
+ *	     (see &struct pending_add_ctx)
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -437,6 +457,7 @@ struct cxl_memdev_state {
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
 	bool dcd_supported;
+	struct pending_add_ctx add_ctx;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -513,6 +534,21 @@ enum cxl_opcode {
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
@@ -583,6 +619,14 @@ struct cxl_mbox_identify {
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
@@ -608,6 +652,7 @@ enum cxl_event_log_type {
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

