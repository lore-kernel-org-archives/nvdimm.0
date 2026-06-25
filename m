Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE223DD505
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386957; cv=none; b=h/S6fbWBpmOEfLeCKav05ZOQ/6XHdLm6N6AI12LtEyoAoJWnaM0u5HPgjhz/TUzgV5bGsCF2HpprkZQzC8OMlMHHzniC4h9Wlu23qjhTFUu1+N/3HlbZaZ9Fhs1uDpNfmfuGQAxETwDE5v5DECXei7rX0xmOby6k7OeBLqN4KIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386957; c=relaxed/simple;
	bh=s4idj64jE0ejp5CibJDVnpYgbHpeGRmuMV7ZYIVU5Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1LYOKL+wLekAp3Nl0D6xu6Aj7ed3HhesksFzQ95FEL5FnNwt/HEHfgzoPWD12KZSK2NT1Cd4T+STcvMUTNHsf5Z2DsR5+/SBgkpJZ8MAL3gqg4rPgci8PoOQ61ChpQDW05KbIHZNjpKYB8K7V86U9W3EI36zDWj2Fj71XlM9JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TjwQC6uR; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TjwQC6uR"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30c23abc62eso2419745eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386954; x=1782991754; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6AaVgy8ZWsRhI8qqW4FQZBaUyGWHmSaI4qutkNjJPo=;
        b=TjwQC6uRxs08kLzpeYX9aUYZMpoj9z0guWeixlb00pErkpRRt35Wh5zi57KJlq2WjE
         yylJZM1D4cDXYh0FFCD2ujSecSC/Grq0H++rtcurfjWLt6ZMZNfblFv3B7rrglIGEtHm
         k1RyPecLj+8KnNhkUZuMrSN6QF+8dXGx1LAt026dqyaVbNAFaS44354VA+Yb8sJOwkUh
         gLmSF4hQ5o9I9xFPWxSlZfH8+1jbGFwVjlzR5AlUtKIw58b400RHzz72NOQZlIsNLOyY
         dlOsgaQ/a/4T5imTzT3sqsKwib1HNUBDx4lCHFFCBUQLaWSq1uxhIemF8H2liP0JzffI
         FaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386954; x=1782991754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r6AaVgy8ZWsRhI8qqW4FQZBaUyGWHmSaI4qutkNjJPo=;
        b=dUa7XPSEIAdJk2R7QB48rlcnWs6GpdAXwzKeSt2I+PitrUuc9bdvF2YEajZuPGaGtO
         DYvs+JgsOFgCKtpSlfootWTSiaHcah9Qg0JDspWRNnw9ivz3WHT3JQk02rNt8ofy4Cqj
         Soz1fAgKkE2E+WxCFlgePkrp/J9O9yK433OCMn8QeS8DbBXiR98nqQU9l3AkLedIAotF
         k31LcBawShj6kibPwDBlhUSAMAuYCCO2CIogJTbTTIV3ZAmkUMTuB2vC/uhVSALf8u0q
         V3sXLMP+ZCjLiLV5S8Ao+zUXCfaUeDfrPxcdDs8gmaiXr322QPLWXxwl8yeg8uMjmPe7
         zAPA==
X-Gm-Message-State: AOJu0YwnvfdeMl8Fqz9QXRmy3dOc8Jg9CIs1U+GNLEOQWjjkIOSECpdU
	5kxNiWvfnD17HCmmT+SmxE1dD+7QpytJ90Yt9eAF8sliWCyGA3w6B1do
