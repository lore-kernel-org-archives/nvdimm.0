Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA64B211F9D7B
 for <linux-nvdimm@lists.01.org>; Tue,  7 May 2019 17:09:52 -0700 (PDT)
Subject: [PATCH v2 1/6] drivers/base/devres: Introduce devm_release_action()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 07 May 2019 16:56:05 -0700
Message-ID: <155727336530.292046.2926860263201336366.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Bjorn Helgaas <bhelgaas@google.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

The devm_add_action() facility allows a resource allocation routine to
add custom devm semantics. One such user is devm_memremap_pages().

There is now a need to manually trigger devm_memremap_pages_release().
Introduce devm_release_action() so the release action can be triggered
via a new devm_memunmap_pages() api in a follow-on change.

Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/base/devres.c  |   24 +++++++++++++++++++++++-
 include/linux/device.h |    1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index e038e2b3b7ea..0bbb328bd17f 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -755,10 +755,32 @@ void devm_remove_action(struct device *dev, void (*action)(void *), void *data)
 
 	WARN_ON(devres_destroy(dev, devm_action_release, devm_action_match,
 			       &devres));
-
 }
 EXPORT_SYMBOL_GPL(devm_remove_action);
 
+/**
+ * devm_release_action() - release previously added custom action
+ * @dev: Device that owns the action
+ * @action: Function implementing the action
+ * @data: Pointer to data passed to @action implementation
+ *
+ * Releases and removes instance of @action previously added by
+ * devm_add_action().  Both action and data should match one of the
+ * existing entries.
+ */
+void devm_release_action(struct device *dev, void (*action)(void *), void *data)
+{
+	struct action_devres devres = {
+		.data = data,
+		.action = action,
+	};
+
+	WARN_ON(devres_release(dev, devm_action_release, devm_action_match,
+			       &devres));
+
+}
+EXPORT_SYMBOL_GPL(devm_release_action);
+
 /*
  * Managed kmalloc/kfree
  */
diff --git a/include/linux/device.h b/include/linux/device.h
index 4e6987e11f68..6d7fd5370f3d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -713,6 +713,7 @@ void __iomem *devm_of_iomap(struct device *dev,
 /* allows to add/remove a custom action to devres stack */
 int devm_add_action(struct device *dev, void (*action)(void *), void *data);
 void devm_remove_action(struct device *dev, void (*action)(void *), void *data);
+void devm_release_action(struct device *dev, void (*action)(void *), void *data);
 
 static inline int devm_add_action_or_reset(struct device *dev,
 					   void (*action)(void *), void *data)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
