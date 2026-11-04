Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833364;
	b=L4/k/WRMo3RtwG9TMZQliOUSjlqb0+Mcd6IwDlp9B+x9RL40qJk9tDFlHZEGzV5tnczu
	 lkR7vmAiH4GVrbY3RqAhsmlrtpoClw005KsFXvUBIVwOTzGALIVOAlNkXSugJ85wuvN+x
	 P15qw2oasfFQPw9r5UkDYEmlo6kdmzFO5wjUGFh+ieCvQVesIEKfruZu5XPnS7r478NbL
	 oqFaoqOVSZfHSxA0ULEYDu6ErYPqe0lsLVjKhvcEQjtJfG3QSLyTqcfxPQcoFYToCM9tr
	 5GUMxWLqwkv/K5z0nsZ8QnrjJ3zqCZQhHc9UN4vG6WdnctoF5VtU/pO997PaBvp8crg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yo2Z1AMAycbdACFt6xNxywNP8Kvhj7/G+Izur0BYI2M=;
	b=YfChkSKJjVdvrH7ypz3Jg/y27fPU+/f8HHwwdeM3kSdpopR8JsLosITcDfJbv/62pZeV
	 KO9viFxdGVK8RNFAeteBynihwdbUiNmTeWXqfy0OxKuQ4b+rxwm+9W5UW/FoA56lsSNBA
	 ZPaTYCwd5IqPalmTpQ2n50W6nEL1TjqmmVPg3BQnTDmPNmsCVIHl8NyNMwXvrtY5GncdD
	 bNAejoyH19bsEvfnp5gkcNUytvUDjDePzT/Om4xD61M3Zu0paf4mxRRMQLErpIr/u+3YS
	 2NKWfgx7VNbGf3F+hdEgi0taM4dQMaPjuiDe+jBB6JrGlUcc6UA3mapM13ZAAySfCSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wZ2RVCq4;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E11606D80A
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16E11606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wZ2RVCq4
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso7183885ad.1
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833363; x=1794438163; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yo2Z1AMAycbdACFt6xNxywNP8Kvhj7/G+Izur0BYI2M=;
        b=wZ2RVCq4/zLYVrKnrfEdhVlAMTPpDoyu65mK26XM9t8Asxvefp8YzfS1h1ehLYfbTj
         lyY4CqVoL8CH/7bgzh72q2w9E4BP1DaiV7ScLqWBz4SsSHYmy+NsqLip20ocRE+MaKj1
         MzRJPwVLulGiVMt4RPy4xxYPYXhUKSJodx4qXsbhNEZsaQ61/dNUwBJwaqGOKTaIqZOS
         LQcGyQicdSOkcLzkDf3W6uIoQRAFvKhkSLbhWQFCc2Xb/ZNckJgv3dApLyXq7/UrDcrH
         uTclzl4fsoebI+kytn8+wc9p1B2exdg6mXd5U2ANNYUeUKGtxMUpUpLZc4DIBXL8jdrn
         opGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833363; x=1794438163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yo2Z1AMAycbdACFt6xNxywNP8Kvhj7/G+Izur0BYI2M=;
        b=WrAr8b9poRU3vWbaQLQybEau9IbmUvfSX6/TiA4DGNrLt2Hbqte+RMFxShKeyN/x3Y
         CmfEavSNsU5kb0FgCMyAkxcGOJIjB+WsQo+UDl4QsneT5jvjBtHceb2tRvGOg5KaWlzk
         JZxWCZ7mIFVFK/y0oD8mwlJklvJObwKFhlY25WSPypyxXUoESTrzuMTH750x0CYWHZyV
         7cD34r46z4GjGxkFAZhwfzg+6n0/PDogcA5sLZ7q32oa/B21AofBWGTCyPuFr2q28bcb
         Fx06TswGXEFXmWwz/phurMRU5jul2qSkTCSv7lqDJ7WlUjy+ne6DC0ff5ypwpYy8P1r1
         rQmg==
X-Gm-Message-State: APuU4Z9QEUweZo2qRz1BfNB+5kWrhZfb5AU9n6RnkoPU9eAl22E1n+UY
	Z81HrJwG03QOnK6tYkWwciHvkPdFm/QwHvZwhPPB4T/TUpU2WGUF4BGf
