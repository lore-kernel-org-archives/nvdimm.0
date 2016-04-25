Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 25B411A1ED4
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:50:54 -0700 (PDT)
Subject: [ndctl PATCH 3/7] ndctl: fix some warnings
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:50:05 -0700
Message-ID: <146161380523.21779.1858997961702829201.stgit@dwillia2-desk3.amr.corp.intel.com>
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

builtin-read-labels.c:417:5: warning: 'count' may be used uninitialized in this function
builtin-xaction-namespace.c:526:2: warning: 'buf' may be used uninitialized in this function

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-read-labels.c       |    3 +--
 builtin-xaction-namespace.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/builtin-read-labels.c b/builtin-read-labels.c
index bea20184c7f8..9dd90c92304e 100644
--- a/builtin-read-labels.c
+++ b/builtin-read-labels.c
@@ -336,7 +336,7 @@ int cmd_read_labels(int argc, const char **argv)
 	struct ndctl_dimm *dimm;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
-	int i, rc, count, err = 0;
+	int i, rc, count = 0, err = 0;
 	FILE *f_out = NULL;
 
         argc = parse_options(argc, argv, nmem_options, u, 0);
@@ -377,7 +377,6 @@ int cmd_read_labels(int argc, const char **argv)
 	if (rc < 0)
 		goto out;
 
-	count = 0;
         ndctl_bus_foreach(ctx, bus) {
 		if (!util_bus_filter(bus, nmem_bus))
 			continue;
diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 40f62822facd..d20e9167dc81 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -490,8 +490,8 @@ static int zero_info_block(struct ndctl_namespace *ndns)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	int fd, rc = -ENXIO;
+	void *buf = NULL;
 	char path[50];
-	void *buf;
 
 	ndctl_namespace_set_raw_mode(ndns, 1);
 	rc = ndctl_namespace_enable(ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
