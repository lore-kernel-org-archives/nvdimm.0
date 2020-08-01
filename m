Return-Path: <SRS0=PDkt=BL=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FD6C433DF
	for <linux-nvdimm@archiver.kernel.org>; Sat,  1 Aug 2020 01:54:47 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 729E12087C
	for <linux-nvdimm@archiver.kernel.org>; Sat,  1 Aug 2020 01:54:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 729E12087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 5497B12960B6D;
	Fri, 31 Jul 2020 18:54:47 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.43; helo=mga05.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7C7811295AF95
	for <linux-nvdimm@lists.01.org>; Fri, 31 Jul 2020 18:54:45 -0700 (PDT)
IronPort-SDR: Bs44wjqO/3sTNIHlowEBVQ+7lCBQGMPi+DVvz/xnkg017vS6e94oxXx36CIhrjSKI2bE2YuCos
 6g27mkb+7gYA==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236757665"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800";
   d="scan'208";a="236757665"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 18:54:44 -0700
IronPort-SDR: Tl5QQepecrA3auUMETKGZRd3DePmMCT48Exe5Rrc2ZUX0CUQ7Yt48pWQOyb224ITJeZGB3OiQY
 rRv+gilspRhQ==
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800";
   d="scan'208";a="331340904"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 18:54:44 -0700
Subject: [PATCH] ACPI: NFIT: Fix ARS zero-sized allocation
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Date: Fri, 31 Jul 2020 18:38:26 -0700
Message-ID: <159624590643.3037264.14157533719042907758.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: SKBLPO6W2DGTZ63QJPYJP5UBZNXBGNLT
X-Message-ID-Hash: SKBLPO6W2DGTZ63QJPYJP5UBZNXBGNLT
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/SKBLPO6W2DGTZ63QJPYJP5UBZNXBGNLT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pending commit in -next "devres: handle zero size in devm_kmalloc()"
triggers a boot regression due to the ARS implementation expecting NULL
from a zero-sized allocation. Avoid the zero-sized allocation by
skipping ARS, otherwise crashes with the following signature when
de-referencing ZERO_SIZE_PTR.

     BUG: kernel NULL pointer dereference, address: 0000000000000018
     #PF: supervisor read access in kernel mode
     #PF: error_code(0x0000) - not-present page
     RIP: 0010:__acpi_nfit_scrub+0x28a/0x350 [nfit]
     [..]
     Call Trace:
       ? acpi_nfit_query_poison+0x6a/0x180 [nfit]
       acpi_nfit_scrub+0x36/0xb0 [nfit]
       process_one_work+0x23c/0x580
       worker_thread+0x50/0x3b0

Otherwise the implementation correctly aborts when NULL is returned from
devm_kzalloc() in ars_status_alloc().

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index fb775b967c52..26dd208a0d63 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3334,7 +3334,7 @@ static void acpi_nfit_init_ars(struct acpi_nfit_desc *acpi_desc,
 static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 {
 	struct nfit_spa *nfit_spa;
-	int rc;
+	int rc, do_sched_ars = 0;
 
 	set_bit(ARS_VALID, &acpi_desc->scrub_flags);
 	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
@@ -3346,7 +3346,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 		}
 	}
 
-	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
+	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
 		switch (nfit_spa_type(nfit_spa->spa)) {
 		case NFIT_SPA_VOLATILE:
 		case NFIT_SPA_PM:
@@ -3354,6 +3354,13 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 			rc = ars_register(acpi_desc, nfit_spa);
 			if (rc)
 				return rc;
+
+			/*
+			 * Kick off background ARS if at least one
+			 * region successfully registered ARS
+			 */
+			if (!test_bit(ARS_FAILED, &nfit_spa->ars_state))
+				do_sched_ars++;
 			break;
 		case NFIT_SPA_BDW:
 			/* nothing to register */
@@ -3372,8 +3379,10 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
 			/* don't register unknown regions */
 			break;
 		}
+	}
 
-	sched_ars(acpi_desc);
+	if (do_sched_ars)
+		sched_ars(acpi_desc);
 	return 0;
 }
 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
