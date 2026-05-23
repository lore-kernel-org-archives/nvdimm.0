Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC26438F934
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529468; cv=none; b=DC1UajpghyW8Oyx4j5KgeJ5I+PclCm66mb8fsGmOsISaOEuuURdQH1yMIMqs/WrPAcYYz5ZCOwjTcvID6SO1/wpoOv1TiWPYATwgrPFXzi+nNaQ1d4E4LXDw8WnxEEEVMqB4TGnKDqsxTiqSgXlVEKWwpQq9qHCUzXWnruijAps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529468; c=relaxed/simple;
	bh=3HXDv3onY23MfZ6DmFqJ7fSkS0iWKYaMT2eOTFDeoDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtlmFrNJ7nknIdN/ThjodHs6yIkZcxneOdKjBop4Vq1O/Uz7lOpLuezkaN/v7xAbDC4AWpVnCQbjFz9UFNEpiRE65/9iWbICTx1Y1ZLXNzFsqXjx3HaK1bBeXa8dW9jnURZsxsp0WjCs01fr8bP+wM3o6VT5RG6wzDEyLFNPrqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OEbw8MCb; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OEbw8MCb"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12ddbe104ccso6054312c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529465; x=1780134265; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o82VrbrSunpqYPkFfmmxbOQmk9JmN+rFJu6lm18iL6E=;
        b=OEbw8MCbpqvfju/yZkE4xpK5zfu/tsPwEj2HFjP8hyDtazBgOJ5d0b5R8y2E32+oLx
         EVhV/5rIyt8Q/3M9M0JvQ+GUqspIf/KzxjBY8u3krhrv0aYg30J0Z0WCmhMIQDhYh4fS
         /EER5rIVcobPnmI4Iulg6lCeh0S+VKA3y/aWY7BYM+P9Gq4yKN3WIVVWkS1svxws7kC3
         SG6JHVjuSYlPBBhB6O8u+j+AMOgm5EjO5ewoawepum/FO/tYaRvMuR3/VINT9ATZp5Eb
         bZXiZ8Fz3049o6nmLTOu0nLabxREDjNftOlC3Ve1RvXvfasqGxKWp0hDWRf8Y/x13tYx
         j+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529465; x=1780134265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o82VrbrSunpqYPkFfmmxbOQmk9JmN+rFJu6lm18iL6E=;
        b=CjfW4aP0uSvY/oIfzPSOhGIg8HzJMVsuAmZ/Cjo+l9/yqIASaM5C4vJMuA++d8FhJ+
         KCtSLGeSKCm7oGzyyFA/9albQu4X8JDsegQ4RK62A3fQscIjIcEcSEVh8AOHeytScq/1
         CfMc7kCvMDAMdEsCkk4t7yvjbRRh3Y0XhvrT6cWQ8Iu0DTcQe9P4Dy/SB+AhItYC3bLI
         eqi/uWViUvUn3cQ48Td+4z/pL3DOc4/5BSTkMTnxu6RA7bxskT8V9EswbeQrtg+A0ZOj
         2iYbPE9zfu3peUOPMqY070YjNtNiQmnfHBsMH6YE1ic7xrkcH57P4uiOVuHRdFsgo+hS
         MxAw==
X-Gm-Message-State: AOJu0YzxjHg0MSM7nLIoITZx0tRsZMJB4L+YTuwyPpVJfkLhfbetPLQ/
	sJk5hrsUENv/4mfPpF/TmT4/VaxQw7Tr/WUm759WHm6PH1kt1NxFRFqU
X-Gm-Gg: Acq92OF6vyViQG5B0CyEGO4WDYTWuMUkMvwF1S/FKFlzE8nMSOrWeAD3t9BQXmHfysh
	x7Rowe334vUXS2oeP2ITysuqZHAA0dyCDtvbqwKhWZKepjK2/cEQQFYajG9kOD7tUGAjxG74Fo2
	hC71vmOOmnfSvtpp4+7MQobZCeBLOdjic5Oic6VkJ+VVeYKfmJKjTKjuUM7EoTPmNQzKQ9CuRgq
	bCsIBntl+H2NWJWf4Qh46+d1Rm43F2QSOpi9lslsXnKFYcr/IauBPMk2o+10WSppzxRPncdTwa0
	ETIGCly1T3C507xWkpAkc+9On8yYbexlf9e640IPDSjuuRkax+HAw5kWMYmgSZj6hKW7/LgkL7O
	PQq+I9Q4wM/DHMl6PCBNqjJ4qnGvVMHAQE+LyBGQ6FS45r3nb5JCqsy2HIAIBoma3dOoWPhgWzN
	WD3pZzy5IokzwvZB6zHedzWns8tqz3vsBx83YBdVl/AS4K/loquZ6ABJiyh/RxhpUYK+yjO8Izq
	+RA7mY=
X-Received: by 2002:a05:7022:b042:20b0:136:73ec:922d with SMTP id a92af1059eb24-13673ec94e7mr1323618c88.36.1779529464768;
        Sat, 23 May 2026 02:44:24 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:23 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 25/31] dax/bus: Reject resize on DC dax devices and enforce 0-size creation
