Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FE3859C2
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529426; cv=none; b=DFBI+f86fkPptSFTuOytmEpClNF0NkxXxbZbokunqnuWkyTRCIgwgsIO9dG3snxCnA8pDpzhECHGPYSEWlyWQ9SIn6ehsUyZKeJCzHUloVNeRowqaPg9WVSL3gdc2g2ZBSqiyYYQhr/+ugQ8V0NDKiRqB30V86Vmr9au4Fcf9y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529426; c=relaxed/simple;
	bh=kE5rNago1b+pyJpsmlKzqPBUNfF637c14Fgd6EpHYHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru8lM9pR+Lv0jywl9x5J51NVrzSO5w5ZyfdoDkb89ofd5IgWKpmcpsQ7lnIJZw522X5hihMdTLEFIAHh3JNjOnHbNDDB3rVmNq2Z5sen92J6wff11o2bq6upWpHM0HsPaisbJz8wzHGtdHFvARF7p7ipTIAx2euLuqUxVBMXh84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMqMX2YI; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMqMX2YI"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-304545e6c7fso1512357eec.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529422; x=1780134222; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWos/AalbO5utJ9gJ5N4ZBriXQ8AKrI8xdpp7eapkB0=;
        b=iMqMX2YIrP3pSNNA4fb4hULifS7IGGdYqWk5S8pDzO9X2MNZc0aPui8531n5xXTyFf
         iTdkQLBXPmeZIu/BGU+/ftJF4PY5Cf56fRsxL3UoYrdkToasxlTGy00xLzn6Cu5gB925
         NfXpGdhEdV/dz7zxASZU45u+uA81d/dMlTYFlVuEzeu2eE8F56GgM6D4rt13nkmSDWJD
         LyN7r6jYA/IVxEJE4gXJgkJ/pHl1o1yx9Ht/3236ZJOI8HzRq1Hdo/lK2ICUwqdje6fl
         auux1dhCPylACKP09OirmX0tnhVRpwQ4pfhy0E99vnjtc5rNTmfL/8l0u8gCsi/9uA6+
         gySA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529422; x=1780134222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWos/AalbO5utJ9gJ5N4ZBriXQ8AKrI8xdpp7eapkB0=;
        b=G9KodcKn8T16vG3x7qFgL9hkpBFh/vxobRC14i8qpJXdStoLr7/u44fqbK2B7vDUr7
         /BPNO8/ybaEUJEffp2jMaGxMCzZs9yYg6QBSZNkQbrtw7XidhBPYSMu0WIERQGbYSfg7
         9X+YXHD1hu5dwlrrgQbrMDHeu+HVMvxlCgXIq2s+tUolpSVYW9M5e8+DqnlHq48uPBOA
         H7XtsC7PmNytHIEgH4Xclcd7Dp7HX6qhilAs7UMZYM8sv3Hwqga328+7bsHdJBLQkIMX
         Obpc16fH3HwjVhLlmgrLXjVQgXSgPADIzZmb7ehCKjWzPk0E3dnj1cJEUeFXXTaBQVOE
         wB6g==
X-Gm-Message-State: AOJu0YzHg6e0t+Ur8qRo+4fXcXd2OJc6H2U4KyuHCqw4dgRQocl+k/EJ
	waXazPsD2pRlVIPPOp6sLRki7Xt5nTX29wfONeEdI+6BDL4IN0AUxuBY
X-Gm-Gg: Acq92OEpmZK3TNWwUPNHbUw9dtb2I6QvaJ8XLndHL25HzoYnvLHHhY7gWAqz4kvzf2f
	qQ9tI/Tts/tS8p6MsxLRcjALrz8/hzgOhyLNb4bOKd90Fe2yR+FuRYEbgDLJAg1ppB2lbjjEJI0
	xcNWZNS2tjjplcQoizQY+MKvm14f1RUwNH2UFP+ThFI8lQ7N9/ArHafdYRezr/58X7f1f2Rqt70
	9xqhMIqC52SFbmCCyobqDo/3sK41gzGvpiJnocEiGAlQ61Uu2zFnmHvN8qZske3aXQDi02rqQRQ
	szKj5ajKezu3nuEfm07C5EXFYy08tS1YoHjkP03/uV42A4/5kWd4kjCPL2IEZtzsqjuVd6h8DoV
	rFVscDmNDfC+QMx2vg3tGTzyGrlPgLj8xr1hoaPo7BqbvMlnE4YKVMfwAx5BAB7/Ib4cqW21GI5
	QlLxw45Z3/f6JwyvOtMw27gUQgx1fRmth5YOYtNXZGJYNlgijEVq6yeBwkIerOolewP+jRuhoXH
	L1K2xw=
X-Received: by 2002:a05:701b:290a:b0:12d:de3e:be88 with SMTP id a92af1059eb24-1365fc6d91cmr1288421c88.36.1779529422248;
        Sat, 23 May 2026 02:43:42 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:41 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 03/31] cxl/cdat: Gather DSMAS data for DCD partitions
Date: Sat, 23 May 2026 02:42:57 -0700
Message-ID: <f7800561164a891513a20381378f2ff052d29288.1779528761.git.anisa.su@samsung.com>
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

Additional DCD partition (AKA region) information is contained in the
DSMAS CDAT tables, including performance, read only, and shareable
attributes.