X-Gm-Gg: AYBFou3UiS8skuXTLp0akkguR4/RqMVIQEq3ZnndifGRONo2AIO51g5vf2XSM/zbU51
	02CkJgp3UG7pDKjXIAl7fXxyZfOV64O4DDZgSVY57vn/AOrM7kvYY4wZjQXohZBT0vajjRlYBNw
	jtJVJZvcVm4mF/hzQT10t6YDmFGHbN37IJ2vvisloRttx0DrEcOmQg3SA7W40m5xEHZRHverS2Q
	QQRoVwXFufJHUx1IX0yGMX0gxwxXhTI4razCk9weHsI/hqAOYAYgG/4qg+qFbUX8CRLbJUMvWkI
	HqWfHT0fJQ5ow61gbsS09hjYg6HaBndVSdxz3IDuulso6GBg9GViPe68sMWV4zjJKXObrFwqdDc
	sqK0nL7WJ5YTlapDJuBGdqOeAFU42545eHTOxXaVkun2e9RUFfQp5WnQ3P6G7xnuQJxIY3QuH/t
	zK4A79xbSQzNUpPAN9zmXfjUfOfmVqz1qHSIUZ0lqOjBkWdE5wxGkHJafUjfe95Yuo8dQCzAb/q
	T9VO5FOYzL1hU6qGxyRmPbH1lOhv15uv/D+zLs89g651060g3Vvy32rzni2zYcFUJJ8be6hPDjM
	K9EvwjBR4GdamM2e1RYox8pBXz+Ohg==
X-Received: by 2002:a17:902:f54a:b0:2e4:adb3:c776 with SMTP id d9443c01a7336-2eb364b8234mr166165075ad.24.1793833363060;
        Wed, 04 Nov 2026 15:02:43 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:42 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 04/14] cxl/mem: Introduce DC event handlers
Date: Thu,  5 Nov 2026 08:02:28 +0900
Message-ID: <20261104230445.66625-5-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Add the handling skeleton for DC Add and DC Release events. Per CXL
r4.0 Section 8.2.10.9.9.3, the host is expected to respond to one or
more Add Capacity Event Record(s) with an Add Dynamic Capacity Response
(Opcode 4802h) to acknowledge which extents the host accepts for use.
Similarly, per CXL r4.0 Section 8.2.10.9.9.4, the host is expected to
respond to Release Capacity Event Record(s) with a Release Dynamic
Capacity command (Opcode 4803h), or to issue one that is not
associated with any event to release capacity on its own.

The records of one operation can be chained by the More flag. Chained
records are contiguous in the event log and share one event type (CXL
r4.0 Table 8-229), so a single staging context, mds->dc_chain, holds
the records of the open chain until the closing record (More=0)
arrives and the chain is processed and responded to as a whole. A
record that fails to stage, or one of the other type arriving inside an
open chain, drops the chain: an add is refused with an empty response,
a release is left for the device to retry.

This commit refuses all extents from Add Capacity chains and acks all
Release Capacity chains. Subsequent commits implement accepting and
releasing extents.

