Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6BE6621A1098A
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:26 -0800 (PST)
Subject: [ndctl PATCH 13/17] ndctl,
 list: teach the list command about the 'fsdax' and 'devdax' modes
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:39 -0800
Message-ID: <151217073900.28402.5371420759088083712.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Allow filtering namespaces by the same mode names used for
create-namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-list.txt |    2 +-
 ndctl/list.c                       |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index e19ded8a3ec2..fc07a71ff640 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -80,7 +80,7 @@ include::xable-region-options.txt[]
 
 -m::
 --mode=::
-	Filter listing by the mode ('raw', 'memory', 'sector' or 'dax')
+	Filter listing by the mode ('raw', 'fsdax', 'sector' or 'devdax')
 	of the namespace(s).
 
 -B::
diff --git a/ndctl/list.c b/ndctl/list.c
index d6e49b03a265..37a224a666ca 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -78,12 +78,16 @@ static enum ndctl_namespace_mode mode_to_type(const char *mode)
 
 	if (strcasecmp(param.mode, "memory") == 0)
 		return NDCTL_NS_MODE_MEMORY;
+	else if (strcasecmp(param.mode, "fsdax") == 0)
+		return NDCTL_NS_MODE_MEMORY;
 	else if (strcasecmp(param.mode, "sector") == 0)
 		return NDCTL_NS_MODE_SAFE;
 	else if (strcasecmp(param.mode, "safe") == 0)
 		return NDCTL_NS_MODE_SAFE;
 	else if (strcasecmp(param.mode, "dax") == 0)
 		return NDCTL_NS_MODE_DAX;
+	else if (strcasecmp(param.mode, "devdax") == 0)
+		return NDCTL_NS_MODE_DAX;
 	else if (strcasecmp(param.mode, "raw") == 0)
 		return NDCTL_NS_MODE_RAW;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
