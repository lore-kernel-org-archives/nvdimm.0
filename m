Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D24F9D2
	for <nvdimm@lists.linux.dev>; Mon,  3 Jul 2023 13:39:39 +0000 (UTC)
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1qGJQo-002CFT-S6; Mon, 03 Jul 2023 14:17:30 +0100
Received: from ben by rainbowdash with local (Exim 4.96)
	(envelope-from <ben@rainbowdash>)
	id 1qGJQo-004EiI-1o;
	Mon, 03 Jul 2023 14:17:30 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: nvdimm@lists.linux.dev
Cc: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lenb@kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] ACPI: NFIT: add helper to_nfit_mem() to take device to nfit_mem
Date: Mon,  3 Jul 2023 14:17:29 +0100
Message-Id: <20230703131729.1009861-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a quick helper to just do struct device to the struct nfit_mem
field it should be referencing. This reduces the number of code
lines in some of the followgn code as it removes the intermediate
struct nvdimm.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 drivers/acpi/nfit/core.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 0fcc247fdfac..9213b426b125 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1361,18 +1361,22 @@ static const struct attribute_group *acpi_nfit_attribute_groups[] = {
 	NULL,
 };
 
-static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+static struct nfit_mem *to_nfit_mem(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	return  nvdimm_provider_data(nvdimm);
+}
+
+static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
+{
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return __to_nfit_memdev(nfit_mem);
 }
 
 static struct acpi_nfit_control_region *to_nfit_dcr(struct device *dev)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return nfit_mem->dcr;
 }
@@ -1531,8 +1535,7 @@ static DEVICE_ATTR_RO(serial);
 static ssize_t family_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	if (nfit_mem->family < 0)
 		return -ENXIO;
@@ -1543,8 +1546,7 @@ static DEVICE_ATTR_RO(family);
 static ssize_t dsm_mask_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	if (nfit_mem->family < 0)
 		return -ENXIO;
@@ -1555,8 +1557,7 @@ static DEVICE_ATTR_RO(dsm_mask);
 static ssize_t flags_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 	u16 flags = __to_nfit_memdev(nfit_mem)->flags;
 
 	if (test_bit(NFIT_MEM_DIRTY, &nfit_mem->flags))
@@ -1576,8 +1577,7 @@ static DEVICE_ATTR_RO(flags);
 static ssize_t id_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return sprintf(buf, "%s\n", nfit_mem->id);
 }
@@ -1586,8 +1586,7 @@ static DEVICE_ATTR_RO(id);
 static ssize_t dirty_shutdown_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return sprintf(buf, "%d\n", nfit_mem->dirty_shutdown);
 }
-- 
2.40.1

