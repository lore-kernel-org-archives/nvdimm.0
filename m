Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B21521C91278
 for <linux-nvdimm@lists.01.org>; Tue, 25 Jul 2017 15:40:44 -0700 (PDT)
Subject: [PATCH 2/4] MAINTAINERS: add ndctl files to libnvdimm
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Jul 2017 15:36:21 -0700
Message-ID: <150102218109.2258.12466198358489473437.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150102217021.2258.1380624380896006.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The ndctl project under tools/ndctl/ provides a helper utility and
library interface to the libnvdimm sub-system.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 527d13759ecc..bc9f081faf79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7348,6 +7348,7 @@ F:	drivers/nvdimm/*
 F:	include/linux/nd.h
 F:	include/linux/libnvdimm.h
 F:	include/uapi/linux/ndctl.h
+F:	tools/ndctl/*
 
 LIBNVDIMM BLK: MMIO-APERTURE DRIVER
 M:	Ross Zwisler <ross.zwisler@linux.intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
