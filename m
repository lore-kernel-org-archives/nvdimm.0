Received: from esa7.hc1455-7.c3s2.iphmx.com (esa7.hc1455-7.c3s2.iphmx.com [139.138.61.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FEB60B8C
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 10:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.138.61.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709721031; cv=none; b=s87qWudjHrYyeJYxbfgYw2ifQdk4clFVX2TlxILESh2gew7qsH7yKExX0qOSINqPu9of8azqjz7VsFNrW+0XDwwN9aEK6pyQxsxwsscsLMlYN0KNvOBULLQldBpY26QTDG2FYLIfnQf10VSjI+RK4U0DxSCsAxk2mlWmjLWolpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709721031; c=relaxed/simple;
	bh=cfFr9yDzIDYGuhO0ed+4EUdT/tYXSwMTNGM6ftOGOr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pXwRGxHOleEX9bQoVmqF2edxoSroCmk18CN122McYGAk7d4dUkk8niFG5WlCfZig4TOh4D+SDmD1BFKraCRsTsgSc/Vxp+Y/3mhgWTXOxQMSmLhyZAzxBl5u6NPUmm8ANdu3f+JF97nF/HTiVbXZXELjHH90LYALIEw7bGhqyRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=t6MRrG+I; arc=none smtp.client-ip=139.138.61.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="t6MRrG+I"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1709721029; x=1741257029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cfFr9yDzIDYGuhO0ed+4EUdT/tYXSwMTNGM6ftOGOr0=;
  b=t6MRrG+ILIbQcfC81LTnJpvHK7NuuRVz+Gww++FIofNQ5bSyxqs22UyH
   8hzC2luLvas7yCPQ6NgB96FQhfZHLIoprv763j/VMOxKPUyAJMxC3BxVr
   RELUwj6MgdiZkJse+EjKhLll7uu6y2O7vWRurO4hZr/jSIhdaRmPeC00N
   49CqnBwpqQ1tiIV+Jq8p4kjFv/phzrIzH9zPcNaisJn5Ep87Jw9uPPSIv
   4KPB21t2zQdeyz6G6+pyjtZ6ahfPLCK8/OscOtzN3n3yTZvRjb0lm+yMw
   UYZEO8TOX8bJJYgPxDkhkuaOcjV4i1CMlu/bmETvhTEStOLmO6TW1HMIM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="130208884"
X-IronPort-AV: E=Sophos;i="6.06,208,1705330800"; 
   d="scan'208";a="130208884"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa7.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 19:29:17 +0900
Received: from yto-m3.gw.nic.fujitsu.com (yto-nat-yto-m3.gw.nic.fujitsu.com [192.168.83.66])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 52BAB9CCB6
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:13 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 802F0E6182
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:12 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 1207F202CB587
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 19:29:12 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 1E80D1A006D;
	Wed,  6 Mar 2024 18:29:11 +0800 (CST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: y-goto@fujitsu.com,
	Alison Schofield <alison.schofield@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	hpa@zytor.com,
	Ingo Molnar <mingo@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	x86@kernel.org,
	kexec@lists.infradead.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v3 7/7] nvdimm: set force_raw=1 in kdump kernel
Date: Wed,  6 Mar 2024 18:28:46 +0800
Message-Id: <20240306102846.1020868-8-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240306102846.1020868-1-lizhijian@fujitsu.com>
References: <20240306102846.1020868-1-lizhijian@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28234.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28234.006
X-TMASE-Result: 10-2.938000-10.000000
X-TMASE-MatchedRID: MGSvkkc+rOj7w6uw5pqYnoOlbll4OMtk9LMB0hXFSeg6Zx3YUNQTG+Wh
	NKYuM7eN4QRvjxz49tHS7j6TEIEt1D3TQfUpAv1sPkILbTHNp5vYUDvAr2Y/17fYIuZsOQ0sOXB
	2cqV0mCIre4xpX839SBGJgBWjZYF4x7Pq8adLcfrum6Nvy6t3NlK6+0HOVoSowLkNMQzGl5B+Kr
	WCPbERP80Age9hS2jaRMoI0qlZNIJF28kU6TjvF869emDs42ddfS0Ip2eEHnz3IzXlXlpamPoLR
	4+zsDTtqrM46JQnL8hECPUxiiiZOrOyZvt4D+xsOs3xt1PQttJyHuAILm2j36P9W6TbIoRbP/Sq
	eQCjGYXssHsZ3G5ixlOiTS2pFc4fpGuqGtYITgaGk+xUaqdMDwHEKwHwYevbwUSxXh+jiUgkww/
	gwY7hMA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

The virtually mapped memory map allows storing struct page objects for
persistent memory devices in pre-allocated storage on those devices.
These 'struct page objects' on devices are also known as metadata.

During libnvdimm/nd_pmem are loading, the previous metadata will
be re-constructed to fit the current running kernel. For kdump purpose,
these metadata should not be touched until the dumping is done so that
the metadata is identical.

To achieve this, we have some options
1. Don't provide libnvdimm driver in kdump kernel rootfs/initramfs
2. Disable libnvdimm driver by specific comline parameters:
   (initcall_blacklist=libnvdimm_init libnvdimm.blacklist=1 rd.driver.blacklist=libnvdimm)
3. Enforce force_raw=1 for nvdimm namespace, because when force_raw=1,
   metadata will not be re-constructed again. This may also result in
   the pmem doesn't work before a few extra configurations.

Here apply the 3rd option.

CC: Dan Williams <dan.j.williams@intel.com>
CC: Vishal Verma <vishal.l.verma@intel.com>
CC: Dave Jiang <dave.jiang@intel.com>
CC: Ira Weiny <ira.weiny@intel.com>
CC: nvdimm@lists.linux.dev
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
 drivers/nvdimm/namespace_devs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index d6d558f94d6b..04f855c7f0b1 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/nd.h>
+#include <linux/crash_dump.h>
 #include "nd-core.h"
 #include "pmem.h"
 #include "pfn.h"
@@ -1513,6 +1514,8 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 			return ERR_PTR(-ENODEV);
 	}
 
+	if (is_kdump_kernel())
+		ndns->force_raw = true;
 	return ndns;
 }
 EXPORT_SYMBOL(nvdimm_namespace_common_probe);
-- 
2.29.2

