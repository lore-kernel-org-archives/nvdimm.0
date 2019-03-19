Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CD4A211DC092
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 23:18:54 -0700 (PDT)
Subject: [PATCH 0/6] security/keys/encrypted: Break module dependency chain
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Mar 2019 23:06:15 -0700
Message-ID: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-nvdimm@lists.01.org, James Bottomley <jejb@linux.ibm.com>, ecryptfs@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Tyler Hicks <tyhicks@canonical.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With v5.1-rc1 all the nvdimm sub-system regression tests started failing
because the libnvdimm module failed to load in the qemu-kvm test
environment.  Critically that environment does not have a TPM. Commit
240730437deb "KEYS: trusted: explicitly use tpm_chip structure..."
started to require a TPM to be present for the trusted.ko module to load
where there was no requirement for that before.

Rather than undo the "fail if no hardware" behavior James points out
that the module dependencies can be broken by looking up the key-type by
name. Remove the dependencies on the "key_type_trusted" and
"key_type_encrypted" symbol exports, and clean up other boilerplate that
supported those exports in different configurations.

---

Dan Williams (6):
      security/keys/encrypted: Allow operation without trusted.ko
      security/keys/encrypted: Clean up request_trusted_key()
      libnvdimm/security: Drop direct dependency on key_type_encrypted
      security/keys/ecryptfs: Drop direct dependency on key_type_encrypted
      security/integrity/evm: Drop direct dependency on key_type_encrypted
      security/keys/encrypted: Drop export of key_type_encrypted


 drivers/nvdimm/security.c                        |   11 ++++-
 fs/ecryptfs/ecryptfs_kernel.h                    |   22 -----------
 fs/ecryptfs/keystore.c                           |   12 ++++++
 include/keys/encrypted-type.h                    |    2 -
 include/linux/key.h                              |    1 
 security/integrity/evm/evm_crypto.c              |    9 ++++
 security/keys/encrypted-keys/Makefile            |    3 -
 security/keys/encrypted-keys/encrypted.c         |   35 ++++++++++++++++-
 security/keys/encrypted-keys/encrypted.h         |   12 ------
 security/keys/encrypted-keys/masterkey_trusted.c |   46 ----------------------
 security/keys/internal.h                         |    2 -
 security/keys/key.c                              |    1 
 12 files changed, 65 insertions(+), 91 deletions(-)
 delete mode 100644 security/keys/encrypted-keys/masterkey_trusted.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
