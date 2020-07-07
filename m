Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFC0C433E3
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:15:39 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC40920722
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC40920722
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C6BF81108DEAC;
	Mon,  6 Jul 2020 19:15:39 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.65; helo=mga03.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D5E8E1108DEAA
	for <linux-nvdimm@lists.01.org>; Mon,  6 Jul 2020 19:15:37 -0700 (PDT)
IronPort-SDR: XE6PNp7KsQtQZitxOu3SeDlQ5Zw/beYoxYADdvH5wgM9jhm1QKCBT8mBxpZdW49ya7piVDdbTR
 SNlkXmuaW52A==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="147538466"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="147538466"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:15:37 -0700
IronPort-SDR: 9ZYdVverSyw+u3Za8MVw+ijVSrccrbAuYHQN729lvemfQ4/5iVg707QpK2r9am9Bbl25/+FM3P
 Y/UrocfzT/Cw==
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="266694312"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:15:37 -0700
Subject: [PATCH v2 09/12] libnvdimm: Convert to DEVICE_ATTR_ADMIN_RO()
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Mon, 06 Jul 2020 18:59:21 -0700
Message-ID: <159408716166.2385045.5987808622423332941.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159408711335.2385045.2567600405906448375.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159408711335.2385045.2567600405906448375.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: RPFKVZP7WS7YFIUAHNYCYZLDFP7RIYKM
X-Message-ID-Hash: RPFKVZP7WS7YFIUAHNYCYZLDFP7RIYKM
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RPFKVZP7WS7YFIUAHNYCYZLDFP7RIYKM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move libnvdimm sysfs attributes that currently use an open coded
DEVICE_ATTR() to hide sensitive root-only information (physical memory
layout) to the new DEVICE_ATTR_ADMIN_RO() helper.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |    2 +-
 drivers/nvdimm/pfn_devs.c       |    2 +-
 drivers/nvdimm/region_devs.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index ae155e860fdc..6da67f4d641a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1309,7 +1309,7 @@ static ssize_t resource_show(struct device *dev,
 		return -ENXIO;
 	return sprintf(buf, "%#llx\n", (unsigned long long) res->start);
 }
-static DEVICE_ATTR(resource, 0400, resource_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(resource);
 
 static const unsigned long blk_lbasize_supported[] = { 512, 520, 528,
 	4096, 4104, 4160, 4224, 0 };
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 34db557dbad1..3e11ef8d3f5b 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -218,7 +218,7 @@ static ssize_t resource_show(struct device *dev,
 
 	return rc;
 }
-static DEVICE_ATTR(resource, 0400, resource_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(resource);
 
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 4502f9c4708d..20ff30c2ab93 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -605,7 +605,7 @@ static ssize_t resource_show(struct device *dev,
 
 	return sprintf(buf, "%#llx\n", nd_region->ndr_start);
 }
-static DEVICE_ATTR(resource, 0400, resource_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(resource);
 
 static ssize_t persistence_domain_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
