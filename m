Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on071a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::71a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A8218032B
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 16:25:32 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH v2 0/3] apci, nfit: DSM improvements
Date: Mon, 6 Mar 2017 19:25:03 -0500
Message-ID: <cover.1488844291.git.linda.knippers@hpe.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The first two patches in this series are motivated by feedback
from distribution developers, test engineers, and management tool
developers.  We need the ability to test and support Linux and
management tools on systems that support more than one DSM family
for NVDIMM-N.

We also need the ability to test and support new functions without
requiring users to update their kernel.  These changes will also
facilate development as we move toward DSM standardization.
The ability to restrict DSM functions to the currently documented
set is still in place.

The third patch cleans up a cosmetic/modinfo parsing issue with one 
of the existing module parameters.

Changes in v2:
- Switched from allowing all functions advertised by the
  firmware through function 0 to an override module parameter.

Linda Knippers (3):
  Allow override of built-in bitmasks for NVDIMM DSMs
  Allow specifying a default DSM family
  Remove unnecessary newline

 drivers/acpi/nfit/core.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
