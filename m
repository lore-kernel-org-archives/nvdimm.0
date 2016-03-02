Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D84EC1A1E94
 for <linux-nvdimm@lists.01.org>; Wed,  2 Mar 2016 13:58:28 -0800 (PST)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 2/4] resource: Add remove_resource interface
Date: Wed,  2 Mar 2016 15:50:54 -0700
Message-Id: <1456959056-12316-3-git-send-email-toshi.kani@hpe.com>
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

insert_resource() and insert_resource_conflict() are called
by resource producers to insert a new resource.  When there
is any conflict, they move conflicting resources down to the
children of the new resource.  There is no destructor of these
interfaces, however.

Add remove_resource(), which removes a resource previously
inserted by insert_resource() or insert_resource_conflict(),
and moves the children up to where they were before.

__release_resource() is changed to have @release_child, so
that this function can be used for remove_resource() as well.

Also add comments to clarify that these functions are intended
for producers of resources to avoid any confusion with
request/release_resource() for consumers.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   51 +++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index afb4559..8017b8b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -174,6 +174,7 @@ extern void reserve_region_with_split(struct resource *root,
 extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
+extern int remove_resource(struct resource *old);
 extern void arch_remove_reservations(struct resource *avail);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
diff --git a/kernel/resource.c b/kernel/resource.c
index 5a56e8f..effb6ee 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -233,9 +233,9 @@ static struct resource * __request_resource(struct resource *root, struct resour
 	}
 }
 
-static int __release_resource(struct resource *old)
+static int __release_resource(struct resource *old, bool release_child)
 {
-	struct resource *tmp, **p;
+	struct resource *tmp, **p, *chd;
 
 	p = &old->parent->child;
 	for (;;) {
@@ -243,7 +243,17 @@ static int __release_resource(struct resource *old)
 		if (!tmp)
 			break;
 		if (tmp == old) {
-			*p = tmp->sibling;
+			if (release_child || !(tmp->child)) {
+				*p = tmp->sibling;
+			} else {
+				for (chd = tmp->child;; chd = chd->sibling) {
+					chd->parent = tmp->parent;
+					if (!(chd->sibling))
+						break;
+				}
+				*p = tmp->child;
+				chd->sibling = tmp->sibling;
+			}
 			old->parent = NULL;
 			return 0;
 		}
@@ -325,7 +335,7 @@ int release_resource(struct resource *old)
 	int retval;
 
 	write_lock(&resource_lock);
-	retval = __release_resource(old);
+	retval = __release_resource(old, true);
 	write_unlock(&resource_lock);
 	return retval;
 }
@@ -679,7 +689,7 @@ static int reallocate_resource(struct resource *root, struct resource *old,
 		old->start = new.start;
 		old->end = new.end;
 	} else {
-		__release_resource(old);
+		__release_resource(old, true);
 		*old = new;
 		conflict = __request_resource(root, old);
 		BUG_ON(conflict);
@@ -825,6 +835,9 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
  * entirely fit within the range of the new resource, then the new
  * resource is inserted and the conflicting resources become children of
  * the new resource.
+ *
+ * This function is intended for producers of resources, such as FW modules
+ * and bus drivers.
  */
 struct resource *insert_resource_conflict(struct resource *parent, struct resource *new)
 {
@@ -842,6 +855,9 @@ struct resource *insert_resource_conflict(struct resource *parent, struct resour
  * @new: new resource to insert
  *
  * Returns 0 on success, -EBUSY if the resource can't be inserted.
+ *
+ * This function is intended for producers of resources, such as FW modules
+ * and bus drivers.
  */
 int insert_resource(struct resource *parent, struct resource *new)
 {
@@ -885,6 +901,31 @@ void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
 	write_unlock(&resource_lock);
 }
 
+/**
+ * remove_resource - Remove a resource in the resource tree
+ * @old: resource to remove
+ *
+ * Returns 0 on success, -EINVAL if the resource is not valid.
+ *
+ * This function removes a resource previously inserted by insert_resource()
+ * or insert_resource_conflict(), and moves the children (if any) up to
+ * where they were before.  insert_resource() and insert_resource_conflict()
+ * insert a new resource, and move any conflicting resources down to the
+ * children of the new resource.
+ *
+ * insert_resource(), insert_resource_conflict() and remove_resource() are
+ * intended for producers of resources, such as FW modules and bus drivers.
+ */
+int remove_resource(struct resource *old)
+{
+	int retval;
+
+	write_lock(&resource_lock);
+	retval = __release_resource(old, false);
+	write_unlock(&resource_lock);
+	return retval;
+}
+
 static int __adjust_resource(struct resource *res, resource_size_t start,
 				resource_size_t size)
 {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
