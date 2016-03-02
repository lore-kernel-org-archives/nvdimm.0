Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 066851A1E91
 for <linux-nvdimm@lists.01.org>; Wed,  2 Mar 2016 13:58:27 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 1/4] resource: Change __request_region to inherit from
 immediate parent
Date: Wed,  2 Mar 2016 15:50:53 -0700
Message-Id: <1456959056-12316-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
References: <1456959056-12316-1-git-send-email-toshi.kani@hpe.com>
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
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

__request_region() sets 'flags' of a new resource from @parent
as it inherits the parent's attribute.  When a target resource
has a conflict, this function inserts the new resource entry
under the conflicted entry by updating @parent.  In this case,
the new resource entry needs to inherit attribute from the updated
parent.  This conflict is a typical case since __request_region()
is used to allocate a new resource from a specific resource range.

For instance, request_mem_region() calls __request_region() with
@parent set to &iomem_resource, which is the root entry of the
whole iomem range.  When this request results in inserting a new
entry "DEV-A" under "BUS-1", "DEV-A" needs to inherit from the
immediate parent "BUS-1" as it holds specific attribute for the
range.

root (&iomem_resource)
 :
 + "BUS-1"
    + "DEV-A"

Change __request_region() to set 'flags' and 'desc' of a new entry
from the immediate parent.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 kernel/resource.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 4d46605..5a56e8f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1085,15 +1085,16 @@ struct resource * __request_region(struct resource *parent,
 	res->name = name;
 	res->start = start;
 	res->end = start + n - 1;
-	res->flags = resource_type(parent) | resource_ext_type(parent);
-	res->flags |= IORESOURCE_BUSY | flags;
-	res->desc = IORES_DESC_NONE;
 
 	write_lock(&resource_lock);
 
 	for (;;) {
 		struct resource *conflict;
 
+		res->flags = resource_type(parent) | resource_ext_type(parent);
+		res->flags |= IORESOURCE_BUSY | flags;
+		res->desc = parent->desc;
+
 		conflict = __request_resource(parent, res);
 		if (!conflict)
 			break;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
