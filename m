Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFDE12283930C
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 11:50:58 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/4] libndctl, test: fix a couple of unchecked returns
Date: Thu,  3 May 2018 12:50:49 -0600
Message-Id: <20180503185050.7559-3-vishal.l.verma@intel.com>
In-Reply-To: <20180503185050.7559-1-vishal.l.verma@intel.com>
References: <20180503185050.7559-1-vishal.l.verma@intel.com>
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

-Wunused-result with -D_FORTIFY_SOURCE=2 reported a couple of unchecked
return values, fix them by appropriately failing on errors.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 5 ++++-
 test/dax-pmd.c       | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 6733b85..47e005e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1243,7 +1243,10 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 				break;
 			}
 			dbg(ctx, "poll wake: revents: %d\n", fds.revents);
-			pread(fd, buf, 1, 0);
+			if (pread(fd, buf, 1, 0) == -1) {
+				rc = -errno;
+				break;
+			}
 			fds.revents = 0;
 		}
 	}
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 06fe522..65bee6f 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -125,7 +125,10 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 				rc = -ENXIO;
 			}
 			((char *) buf)[0] = 0;
-			pread(fd2, buf, 4096, 0);
+			if (pread(fd2, buf, 4096, 0) != 4096) {
+				faili(i);
+				rc = -ENXIO;
+			}
 			if (strcmp(buf, "odirect data") != 0) {
 				faili(i);
 				rc = -ENXIO;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