X-Gm-Gg: AfdE7cnPO7oeYqW4VE9RY1eGXawk2148QHDVgGt/LDUtuhvcmGbZzJcMFGnn6jv9b69
	6ez5K23P0ZY7DiFjzNAA2QRc0i/yWt276BCDXl2St950jcnkNvDEqGc9bBLOoGn+vP1g848ocI2
	KvhBHQBYI1OdrSvtI8H1tKdpP10pMY08s1EdXLP29MZ4FrtYf1nFot7vwmDe6R8lynjK0zHXSRp
	nihBsKaFxll9AjX6hBbg9HkhP/EO8xEmSjSgiGIspLNThS/wKkA/DooIxq3IT0gPQc0TaKYEDAn
	MrmQ8NpUjSDjejfbDnFJJxoTj0MIi2CEpOJ6I92gTg2rUyGFBEkxH1uffyLifNJRpJJNdUcOXcx
	rUsDIg/uV4beOC6TXqzdVXao1Dk6sdWrJu1FWqKsh+wwu8cE86AOrf1P/zVHlgEanaRCKBcOx5K
	SSR8uTzaMetSWRzj6mYPpCMu+8v41Q0h2IM8SdNU8J2wPUaLed0g6aUQf3w7bxir+2XaVsjhvBn
	dBFG6Q=
X-Received: by 2002:a05:7301:9bc1:b0:304:ab8:f87c with SMTP id 5a478bee46e88-30c84bccf11mr2612981eec.12.1782386954325;
        Thu, 25 Jun 2026 04:29:14 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:14 -0700 (PDT)
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
Subject: [PATCH v11 29/31] tools/testing/cxl: Make event logs dynamic
Date: Thu, 25 Jun 2026 04:05:06 -0700
Message-ID: <20260625112638.550691-30-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

The event logs test was created as static arrays as an easy way to mock
events.  Dynamic Capacity Device (DCD) test support requires events be
generated dynamically when extents are created or destroyed.

The current event log test has specific checks for the number of events
seen including log overflow.

Modify mock event logs to be dynamically allocated.  Adjust array size
and mock event entry data to match the output expected by the existing
event test.

Use the static event data to create the dynamic events in the new logs
without inventing complex event injection for the previous tests.

Simplify log processing by using the event log array index as the
handle.  Add a lock to manage concurrency required when user space is
allowed to control DCD extents

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

---
Changes:
[anisa: use lockdep_assert_held() in mes_del_event(), and return on the
 empty-record error instead of falling through.]

[anisa: add_event_from_static() returns int so an event allocation
 failure propagates up and fails the probe instead of being swallowed.]
