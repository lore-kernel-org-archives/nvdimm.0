Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED03DE42E
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386960; cv=none; b=WIeoJx3jONeLN25vhoZ8R/zDNDXmOZAGnL4c0TX3wfQWRULKtF60lU7MEEkoWB17y1v9j9ewBysKhd+vMJibiReFXxPeFQnc4JrXc8ND0jF4Mb0aAx0dlQUEEjwuvQclPAasm3kj4tP4kE2rSkSfbr81AI0yaptNevcjNrQfHOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386960; c=relaxed/simple;
	bh=chD7x9yk1oGS169yPVmjtacgw/R/kTwihTIYktQBQ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=arh7gCE9XPGKjkbPNGbdbNDcCmbT+pGM28TRoGatijOKQRGSTUwksGYh3255FZ4TPFbs6BPh/7Y82pcftj4gJwj9EPuMSpDx7ugmuPcVOpFQecxaZm3hmVUQO8vDkoc5Ifjnh+UwQsR2m3i99jWsUq2FnArNzCJn8Di2rCY2LwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UpIONhCd; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpIONhCd"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30b9e755555so4752635eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386957; x=1782991757; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YCJEPL5+cgIgcmM4KrHETnu+gJnj5YLmHMa9zOTHh8w=;
        b=UpIONhCd9W8Kzhiz7F+fMhz9/YLEFUO+d5K2xtBu5pr198RzaZTs2rbXIyzPh9vq18
         eIYpN52XOsZ4fJf8K29mI1x7Bdb/yKnj5CnPLGUEeIOK+AKGea9t3bTsn9Wpn1XfrkcJ
         E7o3scnK64XX6OOlm+vDUilXLX2sx3QfUEokSlpInn+FqlLwrcxl1ZtnM/VRWuwIgChI
         wzvkRaqqmnxFW3eGq/V74SMhZT1zeYKvX+dqTtmkKSfM8scm1XESX5xnxd9C7m6HvC3A
         MN1ay6fCYXtl0s+bKmQViZ2g+G7Q6ASA3dJMlwFap9D+E8T5QRp/zZaX6/0uB1LxdEMn
         nBYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386957; x=1782991757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YCJEPL5+cgIgcmM4KrHETnu+gJnj5YLmHMa9zOTHh8w=;
        b=Op5OZn+HcgbhmPBYyA4Dn3ycdMrwPBbAzGqdA9EfIR0iuX2Ik80Fcm0DQMoGJUDKqD
         cgDHLQAO+VcAfICArTf9Q+o5f+vme49ljsUBDJU9/SsfMSDFh7WXBRc0omOxsIwllGHe
         IL6SwG50T+UjtcxTrhtg4sB+l0hQmBJvPyfv4PnmIyUGSDUnXjRGJxKGXATjoDKO0yk4
         7T5Kqxb7Q26/ydpDPhl+I4jXdVL9bcUYJzwj763hVAsx98SDQuLPcP8UZYSBu9eDO8oa
         RMYkcRuPyxjG/OMZF0kcxFPxZaAbcutY3fqnwRX2oZEqqKmAabTkgyXe6VutosJZMVd5
         ASvQ==
X-Gm-Message-State: AOJu0YycZJWvJgd1VBWgUGSL9z0/eawmzUVcPtX2XqLHZRbQVW3SxAMY
	g46kEDzRiMiTYwzSQlOuzkQp05wZqCV7J1Piq2QNYJ8vzNWeYuZscmp/
X-Gm-Gg: AfdE7cnsCNQBeHhNicEgH1PurCYYHsFGkr36RySSA4K+a3kOA+wYVXry9sQfkr8/apq
	DVF2owZ9NfJ1V0KLttQMAHv0o/v9ZPkGtsaHqn9hKLHCYfmUy6+9oUCeJIOXLv3xv88yrIoA0x/
	+xziVt1pAsIZwrGGpakgHoqopEpA9fF2jgw4YvjqgV76NVmdTJGjGLmvWyWyjZYC7Dei/JfMAYA
	cdegpSNH5F2S5j8PX168RZ6I4tvO1g+qGOr9a8W5lNpOMQY0sw4ea/97TAZ0iFZIaw0CtWogQIq
	LXyP9tIuxY4oHzUdU8X3U3DnYbSjiGar+fQusNQSFC61AOXbeYZVsEz26by+Cpudkc6cKiPj+pT
	NBHRPVbXkYPBY9LUEFoxOQaw3uLDoXB5GlL0lNN4UoZC96CBvgZklr9Sn29Xp5CwgctGS2I036s
	cuAIezXfJumue2TuzWj2up/ygvdspOPUbbKY9bY8OEIAfRVxPd10B9kX0X/JLykgkVAxCL
