Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2467B36CDE5
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426715; cv=none; b=KrIYFlqnzQ4ZRwN1LHkSomr1RWt1Zn4jI14lBIPP1eebQTcBgTdf6d/idwUbCQ1Q+TjI6pFRhl+7/7Nw3oK0IqhRlimEJnQimSw5Sj8OM2KyjLi5m6e3oULZog24GHgclu2AMARjSYTOg63cjcAhN0Uh//Dwd4xq7RoI2doCpU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426715; c=relaxed/simple;
	bh=Myxyb2rDcBHr+xqknzGDwrg3ZSxy55A1mHw+gpZxb+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixzg8eY/XQfDYTLUK6FZ8T4ux1VnHsJYJjCTCw1XTThkOtOWLN54IgnygTLm3eatPthn1PMhmGeJ54wT+9ro4RlZiWIfUinxmKmPUG+bY5QQg1MuclU9AqlRt2uu3fBHe6aotqv4yhTqc8RBB9rJfu7/c9TZxpO4Pazh7yWJaOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aVLq6ShB; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVLq6ShB"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-40429b1d8baso100547fac.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426694; x=1769031494; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtiQrLd8slGpp7/JWfnN4t75EcUXAx+gZvq0QNgV39M=;
        b=aVLq6ShB0J17jLQZKXdS63kEvKayepg8folsD40Wm+wbDdSdfcedn5q1fbeir3wID9
         1SHwfPM8YtdQrac+2KRkDyKfCnGvyTcnEia1+n4W15ewYMyyU269aTk0ZLF3X+qNHY3h
         Xcvh9QYx+sEVIjbta775wj5pzzPL5uVqeXvy9i2NBMnNljUV0f0ve9oLBpy7Tz9887nW
         tLtPmLP3o0ucp2qORxKeeSjVF5F0eOSFcXZAEgo+rC9Qcd0yrt00G6yCqH8VXz1zyuPw
         VI/qu7pBDBdzEfcngL0jq4lCIWt6Y4Jy6QnI2rw8FfC5hsJdUBY2BnR91KisJLlXRO2G
         W48A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426694; x=1769031494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KtiQrLd8slGpp7/JWfnN4t75EcUXAx+gZvq0QNgV39M=;
        b=EJPfOAL5yHduJ03suqMHVfalhDsTht63bvdr0oACQv7Lmrts2VSxchuW6aARic0/kJ
         r86m/aS6DDixnX3V+tStQcDKTmnKZq8sXdhHHtvC8ClXMbMvjlkCyUDT2YNuLscMV69X
         cYC68WRTDTnXpgMeiE9G7Y1vyfd7Pv51RGqUvzZvrbjdTfuueMhoitmvUjH2jcigaqNF
         BbAioqKSb+nLkNuYBs8zbrdJEolHzAf/MG7eX9nsIJZx5aij5qc5qB2GoATWOn4sl5Ra
         bMNvqjKfOJhOVQa8YMrhh4ED5psbANCuF2vOKwSylNdjoYCVBxbcufWf0uda/bOSabWe
         oGEA==
X-Forwarded-Encrypted: i=1; AJvYcCUr8fESS27g7jLqhiPHDQYQ5R+eLx0HWoJVnJhgpmTlKl0ce7yBmcNv/m0YnFJ5M3dGQ7bsZvQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCM7obq54VCtSCYrHGXmUtTVo2ocuM0DFNONusEeNIsvlcR4ux
	MlW5tSyS89cgXuDlTZV6JPrrNn2uE/BnuN1gjaLqeJfREgcqF0XoC6zd
X-Gm-Gg: AY/fxX4G968za6WzNffWIxt++LDQxQTFtd1g9wihKJk6azLMfNmtsW0Qr3tv140pKh0
	tewXtbIy4qIfx4BFbpDVLNsMsVZRuFHL29ko1cN2Dww1haWQoy66gSgmwhSvJIeqSZoMnX1jI0t
	CZItvNw5Fa1CJgvUW9wL9VAhRMzpIdgr/CGvSBtXxx9HV/2DhUtnjOELI57MQ9pwnzqAUD4ydR3
	jY86sUIgTC0aCK1F4p3zwKktNyGT7NQrgn1At46N+BqMn4Z8Q+pNwZ66ZgN9RGA5ygLUtgrpg4v
	gb3JQCXGufW6NqfD3IBdYlLpAb93eQd5pPR60WqzILaR4XCNtv9YhZNORGniN8tLRZxQ/gd/ygI
	p/m9kIPC7JKFu345MYCQsWqcx16jCSfuwFlFAr4+Cm3E1NTNMxiPVJqKRxIzQfVKZaKQKmViEcB
	DHXYlXssYfvXrUfZO09N9GIdYIOmvQ7IESBnXXxBOy+VFd
