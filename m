Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 87B8321B02822
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 00:34:30 -0800 (PST)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] ndctl, monitor: use type=simple instead of type=forking
Date: Tue,  8 Jan 2019 09:34:23 +0100
Message-Id: <20190108083423.6996-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

There is no need to use Type=forking for 'ndctl monitor', Type=simple is
sufficient.

When we use Type=forking and try to run ndctl monitor on a machine without
pmem we even get the following error in the journal:

Jan 07 13:34:54 bragi systemd[1]: Starting Ndctl Monitor Daemon...
Jan 07 13:34:54 bragi ndctl[13776]: custom logging function 0x55ea57d60250 registered
Jan 07 13:34:54 bragi systemd[1]: Started Ndctl Monitor Daemon.
Jan 07 13:34:54 bragi ndctl[13777]: ndctl monitor daemon started
Jan 07 13:34:54 bragi kill[13778]: kill: cannot find process ""
Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Control process exited, code=exited status=1
Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Unit entered failed state.
Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Failed with result 'exit-code'.

This is because the daemon exits and systemd is not able to determine
$MAINPID anymore.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 ndctl/ndctl-monitor.service | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
index 342a1b1972d5..eeedbd30bb42 100644
--- a/ndctl/ndctl-monitor.service
+++ b/ndctl/ndctl-monitor.service
@@ -2,9 +2,8 @@
 Description=Ndctl Monitor Daemon
 
 [Service]
-Type=forking
-ExecStart=/usr/bin/ndctl monitor --daemon
-ExecStop=/bin/kill ${MAINPID}
+Type=simple
+ExecStart=/usr/bin/ndctl monitor
 
 [Install]
 WantedBy=multi-user.target
-- 
2.16.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