Forced Capacity Release and Region Configuration Updated events are
logged and ignored.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/mbox.c  | 246 ++++++++++++++++++++++++++++++++++++++-
 drivers/cxl/core/trace.h |   3 +-
 drivers/cxl/cxl.h        |   9 ++
 drivers/cxl/cxlmem.h     |  46 ++++++++
 drivers/cxl/pci.c        |  20 +++-
 include/cxl/event.h      |  37 ++++++
 6 files changed, 353 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 13a68f5cef69..3acf5ace48db 100644
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
@@ -1100,6 +1101,237 @@ static int cxl_clear_event_record(struct cxl_memdev_state *mds,
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
+	if (!response) {
+		struct cxl_mbox_dc_response empty = { };
+
+		/* An empty Release DC is invalid (CXL r4.0 Table 8-352) */
+		if (opcode == CXL_MBOX_OP_RELEASE_DC)
+			return -ENOMEM;
+		/* Refuse all extents rather than stall the device. */
+		return send_one_response(cxl_mbox, &empty, opcode, 0, 0);
+	}
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
+static void clear_pending_extents(void *_mds)
+{
+	struct cxl_memdev_state *mds = _mds;
+	struct cxl_extent_list_node *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, &mds->dc_chain.pending_extents, list)
+		delete_extent_node(pos);
+}
+
+static const char *cxl_dcd_evt_type_str(u8 type)
+{
+	switch (type) {
+	case DCD_ADD_CAPACITY:
+		return "add";
+	case DCD_RELEASE_CAPACITY:
+		return "release";
+	case DCD_FORCED_CAPACITY_RELEASE:
+		return "force release";
+	case DCD_REGION_CONFIGURATION_UPDATED:
+		return "region configuration updated";
+	default:
+		break;
+	}
+
+	return "<unknown>";
+}
+
+/*
+ * Drop the open chain.  An add chain is refused with an empty response so
+ * the device can reclaim the offered capacity; a release chain is simply
+ * dropped, the capacity stays with the host and the device may retry.
+ */
+static void cxl_dc_chain_abort(struct cxl_memdev_state *mds)
+{
+	struct cxl_dc_event_chain *chain = &mds->dc_chain;
+	struct device *dev = mds->cxlds.dev;
+
+	if (chain->event_type == DCD_ADD_CAPACITY &&
+	    cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+				 &chain->pending_extents, 0))
+		dev_dbg(dev, "Failed to refuse add chain\n");
+
+	clear_pending_extents(mds);
+}
+
+static int stage_pending_extent(struct list_head *pending,
+				struct cxl_extent *to_add)
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
+	list_add_tail(&node->list, pending);
+	return 0;
+}
+
+static int handle_dcd_chain_event(struct cxl_memdev_state *mds,
+				  struct cxl_event_dcd *event)
+{
+	struct cxl_dc_event_chain *chain = &mds->dc_chain;
+	struct device *dev = mds->cxlds.dev;
+	int rc;
+
+	/* Chained records share one event type (CXL r4.0 Table 8-229) */
+	if (list_empty(&chain->pending_extents)) {
+		chain->event_type = event->event_type;
+	} else if (chain->event_type != event->event_type) {
+		dev_warn_ratelimited(dev, "DC %s record inside an open %s chain; dropping the chain\n",
+				     cxl_dcd_evt_type_str(event->event_type),
+				     cxl_dcd_evt_type_str(chain->event_type));
+		cxl_dc_chain_abort(mds);
+		chain->event_type = event->event_type;
+	}
+
+	rc = stage_pending_extent(&chain->pending_extents, &event->extent);
+	if (rc) {
+		cxl_dc_chain_abort(mds);
+		return rc;
+	}
+
+	if (event->flags & CXL_DCD_EVENT_MORE) {
+		dev_dbg(dev, "more bit set; delay processing of extent\n");
+		return 0;
+	}
+
+	/* Nothing is tracked yet: refuse every add, acknowledge every release */
+	if (event->event_type == DCD_ADD_CAPACITY)
+		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
+					  &chain->pending_extents, 0);
+	else
+		rc = cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC,
+					  &chain->pending_extents,
+					  list_count_nodes(&chain->pending_extents));
+	clear_pending_extents(mds);
+	return rc;
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
+	case DCD_RELEASE_CAPACITY:
+		rc = handle_dcd_chain_event(mds, event);
+		break;
+	case DCD_FORCED_CAPACITY_RELEASE:
+		dev_err_ratelimited(dev, "Forced release event ignored.\n");
+		rc = 0;
+		break;
+	case DCD_REGION_CONFIGURATION_UPDATED:
+		dev_dbg(dev, "Region configuration updated event ignored.\n");
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
@@ -1136,9 +1368,13 @@ static void cxl_mem_get_records_log(struct cxl_memdev_state *mds,
 		if (!nr_rec)
 			break;
 
-		for (i = 0; i < nr_rec; i++)
+		for (i = 0; i < nr_rec; i++) {
 			__cxl_event_trace_record(cxlmd, type,
 						 &payload->records[i]);
+			if (type == CXL_EVENT_TYPE_DCD)
+				cxl_handle_dcd_event_records(mds,
+							     &payload->records[i]);
+		}
 
 		if (payload->flags & CXL_GET_EVENT_FLAG_OVERFLOW)
 			trace_cxl_overflow(cxlmd, type, payload);
@@ -1170,6 +1406,8 @@ void cxl_mem_get_event_records(struct cxl_memdev_state *mds, u32 status)
 {
 	dev_dbg(mds->cxlds.dev, "Reading event logs: %x\n", status);
 
+	if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
+		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
 	if (status & CXLDEV_EVENT_STATUS_FATAL)
 		cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
 	if (status & CXLDEV_EVENT_STATUS_FAIL)
@@ -1771,6 +2009,7 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 						 u16 dvsec)
 {
 	struct cxl_memdev_state *mds;
+	int rc;
 
 	mds = devm_cxl_dev_state_create(dev, CXL_DEVTYPE_CLASSMEM, serial,
 					dvsec, struct cxl_memdev_state, cxlds,
@@ -1781,6 +2020,11 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
 	}
 
 	mutex_init(&mds->event.log_lock);
+	INIT_LIST_HEAD(&mds->dc_chain.pending_extents);
+
+	rc = devm_add_action_or_reset(dev, clear_pending_extents, mds);
+	if (rc)
+		return ERR_PTR(rc);
 
 	return mds;
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index c379d60047fc..64c6ce0878e2 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -177,7 +177,8 @@ TRACE_EVENT(cxl_aer_correctable_error,
 		{ CXL_EVENT_TYPE_INFO, "Informational" },	\
 		{ CXL_EVENT_TYPE_WARN, "Warning" },		\
 		{ CXL_EVENT_TYPE_FAIL, "Failure" },		\
-		{ CXL_EVENT_TYPE_FATAL, "Fatal" })
+		{ CXL_EVENT_TYPE_FATAL, "Fatal" },		\
+		{ CXL_EVENT_TYPE_DCD, "Dynamic Capacity" })
 
 TRACE_EVENT(cxl_overflow,
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index d098f7f50bef..64138e1768a1 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -12,6 +12,7 @@
 #include <linux/node.h>
 #include <linux/io.h>
 #include <linux/range.h>
+#include <linux/xarray.h>
 #include <cxl/cxl.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
@@ -557,6 +558,14 @@ struct cxl_pmem_region {
 	struct cxl_pmem_region_mapping mapping[];
 };
 
+/* See CXL r4.0 8.2.10.2.1.6 */
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
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 35268d1c387c..c88de7cb65d1 100644
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
@@ -426,6 +427,24 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
 	return dev_get_drvdata(cxl_mbox->host);
 }
 
+/**
+ * struct cxl_dc_event_chain - staged Dynamic Capacity event chain
+ * @pending_extents: extents received so far; flushed when the chain
+ *		     closes (More=0)
+ * @event_type: DCD event type of the open chain (add or release)
+ *
+ * The records of one Dynamic Capacity operation can be chained by the
+ * CXL_DCD_EVENT_MORE flag.  Chained records are contiguous in the event
+ * log and share one event type (CXL r4.0 Table 8-229), so at most one
+ * chain is open at a time.  Both Add Capacity and Release Capacity chains
+ * are staged here, @event_type says which.  Records are staged until
+ * More=0, then the chain is processed and responded to as a whole.
+ */
+struct cxl_dc_event_chain {
+	struct list_head pending_extents;
+	u8 event_type;
+};
+
 /**
  * struct cxl_memdev_state - Generic Type-3 Memory Device Class driver data
  *
@@ -444,6 +463,8 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
  * @dcd_supported: all DCD commands are supported
+ * @dc_chain: the open Dynamic Capacity event chain, if any
+ *	      (see &struct cxl_dc_event_chain)
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -463,6 +484,7 @@ struct cxl_memdev_state {
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
 	bool dcd_supported;
+	struct cxl_dc_event_chain dc_chain;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -538,6 +560,21 @@ enum cxl_opcode {
 	UUID_INIT(0x5e1819d9, 0x11a9, 0x400c, 0x81, 0x1f, 0xd6, 0x07, 0x19,     \
 		  0x40, 0x3d, 0x86)
 
+/*
+ * Add Dynamic Capacity Response
+ * CXL r4.0 Section 8.2.10.9.9.3; Table 8-350 & Table 8-351
+ */
+struct cxl_mbox_dc_response {
+	__le32 extent_list_size;
+	u8 flags;
+	u8 reserved[3];
+	struct updated_extent_list {
+		__le64 dpa_start;
+		__le64 length;
+		u8 reserved[8];
+	} __packed extent_list[] __counted_by_le(extent_list_size);
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
@@ -608,6 +645,14 @@ struct cxl_mbox_identify {
 	UUID_INIT(0xe71f3a40, 0x2d29, 0x4092, 0x8a, 0x39, 0x4d, 0x1c, 0x96, \
 		  0x6c, 0x7c, 0x65)
 
+/*
+ * Dynamic Capacity Event Record
+ * CXL r4.0 section 8.2.10.2.1; Table 8-221
+ */
+#define CXL_EVENT_DC_EVENT_UUID                                             \
+	UUID_INIT(0xca95afa7, 0xf183, 0x4018, 0x8c, 0x2f, 0x95, 0x26, 0x8e, \
+		  0x10, 0x1a, 0x2a)
+
 /*
  * Get Event Records output payload
  * CXL rev 3.0 section 8.2.9.2.2; Table 8-50
@@ -633,6 +678,7 @@ enum cxl_event_log_type {
 	CXL_EVENT_TYPE_WARN,
 	CXL_EVENT_TYPE_FAIL,
 	CXL_EVENT_TYPE_FATAL,
+	CXL_EVENT_TYPE_DCD,
 	CXL_EVENT_TYPE_MAX
 };
 
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 3ed7c3e70042..29541b8f79f2 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -510,12 +510,20 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
 	return true;
 }
 
-/* Event logs the driver drains: standard logs when native_cxl */
-static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
+/*
+ * Event logs the driver drains: standard logs when native_cxl, DCD when
+ * supported.
+ */
+static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge,
+				struct cxl_memdev_state *mds)
 {
+	u32 mask = 0;
+
 	if (host_bridge->native_cxl_error)
-		return CXLDEV_EVENT_STATUS_STANDARD_LOGS;
-	return 0;
+		mask |= CXLDEV_EVENT_STATUS_STANDARD_LOGS;
+	if (cxl_dcd_supported(mds))
+		mask |= CXLDEV_EVENT_STATUS_DCD;
+	return mask;
 }
 
 static irqreturn_t cxl_event_thread(int irq, void *id)
@@ -525,7 +533,7 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
 	struct pci_host_bridge *host_bridge =
 		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
-	u32 mask = cxl_event_drain_mask(host_bridge);
+	u32 mask = cxl_event_drain_mask(host_bridge, mds);
 	bool handled = false;
 	u32 status;
 
@@ -786,7 +794,7 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	mask = cxl_event_drain_mask(host_bridge);
+	mask = cxl_event_drain_mask(host_bridge, mds);
 	if (mask)
 		cxl_mem_get_event_records(mds, mask);
 
diff --git a/include/cxl/event.h b/include/cxl/event.h
index a9f5c2381cc9..f154ca952340 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -6,6 +6,7 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/workqueue_types.h>
+#include <linux/list.h>
 
 /*
  * Common Event Record Format
@@ -141,12 +142,48 @@ struct cxl_event_mem_sparing {
 	u8 reserved2[0x25];
 } __packed;
 
+/*
+ * CXL r4.0 section 8.2.10.2.1.6; Table 8-230
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
+};
+
+/*
+ * Dynamic Capacity Event Record
+ * CXL r4.0 section 8.2.10.2.1.6; Table 8-229
+ */
+#define CXL_DCD_EVENT_MORE			BIT(0)
+struct cxl_event_dcd {
+	struct cxl_event_record_hdr hdr;
+	u8 event_type;
+	u8 validity_flags;
+	__le16 host_id;
+	u8 updated_region_index;
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

