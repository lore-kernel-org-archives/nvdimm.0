Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v3 4/6] nvdimm: Fix security issue with DSM IOCTL.
Date: Sun, 13 Dec 2015 18:54:25 -0700
Message-Id: <a438967f7ba34963ecc718a2ae19f93ac1257594.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1450036445.git.jerry.hoemann@hpe.com>
References: <cover.1450036445.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: robert.moore@intel.com, lv.zheng@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Code attempts to prevent certain IOCTL DSM from being called
when device is opened read only.  This security feature can
be trivially overcome by changing the size portion of the
ioctl_command which isn't used.

Check only the _IOC_NR (i.e. the command).

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/bus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 1c81203..87fe545 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -513,10 +513,10 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 
 	/* fail write commands (when read-only) */
 	if (read_only)
-		switch (ioctl_cmd) {
-		case ND_IOCTL_VENDOR:
-		case ND_IOCTL_SET_CONFIG_DATA:
-		case ND_IOCTL_ARS_START:
+		switch (cmd) {
+		case ND_CMD_VENDOR:
+		case ND_CMD_SET_CONFIG_DATA:
+		case ND_CMD_ARS_START:
 			dev_dbg(&nvdimm_bus->dev, "'%s' command while read-only.\n",
 					nvdimm ? nvdimm_cmd_name(cmd)
 					: nvdimm_bus_cmd_name(cmd));
-- 
1.7.11.3

