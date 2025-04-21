Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473D61E572F
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199297; cv=none; b=h9CTY8EIewTznrp657QDhDJM8TXkAuMue6MP1JLshNvfEq/61aY64bSprqdVKSO2LlTKXZcNF9Hz/16oYjjUoeeWjxzuoHm+pCKEgGnLtY8DcPsPGVqJzBnJKrYLdPdEKLMqfWeozTEc3hetGz+nCDUTXKzwVR7Nekm1exdlBNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199297; c=relaxed/simple;
	bh=PEQixm1WSR8qIvIweIBLz5yb47diHKRVT7ZCrAw41jE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V21U9NvoUuibJ15xB7JApqG+xYebKeyuscNLljhFkf42Oiin1txvC1HYulG2epUizprFuQ5g9mN0pEpQ3CzrJCbG/DgtSwmvVbqq+Q0Knco8egxzEixvRzfpKF/qVyHRKDJqGsX28+B35z3DZ6lWYpoew5jBmiR+vyH/yzf0iR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AiZ0KhEw; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AiZ0KhEw"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-72c47631b4cso2370039a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199294; x=1745804094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdQVZhgSGxPpGqga5Gwo7PXNt34SxV9og+/VWo3OSP8=;
        b=AiZ0KhEwNgkImB8iz7OOuJyYpmiyTd/HAv6yAZw6fDQ1jmJL8m3XzyzTNabL0bongX
         PQjkq/PktbM5jnRqM1YpQDyvkl/pidXlE5I8lSKmCIOEF8BBhtwJK+BSHJheMJG7V/Rq
         WMouCk7jDdPaeySKcI8Oqlhn3ZPCadAWzKatgBD2oPu4e4JKDcs/EWAyHTX0+j5GuM+a
         GmlW9SGhd5Z1HGAFJkU9/dhRbY+f9Djg/GWKwePFb+AIk4w1LV2WAL7sxkwaCy5MHhsu
         BknVXfpzPg70AbjUps9F6latjfvEAvhKIpq9QdwbI3s8mjxXF53odHiP0wh2u2Yb+qBg
         Yp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199294; x=1745804094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mdQVZhgSGxPpGqga5Gwo7PXNt34SxV9og+/VWo3OSP8=;
        b=ESubhZyJ900tJ7y3sbDQPW+Xnw1CmGB4Do2tJqFcphFZ0LomoT0qarSnnCEY0Rc32t
         mbHo/sBBo7kG/mRz390hHJwilbzI90X4jfDE0GY1FR0eWOK2DtrinDe2Mz7YT0YvxpR8
         4BIQUfi5rGX4+lVq/l4V5LhsovYkMpUGaeZRig4HUf2XtKDhMr232nDQq9MwBqqk5dsn
         oMJ0kmYEugFuMeTDvksNaeSHnM77UTpDqmVaIJWiEqE+mLPmZYk+RhVakH01GCB3BJRm
         OkE+J5Jx2qxQvnUkRwHxUJH/xxMyrzGEvy15INjuSnbqZD2e4gIrgYshjo0AOAngmow1
         qX9w==
X-Forwarded-Encrypted: i=1; AJvYcCXTF8FyJ+m7k5vKG047NEmIDvIdXI8/DB2jPiKDPQB57QgfatYQxLxPUeeQ6bKL29w7g47jdRs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzIyWCzn+PahaJ6uG76wZ4BoY/pO93RBvhBoM7OI9HVP16gafZi
	JBM+KpCz5Sbxl6xYv15KdREFd8GwY07Dkq2FKv0PUwmy396jVTI6
X-Gm-Gg: ASbGncuNjl3LQyushTNynFU/fadgarL2nsrrYrZlzFFBMaO+Y3M1ea4WVZsEgH6PWW4
	FNpCZWHCuZthVmWdhtCt6uKjtrqe/a+BCXQHbrU5es5FkYIVqu3uSfubzpgP83tN6QGJcOgA+i+
	YHmwwlpE+Ey9Nm4ptrjHMJMzVUsXdnz7PUOib1qL2eFOhhgzXpAcpfcEF31foQP6UKLZ4mJ9dMf
	fyHH7hOwuynNTFjsn5zjIiV2W4xw2UN8hybGLhQUqbtzgDis/coSqJZ5t9GZCQwvfJ2IFBypt/v
	wgf16AnDhWZvsDHbCaWGKNBlPtxothAZTmk/diU/uzBzFXtfNdVosROPkJGC+RsHBQzeag==
X-Google-Smtp-Source: AGHT+IFvhi11eKZv5Y/gzRlzyAgr2UzcgOUfeV5gBpd2B3+8/z28bKwE37MnSOlyjxSbt8eeloMeSg==
X-Received: by 2002:a05:6830:7182:b0:72b:80b8:8c67 with SMTP id 46e09a7af769-73006333e6fmr5754877a34.28.1745199294139;
        Sun, 20 Apr 2025 18:34:54 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:53 -0700 (PDT)
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
Subject: [RFC PATCH 19/19] famfs_fuse: (ignore) debug cruft
Date: Sun, 20 Apr 2025 20:33:46 -0500
Message-Id: <20250421013346.32530-20-john@groves.net>
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

