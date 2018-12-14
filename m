Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D87C211A45A6
 for <linux-nvdimm@lists.01.org>; Fri, 14 Dec 2018 13:09:42 -0800 (PST)
Subject: [PATCH v6 07/12] ndctl: setup modprobe rules
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 14 Dec 2018 14:09:41 -0700
Message-ID: <154482178124.65434.1988469520850504955.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
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
To: "vishal.l.verma."@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding reference config file for modprobe.d in order to trigger the
reference script that will inject keys associated with the nvdimms into
the kernel user ring for unlock.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Makefile.am                  |   10 ++++++++++
 contrib/ndctl-loadkeys.sh    |   24 ++++++++++++++++++++++++
 contrib/nvdimm_modprobe.conf |    1 +
 3 files changed, 35 insertions(+)
 create mode 100755 contrib/ndctl-loadkeys.sh
 create mode 100644 contrib/nvdimm_modprobe.conf

diff --git a/Makefile.am b/Makefile.am
index e0c463a3..5a3f03aa 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -42,6 +42,16 @@ bashcompletiondir = $(BASH_COMPLETION_DIR)
 dist_bashcompletion_DATA = contrib/ndctl
 endif
 
+load_key_file = contrib/ndctl-loadkeys.sh
+load_keydir = $(sysconfdir)/ndctl/
+load_key_DATA = $(load_key_file)
+EXTRA_DIST += $(load_key_file)
+
+modprobe_file = contrib/nvdimm_modprobe.conf
+modprobedir = $(sysconfdir)/modprobe.d/
+modprobe_DATA = $(modprobe_file)
+EXTRA_DIST += $(modprobe_file)
+
 noinst_LIBRARIES = libccan.a
 libccan_a_SOURCES = \
 	ccan/str/str.h \
diff --git a/contrib/ndctl-loadkeys.sh b/contrib/ndctl-loadkeys.sh
new file mode 100755
index 00000000..dae0a88a
--- /dev/null
+++ b/contrib/ndctl-loadkeys.sh
@@ -0,0 +1,24 @@
+#!/bin/bash -Ex
+
+# This script assumes a single master key for all DIMMs
+
+KEY_PATH=/etc/ndctl/keys
+TPMH_PATH=$KEY_PATH/tpm.handle
+KEYTPE=""
+TPM_HANDLE=""
+id=""
+
+if [ -f $TPMH_PATH ]; then
+	KEYTYPE=trusted
+	TPM_HANDLE="keyhandle=`cat $TPMH_PATH`"
+else
+	KEYTYPE=user
+fi
+
+keyctl show | grep -q nvdimm-master || keyctl add $KEYTYPE nvdimm-master "load `cat $KEY_PATH/nvdimm-master.blob` $TPM_HANDLE" @u > /dev/null
+
+for i in `ls -1 $KEY_PATH/nvdimm_*.blob`;
+do
+	id=`echo $i | cut -d'_' -f2`
+	keyctl add encrypted nvdimm:$id "load `cat $i`" @u
+done
diff --git a/contrib/nvdimm_modprobe.conf b/contrib/nvdimm_modprobe.conf
new file mode 100644
index 00000000..b113d8d7
--- /dev/null
+++ b/contrib/nvdimm_modprobe.conf
@@ -0,0 +1 @@
+install libnvdimm /usr/sbin/ndctl-loadkeys.sh ; /sbin/modprobe --ignore-install libnvdimm $CMDLINE_OPTS

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
