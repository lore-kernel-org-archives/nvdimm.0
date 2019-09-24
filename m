Return-Path: <SRS0=wwh3=XT=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B23C432C1
	for <linux-nvdimm@archiver.kernel.org>; Tue, 24 Sep 2019 17:34:51 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8ED9D2146E
	for <linux-nvdimm@archiver.kernel.org>; Tue, 24 Sep 2019 17:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ED9D2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from [127.0.0.1] (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 70306202F73A6;
	Tue, 24 Sep 2019 10:37:12 -0700 (PDT)
Received-SPF: Pass (sender SPF authorized) identity=mailfrom;
 client-ip=134.134.136.20; helo=mga02.intel.com;
 envelope-from=dave.jiang@intel.com; receiver=linux-nvdimm@lists.01.org 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BDF3202E6E08
 for <linux-nvdimm@lists.01.org>; Tue, 24 Sep 2019 10:37:11 -0700 (PDT)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
 by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384;
 24 Sep 2019 10:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,544,1559545200"; d="scan'208";a="340151973"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
 by orsmga004.jf.intel.com with ESMTP; 24 Sep 2019 10:34:49 -0700
Subject: [PATCH v2] libnvdimm: prevent nvdimm from requesting key when
 security is disabled
From: Dave Jiang <dave.jiang@intel.com>
To: dan.j.williams@intel.com
Date: Tue, 24 Sep 2019 10:34:49 -0700
Message-ID: <156934642272.30222.5230162488753445916.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/unknown-version
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
Cc: jthumshirn@suse.com, peter.stark@ts.fujitsu.com, linux-nvdimm@lists.01.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>

Current implementation attempts to request keys from the keyring even when
security is not enabled. Change behavior so when security is disabled it
will skip key request.

Error messages seen when no keys are installed and libnvdimm is loaded:

request-key[4598]: Cannot find command to construct key 661489677
request-key[4606]: Cannot find command to construct key 34713726
...

Fixes: 4c6926a23b76 ("acpi/nfit, libnvdimm: Add unlock of nvdimm support for Intel DIMMs")

Cc: stable@vger.kernel.org
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2:
- Fix up commit header to add more information and cc stable. (Dan)

 drivers/nvdimm/security.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 9e45b207ff01..89b85970912d 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| !nvdimm->sec.flags)
 		return -EIO;
 
+	/* No need to go further if security is disabled */
+	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
+		return 0;
+
 	if (test_bit(NDD_SECURITY_OVERWRITE, &nvdimm->flags)) {
 		dev_dbg(dev, "Security operation in progress.\n");
 		return -EBUSY;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
