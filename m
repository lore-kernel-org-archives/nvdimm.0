Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B167C
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 09:26:51 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id w13so5062203plp.1
        for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 02:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=yO3ZnWbPpoGbIq8B/Q7ETdn558npB4Kk+L1NAs1JDak=;
        b=GBgTsPuo5X2S9CvY1m+P4QF8vY/0rJz4wG5xlN5JMlHJVnDp2q/1jGyw5eA1pGH9rx
         sk37E3LbXX47817Cm6Ok0xRL/1G9oJmf7Y7Ts74S8ZglLGuPqs9zPSlPqTS5hCRaMJYM
         uNpFzeWZa+P3HdkQQG/weZPEIvaeizuPB0qzkREbz7JDNej6UvazM77eaPa8WD2mfqvF
         ueELfznhgSD5Pnnj0sDaexnTXIMk2goMbuynlCeN9+JCsFtAHaV3uUWXWZGrmYKwPVI/
         M+sNwnsHrzSHhuscF3X02vIVobHCuIj2ETBklvUXNmapYSlMYXTZ4EDB7I4VfbklHw5Q
         VSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=yO3ZnWbPpoGbIq8B/Q7ETdn558npB4Kk+L1NAs1JDak=;
        b=VBBqBqAG5EkTuUJ0XFtLFMFSMsK0ryXDf4/9nUu+ihYYsPB2PPdCAG7Vn026ltJaVB
         oG3UDMPyuWa6wJnX58JT1bpa789s/L30PRGHbXi+V1o5kWalnnDOyJ69SJ88EJkQSojV
         nuYbJ/CHp/rhT/okVSFr0SNnT3nnJ8W9VvCkfjQwie+dAPitjVYLcTNBwHXM6h3vShkh
         SzNX7w69UGFFiJKI81w4JvpiBCyBCykAxw7xJ4RUJYkMlFDKUeD3Rk3xTT4tiZ+A/dR4
         pzawCIqhDaztCx8T1jNlIVmBB5g+MsJPlXCJgzChfF2XzwU+15jwric39uNIzx1Quu/5
         iK7Q==
X-Gm-Message-State: ACrzQf00JDxp/fE6c51U6SPCjJoc1RBtbUlEEdR9xh7Rdx40+m0xN6co
	eLUPTIpuoOm0Oqp8NA2V/p0=
X-Google-Smtp-Source: AMsMyM72wBUENYWp/yF3lbC/CF5HAYIeVMDyS0AiG5oRtzrCFV76fJFwc9Ipd2LV2/UYHL0JHNW73A==
X-Received: by 2002:a17:90a:8906:b0:202:d763:72ab with SMTP id u6-20020a17090a890600b00202d76372abmr8409589pjn.56.1663752411397;
        Wed, 21 Sep 2022 02:26:51 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id p63-20020a625b42000000b005367c28fd32sm1602452pfb.185.2022.09.21.02.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 02:26:50 -0700 (PDT)
From: cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zeal Robot <zealci@zte.com.cn>,
	ye xingchen <ye.xingchen@zte.com.cn>
Subject: 
Date: Wed, 21 Sep 2022 09:26:46 +0000
Message-Id: <20220921092646.230274-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

m 1561c1c9285eaa8638406280b53bb9e0b5a67d93 Mon Sep 17 00:00:00 2001
From: ye xingchen <ye.xingchen@zte.com.cn>
Date: Wed, 21 Sep 2022 09:21:30 +0800
Subject: [PATCH linux-next] nvdimm: Use the function kobj_to_dev()

Use kobj_to_dev() instead of open-coding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/nvdimm/bus.c            | 2 +-
 drivers/nvdimm/core.c           | 2 +-
 drivers/nvdimm/dimm_devs.c      | 4 ++--
 drivers/nvdimm/namespace_devs.c | 2 +-
 drivers/nvdimm/region_devs.c    | 4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b38d0355b0ac..6bd53d3a3eeb 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -690,7 +690,7 @@ static struct attribute *nd_numa_attributes[] = {
 static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
 		int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (!IS_ENABLED(CONFIG_NUMA))
 		return 0;
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index d91799b71d23..8ee7eddce0b2 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -466,7 +466,7 @@ static DEVICE_ATTR_ADMIN_RW(activate);
 
 static umode_t nvdimm_bus_firmware_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 	enum nvdimm_fwa_capability cap;
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c7c980577491..5f9487e40111 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -409,7 +409,7 @@ static struct attribute *nvdimm_attributes[] = {
 
 static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
 	if (a != &dev_attr_security.attr && a != &dev_attr_frozen.attr)
@@ -525,7 +525,7 @@ static struct attribute *nvdimm_firmware_attributes[] = {
 
 static umode_t nvdimm_firmware_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 	struct nvdimm *nvdimm = to_nvdimm(dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index dfade66bab73..fd2e8ca67001 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1372,7 +1372,7 @@ static struct attribute *nd_namespace_attributes[] = {
 static umode_t namespace_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (is_namespace_pmem(dev)) {
 		if (a == &dev_attr_size.attr)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 473a71bbd9c9..886740e2c94f 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -607,7 +607,7 @@ static struct attribute *nd_region_attributes[] = {
 
 static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, typeof(*dev), kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	int type = nd_region_to_nstype(nd_region);
@@ -721,7 +721,7 @@ REGION_MAPPING(31);
 
 static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (n < nd_region->ndr_mappings)
-- 
2.25.1
