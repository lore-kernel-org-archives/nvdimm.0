Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F39C433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:36 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6EF620708
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6EF620708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id AC7221108E904;
	Mon,  6 Jul 2020 19:57:36 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.93; helo=mga11.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DB3FF1108E903
	for <linux-nvdimm@lists.01.org>; Mon,  6 Jul 2020 19:57:33 -0700 (PDT)
IronPort-SDR: gMjp/rX9pkqQqCqLqfHMz+S2oNbZgI/nUlxK/wgXg4QgDtu4/8OcIZZeiS4YziFBPxoI8vnsoa
 dANPgllBIpXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="145631394"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="145631394"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:33 -0700
IronPort-SDR: lO4npl3Cp4AqV2NyulezTGQg66z01eDtTDlESj2OIKCGkIsQjogovMxKBP17LgI+rwDmgJvq1E
 mMjlDB0ul7vQ==
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="456950058"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:32 -0700
Subject: [ndctl PATCH 11/16] ndctl/docs: Update copyright date
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: vishal.l.verma@intel.com
Date: Mon, 06 Jul 2020 19:41:17 -0700
Message-ID: <159408967735.2386154.14613913372476840789.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: UY4DMQ4NZTPLYST53OVQSCBNAMC3HESA
X-Message-ID-Hash: UY4DMQ4NZTPLYST53OVQSCBNAMC3HESA
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/UY4DMQ4NZTPLYST53OVQSCBNAMC3HESA/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Happy New Year!

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/copyright.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/copyright.txt b/Documentation/copyright.txt
index 2820a50d2980..760a5be9779e 100644
--- a/Documentation/copyright.txt
+++ b/Documentation/copyright.txt
@@ -2,7 +2,7 @@
 
 COPYRIGHT
 ---------
-Copyright (c) 2016 - 2019, Intel Corporation. License GPLv2: GNU GPL
+Copyright (c) 2016 - 2020, Intel Corporation. License GPLv2: GNU GPL
 version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
 you are free to change and redistribute it.  There is NO WARRANTY, to
 the extent permitted by law.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
