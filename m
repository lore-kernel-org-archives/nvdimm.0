Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB303D8907
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386895; cv=none; b=fDeX4W8r1nR6UA/vmBQejTjipGI/jbaTiScBFbFMtqphIqYdczaEQHQOwG5S/5HgIOQ1VD4oiY5DOFd0uvM2JEBPNdLjILDJEYhd6bI9S0UDd4OeAAu2E6J4CKA2YB4Pg+iUm8h3aztmAdZrIlYLg4GYvjictJ5StBeNXJXwrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386895; c=relaxed/simple;
	bh=DXvkissHn/+KuthdE3sUGuF5LPzedT+vKlIYwzDV4Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgPQCLg5G5Cs/UtGGL0scVXbGhnjFezXlwL7CkmRF0kGH/o94YkLoHtClD0H24nVr1gIer8S46mpnazsu/nnphEGakSQDUXCiTRhh+NDA2CDj+9zolGqefKu+hKPs5KbOELJu7ENcLQm/IVbREt58UYsXGa0DuvB2CLe7+AKNww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HiCrvnlm; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HiCrvnlm"
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-30b6dad2382so3819643eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386892; x=1782991692; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvxC/dokCYNYQ3OhGrfeL1A+tMPegXdAVL8H95aEecc=;
        b=HiCrvnlmlcWoOHedpvv/NiVoOKWbYeZtriTpPUeM/M0U4OnkmaO8KgWKZje5hi0OsN
         //SZ3enLa/UyrF5xDGSu9lFRgtHOh2OiwnxUSz70Zj4MGNkf9GmyzMhuQBZFsa0TIIOx
         xxHx1pygcwqs3TrqYl6CDitMFMOGfgCKkVLrofj0brdY9C5w8AwFJUbIH2hsf1Kq7p7t
         5QX62ZuIk+tsbxQIGN5mqxqYcdosEQwvMB785jrVcuXBIcCe3lj1ny4gC9rTAci3grpi
         sM4e/aKiR9EIxu1L5jLe6xMeeLerMyjjGg+WfnZIoE5VaHu5KWxX0/Dj4IDZ2BmBYFjv
         MwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386892; x=1782991692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BvxC/dokCYNYQ3OhGrfeL1A+tMPegXdAVL8H95aEecc=;
        b=dn6ViupgAUZnRD9Lk9u3H1/1fMW2EQmbvL8NjYS7RSuq0Mnt2PLSFgEXQs33roxmpx
         Kz6etcIuyrWO+IFzrwUWslE65LqdN2ae6UADUhPhPvNWcsxKASBtvGGllqcrPnjYyj8x
         xrxkGmryuJ9RopInD+95/T8Kq3MoMg958vSvo3LLFgoQpKvp1DrvAAQ089GJSJpREnir
         5ipPvUGTsV6OjrCU4CxGHJ2O8xCbeCj0IcgiNgIEY02w5aMnfG1VDwK8t0uCOsIIDKG9
         lSbMcMqR9L9VrTDokUqj0BTv8J16d0Cdaqysq+uqEudqEZkl2rYrkGIJ7ybMxMKzGHcl
         36tg==
X-Gm-Message-State: AOJu0YxsftQUnLtp19o5aQa8vCMgUHv6e7aQOZv8WRpNH0+iPTNq+VkJ
	CNlGQ2bF+b7n7WH3PTwvmiLnZ5hpvieTsDiSismzEmfYpMS5g/99os5X
X-Gm-Gg: AfdE7cldYekz2SDFyJ5oLhHgfAaK130/C4x1oVSL106lS8hqvN4fAhBFaQwyBfI5iDH
	k6Fwu8DfNEq8/w/YfEfEcZks2gOZEQdQHpOrkX+TdkmJEaTDo5TERjHCc4nvxv4xHi6XMhyafK9
	BBUus0uFrmYqvt6gpcAMCOKwBwyxjt/2ihqSDJuXYl3eaCxsyj7h+o8QKrZCY27FU/ON3bRe1OA
	KzDOzyWp/UYPNRd9dti9rjaAtb03KoCIwkSd/gkY1aQSVQ94OU6yML9LQiZ3YWHgv6L/KqicdAh
	KRECp62MKlSCJZr8MQKRAKvRZgvnflSDshQoBvFTKcvI7ZeVm/GdnSkrlMdQwrM9oyKHXHzXH5i
	W7O2cH19IJSjj4C8MYd85yzCOmK5/8sV8AxL5KpRk1Wx62YzGQdfAzcam36DXC43cG8FtgnYObh
	bqaJppfhX1KpjDxjLv2f6SlzALq/d1Ll8Ou5NIowS/gSmraqjIKJn7Zyp2ZKF/srwZD3OP
