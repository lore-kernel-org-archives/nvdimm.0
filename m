Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH 2/4] nvdimm: Add IOCTL pass thru
Date: Fri,  6 Nov 2015 15:27:29 -0700
Message-Id: <4f81a8b6fa24723c808c72888290e2368fcdbca0.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1446684001.git.jerry.hoemann@hpe.com>
References: <cover.1446684001.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Add internal data structure for ndctl_passthru call.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/linux/libnvdimm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 3f021dc..01117e1 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -72,6 +72,7 @@ struct nvdimm_bus_descriptor {
 	unsigned long dsm_mask;
 	char *provider_name;
 	ndctl_fn ndctl;
+	ndctl_fn ndctl_passthru;
 };
 
 struct nd_cmd_desc {
-- 
1.7.11.3