X-Received: by 2002:a05:7300:8190:b0:304:e2a5:689a with SMTP id 5a478bee46e88-30c84dae80cmr2408126eec.21.1782386956577;
        Thu, 25 Jun 2026 04:29:16 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:16 -0700 (PDT)
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
Subject: [PATCH v11 30/31] tools/testing/cxl: Add DC Regions to mock mem data
Date: Thu, 25 Jun 2026 04:05:07 -0700
Message-ID: <20260625112638.550691-31-anisa.su@samsung.com>
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

cxl_test provides a good way to ensure quick smoke and regression
testing.  The complexity of Dynamic Capacity (DC) extent processing as
well as the complexity of DC-backed DAX regions can mostly be tested
through cxl_test.  This includes management of DC regions and DAX
devices on those regions; the management of extent device lifetimes;
and the processing of DCD events.

The only missing functionality from this test is actual interrupt
processing.

Mock memory devices can easily mock DC information and manage fake
extent data.

Define mock_dc_partition information within the mock memory data.  Add
sysfs entries on the mock device to inject and delete extents.

The inject format is <start>:<length>:<tag>:<more>[:<seq>] where <tag>
is a UUID string (or "" / "0" for the null UUID) and <seq> is an
optional shared_extn_seq value used for sharable-partition tests
(defaults to 0).
The delete format is <start>:<length>:<uuid>

Directly call the event irq callback to simulate irqs to process the
test extents.

Add DC mailbox commands to the CEL and implement those commands.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
---
 tools/testing/cxl/test/cxl.c  |  12 +
 tools/testing/cxl/test/mem.c  | 825 +++++++++++++++++++++++++++++++++-
 tools/testing/cxl/test/mock.h |   9 +
 3 files changed, 845 insertions(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 296516eecfd6..993f79175aa1 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -1432,6 +1432,18 @@ static void mock_cxl_endpoint_parse_cdat(struct cxl_port *port)
 		};
 
 		dpa_perf_setup(port, &range, perf);
+
+		/*
+		 * The mock probe stamps MOCK_DC_SHARABLE_SERIAL onto exactly
+		 * one cxl_mem instance; mark its DC partition sharable so
+		 * cxl_validate_extent() routes shared-seq injects through
+		 * the sharable regime.  Every other memdev keeps its DC
+		 * partition non-sharable so the existing untagged / seq=0
+		 * tests still run on this kernel.
+		 */
+		if (cxlds->part[i].mode == CXL_PARTMODE_DYNAMIC_RAM_1 &&
+		    cxlds->serial == MOCK_DC_SHARABLE_SERIAL)
+			cxlds->part[i].shareable = true;
 	}
 
 	cxl_memdev_update_perf(cxlmd);
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index a2bfd52db076..455f8a50d581 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -13,6 +13,7 @@
 #include <crypto/sha2.h>
 #include <cxlmem.h>
 
+#include "mock.h"
 #include "trace.h"
 
 #define LSA_SIZE SZ_128K
@@ -20,6 +21,7 @@
 #define FW_SLOTS 3
 #define DEV_SIZE SZ_2G
 #define EFFECT(x) (1U << x)
+#define BASE_DYNAMIC_CAP_DPA DEV_SIZE
 
 #define MOCK_INJECT_DEV_MAX 8
 #define MOCK_INJECT_TEST_MAX 128
@@ -113,6 +115,22 @@ static struct cxl_cel_entry mock_cel[] = {
 				      EFFECT(SECURITY_CHANGE_IMMEDIATE) |
 				      EFFECT(BACKGROUND_OP)),
 	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_CONFIG),
+		.effect = CXL_CMD_EFFECT_NONE,
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_GET_DC_EXTENT_LIST),
+		.effect = CXL_CMD_EFFECT_NONE,
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_ADD_DC_RESPONSE),
+		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
+	},
+	{
+		.opcode = cpu_to_le16(CXL_MBOX_OP_RELEASE_DC),
+		.effect = cpu_to_le16(EFFECT(CONF_CHANGE_IMMEDIATE)),
+	},
 };
 
 /* See CXL 2.0 Table 181 Get Health Info Output Payload */
@@ -173,6 +191,16 @@ struct vendor_test_feat {
 	__le32 data;
 } __packed;
 
+/*
+ * The kernel surfaces only the first DC partition reported by the
+ * device (cxl_dev_dc_identify() takes partitions[0] only), so any
+ * extents we pre-inject into a second mock partition end up rejected
+ * as "not in a valid DC partition" — and for tagged groups they also
+ * trip the partition-equality gate and drop the whole group (including
+ * the in-range member in DC0).  Keep the mock at one DC partition.
+ */
+#define NUM_MOCK_DC_REGIONS 1
+
 struct cxl_mockmem_data {
 	void *lsa;
 	void *fw;
@@ -191,6 +219,21 @@ struct cxl_mockmem_data {
 	unsigned long sanitize_timeout;
 	struct vendor_test_feat test_feat;
 	u8 shutdown_state;
+
+	struct cxl_dc_partition dc_partitions[NUM_MOCK_DC_REGIONS];
+	u32 dc_ext_generation;
+	u32 dc_offer_seq;
+	struct mutex ext_lock;
+
+	/*
+	 * Extents are in 1 of 3 states
+	 * FM (sysfs added but not sent to the host yet)
+	 * sent (sent to the host but not accepted)
+	 * accepted (by the host)
+	 */
+	struct xarray dc_fm_extents;
+	struct xarray dc_sent_extents;
+	struct xarray dc_accepted_exts;
 };
 
 static struct mock_event_log *event_find_log(struct device *dev, int log_type)
@@ -619,6 +662,230 @@ static int cxl_mock_event_trigger(struct device *dev)
 	return 0;
 }
 
