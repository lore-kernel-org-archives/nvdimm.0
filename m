Return-Path: <SRS0=kIc1=4R=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DC2C3F2CD
	for <linux-nvdimm@archiver.kernel.org>; Sat, 29 Feb 2020 20:37:04 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62C0920836
	for <linux-nvdimm@archiver.kernel.org>; Sat, 29 Feb 2020 20:37:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 62C0920836
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 073BA10FC341A;
	Sat, 29 Feb 2020 12:37:56 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.115; helo=mga14.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 68CE810FC3418
	for <linux-nvdimm@lists.01.org>; Sat, 29 Feb 2020 12:37:54 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Feb 2020 12:37:02 -0800
X-IronPort-AV: E=Sophos;i="5.70,501,1574150400";
   d="scan'208";a="437787251"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Feb 2020 12:37:02 -0800
Subject: [ndctl PATCH 10/36] ndctl/util: Up-level is_power_of_2() and
 introduce IS_ALIGNED
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: vishal.l.verma@intel.com
Date: Sat, 29 Feb 2020 12:20:57 -0800
Message-ID: <158300765729.2141307.8955010212426376178.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158300760415.2141307.14060353322051900501.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158300760415.2141307.14060353322051900501.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: UQIIVDY73IJURE3MPTFWI7XLYCHPIIYB
X-Message-ID-Hash: UQIIVDY73IJURE3MPTFWI7XLYCHPIIYB
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UQIIVDY73IJURE3MPTFWI7XLYCHPIIYB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add helpers for checking alignment to util/size.h.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/ars.c |    6 +-----
 util/size.h     |    7 +++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index bd75131081ba..d91a99d00d10 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -11,6 +11,7 @@
  * more details.
  */
 #include <stdlib.h>
+#include <util/size.h>
 #include <ndctl/libndctl.h>
 #include "private.h"
 
@@ -43,11 +44,6 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 	return cmd;
 }
 
-static bool is_power_of_2(unsigned int v)
-{
-	return v && ((v & (v - 1)) == 0);
-}
-
 static bool validate_clear_error(struct ndctl_cmd *ars_cap)
 {
 	if (!is_power_of_2(ars_cap->ars_cap->clear_err_unit))
diff --git a/util/size.h b/util/size.h
index 34fac58d6945..2f36c2c85ca7 100644
--- a/util/size.h
+++ b/util/size.h
@@ -13,6 +13,7 @@
 
 #ifndef _NDCTL_SIZE_H_
 #define _NDCTL_SIZE_H_
+#include <stdbool.h>
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
@@ -27,8 +28,14 @@
 unsigned long long parse_size64(const char *str);
 unsigned long long __parse_size64(const char *str, unsigned long long *units);
 
+static inline bool is_power_of_2(unsigned long long v)
+{
+	return v && ((v & (v - 1)) == 0);
+}
+
 #define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
 #define ALIGN_DOWN(x, a) (((((unsigned long long) x) + a) & ~(a - 1)) - a)
+#define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)
 #define BITS_PER_LONG (sizeof(unsigned long) * 8)
 #define HPAGE_SIZE (2 << 20)
 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
