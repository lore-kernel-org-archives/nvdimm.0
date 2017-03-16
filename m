Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9F538036A
 for <linux-nvdimm@lists.01.org>; Wed, 15 Mar 2017 21:47:41 -0700 (PDT)
Subject: [4.4-stable PATCH] nfit,
 libnvdimm: fix interleave set cookie calculation
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Mar 2017 21:42:30 -0700
Message-ID: <148963935049.18455.9165722345212544698.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: stable@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit 86ef58a4e35e8fa66afb5898cf6dec6a3bb29f67 upstream.

The interleave-set cookie is a sum that sanity checks the composition of
an interleave set has not changed from when the namespace was initially
created.  The checksum is calculated by sorting the DIMMs by their
location in the interleave-set. The comparison for the sort must be
64-bit wide, not byte-by-byte as performed by memcmp() in the broken
case.

Fix the implementation to accept correct cookie values in addition to
the Linux "memcmp" order cookies, but only allow correct cookies to be
generated going forward. It does mean that namespaces created by
third-party-tooling, or created by newer kernels with this fix, will not
validate on older kernels. However, there are a couple mitigating
conditions:

    1/ platforms with namespace-label capable NVDIMMs are not widely
       available.

    2/ interleave-sets with a single-dimm are by definition not affected
       (nothing to sort). This covers the QEMU-KVM NVDIMM emulation case.

The cookie stored in the namespace label will be fixed by any write the
namespace label, the most straightforward way to achieve this is to
write to the "alt_name" attribute of a namespace in sysfs.

Cc: Johannes Thumshirn <jthumshirn@suse.de>
Reported-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Tested-by: Nicholas Moulin <nicholas.w.moulin@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit.c             |   16 +++++++++++++++-
 drivers/nvdimm/namespace_devs.c |   28 +++++++++++++++++++++-------
 drivers/nvdimm/nd.h             |    1 +
 drivers/nvdimm/region_devs.c    |    9 +++++++++
 include/linux/libnvdimm.h       |    2 ++
 5 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index c097f477c74c..14c2a07c9f3f 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -965,7 +965,7 @@ static size_t sizeof_nfit_set_info(int num_mappings)
 		+ num_mappings * sizeof(struct nfit_set_info_map);
 }
 
-static int cmp_map(const void *m0, const void *m1)
+static int cmp_map_compat(const void *m0, const void *m1)
 {
 	const struct nfit_set_info_map *map0 = m0;
 	const struct nfit_set_info_map *map1 = m1;
@@ -974,6 +974,14 @@ static int cmp_map(const void *m0, const void *m1)
 			sizeof(u64));
 }
 
+static int cmp_map(const void *m0, const void *m1)
+{
+	const struct nfit_set_info_map *map0 = m0;
+	const struct nfit_set_info_map *map1 = m1;
+
+	return map0->region_offset - map1->region_offset;
+}
+
 /* Retrieve the nth entry referencing this spa */
 static struct acpi_nfit_memory_map *memdev_from_spa(
 		struct acpi_nfit_desc *acpi_desc, u16 range_index, int n)
@@ -1029,6 +1037,12 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 	sort(&info->mapping[0], nr, sizeof(struct nfit_set_info_map),
 			cmp_map, NULL);
 	nd_set->cookie = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
+
+	/* support namespaces created with the wrong sort order */
+	sort(&info->mapping[0], nr, sizeof(struct nfit_set_info_map),
+			cmp_map_compat, NULL);
+	nd_set->altcookie = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
+
 	ndr_desc->nd_set = nd_set;
 	devm_kfree(dev, info);
 
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 62120c38d56b..aae7379af4e4 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1534,6 +1534,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 static int find_pmem_label_set(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm)
 {
+	u64 altcookie = nd_region_interleave_set_altcookie(nd_region);
 	u64 cookie = nd_region_interleave_set_cookie(nd_region);
 	struct nd_namespace_label *nd_label;
 	u8 select_id[NSLABEL_UUID_LEN];
@@ -1542,8 +1543,10 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 	int rc = -ENODEV, l;
 	u16 i;
 
-	if (cookie == 0)
+	if (cookie == 0) {
+		dev_dbg(&nd_region->dev, "invalid interleave-set-cookie\n");
 		return -ENXIO;
+	}
 
 	/*
 	 * Find a complete set of labels by uuid.  By definition we can start
@@ -1552,13 +1555,24 @@ static int find_pmem_label_set(struct nd_region *nd_region,
 	for_each_label(l, nd_label, nd_region->mapping[0].labels) {
 		u64 isetcookie = __le64_to_cpu(nd_label->isetcookie);
 
-		if (isetcookie != cookie)
-			continue;
+		if (isetcookie != cookie) {
+			dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
+					nd_label->uuid);
+			if (isetcookie != altcookie)
+				continue;
+
+			dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
+					nd_label->uuid);
+		}
+
+		for (i = 0; nd_region->ndr_mappings; i++) {
+			if (has_uuid_at_pos(nd_region, nd_label->uuid, cookie, i))
+				continue;
+			if (has_uuid_at_pos(nd_region, nd_label->uuid, altcookie, i))
+				continue;
+			break;
+		}
 
-		for (i = 0; nd_region->ndr_mappings; i++)
-			if (!has_uuid_at_pos(nd_region, nd_label->uuid,
-						cookie, i))
-				break;
 		if (i < nd_region->ndr_mappings) {
 			/*
 			 * Give up if we don't find an instance of a
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 417e521d299c..fc870e55bb66 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -245,6 +245,7 @@ struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region);
+u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region);
 void nvdimm_bus_lock(struct device *dev);
 void nvdimm_bus_unlock(struct device *dev);
 bool is_nvdimm_bus_locked(struct device *dev);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 9521696c9385..dc2e919daa39 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -379,6 +379,15 @@ u64 nd_region_interleave_set_cookie(struct nd_region *nd_region)
 	return 0;
 }
 
+u64 nd_region_interleave_set_altcookie(struct nd_region *nd_region)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+
+	if (nd_set)
+		return nd_set->altcookie;
+	return 0;
+}
+
 /*
  * Upon successful probe/remove, take/release a reference on the
  * associated interleave set (if present), and plant new btt + namespace
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3f021dc5da8c..30201b9be7bc 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -83,6 +83,8 @@ struct nd_cmd_desc {
 
 struct nd_interleave_set {
 	u64 cookie;
+	/* compatibility with initial buggy Linux implementation */
+	u64 altcookie;
 };
 
 struct nd_region_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
