Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCBF2F5321
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568674; cv=none; b=Qm5EjM44SzVRZEFdM0+m2ghG0XfNRS6CapWAl4Ict5EwjklY/7elx5RVK/ey69Hnyq+tKcgrf1w7Es1rItivHG4OVAoaNetXwxd9ZOaL3XGGZAUc6il5ts3dcPdrqIuq6P5jFhzI5k8/EP3HKPrCtzMxt6g/GpjaA2AiZFyRAgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568674; c=relaxed/simple;
	bh=mMW0UbMGTQwYwRZyOjOzEYWkKRV1p4nf8Yc9UlNqkSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pnc+AvZm8VbRAaylxK83lrJdwbUFt6wFfZFaqzE/zJDDxdy+waIqkV+56aCP9WrG3EfCYilvk8KoRzKdqlC4Nv0psNm1RKrvhTlOBle9MbKtv62Ks0rNAWA6JTYRtuvpNuzUfhGB+V8S31pWPSVUtw4xSGM6XA1N2d8vqElQ/LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GZUq+di4; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZUq+di4"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-72c14138668so96620a34.2
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568672; x=1752173472; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oWEMonaAutVoYmJ29X2qmwGpA5xB0/IYZPa9u5OJI9E=;
        b=GZUq+di40xTYtNQ8N2o4K1WhbJnMWJAm1S1hsThUIHyoK1hY5heuO1E4VqNp/85QeH
         1RFY8dPHLhMo/5ck4qVBcojuiLci7hxh1VZCu3cmPWAs06O4R3tZCjeKn2gbIqUuwP1l
         xpP5BxcsNG8zvVxSO43/kLNW6jBiaZtlFdXhzqmkoKkkuLvcvYP8YhgXP4YvBYbciXMu
         qIoh8+SE8VhTK2J8MTCJBAz2wsO3vvZrpmiIQBPj1d5xOy5HOXYAEWTAqOT6JJMFIjWX
         HBBEndWLzfv9w2vBcL3Hy0QOMCshbEq6KxAcEXR9Pn1wEdNEXbzNG1K6kBg1keGP9T7R
         9c1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568672; x=1752173472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oWEMonaAutVoYmJ29X2qmwGpA5xB0/IYZPa9u5OJI9E=;
        b=KWMuXPnS0ZtJT54eJjguKM7Ybjln5VjEvykilE7EI93VDvzKIPexivu6HpGAHdKGYH
         FvFda+irmPozgkkWYXygJPGfutID/tIDcZ5v6+0p8BHkQ8Z5sMO54CC1a1bTWmJAAKuh
         SR23pOkb9zHl8rZ7k7AXm/AOk0vTnImqJCc/Db4hh5UvRrmAeCmR+Tweh52q2eba1vGi
         EW/cHwFOK5zisoNPVJdH/CONtbXX0lJSB6+yVOfsgNL7IUBGicJ6D5sK7/ERTdWr77uM
         r3ycSVHgXMbSzSbKITttAtuJ2QgLTrs501JgaphkcwwS8KbhbNxH5O0yD5rGls/AMF+n
         KzxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgRbfzV0Y4+9E6aGqYwYPq3kp2t1u0Kr0xtAeI8ntDJQllhPlEpRsZcQLmIYuasEaciGbYd04=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKKOSDETW38+VbUZragY2a6fw/DlVe2usCWd+5FMRXafkD/3LG
	ntlbpLa6Xvu6ArfeE7lsrH1cT86Wfl8Q+5Nwg6yMDPUCfEiKl7uXJnqq
