Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76D139340A
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800058; cv=none; b=k++4cdGgCpCrIzPkh6FlvdHvTCMMPC4KrArQzi0XvvSS2NSN4Hq/A1u6cM+eRhPJPenLauZXe0u4TvQ3lrNRUqCCQhAPC9kAs5/Njvy/O+tER9f5ZO5VABsjDEtw/HxlrzM97SNjB5t6tBoCROW4T04Ulfx6WqnwpLKI/l05bG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800058; c=relaxed/simple;
	bh=duMgT7bdepQi0N/0JRMDje1jrbfU026HoAJQ/LhmjsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4Na9lAdN5v4jni8Mk2zTeLtKafv4kh1jop0LvFEKgQX6UuVCv58O5G0etqcX4awp8V6m2JKyCHkDwqEGfNIGBEdxYEZNqQrybhmAWSnq6OJfCXdYxKFuc4uXVOPPaj/RH1qocgocSoHBsqheZcO35sQw4kv0z16GcY3MZhucHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kXdiDqO5; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kXdiDqO5"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-455a461ab6eso929812b6e.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800056; x=1768404856; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvpvNKjuheK6bNSoVUbkdsgMg3JblqnFA9UfzPx8aEA=;
        b=kXdiDqO5YQZfUegyQGZJ4KZP/85TUBTCYrDF4yRxWTStfBNHiv3+iMe0XDBlmMk4f/
         F7jQPe0cs9TefNBu1hn4gz/1csAT0Q0LFxokUUuL5G3Z+Q8sCPsnV8HL64FtDy7C+5H6
         2/MaN9cyNKCMExuk95NsoMbk+bHPPBHhqlidslzWehmwq/GpUNcWD6GZ2Hik5QuCiiuk
         QrhJkfU5LRVKhaIdCsyw3/P/qtJq7aYc/+mKkEEolzbP1JKtTFxV3BDsZkTe2UrET14Z
         L9ZWtmcEFZfxBIgnTHwBVNDkg+kmPJLx+Nwivb2sIX0OkWXGa7vE7YKw1xE/goCgTdZl
         46eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800056; x=1768404856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DvpvNKjuheK6bNSoVUbkdsgMg3JblqnFA9UfzPx8aEA=;
        b=iCQ0LO6Y9oxeL7GsZzGhCnRjrq3No8hSv0aRhJg9Kul4TGRQnViqaSSVtI8cRotklv
         Bg33pOUGoFCaGwKZepOXEBhinbjEo0m0Z7pGEk59JrJ96KyiqeMGHRGj8BrvMx5AJJkj
         WBUARvqJRA5e2lyhrGNYPtiIqb9H13mf9u2CVef9ar0Jfe24uOk0RNGT3q888hJybekL
         fPCcNqWOMBEpcXPmiWVrvMQNoIHO/4hvCFaUrkF1R026NlP/U5D6T9W6dn9koU/GBNLb
         77rOPbKgfRFprcdBcVzMyHm9HZOO/v5lsrCndoJjZtpttaugNHGFAb6fq3+N35K6711Y
         CKMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW50/vmhVg+rq1HDvHeBf6SHVtt/FDRfdvyUpz7mj1ADuRhg2T56HBDNzx7FD0mI0H3XekkQ5o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyEBD0m/niSJwl2z3xVmRfv5pYszshyKSAABXpElyfKi8zbFOJE
	1ybEeMexdQS+DlCwoJu1jaz35UM6ol8jB9JiSmhM//+Br6HIvDuj9gOx
X-Gm-Gg: AY/fxX7OlgCKO94OOhHuoOe+PO/P7lsFj1IctjMPjbInRhC3RhuWDm/kebe4I3sDCyw
	1RUXJqx7taIYph7+h9P8u5Z7TyjAZxxGjl5YRI2WjsA0gqTOfziOjNJqdF2dJUEfrJf8eO7vIXT
	RsXQRC4V6owMoWp0mgmh9RoPD3M8u+6W3j0yHqx2zJEnHQaLalUZcV04QfUzXb/TYT/iB+nxITw
	KqsMtFf7b/Sd4DOYDeQpTmXsoYRwRTIPK7dwnK28s/Z+mg6Uw4Mfbdz47QfkK34JKwm8vEeZ+uF
	FPDxOiXxwJgiWrObD3M9X+rRkC2xLP/vU50belZ7gvDIgCi8a2jGkMXhVae0K7YZ8D/sOq0IjAG
	0UlrpVq7oA0fzb4/jw+HVkTOf2Q8gbSJjr+I7uUQCmCbAdLoXWcelOU3PE5Pklc5m67s9MqPCyJ
	rAgQlNv/soBwNqspMejfUcClcbnQ0dwmkfVcuATLbzXlsP
X-Google-Smtp-Source: AGHT+IH/ERiPsB3hUWVBd46Q+0Jhbm8DG3SRCThraKFEJm6cv2tmGnQM3WnzxXsB8duHZXMQqQd33g==
X-Received: by 2002:a05:6808:c1f2:b0:44f:e49e:8e42 with SMTP id 5614622812f47-45a6bef202emr1051295b6e.48.1767800055714;
        Wed, 07 Jan 2026 07:34:15 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:15 -0800 (PST)
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
Subject: [PATCH V3 12/21] famfs_fuse: Basic fuse kernel ABI enablement for famfs
Date: Wed,  7 Jan 2026 09:33:21 -0600
Message-ID: <20260107153332.64727-13-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
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
 fs/fuse/inode.c           | 6 ++++++
 include/uapi/linux/fuse.h | 5 +++++
 3 files changed, 14 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 17736c0a6d2f..ec2446099010 100644
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
index c13e1f9a2f12..5e2c93433823 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -240,6 +240,9 @@
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
  *  - add FUSE_NOTIFY_PRUNE
+ *
+ *  7.46
+ *    - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
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
2.49.0

