Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v2 1/3] nvdimm: Clean-up access mode check.
Date: Mon, 16 Nov 2015 11:38:17 -0700
Message-Id: <37b74929497e6fefe94793ce9ca788e00d386d8a.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1447698598.git.jerry.hoemann@hpe.com>
References: <cover.1447698598.git.jerry.hoemann@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, lenb@kernel.org, dan.j.williams@intel.com, elliott@hpe.com, jmoyer@redhat.com, krivenok.dmitry@gmail.com, linda.knippers@hpe.com
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Jerry Hoemann <jerry.hoemann@hpe.com>
List-ID: <linux-nvdimm@lists.01.org>

Change nd_ioctl and nvdimm_ioctl access mode check to use O_RDONLY.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 drivers/nvdimm/bus.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 7e2c43f..1c81203 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -602,14 +602,14 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 static long nd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long id = (long) file->private_data;
-	int rc = -ENXIO, read_only;
+	int rc = -ENXIO, ro;
 	struct nvdimm_bus *nvdimm_bus;
 
-	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
 		if (nvdimm_bus->id == id) {
-			rc = __nd_ioctl(nvdimm_bus, NULL, read_only, cmd, arg);
+			rc = __nd_ioctl(nvdimm_bus, NULL, ro, cmd, arg);
 			break;
 		}
 	}
@@ -633,10 +633,10 @@ static int match_dimm(struct device *dev, void *data)
 
 static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	int rc = -ENXIO, read_only;
+	int rc = -ENXIO, ro;
 	struct nvdimm_bus *nvdimm_bus;
 
-	read_only = (O_RDWR != (file->f_flags & O_ACCMODE));
+	ro = ((file->f_flags & O_ACCMODE) == O_RDONLY);
 	mutex_lock(&nvdimm_bus_list_mutex);
 	list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
 		struct device *dev = device_find_child(&nvdimm_bus->dev,
@@ -647,7 +647,7 @@ static long nvdimm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			continue;
 
 		nvdimm = to_nvdimm(dev);
-		rc = __nd_ioctl(nvdimm_bus, nvdimm, read_only, cmd, arg);
+		rc = __nd_ioctl(nvdimm_bus, nvdimm, ro, cmd, arg);
 		put_device(dev);
 		break;
 	}
-- 
1.7.11.3