X-Gm-Gg: ASbGnctDnb0QP931IksUnhKWv9+fdk2CW+1kv/amFfFQDehswG8/U8f2iM6UAnXwh5o
	Z2ZutpnFNRd8zGgeRMkVgJ+gc2CkBMLhAZmAQx6ijTmNvxNTunk+ydiBc50demTHGgCV2mjQ0HL
	9w+ABmy8ekWmrNakG2nGlMlMgwBBPH2NAZ4V/Qg5NgvVC6HTGX0eu9D4kfMWRELW1oCpgwd1cnN
	JdsxfA662UkevhZskesLL5DsMmlWpJx3rV6S/7iFqQtP5UMC2/Tm5OFrCDIU1x9RQgweXkf+qIz
	X1ATp8CkX6bAJUdtBfTWDMicj5qFUWp+dugZ51bw053LXKvRbEdbljEqiseSREBLXUXQt5N11JI
	LhfUtDuBLJlclPQ==
X-Google-Smtp-Source: AGHT+IHUwBODwIp7ctJ4MwNp6YGMLaTDNPH7V/WuiY/SsNw4SKPQYUNXiEa1+Y5X/8t1R2ZxfJ9uFQ==
X-Received: by 2002:a05:6830:8008:b0:73c:47f0:b0f2 with SMTP id 46e09a7af769-73c8980e0e1mr3246513a34.27.1751568671716;
        Thu, 03 Jul 2025 11:51:11 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:08 -0700 (PDT)
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
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
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
Subject: [RFC V2 10/18] famfs_fuse: Basic fuse kernel ABI enablement for famfs
Date: Thu,  3 Jul 2025 13:50:24 -0500
Message-Id: <20250703185032.46568-11-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
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
 fs/fuse/fuse_i.h          |  3 +++
 fs/fuse/inode.c           | 14 ++++++++++++++
 include/uapi/linux/fuse.h |  4 ++++
 3 files changed, 21 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 9d87ac48d724..a592c1002861 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -873,6 +873,9 @@ struct fuse_conn {
 	/* Use io_uring for communication */
 	unsigned int io_uring;
 
+	/* dev_dax_iomap support for famfs */
+	unsigned int famfs_iomap:1;
+
 	/** Maximum stack depth for passthrough backing files */
 	int max_stack_depth;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 29147657a99f..e48e11c3f9f3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1392,6 +1392,18 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 			}
 			if (flags & FUSE_OVER_IO_URING && fuse_uring_enabled())
 				fc->io_uring = 1;
+			if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX) &&
+			    flags & FUSE_DAX_FMAP) {
+				/* XXX: Should also check that fuse server
+				 * has CAP_SYS_RAWIO and/or CAP_SYS_ADMIN,
+				 * since it is directing the kernel to access
+				 * dax memory directly - but this function
+				 * appears not to be called in fuse server
+				 * process context (b/c even if it drops
+				 * those capabilities, they are held here).
+				 */
+				fc->famfs_iomap = 1;
+			}
 		} else {
 			ra_pages = fc->max_read / PAGE_SIZE;
 			fc->no_lock = 1;
@@ -1450,6 +1462,8 @@ void fuse_send_init(struct fuse_mount *fm)
 		flags |= FUSE_SUBMOUNTS;
 	if (IS_ENABLED(CONFIG_FUSE_PASSTHROUGH))
 		flags |= FUSE_PASSTHROUGH;
+	if (IS_ENABLED(CONFIG_FUSE_FAMFS_DAX))
+		flags |= FUSE_DAX_FMAP;
 
 	/*
 	 * This is just an information flag for fuse server. No need to check
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5e0eb41d967e..6c384640c79b 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -229,6 +229,8 @@
  *    - FUSE_URING_IN_OUT_HEADER_SZ
  *    - FUSE_URING_OP_IN_OUT_SZ
  *    - enum fuse_uring_cmd
+ *  7.43
+ *    - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
  */
 
 #ifndef _LINUX_FUSE_H
@@ -435,6 +437,7 @@ struct fuse_file_lock {
  *		    of the request ID indicates resend requests
  * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
  * FUSE_OVER_IO_URING: Indicate that client supports io-uring
+ * FUSE_DAX_FMAP: kernel supports dev_dax_iomap (aka famfs) fmaps
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -482,6 +485,7 @@ struct fuse_file_lock {
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
 #define FUSE_OVER_IO_URING	(1ULL << 41)
+#define FUSE_DAX_FMAP		(1ULL << 42)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.49.0

