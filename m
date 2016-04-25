Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id AC4BD1A1F64
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:51:09 -0700 (PDT)
Subject: [ndctl PATCH 6/7] ndctl: fix uninitialized variable in add_dimm()
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:50:20 -0700
Message-ID: <146161382084.21779.5170696006378099616.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis notes 'rc' might not be set if we fail to allocate
'dimm'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 lib/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/libndctl.c b/lib/libndctl.c
index 5c2894d6b82e..58b7fa9d6666 100644
--- a/lib/libndctl.c
+++ b/lib/libndctl.c
@@ -1184,9 +1184,9 @@ static struct kmod_module *to_module(struct ndctl_ctx *ctx, const char *alias);
 
 static int add_dimm(void *parent, int id, const char *dimm_base)
 {
-	int rc, formats, i;
 	struct ndctl_dimm *dimm;
 	char buf[SYSFS_ATTR_SIZE];
+	int rc = -ENOMEM, formats, i;
 	struct ndctl_bus *bus = parent;
 	struct ndctl_ctx *ctx = bus->ctx;
 	char *path = calloc(1, strlen(dimm_base) + 100);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
