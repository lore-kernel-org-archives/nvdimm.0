Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB842399037
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800104; cv=none; b=ACfberUNicUO0gYiJvC1J9kNCYbuLEqQhi3dhTzO8iUkTFeeAAy/D7Q2wH74LKukVS4+jh9rfh4GUG/AObYS4rhXt1ChW5IAXM2hzYVeuZrcTLuiQfybvGbKqOjH/6dFsWfiU/NFy6SVj4tUyCHnpavQckspwFm/rPzYWjUD44g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800104; c=relaxed/simple;
	bh=HM4lKamXQwEUZnRqp2/mgy4o0pjN0zbCyAQ9KEkrnNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuXhDV0ccsiBAiYx1NONQ7GXrAlIIUpSNGPBXO8fZ9WaqQn1TKavRtoZddh9lUsrNd2XFzdG+iGT1b33hOer943hQPC792ysxzRt/JOEBUM+6m6cBlA1a003HxddGigHpUdFOWCebWxjB4uT8RpWggOJs4416UxCt0wSCzchM9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VnhynAm6; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VnhynAm6"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-450b3f60c31so1049992b6e.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800099; x=1768404899; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OPrNuirfi0NELPHMFcu/1KlJClDuCwOT8DJm2N/JJag=;
        b=VnhynAm6kO50UjHrHKxgeVUcEECwJOsE9bisPkVB6agES7553phsq5n0PJjYgTeNao
         ub85TFv6sp/Z+Adp/LejJbMmhJrzUS8yowt/VBfpXut28khvLmHOpA+1zp10KdMXzAAc
         K+rZVZbX1ZgUd/AG8XjUEPLYU8/xM2EsFGSI2FcIb0gPF2ShVr6Gd/eT3VJYnT3oSueB
         Ezs37se54UDKB/MgDvsXBgGGp2rd43+/utvgfK8NKjyiAtqFfbTkHyUHjGja6GM5yL9t
         Kjh0iMBkRyh0vD/6ZAQlJKc8uIL/g7frTI3VrbDiqiyVWy7phuGZoY85K1X8AC7Viv3k
         A3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800099; x=1768404899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OPrNuirfi0NELPHMFcu/1KlJClDuCwOT8DJm2N/JJag=;
        b=B7bswF8l63mXa120DWUZeiNv32Xhn82XHbTVUmLLC5n44SxEhIsQr2gfluOusnndP/
         PiHQYw2ucndoQhub5xRwtRagIgMY+95DjR8+ZFKRXQtf3NpPX7uu/iB7w2ICaWo/oXfv
         jqEl74PkQbiOzj0R9t0rLKU9L/9U2WbljBRlSTC+93TbfbHQxQPS2uZw2xcgytaJwuC6
         1igNoJtEtLW+gKMPxgoIhzLKLSEFyjc5Z1jjpUm0Flt06D9SyujukXOCMePFyTQphsud
         2Y9qIbIZuPuXKqQzbSyGku4I22b5fib5DgqJMP70o2C9tKoEYicHpFVn/1ct1xi+1kzS
         ZXbA==
X-Forwarded-Encrypted: i=1; AJvYcCU6NdA3d3QCpFDwKCoiKXfBKXhmeu4nR8QfGEk35OezJuUr79eX8zVNkLqniCosWN7Oe4bP9PQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtdrT/TuPIkQ2I011MtBSFhY2kHlYSSgB5gvaISNbJPjrySaHt
	y5nV0kmBNnBiFhviwh6Di2CAu8rFBGDvwgbc4eBQhTuBqG+3kweOA+nV
