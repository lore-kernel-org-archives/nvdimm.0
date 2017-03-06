Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A7FB68032B
 for <linux-nvdimm@lists.01.org>; Mon,  6 Mar 2017 13:38:52 -0800 (PST)
Subject: [PATCH 2/4] ndctl: have do_cmd() in libndctl return errno instead
 of -1
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 06 Mar 2017 14:38:51 -0700
Message-ID: <148883633185.72901.4238984422833200159.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
References: <148883624600.72901.16358369702902205527.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This makes debugging easier as we would get the actual errno instead of
just a generic -1 for the top most calling function that invokes do_cmd().

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/libndctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 3a2530d..090ec0b 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2259,7 +2259,10 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 				? ndctl_dimm_get_handle(cmd->dimm) : 0,
 				name, rc, *(cmd->firmware_status), rc < 0 ?
 				strerror(errno) : "success");
-		return rc;
+		if (rc < 0)
+			return -errno;
+		else
+			return rc;
 	}
 
 	for (offset = 0; offset < iter->total_xfer; offset += iter->max_xfer) {
@@ -2270,8 +2273,10 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 			memcpy(iter->data, iter->total_buf + offset,
 					*(cmd->iter.xfer));
 		rc = ioctl(fd, ioctl_cmd, cmd->cmd_buf);
-		if (rc < 0)
+		if (rc < 0) {
+			rc = -errno;
 			break;
+		}
 
 		if (iter->dir == READ)
 			memcpy(iter->total_buf + offset, iter->data,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
