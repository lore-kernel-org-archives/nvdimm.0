Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A29128822
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710198; cv=none; b=X+50OCUwANQztSMYWA6Up1OvoM8fhfr/PJRCJEyA7FsIQtrkI/jvgddVBcMzhOysjfHTq/tRO90vjhqWimYgH7oXf906V6m+e/QaLBw4DZZxN6Zz+/ebu+GgjadDs3SAKzrpzq/zxD4fuqxBCtgTHL/XEF4gEClRIhDD8Mu4a/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710198; c=relaxed/simple;
	bh=5E8ws1s3l5Z0WPoeTvetPbeYIJIcr9hUCwqUfntZF8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UMuwP6uLuzKzYBGr5IaJmxy79QQglqb2fpuNzOL5Y/BvB13DuttO3OLoqIVlrduH9l2vZeBPfW8WvjT10Vj/NHPx/bkq6BfXnqqYPU5krBmcKEo8aDQu7u9c54vjoXBqYOiwKKkKXcFXbcuCCedvbfXM96iIXBTaWvDAUON2qiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SNmXFW4C; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SNmXFW4C"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c15d1bd5b1so422668b6e.1
        for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 09:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708710195; x=1709314995; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zu2qZWqnSX2CvxPOf8wPdAKOwn+qgMDO2ue/T6c8dWQ=;
        b=SNmXFW4CwTwPMgDVSEWJuiTyl42fiVo8/plh3MGKvxKY0M4vsYYMC6XbnvawLXpMTy
         d69ufPv3NuLLvH+nUuwkkuuUVdPD7weWAhvSS7mmWw2RWIOAFGr2TWi/Iu6QY9H1DpI4
         in8z4f5oP+PNlVI8ZmDEFRl5JeYXTU7m5OwxegWMB0NtXFtU1GYRl83YpAVu7KaoqGBo
         mWnmH52A4bNC5NaniUWWyzGLHFj4T8O34ifi6CUeG+VckzVjGQ/PmHc8swjYgOD0Tir0
         ODk65RcMatWIfTsp4Js1sbJT3Pv0WDGUE26/927j52exGGbJJO57UirAT3LK8h2HMGr5
         rIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708710195; x=1709314995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zu2qZWqnSX2CvxPOf8wPdAKOwn+qgMDO2ue/T6c8dWQ=;
        b=eZbLDKTOrYZSimu/dbHw7tjDCad9GZFclTpWaVgUu9n3uvksaBZbza8wlBl+EKZU4o
         yz56XqDoeTkEOEYRAYIpNrNVLsqJB4JTqMlF3C3K7gI4eVwJRrxcCuOIOBvNQJByax6I
         tFmUuFwZILnchm3+BM6mFWamq6bVwrJHhkVc3m3QW6nfFVXBAn/jSP/MY9DVMl9wFjcs
         jiBA0EMIowojYox0VqB3S5l5WIYpk8TUGvr3jgyJNG1rGYAcCy8/dRD6Yk2eGH7trhp1
         MBkpoWHvpLa9XlqDJNHZDepg4OR/Octf/l0bcRGlK/+ojDFg/gvJlT+DIhutLgZjuR7p
         Kdww==
X-Forwarded-Encrypted: i=1; AJvYcCX6AHU+C8GkluOJnZK/HXDPnTJQ1NUcDIKGL/Yg4Vb4pPC0U7jbbngpuqK7XCrfLZeotUpG4CRpZu3lxho4R60moQdZ7Bdb
X-Gm-Message-State: AOJu0Yw2hLJfrDltVL6hPP1QYabhZmrcGIkLZ3ALos8Gy8zvVLGKaHZY
	PQAQO5XzblsGNwZbSeN8e6xFBle0g3X/LpyC9bIuYp1E1e19SW3v
X-Google-Smtp-Source: AGHT+IGYcgtz8Iy06lQQNWXgj+Ve6jWn51fNo3ZASvjNCtG6BLvd5/jrMrMZaBzsTgxAsVPTnEaAAA==
X-Received: by 2002:a05:6870:93cb:b0:21e:4f99:d3c9 with SMTP id c11-20020a05687093cb00b0021e4f99d3c9mr406481oal.50.1708710195603;
        Fri, 23 Feb 2024 09:43:15 -0800 (PST)
Received: from localhost.localdomain (070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id rb7-20020a056871618700b0021f6a2bd4b9sm1257803oab.3.2024.02.23.09.43.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Feb 2024 09:43:15 -0800 (PST)
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
Subject: [RFC PATCH 20/20] famfs: Add Kconfig and Makefile plumbing
Date: Fri, 23 Feb 2024 11:42:04 -0600
Message-Id: <1225d42bc8756c016bb73f8a43095a384b08524a.1708709155.git.john@groves.net>
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

Add famfs Kconfig and Makefile, and hook into fs/Kconfig and fs/Makefile

Signed-off-by: John Groves <john@groves.net>
---
 fs/Kconfig        |  2 ++
 fs/Makefile       |  1 +
 fs/famfs/Kconfig  | 10 ++++++++++
 fs/famfs/Makefile |  5 +++++
 4 files changed, 18 insertions(+)
 create mode 100644 fs/famfs/Kconfig
 create mode 100644 fs/famfs/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index 89fdbefd1075..8a11625a54a2 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -141,6 +141,8 @@ source "fs/autofs/Kconfig"
 source "fs/fuse/Kconfig"
 source "fs/overlayfs/Kconfig"
 
+source "fs/famfs/Kconfig"
+
 menu "Caches"
 
 source "fs/netfs/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index c09016257f05..382c1ea4f4c3 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -130,3 +130,4 @@ obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
 obj-$(CONFIG_EROFS_FS)		+= erofs/
 obj-$(CONFIG_VBOXSF_FS)		+= vboxsf/
 obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
+obj-$(CONFIG_FAMFS)             += famfs/
diff --git a/fs/famfs/Kconfig b/fs/famfs/Kconfig
new file mode 100644
index 000000000000..e450928d8912
--- /dev/null
+++ b/fs/famfs/Kconfig
@@ -0,0 +1,10 @@
+
+
+config FAMFS
+       tristate "famfs: shared memory file system"
+       depends on DEV_DAX && FS_DAX
+       help
+         Support for the famfs file system. Famfs is a dax file system that
+	 can support scale-out shared access to fabric-attached memory
+	 (e.g. CXL shared memory). Famfs is not a general purpose file system;
+	 it is an enabler for data sets in shared memory.
diff --git a/fs/famfs/Makefile b/fs/famfs/Makefile
new file mode 100644
index 000000000000..8cac90c090a4
--- /dev/null
+++ b/fs/famfs/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_FAMFS) += famfs.o
+
+famfs-y := famfs_inode.o famfs_file.o
-- 
2.43.0

