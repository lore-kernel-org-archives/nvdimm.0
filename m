Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0BDB21184E66
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 14:14:29 -0800 (PST)
Subject: [PATCH 08/11] libnvdimm/security: add documentation for ovewrite
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 09 Nov 2018 15:14:29 -0700
Message-ID: <154180166906.70506.2262123031486305806.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, zohar@linux.vnet.ibm.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add overwrite command usages to security documentation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/nvdimm/security.txt |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/nvdimm/security.txt b/Documentation/nvdimm/security.txt
index 11240ce48755..dfe70a8fa25b 100644
--- a/Documentation/nvdimm/security.txt
+++ b/Documentation/nvdimm/security.txt
@@ -96,9 +96,19 @@ its keyid should be passed in via sysfs.
 The command format for doing a secure erase is:
 erase <current keyid>
 
-An "old" key with the passphrase payload that is tied to the nvdimm should be
-injected with a key description that does not have the "nvdimm:" prefix and
-its keyid should be passed in via sysfs.
+9. Overwrite
+------------
+The command format for doing an overwrite is:
+overwrite <current keyid>
+
+Overwrite can be done without a key if security is not enabled. A key serial
+of 0 can be passed in to indicate no key.
+
+The sysfs attribute "security" can be polled to wait on overwrite completion.
+Overwrite can last tens of minutes or more depending on nvdimm size.
+
+An encrypted key with the current key passphrase that is tied to the nvdimm
+should be injected and its keyid should be passed in via sysfs.
 
 [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.7.pdf
 [2]: http://www.t13.org/documents/UploadedDocuments/docs2006/e05179r4-ACS-SecurityClarifications.pdf

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