This debug cruft will be dropped from the "real" patch set

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/Makefile |  2 +-
 fs/fuse/dev.c    | 61 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/Makefile b/fs/fuse/Makefile
index 65a12975d734..ad3e06a9a809 100644
--- a/fs/fuse/Makefile
+++ b/fs/fuse/Makefile
@@ -4,7 +4,7 @@
 #
 
 # Needed for trace events
-ccflags-y = -I$(src)
+ccflags-y = -I$(src) -g -DDEBUG -fno-inline -fno-omit-frame-pointer
 
 obj-$(CONFIG_FUSE_FS) += fuse.o
 obj-$(CONFIG_CUSE) += cuse.o
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 51e31df4c546..ba947511a379 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -30,6 +30,60 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
+static char *opname[] = {
+	[FUSE_LOOKUP]	   =   "LOOKUP",
+	[FUSE_FORGET]	   =   "FORGET",
+	[FUSE_GETATTR]	   =   "GETATTR",
+	[FUSE_SETATTR]	   =   "SETATTR",
+	[FUSE_READLINK]	   =   "READLINK",
+	[FUSE_SYMLINK]	   =   "SYMLINK",
+	[FUSE_MKNOD]	   =   "MKNOD",
+	[FUSE_MKDIR]	   =   "MKDIR",
+	[FUSE_UNLINK]	   =   "UNLINK",
+	[FUSE_RMDIR]	   =   "RMDIR",
+	[FUSE_RENAME]	   =   "RENAME",
+	[FUSE_LINK]	   =   "LINK",
+	[FUSE_OPEN]	   =   "OPEN",
+	[FUSE_READ]	   =   "READ",
+	[FUSE_WRITE]	   =   "WRITE",
+	[FUSE_STATFS]	   =   "STATFS",
+	[FUSE_STATX]       =   "STATX",
+	[FUSE_RELEASE]	   =   "RELEASE",
+	[FUSE_FSYNC]	   =   "FSYNC",
+	[FUSE_SETXATTR]	   =   "SETXATTR",
+	[FUSE_GETXATTR]	   =   "GETXATTR",
+	[FUSE_LISTXATTR]   =   "LISTXATTR",
+	[FUSE_REMOVEXATTR] =   "REMOVEXATTR",
+	[FUSE_FLUSH]	   =   "FLUSH",
+	[FUSE_INIT]	   =   "INIT",
+	[FUSE_OPENDIR]	   =   "OPENDIR",
+	[FUSE_READDIR]	   =   "READDIR",
+	[FUSE_RELEASEDIR]  =   "RELEASEDIR",
+	[FUSE_FSYNCDIR]	   =   "FSYNCDIR",
+	[FUSE_GETLK]	   =   "GETLK",
+	[FUSE_SETLK]	   =   "SETLK",
+	[FUSE_SETLKW]	   =   "SETLKW",
+	[FUSE_ACCESS]	   =  "ACCESS",
+	[FUSE_CREATE]	   =  "CREATE",
+	[FUSE_INTERRUPT]   =  "INTERRUPT",
+	[FUSE_BMAP]	   =  "BMAP",
+	[FUSE_IOCTL]	   =  "IOCTL",
+	[FUSE_POLL]	   =  "POLL",
+	[FUSE_FALLOCATE]   =  "FALLOCATE",
+	[FUSE_DESTROY]	   =  "DESTROY",
+	[FUSE_NOTIFY_REPLY] = "NOTIFY_REPLY",
+	[FUSE_BATCH_FORGET] = "BATCH_FORGET",
+	[FUSE_READDIRPLUS] = "READDIRPLUS",
+	[FUSE_RENAME2]     =  "RENAME2",
+	[FUSE_COPY_FILE_RANGE] = "COPY_FILE_RANGE",
+	[FUSE_LSEEK]	   = "LSEEK",
+	[CUSE_INIT]	   = "CUSE_INIT",
+	[FUSE_TMPFILE]     = "TMPFILE",
+	[FUSE_SYNCFS]      = "SYNCFS",
+	[FUSE_GET_FMAP]    = "GET_FMAP",
+	[FUSE_GET_DAXDEV]  = "GET_DAXDEV",
+};
+
 static struct kmem_cache *fuse_req_cachep;
 
 static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
@@ -566,6 +620,13 @@ ssize_t __fuse_simple_request(struct mnt_idmap *idmap,
 	}
 	fuse_put_request(req);
 
+	pr_debug("%s: opcode=%s (%d) nodeid=%lld out_numargs=%d len[0]=%d len[1]=%d\n",
+		  __func__, opname[args->opcode], args->opcode,
+		  args->nodeid,
+		  args->out_numargs,
+		  args->out_args[0].size,
+		  (args->out_numargs > 1) ? args->out_args[1].size : 0);
+
 	return ret;
 }
 
-- 
2.49.0

