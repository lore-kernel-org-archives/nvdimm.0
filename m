Return-Path: <SRS0=tOjs=YZ=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D325CA9ECF
	for <linux-nvdimm@archiver.kernel.org>; Fri,  1 Nov 2019 20:27:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6089921855
	for <linux-nvdimm@archiver.kernel.org>; Fri,  1 Nov 2019 20:27:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6089921855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A80B3100DC418;
	Fri,  1 Nov 2019 13:30:22 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.31; helo=mga06.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BBEDB100DC414
	for <linux-nvdimm@lists.01.org>; Fri,  1 Nov 2019 13:30:20 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Nov 2019 13:27:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,256,1569308400";
   d="scan'208";a="194785276"
Received: from vverma7-desk1.amr.corp.intel.com (HELO vverma7-desk1.lm.intel.com) ([10.232.112.164])
  by orsmga008.jf.intel.com with ESMTP; 01 Nov 2019 13:27:20 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-nvdimm@lists.01.org>
Subject: [ndctl PATCH 1/2] ndctl/namespace: remove open coded is_namespace_active()
Date: Fri,  1 Nov 2019 14:27:12 -0600
Message-Id: <20191101202713.5111-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Message-ID-Hash: RCPG2V43ZXAT6UMCZ7AMUYONLL5JP725
X-Message-ID-Hash: RCPG2V43ZXAT6UMCZ7AMUYONLL5JP725
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RCPG2V43ZXAT6UMCZ7AMUYONLL5JP725/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the open coded namespace active check with the one provided by
libndctl - ndctl_namespace_is_active().

is_namespace_active() additionally checked for a non-NULL 'ndns', which
the libndctl API doesn't do. However, all the callers either performed
that check themselves, or made prior assumptions about ndns being valid
by dereferencing it earlier.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 7fb0007..ccd46d0 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -453,14 +453,6 @@ static int setup_namespace(struct ndctl_region *region,
 	return rc;
 }
 
-static int is_namespace_active(struct ndctl_namespace *ndns)
-{
-	return ndns && (ndctl_namespace_is_enabled(ndns)
-		|| ndctl_namespace_get_pfn(ndns)
-		|| ndctl_namespace_get_dax(ndns)
-		|| ndctl_namespace_get_btt(ndns));
-}
-
 /*
  * validate_namespace_options - init parameters for setup_namespace
  * @region: parent of the namespace to create / reconfigure
@@ -787,7 +779,7 @@ static struct ndctl_namespace *region_get_namespace(struct ndctl_region *region)
 	/* prefer the 0th namespace if it is idle */
 	ndctl_namespace_foreach(region, ndns)
 		if (ndctl_namespace_get_id(ndns) == 0
-				&& !is_namespace_active(ndns))
+				&& !ndctl_namespace_is_active(ndns))
 			return ndns;
 	return ndctl_region_get_namespace_seed(region);
 }
@@ -827,7 +819,7 @@ static int namespace_create(struct ndctl_region *region)
 		p.size = available;
 
 	ndns = region_get_namespace(region);
-	if (!ndns || is_namespace_active(ndns)) {
+	if (!ndns || ndctl_namespace_is_active(ndns)) {
 		debug("%s: no %s namespace seed\n", devname,
 				ndns ? "idle" : "available");
 		return -EAGAIN;
@@ -1074,7 +1066,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 	}
 
 	ndns = region_get_namespace(region);
-	if (!ndns || is_namespace_active(ndns)) {
+	if (!ndns || !ndctl_namespace_is_active(ndns)) {
 		debug("%s: no %s namespace seed\n",
 				ndctl_region_get_devname(region),
 				ndns ? "idle" : "available");
-- 
2.20.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
