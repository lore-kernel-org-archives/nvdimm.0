Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BE7386C15
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529428; cv=none; b=A+qB0jfotnyKsSCMQUgC7HhMXYVkDLlZbKwH44famRlWxGEefjWEtKnC1OkKRmyhzQQTtnAVWHgzAlk9RLd7GlMhMPfNbRBf06E8KLDrVgIPd4+9uBKDxXRSvHn7iYaTPFOVGv23cm/bZoHNQM3s7qZnmCm5YGXvzJTzVRWmvnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529428; c=relaxed/simple;
	bh=lUv0SjAAaw3E/kgV1KeDK72Wh6iLEtGftRf81Pn66SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4vDYR+VxUFM9YKP+BpYfe/pi6pJWwOtCl72yfSXh9wedaT3zIVLq/y++uTrcByKBLC6DghgDBkaPH9l6qF+uUAn6F1BooASnm2OTnYGt6ucRf2fzstN0KVTtwufvr51eVM7w5+l8Y/7hklOebP8Nqn84FAbgwpmB5Ny1dCCBtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyhPvpjj; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyhPvpjj"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1329fc4bf77so2963471c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529426; x=1780134226; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6Dz9TYOBwWg06fFUo8qqEZEgSQ6r/8vuvT8PbFJpKY=;
        b=CyhPvpjjHB4adSfgMOmnZr/FCekUHSQ0vOhxNqXDSwbayVRKdRH9+UE2fxEZPGmbNX
         YoBSGucWlKp39K7x6nz5NkdNTtalY3IoJsi8J7sFWhtXUQ5y5Gk3U2yHVmX1kvi625tn
         CgDgqG/TmO+LVseBg9vMyD7GkRjlIw8C1s68Zo7cDMCm5prvKqLxGq/RHe4VMZboVxlC
         QkBqeVoodSSHFzOegoxYHvXBJzsVM6o36OOhE7igY7n05hv6Sg0QD+DUOfLdDiJIhIGc
         RIFmzsWYrAi3LnRWoQEcLuP4YlFC9rKxP945qdZmgs/LzkQv7895MZnZBaE91uqLWwQx
         Ex6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529426; x=1780134226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w6Dz9TYOBwWg06fFUo8qqEZEgSQ6r/8vuvT8PbFJpKY=;
        b=HZ5P+hsvqwbL9NstXAd0r3N4z6eRVK+RA0kIQjDG/UgU7IkN3H3hq79LTRY15hDtYo
         kafapLoAQgM0Rz+m4KDZ9ZjZ1sw64cwgOv1vrTEyCigmKSBACGncq/aA2Jsvx62cr9Sf
         kY9g765PZDpnLrp1PVhW4ZoWTSW9p1pdYDSf0b9z0TX67K0EFjSsv0MXPN3DGukz08K1
         5zwC21Rruxg/jmNmbFhp5b997rXxpRGgRHd0x7HlLkZVCz6yCyvzvCWexgSfeiEt5rig
         sY5p3Sm4HDPcL9fZEMCTEL4j3Hn7Q7YxCVBjkzdEQAflZrZ7agJ3I2HppcQ8y9VaPWb9
         XrRg==
X-Gm-Message-State: AOJu0YytP12WQwRFWOGLO4tlq2/S9zS8jQbrPY0DB3nqxyFpuBpeDLBo
	KzIIX3dn115NcNHZQNMnIy/bdbzWlse84Y4dx3GzDZ0IcpWdUhHgVB6V
X-Gm-Gg: Acq92OFuHvQ+yCPEYceqH8xAaYq7tDBVqZAI8WZHXS4nVulruZw2OTMtaISySMSVqIf
	rBxxLUDGqii5yhPimjvM24qpFuELSrDpoeULzwCbGTFmhPz2DM1JA73pvcLSeTycfqOb4ok8SIm
	xJvIu/3X/AeKlPxLiFPpLi4ME6QeBhki4xTg8n2phbpLYEYbvRgU1I2jqnNhIRL9xvzlOF7kZ4A
	CaaOc0CxY/moJMfNymmjA4NFQn8U5oj7D5VQEpaHSBh7Nj9bSnxPkZcvJ4FZ+cUyNlITwvOAPmv
	D2ZuFJJBDQDw26dHZemln4T4yYWZ534c+t5WKKzRSoh1JFv8IONSHltk6MHp9lX8ceUilZyAfdj
	LHQB/cpRcfyUcofluxmMyPmC4g0IsdGPF8/cqbYv64RkmaVHdjNyrqmMX3/VyKs/jpNaJoJGYlw
	cLgMRBpbRVm5/4EwKDCHcwrYywt3DkzJNRIFs3QgELszndKcEhj7OVqTr2gHaBHCOIVsJN1Tv4I
	AIUXEI=
