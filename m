Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2C5146E74
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710185; cv=none; b=UeKHjn23oWoCSlrCVSKPe7ggSzC/95Oos5wkzEzWuGpwKuH+MD1JzBTH6dQUJWBfuzWTdyX+xlpVZFsOT+RjDl6OxNERubWIidFr6yX+pyon5zRnfpdJS4ecHWY6gN7+jUGS6YmyEwJOKX6ug1LlCZKqoEJfCMEhuRnsCHSQ5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710185; c=relaxed/simple;
	bh=fyP1dnJB44f2zHUX/KhaAT1o3vyBlQVFBHhanjGgGrc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mzj1mCVE0a7Xc5j2H/TytiX7s0xZCwb0d5BXcCedny3eRlVV7XnWOtOH/zFn/nq1pm6oVK1bOWDDICUuWM+sup7hbR2S5tfswjfKXuCTAUj0izhqC29fGZO5E2pBCk6Ty4QVTfg+Vle4+Eg6HzU3Ajnbh2G9bwl2n2RJxxLXZys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jx9WdpGI; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jx9WdpGI"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e480af11f2so364723a34.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710183; x=1709314983; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSU63xn35q5xIC/F3LPxUfwI8O4W4i8duNVDi3MdIz8=;
        b=Jx9WdpGIdqbAd6dL8cr90HhOxfXyX6KinQ43LAQcVfyfe17pjUCVqAV6jwd1vtvCz9
         0btM2y+Q5XadHWNM7FRh3p85WwoyjC1/chyYgDLIH34q/vKQCmA/wSAyIe4JluY8GtvT
         wEgF2jsLA4gb2o5iaTHtECMl0xB+j4VRbea0KMnhZSmCXNZvjBU4BjkFCdErUwWzhPw8
         OJ5sjahQlr+UnoFZenvoA2ydWwWXBIr53tlbzC4DLHQ2jhouRPrGcXg3Aah88MYIWR9a
         JLsTlGW/U7OeJCQuQySgokJsopAr9/sua7MhPh4Q69ZwBUQCLhYZwEO4zz8l0HvL0k+G
         5wpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710183; x=1709314983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QSU63xn35q5xIC/F3LPxUfwI8O4W4i8duNVDi3MdIz8=;
        b=QgLS8d1Fx4+exmfmCyHra35kP0cunYhiAB+RdavILk+aZMXb+VFXlqIqY4r3bgAja8
         M6mNmEGv8ApgXGGabOvdq5OrKSwELYAzEmkA4CxEDUoSLQ+mHxT6Sw66Qko3TG1+CQr5
         nO6k5E/SHuDN5OwgC4DUz3YHRmqyyh0wEwV0eT8gBYdMqsaOz4ok1V56Hm7R1Xl2Uwyk
         jttM007sq9iDdVEyATdkfrWgLdN3ovsV/7Z51e/l+NSpunBC+UlBLU2j2P0YpKhnVxPk
         RPUAnszQFNqZEqhnylgT+y/5yfk+IVqUl16HD4uJMnWaF8HbcwgokFfetnEScG1H9rRS
         5M3g==
X-Forwarded-Encrypted: i=1; AJvYcCU/FnazX+xPP0xvX4mHFCSaJzYPJw0nAfVjgx2nNmrYFZ/e6C2AsIastsPB1uBhTTpzFLoz65HPHU42WyJBsVt6SLVJQt7c
X-Gm-Message-State: AOJu0YwR+SDCqipLpEX2AnGEmeqSw5/rsShz6O8a5M4C18EWBlZHMTqF
	nrUBnprQMQANCL8oFctwuHYySW8ZEqI57GHnCAjih/aaEtnfEX8Q
X-Google-Smtp-Source: AGHT+IHYLhdAVNB79UcBgLmrX8iHEz3pdisd9nD17jHPXDhHA28rwXuN54PUoWNin6tsA8ziv8tebw==
X-Received: by 2002:a05:6870:f6a1:b0:21e:9b99:53d8 with SMTP id el33-20020a056870f6a100b0021e9b9953d8mr563209oab.22.1708710183097;
        Fri, 23 Feb 2024 09:43:03 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.43.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:43:02 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John@Groves.net,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	John Groves <john@groves.net>
Subject: [RFC PATCH 16/20] famfs: Add fault counters
Date: Fri, 23 Feb 2024 11:42:00 -0600
Message-Id: <43245b463f00506016b8c39c0252faf62bd73e35.1708709155.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <cover.1708709155.git.john@groves.net>
References: <cover.1708709155.git.john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

One of the key requirements for famfs is that it service vma faults
efficiently. Our metadata helps - the search order is n for n extents,
and n is usually 1. But we can still observe gnarly lock contention
in mm if PTE faults are happening. This commit introduces fault counters
that can be enabled and read via /sys/fs/famfs/...

These counters have proved useful in troubleshooting situations where
PTE faults were happening instead of PMD. No performance impact when
disabled.

Signed-off-by: John Groves <john@groves.net>
---
 fs/famfs/famfs_file.c     | 97 +++++++++++++++++++++++++++++++++++++++
 fs/famfs/famfs_internal.h | 73 +++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)

diff --git a/fs/famfs/famfs_file.c b/fs/famfs/famfs_file.c
index fd42d5966982..a626f8a89790 100644
--- a/fs/famfs/famfs_file.c
+++ b/fs/famfs/famfs_file.c
@@ -19,6 +19,100 @@
 #include <uapi/linux/famfs_ioctl.h>
 #include "famfs_internal.h"
 
