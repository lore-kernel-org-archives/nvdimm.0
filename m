Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCA3134CE5
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710159; cv=none; b=M6THpHmC4GDbbLHAXC4XA5ioKvdwpgK+kQOh80+9T+Ba3i7YGNpASZ9sJ8+HMgoboV3AprbnGD+yTVMiwn02RQ0kEkC86O3jwfHRX3G1tYlxj83lQMIle3ocjg6pdcI0b8GRqC4tAQkj3tuAI0usz54bYGKQQsrR4170GZuiMaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710159; c=relaxed/simple;
	bh=k/M1Z1IjBAm6hPnaoO3KF5w8PO6H65N7SDu9f4q8Yyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lCaKxVBLXRZOhc8vQ7Jg1j3ouSkhvS/680WIWg9uZyo+d2gzcf9j+GhTbybttf12t4yHfAPvkGZcdD8GIOB11RSAbr08rBevDR/ajVmaaorDLn+JZYi4iT3sETU/skL/dydTCs2hrt6ElVU/tOog6lKDj3iiHlZdPxik8SH9lRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fl6NxP86; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fl6NxP86"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3c0485fc8b8so732686b6e.3
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710157; x=1709314957; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8B3WSC/oB5J5WuE4nqPN1CLkkErOjaE3oAAMcrX2mc=;
        b=fl6NxP86hEFTErGqYSt0Vr4C1+whIjVdoLbZReIldPl1xuo2hTNVlu3AfYjmzsb9df
         8HUkmXVKHv5ml06vni0cYCoU5K7tr0O3TaKVCLjib5c5+7YRKYRiQQmXLIN0++PCHw2E
         ZODr3KtqWWkIzadUj1XdmCUuL6gZy3tSdQL28lMg6KEJPWQ4mPd7cC4nYQbdikVFRXSL
         7xzVrH8zcoh2/XKSBrf9TApoDhnsfpUrJgVkcU9C7fP6xkARM1DNxBiVDrm07V/Rtl/D
         JjvPLehHcMwLZC4abjxmYTHLj4BCfqxOoIZ87X7OP8QowpcoOQaHps1DrQYJQB3tIIy0
         b7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710157; x=1709314957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z8B3WSC/oB5J5WuE4nqPN1CLkkErOjaE3oAAMcrX2mc=;
        b=T8GsagmHaHaa3f9xa9wgsk8ZVMECirqjvdoD+aRbI1RHyi7FGS63+5gQtyCjSd4khN
         8+mqjBQI+kBFPs4cnfbJ+CpdBj7L2qPUXHvdsuk7Wx7t2uSuu1EEQc5AaZCVwDE8fKr0
         jZwjrjj2G+nJlCJON8JQCfc21Z9YHwaWtg0wMjOPA5Zr31V80gOJGVjJgkshpJnnWmMP
         aoir4FXQLCPc+XkvF772VWKjA13EJCVZk4v05XPIhutfep7JK0qr0oYNl1QsWKtt7XZj
         XwxlvGMxjtVvOIFhmFhhyNG2Jbg2mGyJn37bQT3rROUqki+4QgnWwsqq11zyAL6XaVBx
         oNsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYp9csoIN40W/uIdrcQnEQMpiwT/AzRVi86mIHWGSK2WslMGr/WY0d/3bJOBwnpGAXdYUjC5zJX4eNlF/QsRhnSp7Cep2L
X-Gm-Message-State: AOJu0YwYb03CtSGTaLOplqBfIvZ2xqm6S3Tr/0Zqj8qASWWzrAQ3RaGS
	WXuEbH7xW1hLiHMgwQdZx9rtiO170o0JSsRqiIkDm33fo7qfV7+SgE8XWM+82cA=
X-Google-Smtp-Source: AGHT+IEj8V1jRM+L2D+9halnV4FZjeOEtT0OxuoIXcJr1ybp9rMmGgfQ+zJi9Q54i2o5gJWGfNSg3w==
X-Received: by 2002:a05:6871:7805:b0:21e:8cdb:1030 with SMTP id oy5-20020a056871780500b0021e8cdb1030mr638921oac.24.1708710157291;
        Fri, 23 Feb 2024 09:42:37 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.42.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:42:37 -0800 (PST)
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
Subject: [RFC PATCH 07/20] famfs: Add include/linux/famfs_ioctl.h
Date: Fri, 23 Feb 2024 11:41:51 -0600
Message-Id: <b40ca30e4bf689249a8c237909d9a7aaca9861e4.1708709155.git.john@groves.net>
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

Add uapi include file for famfs. The famfs user space uses ioctl on
individual files to pass in mapping information and file size. This
would be hard to do via sysfs or other means, since it's
file-specific.

Signed-off-by: John Groves <john@groves.net>
---
 include/uapi/linux/famfs_ioctl.h | 56 ++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 include/uapi/linux/famfs_ioctl.h

diff --git a/include/uapi/linux/famfs_ioctl.h b/include/uapi/linux/famfs_ioctl.h
new file mode 100644
index 000000000000..6b3e6452d02f
--- /dev/null
+++ b/include/uapi/linux/famfs_ioctl.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * famfs - dax file system for shared fabric-attached memory
+ *
+ * Copyright 2023-2024 Micron Technology, Inc.
+ *
+ * This file system, originally based on ramfs the dax support from xfs,
+ * is intended to allow multiple host systems to mount a common file system
+ * view of dax files that map to shared memory.
+ */
+#ifndef FAMFS_IOCTL_H
+#define FAMFS_IOCTL_H
+
+#include <linux/ioctl.h>
+#include <linux/uuid.h>
+
+#define FAMFS_MAX_EXTENTS 2
+
+enum extent_type {
+	SIMPLE_DAX_EXTENT = 13,
+	INVALID_EXTENT_TYPE,
+};
+
+struct famfs_extent {
+	__u64              offset;
+	__u64              len;
+};
+
+enum famfs_file_type {
+	FAMFS_REG,
+	FAMFS_SUPERBLOCK,
+	FAMFS_LOG,
+};
+
+/**
+ * struct famfs_ioc_map
+ *
+ * This is the metadata that indicates where the memory is for a famfs file
+ */
+struct famfs_ioc_map {
+	enum extent_type          extent_type;
+	enum famfs_file_type      file_type;
+	__u64                     file_size;
+	__u64                     ext_list_count;
+	struct famfs_extent       ext_list[FAMFS_MAX_EXTENTS];
+};
+
+#define FAMFSIOC_MAGIC 'u'
+
+/* famfs file ioctl opcodes */
+#define FAMFSIOC_MAP_CREATE    _IOW(FAMFSIOC_MAGIC, 1, struct famfs_ioc_map)
+#define FAMFSIOC_MAP_GET       _IOR(FAMFSIOC_MAGIC, 2, struct famfs_ioc_map)
+#define FAMFSIOC_MAP_GETEXT    _IOR(FAMFSIOC_MAGIC, 3, struct famfs_extent)
+#define FAMFSIOC_NOP           _IO(FAMFSIOC_MAGIC,  4)
+
+#endif /* FAMFS_IOCTL_H */
-- 
2.43.0