X-Gm-Gg: AY/fxX4ZZtsbRLqSCcE4Gs37dvTy9A2OquUBfSN2M3gWHlJvMT126a8gaAXi2/je23r
	sNTlclYKFwzRsR4EkSZ7jZoUoQnvdFvfxTHxsh3WrouwyVOGHcF6MTn1OEh7TI/QE4ZTS0rin9i
	Y7ipYeIyuHTYwUlES0VyvUt83FXd6lB2ynStofTWtcRRZW8gBqh3asaX/r5oaqRNN6v5ue8V0m/
	T/qPUvQZ9S3G7vQ4W7hxmYYrW0t9nI7LL9JnCrDTb7o8FJ1JvbGByHizXJDZSi4gEWldHXhLoj9
	6qdCFGmAqkHMV7NMvmpK4pkZ/SkH8MI0JK1Khtm+LSXn8ROnZrR8MiTRYCTkK2vX/ZDl1qLqIYS
	ySbb4QK0MGche1nqN123Lj+dVH7tDTOrms4VmbuGUuNs/bPZSQDcSKW7R2WTbXmQTxeZbukzNbX
	KkBE9c4nUJk7TrTqnApDWpSOKFeTSc2GRnPptOFXdvpPcY
X-Google-Smtp-Source: AGHT+IFUAwqlKPFZxOP8hKjN3yWWiewXwLTUZV8MqKGeOfhFctvOkPQ3NvPc2aDZQl4je/LWLvX3LQ==
X-Received: by 2002:a05:6808:3206:b0:450:c877:fd6f with SMTP id 5614622812f47-45a6befa901mr1333720b6e.67.1767800099405;
        Wed, 07 Jan 2026 07:34:59 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm2398424b6e.4.2026.01.07.07.34.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:59 -0800 (PST)
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
	Chen Linxuan <chenlinxuan@uniontech.com>,
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
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V3 4/4] fuse: add famfs DAX fmap support
Date: Wed,  7 Jan 2026 09:34:43 -0600
Message-ID: <20260107153443.64794-5-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153443.64794-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153443.64794-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new FUSE operations and capability for famfs DAX file mapping:

- FUSE_CAP_DAX_FMAP: New capability flag at bit 32 (using want_ext/capable_ext
  fields) to indicate kernel and userspace support for DAX fmaps

- GET_FMAP: New operation to retrieve a file map for DAX-mapped files.
  Returns a fuse_famfs_fmap_header followed by simple or interleaved
  extent descriptors. The kernel passes the file size as an argument.

- GET_DAXDEV: New operation to retrieve DAX device info by index.
  Called when GET_FMAP returns an fmap referencing a previously
  unknown DAX device.

These operations enable FUSE filesystems to provide direct access
mappings to persistent memory, allowing the kernel to map files
directly to DAX devices without page cache intermediation.

Signed-off-by: John Groves <john@groves.net>
---
 include/fuse_common.h   |  5 +++++
 include/fuse_lowlevel.h | 37 +++++++++++++++++++++++++++++++++++++
 lib/fuse_lowlevel.c     | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/include/fuse_common.h b/include/fuse_common.h
