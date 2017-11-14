Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym01.jp.fujitsu.com (mgwym01.jp.fujitsu.com [211.128.242.40])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1C4A2035A7DF
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:11 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id AC19BAC00A2
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 6/7] ndctl: nvdimmd: add the unit file of systemd for
 nvdimmd service
Date: Tue, 14 Nov 2017 16:47:03 +0900
Message-Id: <20171114074704.3446-7-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
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

This patch adds and autotools to install the unit file of systemd for
nvdimmd service.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 nvdimmd/Makefile.am     | 7 +++++++
 nvdimmd/nvdimmd.service | 7 +++++++
 2 files changed, 14 insertions(+)
 create mode 100644 nvdimmd/nvdimmd.service

diff --git a/nvdimmd/Makefile.am b/nvdimmd/Makefile.am
index 6716547..bca0bc8 100644
--- a/nvdimmd/Makefile.am
+++ b/nvdimmd/Makefile.am
@@ -18,6 +18,12 @@ nvdimmd_LDADD = ../ndctl/lib/libndctl.la \
 		$(UUID_LIBS) \
 		$(UDEV_LIBS)
 
+unitfiles = nvdimmd.service
+
+unitdir = /usr/lib/systemd/system/
+
+unit_DATA = $(unitfiles)
+
 conffiles = nvdimmd.conf
 
 confdir = /etc/nvdimmd/
@@ -25,4 +31,5 @@ confdir = /etc/nvdimmd/
 conf_DATA = $(conffiles)
 
 EXTRA_DIST =\
+	$(unitfiles) \
 	$(conffiles)
diff --git a/nvdimmd/nvdimmd.service b/nvdimmd/nvdimmd.service
new file mode 100644
index 0000000..0b96aaa
--- /dev/null
+++ b/nvdimmd/nvdimmd.service
@@ -0,0 +1,7 @@
+[Unit]
+Description=Nvdimm Daemon
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/nvdimmd
+ExecStop=/usr/bin/kill ${MAINPID}
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
