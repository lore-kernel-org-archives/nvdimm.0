Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39D1921E70D3B
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 14:37:52 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm fix for 4.13-final
Date: Wed, 30 Aug 2017 21:37:54 +0000
Message-ID: <1504129067.3089.3.camel@intel.com>
Content-Language: en-US
Content-ID: <C66C7D52C730514AA82A6EFB7CD875E9@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

...to receive a single patch removing some structure definitions from a
uapi header file. These payloads are never processed directly by the
kernel they are simply passed through an ioctl as opaque blobs to the
ACPI _DSM (Device Specific Method) interface.

Userspace should not be depending on the kernel to define these
payloads. We will instead provide these definitions via the existing
libndctl (https://github.com/pmem/ndctl) project that has NVDIMM
command helpers and other definitions.

---

The following changes since commit cc4a41fe5541a73019a864883297bd5043aa6d98:

  Linux 4.13-rc7 (2017-08-27 17:20:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-fixes

for you to fetch changes up to 7a14724f54bf9889fcb1a9f1d4aa4e1d2e969d93:

  libnvdimm: clean up command definitions (2017-08-28 08:33:20 -0700)

----------------------------------------------------------------
Dan Williams (1):
      libnvdimm: clean up command definitions

 include/uapi/linux/ndctl.h | 37 -------------------------------------
 1 file changed, 37 deletions(-)

commit 7a14724f54bf9889fcb1a9f1d4aa4e1d2e969d93
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Aug 28 08:33:20 2017 -0700

    libnvdimm: clean up command definitions
    
    Remove the command payloads that do not have an associated libnvdimm
    ioctl. I.e. remove the payloads that would only ever be carried in the
    ND_CMD_CALL envelope. This prevents userspace from growing unnecessary
    dependencies on this kernel header when userspace already has everything
    it needs to craft and send these commands.
    
    Cc: Jerry Hoemann <jerry.hoemann@hpe.com>
    Reported-by: Yasunori Goto <y-goto@jp.fujitsu.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c54264d8e..3f03567631cb 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -145,43 +145,6 @@ struct nd_cmd_clear_error {
 	__u64 cleared;
 } __packed;
 
-struct nd_cmd_trans_spa {
-	__u64 spa;
-	__u32 status;
-	__u8  flags;
-	__u8  _reserved[3];
-	__u64 trans_length;
-	__u32 num_nvdimms;
-	struct nd_nvdimm_device {
-		__u32 nfit_device_handle;
-		__u32 _reserved;
-		__u64 dpa;
-	} __packed devices[0];
-
-} __packed;
-
-struct nd_cmd_ars_err_inj {
-	__u64 err_inj_spa_range_base;
-	__u64 err_inj_spa_range_length;
-	__u8  err_inj_options;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_clr {
-	__u64 err_inj_clr_spa_range_base;
-	__u64 err_inj_clr_spa_range_length;
-	__u32 status;
-} __packed;
-
-struct nd_cmd_ars_err_inj_stat {
-	__u32 status;
-	__u32 inj_err_rec_count;
-	struct nd_error_stat_query_record {
-		__u64 err_inj_stat_spa_range_base;
-		__u64 err_inj_stat_spa_range_length;
-	} __packed record[0];
-} __packed;
-
 enum {
 	ND_CMD_IMPLEMENTED = 0,
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
