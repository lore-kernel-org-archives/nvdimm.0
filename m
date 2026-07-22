Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21F2440A2D
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745331; cv=none; b=FsIm2HYTnGuOYrqH7+Qa6XDngJkxHNT5+avIiUXrHx0fp4Fqtpd1WCHivDZNDRYJiahR5BYDFrRZ5P3CIYMR/T52pu03R7eFSpgjT2ZMP02neWxGhMHE8hGxpqBs7iIgpZxKJeJraSOtS3Mic/8GVTFOjuhPzfD95tD22vUbqEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745331; c=relaxed/simple;
	bh=vzqm4fFMouD2OMwwrdEh32Zh9IQ4/VjYNHxtQU2rRGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhkC1TXOjP2RmoCQBpFBVcb/a4nNZ4PcCjnvZuf3BeaTEVLMg11YMo25zp8Da9+dEr+77owxU+4KNnP/hZ+QkP+/vJ0Ctq2eDpCuRqa0+W1JLWpOtgsy846y/eVtfiMOQyhSP0h99/1m+s65/LbEU2u/k43yA4PbqBX9QpuYPdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=J8Oc/57F; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="J8Oc/57F"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ff5d1b0f91so90755556d6.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745329; x=1785350129; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V1q9zTpOIyp/zk0K72AZII9eGrDR/fzPr3ymjVJM/e8=;
        b=J8Oc/57FFChyEAguprSsIoytX+nfs6qI3Juq/6psZUu7d45qslgFwAtOHiphxVGghr
         RbiS3jbptK7Rag2hkRTCear81RMR1j2kS9MU4wRoTNzfZoj0v9Rr1kQFHz6hos3qEl8j
         aJwBa1kcCiweS0pQZlZpbrKL/d9Vnrf0itqN4QVAJtvHC0SC7qIW22ZNDFPYzH+PQezF
         K9TnAhyk9CCpgtCMETDngJRFVXdJZu0wiUuAp7Y7aGaAdBFGiGSMigB2XY0L6YCxHj0x
         tlduiXWft9bTq5pK4Rux8JUym6/8jKw35KuNHMzUtZtk+VLHeG8Gcfw+Uy/w9//pw7nf
         Mz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745329; x=1785350129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V1q9zTpOIyp/zk0K72AZII9eGrDR/fzPr3ymjVJM/e8=;
        b=OL3eTkMl0bmV3MFZXUC8yGZf//S+mitoAPPlIeGx8OQoWQ/GOT897cPvShzS1FbKpu
         6AG45QQPvTw4fSKpXReURhmcIVk6TwH3ml61TboN9Nt2iicZyZ+wt5XIOIFwzfLYVHN3
         jUfHegCseAJwrTSKnALTUbU32YmPdaUkDIYU/DNOIlOkonCaEPl6AWF4l6eDAyClK8JH
         m7CjPvTn6CL+wP80MZJrklezo5xs2H0pz/oUZ1uduk/F1oNgU1J3x40cnkUCn3BsJveo
         fBs1mouGr0fG47W7xPzF9rjsQ6Pv/ivwx7g+MqVJhq5wPK0tG1XRv/nqo1kJZgkd57YD
         NcRA==
X-Gm-Message-State: AOJu0YznIxhNFIal4laRHWYWYiAWDf1DSB5WR26kM8l24hRhDST2lRaZ
	gVLtGIbeTjpZJonVS3LdYuI+glWzsnZRiEX4hxJwdKs1Cf9xZl6wiUELdiW6zvWVRrE=
X-Gm-Gg: AR+sD115ziavq7rXtL7B4KUSiNcu7GXbOM8cIkcF5q6aj4mF/tSwD/9UTmTan0Y8rny
	hvWtDfYhXxjTE54/ryEoVhXWO+xsfHMZNG9+reNLcCntqQJRisC3ON+jKY3LrtsTFYywQQX9qTT
	DlGQPDw7JTpegkhq7NIn+q7pQALWKtw8vNM7bZbSruBi5FBFIFQEpuFlPPlBV2bOJex1xSetJfF
	byLAAkTyHQ/neW/ufVCQ/4IPddSQ8hGsjf1t4XiSelC1u3/LRdj/6ZKUQQTkoP9Nw7+WJIUNDMX
	e3pqmD81I6FXHsF4jBO+h1CtUwkxuWDDgD4Mw7sihkYJRMEcktkSfEM7sH5fRNQWqdzfpFQ4Un+
	2US+9nWgW8lf+rji7m9jWQ0aaRJnf0M9i2XSob+OmHCSxdfYfAprW5Y17HKGscDL5BQZNohARi1
	NTzk0WYccYo4+L5t9L8Hqpxt9l3xd3FQP4kCvUE3wwRp/TfdwAxcsbHzRmPNvz5S4=
X-Received: by 2002:a05:6214:5701:b0:8f1:90f4:cb78 with SMTP id 6a1803df08f44-907ca5e95a1mr29856d6.37.1784745328921;
        Wed, 22 Jul 2026 11:35:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:28 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 3/8] dax/kmem: add the reclaim opt-in (CAP_RECLAIM) for private nodes
Date: Wed, 22 Jul 2026 14:35:14 -0400
Message-ID: <20260722183519.935213-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
References: <20260722183519.935213-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the first per-service opt-in for a private node: "reclaim".
Also introduces the KMEM_PRIVATE_CAP_ATTR() helper for future bits.

Sets NODE_PRIVATE_CAP_RECLAIM for the device's private node.

A private kmem node opted into reclaim recovers THP compatibility.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c4c18aeb43c69..cf6cb927e5ed5 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -117,7 +117,7 @@ static int kmem_anon_mmap(struct file *filp, struct vm_area_struct *vma)
 	 * Without reclaim/compaction, high-order allocations can fail despite
 	 * memory still being available. Can be relaxed with reclaim support.
 	 */
-	if (data->private)
+	if (!node_allows_reclaim(data->numa_node))
 		vm_flags_set(vma, VM_NOHUGEPAGE);
 	mpol_get(data->policy);
 	kmem_vma_set_policy(vma, data->policy);
@@ -595,8 +595,44 @@ static ssize_t dax_file_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(dax_file);
 
+/* NODE_PRIVATE_CAP_* opt-in toggles - captured in data->caps */
+#define KMEM_PRIVATE_CAP_ATTR(name, CAP)				\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *buf)	\
+{									\
+	struct dax_kmem_data *data = dev_get_drvdata(dev);		\
+									\
+	return sysfs_emit(buf, "%d\n", !!(data->caps & (CAP)));		\
+}									\
+static ssize_t name##_store(struct device *dev,				\
+			    struct device_attribute *attr,		\
+			    const char *buf, size_t len)		\
+{									\
+	struct dax_kmem_data *data = dev_get_drvdata(dev);		\
+	bool enable;							\
+	ssize_t rc;							\
+									\
+	rc = kstrtobool(buf, &enable);					\
+	if (rc)								\
+		return rc;						\
+									\
+	guard(mutex)(&data->lock);					\
+									\
+	if (data->state != DAX_KMEM_UNPLUGGED)				\
+		return -EBUSY;						\
+	if (enable)							\
+		data->caps |= (CAP);					\
+	else								\
+		data->caps &= ~(CAP);					\
+	return len;							\
+}									\
+static DEVICE_ATTR_RW(name)
+
+KMEM_PRIVATE_CAP_ATTR(reclaim, NODE_PRIVATE_CAP_RECLAIM);
+
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
+	&dev_attr_reclaim.attr,
 	NULL,
 };
 static const struct attribute_group dax_kmem_private_group = {
-- 
2.53.0-Meta