X-Received: by 2002:a05:7300:f108:b0:30c:5807:abbb with SMTP id 5a478bee46e88-30c84cb1ab9mr2140180eec.20.1782386892087;
        Thu, 25 Jun 2026 04:28:12 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:11 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 05/31] cxl/mem: Expose dynamic ram 1 partition in sysfs
Date: Thu, 25 Jun 2026 04:04:42 -0700
Message-ID: <20260625112638.550691-6-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

To properly configure CXL regions user space will need to know the
details of the dynamic ram partition.

Expose the first dynamic ram partition through sysfs.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

---
Changes:
1. Documentation: bump kernel version to 7.3 and date to June 2026
2. Pick up Dave's reviewed-by tag
3. Rename dynamic_ram_a to dynamic_ram_1
---
 Documentation/ABI/testing/sysfs-bus-cxl | 24 +++++++++++
 drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 16a9b3d2e2c0..435495de409c 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -89,6 +89,30 @@ Description:
 		and there are platform specific performance related
 		side-effects that may result. First class-id is displayed.
 
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/size
+Date:		June, 2026
+KernelVersion:	v7.3
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RO) The first Dynamic RAM partition capacity as bytes.
+
+
+What:		/sys/bus/cxl/devices/memX/dynamic_ram_1/qos_class
+Date:		June, 2026
+KernelVersion:	v7.3
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
index 71602820f896..20417db933aa 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -101,6 +101,19 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 static struct device_attribute dev_attr_pmem_size =
 	__ATTR(size, 0444, pmem_size_show, NULL);
 
+static ssize_t dynamic_ram_1_size_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
+
+	return sysfs_emit(buf, "%#llx\n", len);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_1_size =
+	__ATTR(size, 0444, dynamic_ram_1_size_show, NULL);
+
 static ssize_t serial_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -443,6 +456,25 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
 	NULL,
 };
 
+static ssize_t dynamic_ram_1_qos_class_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+
+	return sysfs_emit(buf, "%d\n",
+			  part_perf(cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)->qos_class);
+}
+
+static struct device_attribute dev_attr_dynamic_ram_1_qos_class =
+	__ATTR(qos_class, 0444, dynamic_ram_1_qos_class_show, NULL);
+
+static struct attribute *cxl_memdev_dynamic_ram_1_attributes[] = {
+	&dev_attr_dynamic_ram_1_size.attr,
+	&dev_attr_dynamic_ram_1_qos_class.attr,
+	NULL,
+};
+
 static ssize_t ram_qos_class_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
@@ -519,6 +551,29 @@ static struct attribute_group cxl_memdev_pmem_attribute_group = {
 	.is_visible = cxl_pmem_visible,
 };
 
+static umode_t cxl_dynamic_ram_1_visible(struct kobject *kobj, struct attribute *a, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1);
+
+	if (a == &dev_attr_dynamic_ram_1_qos_class.attr &&
+	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
+		return 0;
+
+	if (a == &dev_attr_dynamic_ram_1_size.attr &&
+	    (!cxl_part_size(cxlmd->cxlds, CXL_PARTMODE_DYNAMIC_RAM_1)))
+		return 0;
+
+	return a->mode;
+}
+
+static struct attribute_group cxl_memdev_dynamic_ram_1_attribute_group = {
+	.name = "dynamic_ram_1",
+	.attrs = cxl_memdev_dynamic_ram_1_attributes,
+	.is_visible = cxl_dynamic_ram_1_visible,
+};
+
 static umode_t cxl_memdev_security_visible(struct kobject *kobj,
 					   struct attribute *a, int n)
 {
@@ -547,6 +602,7 @@ static const struct attribute_group *cxl_memdev_attribute_groups[] = {
 	&cxl_memdev_attribute_group,
 	&cxl_memdev_ram_attribute_group,
 	&cxl_memdev_pmem_attribute_group,
+	&cxl_memdev_dynamic_ram_1_attribute_group,
 	&cxl_memdev_security_attribute_group,
 	NULL,
 };
@@ -555,6 +611,7 @@ void cxl_memdev_update_perf(struct cxl_memdev *cxlmd)
 {
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_ram_attribute_group);
 	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_pmem_attribute_group);
+	sysfs_update_group(&cxlmd->dev.kobj, &cxl_memdev_dynamic_ram_1_attribute_group);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_memdev_update_perf, "CXL");
 
-- 
2.43.0

