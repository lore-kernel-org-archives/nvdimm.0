From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC v2 02/14] kunit: test: add test resource management API
Date: Tue, 23 Oct 2018 16:57:38 -0700
Message-ID: <20181023235750.103146-3-brendanhiggins@google.com>
References: <20181023235750.103146-1-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181023235750.103146-1-brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, julia.lawall-L2FTfq7BK8M@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Create a common API for test managed resources like memory and test
objects. A lot of times a test will want to set up infrastructure to be
used in test cases; this could be anything from just wanting to allocate
some memory to setting up a driver stack; this defines facilities for
creating "test resources" which are managed by the test infrastructure
and are automatically cleaned up at the conclusion of the test.

Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/kunit/test.h | 109 +++++++++++++++++++++++++++++++++++++++++++
 kunit/test.c         |  95 +++++++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index e0b14b227ac44..1c116a20063da 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -12,6 +12,69 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 
+struct test_resource;
+
+typedef int (*test_resource_init_t)(struct test_resource *, void *);
+typedef void (*test_resource_free_t)(struct test_resource *);
+
+/**
+ * struct test_resource - represents a *test managed resource*
+ * @allocation: for the user to store arbitrary data.
+ * @free: a user supplied function to free the resource. Populated by
+ * test_alloc_resource().
+ *
+ * Represents a *test managed resource*, a resource which will automatically be
+ * cleaned up at the end of a test case.
+ *
+ * Example:
+ *
+ * .. code-block:: c
+ *
+ *	struct test_kmalloc_params {
+ *		size_t size;
+ *		gfp_t gfp;
+ *	};
+ *
+ *	static int test_kmalloc_init(struct test_resource *res, void *context)
+ *	{
+ *		struct test_kmalloc_params *params = context;
+ *		res->allocation = kmalloc(params->size, params->gfp);
+ *
+ *		if (!res->allocation)
+ *			return -ENOMEM;
+ *
+ *		return 0;
+ *	}
+ *
+ *	static void test_kmalloc_free(struct test_resource *res)
+ *	{
+ *		kfree(res->allocation);
+ *	}
+ *
+ *	void *test_kmalloc(struct test *test, size_t size, gfp_t gfp)
+ *	{
+ *		struct test_kmalloc_params params;
+ *		struct test_resource *res;
+ *
+ *		params.size = size;
+ *		params.gfp = gfp;
+ *
+ *		res = test_alloc_resource(test, test_kmalloc_init,
+ *			test_kmalloc_free, &params);
+ *		if (res)
+ *			return res->allocation;
+ *		else
+ *			return NULL;
+ *	}
+ */
+struct test_resource {
+	void *allocation;
+	test_resource_free_t free;
+
+	/* private: internal use only. */
+	struct list_head node;
+};
+
 struct test;
 
 /**
@@ -104,6 +167,7 @@ struct test {
 	const char *name; /* Read only after initialization! */
 	spinlock_t lock; /* Gaurds all mutable test state. */
 	bool success; /* Protected by lock. */
+	struct list_head resources; /* Protected by lock. */
 	void (*vprintk)(const struct test *test,
 			const char *level,
 			struct va_format *vaf);
