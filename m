Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB41F211C3F5C
 for <linux-nvdimm@lists.01.org>; Thu, 31 Jan 2019 15:24:40 -0800 (PST)
Subject: [PATCH] ndctl: security documentation update
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 31 Jan 2019 16:24:40 -0700
Message-ID: <154897708013.51182.14455795448108189661.stgit@djiang5-desk3.ch.intel.com>
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

In order to avoid terminology confusion, update the security man pages so
that when we are talking about keys, we are exclusively talking about the
key encryption key. The encrypted keys with payload will be referred to as
passphrase instead.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/intel-nvdimm-security.txt   |   14 +++++++-------
 Documentation/ndctl/ndctl-freeze-security.txt   |    4 ++++
 Documentation/ndctl/ndctl-remove-passphrase.txt |   10 +++++++---
 Documentation/ndctl/ndctl-sanitize-dimm.txt     |    6 +++++-
 Documentation/ndctl/ndctl-setup-passphrase.txt  |   16 ++++++++--------
 Documentation/ndctl/ndctl-update-passphrase.txt |   17 ++++++++---------
 6 files changed, 39 insertions(+), 28 deletions(-)

diff --git a/Documentation/ndctl/intel-nvdimm-security.txt b/Documentation/ndctl/intel-nvdimm-security.txt
index dc114df9..1b9e2434 100644
--- a/Documentation/ndctl/intel-nvdimm-security.txt
+++ b/Documentation/ndctl/intel-nvdimm-security.txt
@@ -58,10 +58,10 @@ of the nvdimm driver, it will:
 3. Finally, create the unlock DSM, copy the decrypted payload into the DSM
    passphrase field, and issue the DSM to unlock the DIMM.
 
-If the DIMM is already unlocked, the kernel will attempt to revalidate the key.
-This can be overriden with a kernel module parameter. If we fail to revalidate
-the key, the kernel will freeze the security and disallow any further security
-configuration changes.
+If the DIMM is already unlocked, the kernel will attempt to revalidate the
+passphrase.  This can be overriden with a kernel module parameter. If we fail
+to revalidate the passphrase, the kernel will freeze the security and disallow
+any further security configuration changes.
 
 SETUP USER PASSPHRASE
 ----------------------
@@ -126,9 +126,9 @@ will be issued first before overwrite.
 
 SECURITY FREEZE
 ---------------
-This operation requires no key to succeed. ndctl will issue the DSM command
-and upon completion, the security commands besides status query will be locked
-out until the next boot.
+This operation requires no passphrase to succeed. ndctl will issue the DSM
+command and upon completion, the security commands besides status query will
+be locked out until the next boot.
 
 MASTER PASSPHRASE SETUP, UPDATE, and CRYPTO ERASE
 -----------------------------------------------------------
diff --git a/Documentation/ndctl/ndctl-freeze-security.txt b/Documentation/ndctl/ndctl-freeze-security.txt
index 43ea81eb..46ec30d2 100644
--- a/Documentation/ndctl/ndctl-freeze-security.txt
+++ b/Documentation/ndctl/ndctl-freeze-security.txt
@@ -55,6 +55,10 @@ OPTIONS
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-v::
+--verbose::
+        Emit debug messages.
+
 include::intel-nvdimm-security.txt[]
 
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-remove-passphrase.txt b/Documentation/ndctl/ndctl-remove-passphrase.txt
index df83eaee..04722337 100644
--- a/Documentation/ndctl/ndctl-remove-passphrase.txt
+++ b/Documentation/ndctl/ndctl-remove-passphrase.txt
@@ -14,15 +14,19 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-Search the user key ring for the associated NVDIMM key. If not found,
-attempt to load the key blob. After disabling the passphrase successfully,
-remove the key and the key blob.
+Search the user key ring for the associated passphrase. If not found,
+attempt to load the passphrase blob. After disabling the passphrase
+successfully, remove the passphrase and the passphrase blob.
 
 OPTIONS
 -------
 <dimm>::
 include::xable-dimm-options.txt[]
 
+-v::
+--verbose::
+        Emit debug messages.
+
 include::intel-nvdimm-security.txt[]
 
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-sanitize-dimm.txt b/Documentation/ndctl/ndctl-sanitize-dimm.txt
index 06ce06c8..eb3d37c4 100644
--- a/Documentation/ndctl/ndctl-sanitize-dimm.txt
+++ b/Documentation/ndctl/ndctl-sanitize-dimm.txt
@@ -19,7 +19,7 @@ is the default method, and the other is overwrite the NVDIMM. ndctl will
 search the user key ring for the associated NVDIMM. If not found,
 attempt to load the key blob from the default location.
 Security is disabled for the dimm after operation and ndctl will remove
