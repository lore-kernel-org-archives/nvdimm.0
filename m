Return-Path: <SRS0=1VC5=AX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894E2C433FE
	for <linux-nvdimm@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:51 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B10D20702
	for <linux-nvdimm@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B10D20702
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 63A8011591331;
	Sun, 12 Jul 2020 09:42:51 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.24; helo=mga09.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 352ED11591330
	for <linux-nvdimm@lists.01.org>; Sun, 12 Jul 2020 09:42:49 -0700 (PDT)
IronPort-SDR: /1l1LWXzZbWLDuaox7dBeLxH0TiI8wkvVxlGl+VgRXPjMOZrZSzhb4617vACTTbKoNykG5+cuk
 2sORVZz7K9WQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9680"; a="149971532"
X-IronPort-AV: E=Sophos;i="5.75,344,1589266800";
   d="scan'208";a="149971532"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 09:42:49 -0700
IronPort-SDR: ZzOMBq0ET8igwu4TZFb4M2OdcM55gg/QlESleodkOsbeBEKm9gKJZLYMr9qCqV6UMIu2eGNtXI
 gaVJXoQw7NRA==
X-IronPort-AV: E=Sophos;i="5.75,344,1589266800";
   d="scan'208";a="458998362"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 09:42:48 -0700
Subject: [PATCH v2 05/22] resource: Report parent to walk_iomem_res_desc()
 callback
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Sun, 12 Jul 2020 09:26:33 -0700
Message-ID: <159457119303.754248.2238364198589067082.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159457116473.754248.7879464730875147365.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159457116473.754248.7879464730875147365.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: IWZVDE6BEHAF57V47JWCGK57YP6DQBBD
X-Message-ID-Hash: IWZVDE6BEHAF57V47JWCGK57YP6DQBBD
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Jason Gunthorpe <jgg@mellanox.com>, Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, peterz@infradead.org, ard.biesheuvel@linaro.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, joao.m.martins@oracle.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IWZVDE6BEHAF57V47JWCGK57YP6DQBBD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In support of detecting whether a resource might have been been claimed,
report the parent to the walk_iomem_res_desc() callback. For example,
the ACPI HMAT parser publishes "hmem" platform devices per target range.
However, if the HMAT is disabled / missing a fallback driver can attach
devices to the raw memory ranges as a fallback if it sees unclaimed /
orphan "Soft Reserved" resources in the resource tree.

Otherwise, find_next_iomem_res() returns a resource with garbage data
from the stack allocation in __walk_iomem_res_desc() for the res->parent
field.

There are currently no users that expect ->child and ->sibling to be
valid, and the resource_lock would be needed to traverse them. Use a
compound literal to implicitly zero initialize the fields that are not
being returned in addition to setting ->parent.

Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/resource.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 841737bbda9e..f1175ce93a1d 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -382,10 +382,13 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 
 	if (p) {
 		/* copy data */
-		res->start = max(start, p->start);
-		res->end = min(end, p->end);
-		res->flags = p->flags;
-		res->desc = p->desc;
+		*res = (struct resource) {
+			.start = max(start, p->start),
+			.end = min(end, p->end),
+			.flags = p->flags,
+			.desc = p->desc,
+			.parent = p->parent,
+		};
 	}
 
 	read_unlock(&resource_lock);
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
