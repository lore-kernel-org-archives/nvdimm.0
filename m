Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C446F2E8;
	Mon, 10 Jun 2024 08:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718007589; cv=none; b=dLRwudk8nnxtTqT5E+rLBLzqk969cUf/UHr0Qfc9VE6L/lFB4OsN8vfxxY7uBAKbyCwxbDlS31Rl4LE4oipuKbDPGpoBqI9aj+MZ0kVFq9KouHUXOCiAAogS//0A4u5F1a/zV+MCe/oEkhHgRSHyJfQIns8dYzAUCnkRJu7YTIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718007589; c=relaxed/simple;
	bh=4bnhfABeL9wMNaLRFs7jfMOSG8cNLfTLCbFckvsvrM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xeof4Z+2eCz1kVdn6tAYsi71irZM2+cMwOda2PmunLrbduVdH45K1sla8EVq6SYYCCNoWGs3Y4RXfcmgV0qj0rJH7UoqKFqq6e1IH5cXa+2y0gteKGOnHOhl+EVfxwVYwlugnegJ1HROnFJ1BpuaP0ouZ3LQbUbW16+ADFiC+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ1p7ErO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ1p7ErO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631C2C4AF1C;
	Mon, 10 Jun 2024 08:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718007588;
	bh=4bnhfABeL9wMNaLRFs7jfMOSG8cNLfTLCbFckvsvrM0=;
	h=From:To:Cc:Subject:Date:From;
	b=WQ1p7ErOzdBl73QtueAUgSo46u2ijPYial0jcb6VgRtkEISzyHUenvwC7eyqnhLEO
	 LCLuFqra1fXV4tzOspxnuo6YMmUZVQnNonjEx3EqAHgPHmZvT6R0iXlxnLAfsp7UJR
	 bwxnOwzVfoUMCv85ky7xeXGVMIQ7QYTiA98P8wSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] nvdimm: make nd_class constant
Date: Mon, 10 Jun 2024 10:19:42 +0200
Message-ID: <2024061041-grandkid-coherence-19b0@gregkh>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2634; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=4bnhfABeL9wMNaLRFs7jfMOSG8cNLfTLCbFckvsvrM0=; b=owGbwMvMwCRo6H6F97bub03G02pJDGlp2+XWaj/ozZMQO/pcs9CCa/38o18cnyXXKCol/Vd6d X51jU9iRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEzkVx3DgtaXW6/9E/5d2Lbj bzgfr0mncfHCBoZ5OnNs7oYrnXqUdV3y/7nw2THMfHUHAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

Now that the driver core allows for struct class to be in read-only
memory, we should make all 'class' structures declared at build time
placing them into read-only memory, instead of having to be dynamically
allocated at runtime.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: nvdimm@lists.linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/bus.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 508aed017ddc..101c425f3e8b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -25,9 +25,12 @@
 
 int nvdimm_major;
 static int nvdimm_bus_major;
-static struct class *nd_class;
 static DEFINE_IDA(nd_ida);
 
+static const struct class nd_class = {
+	.name = "nd",
+};
+
 static int to_nd_device_type(const struct device *dev)
 {
 	if (is_nvdimm(dev))
@@ -742,7 +745,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &nvdimm_ndctl_key);
 	device_set_pm_not_required(dev);
-	dev->class = nd_class;
+	dev->class = &nd_class;
 	dev->parent = &nvdimm_bus->dev;
 	dev->devt = devt;
 	dev->release = ndctl_release;
@@ -765,7 +768,7 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
 {
-	device_destroy(nd_class, MKDEV(nvdimm_bus_major, nvdimm_bus->id));
+	device_destroy(&nd_class, MKDEV(nvdimm_bus_major, nvdimm_bus->id));
 }
 
 static const struct nd_cmd_desc __nd_cmd_dimm_descs[] = {
@@ -1320,11 +1323,9 @@ int __init nvdimm_bus_init(void)
 		goto err_dimm_chrdev;
 	nvdimm_major = rc;
 
-	nd_class = class_create("nd");
-	if (IS_ERR(nd_class)) {
-		rc = PTR_ERR(nd_class);
+	rc = class_register(&nd_class);
+	if (rc)
 		goto err_class;
-	}
 
 	rc = driver_register(&nd_bus_driver.drv);
 	if (rc)
@@ -1333,7 +1334,7 @@ int __init nvdimm_bus_init(void)
 	return 0;
 
  err_nd_bus:
-	class_destroy(nd_class);
+	class_unregister(&nd_class);
  err_class:
 	unregister_chrdev(nvdimm_major, "dimmctl");
  err_dimm_chrdev:
@@ -1347,7 +1348,7 @@ int __init nvdimm_bus_init(void)
 void nvdimm_bus_exit(void)
 {
 	driver_unregister(&nd_bus_driver.drv);
-	class_destroy(nd_class);
+	class_unregister(&nd_class);
 	unregister_chrdev(nvdimm_bus_major, "ndctl");
 	unregister_chrdev(nvdimm_major, "dimmctl");
 	bus_unregister(&nvdimm_bus_type);
-- 
2.45.2

