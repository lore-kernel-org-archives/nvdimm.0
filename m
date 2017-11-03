Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14275203555FA
 for <linux-nvdimm@lists.01.org>; Fri,  3 Nov 2017 06:59:45 -0700 (PDT)
Subject: [PATCH] ndctl, test: fix smart event alerting unit test
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 03 Nov 2017 06:57:15 -0700
Message-ID: <150971743587.27961.15140037224342017626.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Daniel Osawa <daniel.k.osawa@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The 'libndctl' test was neglecting to add the health_eventfd to the
select() fdset when testing for notification timeouts. We also need to
clear the signalled status by reading the buffer.

Reported-by: Daniel Osawa <daniel.k.osawa@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index 50fce70183a8..770171919b6c 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2210,6 +2210,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	};
 	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
 	struct timeval tm;
+	char buf[4096];
 	fd_set fds;
 	int rc, fd;
 
@@ -2221,6 +2222,8 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 
 	fd = ndctl_dimm_get_health_eventfd(dimm);
 	FD_ZERO(&fds);
+	FD_SET(fd, &fds);
+	rc = pread(fd, buf, sizeof(buf), 0);
 	tm.tv_sec = 0;
 	tm.tv_usec = 500;
 	rc = select(fd + 1, NULL, NULL, &fds, &tm);
@@ -2245,6 +2248,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 			rc = select(fd + 1, NULL, NULL, &fds, &tm);
 			if (rc != 1 || !FD_ISSET(fd, &fds))
 				exit(EXIT_FAILURE);
+			rc = pread(fd, buf, sizeof(buf), 0);
 			exit(EXIT_SUCCESS);
 		}
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
