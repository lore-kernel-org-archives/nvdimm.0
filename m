Return-Path: <SRS0=uB8i=6Y=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53C2C38A2A
	for <linux-nvdimm@archiver.kernel.org>; Sun, 10 May 2020 15:32:18 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 885112080C
	for <linux-nvdimm@archiver.kernel.org>; Sun, 10 May 2020 15:32:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 885112080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 44211118816FA;
	Sun, 10 May 2020 08:30:00 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.20; helo=mga02.intel.com; envelope-from=redhairer.li@intel.com; receiver=<UNKNOWN> 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EB323118816F8
	for <linux-nvdimm@lists.01.org>; Sun, 10 May 2020 08:29:57 -0700 (PDT)
IronPort-SDR: UfK+nluvSntqyDuST5fvxKSWdlouCqXF6NWhcJ0PPo4VS2bIaaaIl1jPi5VCKU8iFFVVHKsVvp
 MRNP7u2tsYAw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2020 08:32:15 -0700
IronPort-SDR: Zc0KxD+6r0hTy6WPHIhxWtUMLo//EtBrz52MqD2KCTIGGj15ZYYqLxkNOG0k/lEXPZbHGljvYi
 bsxdSIrhxPjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,376,1583222400";
   d="scan'208";a="305960524"
Received: from redhaire-mobl1.gar.corp.intel.com ([10.213.144.142])
  by FMSMGA003.fm.intel.com with ESMTP; 10 May 2020 08:32:14 -0700
From: Redhairer Li <redhairer.li@intel.com>
To: linux-nvdimm@lists.01.org,
	dan.j.williams@intel.com
Subject: [PATCH 1/1] ndctl/namespace: Fix disable-namespace accounting relative to seed devices
Date: Sun, 10 May 2020 23:32:07 +0800
Message-Id: <20200510153207.19296-1-redhairer.li@intel.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Message-ID-Hash: CAYBH24ILIE5LHT6X6DJX5WNMHCJE6NY
X-Message-ID-Hash: CAYBH24ILIE5LHT6X6DJX5WNMHCJE6NY
X-MailFrom: redhairer.li@intel.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Redhairer Li <redhairer.li@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CAYBH24ILIE5LHT6X6DJX5WNMHCJE6NY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Seed namespaces are included in "ndctl disable-namespace all". However
since the user never "creates" them it is surprising to see
"disable-namespace" report 1 more namespace relative to the number that
have been created. Catch attempts to disable a zero-sized namespace:

Before:
{
  "dev":"namespace1.0",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1"
}
{
  "dev":"namespace1.1",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1.1"
}
{
  "dev":"namespace1.2",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1.2"
}
disabled 4 namespaces

After:
{
  "dev":"namespace1.0",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1"
}
{
  "dev":"namespace1.3",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1.3"
}
{
  "dev":"namespace1.1",
  "size":"492.00 MiB (515.90 MB)",
  "blockdev":"pmem1.1"
}
disabled 3 namespaces

Signed-off-by: Redhairer Li <redhairer.li@intel.com>
---
 ndctl/namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 0550580..1bfe736 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -2034,6 +2034,7 @@ static int do_xaction_namespace(const char *namespace,
 	struct ndctl_region *region;
 	const char *ndns_name;
 	struct ndctl_bus *bus;
+	unsigned long long size;
 
 	*processed = 0;
 
@@ -2134,7 +2135,8 @@ static int do_xaction_namespace(const char *namespace,
 				switch (action) {
 				case ACTION_DISABLE:
 					rc = ndctl_namespace_disable_safe(ndns);
-					if (rc == 0)
+					size = ndctl_namespace_get_size(ndns);
+					if (rc == 0 && size != 0)
 						(*processed)++;
 					break;
 				case ACTION_ENABLE:
-- 
2.20.1.windows.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
