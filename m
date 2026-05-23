Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47FD3911D2
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529472; cv=none; b=kg1PPeujFsAOQWqbrB2YxkN0aHtUaq4YD0pdUZAKYXhUyvToyIfh9wlDvBSk/ISDgMVB0GHUXtdB2cfaAzcQjmWOOG2cKSTmdsi5u0NTrLJzSXFLkVYWH5su3P1iescOExUplVUE88uc2PpZF5Xc3Ev1oKyoOblqRaxVpxwotsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529472; c=relaxed/simple;
	bh=JPCMU4iD/OhP7hoGghQn0xJwqOz/NcDzAZp6Xaopfi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFeXlf13RkwS/fzH6aqOgR4xK2f+4bn82zMPXYYZfHiwqb80+8jqlzSfSpjTkckr4/QLk33qZdvBLTeIokWwKa8BDYMw3HFoIWC26zajLDvVrSethEiR+rNMTfQnvJ4oJMCHhJ3iwv+696joItE5SEbdMSeiYTUJJwn3rAldEHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERmmWttY; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERmmWttY"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1329fc4bf77so2964265c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529469; x=1780134269; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/w4XKguC5ZxUtQmxS7Ocj+WzmWedODSvERTnM77yobw=;
        b=ERmmWttY8uqVt5WjIGPQJLffK0H8DlA9Z23azrIn4r9OviHlIbvMZacy3VgzOqiGf/
         xfi1aQXTeM/JaMYPKxB/K+wmP8L/L7FkwguOvrFqZg61LH0GSuCUaxCbPSs5PNM7c3No
         SPAj88Gt3lKbdyJXI35rQZwjj6y0o6hzWA4qYaA5BxTs/I9O5f/BPxZnzpq3OWY5uifv
         riRanZSEMkfs0RFFVLE13l92LgLM+65geNByrT1Kv6C8SKOPMzYfW50RQe7M7JdCDGao
         8UXQL1uNS9mr/5jVjmxKkwmLQemeOT+PdNyTGjhbjEFqUZ5OTTgtxzb6tGOb+o108Be+
         fgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529469; x=1780134269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/w4XKguC5ZxUtQmxS7Ocj+WzmWedODSvERTnM77yobw=;
        b=mde9PTvmnClAp/9J5KzNwi9RGNvl/Re2wt9JEoIGfGza7TTaW4bpxZkNZIKlNAK/73
         w81qhwxDqBUbYTjbEiJqSRmAi8NmvcUnbn83wI29VSVvQSjqiKlHrw4xbOEw5HLiyVeb
         YUS8olA0Sjg1MP6dQOYnEbRuDnfCpa40WcXV3FkkITrSAsReJKXE5v3CTjZEohINFNFH
         kjeqOk+0mU2ONfH0dk+0i5KWm4RhAHf0FNQI8wREMorRXOBFTOrzMimQfZZIhArQtTfy
         jqHRyzHXb60h3fTRejGLth3DsMRbHF1nDAvD99Vxpb6YgeybAQicIgsR3st22gM5b/Iz
         clhw==
X-Gm-Message-State: AOJu0YzmB2IjuF9V/6mF99hBe983sj30HQETjoUUE86OyyKsy9AkHAR7
	9/bhE+PEXNM1CWWzBQdBjsPHA5tgXdT92iVcfVTyuOmS76xo2/yrkgpT
X-Gm-Gg: Acq92OGafjnjYC9MnAnX9goGBVxjcoCk9hfOtmaUJpdrp3RbWoyeHaWFcbj4URUS8BB
	XiAjAEElht0RcYyTAMvx6UqP5wOJpFKk9rYFEeTd4OnJGszUYO9kRBmjEaxejmNInA6amHMpUwT
	Lye8CU6IJGIOIORKBNfH8z2xbtTY2dqpD3QzibmckrJVnxkRbkyYPclvcI3UNqgYGb7WvkOsjFZ
	928Ss16VLu/iyctKEdd755M8cZRB9AvAFubS6bKrO8ClfmPEZJN7OkWAGOdh3GiVcnFcKSqTmXH
	4WPGCAQqwEAQ84cuvdXrYyamRq3zgic7XNVMGs+WbEuBxaclH0z3e4NvN26hEnHSizGAFvYovkO
	9HFMRdNoyRAf8Bmvx1RjYlD4StC5wjxswpI1gJ8TVJCmSv+dIDbq2mAx9nK4DagLcP5+ZzqldbZ
	rZtNe92FtPRM8hypp8O+GTnrXh7gB+hdQ7qlXBgCtmQrxIUyG10SE4LRTQ04JH5B6Q2O9lS5KYh
	lKHE/I=
