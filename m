Return-Path: <SRS0=QvMI=4U=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1473DC3F2C6
	for <linux-nvdimm@archiver.kernel.org>; Tue,  3 Mar 2020 23:14:40 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CDB2120870
	for <linux-nvdimm@archiver.kernel.org>; Tue,  3 Mar 2020 23:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDB2120870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 0837510FC360E;
	Tue,  3 Mar 2020 15:15:31 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.93; helo=mga11.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3268C10FC33F2
	for <linux-nvdimm@lists.01.org>; Tue,  3 Mar 2020 15:15:28 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 15:14:35 -0800
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400";
   d="scan'208";a="412928648"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 15:14:35 -0800
Subject: [ndctl PATCH v2 1/2] ndctl/test: Cleanup test-vs-production nvdimm
 module detection
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Tue, 03 Mar 2020 14:58:30 -0800
Message-ID: <158327631042.2222444.6483138766986602497.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <158300774836.2141307.13052648687237614794.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158300774836.2141307.13052648687237614794.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: YFC6MHPR5B7IHCUZNLEXHDTB6XBK73YF
X-Message-ID-Hash: YFC6MHPR5B7IHCUZNLEXHDTB6XBK73YF
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YFC6MHPR5B7IHCUZNLEXHDTB6XBK73YF/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Update nfit_test_init() to use strcmp() instead of strstr() to filter
which modules are probed to come from the out-of-tree unit-test set.

Reported-by: Jan Kara <jack@suse.cz>
Link: http://lore.kernel.org/r/20200303132850.GA21048@quack2.suse.cz
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/core.c b/test/core.c
index 888f5d8c0e42..3aa746fe6786 100644
--- a/test/core.c
+++ b/test/core.c
@@ -164,7 +164,7 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		 * Don't check for device-dax modules on kernels older
 		 * than 4.7.
 		 */
-		if (strstr(name, "dax")
+		if (strcmp(name, "dax") == 0
 				&& !ndctl_test_attempt(test,
 					KERNEL_VERSION(4, 7, 0)))
 			continue;
@@ -172,8 +172,8 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		/*
 		 * Skip device-dax bus-model modules on pre-v5.1
 		 */
-		if ((strstr(name, "dax_pmem_core")
-				|| strstr(name, "dax_pmem_compat"))
+		if ((strcmp(name, "dax_pmem_core") == 0
+				|| strcmp(name, "dax_pmem_compat") == 0)
 				&& !ndctl_test_attempt(test,
 					KERNEL_VERSION(5, 1, 0)))
 			continue;
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
