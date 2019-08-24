From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v15 02/18] kunit: test: add test resource management API
Date: Fri, 23 Aug 2019 18:34:09 -0700
Message-ID: <20190824013425.175645-3-brendanhiggins@google.com>
References: <20190824013425.175645-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190824013425.175645-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org
Cc: pmladek-IBi9RG/b67k@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Create a common API for test managed resources like memory and test
objects. A lot of times a test will want to set up infrastructure to be
used in test cases; this could be anything from just wanting to allocate
some memory to setting up a driver stack; this defines facilities for
creating "test resources" which are managed by the test infrastructure
and are automatically cleaned up at the conclusion of the test.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Reviewed-by: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/kunit/test.h | 187 +++++++++++++++++++++++++++++++++++++++++++
 kunit/test.c         | 163 +++++++++++++++++++++++++++++++++++++
 2 files changed, 350 insertions(+)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index e30d1bf2fb68..6781c756f11b 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -9,8 +9,72 @@
 #ifndef _KUNIT_TEST_H
 #define _KUNIT_TEST_H
 
+#include <linux/slab.h>
 #include <linux/types.h>
 
+struct kunit_resource;
+
+typedef int (*kunit_resource_init_t)(struct kunit_resource *, void *);
+typedef void (*kunit_resource_free_t)(struct kunit_resource *);
+
+/**
+ * struct kunit_resource - represents a *test managed resource*
+ * @allocation: for the user to store arbitrary data.
+ * @free: a user supplied function to free the resource. Populated by
+ * kunit_alloc_resource().
+ *
+ * Represents a *test managed resource*, a resource which will automatically be
+ * cleaned up at the end of a test case.
+ *
+ * Example:
+ *
+ * .. code-block:: c
+ *
+ *	struct kunit_kmalloc_params {
+ *		size_t size;
+ *		gfp_t gfp;
+ *	};
+ *
+ *	static int kunit_kmalloc_init(struct kunit_resource *res, void *context)
+ *	{
+ *		struct kunit_kmalloc_params *params = context;
+ *		res->allocation = kmalloc(params->size, params->gfp);
+ *
+ *		if (!res->allocation)
+ *			return -ENOMEM;
+ *
+ *		return 0;
+ *	}
+ *
+ *	static void kunit_kmalloc_free(struct kunit_resource *res)
+ *	{
+ *		kfree(res->allocation);
+ *	}
+ *
+ *	void *kunit_kmalloc(struct kunit *test, size_t size, gfp_t gfp)
+ *	{
+ *		struct kunit_kmalloc_params params;
+ *		struct kunit_resource *res;
+ *
+ *		params.size = size;
+ *		params.gfp = gfp;
+ *
+ *		res = kunit_alloc_resource(test, kunit_kmalloc_init,
+ *			kunit_kmalloc_free, &params);
+ *		if (res)
+ *			return res->allocation;
+ *
+ *		return NULL;
+ *	}
+ */
+struct kunit_resource {
+	void *allocation;
+	kunit_resource_free_t free;
+
+	/* private: internal use only. */
+	struct list_head node;
+};
+
 struct kunit;
 
 /**
@@ -114,6 +178,13 @@ struct kunit {
 	 * with the test case have terminated.
 	 */
 	bool success; /* Read only after test_case finishes! */
+	spinlock_t lock; /* Guards all mutable test state. */
+	/*
+	 * Because resources is a list that may be updated multiple times (with
+	 * new resources) from any thread associated with a test case, we must
+	 * protect it with some type of lock.
+	 */
+	struct list_head resources; /* Protected by lock. */
 };
 
 void kunit_init_test(struct kunit *test, const char *name);