X-Received: by 2002:a05:7022:258a:b0:12d:de3e:cc02 with SMTP id a92af1059eb24-1365fd80b13mr2830332c88.41.1779529425905;
        Sat, 23 May 2026 02:43:45 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:45 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 05/31] cxl/mem: Expose dynamic ram A partition in sysfs
Date: Sat, 23 May 2026 02:42:59 -0700
Message-ID: <45bc277b11c1aabf495132925c0d75c78e3b5a8a.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

To properly configure CXL regions user space will need to know the
details of the dynamic ram partition.

Expose the first dynamic ram partition through sysfs.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: Update kernel version to 7.0]
[davidlohr: Remove "persistent" from description of
/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
 drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 16a9b3d2e2c0..3d95c325f6e0 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -89,6 +89,30 @@ Description:
 		and there are platform specific performance related
 		side-effects that may result. First class-id is displayed.
 
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/size
+Date:		May, 2025
+KernelVersion:	v7.0
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) The first Dynamic RAM partition capacity as bytes.
+
+
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class
+Date:		May, 2025
+KernelVersion:	v7.0
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) For CXL host platforms that support "QoS Telemmetry"
+		this attribute conveys a comma delimited list of platform
+		specific cookies that identifies a QoS performance class
+		for the partition of the CXL mem device. These
+		class-ids can be compared against a similar "qos_class"
+		published for a root decoder. While it is not required
+		that the endpoints map their local memory-class to a
+		matching platform class, mismatches are not recommended
+		and there are platform specific performance related
+		side-effects that may result. First class-id is displayed.
+
 
 What:		/sys/bus/cxl/devices/memX/serial
 Date:		January, 2022
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 71602820f896..064cfd628577 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 static struct device_attribute dev_attr_pmem_size =
 	__ATTR(size, 0444, pmem_size_show, NULL);
 
+static ssize_t dynamic_ram_a_size_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
+
+	return sysfs_emit(buf, "%#llx\n", len);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_a_size =
+	__ATTR(size, 0444, dynamic_ram_a_size_show, NULL);
+
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
 	NULL,
 };
 
+static ssize_t dynamic_ram_a_qos_class_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return sysfs_emit(buf, "%d\n",
+			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)->qos_class);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_a_qos_class =
+	__ATTR(qos_class, 0444, dynamic_ram_a_qos_class_show, NULL);
+
+static struct attribute *cxl_memdev_dynamic_ram_a_attributes[] = {
+	&dev_attr_dynamic_ram_a_size.attr,
+	&dev_attr_dynamic_ram_a_qos_class.attr,
+	NULL,
+};
+
 static ssize_t ram_qos_class_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
 	.is_visible = cxl_pmem_visible,
 };
 
+static umode_t cxl_dynamic_ram_a_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A);
+
+	if (a == &dev_attr_dynamic_ram_a_qos_class.attr &&
+	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
+		return 0;
+
+	if (a == &dev_attr_dynamic_ram_a_size.attr &&
+	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_A)))
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group cxl_memdev_dynamic_ram_a_attribute_group = {
+	.name = "dynamic_ram_a",
+	.attrs = cxl_memdev_dynamic_ram_a_attributes,
+	.is_visible = cxl_dynamic_ram_a_visible,
+};
+
 static umode_t cxl_memdev_security_visible(struct kobject *kobj,
 					   struct attribute *a, int n)
 {
@@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
 	&cxl_memdev_attribute_group,
 	&cxl_memdev_ram_attribute_group,
 	&cxl_memdev_pmem_attribute_group,
+	&cxl_memdev_dynamic_ram_a_attribute_group,
 	&cxl_memdev_security_attribute_group,
 	NULL,
 };
@@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
 {
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
+	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_a_attribute_group);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
 
-- 
2.43.0