Date: Sat, 23 May 2026 02:43:19 -0700
Message-ID: <9c73377182f19e86e2cc939ddf0184d5d85581f9.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A DC dax device's size is determined by the extents that back it, not by
the user.  DCD extents are all-or-nothing, so partial shrink is just as
illegal as growing.  Enforce that on the size and creation paths:

  * size_store: any non-zero resize on a DC region returns -EOPNOTSUPP.
    The sole exception is size=0, which daxctl destroy-device writes to
    return every claimed extent to the region's available pool before
    the device's name is written to the region's 'delete' attribute.
  * __devm_create_dev_dax: a DC dax device must be created at size 0.
    Non-zero data->size on a DC region returns -EINVAL with a clear
    message.

The resize machinery (dev_dax_shrink, adjust_ok, dev_dax_resize_static,
dev_dax_resize) learns to walk the right parent — dax_region->res for
static regions, the dax_resource->res for DC regions claimed via
uuid_store — so shrink-to-0 correctly releases each extent's child
resource rather than the region's.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: split out from the original "Surface dc_extents" commit;
 DC-aware resize policy only.]
---
 drivers/dax/bus.c | 46 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1d6f82920be6..c030eb103ad0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1136,7 +1136,8 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 	int i;
 
 	for (i = dev_dax->nr_range - 1; i >= 0; i--) {
-		struct range *range = &dev_dax->ranges[i].range;
+		struct dev_dax_range *dev_range = &dev_dax->ranges[i];
+		struct range *range = &dev_range->range;
 		struct dax_mapping *mapping = dev_dax->ranges[i].mapping;
 		struct resource *adjust = NULL, *res;
 		resource_size_t shrink;
@@ -1152,6 +1153,10 @@ static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
 			continue;
 		}
 
+		/*
+		 * Partial shrink: forbidden on DC regions, so dev_range
+		 * here must belong to a static device.
+		 */
 		for_each_dax_region_resource(dax_region, res)
 			if (strcmp(res->name, dev_name(dev)) == 0
 					&& res->start == range->start) {
@@ -1195,19 +1200,21 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
 }
 
 /**
- * dev_dax_resize_static - Expand the device into the unused portion of the
- * region. This may involve adjusting the end of an existing resource, or
- * allocating a new resource.
+ * __dev_dax_resize - Expand the device into the unused portion of the region.
+ * This may involve adjusting the end of an existing resource, or allocating a
+ * new resource.
  *
  * @parent: parent resource to allocate this range in
  * @dev_dax: DAX device to be expanded
  * @to_alloc: amount of space to alloc; must be <= space available in @parent
+ * @dax_resource: if dc; the parent resource
  *
  * Return the amount of space allocated or -ERRNO on failure
  */
-static ssize_t dev_dax_resize_static(struct resource *parent,
-				     struct dev_dax *dev_dax,
-				     resource_size_t to_alloc)
+static ssize_t __dev_dax_resize(struct resource *parent,
+				struct dev_dax *dev_dax,
+				resource_size_t to_alloc,
+				struct dax_resource *dax_resource)
 {
 	struct resource *res, *first;
 	int rc;
@@ -1215,7 +1222,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 	first = parent->child;
 	if (!first) {
 		rc = alloc_dev_dax_range(parent, dev_dax,
-					   parent->start, to_alloc, NULL);
+					   parent->start, to_alloc,
+					   dax_resource);
 		if (rc)
 			return rc;
 		return to_alloc;
@@ -1229,7 +1237,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 		if (res == first && res->start > parent->start) {
 			alloc = min(res->start - parent->start, to_alloc);
 			rc = alloc_dev_dax_range(parent, dev_dax,
-						 parent->start, alloc, NULL);
+						 parent->start, alloc,
+						 dax_resource);
 			if (rc)
 				return rc;
 			return alloc;
@@ -1253,7 +1262,8 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 				return rc;
 			return alloc;
 		}
-		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc, NULL);
+		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc,
+					 dax_resource);
 		if (rc)
 			return rc;
 		return alloc;
@@ -1264,6 +1274,13 @@ static ssize_t dev_dax_resize_static(struct resource *parent,
 	return 0;
 }
 
+static ssize_t dev_dax_resize_static(struct dax_region *dax_region,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
+{
+	return __dev_dax_resize(&dax_region->res, dev_dax, to_alloc, NULL);
+}
+
 static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		struct dev_dax *dev_dax, resource_size_t size)
 {
@@ -1277,6 +1294,8 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		return -EBUSY;
 	if (size == dev_size)
 		return 0;
+	if (size != 0 && is_dynamic(dax_region))
+		return -EOPNOTSUPP;
 	if (size > dev_size && size - dev_size > avail)
 		return -ENOSPC;
 	if (size < dev_size)
@@ -1288,7 +1307,7 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 		return -ENXIO;
 
 retry:
-	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
+	alloc = dev_dax_resize_static(dax_region, dev_dax, to_alloc);
 	if (alloc <= 0)
 		return alloc;
 	to_alloc -= alloc;
@@ -1674,6 +1693,11 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	struct device *dev;
 	int rc;
 
+	if (is_dynamic(dax_region) && data->size) {
+		dev_err(parent, "DC DAX region devices must be created initially with 0 size");
+		return ERR_PTR(-EINVAL);
+	}
+
 	dev_dax = kzalloc_obj(*dev_dax);
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
-- 
2.43.0