+struct cxl_extent_data {
+	u64 dpa_start;
+	u64 length;
+	uuid_t uuid;
+	u16 shared_extn_seq;
+	u32 offer_seq;
+	bool shared;
+};
+
+/*
+ * Parse a tag string into a uuid_t.  Accepts the empty string and "0"
+ * as shorthand for the null UUID; anything else must be a UUID string
+ * uuid_parse() can understand.
+ */
+static int parse_tag(const char *tag, uuid_t *out)
+{
+	if (!tag || tag[0] == '\0' || strcmp(tag, "0") == 0) {
+		uuid_copy(out, &uuid_null);
+		return 0;
+	}
+	return uuid_parse(tag, out);
+}
+
+static int __devm_add_extent(struct device *dev, struct xarray *array,
+			     u64 start, u64 length, const char *tag,
+			     u16 shared_extn_seq, bool shared)
+{
+	struct cxl_extent_data *extent;
+	int rc;
+
+	extent = devm_kzalloc(dev, sizeof(*extent), GFP_KERNEL);
+	if (!extent)
+		return -ENOMEM;
+
+	extent->dpa_start = start;
+	extent->length = length;
+	rc = parse_tag(tag, &extent->uuid);
+	if (rc) {
+		dev_err(dev, "Failed to parse tag '%s'\n", tag);
+		devm_kfree(dev, extent);
+		return rc;
+	}
+	extent->shared_extn_seq = shared_extn_seq;
+	extent->shared = shared;
+
+	if (xa_insert(array, start, extent, GFP_KERNEL)) {
+		devm_kfree(dev, extent);
+		dev_err(dev, "Failed xarry insert %#llx\n", start);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int devm_add_fm_extent(struct device *dev, u64 start, u64 length,
+			      const char *tag, u16 shared_extn_seq, bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+
+	guard(mutex)(&mdata->ext_lock);
+	return __devm_add_extent(dev, &mdata->dc_fm_extents, start, length,
+				 tag, shared_extn_seq, shared);
+}
+
+static int dc_accept_extent(struct device *dev, u64 start, u64 length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	lockdep_assert_held(&mdata->ext_lock);
+
+	dev_dbg(dev, "Host accepting extent %#llx\n", start);
+	ext = xa_load(&mdata->dc_sent_extents, start);
+	if (!ext || ext->length != length) {
+		/*
+		 * The host may re-accept extents we already moved into the
+		 * accepted xarray (e.g. pre-injected extents replayed on
+		 * region creation).  Treat that as a successful no-op so
+		 * the existing-extent ingest path doesn't abort.
+		 */
+		ext = xa_load(&mdata->dc_accepted_exts, start);
+		if (ext && ext->length == length)
+			return 0;
+		dev_err(dev, "Extent %#llx-%#llx not found\n",
+			start, start + length);
+		return -ENOMEM;
+	}
+	mdata->dc_ext_generation++;
+	xa_erase(&mdata->dc_sent_extents, start);
+	return xa_insert(&mdata->dc_accepted_exts, start, ext, GFP_KERNEL);
+}
+
+static void release_dc_ext(void *md)
+{
+	struct cxl_mockmem_data *mdata = md;
+
+	xa_destroy(&mdata->dc_fm_extents);
+	xa_destroy(&mdata->dc_sent_extents);
+	xa_destroy(&mdata->dc_accepted_exts);
+}
+
+/* Pretend to have some previous accepted extents */
+struct pre_ext_info {
+	u64 offset;
+	u64 length;
+	const char *tag;
+} pre_ext_info[] = {
+	{
+		.offset = SZ_128M,
+		.length = SZ_64M,
+		.tag = "",
+	},
+	{
+		.offset = SZ_256M,
+		.length = SZ_64M,
+		.tag = "deadbeef-cafe-baad-f00d-fedcba987654",
+	},
+};
+
+static int devm_add_sent_extent(struct device *dev, u64 start, u64 length,
+				const char *tag, u16 shared_extn_seq, bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+
+	lockdep_assert_held(&mdata->ext_lock);
+	return __devm_add_extent(dev, &mdata->dc_sent_extents, start, length,
+				 tag, shared_extn_seq, shared);
+}
+
+static int inject_prev_extents(struct device *dev, u64 base_dpa)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	int rc;
+
+	dev_dbg(dev, "Adding %ld pre-extents for testing\n",
+		ARRAY_SIZE(pre_ext_info));
+
+	guard(mutex)(&mdata->ext_lock);
+	for (int i = 0; i < ARRAY_SIZE(pre_ext_info); i++) {
+		u64 ext_dpa = base_dpa + pre_ext_info[i].offset;
+		u64 ext_len = pre_ext_info[i].length;
+
+		dev_dbg(dev, "Adding pre-extent DPA:%#llx LEN:%#llx tag:%s\n",
+			ext_dpa, ext_len, pre_ext_info[i].tag);
+
+		rc = devm_add_sent_extent(dev, ext_dpa, ext_len,
+					  pre_ext_info[i].tag, 0, false);
+		if (rc) {
+			dev_err(dev, "Failed to add pre-extent DPA:%#llx LEN:%#llx; %d\n",
+				ext_dpa, ext_len, rc);
+			return rc;
+		}
+
+		rc = dc_accept_extent(dev, ext_dpa, ext_len);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+static int cxl_mock_dc_partition_setup(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u64 base_dpa = BASE_DYNAMIC_CAP_DPA;
+	u32 dsmad_handle = 0xFA;
+	u64 decode_length = SZ_512M;
+	u64 block_size = SZ_512;
+	u64 length = SZ_512M;
+	int rc;
+
+	mutex_init(&mdata->ext_lock);
+	xa_init(&mdata->dc_fm_extents);
+	xa_init(&mdata->dc_sent_extents);
+	xa_init(&mdata->dc_accepted_exts);
+
+	rc = devm_add_action_or_reset(dev, release_dc_ext, mdata);
+	if (rc)
+		return rc;
+
+	for (int i = 0; i < NUM_MOCK_DC_REGIONS; i++) {
+		struct cxl_dc_partition *part = &mdata->dc_partitions[i];
+
+		dev_dbg(dev, "Creating DC partition DC%d DPA:%#llx LEN:%#llx\n",
+			i, base_dpa, length);
+
+		part->base = cpu_to_le64(base_dpa);
+		part->decode_length = cpu_to_le64(decode_length /
+						  CXL_CAPACITY_MULTIPLIER);
+		part->length = cpu_to_le64(length);
+		part->block_size = cpu_to_le64(block_size);
+		part->dsmad_handle = cpu_to_le32(dsmad_handle);
+		dsmad_handle++;
+
+		/*
+		 * Skip pre-injection on the sharable mock memdev.  The
+		 * pre-injected extents are untagged / seq=0, which a
+		 * sharable partition rejects as firmware-bug; leaving the
+		 * sharable memdev with an empty DC partition is what its
+		 * dedicated tests (test_shared_extent_inject and
+		 * test_seq_integrity_gap in cxl-dcd.sh) expect anyway.
+		 *
+		 * The sharable fixture is the memdev at pdev->id == 0 —
+		 * see the matching MOCK_DC_SHARABLE_SERIAL stamp in
+		 * cxl_mock_mem_probe().  This relies on tools/testing/cxl
+		 * always allocating a "cxl_mem" platform device with id 0
+		 * as the first memdev; if that invariant ever breaks the
+		 * sharable test fixture will land on the wrong device.
+		 */
+		if (to_platform_device(dev)->id != 0) {
+			rc = inject_prev_extents(dev, base_dpa);
+			if (rc) {
+				dev_err(dev,
+					"Failed to add pre-extents for DC%d\n",
+					i);
+				return rc;
+			}
+		}
+
+		base_dpa += decode_length;
+	}
+
+	return 0;
+}
+
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
 {
 	if (cmd->size_out < sizeof(mock_gsl_payload))
@@ -1594,6 +1861,215 @@ static int mock_get_supported_features(struct cxl_mockmem_data *mdata,
 	return 0;
 }
 
+static int mock_get_dc_config(struct device *dev,
+			      struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_get_dc_config_in *dc_config = cmd->payload_in;
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u8 partition_requested, partition_start_idx, partition_ret_cnt;
+	struct cxl_mbox_get_dc_config_out *resp;
+	int i;
+
+	partition_requested = min(dc_config->partition_count, NUM_MOCK_DC_REGIONS);
+
+	if (cmd->size_out < struct_size(resp, partition, partition_requested))
+		return -EINVAL;
+
+	memset(cmd->payload_out, 0, cmd->size_out);
+	resp = cmd->payload_out;
+
+	partition_start_idx = dc_config->start_partition_index;
+	partition_ret_cnt = 0;
+	for (i = partition_start_idx;
+	     i < NUM_MOCK_DC_REGIONS && partition_ret_cnt < partition_requested;
+	     i++) {
+		memcpy(&resp->partition[partition_ret_cnt],
+			&mdata->dc_partitions[i],
+			sizeof(resp->partition[partition_ret_cnt]));
+		partition_ret_cnt++;
+	}
+	resp->avail_partition_count = NUM_MOCK_DC_REGIONS;
+	resp->partitions_returned = partition_ret_cnt;
+	cmd->size_out = struct_size(resp, partition, partition_ret_cnt);
+
+	dev_dbg(dev, "Returning %d dc partitions\n", partition_ret_cnt);
+	return 0;
+}
+
+static int mock_get_dc_extent_list(struct device *dev,
+				   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_get_extent_out *resp = cmd->payload_out;
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_mbox_get_extent_in *get = cmd->payload_in;
+	u32 total_avail = 0, total_ret = 0, idx = 0;
+	struct cxl_extent_data *ext;
+	u32 ext_count, start_idx;
+	unsigned long i;
+
+	ext_count = le32_to_cpu(get->extent_cnt);
+	start_idx = le32_to_cpu(get->start_extent_index);
+
+	memset(resp, 0, sizeof(*resp));
+
+	guard(mutex)(&mdata->ext_lock);
+	/*
+	 * Total available needs to be calculated and returned regardless of
+	 * how many can actually be returned.
+	 */
+	xa_for_each(&mdata->dc_accepted_exts, i, ext)
+		total_avail++;
+
+	if (start_idx > total_avail)
+		return -EINVAL;
+
+	xa_for_each(&mdata->dc_accepted_exts, i, ext) {
+		if (total_ret >= ext_count)
+			break;
+
+		if (idx++ >= start_idx) {
+			resp->extent[total_ret].start_dpa =
+						cpu_to_le64(ext->dpa_start);
+			resp->extent[total_ret].length =
+						cpu_to_le64(ext->length);
+			export_uuid(resp->extent[total_ret].uuid, &ext->uuid);
+			resp->extent[total_ret].shared_extn_seq =
+						cpu_to_le16(ext->shared_extn_seq);
+			total_ret++;
+		}
+	}
+
+	resp->returned_extent_count = cpu_to_le32(total_ret);
+	resp->total_extent_count = cpu_to_le32(total_avail);
+	resp->generation_num = cpu_to_le32(mdata->dc_ext_generation);
+
+	dev_dbg(dev, "Returning %d extents of %d total\n",
+		total_ret, total_avail);
+
+	return 0;
+}
+
+static void dc_clear_sent(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+	unsigned long index;
+
+	lockdep_assert_held(&mdata->ext_lock);
+
+	/* Any extents not accepted must be cleared */
+	xa_for_each(&mdata->dc_sent_extents, index, ext) {
+		dev_dbg(dev, "Host rejected extent %#llx\n", ext->dpa_start);
+		xa_erase(&mdata->dc_sent_extents, ext->dpa_start);
+	}
+}
+
+static int mock_add_dc_response(struct device *dev,
+				struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_dc_response *req = cmd->payload_in;
+	u32 list_size = le32_to_cpu(req->extent_list_size);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u32 last_offer_seq = 0;
+	bool first = true;
+
+	guard(mutex)(&mdata->ext_lock);
+	for (int i = 0; i < list_size; i++) {
+		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
+		u64 length = le64_to_cpu(req->extent_list[i].length);
+		struct cxl_extent_data *ext;
+		int rc;
+
+		/*
+		 * CXL r4.0 8.2.10.9.9.3: the host must list extents in the
+		 * order the device offered them (Add Capacity events); reject
+		 * an out-of-order response as Invalid Input.
+		 */
+		ext = xa_load(&mdata->dc_sent_extents, start);
+		if (!ext)
+			ext = xa_load(&mdata->dc_accepted_exts, start);
+		if (ext) {
+			if (!first && ext->offer_seq < last_offer_seq) {
+				dev_err(dev, "Add-DC-Response out of order at extent %#llx\n",
+					start);
+				return -EINVAL;
+			}
+			last_offer_seq = ext->offer_seq;
+			first = false;
+		}
+
+		rc = dc_accept_extent(dev, start, length);
+		if (rc)
+			return rc;
+	}
+
+	dc_clear_sent(dev);
+	return 0;
+}
+
+static void dc_delete_extent(struct device *dev, unsigned long long start,
+			     unsigned long long length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long end = start + length;
+	struct cxl_extent_data *ext;
+	unsigned long index;
+
+	dev_dbg(dev, "Deleting extent at %#llx len:%#llx\n", start, length);
+
+	guard(mutex)(&mdata->ext_lock);
+	xa_for_each(&mdata->dc_fm_extents, index, ext) {
+		u64 extent_end = ext->dpa_start + ext->length;
+
+		/*
+		 * Any extent which 'touches' the released delete range will be
+		 * removed.  Standard half-open overlap test, which also catches
+		 * an extent that fully contains the delete range.
+		 */
+		if (start < extent_end && ext->dpa_start < end)
+			xa_erase(&mdata->dc_fm_extents, ext->dpa_start);
+	}
+
+	/*
+	 * If the extent was accepted let it be for the host to drop
+	 * later.
+	 */
+}
+
+static int release_accepted_extent(struct device *dev, u64 start, u64 length)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	guard(mutex)(&mdata->ext_lock);
+	ext = xa_load(&mdata->dc_accepted_exts, start);
+	if (!ext || ext->length != length) {
+		dev_err(dev, "Extent %#llx not in accepted state\n", start);
+		return -EINVAL;
+	}
+	xa_erase(&mdata->dc_accepted_exts, start);
+	mdata->dc_ext_generation++;
+
+	return 0;
+}
+
+static int mock_dc_release(struct device *dev,
+			   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mbox_dc_response *req = cmd->payload_in;
+	u32 list_size = le32_to_cpu(req->extent_list_size);
+
+	for (int i = 0; i < list_size; i++) {
+		u64 start = le64_to_cpu(req->extent_list[i].dpa_start);
+		u64 length = le64_to_cpu(req->extent_list[i].length);
+
+		dev_dbg(dev, "Extent %#llx released by host\n", start);
+		release_accepted_extent(dev, start, length);
+	}
+
+	return 0;
+}
+
 static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
 			      struct cxl_mbox_cmd *cmd)
 {
@@ -1685,6 +2161,18 @@ static int cxl_mock_mbox_send(struct cxl_mailbox *cxl_mbox,
 	case CXL_MBOX_OP_GET_SUPPORTED_FEATURES:
 		rc = mock_get_supported_features(mdata, cmd);
 		break;
+	case CXL_MBOX_OP_GET_DC_CONFIG:
+		rc = mock_get_dc_config(dev, cmd);
+		break;
+	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
+		rc = mock_get_dc_extent_list(dev, cmd);
+		break;
+	case CXL_MBOX_OP_ADD_DC_RESPONSE:
+		rc = mock_add_dc_response(dev, cmd);
+		break;
+	case CXL_MBOX_OP_RELEASE_DC:
+		rc = mock_dc_release(dev, cmd);
+		break;
 	case CXL_MBOX_OP_GET_FEATURE:
 		rc = mock_get_feature(mdata, cmd);
 		break;
@@ -1761,6 +2249,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	struct cxl_mockmem_data *mdata;
 	struct cxl_mailbox *cxl_mbox;
 	struct cxl_dpa_info range_info = { 0 };
+	u64 serial;
 	int rc;
 
 	/* Increase async probe race window */
@@ -1771,6 +2260,10 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
+	rc = cxl_mock_dc_partition_setup(dev);
+	if (rc)
+		return rc;
+
 	mdata->lsa = vmalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
@@ -1787,7 +2280,17 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
-	mds = cxl_memdev_state_create(dev, pdev->id + 1, 0);
+	/*
+	 * Reserve the memdev at pdev->id == 0 as the sharable DC partition
+	 * test fixture.  This relies on tools/testing/cxl always allocating a
+	 * "cxl_mem" platform device with id 0 as the first memdev — currently
+	 * true in cxl.c, but if the topology ever renumbers, the sharable
+	 * serial will be stamped on the wrong device (or no device).  Matched
+	 * by the skip-pre-inject guard in cxl_mock_dc_partition_setup and by
+	 * mock_cxl_endpoint_parse_cdat in cxl_test.
+	 */
+	serial = pdev->id == 0 ? MOCK_DC_SHARABLE_SERIAL : pdev->id + 1;
+	mds = cxl_memdev_state_create(dev, serial, 0);
 	if (IS_ERR(mds))
 		return PTR_ERR(mds);
 
@@ -1827,6 +2330,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		return rc;
 
+	if (cxl_dcd_supported(mds))
+		cxl_configure_dcd(mds, &range_info);
+
 	rc = cxl_dpa_setup(cxlds, &range_info);
 	if (rc)
 		return rc;
@@ -1936,11 +2442,328 @@ static ssize_t sanitize_timeout_store(struct device *dev,
 
 static DEVICE_ATTR_RW(sanitize_timeout);
 
+/* Return if the proposed extent would break the test code */
+static bool new_extent_valid(struct device *dev, size_t new_start,
+			     size_t new_len)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *extent;
+	size_t new_end, i;
+
+	if (!new_len)
+		return false;
+
+	new_end = new_start + new_len;
+
+	dev_dbg(dev, "New extent %zx-%zx\n", new_start, new_end);
+
+	guard(mutex)(&mdata->ext_lock);
+	dev_dbg(dev, "Checking extents starts...\n");
+	xa_for_each(&mdata->dc_fm_extents, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	dev_dbg(dev, "Checking sent extents starts...\n");
+	xa_for_each(&mdata->dc_sent_extents, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	dev_dbg(dev, "Checking accepted extents starts...\n");
+	xa_for_each(&mdata->dc_accepted_exts, i, extent) {
+		if (extent->dpa_start == new_start)
+			return false;
+	}
+
+	return true;
+}
+
+struct cxl_test_dcd {
+	uuid_t id;
+	struct cxl_event_dcd rec;
+} __packed;
+
+struct cxl_test_dcd dcd_event_rec_template = {
+	.id = CXL_EVENT_DC_EVENT_UUID,
+	.rec = {
+		.hdr = {
+			.length = sizeof(struct cxl_test_dcd),
+		},
+	},
+};
+
+static int log_dc_event(struct cxl_mockmem_data *mdata, enum dc_event type,
+			u64 start, u64 length, const char *tag_str,
+			u16 shared_extn_seq, bool more)
+{
+	struct device *dev = mdata->mds->cxlds.dev;
+	struct cxl_test_dcd *dcd_event;
+	uuid_t tag;
+	int rc;
+
+	dev_dbg(dev, "mock device log event %d\n", type);
+
+	dcd_event = devm_kmemdup(dev, &dcd_event_rec_template,
+				     sizeof(*dcd_event), GFP_KERNEL);
+	if (!dcd_event)
+		return -ENOMEM;
+
+	dcd_event->rec.flags = 0;
+	if (more)
+		dcd_event->rec.flags |= CXL_DCD_EVENT_MORE;
+	dcd_event->rec.event_type = type;
+	dcd_event->rec.extent.start_dpa = cpu_to_le64(start);
+	dcd_event->rec.extent.length = cpu_to_le64(length);
+	rc = parse_tag(tag_str, &tag);
+	if (rc) {
+		devm_kfree(dev, dcd_event);
+		return rc;
+	}
+	export_uuid(dcd_event->rec.extent.uuid, &tag);
+	dcd_event->rec.extent.shared_extn_seq = cpu_to_le16(shared_extn_seq);
+
+	mes_add_event(mdata, CXL_EVENT_TYPE_DCD,
+		      (struct cxl_event_record_raw *)dcd_event);
+
+	/* Fake the irq */
+	cxl_mem_get_event_records(mdata->mds, CXLDEV_EVENT_STATUS_DCD);
+
+	return 0;
+}
+
+static void mark_extent_sent(struct device *dev, unsigned long long start)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct cxl_extent_data *ext;
+
+	guard(mutex)(&mdata->ext_lock);
+	ext = xa_erase(&mdata->dc_fm_extents, start);
+	/* A concurrent delete may have removed it. */
+	if (!ext)
+		return;
+	/* Record the order extents are offered to the host (event order). */
+	ext->offer_seq = mdata->dc_offer_seq++;
+	if (xa_insert(&mdata->dc_sent_extents, ext->dpa_start, ext, GFP_KERNEL)) {
+		dev_err(dev, "Failed to mark extent %#llx sent\n", ext->dpa_start);
+		devm_kfree(dev, ext);
+	}
+}
+
+/*
+ * Format <start>:<length>:<tag>:<more_flag>
+ *
+ * start and length must be a multiple of the configured partition block size.
+ * Tag can be any string up to 16 bytes.
+ *
+ * Extents must be exclusive of other extents
+ *
+ * If the more flag is specified it is expected that an additional extent will
+ * be specified without the more flag to complete the test transaction with the
+ * host.
+ */
+static ssize_t __dc_inject_extent_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count,
+					bool shared)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long start, length, more;
+	char *len_str, *uuid_str, *more_str, *seq_str;
+	u16 shared_extn_seq = 0;
+	size_t buf_len = count;
+	int rc;
+
+	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
+	if (!start_str)
+		return -ENOMEM;
+
+	len_str = strnchr(start_str, buf_len, ':');
+	if (!len_str) {
+		dev_err(dev, "Extent failed to find len_str: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	*len_str = '\0';
+	len_str += 1;
+	buf_len -= strlen(start_str);
+
+	uuid_str = strnchr(len_str, buf_len, ':');
+	if (!uuid_str) {
+		dev_err(dev, "Extent failed to find uuid_str: %s\n", len_str);
+		return -EINVAL;
+	}
+	*uuid_str = '\0';
+	uuid_str += 1;
+
+	more_str = strnchr(uuid_str, buf_len, ':');
+	if (!more_str) {
+		dev_err(dev, "Extent failed to find more_str: %s\n", uuid_str);
+		return -EINVAL;
+	}
+	*more_str = '\0';
+	more_str += 1;
+
+	/* Optional 5th field: shared_extn_seq.  Absent -> 0. */
+	seq_str = strnchr(more_str, buf_len, ':');
+	if (seq_str) {
+		unsigned long long seq;
+
+		*seq_str = '\0';
+		seq_str += 1;
+		if (kstrtoull(seq_str, 0, &seq) || seq > U16_MAX) {
+			dev_err(dev, "Extent failed to parse seq: %s\n",
+				seq_str);
+			return -EINVAL;
+		}
+		shared_extn_seq = seq;
+	}
+
+	if (kstrtoull(start_str, 0, &start)) {
+		dev_err(dev, "Extent failed to parse start: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(len_str, 0, &length)) {
+		dev_err(dev, "Extent failed to parse length: %s\n", len_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(more_str, 0, &more)) {
+		dev_err(dev, "Extent failed to parse more: %s\n", more_str);
+		return -EINVAL;
+	}
+
+	if (!new_extent_valid(dev, start, length))
+		return -EINVAL;
+
+	rc = devm_add_fm_extent(dev, start, length, uuid_str, shared_extn_seq,
+				shared);
+	if (rc) {
+		dev_err(dev, "Failed to add extent DPA:%#llx LEN:%#llx; %d\n",
+			start, length, rc);
+		return rc;
+	}
+
+	mark_extent_sent(dev, start);
+	rc = log_dc_event(mdata, DCD_ADD_CAPACITY, start, length, uuid_str,
+			  shared_extn_seq, more);
+	if (rc) {
+		dev_err(dev, "Failed to add event %d\n", rc);
+		return rc;
+	}
+
+	return count;
+}
+
+static ssize_t dc_inject_extent_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	return __dc_inject_extent_store(dev, attr, buf, count, false);
+}
+static DEVICE_ATTR_WO(dc_inject_extent);
+
+static ssize_t dc_inject_shared_extent_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	return __dc_inject_extent_store(dev, attr, buf, count, true);
+}
+static DEVICE_ATTR_WO(dc_inject_shared_extent);
+
+static ssize_t __dc_del_extent_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count,
+				     enum dc_event type)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	unsigned long long start, length;
+	char *len_str, *uuid_str;
+	size_t buf_len = count;
+	int rc;
+
+	char *start_str __free(kfree) = kstrdup(buf, GFP_KERNEL);
+	if (!start_str)
+		return -ENOMEM;
+
+	len_str = strnchr(start_str, buf_len, ':');
+	if (!len_str) {
+		dev_err(dev, "Failed to find len_str: %s\n", start_str);
+		return -EINVAL;
+	}
+	*len_str = '\0';
+	len_str += 1;
+	buf_len -= strlen(start_str);
+
+	uuid_str = strnchr(len_str, buf_len, ':');
+	if (!uuid_str) {
+		dev_err(dev, "Failed to find uuid_str: %s\n", len_str);
+		return -EINVAL;
+	}
+	*uuid_str = '\0';
+	uuid_str += 1;
+	/*
+	 * uuid_str is the trailing field; trim shell-added '\n' so
+	 * parse_tag()/uuid_parse() see a clean string.
+	 */
+	uuid_str = strim(uuid_str);
+
+	if (kstrtoull(start_str, 0, &start)) {
+		dev_err(dev, "Failed to parse start: %s\n", start_str);
+		return -EINVAL;
+	}
+
+	if (kstrtoull(len_str, 0, &length)) {
+		dev_err(dev, "Failed to parse length: %s\n", len_str);
+		return -EINVAL;
+	}
+
+	dc_delete_extent(dev, start, length);
+
+	if (type == DCD_FORCED_CAPACITY_RELEASE)
+		dev_dbg(dev, "Forcing delete of extent %#llx len:%#llx\n",
+			start, length);
+
+	rc = log_dc_event(mdata, type, start, length, uuid_str, 0, false);
+	if (rc) {
+		dev_err(dev, "Failed to add event %d\n", rc);
+		return rc;
+	}
+
+	return count;
+}
+
+/*
+ * Format <start>:<length>:<uuid>
+ */
+static ssize_t dc_del_extent_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	return __dc_del_extent_store(dev, attr, buf, count,
+				     DCD_RELEASE_CAPACITY);
+}
+static DEVICE_ATTR_WO(dc_del_extent);
+
+static ssize_t dc_force_del_extent_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	return __dc_del_extent_store(dev, attr, buf, count,
+				     DCD_FORCED_CAPACITY_RELEASE);
+}
+static DEVICE_ATTR_WO(dc_force_del_extent);
+
 static struct attribute *cxl_mock_mem_attrs[] = {
 	&dev_attr_security_lock.attr,
 	&dev_attr_event_trigger.attr,
 	&dev_attr_fw_buf_checksum.attr,
 	&dev_attr_sanitize_timeout.attr,
+	&dev_attr_dc_inject_extent.attr,
+	&dev_attr_dc_inject_shared_extent.attr,
+	&dev_attr_dc_del_extent.attr,
+	&dev_attr_dc_force_del_extent.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(cxl_mock_mem);
diff --git a/tools/testing/cxl/test/mock.h b/tools/testing/cxl/test/mock.h
index 4f57dc80ae7d..58ebe1c81fd2 100644
--- a/tools/testing/cxl/test/mock.h
+++ b/tools/testing/cxl/test/mock.h
@@ -5,6 +5,15 @@
 #include <linux/dax.h>
 #include <cxl.h>
 
+/*
+ * Mock serial sentinel.  The cxl_mock_mem probe stamps this serial on
+ * exactly one platform device (cxl_mem with id 0); that single memdev's
+ * DC partition is marked sharable in mock_cxl_endpoint_parse_cdat() so
+ * the suite can exercise sharable-extent code paths without losing the
+ * non-sharable coverage on the other mock memdevs.
+ */
+#define MOCK_DC_SHARABLE_SERIAL 0xDCDCULL
+
 struct cxl_mock_ops {
 	struct list_head list;
 	bool (*is_mock_adev)(struct acpi_device *dev);
-- 
2.43.0