---
 tools/testing/cxl/test/mem.c | 284 ++++++++++++++++++++++-------------
 1 file changed, 178 insertions(+), 106 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 271c7ad8cc32..a2bfd52db076 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -142,18 +142,26 @@ static struct {
 
 #define PASS_TRY_LIMIT 3
 
-#define CXL_TEST_EVENT_CNT_MAX 15
+#define CXL_TEST_EVENT_CNT_MAX 16
+/* 1 extra slot to accommodate that handles can't be 0 */
+#define CXL_TEST_EVENT_ARRAY_SIZE (CXL_TEST_EVENT_CNT_MAX + 1)
 
 /* Set a number of events to return at a time for simulation.  */
 #define CXL_TEST_EVENT_RET_MAX 4
 
+/*
+ * @last_handle: last handle (index) to have an entry stored
+ * @current_handle: current handle (index) to be returned to the user on get_event
+ * @nr_overflow: number of events added past the log size
+ * @lock: protect these state variables
+ * @events: array of pending events to be returned.
+ */
 struct mock_event_log {
-	u16 clear_idx;
-	u16 cur_idx;
-	u16 nr_events;
+	u16 last_handle;
+	u16 current_handle;
 	u16 nr_overflow;
-	u16 overflow_reset;
-	struct cxl_event_record_raw *events[CXL_TEST_EVENT_CNT_MAX];
+	rwlock_t lock;
+	struct cxl_event_record_raw *events[CXL_TEST_EVENT_ARRAY_SIZE];
 };
 
 struct mock_event_store {
@@ -194,56 +202,67 @@ static struct mock_event_log *event_find_log(struct device *dev, int log_type)
 	return &mdata->mes.mock_logs[log_type];
 }
 
-static struct cxl_event_record_raw *event_get_current(struct mock_event_log *log)
-{
-	return log->events[log->cur_idx];
-}
-
-static void event_reset_log(struct mock_event_log *log)
-{
-	log->cur_idx = 0;
-	log->clear_idx = 0;
-	log->nr_overflow = log->overflow_reset;
-}
-
 /* Handle can never be 0 use 1 based indexing for handle */
-static u16 event_get_clear_handle(struct mock_event_log *log)
+static u16 event_inc_handle(u16 handle)
 {
-	return log->clear_idx + 1;
+	handle = (handle + 1) % CXL_TEST_EVENT_ARRAY_SIZE;
+	if (handle == 0)
+		handle = 1;
+	return handle;
 }
 
-/* Handle can never be 0 use 1 based indexing for handle */
-static __le16 event_get_cur_event_handle(struct mock_event_log *log)
-{
-	u16 cur_handle = log->cur_idx + 1;
-
-	return cpu_to_le16(cur_handle);
-}
-
-static bool event_log_empty(struct mock_event_log *log)
-{
-	return log->cur_idx == log->nr_events;
-}
-
-static void mes_add_event(struct mock_event_store *mes,
+/* Add the event or free it on overflow */
+static void mes_add_event(struct cxl_mockmem_data *mdata,
 			  enum cxl_event_log_type log_type,
 			  struct cxl_event_record_raw *event)
 {
+	struct device *dev = mdata->mds->cxlds.dev;
 	struct mock_event_log *log;
 
 	if (WARN_ON(log_type >= CXL_EVENT_TYPE_MAX))
 		return;
 
-	log = &mes->mock_logs[log_type];
+	log = &mdata->mes.mock_logs[log_type];
 
-	if ((log->nr_events + 1) > CXL_TEST_EVENT_CNT_MAX) {
+	guard(write_lock)(&log->lock);
+
+	dev_dbg(dev, "Add log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
+
+	/* Check next buffer */
+	if (event_inc_handle(log->last_handle) == log->current_handle) {
 		log->nr_overflow++;
-		log->overflow_reset = log->nr_overflow;
+		dev_dbg(dev, "Overflowing log %d nr %d\n",
+			log_type, log->nr_overflow);
+		devm_kfree(dev, event);
 		return;
 	}
 
-	log->events[log->nr_events] = event;
-	log->nr_events++;
+	dev_dbg(dev, "Log %d; handle %u\n", log_type, log->last_handle);
+	event->event.generic.hdr.handle = cpu_to_le16(log->last_handle);
+	log->events[log->last_handle] = event;
+	log->last_handle = event_inc_handle(log->last_handle);
+}
+
+static void mes_del_event(struct device *dev,
+			  struct mock_event_log *log,
+			  u16 handle)
+{
+	struct cxl_event_record_raw *record;
+
+	lockdep_assert_held(&log->lock);
+
+	dev_dbg(dev, "Clearing event %u; record %u\n",
+		handle, log->current_handle);
+	record = log->events[handle];
+	if (!record) {
+		dev_err(dev, "Mock event index %u empty?\n", handle);
+		return;
+	}
+
+	log->events[handle] = NULL;
+	log->current_handle = event_inc_handle(log->current_handle);
+	devm_kfree(dev, record);
 }
 
 /*
@@ -257,6 +276,7 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	struct cxl_get_event_payload *pl;
 	struct mock_event_log *log;
 	int ret_limit;
+	u16 handle;
 	u8 log_type;
 	int i;
 
@@ -276,22 +296,31 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	memset(cmd->payload_out, 0, struct_size(pl, records, 0));
 
 	log = event_find_log(dev, log_type);
-	if (!log || event_log_empty(log))
+	if (!log)
 		return 0;
 
 	pl = cmd->payload_out;
 
-	for (i = 0; i < ret_limit && !event_log_empty(log); i++) {
-		memcpy(&pl->records[i], event_get_current(log),
-		       sizeof(pl->records[i]));
-		pl->records[i].event.generic.hdr.handle =
-				event_get_cur_event_handle(log);
-		log->cur_idx++;
+	guard(read_lock)(&log->lock);
+
+	handle = log->current_handle;
+	dev_dbg(dev, "Get log %d handle %u last %u\n",
+		log_type, handle, log->last_handle);
+	for (i = 0; i < ret_limit && handle != log->last_handle;
+	     i++, handle = event_inc_handle(handle)) {
+		struct cxl_event_record_raw *cur;
+
+		cur = log->events[handle];
+		dev_dbg(dev, "Sending event log %d handle %d idx %u\n",
+			log_type, le16_to_cpu(cur->event.generic.hdr.handle),
+			handle);
+		memcpy(&pl->records[i], cur, sizeof(pl->records[i]));
+		pl->records[i].event.generic.hdr.handle = cpu_to_le16(handle);
 	}
 
 	cmd->size_out = struct_size(pl, records, i);
 	pl->record_count = cpu_to_le16(i);
-	if (!event_log_empty(log))
+	if (handle != log->last_handle)
 		pl->flags |= CXL_GET_EVENT_FLAG_MORE_RECORDS;
 
 	if (log->nr_overflow) {
@@ -313,8 +342,8 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
-	struct mock_event_log *log;
 	u8 log_type = pl->event_log;
+	struct mock_event_log *log;
 	u16 handle;
 	int nr;
 
@@ -325,23 +354,20 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 	if (!log)
 		return 0; /* No mock data in this log */
 
-	/*
-	 * This check is technically not invalid per the specification AFAICS.
-	 * (The host could 'guess' handles and clear them in order).
-	 * However, this is not good behavior for the host so test it.
-	 */
-	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
-		dev_err(dev,
-			"Attempting to clear more events than returned!\n");
-		return -EINVAL;
-	}
+	guard(write_lock)(&log->lock);
 
 	/* Check handle order prior to clearing events */
-	for (nr = 0, handle = event_get_clear_handle(log);
-	     nr < pl->nr_recs;
-	     nr++, handle++) {
+	handle = log->current_handle;
+	for (nr = 0; nr < pl->nr_recs && handle != log->last_handle;
+	     nr++, handle = event_inc_handle(handle)) {
+
+		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
+			log_type, handle,
+			le16_to_cpu(pl->handles[nr]));
+
 		if (handle != le16_to_cpu(pl->handles[nr])) {
-			dev_err(dev, "Clearing events out of order\n");
+			dev_err(dev, "Clearing events out of order %u %u\n",
+				handle, le16_to_cpu(pl->handles[nr]));
 			return -EINVAL;
 		}
 	}
@@ -350,25 +376,12 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
 		log->nr_overflow = 0;
 
 	/* Clear events */
-	log->clear_idx += pl->nr_recs;
-	return 0;
-}
+	for (nr = 0; nr < pl->nr_recs; nr++)
+		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));
+	dev_dbg(dev, "Delete log %d cur %d last %d\n",
+		log_type, log->current_handle, log->last_handle);
 
