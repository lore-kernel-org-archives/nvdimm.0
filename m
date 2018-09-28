Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7D602115C07B
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 14:54:30 -0700 (PDT)
Subject: [PATCH v11 10/12] libnvdimm: add documentation for nvdimm security
 support
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 28 Sep 2018 14:54:23 -0700
Message-ID: <153817166322.17152.9001270695094344266.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
References: <153817140052.17152.8594371908103118425.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add theory of operation for the security support that's going into
libnvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/nvdimm/security.txt |   99 +++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/nvdimm/security.txt

diff --git a/Documentation/nvdimm/security.txt b/Documentation/nvdimm/security.txt
new file mode 100644
index 000000000000..50cbb6cb96a1
--- /dev/null
+++ b/Documentation/nvdimm/security.txt
@@ -0,0 +1,99 @@
+NVDIMM SECURITY
+===============
+
+1. Introduction
+---------------
+
+With the introduction of Intel DSM v1.7 specification [1], security DSMs are
+introduced. The spec added the following security DSMs: "get security state",
+"set passphrase", "disable passphrase", "unlock unit", "freeze lock",
+"secure erase", and "overwrite". A security_ops data structure has been
+added to struct dimm in order to support the security operations and generic
+APIs are exposed to allow vendor neutral operations.
+
+2. Sysfs Interface
+------------------
+The "security" sysfs attribute is provided in the nvdimm sysfs directory. For
+example:
+/sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem0/security
+
+The "show" function of that attribute will display the security state for
+that DIMM. The following states are available: disabled, unlocked, locked,
+frozen, and unsupported.
+
+The "store" function takes several commands when the attribute is written to
+in order to support some of the security functionalities:
+update <old_keyid> <new_keyid> - enable security. Add or update current key.
+disable <old_keyid> - disable enabled security and remove key.
+freeze - freeze changing of security states.
+erase <old_keyid> - generate new ecryption key for DIMM and crypto-scrambles
+	all existing user data.
+
+3. Key Management
+-----------------
+
+The key is associted to the payload by the DIMM id. For example:
+# cat /sys/devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0012:00/ndbus0/nmem0/nfit/id
+8089-a2-1740-00000133
+The DIMM id would be provided along with the key payload (passphrase) to
+the kernel.
+
+The security keys are managed on the basis of a single key per DIMM. The
+key "passphrase" is expected to be 32bytes long or padded to 32bytes. This is
+similar to the ATA security specification [2]. A key is initially acquired
+via the request_key() kernel API call and retrieved from userspace. It is up to
+the user to provide an upcall application to retrieve the key in whatever
+fashion meets their security requirements.
+
+A nvdimm user logon key has the description format of:
+nvdimm:<bus-provider-specific-unique-id>
+
+4. Unlocking
+------------
+When the DIMMs are being enumerated by the kernel, the kernel will attempt to
+retrieve the key from its keyring. If that fails, it will attempt to
+acquire the key from the userspace upcall function. This is the only time
+a locked DIMM can be unlocked. Once unlocked, the DIMM will remain unlocked
+until reboot.
+
+5. Update
+---------
+When doing an update, it is expected that the new key with the 64bit payload of
+format described above is added via the keyutils API or utility. The update
+command written to the sysfs attribute will be with the format:
+update <old keyid> <new keyid>
+
+It is expected that a user logon key has been injected via keyutils to provide
+the payload for the update operation. The kernel will take the new user key,
+attempt the update operation with the nvdimm, and replace the existing key's
+payload with the new passphrase.
+
+If there is no old key id due to a security enabling, then a 0 should be
+passed in.  If a nvdimm has an existing passphrase, then an "old" key should
+be injected with a key description that does not have the "nvdimm:" prefix.
+
+6. Freeze
+---------
+The freeze operation does not require any keys. The security config can be
+frozen by a user with root privelege.
+
+7. Disable
+----------
+The security disable command format is:
+disable <old keyid>
+
+An "old" key with the passphrase payload that is tied to the nvdimm should be
+injected with a key description that does not have the "nvdimm:" prefix and
+its keyid should be passed in via sysfs.
+
+8. Secure Erase
+---------------
+The command format for doing a secure erase is:
+erase <old keyid>
+
+An "old" key with the passphrase payload that is tied to the nvdimm should be
+injected with a key description that does not have the "nvdimm:" prefix and
+its keyid should be passed in via sysfs.
+
+[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf
+[2]: http://www.t13.org/documents/UploadedDocuments/docs2006/e05179r4-ACS-SecurityClarifications.pdf

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
