Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1C8220945D80
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jul 2018 13:59:34 -0700 (PDT)
Subject: [PATCH v6 11/11] libnvdimm: add documentation for nvdimm security
 support
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 25 Jul 2018 13:59:33 -0700
Message-ID: <153255237307.51274.5702807645252033322.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
References: <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add theory of operation for the security support that's going into
libnvdimm.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/nvdimm/security |   70 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)
 create mode 100644 Documentation/nvdimm/security

diff --git a/Documentation/nvdimm/security b/Documentation/nvdimm/security
new file mode 100644
index 000000000000..b776ef1f5e41
--- /dev/null
+++ b/Documentation/nvdimm/security
@@ -0,0 +1,70 @@
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
+update - enable security. Add or update current key.
+disable - disable enabled security and remove key.
+freeze - freeze changing of security states.
+erase - generate new ecryption key for DIMM and crypto-scrambles all existing
+	user data.
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
+The payload provided to the key can be a 32bytes payload or 64bytes payload
+when doing an "update". The payload is viewed as 64 bytes in the following
+format:
+[32 bytes new key data zero padded][32 bytes current key data zero padded]
+However, a 32bytes payload can be provided and will be assumed as the old
+key to be 32 bytes of 0s and the provided 32bytes payload is the new key.
+It is up to the user upcall function how that's presented as the key payload
+to the kernel.
+
+All the other security functions that require a provided key can accept a
+32bytes payload or 64bytes. If the payload is 64bytes, then second 32bytes
+will be ignored and the first 32bytes contains the expected "passphrase".
+
+4. Unlocking
+------------
+When the DIMMs are being enumerated by the kernel, the kernel will attempt to
+retrieve the key from its keyring. If that fails, it will attempt to
+acquire the key from the userspace upcall function. This is the only time
+a locked DIMM can be unlocked. Once unlocked, the DIMM will remain unlocked
+until reboot.
+
+[1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf
+[2]: http://www.t13.org/documents/UploadedDocuments/docs2006/e05179r4-ACS-SecurityClarifications.pdf

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
