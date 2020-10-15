Return-Path: <SRS0=M7Jl=DW=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B793C43457
	for <linux-nvdimm@archiver.kernel.org>; Thu, 15 Oct 2020 01:01:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E20E822255
	for <linux-nvdimm@archiver.kernel.org>; Thu, 15 Oct 2020 01:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E20E822255
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 564F615989D2B;
	Wed, 14 Oct 2020 18:00:57 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.126; helo=mga18.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 0C79415943AEA
	for <linux-nvdimm@lists.01.org>; Wed, 14 Oct 2020 18:00:55 -0700 (PDT)
IronPort-SDR: zb0kgTXdFfxscw6tDaHKf/S3iI0+/xDPdsRZAKJFK2FaO9qJjUAyMVrhdpfQ56L+MrA9Hrorfx
 PTmD+1eavpzA==
X-IronPort-AV: E=McAfee;i="6000,8403,9774"; a="154055175"
X-IronPort-AV: E=Sophos;i="5.77,376,1596524400";
   d="scan'208";a="154055175"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2020 18:00:45 -0700
IronPort-SDR: FfdsxjRqp3q4f4etEQRl1TI5VTynO18vfKev9t2iOTvW0tZxScWrNfuysGf8rx03gz/Y/v7tG4
 l/NGqn36Tp+w==
X-IronPort-AV: E=Sophos;i="5.77,376,1596524400";
   d="scan'208";a="521643942"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2020 18:00:44 -0700
Subject: [PATCH 2/2] xen/unpopulated-alloc: Consolidate pgmap manipulation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Date: Wed, 14 Oct 2020 17:42:14 -0700
Message-ID: <160272253442.3136502.16683842453317773487.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <160272252400.3136502.13635752844548960833.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <160272252400.3136502.13635752844548960833.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: TIZXECYBPXUC3DZOPPL4XUUWBRKY6PCY
X-Message-ID-Hash: TIZXECYBPXUC3DZOPPL4XUUWBRKY6PCY
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, akpm@linux-foundation.org, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, dave.hansen@linux.intel.com, linux-nvdimm@lists.01.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TIZXECYBPXUC3DZOPPL4XUUWBRKY6PCY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cleanup fill_list() to keep all the pgmap manipulations in a single
location of the function. Update the exit unwind path accordingly.

Link: http://lore.kernel.org/r/6186fa28-d123-12db-6171-a75cb6e615a5@oracle.com

Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <xen-devel@lists.xenproject.org>
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/xen/unpopulated-alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
index 8c512ea550bb..75ab5de99868 100644
--- a/drivers/xen/unpopulated-alloc.c
+++ b/drivers/xen/unpopulated-alloc.c
@@ -27,11 +27,6 @@ static int fill_list(unsigned int nr_pages)
 	if (!res)
 		return -ENOMEM;
 
-	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
-		goto err_pgmap;
-
-	pgmap->type = MEMORY_DEVICE_GENERIC;
 	res->name = "Xen scratch";
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
@@ -43,6 +38,11 @@ static int fill_list(unsigned int nr_pages)
 		goto err_resource;
 	}
 
+	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
+	if (!pgmap)
+		goto err_pgmap;
+
+	pgmap->type = MEMORY_DEVICE_GENERIC;
 	pgmap->range = (struct range) {
 		.start = res->start,
 		.end = res->end,
@@ -91,10 +91,10 @@ static int fill_list(unsigned int nr_pages)
 	return 0;
 
 err_memremap:
-	release_resource(res);
-err_resource:
 	kfree(pgmap);
 err_pgmap:
+	release_resource(res);
+err_resource:
 	kfree(res);
 	return ret;
 }
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
