Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam03on0708.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe48::708])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E2AD820A5
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 08:28:13 -0800 (PST)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: [PATCH 0/3] apci, nfit: DSM improvements
Date: Mon, 13 Feb 2017 11:27:46 -0500
Message-ID: <cover.1486750246.git.linda.knippers@hpe.com>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
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

The third patch cleans up a nit.

Linda Knippers (3):
  Allow all supported HPE DSM functions to be called
  Allow specifying a default DSM family
  Remove unnecessary newline

 drivers/acpi/nfit/core.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
