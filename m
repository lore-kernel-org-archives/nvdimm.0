Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53F96210ED104
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 17:40:59 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl,
 udev: fix a resource leak in save_unsafe_shutdown_count
Date: Fri, 10 Aug 2018 18:40:53 -0600
Message-Id: <20180811004053.15392-2-vishal.l.verma@intel.com>
In-Reply-To: <20180811004053.15392-1-vishal.l.verma@intel.com>
References: <20180811004053.15392-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Static analysis reports that we leak the 'fd' in the above function. Fix
by adding a proper cleanup path that closes it.

Cc: Keith Busch <keith.busch@intel.com>
Fixes: dd8e6ff9ab00 ("ndctl: Create ndctl udev rules for dirty shutdown")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/ndctl-udev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/ndctl/ndctl-udev.c b/ndctl/ndctl-udev.c
index 2b4d067..7b174b6 100644
--- a/ndctl/ndctl-udev.c
+++ b/ndctl/ndctl-udev.c
@@ -110,10 +110,13 @@ static void save_unsafe_shutdown_count(struct ndctl_dimm *dimm,
 		goto free_usc;
 
 	if (snprintf(count, sizeof(count), "%u\n", shutdown) < 0)
-		goto free_usc;
+		goto close_fd;
 
 	if (write(fd, count, strlen(count)) < 0)
-		goto free_usc;
+		goto close_fd;
+
+ close_fd:
+	close(fd);
  free_usc:
 	free(usc);
  free_path:
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