+/***************************************************************************************
+ * filemap_fault counters
+ *
+ * The counters and the fault_count_enable file live at
+ * /sys/fs/famfs/
+ */
+struct famfs_fault_counters ffc;
+static int fault_count_enable;
+
+static ssize_t
+fault_count_enable_show(struct kobject *kobj,
+			struct kobj_attribute *attr,
+			char *buf)
+{
+	return sprintf(buf, "%d\n", fault_count_enable);
+}
+
+static ssize_t
+fault_count_enable_store(struct kobject        *kobj,
+			 struct kobj_attribute *attr,
+			 const char            *buf,
+			 size_t                 count)
+{
+	int value;
+	int rc;
+
+	rc = sscanf(buf, "%d", &value);
+	if (rc != 1)
+		return 0;
+
+	if (value > 0) /* clear fault counters when enabling, but not when disabling */
+		famfs_clear_fault_counters(&ffc);
+
+	fault_count_enable = value;
+	return count;
+}
+
+/* Individual fault counters are read-only */
+static ssize_t
+fault_count_pte_show(struct kobject *kobj,
+		     struct kobj_attribute *attr,
+		     char *buf)
+{
+	return sprintf(buf, "%llu", famfs_pte_fault_ct(&ffc));
+}
+
+static ssize_t
+fault_count_pmd_show(struct kobject *kobj,
+		     struct kobj_attribute *attr,
+		     char *buf)
+{
+	return sprintf(buf, "%llu", famfs_pmd_fault_ct(&ffc));
+}
+
+static ssize_t
+fault_count_pud_show(struct kobject *kobj,
+		     struct kobj_attribute *attr,
+		     char *buf)
+{
+	return sprintf(buf, "%llu", famfs_pud_fault_ct(&ffc));
+}
+
+static struct kobj_attribute fault_count_enable_attribute = __ATTR(fault_count_enable,
+								   0660,
+								   fault_count_enable_show,
+								   fault_count_enable_store);
+static struct kobj_attribute fault_count_pte_attribute = __ATTR(pte_fault_ct,
+								0440,
+								fault_count_pte_show,
+								NULL);
+static struct kobj_attribute fault_count_pmd_attribute = __ATTR(pmd_fault_ct,
+								0440,
+								fault_count_pmd_show,
+								NULL);
+static struct kobj_attribute fault_count_pud_attribute = __ATTR(pud_fault_ct,
+								0440,
+								fault_count_pud_show,
+								NULL);
+
+
+static struct attribute *attrs[] = {
+	&fault_count_enable_attribute.attr,
+	&fault_count_pte_attribute.attr,
+	&fault_count_pmd_attribute.attr,
+	&fault_count_pud_attribute.attr,
+	NULL,
+};
+
+struct attribute_group famfs_attr_group = {
+	.attrs = attrs,
+};
+
+/* End fault counters */
+
 /**
  * famfs_map_meta_alloc() - Allocate famfs file metadata
  * @mapp:       Pointer to an mcache_map_meta pointer
@@ -525,6 +619,9 @@ __famfs_filemap_fault(
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
+		if (fault_count_enable)
+			famfs_inc_fault_counter_by_order(&ffc, pe_size);
+
 		ret = dax_iomap_fault(vmf, pe_size, &pfn, NULL, &famfs_iomap_ops);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
diff --git a/fs/famfs/famfs_internal.h b/fs/famfs/famfs_internal.h
index af3990d43305..987cb172a149 100644
--- a/fs/famfs/famfs_internal.h
+++ b/fs/famfs/famfs_internal.h
@@ -50,4 +50,77 @@ struct famfs_fs_info {
 	char                    *rootdev;
 };
 
+/*
+ * filemap_fault counters
+ */
+extern struct attribute_group famfs_attr_group;
+
+enum famfs_fault {
+	FAMFS_PTE = 0,
+	FAMFS_PMD,
+	FAMFS_PUD,
+	FAMFS_NUM_FAULT_TYPES,
+};
+
+static inline int valid_fault_type(int type)
+{
+	if (unlikely(type < 0 || type > FAMFS_PUD))
+		return 0;
+	return 1;
+}
+
+struct famfs_fault_counters {
+	atomic64_t fault_ct[FAMFS_NUM_FAULT_TYPES];
+};
+
+extern struct famfs_fault_counters ffc;
+
+static inline void famfs_clear_fault_counters(struct famfs_fault_counters *fc)
+{
+	int i;
+
+	for (i = 0; i < FAMFS_NUM_FAULT_TYPES; i++)
+		atomic64_set(&fc->fault_ct[i], 0);
+}
+
+static inline void famfs_inc_fault_counter(struct famfs_fault_counters *fc,
+					   enum famfs_fault type)
+{
+	if (valid_fault_type(type))
+		atomic64_inc(&fc->fault_ct[type]);
+}
+
+static inline void famfs_inc_fault_counter_by_order(struct famfs_fault_counters *fc, int order)
+{
+	int pgf = -1;
+
+	switch (order) {
+	case 0:
+		pgf = FAMFS_PTE;
+		break;
+	case PMD_ORDER:
+		pgf = FAMFS_PMD;
+		break;
+	case PUD_ORDER:
+		pgf = FAMFS_PUD;
+		break;
+	}
+	famfs_inc_fault_counter(fc, pgf);
+}
+
+static inline u64 famfs_pte_fault_ct(struct famfs_fault_counters *fc)
+{
+	return atomic64_read(&fc->fault_ct[FAMFS_PTE]);
+}
+
+static inline u64 famfs_pmd_fault_ct(struct famfs_fault_counters *fc)
+{
+	return atomic64_read(&fc->fault_ct[FAMFS_PMD]);
+}
+
+static inline u64 famfs_pud_fault_ct(struct famfs_fault_counters *fc)
+{
+	return atomic64_read(&fc->fault_ct[FAMFS_PUD]);
+}
+
 #endif /* FAMFS_INTERNAL_H */
-- 
2.43.0

