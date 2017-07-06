Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71AF320958992
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 14:51:04 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [RFC v2 1/5] acpi: add missing include in acpi_numa.h
Date: Thu,  6 Jul 2017 15:52:29 -0600
Message-Id: <20170706215233.11329-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-kernel@vger.kernel.org
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, Robert, Lukasz, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw" <Jaroslaw.Kogut@intel.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Right now if a file includes acpi_numa.h and they don't happen to include
linux/numa.h before it, they get the following warning:

./include/acpi/acpi_numa.h:9:5: warning: "MAX_NUMNODES" is not defined [-Wundef]
 #if MAX_NUMNODES > 256
     ^~~~~~~~~~~~

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/acpi/acpi_numa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/acpi/acpi_numa.h b/include/acpi/acpi_numa.h
index d4b7294..1e3a74f 100644
--- a/include/acpi/acpi_numa.h
+++ b/include/acpi/acpi_numa.h
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_ACPI_NUMA
 #include <linux/kernel.h>
+#include <linux/numa.h>
 
 /* Proximity bitmap length */
 #if MAX_NUMNODES > 256
-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
