Return-Path: <SRS0=BDGy=FS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0B0C4361B
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 10:39:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E72422B42
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 10:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E72422B42
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DF255100EF278;
	Mon, 14 Dec 2020 02:39:48 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::443; helo=mail-pf1-x443.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 2B65A100EF270
	for <linux-nvdimm@lists.01.org>; Mon, 14 Dec 2020 02:39:46 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c12so11812821pfo.10
        for <linux-nvdimm@lists.01.org>; Mon, 14 Dec 2020 02:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sKIV5BJSs/1ZrCTuR9MIwhL9Uhr+55Pw7BNiUI+wgo=;
        b=BISQUwJSSL+YPdXyL+5SAi6maz3WD5UxDQNRxWhoZRp0NDVJybU0c5NEga6nvBhFVK
         zQI6sXp4S63Yi/6pYQkL+E7odDz5HLA5qzr5l0qkw3SyW2MpJHiJ3m1kkFaGyYr961Ly
         b1GdF6/fle0aEUc6sDj9DvviWBtAx1ipBr0x0SftM1XfBeKjFXnerVxC6y5wTtACHmE8
         RkfhGO0cvibDYAuBobZDkXbC1F5dhOFObn39Z8/zgQAuYtMLIJM1QkGTMDIv6pOrn6EQ
         DR3tC/Cag4UsIQUQaM7YWO82dZa1ANzJ68rKkFMwpxRn2m+WVWRyC7pVQ+/cux0Wczs+
         ZX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sKIV5BJSs/1ZrCTuR9MIwhL9Uhr+55Pw7BNiUI+wgo=;
        b=HXAS09fo8+gQJa12isHJW89K2sb9P7rcWzKlJ+BJKz025RWzaObSs8iunRcgWAWbyp
         MSPgwMLuLCgQMaOMB6ejST1iAKFfKFJR2SwpvwU/LEckent6cV2NsEAxfuCjAF1r91+p
         6UroKGX0dzbVjHWv63WgvUq1jip4NUL4YVZcdWIrpqgIq+Cn9Qge4T7cVnQJv+ajJMjv
         2B6J7zt2WhbAX1chS9KpQ40TbNpqZYK2QDwGnV25m1QiJlAhkKhM5l/d91Cbn0FmLVh9
         3YKnk+QKDQlvq7TaoAO0LobS+Tl55SfsNrWUVU/IQmTH9OghV09v7gLXBCoc09fUEccx
         Ne/A==
X-Gm-Message-State: AOAM533ReMz8cG2Hj//RgUG25oDe0cu4PV8/7FDn7U8JUHpTuQDlmHwI
	TKzA9DRTuzqo9FA2bJbOmexWp//HZjqlZg==
X-Google-Smtp-Source: ABdhPJzt2m6kMX8MJ2KHyEnAV2AMTZdRFm57VCNCg6W9sCG8GyGeuz16rXMKfKct9M374DUSWoUhdQ==
X-Received: by 2002:a62:1c93:0:b029:198:1c0a:ea71 with SMTP id c141-20020a621c930000b02901981c0aea71mr23381638pfc.22.1607942385557;
        Mon, 14 Dec 2020 02:39:45 -0800 (PST)
Received: from santosiv.in.ibm.com.com ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id p1sm20735926pfb.208.2020.12.14.02.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 02:39:45 -0800 (PST)
From: Santosh Sivaraj <santosh@fossix.org>
To: Linux NVDIMM <linux-nvdimm@lists.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Harish Sriram <harish@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Subject: [RFC v5 7/7] ndtest: Add papr health related flags
Date: Mon, 14 Dec 2020 16:08:59 +0530
Message-Id: <20201214103859.2409175-8-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214103859.2409175-1-santosh@fossix.org>
References: <20201214103859.2409175-1-santosh@fossix.org>
MIME-Version: 1.0
Message-ID-Hash: R2POBZC7EKMCY4SPPJCSFDJCQFCNXAMS
X-Message-ID-Hash: R2POBZC7EKMCY4SPPJCSFDJCQFCNXAMS
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/R2POBZC7EKMCY4SPPJCSFDJCQFCNXAMS/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

sysfs attibutes to show health related flags are added.

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 tools/testing/nvdimm/test/ndtest.c | 41 ++++++++++++++++++++++++++++++
 tools/testing/nvdimm/test/ndtest.h | 31 ++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index dc1e3636616a..6862915f1fb0 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -86,6 +86,9 @@ static struct ndtest_dimm dimm_group2[] = {
 		.uuid_str = "ca0817e2-b618-11ea-9db3-507b9ddc0f72",
 		.physical_id = 0,
 		.num_formats = 1,
+		.flags = PAPR_PMEM_UNARMED | PAPR_PMEM_EMPTY |
+			 PAPR_PMEM_SAVE_FAILED | PAPR_PMEM_SHUTDOWN_DIRTY |
+			 PAPR_PMEM_HEALTH_FATAL,
 	},
 };
 