X-Received: by 2002:a05:6871:3a2c:b0:3d3:7288:fe44 with SMTP id 586e51a60fabf-4040ba24643mr2524454fac.11.1768426694295;
        Wed, 14 Jan 2026 13:38:14 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50721a6sm17711247fac.10.2026.01.14.13.38.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:38:13 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 11/19] famfs_fuse: Basic fuse kernel ABI enablement for famfs
Date: Wed, 14 Jan 2026 15:31:58 -0600
Message-ID: <20260114213209.29453-12-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch starts the kernel ABI enablement of famfs in fuse.

- Kconfig: Add FUSE_FAMFS_DAX config parameter, to control
  compilation of famfs within fuse.
- FUSE_DAX_FMAP flag in INIT request/reply
- fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
  famfs-enabled connection

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/Kconfig           | 14 ++++++++++++++
 fs/fuse/fuse_i.h          |  3 +++
 fs/fuse/inode.c           |  6 ++++++
 include/uapi/linux/fuse.h |  5 +++++
 4 files changed, 28 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 3a4ae632c94a..5ca9fae62c7b 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -76,3 +76,17 @@ config FUSE_IO_URING
 
 	  If you want to allow fuse server/client communication through io-uring,
 	  answer Y
+
+config FUSE_FAMFS_DAX
+	bool "FUSE support for fs-dax filesystems backed by devdax"
+	depends on FUSE_FS
+	depends on DEV_DAX
+	depends on FS_DAX
+	default FUSE_FS
+	help
+	  This enables the fabric-attached memory file system (famfs),
+	  which enables formatting devdax memory as a file system. Famfs
+	  is primarily intended for scale-out shared access to
+	  disaggregated memory.
+
+	  To enable famfs or other fuse/fs-dax file systems, answer Y
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 45e108dec771..2839efb219a9 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -921,6 +921,9 @@ struct fuse_conn {
 	/* Is synchronous FUSE_INIT allowed? */
 	unsigned int sync_init:1;
 
+	/* dev_dax_iomap support for famfs */
+	unsigned int famfs_iomap:1;
+
 	/* Use io_uring for communication */
 	unsigned int io_uring;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ed667920997f..acabf92a11f8 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1456,6 +1456,10 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 
 			if (flags & FUSE_REQUEST_TIMEOUT)
 				timeout = arg->request_timeout;
+
+			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
+			    flags & FUSE_DAX_FMAP)
+				fc->famfs_iomap = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1517,6 +1521,8 @@ static struct fuse_init_args *fuse_new_init(struct fuse_mount *fm)
 		flags |= FUSE_SUBMOUNTS;
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+		flags |= FUSE_DAX_FMAP;
 
 	/*
 	 * This is just an information flag for fuse server. No need to check
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index c13e1f9a2f12..25686f088e6a 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -240,6 +240,9 @@
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
  *  - add FUSE_NOTIFY_PRUNE
+ *
+ *  7.46
+ *  - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
  */
 
 #ifndef _LINUX_FUSE_H
@@ -448,6 +451,7 @@ struct fuse_file_lock {
  * FUSE_OVER_IO_URING: Indicate that client supports io-uring
  * FUSE_REQUEST_TIMEOUT: kernel supports timing out requests.
  *			 init_out.request_timeout contains the timeout (in secs)
+ * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -495,6 +499,7 @@ struct fuse_file_lock {
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
 #define FUSE_OVER_IO_URING	(1ULL << 41)
 #define FUSE_REQUEST_TIMEOUT	(1ULL << 42)
+#define FUSE_DAX_FMAP		(1ULL << 43)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.52.0

