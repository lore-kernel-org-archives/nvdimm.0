Return-Path: <SRS0=8Ot0=HX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2054C433E0
	for <linux-nvdimm@archiver.kernel.org>; Sun, 21 Feb 2021 03:58:54 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1C40864E04
	for <linux-nvdimm@archiver.kernel.org>; Sun, 21 Feb 2021 03:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C40864E04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id DB35C100EBBCD;
	Sat, 20 Feb 2021 19:58:53 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.20; helo=mga02.intel.com; envelope-from=ben.widawsky@intel.com; receiver=<UNKNOWN> 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B4F19100EBBB3
	for <linux-nvdimm@lists.01.org>; Sat, 20 Feb 2021 19:58:51 -0800 (PST)
IronPort-SDR: kFQ7bn3rgxaoRNmgx65TmyFMX3hUPtOr6DaulBj+1ZMvy4wySmn3xo+GOQ41bDGEndEuQjy6Xq
 wf3qpTpkQkPA==
X-IronPort-AV: E=McAfee;i="6000,8403,9901"; a="171311050"
X-IronPort-AV: E=Sophos;i="5.81,194,1610438400";
   d="scan'208";a="171311050"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 19:58:51 -0800
IronPort-SDR: 26YawLk9aCNCA2oAW2ukf+beWUX0Mi6MOgxq+H9lUnamBmO63IO4vwC1DfgvJCYVTlO6QWEq/1
 tYDILTd7PHVA==
X-IronPort-AV: E=Sophos;i="5.81,194,1610438400";
   d="scan'208";a="595424370"
Received: from aevangel-mobl.amr.corp.intel.com (HELO bwidawsk-mobl5.local) ([10.252.134.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 19:58:50 -0800
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
	linux-cxl@vger.kernel.org,
	linux-nvdimm@lists.01.org
Subject: [PATCH v2] cxl/mem: Fix potential memory leak
Date: Sat, 20 Feb 2021 19:58:46 -0800
Message-Id: <20210221035846.680145-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210220215641.604535-1-ben.widawsky@intel.com>
References: <20210220215641.604535-1-ben.widawsky@intel.com>
MIME-Version: 1.0
Message-ID-Hash: 36FF4GMPGIFJIGJU3BTP5ZOMOIJP2ZLN
X-Message-ID-Hash: 36FF4GMPGIFJIGJU3BTP5ZOMOIJP2ZLN
X-MailFrom: ben.widawsky@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Alison Schofield <alison.schofield@intel.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Ben Widawsky <ben.widawsky@intel.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/36FF4GMPGIFJIGJU3BTP5ZOMOIJP2ZLN/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When submitting a command for userspace, input and output payload bounce
buffers are allocated. For a given command, both input and output
buffers may exist and so when allocation of the input buffer fails, the
output buffer must be freed too.

As far as I can tell, userspace can't easily exploit the leak to OOM a
machine unless the machine was already near OOM state.

Fixes: 583fa5e71cae ("cxl/mem: Add basic IOCTL interface")
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
---
 drivers/cxl/mem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index df895bcca63a..244cb7d89678 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -514,8 +514,10 @@ static int handle_mailbox_cmd_from_user(struct cxl_mem *cxlm,
 	if (cmd->info.size_in) {
 		mbox_cmd.payload_in = vmemdup_user(u64_to_user_ptr(in_payload),
 						   cmd->info.size_in);
-		if (IS_ERR(mbox_cmd.payload_in))
+		if (IS_ERR(mbox_cmd.payload_in)) {
+			kvfree(mbox_cmd.payload_out);
 			return PTR_ERR(mbox_cmd.payload_in);
+		}
 	}
 
 	rc = cxl_mem_mbox_get(cxlm);
-- 
2.30.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
