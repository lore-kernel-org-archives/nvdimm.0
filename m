Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/3] resource: Make __request_region to inherit from immediate parent
Date: Tue,  2 Feb 2016 11:55:09 -0700
Message-Id: <1454439311-23690-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
References: <1454439311-23690-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, bp@suse.de, dan.j.williams@intel.com, rjw@rjwysocki.net, akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

__request_region() sets 'flags' from a given 'parent' to inherit
its attribute.  When a target resource has conflict, this function
inserts a resource entry under the conflicted entry by updating
'parent'.  In this case, the new resource entry needs to inherit
attribute from the updated parent.

For instance, request_mem_region() calls __request_region() with
'parent' set to &iomem_resource, which is the root entry of the
whole iomem range.  When this request results in inserting a new
entry "new" under "DEV-A", "new" needs to inherit from the immediate
parent "DEV-A" as it holds specific attribute for the range.

root (&iomem_resource)
 :
 + "DEV-A"
    + "new"

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
index 4983430..9df79ff 100644
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
