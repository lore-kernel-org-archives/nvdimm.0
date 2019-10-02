Return-Path: <SRS0=ArFb=X3=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CACC4360C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:44 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4792A21A4C
	for <linux-nvdimm@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4792A21A4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E6835100DC437;
	Wed,  2 Oct 2019 16:50:56 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 41FB3100DC42F
	for <linux-nvdimm@lists.01.org>; Wed,  2 Oct 2019 16:50:54 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:49:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200";
   d="scan'208";a="195032115"
Received: from vverma7-desk1.lm.intel.com ([10.232.112.164])
  by orsmga003.jf.intel.com with ESMTP; 02 Oct 2019 16:49:36 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-nvdimm@lists.01.org>
Subject: [ndctl PATCH 06/10] daxctl: show a 'movable' attribute in device listings
Date: Wed,  2 Oct 2019 17:49:21 -0600
Message-Id: <20191002234925.9190-7-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002234925.9190-1-vishal.l.verma@intel.com>
References: <20191002234925.9190-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
Message-ID-Hash: Z4CATRZNFRJXBCBPXTFWWCCM5B2D32MK
X-Message-ID-Hash: Z4CATRZNFRJXBCBPXTFWWCCM5B2D32MK
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Dave Hansen <dave.hansen@linux.intel.com>, Ben Olson <ben.olson@intel.com>, Michal Biesek <michal.biesek@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/Z4CATRZNFRJXBCBPXTFWWCCM5B2D32MK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For dax devices in 'system-ram' mode, display a 'movable' attribute in
device listings. This helps a user easily determine if memory was not
onlined in the expected way for any reason.

Link: https://github.com/pmem/ndctl/issues/110
Reported-by: Ben Olson <ben.olson@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/json.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/util/json.c b/util/json.c
index 5e6a32a..497c52b 100644
--- a/util/json.c
+++ b/util/json.c
@@ -278,7 +278,7 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct json_object *jdev, *jobj;
-	int node;
+	int node, movable;
 
 	jdev = json_object_new_object();
 	if (!devname || !jdev)
@@ -306,6 +306,18 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 	if (jobj)
 		json_object_object_add(jdev, "mode", jobj);
 
+	if (mem) {
+		movable = daxctl_memory_is_movable(mem);
+		if (movable == 1)
+			jobj = json_object_new_boolean(true);
+		else if (movable == 0)
+			jobj = json_object_new_boolean(false);
+		else
+			jobj = NULL;
+		if (jobj)
+			json_object_object_add(jdev, "movable", jobj);
+	}
+
 	if (!daxctl_dev_is_enabled(dev)) {
 		jobj = json_object_new_string("disabled");
 		if (jobj)
-- 
2.20.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
