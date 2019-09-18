Return-Path: <SRS0=mEU+=XN=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918D5C4CEC4
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Sep 2019 21:19:38 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6188D20640
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Sep 2019 21:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6188D20640
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id ADF8521A07095;
	Wed, 18 Sep 2019 14:18:49 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=192.55.52.88; helo=mga01.intel.com;
 envelope-from=ira.weiny@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCC6D21A07095
 for <linux-nvdimm@lists.01.org>; Wed, 18 Sep 2019 14:18:47 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Sep 2019 14:19:35 -0700
X-IronPort-AV: E=Sophos;i="5.64,522,1559545200"; d="scan'208";a="388065194"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
 by fmsmga006-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 18 Sep 2019 14:19:35 -0700
From: ira.weiny@intel.com
To: linux-nvdimm@lists.01.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm: Trivial comment fix
Date: Wed, 18 Sep 2019 14:19:33 -0700
Message-Id: <20190918211933.13213-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-BeenThere: linux-nvdimm@lists.01.org
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

From: Ira Weiny <ira.weiny@intel.com>

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 include/linux/nd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/nd.h b/include/linux/nd.h
index f778f962d1b6..55c735997805 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -147,7 +147,7 @@ static inline int nvdimm_read_bytes(struct nd_namespace_common *ndns,
 
 /**
  * nvdimm_write_bytes() - synchronously write bytes to an nvdimm namespace
- * @ndns: device to read
+ * @ndns: device to write
  * @offset: namespace-relative starting offset
  * @buf: buffer to drain
  * @size: transfer length
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
