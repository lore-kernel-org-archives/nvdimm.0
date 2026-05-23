Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A538C2A5
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529458; cv=none; b=VbhJCe2DUA+PAVkqM+sZ9qzlqgw7WYxcnB6aR35xm2Yeo9q3JBRf+9PgdFlRtP7ZRb33OvV/mED3DuU3sgisMOvSceDsagjJx4tilYoIhcDvYBNSegWjm1p0insX9JrcbuYoovoeWXGvER0+EN5OPh7eo6E4r6xyQ+rQT+tWZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529458; c=relaxed/simple;
	bh=8ZZdtYpNGTgL3MTMyM19kxOHIuOMKMfxKPRjn4eIfvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFNu00nnn8ABgwP3Ng2Cm7Vzk/fA2krppVnYkQo7FyaY+WrUnzB54XlTcEUT9XWSbhAzPD4BXYFOD55tKKVpEFtsXn3qSDH1vysUcsP5ZhT+Ubpx3HGJmQK6VgFZtvoXaBgMRzCT1oszq8FecnFuEpH0Nc/Qzfgq5gdLWyKjbao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCcfcKo0; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCcfcKo0"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1334825de43so7175084c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529456; x=1780134256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dZtq66UJzhpDDIp080UOgE5HZPWgaTtRKq2769BN13g=;
        b=jCcfcKo0C4KUszh1bp+dI70L6U3qjCbEZjB2fAVFSCm8TruRKSI8FMR/GE83o1OGeE
         0C/zDJ7KBbx7zXV1ZNydtANYf3VOOYufo+UKi6xwELAD66s4CAtgb21awhz9L2WTjD52
         GHbv8+lUrlHUQ/YXRdKBqxIP4J60nkMc2cvYPMxRh54zNYrBzBxHshlrtzCLMfVLb7uu
         0Ht9+dyiiXYIY5J5/zGWb0wRoZuhiRaGQCVemvIAgtqVJ529mrrSLVXODZQmLdb7rvTw
         CCDkgWM2Xz7C9vu7zzQikIZGAOP6GabvJbRrqdL9xfOWdQ1nwsM96UEj3CxfWIorM4W6
         h7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529456; x=1780134256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dZtq66UJzhpDDIp080UOgE5HZPWgaTtRKq2769BN13g=;
        b=iMKUS+kGKpy9RnfWTrzHCVFPy9CAZhfjYxcW1OPoRoYzGtTqhbKNVDrJwpMc6A+u4+
         gAtvA6PkwiauJL+/ThvGSNVqRSBg9Xh0e77cUmE+HRNGBHOQ1sYyLkNyS96wbyGPINNt
         T3hitsGs17Cjm1SsPaPEqR5jPcGBQ3LwyLPvbUpz0k8VCwyzJuB37S1macMu0NOolW0q
         Fu6GKLAs07imijglvHHQoAMk6F9NNLNNrZ9KYj90NWMTttJbyszHOZGlPP5Eq6KtQdm/
         B8kbqnW8a7dnL+ifqtD+4FR49obpT0gPhPdkWJJNV3BKuktIqxRd9VMPHH+NOBtIvVYa
         bShg==
X-Gm-Message-State: AOJu0Yy0HxL6spuUk5QnIJ1gVDe8TM0FbaOW1S+yHlStvMkeioL4VzR/
	F9/pRYscn8YZKv6xCjfeuv0c+10i46VCN2HSJyFqu6tjsa8GwHvk2LDz
X-Gm-Gg: Acq92OF8Cvm4fuHiK8IoDOgRixfFog0iBHN5LIYSIBoQKCt+lrOWCMaHHkkyQHsXUAj
	4ffzP5eYvQ1RmjmgRQsWbtvCPgxNtO6KqE6tg4Kpxweanv6ANaISBpi/m5liIyMx/MK1m3cYa9r
	Kd39Lc6qZgPlYB+wvHF73nr4Le31zfcEyZPUNQxwJw3DTr6qIab2WeRcmUMCFcC7i3tMiyi6M9G
	srMCE4NzN5KmG7vWsJo2GSQtj2bwM97iBQmYnZhxUo0ygenfeJfssrP/uPchzd95G6YW7u8/Pys
	6t0TmF/jHhJYU3ay27F8eQOGOVYFbWjczLNNkawel8TRvL3iZMmO0aGMVgHPTbaevAgdS7bipOD
	+FNCjVM0805o0FOxid2ibocD71y/HjIPZ0KVDldhgZNB/IFTzz/VbWurMT4WQGaFWgnh3W1f4w8
	zAIUZMMtvR3kL5DPq4IL09nQjRUyr/QHvj3NGT0hAvY5d5zK/vahgfZf3e5YBfY4Jv4Vl8OVECb
	HICx1ncAcFy8GnhTmAdNnNtvAVl
