Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C75022261815F
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 15:49:25 -0700 (PDT)
Subject: [PATCH 4/5] tools/testing/nvdimm: fix missing newline in
 nfit_test_dimm 'handle' attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 15:39:29 -0700
Message-ID: <152339996986.16061.7075031344411812909.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Sysfs userspace tooling generally expects the kernel to emit a newlines
when reading sysfs attributes.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/nfit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index c8c88363311b..51fc41c24a77 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1193,7 +1193,7 @@ static ssize_t handle_show(struct device *dev, struct device_attribute *attr,
 	if (dimm < 0)
 		return dimm;
 
-	return sprintf(buf, "%#x", handle[dimm]);
+	return sprintf(buf, "%#x\n", handle[dimm]);
 }
 DEVICE_ATTR_RO(handle);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
