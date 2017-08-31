Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C05B21E95DFE
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:24:11 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 188C4AC00F7
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:25:15 +0900 (JST)
Date: Thu, 31 Aug 2017 10:25:06 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 2/5] make interface to check device/nfit/dsm_mask flags
In-Reply-To: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
References: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170831102503.DA33.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


To check what feature can be called via ND_CMD_CALL, ndctl need to read
device/nfit/dsm_mask. This patch make an interface to check it in libndctl.c


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 ndctl/lib/libndctl.c   | 13 +++++++++++++
 ndctl/lib/libndctl.sym |  1 +
 ndctl/libndctl.h.in    |  1 +
 3 files changed, 15 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c2e0efb..803056d 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -102,6 +102,7 @@ struct ndctl_bus {
 	size_t buf_len;
 	char *wait_probe_path;
 	unsigned long dsm_mask;
+	unsigned long passthru_dsm_mask;
 };
 
 /**
@@ -846,6 +847,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 		bus->revision = strtoul(buf, NULL, 0);
 	}
 
+	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		bus->passthru_dsm_mask = 0;
+	else
+		bus->passthru_dsm_mask = strtoul(buf, NULL, 16);
+
 	sprintf(path, "%s/device/provider", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1101,6 +1108,12 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
 	return !!(bus->dsm_mask & (1ULL << cmd));
 }
 
+NDCTL_EXPORT int ndctl_bus_is_passthru_cmd_supported(struct ndctl_bus *bus,
+		int cmd)
+{
+	return !!(bus->passthru_dsm_mask & (1ULL << cmd));
+}
+
 NDCTL_EXPORT unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus)
 {
 	return bus->revision;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b8ac65f..48b0a2f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -30,6 +30,7 @@ global:
 	ndctl_bus_get_by_provider;
 	ndctl_bus_get_cmd_name;
 	ndctl_bus_is_cmd_supported;
+	ndctl_bus_is_passthru_cmd_supported;
 	ndctl_bus_has_nfit;
 	ndctl_bus_get_revision;
 	ndctl_bus_get_id;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 855d883..49b73a4 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -109,6 +109,7 @@ struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 		const char *provider);
 const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd);
 int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
+int ndctl_bus_is_passthru_cmd_supported(struct ndctl_bus *bus, int cmd);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