index 041188e..e428ddb 100644
--- a/include/fuse_common.h
+++ b/include/fuse_common.h
@@ -512,6 +512,11 @@ struct fuse_loop_config_v1 {
  */
 #define FUSE_CAP_OVER_IO_URING (1UL << 31)
 
+/**
+ * handle files that use famfs dax fmaps
+ */
+#define FUSE_CAP_DAX_FMAP (1UL<<32)
+
 /**
  * Ioctl flags
  *
diff --git a/include/fuse_lowlevel.h b/include/fuse_lowlevel.h
index d2bbcca..55fcfd7 100644
--- a/include/fuse_lowlevel.h
+++ b/include/fuse_lowlevel.h
@@ -1341,6 +1341,43 @@ struct fuse_lowlevel_ops {
 	 */
 	void (*statx)(fuse_req_t req, fuse_ino_t ino, int flags, int mask,
 		      struct fuse_file_info *fi);
+
+	/**
+	 * Get a famfs/devdax/fsdax fmap
+	 *
+	 * Retrieve a file map (aka fmap) for a previously looked-up file.
+	 * The fmap is serialized into the buffer, anchored by
+	 * struct fuse_famfs_fmap_header, followed by one or more
+	 * structs fuse_famfs_simple_ext, or fuse_famfs_iext (which itself
+	 * is followed by one or more fuse_famfs_simple_ext...
+	 *
+	 * Valid replies:
+	 *    fuse_reply_buf  (TODO: variable-size reply)
+	 *    fuse_reply_err
+	 *
+	 * @param req request handle
+	 * @param ino the inode number
+	 */
+	void (*get_fmap) (fuse_req_t req, fuse_ino_t ino, size_t size);
+
+	/**
+	 * Get a daxdev by index
+	 *
+	 * Retrieve info on a daxdev by index. This will be called any time
+	 * GET_FMAP has returned a file map that references a previously
+	 * unused daxdev. struct famfs_simple_ext, which is used for all
+	 * resolutions to daxdev offsets, references daxdevs by index.
+	 * In user space we maintain a master list of all referenced daxdevs
+	 * by index, which is queried by get_daxdev.
+	 *
+	 * Valid replies:
+	 *    fuse_reply_buf
+	 *    fuse_reply_err
+	 *
+	 * @param req request handle
+	 * @param ino the index of the daxdev
+	 */
+	void (*get_daxdev) (fuse_req_t req, int daxdev_index);
 };
 
 /**
diff --git a/lib/fuse_lowlevel.c b/lib/fuse_lowlevel.c
index 413e7c3..c3adfa2 100644
--- a/lib/fuse_lowlevel.c
+++ b/lib/fuse_lowlevel.c
@@ -2769,7 +2769,8 @@ _do_init(fuse_req_t req, const fuse_ino_t nodeid, const void *op_in,
 			se->conn.capable_ext |= FUSE_CAP_NO_EXPORT_SUPPORT;
 		if (inargflags & FUSE_OVER_IO_URING)
 			se->conn.capable_ext |= FUSE_CAP_OVER_IO_URING;
-
+		if (inargflags & FUSE_DAX_FMAP)
+			se->conn.capable_ext |= FUSE_CAP_DAX_FMAP;
 	} else {
 		se->conn.max_readahead = 0;
 	}
@@ -2932,6 +2933,8 @@ _do_init(fuse_req_t req, const fuse_ino_t nodeid, const void *op_in,
 		outargflags |= FUSE_REQUEST_TIMEOUT;
 		outarg.request_timeout = se->conn.request_timeout;
 	}
+	if (se->conn.want_ext & FUSE_CAP_DAX_FMAP)
+		outargflags |= FUSE_DAX_FMAP;
 
 	outarg.max_readahead = se->conn.max_readahead;
 	outarg.max_write = se->conn.max_write;
@@ -3035,6 +3038,30 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
 	_do_destroy(req, nodeid, inarg, NULL);
 }
 
+static void
+do_get_fmap(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
+{
+	struct fuse_session *se = req->se;
+	struct fuse_getxattr_in *arg = (struct fuse_getxattr_in *) inarg;
+
+	if (se->op.get_fmap)
+		se->op.get_fmap(req, nodeid, arg->size);
+	else
+		fuse_reply_err(req, -EOPNOTSUPP);
+}
+
+static void
+do_get_daxdev(fuse_req_t req, fuse_ino_t nodeid, const void *inarg)
+{
+	struct fuse_session *se = req->se;
+	(void)inarg;
+
+	if (se->op.get_daxdev)
+		se->op.get_daxdev(req, nodeid); /* Use nodeid as daxdev_index */
+	else
+		fuse_reply_err(req, -EOPNOTSUPP);
+}
+
 static void list_del_nreq(struct fuse_notify_req *nreq)
 {
 	struct fuse_notify_req *prev = nreq->prev;
@@ -3470,6 +3497,8 @@ static struct {
 	[FUSE_LSEEK]	   = { do_lseek,       "LSEEK"	     },
 	[FUSE_STATX]	   = { do_statx,       "STATX"	     },
 	[CUSE_INIT]	   = { cuse_lowlevel_init, "CUSE_INIT"   },
+	[FUSE_GET_FMAP]	   = { do_get_fmap, "GET_FMAP"       },
+	[FUSE_GET_DAXDEV]  = { do_get_daxdev, "GET_DAXDEV"   },
 };
 
 static struct {
-- 
2.49.0