@@ -147,6 +218,122 @@ int kunit_run_tests(struct kunit_suite *suite);
 	}								       \
 	late_initcall(kunit_suite_init##suite)
 
+/*
+ * Like kunit_alloc_resource() below, but returns the struct kunit_resource
+ * object that contains the allocation. This is mostly for testing purposes.
+ */
+struct kunit_resource *kunit_alloc_and_get_resource(struct kunit *test,
+						    kunit_resource_init_t init,
+						    kunit_resource_free_t free,
+						    gfp_t internal_gfp,
+						    void *context);
+
+/**
+ * kunit_alloc_resource() - Allocates a *test managed resource*.
+ * @test: The test context object.
+ * @init: a user supplied function to initialize the resource.
+ * @free: a user supplied function to free the resource.
+ * @internal_gfp: gfp to use for internal allocations, if unsure, use GFP_KERNEL
+ * @context: for the user to pass in arbitrary data to the init function.
+ *
+ * Allocates a *test managed resource*, a resource which will automatically be
+ * cleaned up at the end of a test case. See &struct kunit_resource for an
+ * example.
+ *
+ * NOTE: KUnit needs to allocate memory for each kunit_resource object. You must
+ * specify an @internal_gfp that is compatible with the use context of your
+ * resource.
+ */
+static inline void *kunit_alloc_resource(struct kunit *test,
+					 kunit_resource_init_t init,
+					 kunit_resource_free_t free,
+					 gfp_t internal_gfp,
+					 void *context)
+{
+	struct kunit_resource *res;
+
+	res = kunit_alloc_and_get_resource(test, init, free, internal_gfp,
+					   context);
+
+	if (res)
+		return res->allocation;
+
+	return NULL;
+}
+
+typedef bool (*kunit_resource_match_t)(struct kunit *test,
+				       const void *res,
+				       void *match_data);
+
+/**
+ * kunit_resource_instance_match() - Match a resource with the same instance.
+ * @test: Test case to which the resource belongs.
+ * @res: The data stored in kunit_resource->allocation.
+ * @match_data: The resource pointer to match against.
+ *
+ * An instance of kunit_resource_match_t that matches a resource whose
+ * allocation matches @match_data.
+ */
+static inline bool kunit_resource_instance_match(struct kunit *test,
+						 const void *res,
+						 void *match_data)
+{
+	return res == match_data;
+}
+
+/**
+ * kunit_resource_destroy() - Find a kunit_resource and destroy it.
+ * @test: Test case to which the resource belongs.
+ * @match: Match function. Returns whether a given resource matches @match_data.
+ * @free: Must match free on the kunit_resource to free.
+ * @match_data: Data passed into @match.
+ *
+ * Free the latest kunit_resource of @test for which @free matches the
+ * kunit_resource_free_t associated with the resource and for which @match
+ * returns true.
+ *
+ * RETURNS:
+ * 0 if kunit_resource is found and freed, -ENOENT if not found.
+ */
+int kunit_resource_destroy(struct kunit *test,
+			   kunit_resource_match_t match,
+			   kunit_resource_free_t free,
+			   void *match_data);
+
+/**
+ * kunit_kmalloc() - Like kmalloc() except the allocation is *test managed*.
+ * @test: The test context object.
+ * @size: The size in bytes of the desired memory.
+ * @gfp: flags passed to underlying kmalloc().
+ *
+ * Just like `kmalloc(...)`, except the allocation is managed by the test case
+ * and is automatically cleaned up after the test case concludes. See &struct
+ * kunit_resource for more information.
+ */
+void *kunit_kmalloc(struct kunit *test, size_t size, gfp_t gfp);
+
+/**
+ * kunit_kfree() - Like kfree except for allocations managed by KUnit.
+ * @test: The test case to which the resource belongs.
+ * @ptr: The memory allocation to free.
+ */
+void kunit_kfree(struct kunit *test, const void *ptr);
+
+/**
+ * kunit_kzalloc() - Just like kunit_kmalloc(), but zeroes the allocation.
+ * @test: The test context object.
+ * @size: The size in bytes of the desired memory.
+ * @gfp: flags passed to underlying kmalloc().
+ *
+ * See kzalloc() and kunit_kmalloc() for more information.
+ */
+static inline void *kunit_kzalloc(struct kunit *test, size_t size, gfp_t gfp)
+{
+	return kunit_kmalloc(test, size, gfp | __GFP_ZERO);
+}
+
+void kunit_cleanup(struct kunit *test);
+
 void __printf(3, 4) kunit_printk(const char *level,
 				 const struct kunit *test,
 				 const char *fmt, ...);
diff --git a/kunit/test.c b/kunit/test.c
index d3dda359f99b..68b1037ab74d 100644
--- a/kunit/test.c
+++ b/kunit/test.c
@@ -122,6 +122,8 @@ static void kunit_print_test_case_ok_not_ok(struct kunit_case *test_case,
 
 void kunit_init_test(struct kunit *test, const char *name)
 {
+	spin_lock_init(&test->lock);
+	INIT_LIST_HEAD(&test->resources);
 	test->name = name;
 	test->success = true;
 }
@@ -153,6 +155,8 @@ static void kunit_run_case(struct kunit_suite *suite,
 	if (suite->exit)
 		suite->exit(&test);
 
+	kunit_cleanup(&test);
+
 	test_case->success = test.success;
 }
 
@@ -173,6 +177,165 @@ int kunit_run_tests(struct kunit_suite *suite)
 	return 0;
 }
 
+struct kunit_resource *kunit_alloc_and_get_resource(struct kunit *test,
+						    kunit_resource_init_t init,
+						    kunit_resource_free_t free,
+						    gfp_t internal_gfp,
+						    void *context)
+{
+	struct kunit_resource *res;
+	int ret;
+
+	res = kzalloc(sizeof(*res), internal_gfp);
+	if (!res)
+		return NULL;
+
+	ret = init(res, context);
+	if (ret)
+		return NULL;
+
+	res->free = free;
+	spin_lock(&test->lock);
+	list_add_tail(&res->node, &test->resources);
+	spin_unlock(&test->lock);
+
+	return res;
+}
+
+static void kunit_resource_free(struct kunit *test, struct kunit_resource *res)
+{
+	res->free(res);
+	kfree(res);
+}
+
+static struct kunit_resource *kunit_resource_find(struct kunit *test,
+						  kunit_resource_match_t match,
+						  kunit_resource_free_t free,
+						  void *match_data)
+{
+	struct kunit_resource *resource;
+
+	lockdep_assert_held(&test->lock);
+
+	list_for_each_entry_reverse(resource, &test->resources, node) {
+		if (resource->free != free)
+			continue;
+		if (match(test, resource->allocation, match_data))
+			return resource;
+	}
+
+	return NULL;
+}
+
+static struct kunit_resource *kunit_resource_remove(
+		struct kunit *test,
+		kunit_resource_match_t match,
+		kunit_resource_free_t free,
+		void *match_data)
+{
+	struct kunit_resource *resource;
+
+	spin_lock(&test->lock);
+	resource = kunit_resource_find(test, match, free, match_data);
+	if (resource)
+		list_del(&resource->node);
+	spin_unlock(&test->lock);
+
+	return resource;
+}
+
+int kunit_resource_destroy(struct kunit *test,
+			   kunit_resource_match_t match,
+			   kunit_resource_free_t free,
+			   void *match_data)
+{
+	struct kunit_resource *resource;
+
+	resource = kunit_resource_remove(test, match, free, match_data);
+
+	if (!resource)
+		return -ENOENT;
+
+	kunit_resource_free(test, resource);
+	return 0;
+}
+
+struct kunit_kmalloc_params {
+	size_t size;
+	gfp_t gfp;
+};
+
+static int kunit_kmalloc_init(struct kunit_resource *res, void *context)
+{
+	struct kunit_kmalloc_params *params = context;
+
+	res->allocation = kmalloc(params->size, params->gfp);
+	if (!res->allocation)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void kunit_kmalloc_free(struct kunit_resource *res)
+{
+	kfree(res->allocation);
+}
+
+void *kunit_kmalloc(struct kunit *test, size_t size, gfp_t gfp)
+{
+	struct kunit_kmalloc_params params = {
+		.size = size,
+		.gfp = gfp
+	};
+
+	return kunit_alloc_resource(test,
+				    kunit_kmalloc_init,
+				    kunit_kmalloc_free,
+				    gfp,
+				    &params);
+}
+
+void kunit_kfree(struct kunit *test, const void *ptr)
+{
+	int rc;
+
+	rc = kunit_resource_destroy(test,
+				    kunit_resource_instance_match,
+				    kunit_kmalloc_free,
+				    (void *)ptr);
+
+	WARN_ON(rc);
+}
+
+void kunit_cleanup(struct kunit *test)
+{
+	struct kunit_resource *resource;
+
+	/*
+	 * test->resources is a stack - each allocation must be freed in the
+	 * reverse order from which it was added since one resource may depend
+	 * on another for its entire lifetime.
+	 * Also, we cannot use the normal list_for_each constructs, even the
+	 * safe ones because *arbitrary* nodes may be deleted when
+	 * kunit_resource_free is called; the list_for_each_safe variants only
+	 * protect against the current node being deleted, not the next.
+	 */
+	while (true) {
+		spin_lock(&test->lock);
+		if (list_empty(&test->resources)) {
+			spin_unlock(&test->lock);
+			break;
+		}
+		resource = list_last_entry(&test->resources,
+					   struct kunit_resource,
+					   node);
+		list_del(&resource->node);
+		spin_unlock(&test->lock);
+
+		kunit_resource_free(test, resource);
+	}
+}
+
 void kunit_printk(const char *level,
 		  const struct kunit *test,
 		  const char *fmt, ...)
-- 
2.23.0.187.g17f5b7556c-goog
