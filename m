Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80E62212017E7
 for <linux-nvdimm@lists.01.org>; Tue, 30 Apr 2019 23:42:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u17so4269595pfn.7
 for <linux-nvdimm@lists.01.org>; Tue, 30 Apr 2019 23:42:22 -0700 (PDT)
Date: Wed, 1 May 2019 12:12:13 +0530
From: Nishad Kamdar <nishadkamdar@gmail.com>
Subject: [PATCH] acpi/nfit: Use the correct style for SPDX License Identifier
Message-ID: <20190501064209.GA4716@nishad>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Keith Busch <keith.busch@intel.com>, Ira Weiny <ira.weiny@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
Cc: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Joe Perches <joe@perches.com>
List-ID: <linux-nvdimm@lists.01.org>

This patch corrects the SPDX License Identifier style
in drivers/acpi/nfit/intel.h. For C header files
Documentation/process/license-rules.rst mandates C-like comments
(opposed to C source files where C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/acpi/nfit/intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/intel.h b/drivers/acpi/nfit/intel.h
index 0aca682ab9d7..8f5461c1dd9d 100644
--- a/drivers/acpi/nfit/intel.h
+++ b/drivers/acpi/nfit/intel.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright(c) 2018 Intel Corporation. All rights reserved.
  * Intel specific definitions for NVDIMM Firmware Interface Table - NFIT
-- 
2.17.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
