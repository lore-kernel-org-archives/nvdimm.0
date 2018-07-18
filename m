Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F1322097F544
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 19:50:26 -0700 (PDT)
From: Baoquan He <bhe@redhat.com>
Subject: [PATCH v7 1/4] resource: Move reparent_resources() to
 kernel/resource.c and make it public
Date: Wed, 18 Jul 2018 10:49:41 +0800
Message-Id: <20180718024944.577-2-bhe@redhat.com>
In-Reply-To: <20180718024944.577-1-bhe@redhat.com>
References: <20180718024944.577-1-bhe@redhat.com>
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
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, robh+dt@kernel.org, dan.j.williams@intel.com, nicolas.pitre@linaro.org, josh@joshtriplett.org, fengguang.wu@intel.com, bp@suse.de, andy.shevchenko@gmail.com
Cc: brijesh.singh@amd.com, devicetree@vger.kernel.org, airlied@linux.ie, linux-pci@vger.kernel.org, richard.weiyang@gmail.com, jcmvbkbc@gmail.com, Paul Mackerras <paulus@samba.org>, baiyaowei@cmss.chinamobile.com, kys@microsoft.com, frowand.list@gmail.com, lorenzo.pieralisi@arm.com, sthemmin@microsoft.com, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, Michael Ellerman <mpe@ellerman.id.au>, patrik.r.jakobsson@gmail.com, linux-input@vger.kernel.org, gustavo@padovan.org, dyoung@redhat.com, thomas.lendacky@amd.com, haiyangz@microsoft.com, maarten.lankhorst@linux.intel.com, jglisse@redhat.com, seanpaul@chromium.org, bhelgaas@google.com, tglx@linutronix.de, yinghai@kernel.org, jonathan.derrick@intel.com, chris@zankel.net, monstr@monstr.eu, linux-parisc@vger.kernel.org, gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ebiederm@xmission.com, devel@linuxdriverproject.org, linuxppc-dev@lists.ozlabs.org, davem@davemloft.net
List-ID: <linux-nvdimm@lists.01.org>

reparent_resources() is duplicated in arch/microblaze/pci/pci-common.c
and arch/powerpc/kernel/pci-common.c, so move it to kernel/resource.c
so that it's shared.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org
---
 arch/microblaze/pci/pci-common.c | 37 -----------------------------------
 arch/powerpc/kernel/pci-common.c | 35 ---------------------------------
 include/linux/ioport.h           |  1 +
 kernel/resource.c                | 42 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 72 deletions(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index f34346d56095..7899bafab064 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -619,43 +619,6 @@ int pcibios_add_device(struct pci_dev *dev)
 EXPORT_SYMBOL(pcibios_add_device);
 
 /*
- * Reparent resource children of pr that conflict with res
- * under res, and make res replace those children.
- */
-static int __init reparent_resources(struct resource *parent,
-				     struct resource *res)
-{
-	struct resource *p, **pp;
-	struct resource **firstpp = NULL;
-
-	for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
-		if (p->end < res->start)
-			continue;
-		if (res->end < p->start)
-			break;
-		if (p->start < res->start || p->end > res->end)
-			return -1;	/* not completely contained */
-		if (firstpp == NULL)
-			firstpp = pp;
-	}
-	if (firstpp == NULL)
-		return -1;	/* didn't find any conflicting entries? */
-	res->parent = parent;
-	res->child = *firstpp;
-	res->sibling = *pp;
-	*firstpp = res;
-	*pp = NULL;
-	for (p = res->child; p != NULL; p = p->sibling) {
-		p->parent = res;
-		pr_debug("PCI: Reparented %s [%llx..%llx] under %s\n",
-			 p->name,
-			 (unsigned long long)p->start,
-			 (unsigned long long)p->end, res->name);
-	}
-	return 0;
-}
-
-/*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
  *  On the other hand, we cannot just re-allocate all devices, as it would
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index fe9733ffffaa..926035bb378d 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1088,41 +1088,6 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 EXPORT_SYMBOL(pcibios_align_resource);
 
 /*
- * Reparent resource children of pr that conflict with res
- * under res, and make res replace those children.
- */
-static int reparent_resources(struct resource *parent,
-				     struct resource *res)
-{
-	struct resource *p, **pp;
-	struct resource **firstpp = NULL;
-
-	for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
-		if (p->end < res->start)
-			continue;
-		if (res->end < p->start)
-			break;
-		if (p->start < res->start || p->end > res->end)
-			return -1;	/* not completely contained */
-		if (firstpp == NULL)
-			firstpp = pp;
-	}
-	if (firstpp == NULL)
-		return -1;	/* didn't find any conflicting entries? */
-	res->parent = parent;
-	res->child = *firstpp;
-	res->sibling = *pp;
-	*firstpp = res;
-	*pp = NULL;
-	for (p = res->child; p != NULL; p = p->sibling) {
-		p->parent = res;
-		pr_debug("PCI: Reparented %s %pR under %s\n",
-			 p->name, p, res->name);
-	}
-	return 0;
-}
-
-/*
  *  Handle resources of PCI devices.  If the world were perfect, we could
  *  just allocate all the resource regions and do nothing more.  It isn't.
  *  On the other hand, we cannot just re-allocate all devices, as it would
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index da0ebaec25f0..dfdcd0bfe54e 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -192,6 +192,7 @@ extern int allocate_resource(struct resource *root, struct resource *new,
 struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
+int reparent_resources(struct resource *parent, struct resource *res);
 resource_size_t resource_alignment(struct resource *res);
 static inline resource_size_t resource_size(const struct resource *res)
 {
diff --git a/kernel/resource.c b/kernel/resource.c
index 30e1bc68503b..81ccd19c1d9f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -983,6 +983,48 @@ int adjust_resource(struct resource *res, resource_size_t start,
 }
 EXPORT_SYMBOL(adjust_resource);
 
+/**
+ * reparent_resources - reparent resource children of parent that res covers
+ * @parent: parent resource descriptor
+ * @res: resource descriptor desired by caller
+ *
+ * Returns 0 on success, -ENOTSUPP if child resource is not completely
+ * contained by 'res', -ECANCELED if no any conflicting entry found.
+ *
+ * Reparent resource children of 'parent' that conflict with 'res'
+ * under 'res', and make 'res' replace those children.
+ */
+int reparent_resources(struct resource *parent, struct resource *res)
+{
+	struct resource *p, **pp;
+	struct resource **firstpp = NULL;
+
+	for (pp = &parent->child; (p = *pp) != NULL; pp = &p->sibling) {
+		if (p->end < res->start)
+			continue;
+		if (res->end < p->start)
+			break;
+		if (p->start < res->start || p->end > res->end)
+			return -ENOTSUPP;	/* not completely contained */
+		if (firstpp == NULL)
+			firstpp = pp;
+	}
+	if (firstpp == NULL)
+		return -ECANCELED; /* didn't find any conflicting entries? */
+	res->parent = parent;
+	res->child = *firstpp;
+	res->sibling = *pp;
+	*firstpp = res;
+	*pp = NULL;
+	for (p = res->child; p != NULL; p = p->sibling) {
+		p->parent = res;
+		pr_debug("PCI: Reparented %s %pR under %s\n",
+			 p->name, p, res->name);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(reparent_resources);
+
 static void __init __reserve_region_with_split(struct resource *root,
 		resource_size_t start, resource_size_t end,
 		const char *name)
-- 
2.13.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
