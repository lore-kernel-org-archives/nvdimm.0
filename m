Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8F42202E5E59
 for <linux-nvdimm@lists.01.org>; Mon,  6 Nov 2017 15:14:32 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] libndctl: add missing error handling in
 _wait_for_scrub_completion
Date: Mon,  6 Nov 2017 16:16:09 -0700
Message-Id: <20171106231610.8271-2-vishal.l.verma@intel.com>
In-Reply-To: <20171106231610.8271-1-vishal.l.verma@intel.com>
References: <20171106231610.8271-1-vishal.l.verma@intel.com>
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

Static analysis complains that we could be passing a negative value to
close(). The root of the problem is that we neglect to error-check the
return from open(). Add that to correctly fix the problem. Also fix a
whitespace error in close().

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index e78a32c..6737705 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1114,6 +1114,12 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 	int fd = 0, rc;
 
 	fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
+	if (fd < 0) {
+		err(ctx, "failed to open %s: %s\n", bus->scrub_path,
+			strerror(errno));
+		return -errno;
+	}
+
 	fds.fd = fd;
 	fds.events =  POLLPRI | POLLIN;
 	do {
@@ -1154,7 +1160,7 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 
 	dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
 	if (fd)
-		close (fd);
+		close(fd);
 	return rc < 0 ? -ENXIO : 0;
 }
 
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
