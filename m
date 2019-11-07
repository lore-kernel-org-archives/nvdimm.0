Return-Path: <SRS0=DOXq=Y7=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5405C5DF60
	for <linux-nvdimm@archiver.kernel.org>; Thu,  7 Nov 2019 04:12:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A2FFD218AE
	for <linux-nvdimm@archiver.kernel.org>; Thu,  7 Nov 2019 04:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2FFD218AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 462F7100DC2B7;
	Wed,  6 Nov 2019 20:14:30 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=192.55.52.151; helo=mga17.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 70FFA100DC2A6
	for <linux-nvdimm@lists.01.org>; Wed,  6 Nov 2019 20:14:28 -0800 (PST)
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 20:11:58 -0800
X-IronPort-AV: E=Sophos;i="5.68,276,1569308400";
   d="scan'208";a="229453323"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 20:11:58 -0800
Subject: [PATCH 12/16] dax: Add numa_node to the default device-dax
 attributes
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Date: Wed, 06 Nov 2019 19:57:41 -0800
Message-ID: <157309906102.1582359.4262088001244476001.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <157309899529.1582359.15358067933360719580.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <157309899529.1582359.15358067933360719580.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Message-ID-Hash: 36FXQZI6WZSAOFHUUZKEFGOZ4JUPVGCI
X-Message-ID-Hash: 36FXQZI6WZSAOFHUUZKEFGOZ4JUPVGCI
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: peterz@infradead.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/36FXQZI6WZSAOFHUUZKEFGOZ4JUPVGCI/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It is confusing that device-dax instances publish a 'target_node'
attribute, but not a 'numa_node'. The 'numa_node' information is
available elsewhere in the sysfs device hierarchy, but it is not obvious
and not reliable from one device-dax instance-type (e.g. child devices
of nvdimm namespaces) to the next (e.g. 'hmem' devices defined by EFI
Specific Purpose Memory and the ACPI HMAT).

Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/bus.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index ce6d648d7670..0879b9663eb7 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -322,6 +322,13 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(modalias);
 
+static ssize_t numa_node_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", dev_to_node(dev));
+}
+static DEVICE_ATTR_RO(numa_node);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -329,6 +336,8 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 
 	if (a == &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) < 0)
 		return 0;
+	if (a == &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
+		return 0;
 	return a->mode;
 }
 
@@ -337,6 +346,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
 	&dev_attr_resource.attr,
+	&dev_attr_numa_node.attr,
 	NULL,
 };
 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
