Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from relay.sgi.com (relay1.sgi.com [192.48.180.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A03FB21BADAB2
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 15:54:22 -0700 (PDT)
Message-Id: <20180730195548.580717146@stormcage.americas.sgi.com>
References: <20180730195545.795802877@stormcage.americas.sgi.com>
Date: Mon, 30 Jul 2018 14:55:46 -0500
From: Mike Travis <mike.travis@hpe.com>
Subject: [PATCH 1/1] x86, pmem,
 acpi: Remove excessive ACPI Large Reference Count warnings
Content-Disposition: inline; filename=incr-acpi-ref-cnt-warning
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
To: Robert Moore <robert.moore@intel.com>, Erik Schmauss <erik.schmauss@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <lenb@kernel.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>, Russ Anderson <russ.anderson@hpe.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, devel@acpica.org
List-ID: <linux-nvdimm@lists.01.org>

With the Intel BIOS support for 8 processor sockets with a full complement
of NVDIMMS potentially installable, and there are empty sockets without
NVDIMMS, there is an extremely large amount of the following warnings:

ACPI Warning: Large Reference Count (0x1001) in object ffff99453fc71750,
	Type=0x0A

On a 4 socket system with 4 NVDIMMs there were over 6000 of these warning
messages and it has been seem on systems from 4 to 32 sockets.

Through some guidance from the BIOS developers and testing, it appears
that simply bumping up the threshold for warnings from 0x1000 to 0x2000
eliminates these messages.  Changing them to be ACPI DEBUG messages, or
even removing them are other options, but it would then defeat the purpose
of the warnings as the problem would effectively be hidden.

Reviewed-by: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Tested-by: Russ Anderson <russ.anderson@hpe.com>
Signed-off-by: Mike Travis <mike.travis@hpe.com>
---
 include/acpi/acconfig.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-4.12.orig/include/acpi/acconfig.h
+++ linux-4.12/include/acpi/acconfig.h
@@ -123,7 +123,7 @@
 
 /* Maximum object reference count (detects object deletion issues) */
 
-#define ACPI_MAX_REFERENCE_COUNT        0x1000
+#define ACPI_MAX_REFERENCE_COUNT        0x2000
 
 /* Default page size for use in mapping memory for operation regions */
 

-- 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