X-Received: by 2002:a05:7022:ef06:b0:12d:b66f:35d7 with SMTP id a92af1059eb24-1365f820d0emr2667680c88.10.1779529468827;
        Sat, 23 May 2026 02:44:28 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:28 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [PATCH v10 27/31] cxl/region: Read existing extents on region creation
Date: Sat, 23 May 2026 02:43:21 -0700
Message-ID: <ec8d257b53053061d70ca0b30408be116d479a03.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Dynamic capacity device extents may be left in an accepted state on a
device due to an unexpected host crash.  In this case it is expected
that the creation of a new region on top of a DC partition can read
those extents and surface them for continued use.

Once all endpoint decoders are part of a region and the region is being
realized, a read of the 'devices extent list' can reveal these
previously accepted extents.

CXL r3.1 specifies the mailbox call Get Dynamic Capacity Extent List for
this purpose.  The call returns all the extents for all dynamic capacity
partitions.  If the fabric manager is adding extents to any DCD
partition, the extent list for the recovered region may change.  In this
case the query must retry.  Upon retry the query could encounter extents
which were accepted on a previous list query.  Adding such extents is
ignored without error because they are entirely within a previous
accepted extent.  Instead warn on this case to allow for differentiating
bad devices from this normal condition.

Latch any errors to be bubbled up to ensure notification to the user
even if individual errors are rate limited or otherwise ignored.

The scan for existing extents races with the dax_cxl driver.  This is
synchronized through the region device lock.  Extents which are found
after the driver has loaded will surface through the normal notification
path while extents seen prior to the driver are read during driver load.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/core.h       |   1 +
 drivers/cxl/core/mbox.c       | 116 ++++++++++++++++++++++++++++++++++
 drivers/cxl/core/region_dax.c |  27 ++++++++
 drivers/cxl/cxlmem.h          |  21 ++++++
 4 files changed, 165 insertions(+)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index c28e357c5817..f5b05de5ed83 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -28,6 +28,7 @@ cxled_to_mds(struct cxl_endpoint_decoder *cxled)
 	return container_of(cxlds, struct cxl_memdev_state, cxlds);
 }
 
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled);
 int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
 
 #ifdef CONFIG_CXL_REGION
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 8071c1ed1b36..486110e1c03d 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -2083,6 +2083,122 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
 