@@ -789,6 +792,40 @@ static umode_t ndtest_nvdimm_attr_visible(struct kobject *kobj,
 	return a->mode;
 }
 
+static ssize_t flags_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct ndtest_dimm *dimm = nvdimm_provider_data(nvdimm);
+	struct seq_buf s;
+	u64 flags;
+
+	flags = dimm->flags;
+
+	seq_buf_init(&s, buf, PAGE_SIZE);
+	if (flags & PAPR_PMEM_UNARMED_MASK)
+		seq_buf_printf(&s, "not_armed ");
+
+	if (flags & PAPR_PMEM_BAD_SHUTDOWN_MASK)
+		seq_buf_printf(&s, "flush_fail ");
+
+	if (flags & PAPR_PMEM_BAD_RESTORE_MASK)
+		seq_buf_printf(&s, "restore_fail ");
+
+	if (flags & PAPR_PMEM_SAVE_MASK)
+		seq_buf_printf(&s, "save_fail ");
+
+	if (flags & PAPR_PMEM_SMART_EVENT_MASK)
+		seq_buf_printf(&s, "smart_notify ");
+
+
+	if (seq_buf_used(&s))
+		seq_buf_printf(&s, "\n");
+
+	return seq_buf_used(&s);
+}
+static DEVICE_ATTR_RO(flags);
+
 static struct attribute *ndtest_nvdimm_attributes[] = {
 	&dev_attr_nvdimm_show_handle.attr,
 	&dev_attr_vendor.attr,
@@ -799,6 +836,7 @@ static struct attribute *ndtest_nvdimm_attributes[] = {
 	&dev_attr_formats.attr,
 	&dev_attr_format.attr,
 	&dev_attr_format1.attr,
+	&dev_attr_flags.attr,
 	NULL,
 };
 
@@ -824,6 +862,9 @@ static int ndtest_dimm_register(struct ndtest_priv *priv,
 		set_bit(NDD_LABELING, &dimm_flags);
 	}
 
+	if (dimm->flags & PAPR_PMEM_UNARMED_MASK)
+		set_bit(NDD_UNARMED, &dimm_flags);
+
 	dimm->nvdimm = nvdimm_create(priv->bus, dimm,
 				    ndtest_nvdimm_attribute_groups, dimm_flags,
 				    NDTEST_SCM_DIMM_CMD_MASK, 0, NULL);
diff --git a/tools/testing/nvdimm/test/ndtest.h b/tools/testing/nvdimm/test/ndtest.h
index 8f27ad6f7319..2c54c9cbb90c 100644
--- a/tools/testing/nvdimm/test/ndtest.h
+++ b/tools/testing/nvdimm/test/ndtest.h
@@ -5,6 +5,37 @@
 #include <linux/platform_device.h>
 #include <linux/libnvdimm.h>
 
+/* SCM device is unable to persist memory contents */
+#define PAPR_PMEM_UNARMED                   (1ULL << (63 - 0))
+/* SCM device failed to persist memory contents */
+#define PAPR_PMEM_SHUTDOWN_DIRTY            (1ULL << (63 - 1))
+/* SCM device contents are not persisted from previous IPL */
+#define PAPR_PMEM_EMPTY                     (1ULL << (63 - 3))
+#define PAPR_PMEM_HEALTH_CRITICAL           (1ULL << (63 - 4))
+/* SCM device will be garded off next IPL due to failure */
+#define PAPR_PMEM_HEALTH_FATAL              (1ULL << (63 - 5))
+/* SCM contents cannot persist due to current platform health status */
+#define PAPR_PMEM_HEALTH_UNHEALTHY          (1ULL << (63 - 6))
+
+/* Bits status indicators for health bitmap indicating unarmed dimm */
+#define PAPR_PMEM_UNARMED_MASK (PAPR_PMEM_UNARMED |		\
+				PAPR_PMEM_HEALTH_UNHEALTHY)
+
+#define PAPR_PMEM_SAVE_FAILED                (1ULL << (63 - 10))
+
+/* Bits status indicators for health bitmap indicating unflushed dimm */
+#define PAPR_PMEM_BAD_SHUTDOWN_MASK (PAPR_PMEM_SHUTDOWN_DIRTY)
+
+/* Bits status indicators for health bitmap indicating unrestored dimm */
+#define PAPR_PMEM_BAD_RESTORE_MASK  (PAPR_PMEM_EMPTY)
+
+/* Bit status indicators for smart event notification */
+#define PAPR_PMEM_SMART_EVENT_MASK (PAPR_PMEM_HEALTH_CRITICAL | \
+				    PAPR_PMEM_HEALTH_FATAL |	\
+				    PAPR_PMEM_HEALTH_UNHEALTHY)
+
+#define PAPR_PMEM_SAVE_MASK                (PAPR_PMEM_SAVE_FAILED)
+
 struct ndtest_config;
 
 struct ndtest_priv {
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
