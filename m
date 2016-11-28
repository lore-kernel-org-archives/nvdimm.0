Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3285D81C9A
 for <linux-nvdimm@lists.01.org>; Mon, 28 Nov 2016 11:29:53 -0800 (PST)
Subject: [PATCH] libnvdimm: use consistent naming for request_mem_region()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Nov 2016 11:25:43 -0800
Message-ID: <148036114338.1592.11338839039403854102.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Here is an example /proc/iomem listing for a system with 2 namespaces,
one in "sector" mode and one in "memory" mode:

  1fc000000-2fbffffff : Persistent Memory (legacy)
    1fc000000-2fbffffff : namespace1.0
  340000000-34fffffff : Persistent Memory
    340000000-34fffffff : btt0.1

Here is the corresponding ndctl listing:

  # ndctl list
  [
    {
      "dev":"namespace1.0",
      "mode":"memory",
      "size":4294967296,
      "blockdev":"pmem1"
    },
    {
      "dev":"namespace0.0",
      "mode":"sector",
      "size":267091968,
      "uuid":"f7594f86-badb-4592-875f-ded577da2eaf",
      "sector_size":4096,
      "blockdev":"pmem0s"
    }
  ]

Notice that the ndctl listing is purely in terms of namespace devices,
while the iomem listing leaks the internal "btt0.1" implementation
detail. Given that ndctl requires the namespace device name to change
the mode, for example:

  # ndctl create-namespace --reconfig=namespace0.0 --mode=raw --force

...use the namespace name in the iomem listing to keep the claiming
device name consistent across different mode settings.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/pmem.c     |    3 ++-
 drivers/nvdimm/claim.c |    2 +-
 drivers/nvdimm/pmem.c  |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 9630d8837ba9..3ff84784249a 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -87,7 +87,8 @@ static int dax_pmem_probe(struct device *dev)
 	pfn_sb = nd_pfn->pfn_sb;
 
 	if (!devm_request_mem_region(dev, nsio->res.start,
-				resource_size(&nsio->res), dev_name(dev))) {
+				resource_size(&nsio->res),
+				dev_name(&ndns->dev))) {
 		dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
 		return -EBUSY;
 	}
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 8d66fbb779ed..4638b9ea5229 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -275,7 +275,7 @@ int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio)
 
 	nsio->size = resource_size(res);
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				dev_name(dev))) {
+				dev_name(&ndns->dev))) {
 		dev_warn(dev, "could not reserve region %pR\n", res);
 		return -EBUSY;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 42b3a8217073..34f16a17c07b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -266,7 +266,7 @@ static int pmem_attach_disk(struct device *dev,
 		dev_warn(dev, "unable to guarantee persistence of writes\n");
 
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
-				dev_name(dev))) {
+				dev_name(&ndns->dev))) {
 		dev_warn(dev, "could not reserve region %pR\n", res);
 		return -EBUSY;
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
