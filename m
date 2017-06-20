Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB20021BBC433
 for <linux-nvdimm@lists.01.org>; Tue, 20 Jun 2017 09:50:31 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 3/7] libnvdimm: Add bus level dsm mask.
Date: Tue, 20 Jun 2017 10:51:22 -0600
Message-Id: <43d0589ef57cf879c65e5c29ea69b6592661d717.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1497939166.git.jerry.hoemann@hpe.com>
References: <cover.1497939166.git.jerry.hoemann@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a bus level dsm_mask to nvdimm_bus_descriptor to allow the passthru
calling mechanism to specify a different mask from the cmd_mask.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/linux/libnvdimm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 6c80701..f8b8f43 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -54,6 +54,7 @@ typedef int (*ndctl_fn)(struct nvdimm_bus_descriptor *nd_desc,
 
 struct nvdimm_bus_descriptor {
 	const struct attribute_group **attr_groups;
+	unsigned long bus_dsm_mask;
 	unsigned long cmd_mask;
 	struct module *module;
 	char *provider_name;
-- 
1.8.5.6

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
