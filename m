Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266FE19CC06
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199267; cv=none; b=M3RcQlFjFY0P0J7QIhq1i/qSR2rVRCmnXteji2YNGjw4utzb5g9s7LSJOv7BTzcf79ShCyKE6OUi6BjmydDFdhmqM1cGcpUrzksX1BmVlfgpMS3LIEARz2d/Pn/BXTa410VTnppOJ18BjjWpHIFWB8DFeCvPMb07CDK/yKHzkNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199267; c=relaxed/simple;
	bh=oeJWVqoXTfM85DPBtFlVkuLxvj/f4i/x+rX/RZYjhZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m1FD6gETJqGiwoLqu3D654YXW3QVAHGk44kasHvE+cJBZuUlxhhPaI9C5Vc20YqGNZmjhwxrT/f9FYBvKXH9w5kLDLyALtR68cHEwCM+iqEAY0Kym7JGBWcZstu3qs0iHBfV1o7kGeEmEIc+7WBnOuvTepf/QWLomAYucmtW8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4RYHGbZ; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4RYHGbZ"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-72c14235af3so2428189a34.3
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199265; x=1745804065; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zJTUPxCr5iXCtHx04L7AsNg2Bv7yPa69NQGQVSsPk1Y=;
        b=C4RYHGbZrp9NV0Ky4BQuVuWYK0uJAzjJS+0L5zQ+I2I/q4e5RoQPkFJYXKlsLmQY4v
         GJgTqU0qM/XA6Bkww+Ii+MpueNvud1DUJseyUCrsbb0YR767Idy4rKs17v6sHOH7dJNs
         VuL4XSVLT+FDgyIOXhtbbmRdsWrd7wdUXaW/66nPgWuh5V0iqvBZlVWQjUee8msflBCI
         4GyRDnAFS2SiYTqcor5YQjzl61dC7LRVLk+vafNs5GnIf+BDZUt8CDJFuP0IwePMMj1Y
         zMVmXwXoeGzhUCMIetR6hCfD0+F4hiwKi9Hwwl+7ARVYm+OJqSliRUrdO9O15oDgWks5
         W/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199265; x=1745804065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zJTUPxCr5iXCtHx04L7AsNg2Bv7yPa69NQGQVSsPk1Y=;
        b=xQanword0ji5zPE98D/P1iwSopo8zs1L1klGsIPP408Y1JgkOjlO7K63iik4XscVWp
         1tV1mxvcGvzapGRQMu8yjlaxJ76arPTjCIXMQUNQlyybrPbUquqq8gcpo8M1kqanCBd2
         BsgYQ0UuUZjOJgLfwx33DeMBP+YY16wTwAANb+6hH9My68NFbiBXDi8a6+DcPj6B4zUW
         jl8L7sNkehWxQZeQy78MRDQqZmCgr47cdgZmTCcvgEweczSiS2lBJUpDlWlsfHq3Sarx
         It/DVyKfd+KLucR/K/6I3QVLS+/FYHcv9mGRX+uq254L+6LABAXwfXIZErelEWURBIMt
         Wgvg==
X-Forwarded-Encrypted: i=1; AJvYcCUPyEaYUH9UMkFTvQ+SWskVMQBb9pSPWzPtRCIm7gvta4RlE9lz/9JbCDV4qneAIfnZ/MFjtfY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQvN9y+eJgWhsYP1wBUb2DIAuRG7GVh4hfjVBB7G2v90IFPrVj
	DHYIZuayIP8hrxMXHgD8IPnwfQAWc7j4MN5c2fb1wJD7KcNfD7Pd
X-Gm-Gg: ASbGncvUChcERM13q5wg7mXEX3zlHYQvN/R0eCklEmXBUeJk6/5n3puugdIBlWqvU6P
	7Uyycor00IpliJtVtp/NnIbXFjEXgjnzm8xfRFz4LqoA3LNjIbGu5I4w8GAZ4vjkaUKBXdqPlUj
	+O1DuMZb1GiYmAANXqc6nIGaG+ybz6PrCiAg/DKchMaYN0wUPR5BfP/2W7rGMeB4EogVSXrxqGP
	56ItFNPVbQZeNxX1wMVinQmZKbOysHnkkYOwfsGFi+y4PM+hmLRT1aUjm7N2cLQ578eK7M+CMcj
	p4e+dyFuuvrKlbZpO+W9AEcBpN/sE4Mzw3k2woZOVRosR7VK/T49Jr+dnZpDqoxbfUwcBA==
X-Google-Smtp-Source: AGHT+IEeWI/ZWY1Oz4SEkKzVLnxG9+3nSwWecNs4VxQIfI4WYWMi4G/PZMw2CRTN5C5Uzp8choe8BQ==
X-Received: by 2002:a05:6830:3902:b0:727:3e60:b44b with SMTP id 46e09a7af769-7300622c63dmr5997735a34.14.1745199265163;
        Sun, 20 Apr 2025 18:34:25 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:24 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Luis Henriques <luis@igalia.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Vorel <pvorel@suse.cz>,
	Brian Foster <bfoster@redhat.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [RFC PATCH 10/19] famfs_fuse: Basic fuse kernel ABI enablement for famfs
Date: Sun, 20 Apr 2025 20:33:37 -0500
Message-Id: <20250421013346.32530-11-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

* FUSE_DAX_FMAP flag in INIT request/reply

* fuse_conn->famfs_iomap (enable famfs-mapped files) to denote a
  famfs-enabled connection

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/fuse_i.h          | 3 +++
 fs/fuse/inode.c           | 5 +++++
 include/uapi/linux/fuse.h | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e04d160fa995..b2c563b1a1c8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -870,6 +870,9 @@ struct fuse_conn {
 	/* Use io_uring for communication */
 	unsigned int io_uring;
 
+	/* dev_dax_iomap support for famfs */
+	unsigned int famfs_iomap:1;
+
 	/** Maximum stack depth for passthrough backing files */
 	int max_stack_depth;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 29147657a99f..5c6947b12503 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1392,6 +1392,9 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 			}
 			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
 				fc->io_uring = 1;
+			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
+				       flags & FUSE_DAX_FMAP)
+				fc->famfs_iomap = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1450,6 +1453,8 @@ void fuse_send_init(struct fuse_mount *fm)
 		flags |= FUSE_SUBMOUNTS;
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+		flags |= FUSE_DAX_FMAP;
 
 	/*
 	 * This is just an information flag for fuse server. No need to check
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5e0eb41d967e..f9e14180367a 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -435,6 +435,7 @@ struct fuse_file_lock {
  *		    of the request ID indicates resend requests
  * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
  * FUSE_OVER_IO_URING: Indicate that client supports io-uring
+ * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -482,6 +483,7 @@ struct fuse_file_lock {
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
 #define FUSE_OVER_IO_URING	(1ULL << 41)
+#define FUSE_DAX_FMAP		(1ULL << 42)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.49.0

