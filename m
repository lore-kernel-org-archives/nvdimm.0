Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F38B1A1E2A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 12:50:24 -0700 (PDT)
Subject: [ndctl PATCH] libndctl: don't attempt to read/write past the end of
 the label area
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Oct 2016 12:47:21 -0700
Message-ID: <147647444172.16152.1588914246838849105.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Some NVDIMM platform implementations (like QEMU) rather than partially
completing the part of the transfer that is in-scope fail the request
outright.  Teach the label area iterator to trim the request to the
valid remaining space in the total transfer.

This resolves the following problem when attempting to dump the label
area with "ndctl read-labels -j all":

 nfit ACPI0012:00: acpi_nfit_ctl:nmem0 get_data input length: 8
 get_data00000000: 0001fd80 00000fec                    ........
 nfit ACPI0012:00: acpi_nfit_ctl:nmem0 get_data output length: 8
 get_data00000000: 00000003 00000005                    ........
 nfit ACPI0012:00: acpi_nfit_ctl:nmem0 output object underflow get_data field: 1

The line "get_data00000000: 00000003 00000005" is an EINVAL response
from platform firmware.

Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl-private.h |    1 +
 ndctl/lib/libndctl.c         |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
index 0dc9e30cdb6e..050431850c66 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/libndctl-private.h
@@ -176,6 +176,7 @@ struct ndctl_cmd {
 	u32 *firmware_status;
 	struct ndctl_cmd_iter {
 		u32 *offset;
+		u32 *xfer; /* pointer to xfer length in cmd */
 		u8 *data; /* pointer to the data buffer location in cmd */
 		u32 max_xfer;
 		char *total_buf;
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 14bf2170f816..02524501db16 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1968,6 +1968,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg
 	cmd->get_data->in_length = cfg_size->get_size->max_xfer;
 	cmd->firmware_status = &cmd->get_data->status;
 	cmd->iter.offset = &cmd->get_data->in_offset;
+	cmd->iter.xfer = &cmd->get_data->in_length;
 	cmd->iter.max_xfer = cfg_size->get_size->max_xfer;
 	cmd->iter.data = cmd->get_data->out_buf;
 	cmd->iter.total_xfer = cfg_size->get_size->config_size;
@@ -2021,6 +2022,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cf
 	cmd->firmware_status = (u32 *) (cmd->cmd_buf
 		+ sizeof(struct nd_cmd_set_config_hdr) + cfg_read->iter.max_xfer);
 	cmd->iter.offset = &cmd->set_data->in_offset;
+	cmd->iter.xfer = &cmd->set_data->in_length;
 	cmd->iter.max_xfer = cfg_read->iter.max_xfer;
 	cmd->iter.data = cmd->set_data->in_buf;
 	cmd->iter.total_xfer = cfg_read->iter.total_xfer;
@@ -2229,19 +2231,21 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 	}
 
 	for (offset = 0; offset < iter->total_xfer; offset += iter->max_xfer) {
+		*(cmd->iter.xfer) = min(iter->total_xfer - offset,
+				iter->max_xfer);
+		*(cmd->iter.offset) = offset;
 		if (iter->dir == WRITE)
 			memcpy(iter->data, iter->total_buf + offset,
-					iter->max_xfer);
-		*(cmd->iter.offset) = offset;
+					*(cmd->iter.xfer));
 		rc = ioctl(fd, ioctl_cmd, cmd->cmd_buf);
 		if (rc < 0)
 			break;
 
 		if (iter->dir == READ)
 			memcpy(iter->total_buf + offset, iter->data,
-					iter->max_xfer - rc);
+					*(cmd->iter.xfer) - rc);
 		if (*(cmd->firmware_status) || rc) {
-			rc = offset + iter->max_xfer - rc;
+			rc = offset + *(cmd->iter.xfer) - rc;
 			break;
 		}
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
