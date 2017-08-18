Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB94E21E7903C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:31:29 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A3EC0AC00CD
 for <linux-nvdimm@lists.01.org>;
 Fri, 18 Aug 2017 13:33:53 +0900 (JST)
Date: Fri, 18 Aug 2017 13:33:49 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 1/4] make interface to check device/nfit/dsm_mask flags
In-Reply-To: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
References: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
Message-Id: <20170818133348.8EAE.E1E9C6FF@jp.fujitsu.com>
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
 ndctl/lib/libndctl.c | 13 +++++++++++++
 ndctl/libndctl.h.in  |  1 +
 2 files changed, 14 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c2e0efb..93692e5 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -102,6 +102,7 @@ struct ndctl_bus {
 	size_t buf_len;
 	char *wait_probe_path;
 	unsigned long dsm_mask;
+	unsigned long bus_dsm_mask;
 };
 
 /**
@@ -846,6 +847,12 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 		bus->revision = strtoul(buf, NULL, 0);
 	}
 
+	sprintf(path, "%s/device/nfit/dsm_mask", ctl_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		bus->bus_dsm_mask = 0;
+	else
+		bus->bus_dsm_mask = strtoul(buf, NULL, 16);
+
 	sprintf(path, "%s/device/provider", ctl_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1101,6 +1108,12 @@ NDCTL_EXPORT int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus,
 	return !!(bus->dsm_mask & (1ULL << cmd));
 }
 
+NDCTL_EXPORT int ndctl_bus_is_sub_cmd_supported(struct ndctl_bus *bus,
+		int cmd)
+{
+	return !!(bus->bus_dsm_mask & (1ULL << cmd));
+}
+
 NDCTL_EXPORT unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus)
 {
 	return bus->revision;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 855d883..206c441 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -109,6 +109,7 @@ struct ndctl_bus *ndctl_bus_get_by_provider(struct ndctl_ctx *ctx,
 		const char *provider);
 const char *ndctl_bus_get_cmd_name(struct ndctl_bus *bus, int cmd);
 int ndctl_bus_is_cmd_supported(struct ndctl_bus *bus, int cmd);
+int ndctl_bus_is_sub_cmd_supported(struct ndctl_bus *bus, int cmd);
 unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
