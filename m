Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB27460
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657843350; x=1689379350;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHmWXe/fj8s99H1gM2mKlKkxWW6tK1PQHi8PV+spXQI=;
  b=nU68YlKyRt4VCPPaKJrlgekFnkpIa7oBHNk0ocLvCXrokD11gjgYdbAG
   HeeiyqX86ur+dzAqP/XpL2Ekq6AdbqmJd7pDe0vHDaAmURtAeLpqcgpAd
   ZtkNadV+p60+SiT3BIcQ7u0lNUmSDfMkAbThfYxyb+VgfxHlUL+4wpNfj
   JtmTPoOvXoxxx4grQLnOgYEYatQ4UBdZ9MRwiNNXltXWq0OEv2R6cW9Em
   1Wpr7ap37aJfSky4/ayQAbRP+8z46vnSzu3yTiTLvjkXTeHjs4/5MYFpj
   Gusryf8gF0EVVWPthZouUUNUUA+eNs3B2gLGeh9g3mE+fr5JpVFE/vQxG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="266073625"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="266073625"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="546461988"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 17:02:02 -0700
Subject: [PATCH v2 14/28] cxl/hdm: Add sysfs attributes for interleave ways
 + granularity
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <bwidawsk@kernel.org>, hch@lst.de, nvdimm@lists.linux.dev,
 linux-pci@vger.kernel.org
Date: Thu, 14 Jul 2022 17:02:02 -0700
Message-ID: <165784332235.1758207.7185062713652694607.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <bwidawsk@kernel.org>

The region provisioning flow involves selecting interleave ways +
granularity settings for a region, and then programming the decoder
topology to meet those constraints, if possible. For example, root
decoders set the minimum interleave ways + granularity for any hosted
regions.

Given decoder programming is not atomic and collisions can occur between
multiple requesting regions userspace will be responsible for conflict
resolution and it needs these attributes to make those decisions.

Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
[djbw: reword changelog, make read-only, add sysfs ABI documentaion]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl |   27 +++++++++++++++++++++++++++
 drivers/cxl/core/port.c                 |   23 +++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 9b6cc7cdc73b..0362ae98218e 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -230,3 +230,30 @@ Description:
 		allocations are enforced to occur in increasing 'decoderX.Y/id'
 		order and frees are enforced to occur in decreasing
 		'decoderX.Y/id' order.
+
+
+What:		/sys/bus/cxl/devices/decoderX.Y/interleave_ways
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) The number of targets across which this decoder's host
+		physical address (HPA) memory range is interleaved. The device
+		maps every Nth block of HPA (of size ==
+		'interleave_granularity') to consecutive DPA addresses. The
+		decoder's position in the interleave is determined by the
+		device's (endpoint or switch) switch ancestry. For root
+		decoders their interleave is specified by platform firmware and
+		they only specify a downstream target order for host bridges.
+
+
+What:		/sys/bus/cxl/devices/decoderX.Y/interleave_granularity
+Date:		May, 2022
+KernelVersion:	v5.20
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) The number of consecutive bytes of host physical address
+		space this decoder claims at address N before the decode rotates
+		to the next target in the interleave at address N +
+		interleave_granularity (assuming N is aligned to
+		interleave_granularity).
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index b2c44e7ef6a8..a43735f349d6 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -260,10 +260,33 @@ static ssize_t dpa_size_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(dpa_size);
 
+static ssize_t interleave_granularity_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+
+	return sysfs_emit(buf, "%d\n", cxld->interleave_granularity);
+}
+
+static DEVICE_ATTR_RO(interleave_granularity);
+
+static ssize_t interleave_ways_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct cxl_decoder *cxld = to_cxl_decoder(dev);
+
+	return sysfs_emit(buf, "%d\n", cxld->interleave_ways);
+}
+
+static DEVICE_ATTR_RO(interleave_ways);
+
 static struct attribute *cxl_decoder_base_attrs[] = {
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_locked.attr,
+	&dev_attr_interleave_granularity.attr,
+	&dev_attr_interleave_ways.attr,
 	NULL,
 };
 

