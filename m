Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 924C7211E9FBD
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 15:26:06 -0700 (PDT)
Subject: [PATCH v2 3/3] ndctl: add unit test for load-keys
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 28 Mar 2019 15:26:05 -0700
Message-ID: <155381190641.13778.16998322434894711396.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <155381182887.13778.15556671056565903543.stgit@djiang5-desk3.ch.intel.com>
References: <155381182887.13778.15556671056565903543.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add to security.sh to test load-keys for user keys.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

V2:
- Add quotes around $masterkey. (Vishal)
- Change fail to failed in output. (Vishal)

 test/security.sh |   68 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/test/security.sh b/test/security.sh
index 1b7a9a1a..8a36265f 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -6,8 +6,10 @@ rc=77
 dev=""
 id=""
 keypath="/etc/ndctl/keys"
-masterkey="nvdimm-master-test"
-masterpath="$keypath/$masterkey"
+masterkey="nvdimm-master"
+masterpath="$keypath/$masterkey.blob"
+backup_key=0
+backup_handle=0
 
 . ./common
 
@@ -32,6 +34,15 @@ setup_keys()
 		mkdir -p "$keypath"
 	fi
 
+	if [ -f "$masterpath" ]; then
+		mv "$masterpath" "$masterpath.bak"
+		$backup_key=1
+	fi
+	if [ -f "$keypath/tpm.handle" ]; then
+		mv "$keypath/tpm.handle" "$keypath/tmp.handle.bak"
+		$backup_handle=1
+	fi
+
 	dd if=/dev/urandom bs=1 count=32 2>/dev/null | keyctl padd user "$masterkey" @u
 	keyctl pipe "$(keyctl search @u user $masterkey)" > "$masterpath"
 }
@@ -43,16 +54,25 @@ test_cleanup()
 	fi
 
 	if keyctl search @u user "$masterkey"; then
-		keyctl unlink "$(keyctl search @u user $masterkey)"
+		keyctl unlink "$(keyctl search @u user "$masterkey")"
 	fi
 
 	if [ -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob ]; then
 		rm -f "$keypath"/nvdimm_"$id"_"$(hostname)".blob
 	fi
+}
 
+post_cleanup()
+{
 	if [ -f $masterpath ]; then
 		rm -f "$masterpath"
 	fi
+	if [ "$backup_key" -eq 1 ]; then
+		mv "$masterpath.bak" "$masterpath"
+	fi
+	if [ "$backup_handle" -eq 1 ]; then
+		mv "$keypath/tpm.handle.bak" "$keypath/tmp.handle"
+	fi
 }
 
 lock_dimm()
@@ -168,8 +188,8 @@ test_4_security_unlock()
 	remove_passphrase
 }
 
-# this should always be the last test. with security frozen, nfit_test must
-# be removed and is no longer usable
+# This should always be the last nvdimm security test.
+# with security frozen, nfit_test must be removed and is no longer usable
 test_5_security_freeze()
 {
 	setup_passphrase
@@ -188,6 +208,33 @@ test_5_security_freeze()
 	fi
 }
 
+test_6_load_keys()
+{
+	if keyctl search @u encrypted nvdimm:"$id"; then
+		keyctl unlink "$(keyctl search @u encrypted nvdimm:"$id")"
+	fi
+
+	if keyctl search @u user "$masterkey"; then
+		keyctl unlink "$(keyctl search @u user "$masterkey")"
+	fi
+
+	$NDCTL load-keys
+
+	if keyctl search @u user "$masterkey"; then
+		echo "master key loaded"
+	else
+		echo "master key failed to loaded"
+		err "$LINENO"
+	fi
+
+	if keyctl search @u encrypted nvdimm:"$id"; then
+		echo "dimm key loaded"
+	else
+		echo "dimm key failed to load"
+		err "$LINENO"
+	fi
+}
+
 check_min_kver "5.0" || do_skip "may lack security handling"
 uid="$(keyctl show | grep -Eo "_uid.[0-9]+" | head -1 | cut -d. -f2-)"
 if [ "$uid" -ne 0 ]; then
@@ -210,11 +257,18 @@ test_3_security_setup_and_erase
 echo "Test 4, unlock dimm"
 test_4_security_unlock
 
-# Freeze should always be run last because it locks security state and require
-# nfit_test module unload.
+# Freeze should always be the last nvdimm security test because it locks
+# security state and require nfit_test module unload. However, this does
+# not impact any key management testing via libkeyctl.
 echo "Test 5, freeze security"
 test_5_security_freeze
 
+# Load-keys is independent of actual nvdimm security and is part of key
+# mangement testing.
+echo "Test 6, test load-keys"
+test_6_load_keys
+
 test_cleanup
+post_cleanup
 _cleanup
 exit 0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
