Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D4D2E2652
	for <nvdimm@lists.linux.dev>; Fri, 27 Jun 2025 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034008; cv=none; b=UAt/DIunWPeqmaRf2eXwexlWfS4asH8awKhN0yAHriL6v9htDNh9ezg3B6AVt3m2lLOlT7rfa6hpnl2eW4L+UaU3ZUgneHyjwOJZm6f7fxfPlxRoY/d0T3I57Rx7G0JnsqK4yW8giSeqNAb+w/NBcx1Xx8bNw5baDDEzsVrgbHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034008; c=relaxed/simple;
	bh=X1LW1oZ0Yi5W6s1QSGFN/vY4p6QmWFxGUP/LCeeyHA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ldCIyLAS8ZTbI5TWLrKkmqpcFZ7e+6o3CMI5k3a9jjQZYxEI60fbOXa12CztpP1TBmVUKxbUtQqIUGwM8BFeCAQ9qIUWDg9oQNbmg3vV90ioWC5kNtpCtCSxmvJfWFanaaqDLuW215XHKCHEW50y1EX/dCutMI8MnlBdNsfT6b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N/pdxHje; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N/pdxHje"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751034007; x=1782570007;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X1LW1oZ0Yi5W6s1QSGFN/vY4p6QmWFxGUP/LCeeyHA8=;
  b=N/pdxHje3fd/cte5RS/3HZINzcPdG8ie7dNqeV9rI54ub1EP645GWxer
   I5lcUDhyOFAcgCCsnda+yucHf8zFb2BC6k4+UmpTY/Kb4aPxVxM6ONu7x
   C34XeQtLJzIOZG/n7epBRYxkOFtK+2Ni1t3QzPhCjbe1xBOYFfRc6hmlE
   oEeLchTVDytXbSNPVZ5JSTCoo+AMjPUZjwQ5VbjJo8BDao8C/5JANYeOG
   ZcIOXuBQp8mrthRxHQia9IrytWnstCZm4IjfC9hviVZBUdDnmeQYRp1FL
   PlCJbJz2/M0XgoQVkeGTNCcBlXYLfMzu5ffdPqeviYJLyvppMiTmeNLaj
   Q==;
X-CSE-ConnectionGUID: HnIGGOUHTf+7c5BuyQlafA==
X-CSE-MsgGUID: l1eai6sWQbK9L1iKsIJCFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="52467225"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="52467225"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 07:20:06 -0700
X-CSE-ConnectionGUID: 1rtKbcErQu2qicUgRu890Q==
X-CSE-MsgGUID: IH+tU32BTqu3xrHkLL7q+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="158548200"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa005.jf.intel.com with ESMTP; 27 Jun 2025 07:20:04 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
	id D176B2BA; Fri, 27 Jun 2025 17:20:02 +0300 (EEST)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v2 1/1] libnvdimm: Don't use "proxy" headers
Date: Fri, 27 Jun 2025 17:19:23 +0300
Message-ID: <20250627142001.994860-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update header inclusions to follow IWYU (Include What You Use)
principle.

Note that kernel.h is discouraged to be included as it's written
at the top of that file.

While doing that, sort headers alphabetically.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---

v2: reshuffled includes and forward declarations (Ira)

 include/linux/libnvdimm.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index e772aae71843..28f086c4a187 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -6,12 +6,12 @@
  */
 #ifndef __LIBNVDIMM_H__
 #define __LIBNVDIMM_H__
-#include <linux/kernel.h>
+
+#include <linux/io.h>
 #include <linux/sizes.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
-#include <linux/spinlock.h>
-#include <linux/bio.h>
 
 struct badrange_entry {
 	u64 start;
@@ -80,7 +80,9 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 		struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc);
 
+struct attribute_group;
 struct device_node;
+struct module;
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
 	unsigned long cmd_mask;
@@ -121,6 +123,8 @@ struct nd_mapping_desc {
 	int position;
 };
 
+struct bio;
+struct resource;
 struct nd_region;
 struct nd_region_desc {
 	struct resource *res;
@@ -147,8 +151,6 @@ static inline void __iomem *devm_nvdimm_ioremap(struct device *dev,
 	return (void __iomem *) devm_nvdimm_memremap(dev, offset, size, 0);
 }
 
-struct nvdimm_bus;
-
 /*
  * Note that separate bits for locked + unlocked are defined so that
  * 'flags == 0' corresponds to an error / not-supported state.
@@ -238,6 +240,9 @@ struct nvdimm_fw_ops {
 	int (*arm)(struct nvdimm *nvdimm, enum nvdimm_fwa_trigger arg);
 };
 
+struct kobject;
+struct nvdimm_bus;
+
 void badrange_init(struct badrange *badrange);
 int badrange_add(struct badrange *badrange, u64 addr, u64 length);
 void badrange_forget(struct badrange *badrange, phys_addr_t start,
-- 
2.47.2

