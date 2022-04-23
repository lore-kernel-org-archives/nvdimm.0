Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF867C
	for <nvdimm@lists.linux.dev>; Sat, 23 Apr 2022 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650747921; x=1682283921;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u2uujpIWafLuqRQHmmYfUJuJS1w46wzg590lAQIVpiY=;
  b=W3jq0zX/txDa0FFCKYob99yIHrkMsSY+yg3eCZK4X+WhfNmnw5Z2QJqA
   sVm3aFg1kN01f0qGlmuOBY/rBM3SxlWKVRThnk/yKXa9FOlNmRJ+zEIHN
   lLOdY4f4wemWVp0UzcSCXLlzWuFYq9bFUqfErZEDcjpLWT3Rs1hSgrW9C
   0ZqrPn9Pwh0hVOrcIz+lMG6ojFeAv19+zVHWP0c4pgnguZOcwppPknRQ9
   +OEKBbvO4gSG6fSK+9TP8jcJbh4OYUIe17pukFLYvDO/Xh95MDE+u13M4
   Ka4zmpdC2dQK6tv6wLE66++G40ioLEuUbcGtXNsGQxlW0oU4esKnetOcf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="252296279"
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="252296279"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 14:05:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,285,1643702400"; 
   d="scan'208";a="729057744"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 14:05:20 -0700
Subject: [PATCH v4 2/8] cxl/acpi: Add root device lockdep validation
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ira Weiny <ira.weiny@intel.com>, nvdimm@lists.linux.dev
Date: Sat, 23 Apr 2022 14:05:20 -0700
Message-ID: <165074768280.4047093.15803516065715087623.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165055519869.3745911.10162603933337340370.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CXL "root" device, ACPI0017, is an attach point for coordinating
platform level CXL resources and is the parent device for a CXL port
topology tree. As such it has distinct locking rules relative to other
CXL subsystem objects, but because it is an ACPI device the lock class
is established well before it is given to the cxl_acpi driver.

However, the lockdep API does support changing the lock class "live" for
situations like this. Add a device_lock_set_class() helper that a driver
can use in ->probe() to set a custom lock class, and
device_lock_reset_class() to return to the default "no validate" class
before the custom lock class key goes out of scope after ->remove().

Note the helpers are all macros to support dead code elimination in the
CONFIG_PROVE_LOCKING=n case.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Add a comment about expected usage of device_lock_set_class() to only
  override the "no validate" class (Ira)
- Clang-format the macros
- Fix device_lock_reset_class() to reset the lock class name to
  "&dev->mutex".

 drivers/cxl/acpi.c     |   15 +++++++++++++++
 include/linux/device.h |   25 +++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index d15a6aec0331..e19cea27387e 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -275,6 +275,15 @@ static int add_root_nvdimm_bridge(struct device *match, void *data)
 	return 1;
 }
 
+static struct lock_class_key cxl_root_key;
+
+static void cxl_acpi_lock_reset_class(void *_dev)
+{
+	struct device *dev = _dev;
+
+	device_lock_reset_class(dev);
+}
+
 static int cxl_acpi_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -283,6 +292,12 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	struct acpi_device *adev = ACPI_COMPANION(host);
 	struct cxl_cfmws_context ctx;
 
+	device_lock_set_class(&pdev->dev, &cxl_root_key);
+	rc = devm_add_action_or_reset(&pdev->dev, cxl_acpi_lock_reset_class,
+				      &pdev->dev);
+	if (rc)
+		return rc;
+
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
diff --git a/include/linux/device.h b/include/linux/device.h
index 93459724dcde..a4a7c1bf3b72 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -850,6 +850,31 @@ static inline bool device_supports_offline(struct device *dev)
 	return dev->bus && dev->bus->offline && dev->bus->online;
 }
 
+#define __device_lock_set_class(dev, name, key)                                \
+	lock_set_class(&(dev)->mutex.dep_map, name, key, 0, _THIS_IP_)
+
+/**
+ * device_lock_set_class - Specify a temporary lock class while a device
+ *			   is attached to a driver
+ * @dev: device to modify
+ * @key: lock class key data
+ *
+ * This must be called with the device_lock() already held, for example
+ * from driver ->probe(). Take care to only override the default
+ * lockdep_no_validate class.
+ */
+#define device_lock_set_class(dev, key) __device_lock_set_class(dev, #key, key)
+
+/**
+ * device_lock_reset_class - Return a device to the default lockdep novalidate state
+ * @dev: device to modify
+ *
+ * This must be called with the device_lock() already held, for example
+ * from driver ->remove().
+ */
+#define device_lock_reset_class(dev)                                           \
+	__device_lock_set_class(dev, "&dev->mutex", &__lockdep_no_validate__)
+
 void lock_device_hotplug(void);
 void unlock_device_hotplug(void);
 int lock_device_hotplug_sysfs(void);

