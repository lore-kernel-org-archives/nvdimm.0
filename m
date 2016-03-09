Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DFB91A1F5B
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 10:54:53 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 3/4] resource: Export insert_resource and remove_resource
Date: Wed,  9 Mar 2016 12:47:05 -0700
Message-Id: <1457552826-13987-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1457552826-13987-1-git-send-email-toshi.kani@hpe.com>
References: <1457552826-13987-1-git-send-email-toshi.kani@hpe.com>
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
Cc: linux-acpi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

insert_resource() and remove_resouce() are called by producers
of resources, such as FW modules and bus drivers.  These modules
may be implemented as loadable modules.

Export insert_resource() and remove_resouce() so that they can
be called from such modules.

link: https://lkml.org/lkml/2016/3/8/872
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 kernel/resource.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index effb6ee..2e78ead 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -866,6 +866,7 @@ int insert_resource(struct resource *parent, struct resource *new)
 	conflict = insert_resource_conflict(parent, new);
 	return conflict ? -EBUSY : 0;
 }
+EXPORT_SYMBOL_GPL(insert_resource);
 
 /**
  * insert_resource_expand_to_fit - Insert a resource into the resource tree
@@ -925,6 +926,7 @@ int remove_resource(struct resource *old)
 	write_unlock(&resource_lock);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(remove_resource);
 
 static int __adjust_resource(struct resource *res, resource_size_t start,
 				resource_size_t size)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
