Return-Path: <SRS0=K/Bp=Y4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F7DCA9EC9
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 Nov 2019 23:09:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D3607214E0
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 Nov 2019 23:09:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3607214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CED7A100EA549;
	Mon,  4 Nov 2019 15:11:58 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.120; helo=mga04.intel.com; envelope-from=vishal.l.verma@intel.com; receiver=<UNKNOWN> 
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id BCF13100EA542
	for <linux-nvdimm@lists.01.org>; Mon,  4 Nov 2019 15:11:56 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 15:09:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400";
   d="scan'208";a="195622116"
Received: from vverma7-desk1.amr.corp.intel.com (HELO vverma7-desk1.lm.intel.com) ([10.232.112.164])
  by orsmga008.jf.intel.com with ESMTP; 04 Nov 2019 15:09:08 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-nvdimm@lists.01.org>
Subject: [ndctl PATCH 1/2] ndctl/namespace: skip seed namespaces for 'enable-namespace'
Date: Mon,  4 Nov 2019 16:08:56 -0700
Message-Id: <20191104230857.28172-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Message-ID-Hash: 53OKT4DZBDVV7HIEODWS7SR273TOJVZC
X-Message-ID-Hash: 53OKT4DZBDVV7HIEODWS7SR273TOJVZC
X-MailFrom: vishal.l.verma@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/53OKT4DZBDVV7HIEODWS7SR273TOJVZC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Performing 'ndctl enable-namespace all' results in ndctl going through a
number of seed namespaces, one per region, and trying to enable them,
which fails as expected. This results in error messages like the
following, which are almost always going to be present, and are almost
always pointless:

  $ sudo ndctl enable-namespace all
  libndctl: ndctl_namespace_enable: namespace3.0: failed to enable
  libndctl: ndctl_namespace_enable: namespace5.0: failed to enable
  error enabling namespaces: No such device or address
  enabled 5 namespaces

Using the new 'ndctl_namespace_is_configuration_idle()' API to determine
whether a given namespace might be a 'seed' namespace, we can avoid
these error messages.

Ad a debug message gated behind the verbose option that prints when a
namespace is skipped when it it detected as a 'seed'.

Link: https://github.com/pmem/ndctl/issues/119
Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index a07d7e2..ed0421b 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1401,6 +1401,11 @@ static int do_xaction_namespace(const char *namespace,
 						(*processed)++;
 					break;
 				case ACTION_ENABLE:
+					if (ndctl_namespace_is_configuration_idle(ndns)) {
+						debug("%s: skip seed namespace\n",
+							ndctl_namespace_get_devname(ndns));
+						continue;
+					}
 					rc = ndctl_namespace_enable(ndns);
 					if (rc >= 0) {
 						(*processed)++;
-- 
2.20.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
