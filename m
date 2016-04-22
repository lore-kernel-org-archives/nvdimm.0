Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 0DF571A2170
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:28 -0700 (PDT)
Subject: [ndctl PATCH 7/8] ndctl,
 create-namespace: fix sector mode default for pmem namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:38 -0700
Message-ID: <146135445871.4228.1090587699596226202.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The man page uses the following example for establishing a sector mode
namespace:

    ndctl create-namespace -e namespace0.0 -f -m sector

...however this only works for blk-type namespaces to inherit a default
sector size.  Default to 4K in the pmem-type namespaces.

Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 7d555a7d14a1..6ae8d7aee849 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -410,6 +410,8 @@ static int validate_namespace_options(struct ndctl_namespace *ndns,
 		else if (ndctl_namespace_get_type(ndns)
 				== ND_DEVICE_NAMESPACE_BLK)
 			p->sector_size = ndctl_namespace_get_sector_size(ndns);
+		else if (p->mode == NDCTL_NS_MODE_SAFE)
+				p->sector_size = 4096;
 	}
 
 	if (param.map) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