Match DCD partitions with DSMAS tables and store the meta data.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
[jonathan: core/mbox.c: error if there are non-zero reserved bits in DSMAD
handle in cxl_dc_check]
---
 drivers/cxl/core/cdat.c | 11 +++++++++++
 drivers/cxl/core/mbox.c |  7 +++++++
 drivers/cxl/cxlmem.h    |  2 ++
 include/cxl/cxl.h       |  4 ++++
 4 files changed, 24 insertions(+)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 5c9f07262513..c5f3d2ebea55 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -17,6 +17,7 @@ struct dsmas_entry {
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int entries;
 	int qos_class;
+	bool shareable;
 };
 
 static u32 cdat_normalize(u16 entry, u64 base, u8 type)
@@ -74,6 +75,7 @@ static int cdat_dsmas_handler(union acpi_subtable_headers *header, void *arg,
 		return -ENOMEM;
 
 	dent->handle = dsmas->dsmad_handle;
+	dent->shareable = dsmas->flags & ACPI_CDAT_DSMAS_SHAREABLE;
 	dent->dpa_range.start = le64_to_cpu((__force __le64)dsmas->dpa_base_address);
 	dent->dpa_range.end = le64_to_cpu((__force __le64)dsmas->dpa_base_address) +
 			      le64_to_cpu((__force __le64)dsmas->dpa_length) - 1;
@@ -244,6 +246,7 @@ static void update_perf_entry(struct device *dev, struct dsmas_entry *dent,
 		dpa_perf->coord[i] = dent->coord[i];
 		dpa_perf->cdat_coord[i] = dent->cdat_coord[i];
 	}
+	dpa_perf->shareable = dent->shareable;
 	dpa_perf->dpa_range = dent->dpa_range;
 	dpa_perf->qos_class = dent->qos_class;
 	dev_dbg(dev,
@@ -266,13 +269,21 @@ static void cxl_memdev_set_qos_class(struct cxl_dev_state *cxlds,
 		bool found = false;
 
 		for (int i = 0; i < cxlds->nr_partitions; i++) {
+			enum cxl_partition_mode mode = cxlds->part[i].mode;
 			struct resource *res = &cxlds->part[i].res;
+			u8 handle = cxlds->part[i].handle;
 			struct range range = {
 				.start = res->start,
 				.end = res->end,
 			};
 
 			if (range_contains(&range, &dent->dpa_range)) {
+				if (mode == CXL_PARTMODE_DYNAMIC_RAM_A &&
+				    dent->handle != handle)
+					dev_warn(dev,
+						"Dynamic RAM perf mismatch; %pra (%u) vs %pra (%u)\n",
+						&range, handle, &dent->dpa_range, dent->handle);
+
 				update_perf_entry(dev, dent,
 						  &cxlds->part[i].perf);
 				found = true;
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 71b29cd6abfe..f9a5e21f5d09 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1356,10 +1356,16 @@ static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_a
 {
 	size_t blk_size = le64_to_cpu(dev_part->block_size);
 	size_t len = le64_to_cpu(dev_part->length);
+	u32 handle = le32_to_cpu(dev_part->dsmad_handle);
 
 	part_array[index].start = le64_to_cpu(dev_part->base);
 	part_array[index].size = le64_to_cpu(dev_part->decode_length);
 	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
+	if (handle & ~0xFF) {
+		dev_warn(dev, "DSMAD handle 0x%x has non-zero reserved bits\n", handle);
+		return -EINVAL;
+	}
+	part_array[index].handle = handle;
 
 	/* Check partitions are in increasing DPA order */
 	if (index > 0) {
@@ -1494,6 +1500,7 @@ int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
 	/* Return 1st partition */
 	dc_info->start = partitions[0].start;
 	dc_info->size = partitions[0].size;
+	dc_info->handle = partitions[0].handle;
 	dev_dbg(dev, "Returning partition 0 %zu size %zu\n",
 		dc_info->start, dc_info->size);
 
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 87386488ad10..cee936fb3d03 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -118,6 +118,7 @@ struct cxl_dpa_info {
 	struct cxl_dpa_part_info {
 		struct range range;
 		enum cxl_partition_mode mode;
+		u8 handle;
 	} part[CXL_NR_PARTITIONS_MAX];
 	int nr_partitions;
 };
@@ -818,6 +819,7 @@ int cxl_dev_state_identify(struct cxl_memdev_state *mds);
 struct cxl_dc_partition_info {
 	size_t start;
 	size_t size;
+	u8 handle;
 };
 
 int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index bb1df0cef863..51685a01d19c 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -122,12 +122,14 @@ struct cxl_register_map {
  * @coord: QoS performance data (i.e. latency, bandwidth)
  * @cdat_coord: raw QoS performance data from CDAT
  * @qos_class: QoS Class cookies
+ * @shareable: Is the range sharable
  */
 struct cxl_dpa_perf {
 	struct range dpa_range;
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct access_coordinate cdat_coord[ACCESS_COORDINATE_MAX];
 	int qos_class;
+	bool shareable;
 };
 
 enum cxl_partition_mode {
@@ -141,11 +143,13 @@ enum cxl_partition_mode {
  * @res: shortcut to the partition in the DPA resource tree (cxlds->dpa_res)
  * @perf: performance attributes of the partition from CDAT
  * @mode: operation mode for the DPA capacity, e.g. ram, pmem, dynamic...
+ * @handle: DSMAS handle intended to represent this partition
  */
 struct cxl_dpa_partition {
 	struct resource res;
 	struct cxl_dpa_perf perf;
 	enum cxl_partition_mode mode;
+	u8 handle;
 };
 
 #define CXL_NR_PARTITIONS_MAX 3
-- 
2.43.0

