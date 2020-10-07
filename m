Return-Path: <SRS0=DizB=DO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BD3C3279D
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 03:11:54 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 638B120838
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 03:11:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 638B120838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id BA831158AFE83;
	Tue,  6 Oct 2020 20:11:53 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.43; helo=mga05.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4FF33158AFE81
	for <linux-nvdimm@lists.01.org>; Tue,  6 Oct 2020 20:11:50 -0700 (PDT)
IronPort-SDR: tUSAjR77D76BqnAuEdUe4dvyexEVnzHxIDpBngwiVFESkAC+ivxAIF/RgHZZu9vP3e4B5R3pqM
 SbgBFby1gmTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="249510692"
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400";
   d="scan'208";a="249510692"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 20:11:50 -0700
IronPort-SDR: +uZNm6tMztulcsNPbamcFIaeGNq+G2pkkWAUrYqTXju9hsrk1O9zDTtmNidqPQomSG/KZFpViB
 0mhTDZOKTyjA==
X-IronPort-AV: E=Sophos;i="5.77,345,1596524400";
   d="scan'208";a="527744123"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 20:11:49 -0700
Subject: [ndctl PATCH] ndctl/namespace: Catch attempts to sub-divide legacy
 / label-less capacity
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Date: Tue, 06 Oct 2020 19:53:21 -0700
Message-ID: <160203920105.2317828.2025624736239651180.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: TS6CDY7KBCH6RLGTA37NY2IK46SWG233
X-Message-ID-Hash: TS6CDY7KBCH6RLGTA37NY2IK46SWG233
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Eric Sandeen <esandeen@redhat.com>, linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/TS6CDY7KBCH6RLGTA37NY2IK46SWG233/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fail attempts to specify a size smaller than the host region to
'create-namespace' when labels are not available. Otherwise ndctl
confusingly succeeds and reports that the namespace is still statically
sized to the region:

Example before:

  # ndctl create-namespace -s 32g
    "size":"63.00 GiB (67.64 GB)",

Example after:

  # ndctl create-namespace -e namespace0.0 -s 2G -f
    Error: Legacy / label-less namespaces do not support sub-dividing a region retry without -s/--size=

  failed to reconfigure namespace: Invalid argument

The memmap= parameter while useful, does not emulate many of the
provisioning flows of real persistent memory devices. The set of useful
namespace configuration that can be performed on top of memmap= defined
region+namespace is reconfiguring the namespace between operation modes:

   create-namespace -e namespace0.0 -f -m {devdax,fsdax,sector}

Link: https://github.com/pmem/ndctl/issues/150
Reported-by: Eric Sandeen <esandeen@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index e734248c9752..e946bb6c9bfa 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -684,6 +684,17 @@ static int validate_namespace_options(struct ndctl_region *region,
 			return rc;
 	}
 
+	/*
+	 * Block attempts to set a custom size on legacy (label-less)
+	 * namespaces
+	 */
+	if (ndctl_region_get_nstype(region) == ND_DEVICE_NAMESPACE_IO
+			&& p->size != ndctl_region_get_size(region)) {
+		error("Legacy / label-less namespaces do not support sub-dividing a region\n");
+		error("Retry without -s/--size=\n");
+		return -EINVAL;
+	}
+
 	if (param.uuid) {
 		if (uuid_parse(param.uuid, p->uuid) != 0) {
 			err("%s: invalid uuid\n", __func__);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
