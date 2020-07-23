Return-Path: <SRS0=Ht1H=BC=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83521C433E4
	for <linux-nvdimm@archiver.kernel.org>; Thu, 23 Jul 2020 17:51:59 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4611D22B47
	for <linux-nvdimm@archiver.kernel.org>; Thu, 23 Jul 2020 17:51:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4611D22B47
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1057D12509DA2;
	Thu, 23 Jul 2020 10:51:59 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=195.135.220.15; helo=mx2.suse.de; envelope-from=msuchanek@suse.de; receiver=<UNKNOWN> 
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 70CFA12509D9F
	for <linux-nvdimm@lists.01.org>; Thu, 23 Jul 2020 10:51:55 -0700 (PDT)
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 0CB28AE38
	for <linux-nvdimm@lists.01.org>; Thu, 23 Jul 2020 17:52:02 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: linux-nvdimm@lists.01.org
Subject: [PATCH 2/2] ndctl/namespace: Suppress ENODEV when processing all namespaces.
Date: Thu, 23 Jul 2020 19:51:45 +0200
Message-Id: <3905bc44eec1a7251ea67729aee9ecf4d6d33653.1595526596.git.msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <ac216d4887a00c468acfb323920426135f6861dd.1595526596.git.msuchanek@suse.de>
References: <ac216d4887a00c468acfb323920426135f6861dd.1595526596.git.msuchanek@suse.de>
MIME-Version: 1.0
Message-ID-Hash: QFYITZGOSFI7TUBD23MP44YP43WY6I6R
X-Message-ID-Hash: QFYITZGOSFI7TUBD23MP44YP43WY6I6R
X-MailFrom: msuchanek@suse.de
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Michal Suchanek <msuchanek@suse.de>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/QFYITZGOSFI7TUBD23MP44YP43WY6I6R/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When processing all namespaces and no namespaces exist user gets the
default -ENOENT. Set default rc to 0 when processing all namespaces.
This avoids confusing error message printed in addition to the message
saying 0 namespaces were affected.

Before:

 # ndctl check-namespace all
namespace0.0: namespace_check: namespace0.0: check aborted, namespace online
error checking namespaces: Device or resource busy
checked 0 namespaces
 # ndctl disable-namespace all
disabled 1 namespace
 # ndctl check-namespace all
namespace0.0: namespace_check: Unable to recover any BTT info blocks
error checking namespaces: No such device or address
checked 0 namespaces
 # ndctl destroy-namespace all
destroyed 1 namespace
 # ndctl check-namespace all
error checking namespaces: No such device or address
checked 0 namespaces
 # ndctl destroy-namespace all
error destroying namespaces: No such device or address
destroyed 0 namespaces

After:

 # ndctl check-namespace all
namespace0.0: namespace_check: namespace0.0: check aborted, namespace online
error checking namespaces: Device or resource busy
checked 0 namespaces
 # ndctl disable-namespace namespace0.0
disabled 1 namespace
 # ndctl check-namespace all
namespace0.0: namespace_check: Unable to recover any BTT info blocks
error checking namespaces: No such device or address
checked 0 namespaces
 # ndctl destroy-namespace all
destroyed 1 namespace
 # ndctl check-namespace all
checked 0 namespaces
 # ndctl destroy-namespace all
destroyed 0 namespaces
 # ndctl destroy-namespace all
destroyed 0 namespaces

Note: this does change the return value from -ENOENT to 0 in the cases
when no namespaces exist and processing all namespaces was requested.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 ndctl/namespace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 3fabe4799d75..835f4076008a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2112,6 +2112,9 @@ static int do_xaction_namespace(const char *namespace,
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
 
+	if (namespace && (strcmp(namespace, "all") == 0))
+		rc = 0;
+
 	if (verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
