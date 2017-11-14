Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCEA22035A7DA
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:13 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 87540AC0113
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 5/7] ndctl: nvdimmd: add nvdimmd config file
Date: Tue, 14 Nov 2017 16:47:02 +0900
Message-Id: <20171114074704.3446-6-qi.fuli@jp.fujitsu.com>
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

This patch adds nvdimmd.conf.
Autotools to install the config file for nvdimmd service.
The nvdimmd.conf includs the following parameters.
   - LOGFILE: Users can choose either to write the notifications into syslog
     (LOGFILE=syslog), or to send into a special file under /var/log/nvdimmd/
     (such as LOGFILE=nvdimmd.log) by configuring LOGFILE parameter in the
     config file.
   - LOGFORMAT: Users can choose the format of notification to be structured
     json(LOGFORMAT=json) or text(LOGFORMAT=text) by configuring LOGFORMAT
     parameter in the config file.
   - MONITORDIMM: The dimms to monitor are filtered via dimm's name by setting
     MONITORDIMM parameter in the config file. When setting up multiple dimms,
     the names of dimms should be separated by ",".(MONITORDIMM=nmem0,nmem1,nmem2)
   - MONITORBUS: The dimms to monitor are filtered via its parent bus by setting
     MONITORBUS parameter as well. When setting up multiple dimms, the names of
     buses should be separated by "," (MONITORBUS=ndbus0,ndbus1)
The nvdimmd.conf would be read when nvdimmd service starts. Users need to restart
nvdimmd service after changing the value of paramaters in nvdimmd.conf.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 nvdimmd/Makefile.am  |  9 +++++++++
 nvdimmd/nvdimmd.conf | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 nvdimmd/nvdimmd.conf

diff --git a/nvdimmd/Makefile.am b/nvdimmd/Makefile.am
index 9883edd..6716547 100644
--- a/nvdimmd/Makefile.am
+++ b/nvdimmd/Makefile.am
@@ -17,3 +17,12 @@ nvdimmd_LDADD = ../ndctl/lib/libndctl.la \
 		$(JSON_LIBS) \
 		$(UUID_LIBS) \
 		$(UDEV_LIBS)
+
+conffiles = nvdimmd.conf
+
+confdir = /etc/nvdimmd/
+
+conf_DATA = $(conffiles)
+
+EXTRA_DIST =\
+	$(conffiles)
diff --git a/nvdimmd/nvdimmd.conf b/nvdimmd/nvdimmd.conf
new file mode 100644
index 0000000..4e6a12a
--- /dev/null
+++ b/nvdimmd/nvdimmd.conf
@@ -0,0 +1,25 @@
+# This is the main Nvdimm daemon configuration file. It contains the
+# configuration directives that give nvdimmd its instructions.
+# You can change settings by editing this file.
+# The changed item will work after restart nvdimmd service.
+# In this file, lines starting with a hash (#) are comments.
+# The following charecters are not allowed the value: : # ? / \ % " '
+
+# LOGFILE: Users can choose either to write the notifications into syslog
+# (LOGFILE=syslog), or to send into a special file under /var/log/nvdimmd/
+# (such as LOGFILE=nvdimmd.log) by setting LOGFILE.
+LOGFILE=nvdimmd.log
+
+# LOGFORMAT: Users can choose the format of notification to be json
+# (LOGFORMAT=json) or text(LOGFORMAT=text) by setting LOGFORMAT.
+LOGFORMAT = json
+
+# MONITORDIMM: The dimms to monitor are filtered via dimm's name by setting
+# MONITORDIMM. When setting up mutiple dimms, the names of dimms should be
+# separated by ",".(MONITORDIMM=nmem0,nmem1,nmem2)
+MONITORDIMM=all
+
+# MONITORBUS: The dimms to monitor are filtered via its parent bus by
+# setting as well. When setting up mutiple dimms, the names of buses
+# should be seprated by "," (MONITORBUS=ndbus0,ndbus1)
+MONITORBUS=all
-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