@@ -127,6 +191,51 @@ int test_run_tests(struct test_module *module);
 		} \
 		late_initcall(module_test_init##module)
 
+/**
+ * test_alloc_resource() - Allocates a *test managed resource*.
+ * @test: The test context object.
+ * @init: a user supplied function to initialize the resource.
+ * @free: a user supplied function to free the resource.
+ * @context: for the user to pass in arbitrary data.
+ *
+ * Allocates a *test managed resource*, a resource which will automatically be
+ * cleaned up at the end of a test case. See &struct test_resource for an
+ * example.
+ */
+struct test_resource *test_alloc_resource(struct test *test,
+					  test_resource_init_t init,
+					  test_resource_free_t free,
+					  void *context);
+
+void test_free_resource(struct test *test, struct test_resource *res);
+
+/**
+ * test_kmalloc() - Just like kmalloc() except the allocation is *test managed*.
+ * @test: The test context object.
+ * @size: The size in bytes of the desired memory.
+ * @gfp: flags passed to underlying kmalloc().
+ *
+ * Just like `kmalloc(...)`, except the allocation is managed by the test case
+ * and is automatically cleaned up after the test case concludes. See &struct
+ * test_resource for more information.
+ */
+void *test_kmalloc(struct test *test, size_t size, gfp_t gfp);
+
+/**
+ * test_kzalloc() - Just like test_kmalloc(), but zeroes the allocation.
+ * @test: The test context object.
+ * @size: The size in bytes of the desired memory.
+ * @gfp: flags passed to underlying kmalloc().
+ *
+ * See kzalloc() and test_kmalloc() for more information.
+ */
+static inline void *test_kzalloc(struct test *test, size_t size, gfp_t gfp)
+{
+	return test_kmalloc(test, size, gfp | __GFP_ZERO);
+}
+
+void test_cleanup(struct test *test);
+
 void __printf(3, 4) test_printk(const char *level,
 				const struct test *test,
 				const char *fmt, ...);
diff --git a/kunit/test.c b/kunit/test.c
index 4732e5f0d7575..fd0a51245215e 100644
--- a/kunit/test.c
+++ b/kunit/test.c
@@ -66,6 +66,7 @@ static void test_vprintk(const struct test *test,
 int test_init_test(struct test *test, const char *name)
 {
 	spin_lock_init(&test->lock);
+	INIT_LIST_HEAD(&test->resources);
 	test->name = name;
 	test->vprintk = test_vprintk;
 
@@ -93,6 +94,11 @@ static void test_run_case_internal(struct test *test,
 	test_case->run_case(test);
 }
 
+static void test_case_internal_cleanup(struct test *test)
+{
+	test_cleanup(test);
+}
+
 /*
  * Performs post validations and cleanup after a test case was run.
  * XXX: Should ONLY BE CALLED AFTER test_run_case_internal!
@@ -103,6 +109,8 @@ static void test_run_case_cleanup(struct test *test,
 {
 	if (module->exit)
 		module->exit(test);
+
+	test_case_internal_cleanup(test);
 }
 
 /*
@@ -150,6 +158,93 @@ int test_run_tests(struct test_module *module)
 	return 0;
 }
 
+struct test_resource *test_alloc_resource(struct test *test,
+					  test_resource_init_t init,
+					  test_resource_free_t free,
+					  void *context)
+{
+	struct test_resource *res;
+	unsigned long flags;
+	int ret;
+
+	res = kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return NULL;
+
+	ret = init(res, context);
+	if (ret)
+		return NULL;
+
+	res->free = free;
+	spin_lock_irqsave(&test->lock, flags);
+	list_add_tail(&res->node, &test->resources);
+	spin_unlock_irqrestore(&test->lock, flags);
+
+	return res;
+}
+
+void test_free_resource(struct test *test, struct test_resource *res)
+{
+	res->free(res);
+	list_del(&res->node);
+	kfree(res);
+}
+
+struct test_kmalloc_params {
+	size_t size;
+	gfp_t gfp;
+};
+
+static int test_kmalloc_init(struct test_resource *res, void *context)
+{
+	struct test_kmalloc_params *params = context;
+
+	res->allocation = kmalloc(params->size, params->gfp);
+	if (!res->allocation)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void test_kmalloc_free(struct test_resource *res)
+{
+	kfree(res->allocation);
+}
+
+void *test_kmalloc(struct test *test, size_t size, gfp_t gfp)
+{
+	struct test_kmalloc_params params;
+	struct test_resource *res;
+
+	params.size = size;
+	params.gfp = gfp;
+
+	res = test_alloc_resource(test,
+				  test_kmalloc_init,
+				  test_kmalloc_free,
+				  &params);
+
+	if (res)
+		return res->allocation;
+	else
+		return NULL;
+}
+
+void test_cleanup(struct test *test)
+{
+	struct test_resource *resource, *resource_safe;
+	unsigned long flags;
+
+	spin_lock_irqsave(&test->lock, flags);
+	list_for_each_entry_safe(resource,
+				 resource_safe,
+				 &test->resources,
+				 node) {
+		test_free_resource(test, resource);
+	}
+	spin_unlock_irqrestore(&test->lock, flags);
+}
+
 void test_printk(const char *level,
 		 const struct test *test,
 		 const char *fmt, ...)
-- 
2.19.1.568.g152ad8e336-goog
