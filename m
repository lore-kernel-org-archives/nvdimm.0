Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91B23211B5A46
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 09:54:31 -0800 (PST)
Subject: [PATCH v7 07/12] ndctl: setup modprobe rules
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 09 Jan 2019 10:54:30 -0700
Message-ID: <154705647045.23227.7733373111052687524.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding reference config file for modprobe.d in order to trigger the
reference script that will inject keys associated with the nvdimms into
the kernel user ring for unlock.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Makefile.am                  |   10 ++++++++++
 contrib/ndctl-loadkeys.sh    |   25 +++++++++++++++++++++++++
 contrib/nvdimm_modprobe.conf |    1 +
 3 files changed, 36 insertions(+)
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
index 00000000..bc2c94df
--- /dev/null
+++ b/contrib/ndctl-loadkeys.sh
@@ -0,0 +1,25 @@
+#!/bin/bash -Ex
+
+# This script assumes a single master key for all DIMMs
+
+key_path=/etc/ndctl/keys
+tpmh_path="$key_path"/tpm.handle
+key_type=""
+tpm_handle=""
+id=""
+
+if [ -f $tpmh_path ]; then
+	key_type=trusted
+	tpm_handle="keyhandle=$(cat $tpmh_path)"
+else
+	key_type=user
+fi
+
+if ! keyctl search @u "$key_type" nvdimm-master; then
+	keyctl add "$key_type" nvdimm-master "load $(cat $key_path/nvdimm-master.blob) $tpm_handle" @u > /dev/null
+fi
+
+for file in "$key_path"/nvdimm_*; do
+	id="$(cut -d'_' -f2 <<< "${file##*/}")"
+	keyctl add encrypted nvdimm:"$id" "load $(cat "$file")" @u
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
