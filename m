Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDFA51A1E86
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:13:05 -0700 (PDT)
Subject: [PATCH 1/2] libnvdimm: allow a platform to force enable label support
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:09:53 -0700
Message-ID: <147689339360.9946.18026760323007745863.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689338812.9946.11071407155879544366.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689338812.9946.11071407155879544366.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Platforms like QEMU-KVM implement an NFIT table and label DSMs.
However, since that environment does not define an aliased
configuration, the labels are currently ignored and the kernel registers
a single full-sized pmem-namespace per region. Now that the kernel
supports sub-divisions of pmem regions the labels have a purpose.
Arrange for the labels to be honored when we find an existing / valid
namespace index block.

Cc: <qemu-devel@nongnu.org>
Cc: Haozhong Zhang <haozhong.zhang@intel.com>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm.c      |    2 ++
 drivers/nvdimm/dimm_devs.c |    7 +++++++
 drivers/nvdimm/nd.h        |    1 +
 3 files changed, 10 insertions(+)

diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
index 619834e144d1..ee0b412827bf 100644
--- a/drivers/nvdimm/dimm.c
+++ b/drivers/nvdimm/dimm.c
@@ -64,6 +64,8 @@ static int nvdimm_probe(struct device *dev)
 	nd_label_copy(ndd, to_next_namespace_index(ndd),
 			to_current_namespace_index(ndd));
 	rc = nd_label_reserve_dpa(ndd);
+	if (ndd->ns_current >= 0)
+		nvdimm_set_aliasing(dev);
 	nvdimm_bus_unlock(dev);
 
 	if (rc)
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index d614493ad5ac..0eedc49e0d47 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -184,6 +184,13 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 	return rc;
 }
 
+void nvdimm_set_aliasing(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+
+	nvdimm->flags |= NDD_ALIASING;
+}
+
 static void nvdimm_release(struct device *dev)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 065abf1b8f32..35dd75057e16 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -238,6 +238,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
 		void *buf, size_t len);
 long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		unsigned int len);
+void nvdimm_set_aliasing(struct device *dev);
 struct nd_btt *to_nd_btt(struct device *dev);
 
 struct nd_gen_sb {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
