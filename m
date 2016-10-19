Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AABD41A1E8B
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:17 -0700 (PDT)
Subject: [ndctl PATCH 5/8] libndctl: add ndctl_cmd_cfg_read_get_size()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:15 -0700
Message-ID: <147689569519.11015.13966814247817280212.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Allow the size of the configuration label region to be retrieved from
the cfg_read command.  This lets applications pass around a successful
cfg_read command object and not need access to the original cfg_size
command.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |    9 +++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 3 files changed, 11 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 7d870b082cd4..82b11a0d3ac9 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2057,6 +2057,15 @@ NDCTL_EXPORT ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read,
 	return len;
 }
 
+NDCTL_EXPORT ssize_t ndctl_cmd_cfg_read_get_size(struct ndctl_cmd *cfg_read)
+{
+	if (cfg_read->type != ND_CMD_GET_CONFIG_DATA || cfg_read->status > 0)
+		return -EINVAL;
+	if (cfg_read->status < 0)
+		return cfg_read->status;
+	return cfg_read->iter.total_xfer;
+}
+
 NDCTL_EXPORT ssize_t ndctl_cmd_cfg_write_set_data(struct ndctl_cmd *cfg_write,
 		void *buf, unsigned int len, unsigned int offset)
 {
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index dfc44ae51362..6bd032ea7526 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -210,6 +210,7 @@ global:
 	ndctl_btt_is_configured;
 	ndctl_cmd_cfg_size_get_size;
 	ndctl_cmd_cfg_read_get_data;
+	ndctl_cmd_cfg_read_get_size;
 	ndctl_cmd_cfg_write_set_data;
 	ndctl_cmd_cfg_write_zero_data;
 	ndctl_cmd_unref;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 803368bc1acd..d3379f76e1f9 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -356,6 +356,7 @@ unsigned long ndctl_dimm_get_available_labels(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_cfg_size_get_size(struct ndctl_cmd *cfg_size);
 ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read, void *buf,
 		unsigned int len, unsigned int offset);
+ssize_t ndctl_cmd_cfg_read_get_size(struct ndctl_cmd *cfg_read);
 ssize_t ndctl_cmd_cfg_write_set_data(struct ndctl_cmd *cfg_write, void *buf,
 		unsigned int len, unsigned int offset);
 ssize_t ndctl_cmd_cfg_write_zero_data(struct ndctl_cmd *cfg_write);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