X-Received: by 2002:a05:7022:983:b0:130:7246:10aa with SMTP id a92af1059eb24-1365f703a38mr2595686c88.12.1779529455648;
        Sat, 23 May 2026 02:44:15 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:15 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [PATCH v10 20/31] cxl/region/extent: Expose dc_extent information in sysfs
Date: Sat, 23 May 2026 02:43:14 -0700
Message-ID: <52f5a9ba175424c0f0a181e32ed6c04f26993d96.1779528761.git.anisa.su@samsung.com>
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

From: Ira Weiny <ira.weiny@intel.com>

Extent information can be helpful to the user to coordinate memory
usage with the external orchestrator and FM.

Expose the details of each dc_extent by creating the following sysfs
entries.

	/sys/bus/cxl/devices/dax_regionX/extentX.Y
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
	/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid

Each dc_extent surfaces as its own extentX.Y device under the parent
dax_region.  offset and length describe that dc_extent's HPA range,
not an aggregate bounding box across the containing tagged
allocation — so when a tagged allocation has multiple
DPA-discontiguous extents, each is reported with its own offset and
length.  uuid is the tag identifying the containing allocation; it
is shared across dc_extents that belong to the same tagged
allocation and is hidden for untagged extents.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Tested-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 36 +++++++++++++++
 drivers/cxl/core/extent.c               | 58 +++++++++++++++++++++++++
 2 files changed, 94 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 3080aef9ad67..38cf0a2894b9 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -661,3 +661,39 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/offset
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent offset
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/length
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  Extent length
+		within the region.
+
+
+What:		/sys/bus/cxl/devices/dax_regionX/extentX.Y/uuid
+Date:		May, 2025
+KernelVersion:	v6.16
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) [For Dynamic Capacity regions only] Users can use the
+		extent information to create DAX devices on specific extents.
+		This is done by creating and destroying DAX devices in specific
+		sequences and looking at the mappings created.  UUID of this
+		extent.
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index f66fa8c600c5..34babfe032d1 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -6,6 +6,63 @@
 
 #include "core.h"
 
+static ssize_t offset_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	return sysfs_emit(buf, "%#llx\n", dc_extent->hpa_range.start);
+}
+static DEVICE_ATTR_RO(offset);
+
+static ssize_t length_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+	u64 length = range_len(&dc_extent->hpa_range);
+
+	return sysfs_emit(buf, "%#llx\n", length);
+}
+static DEVICE_ATTR_RO(length);
+
+static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	return sysfs_emit(buf, "%pUb\n", &dc_extent->group->uuid);
+}
+static DEVICE_ATTR_RO(uuid);
+
+static struct attribute *dc_extent_attrs[] = {
+	&dev_attr_offset.attr,
+	&dev_attr_length.attr,
+	&dev_attr_uuid.attr,
+	NULL
+};
+
+static uuid_t empty_uuid = { 0 };
+
+static umode_t dc_extent_visible(struct kobject *kobj,
+				 struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct dc_extent *dc_extent = to_dc_extent(dev);
+
+	if (a == &dev_attr_uuid.attr &&
+	    uuid_equal(&dc_extent->group->uuid, &empty_uuid))
+		return 0;
+
+	return a->mode;
+}
+
+static const struct attribute_group dc_extent_attribute_group = {
+	.attrs = dc_extent_attrs,
+	.is_visible = dc_extent_visible,
+};
+
+__ATTRIBUTE_GROUPS(dc_extent_attribute);
+
 
 static void cxled_release_extent(struct cxl_endpoint_decoder *cxled,
 				 struct dc_extent *dc_extent)
@@ -93,6 +150,7 @@ static void dc_extent_release(struct device *dev)
 static const struct device_type dc_extent_type = {
 	.name = "extent",
 	.release = dc_extent_release,
+	.groups = dc_extent_attribute_groups,
 };
 
 bool is_dc_extent(struct device *dev)
-- 
2.43.0

