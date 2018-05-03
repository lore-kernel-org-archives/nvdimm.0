Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA0A32282E589
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 11:50:57 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/4] libndctl: improve debug prints in
 wait_for_scrub_completion
Date: Thu,  3 May 2018 12:50:48 -0600
Message-Id: <20180503185050.7559-2-vishal.l.verma@intel.com>
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

ndctl_bus_wait_for_scrub_completion() printed the same debug message
irrespective of whether we encountered a failure or not. Add a newe
debug message that is printed for failing cases.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 2a3ef0c..6733b85 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1248,7 +1248,11 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 		}
 	}
 
-	dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
+	if (rc == 0)
+		dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
+	else
+		dbg(ctx, "bus%d: error waiting for scrub completion: %s\n",
+			ndctl_bus_get_id(bus), strerror(-rc));
 	if (fd)
 		close (fd);
 	return rc;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
