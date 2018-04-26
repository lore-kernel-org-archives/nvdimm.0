Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x241.google.com (mail-pg0-x241.google.com
 [IPv6:2607:f8b0:400e:c05::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3749B202E5EF7
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 18:18:45 -0700 (PDT)
Received: by mail-pg0-x241.google.com with SMTP id 82so4760095pge.11
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 18:18:45 -0700 (PDT)
Date: Thu, 26 Apr 2018 09:18:37 +0800
From: Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3 1/3] resource: Use list_head to link sibling resource
Message-ID: <20180426011837.GA79340@WeideMacBook-Pro.local>
References: <20180419001848.3041-1-bhe@redhat.com>
 <20180419001848.3041-2-bhe@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180419001848.3041-2-bhe@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Baoquan He <bhe@redhat.com>
Cc: nicolas.pitre@linaro.org, Brijesh Singh <brijesh.singh@amd.com>, devicetree@vger.kernel.org, David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>, Keith Busch <keith.busch@intel.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Frank Rowand <frowand.list@gmail.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-nvdimm@lists.01.org, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, linux-input@vger.kernel.org, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, Haiyang Zhang <haiyangz@microsoft.com>, josh@joshtriplett.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, robh+dt@kernel.org, Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>, Jonathan Derrick <jonathan.derrick@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 19, 2018 at 08:18:46AM +0800, Baoquan He wrote:
>The struct resource uses singly linked list to link siblings. It's not
>easy to do reverse iteration on sibling list. So replace it with list_head.
>

Hi, Baoquan

Besides changing the data structure, I have another proposal to do the reverse
iteration. Which means it would not affect other users, if you just want a
reverse iteration.

BTW, I don't think Andrew suggest to use linked-list directly. What he wants
is a better solution to your first proposal in
https://patchwork.kernel.org/patch/10300819/.

Below is my proposal of resource reverse iteration without changing current
design.

>From 5d7145d44fe48b98572a03884fa3a3aa82e3cef9 Mon Sep 17 00:00:00 2001
From: Wei Yang <richard.weiyang@gmail.com>
Date: Sat, 24 Mar 2018 23:25:46 +0800
Subject: [PATCH] kernel/resource: add walk_system_ram_res_rev()

As discussed on https://patchwork.kernel.org/patch/10300819/, this patch
comes up with a variant implementation of walk_system_ram_res_rev(), which
uses iteration instead of allocating array to store those resources.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/ioport.h |   3 ++
 kernel/resource.c      | 113 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index da0ebaec25f0..473f1d9cb97e 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -277,6 +277,9 @@ extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
 		    int (*func)(struct resource *, void *));
 extern int
+walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+		    int (*func)(struct resource *, void *));
+extern int
 walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 
diff --git a/kernel/resource.c b/kernel/resource.c
index 769109f20fb7..d4ec5fbc6875 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -73,6 +73,38 @@ static struct resource *next_resource(struct resource *p, bool sibling_only)
 	return p->sibling;
 }
 
+static struct resource *prev_resource(struct resource *p, bool sibling_only)
+{
+	struct resource *prev;
+	if (NULL == iomem_resource.child)
+		return NULL;
+
+	if (p == NULL) {
+		prev = iomem_resource.child;
+		while (prev->sibling)
+			prev = prev->sibling;
+	} else {
+		if (p->parent->child == p) {
+			return p->parent;
+		}
+
+		for (prev = p->parent->child; prev->sibling != p;
+			prev = prev->sibling) {}
+	}
+
+	/* Caller wants to traverse through siblings only */
+	if (sibling_only)
+		return prev;
+
+	for (;prev->child;) {
+		prev = prev->child;
+
+		while (prev->sibling)
+			prev = prev->sibling;
+	}
+	return prev;
+}
+
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -401,6 +433,47 @@ static int find_next_iomem_res(struct resource *res, unsigned long desc,
 	return 0;
 }
 
+/*
+ * Finds the highest iomem resource existing within [res->start.res->end).
+ * The caller must specify res->start, res->end, res->flags, and optionally
+ * desc.  If found, returns 0, res is overwritten, if not found, returns -1.
+ * This function walks the whole tree and not just first level children until
+ * and unless first_level_children_only is true.
+ */
+static int find_prev_iomem_res(struct resource *res, unsigned long desc,
+			       bool first_level_children_only)
+{
+	struct resource *p;
+
+	BUG_ON(!res);
+	BUG_ON(res->start >= res->end);
+
+	read_lock(&resource_lock);
+
+	for (p = prev_resource(NULL, first_level_children_only); p;
+		p = prev_resource(p, first_level_children_only)) {
+		if ((p->flags & res->flags) != res->flags)
+			continue;
+		if ((desc != IORES_DESC_NONE) && (desc != p->desc))
+			continue;
+		if (p->end < res->start || p->child == iomem_resource.child) {
+			p = NULL;
+			break;
+		}
+		if ((p->end >= res->start) && (p->start < res->end))
+			break;
+	}
+
+	read_unlock(&resource_lock);
+	if (!p)
+		return -1;
+	/* copy data */
+	resource_clip(res, p->start, p->end);
+	res->flags = p->flags;
+	res->desc = p->desc;
+	return 0;
+}
+
 static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
 				 bool first_level_children_only,
 				 void *arg,
@@ -422,6 +495,27 @@ static int __walk_iomem_res_desc(struct resource *res, unsigned long desc,
 	return ret;
 }
 
+static int __walk_iomem_res_rev_desc(struct resource *res, unsigned long desc,
+				 bool first_level_children_only,
+				 void *arg,
+				 int (*func)(struct resource *, void *))
+{
+	u64 orig_start = res->start;
+	int ret = -1;
+
+	while ((res->start < res->end) &&
+	       !find_prev_iomem_res(res, desc, first_level_children_only)) {
+		ret = (*func)(res, arg);
+		if (ret)
+			break;
+
+		res->end = res->start?(res->start - 1):0;
+		res->start = orig_start;
+	}
+
+	return ret;
+}
+
 /*
  * Walks through iomem resources and calls func() with matching resource
  * ranges. This walks through whole tree and not just first level children.
@@ -468,6 +562,25 @@ int walk_system_ram_res(u64 start, u64 end, void *arg,
 				     arg, func);
 }
 
+/*
+ * This function, being a variant of walk_system_ram_res(), calls the @func
+ * callback against all memory ranges of type System RAM which are marked as
+ * IORESOURCE_SYSTEM_RAM and IORESOUCE_BUSY in reversed order, i.e., from
+ * higher to lower.
+ */
+int walk_system_ram_res_rev(u64 start, u64 end, void *arg,
+				int (*func)(struct resource *, void *))
+{
+	struct resource res;
+
+	res.start = start;
+	res.end = end;
+	res.flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
+
+	return __walk_iomem_res_rev_desc(&res, IORES_DESC_NONE, true,
+				     arg, func);
+}
+
 /*
  * This function calls the @func callback against all memory ranges, which
  * are ranges marked as IORESOURCE_MEM and IORESOUCE_BUSY.
-- 
2.15.1


-- 
Wei Yang
Help you, Help me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