-the key from the key ring and delete the associated key blob file.
+the passphrase from the key ring and delete the associated passphrase blob file.
 
 OPTIONS
 -------
@@ -43,6 +43,10 @@ include::xable-dimm-options.txt[]
 	instead of the user passphrase. This only is applicable to the
 	crypto-erase option.
 
+-v::
+--verbose::
+        Emit debug messages.
+
 include::intel-nvdimm-security.txt[]
 
 include::../copyright.txt[]
diff --git a/Documentation/ndctl/ndctl-setup-passphrase.txt b/Documentation/ndctl/ndctl-setup-passphrase.txt
index 76b55492..e9ffd7c3 100644
--- a/Documentation/ndctl/ndctl-setup-passphrase.txt
+++ b/Documentation/ndctl/ndctl-setup-passphrase.txt
@@ -18,15 +18,15 @@ DESCRIPTION
 -----------
 Enable the security passphrase for one or more NVDIMMs.
 
-Prerequisite for command to succeed:
-1. The master key has already been loaded into the user key ring.
-2. ndctl install-encrypt-key has been executed successfully.
+Prerequisite for command to succeed is that the key encryption key has already been loaded
+into the user key ring. See kernel doc on how to do this:
+https://www.kernel.org/doc/html/latest/security/keys/trusted-encrypted.html
 
-The encrypted key blobs will be created by ndctl in {ndctl_keysdir} directory
-with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+The passphrase blobs will be created by ndctl in {ndctl_keysdir} directory
+with the file name of "nvdimm_<dimm-unique-id>_<hostname>.blob".
 
-The command will fail if the nvdimm key is already in the user key ring and/or
-the key blob already resides in {ndctl_keysdir}.
+The command will fail if the passphrase is already in the user key ring and/or
+the passphrase blob already resides in {ndctl_keysdir}.
 
 OPTIONS
 -------
@@ -47,7 +47,7 @@ include::xable-dimm-options.txt[]
 
 -v::
 --verbose::
-        Emit debug messages for the namespace check process.
+        Emit debug messages.
 
 include::intel-nvdimm-security.txt[]
 
diff --git a/Documentation/ndctl/ndctl-update-passphrase.txt b/Documentation/ndctl/ndctl-update-passphrase.txt
index 2a43f2bb..c09e4780 100644
--- a/Documentation/ndctl/ndctl-update-passphrase.txt
+++ b/Documentation/ndctl/ndctl-update-passphrase.txt
@@ -17,14 +17,13 @@ SYNOPSIS
 DESCRIPTION
 -----------
 Update the security passphrase for one or more NVDIMMs.
-Prerequisite for command to succeed:
+Prerequisites for command to succeed:
 1. The master key has already been loaded into the user key ring.
-2. ndctl install-encrypt-key has been executed successfully.
-3. setup-passphrase has successfully been executed previously on the NVDIMM
+2. setup-passphrase has successfully been executed previously on the NVDIMM
    or NVDIMM has been successfully unlocked by the kernel.
 
-The updated key blobs will be created by ndctl in {ndctl_keysdir} directory
-with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
+The updated passphrase blobs will be created by ndctl in {ndctl_keysdir}
+directory with the file name of "nvdimm_<dimm-unique-id>_<hostname>.blob".
 
 OPTIONS
 -------
@@ -33,12 +32,12 @@ include::xable-dimm-options.txt[]
 
 -k::
 --key_handle=::
-	The new encryption key (master) key handle, used for sealing the DIMM
+	The new master key handle, used for sealing the DIMM
 	encrypted keys. The format is <key type>:<key description>.
 	i.e. trusted:nvdimm-master
 	This key is expected to be loaded in the kernel's user keyring.
-	This parameter is optional. If none provided, ndctl will determine
-	the current key handle from the encrypted key for the NVDIMM.
+	This parameter is optional. If not provided, ndctl will determine
+	the current master key handle from the passphrase payload for the NVDIMM.
 
 -m::
 --master-passphrase::
@@ -47,7 +46,7 @@ include::xable-dimm-options.txt[]
 
 -v::
 --verbose::
-        Emit debug messages for the namespace check process.
+        Emit debug messages.
 
 include::intel-nvdimm-security.txt[]
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