-static void cxl_mock_event_trigger(struct device *dev)
-{
-	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
-	struct mock_event_store *mes = &mdata->mes;
-	int i;
-
-	for (i = CXL_EVENT_TYPE_INFO; i < CXL_EVENT_TYPE_MAX; i++) {
-		struct mock_event_log *log;
-
-		log = event_find_log(dev, i);
-		if (log)
-			event_reset_log(log);
-	}
-
-	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+	return 0;
 }
 
 struct cxl_event_record_raw maint_needed = {
@@ -509,8 +522,30 @@ static int mock_set_timestamp(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
-static void cxl_mock_add_event_logs(struct mock_event_store *mes)
+/* Create a dynamically allocated event out of a statically defined event. */
+static int add_event_from_static(struct cxl_mockmem_data *mdata,
+				 enum cxl_event_log_type log_type,
+				 struct cxl_event_record_raw *raw)
+{
+	struct device *dev = mdata->mds->cxlds.dev;
+	struct cxl_event_record_raw *rec;
+
+	rec = devm_kmemdup(dev, raw, sizeof(*rec), GFP_KERNEL);
+	if (!rec) {
+		dev_err(dev, "Failed to alloc event for log\n");
+		return -ENOMEM;
+	}
+	mes_add_event(mdata, log_type, rec);
+
+	return 0;
+}
+
+static int cxl_mock_add_event_logs(struct cxl_mockmem_data *mdata)
 {
+	struct mock_event_store *mes = &mdata->mes;
+	struct device *dev = mdata->mds->cxlds.dev;
+	int rc = 0;
+
 	put_unaligned_le16(CXL_GMER_VALID_CHANNEL | CXL_GMER_VALID_RANK |
 			   CXL_GMER_VALID_COMPONENT | CXL_GMER_VALID_COMPONENT_ID_FORMAT,
 			   &gen_media.rec.media_hdr.validity_flags);
@@ -523,41 +558,65 @@ static void cxl_mock_add_event_logs(struct mock_event_store *mes)
 	put_unaligned_le16(CXL_MMER_VALID_COMPONENT | CXL_MMER_VALID_COMPONENT_ID_FORMAT,
 			   &mem_module.rec.validity_flags);
 
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_INFO);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_INFO, &maint_needed);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
 		      (struct cxl_event_record_raw *)&mem_module);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_INFO;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &maint_needed);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FAIL);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &maint_needed);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
