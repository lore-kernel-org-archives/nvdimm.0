Return-Path: <SRS0=AdRK=ZG=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EDDC432C3
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 00:36:27 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 137A8206EC
	for <linux-nvdimm@archiver.kernel.org>; Thu, 14 Nov 2019 00:36:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 137A8206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 42548100DC437;
	Wed, 13 Nov 2019 16:38:01 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.151; helo=mga17.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 96891100DC434
	for <linux-nvdimm@lists.01.org>; Wed, 13 Nov 2019 16:37:58 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 16:36:23 -0800
X-IronPort-AV: E=Sophos;i="5.68,302,1569308400";
   d="scan'208";a="207625341"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 16:36:22 -0800
Subject: [PATCH] tools/testing/nvdimm: Fix mock support for ioremap
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Wed, 13 Nov 2019 16:22:06 -0800
Message-ID: <157369090817.2974548.10148423996292973088.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: CLIDKNQ6RPMIZZHB57RFHMB3NSNNRI35
X-Message-ID-Hash: CLIDKNQ6RPMIZZHB57RFHMB3NSNNRI35
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CLIDKNQ6RPMIZZHB57RFHMB3NSNNRI35/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After commit d092a8707326 "arch: rely on asm-generic/io.h for default
ioremap_* definitions" the ioremap_nocache() symbol has been replaced
with ioremap(). Update the mocked symbol list for nvdimm testing.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Noticed this while trying the nvdimm tests on latest linux-next.

 tools/testing/nvdimm/Kbuild       |    1 +
 tools/testing/nvdimm/test/iomap.c |    6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index c4a9196d794c..6aca8d5be159 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -5,6 +5,7 @@ ldflags-y += --wrap=devm_ioremap_nocache
 ldflags-y += --wrap=devm_memremap
 ldflags-y += --wrap=devm_memunmap
 ldflags-y += --wrap=ioremap_nocache
+ldflags-y += --wrap=ioremap
 ldflags-y += --wrap=iounmap
 ldflags-y += --wrap=memunmap
 ldflags-y += --wrap=__devm_request_region
diff --git a/tools/testing/nvdimm/test/iomap.c b/tools/testing/nvdimm/test/iomap.c
index 3f55f2f99112..6271ac757a4b 100644
--- a/tools/testing/nvdimm/test/iomap.c
+++ b/tools/testing/nvdimm/test/iomap.c
@@ -193,6 +193,12 @@ void __iomem *__wrap_ioremap_nocache(resource_size_t offset, unsigned long size)
 }
 EXPORT_SYMBOL(__wrap_ioremap_nocache);
 
+void __iomem *__wrap_ioremap(resource_size_t offset, unsigned long size)
+{
+	return __nfit_test_ioremap(offset, size, ioremap);
+}
+EXPORT_SYMBOL(__wrap_ioremap);
+
 void __iomem *__wrap_ioremap_wc(resource_size_t offset, unsigned long size)
 {
 	return __nfit_test_ioremap(offset, size, ioremap_wc);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