+/* Return -EAGAIN if the extent list changes while reading */
+static int __cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	u32 current_index, total_read, total_expected, initial_gen_num;
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	struct device *dev = mds->cxlds.dev;
+	struct cxl_mbox_cmd mbox_cmd;
+	u32 max_extent_count;
+	int latched_rc = 0;
+	bool first = true;
+
+	struct cxl_mbox_get_extent_out *extents __free(kvfree) =
+				kvmalloc(cxl_mbox->payload_size, GFP_KERNEL);
+	if (!extents)
+		return -ENOMEM;
+
+	total_read = 0;
+	current_index = 0;
+	total_expected = 0;
+	max_extent_count = (cxl_mbox->payload_size - sizeof(*extents)) /
+				sizeof(struct cxl_extent);
+	do {
+		u32 nr_returned, current_total, current_gen_num;
+		struct cxl_mbox_get_extent_in get_extent;
+		int rc;
+
+		get_extent = (struct cxl_mbox_get_extent_in) {
+			.extent_cnt = cpu_to_le32(max(max_extent_count,
+						  total_expected - current_index)),
+			.start_extent_index = cpu_to_le32(current_index),
+		};
+
+		mbox_cmd = (struct cxl_mbox_cmd) {
+			.opcode = CXL_MBOX_OP_GET_DC_EXTENT_LIST,
+			.payload_in = &get_extent,
+			.size_in = sizeof(get_extent),
+			.size_out = cxl_mbox->payload_size,
+			.payload_out = extents,
+			.min_out = 1,
+		};
+
+		rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
+		if (rc < 0)
+			return rc;
+
+		/* Save initial data */
+		if (first) {
+			total_expected = le32_to_cpu(extents->total_extent_count);
+			initial_gen_num = le32_to_cpu(extents->generation_num);
+			first = false;
+		}
+
+		nr_returned = le32_to_cpu(extents->returned_extent_count);
+		total_read += nr_returned;
+		current_total = le32_to_cpu(extents->total_extent_count);
+		current_gen_num = le32_to_cpu(extents->generation_num);
+
+		dev_dbg(dev, "Got extent list %d-%d of %d generation Num:%d\n",
+			current_index, total_read - 1, current_total, current_gen_num);
+
+		if (current_gen_num != initial_gen_num || total_expected != current_total) {
+			dev_warn(dev, "Extent list change detected; gen %u != %u : cnt %u != %u\n",
+				 current_gen_num, initial_gen_num,
+				 total_expected, current_total);
+			return -EAGAIN;
+		}
+
+		for (int i = 0; i < nr_returned ; i++) {
+			struct cxl_extent *extent = &extents->extent[i];
+
+			dev_dbg(dev, "Processing extent %d/%d\n",
+				current_index + i, total_expected);
+
+			rc = add_to_pending_list(&mds->add_ctx.pending_extents,
+						 extent);
+			if (rc) {
+				latched_rc = rc;
+			}
+		}
+
+		current_index += nr_returned;
+	} while (total_expected > total_read);
+
+	if (!latched_rc && !list_empty(&mds->add_ctx.pending_extents)) {
+		latched_rc = cxl_add_pending(mds);
+	}
+	clear_pending_extents(mds);
+
+	return latched_rc;
+}
+
+#define CXL_READ_EXTENT_LIST_RETRY 10
+
+/**
+ * cxl_process_extent_list() - Read existing extents
+ * @cxled: Endpoint decoder which is part of a region
+ *
+ * Issue the Get Dynamic Capacity Extent List command to the device
+ * and add existing extents if found.
+ *
+ * A retry of 10 is somewhat arbitrary, however, extent changes should be
+ * relatively rare while bringing up a region.  So 10 should be plenty.
+ */
+int cxl_process_extent_list(struct cxl_endpoint_decoder *cxled)
+{
+	int retry = CXL_READ_EXTENT_LIST_RETRY;
+	int rc;
+
+	do {
+		rc = __cxl_process_extent_list(cxled);
+	} while (rc == -EAGAIN && retry--);
+
+	return rc;
+}
+
 static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
 {
 	int i = info->nr_partitions;
diff --git a/drivers/cxl/core/region_dax.c b/drivers/cxl/core/region_dax.c
index 519e203c486a..e7a812e8b2e7 100644
--- a/drivers/cxl/core/region_dax.c
+++ b/drivers/cxl/core/region_dax.c
@@ -82,6 +82,26 @@ static void cxlr_dax_unregister(void *_cxlr_dax)
 	device_unregister(&cxlr_dax->dev);
 }
 
+static int cxlr_add_existing_extents(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int i, latched_rc = 0;
+
+	for (i = 0; i < p->nr_targets; i++) {
+		struct device *dev = &p->targets[i]->cxld.dev;
+		int rc;
+
+		rc = cxl_process_extent_list(p->targets[i]);
+		if (rc) {
+			dev_err(dev, "Existing extent processing failed %d\n",
+				rc);
+			latched_rc = rc;
+		}
+	}
+
+	return latched_rc;
+}
+
 int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 {
 	struct device *dev;
@@ -110,6 +130,13 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
 		dev_name(dev));
 
+	if (cxlr->mode == CXL_PARTMODE_DYNAMIC_RAM_A) {
+		rc = cxlr_add_existing_extents(cxlr);
+		if (rc)
+			dev_err(&cxlr->dev,
+				"Existing extent processing failed %d\n", rc);
+	}
+
 	return devm_add_action_or_reset(&cxlr->dev, cxlr_dax_unregister,
 					no_free_ptr(cxlr_dax));
 }
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index d992cc9b7811..1ad3dc7e413c 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -564,6 +564,27 @@ struct cxl_mbox_dc_response {
 	} __packed extent_list[] __counted_by(extent_list_size);
 } __packed;
 
+/*
+ * Get Dynamic Capacity Extent List; Input Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-166
+ */
+struct cxl_mbox_get_extent_in {
+	__le32 extent_cnt;
+	__le32 start_extent_index;
+} __packed;
+
+/*
+ * Get Dynamic Capacity Extent List; Output Payload
+ * CXL rev 3.1 section 8.2.9.9.9.2; Table 8-167
+ */
+struct cxl_mbox_get_extent_out {
+	__le32 returned_extent_count;
+	__le32 total_extent_count;
+	__le32 generation_num;
+	u8 rsvd[4];
+	struct cxl_extent extent[];
+} __packed;
+
 struct cxl_mbox_get_supported_logs {
 	__le16 entries;
 	u8 rsvd[6];
-- 
2.43.0