+		      (struct cxl_event_record_raw *)&mem_module);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&gen_media);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&mem_module);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
 		      (struct cxl_event_record_raw *)&dram);
 	/* Overflow this log */
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FAIL;
 
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL, &hardware_replace);
-	mes_add_event(mes, CXL_EVENT_TYPE_FATAL,
+	dev_dbg(dev, "Generating fake event logs %d\n",
+		CXL_EVENT_TYPE_FATAL);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL, &hardware_replace);
+	rc = rc ?: add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL,
 		      (struct cxl_event_record_raw *)&dram);
 	mes->ev_status |= CXLDEV_EVENT_STATUS_FATAL;
+
+	return rc;
+}
+
+static int cxl_mock_event_trigger(struct device *dev)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	struct mock_event_store *mes = &mdata->mes;
+	int rc;
+
+	rc = cxl_mock_add_event_logs(mdata);
+	if (rc)
+		return rc;
+	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
+
+	return 0;
 }
 
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
@@ -1663,8 +1722,9 @@ static ssize_t event_trigger_store(struct device *dev,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
-	cxl_mock_event_trigger(dev);
-	return count;
+	int rc = cxl_mock_event_trigger(dev);
+
+	return rc ?: count;
 }
 static DEVICE_ATTR_WO(event_trigger);
 
@@ -1684,6 +1744,14 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)
 	mdata->test_feat.data = cpu_to_le32(0xdeadbeef);
 }
 
+static void init_event_log(struct mock_event_log *log)
+{
+	rwlock_init(&log->lock);
+	/* Handle can never be 0 use 1 based indexing for handle */
+	log->current_handle = 1;
+	log->last_handle = 1;
+}
+
 static int cxl_mock_mem_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1767,7 +1835,11 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		dev_dbg(dev, "No CXL Features discovered\n");
 
-	cxl_mock_add_event_logs(&mdata->mes);
+	for (int i = 0; i < CXL_EVENT_TYPE_MAX; i++)
+		init_event_log(&mdata->mes.mock_logs[i]);
+	rc = cxl_mock_add_event_logs(mdata);
+	if (rc)
+		return rc;
 
 	cxlmd = devm_cxl_add_memdev(cxlds, NULL);
 	if (IS_ERR(cxlmd))
-- 
2.43.0

