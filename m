Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 89595209831EC
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 16:00:15 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/4] ndctl, monitor: Fix memory leak in monitor_event
Date: Thu, 19 Jul 2018 16:59:57 -0600
Message-Id: <20180719225958.6814-4-vishal.l.verma@intel.com>
In-Reply-To: <20180719225958.6814-1-vishal.l.verma@intel.com>
References: <20180719225958.6814-1-vishal.l.verma@intel.com>
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

Static analysis reports we were leaking the 'events' buffer in the above
function. We were also returning a simple '1' for every error case. Take
this chance to return a more meaningful 'errno' in each case, while also
fixing up the resource leak.

Fixes: fdf6b6844ccf ("ndctl, monitor: add a new command - monitor")
Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/monitor.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 4d25c2b..7fc2aaa 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -360,32 +360,35 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		struct monitor_filter_arg *mfa)
 {
 	struct epoll_event ev, *events;
-	int nfds, epollfd, i, rc;
+	int nfds, epollfd, i, rc = 0;
 	struct monitor_dimm *mdimm;
 	char buf;
 
 	events = calloc(mfa->num_dimm, sizeof(struct epoll_event));
 	if (!events) {
 		err(ctx, "malloc for events error\n");
-		return 1;
+		return -ENOMEM;
 	}
 	epollfd = epoll_create1(0);
 	if (epollfd == -1) {
 		err(ctx, "epoll_create1 error\n");
-		return 1;
+		rc = -errno;
+		goto out;
 	}
 	list_for_each(&mfa->dimms, mdimm, list) {
 		memset(&ev, 0, sizeof(ev));
 		rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
 		if (rc < 0) {
 			err(ctx, "pread error\n");
-			return 1;
+			rc = -errno;
+			goto out;
 		}
 		ev.data.ptr = mdimm;
 		if (epoll_ctl(epollfd, EPOLL_CTL_ADD,
 				mdimm->health_eventfd, &ev) != 0) {
 			err(ctx, "epoll_ctl error\n");
-			return 1;
+			rc = -errno;
+			goto out;
 		}
 	}
 
@@ -394,7 +397,8 @@ static int monitor_event(struct ndctl_ctx *ctx,
 		nfds = epoll_wait(epollfd, events, mfa->num_dimm, -1);
 		if (nfds <= 0) {
 			err(ctx, "epoll_wait error\n");
-			return 1;
+			rc = -errno;
+			goto out;
 		}
 		for (i = 0; i < nfds; i++) {
 			mdimm = events[i].data.ptr;
@@ -404,13 +408,18 @@ static int monitor_event(struct ndctl_ctx *ctx,
 						ndctl_dimm_get_devname(mdimm->dimm));
 			}
 			rc = pread(mdimm->health_eventfd, &buf, sizeof(buf), 0);
-			if (rc < 0)
-				fail("pread error\n");
+			if (rc < 0) {
+				err(ctx, "pread error\n");
+				rc = -errno;
+				goto out;
+			}
 		}
 		if (did_fail)
 			return 1;
 	}
-	return 0;
+ out:
+	free(events);
+	return rc;
 }
 
 static int parse_monitor_event(struct monitor *_monitor, struct ndctl_ctx *ctx)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
