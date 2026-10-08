Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CE9435535
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791458423; cv=none; b=kEehDKfi9AR/+GlkosKsFbi8jn13z0oTS3ukO6e7Q/YKjOrhF97++1wObV+GbbMxgaEmMWGHDa1U5v0E6ecBItRnWSXw27vJi2Ta9LxAGU3MwDCiJQIT7oIPc7qAumS7ZN3oggXfdAmLEfKNR63aTWHT6XJFeJzmIR9mz2O8nX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791458423; c=relaxed/simple;
	bh=+cGMmSe+crUjw1fz673MTOCVaoTBdP1tpqMVvtnAE6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=AuaR0Nd6AjjSMNHORszgyhM5ObIhEYthWceEA5QsPgZZwIcVxUWjOELMtB8hLHDCroNfPA1siDr1d2UOA4QRkoXkPvBRzGKWaR3mgGVxiiKdZ4Qg2/fahT8VZ0g7yNxLz7qG9gLc5RFMeZdeG16NR5lrunwfgrruEacpkm5ejLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ny9krqVb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ny9krqVb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791458421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAv2T/O52sHhyFcGWWs9qCelD6+CbSyPV8IV2DkgllI=;
	b=Ny9krqVbJQYqE6nUn+P4Rj6BDfaqDB/rQGoz0lQRuA8QOjXSlOYOjuKmPbgKiMetr7gU66
	Ve7WcVWSqXuwf74i83ME4rIqJqhGAH2THbu47CC45qctOIWC6gmAdCGZ6PI9JXen7y8UTy
	kXewn/Byy7jveNnFFbxioLzc1T9ATHA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-7f4gNOFxODC0p0H7lxaPyw-1; Thu, 08 Oct 2026 07:20:20 -0400
X-MC-Unique: 7f4gNOFxODC0p0H7lxaPyw-1
X-Mimecast-MFC-AGG-ID: 7f4gNOFxODC0p0H7lxaPyw_1791458419
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c315f2ff14fso67143966b.0
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 04:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791458419; x=1792063219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qAv2T/O52sHhyFcGWWs9qCelD6+CbSyPV8IV2DkgllI=;
        b=xNE6h8v+c5fpkcVYBxH9tbayE9vNKFsy7HnR68Ul09FhV87FK10ey3qhHUUa077K+U
         c4OyxUsHr0I+/NOL9rL5MyO/rnwbfgJafcTy1KkM6msP1RC+l6mLVPZcnRAAbHtFEiCn
         nJneCRoPGFECPOL/YtHDsaR7bQCJlN4ZtP/aRxQdkazRimrmVeTLyfyCUXcWRKhYmQRI
         JFkBCtGy/xMqApIvJ5dmWVM3+xuHrWgnuUPAq4R6RkgH6S9vD17RqhLaLs0C1ebVmhsZ
         MyOjpIX6+OtYZkKBrs2wl9lwU3q0NAo6JycpiBPvNlb21doFWvFRLf0Qd4NBJK0MhU/p
         cZ/g==
X-Forwarded-Encrypted: i=1; AKwUvBz2I+LxS8u2KApA6uJprXi2467Cu85h6gCGq5tC3YKTV4jzPj+9UfKtyYiW/soVcS9x6RVX4O8=@lists.linux.dev
X-Gm-Message-State: AFuF++nqW6F4dDsDdjCj2yC6/mjNFTFt/Zi2/ZIV0mMQLcBHbvCho50S
	iOHLAqHh3feaMRyQQCHduf2EwI715NTi4QBZmsmvaOjrbZ+ZvmBSCrgglw3HnVPcT1MYnRnexsA
	URu4SbrOjKa15YaaD6UDzlvUKJbXhPJbR3ZoZ2emIxdtendeVc7quGXIEWg==
X-Gm-Gg: AYBFou0F4NY+IeBhX0iD5Yw2Bo+jn4TamMthHABrNm2XoyXXbGS0MIeMdObFf+Wvqyp
	DFEoK93ULi/7oZACV921gTr68K/f1Oz93p9HLVbWLPutZ/ifd1U7ZCIlngHlZ1mSQnW9ThvG4Ac
	wzRtiQK2LP5slciRMCOtlncCSdzN9b1NhdVXdQPdf5fFejJnC25ej2qPGrTdP9/xRAVJBO4HbnH
	ZQkryxcb8IwqKrWuvLKx/+G/b7qI3sjGu4rzq0HWU+LERjBViusBTOSbAUp39ZBKgu6Mq2IWd8G
	CdK4Q0W8SuiCS71EafSwpPigCdbAQWjqfF1kMqykPB2JkSiRg+RlNnB0vMDTeJttXnwZfDeSeCU
	Wh8g/OtIPRT6QElvTn1JjVnEoQpvuzzEo5F/A9mMUBStwt8XuJB92rBkc
X-Received: by 2002:a17:907:d22:b0:c31:7a83:bd78 with SMTP id a640c23a62f3a-c3191dcd0afmr202469866b.27.1791458418723;
        Thu, 08 Oct 2026 04:20:18 -0700 (PDT)
X-Received: by 2002:a17:907:d22:b0:c31:7a83:bd78 with SMTP id a640c23a62f3a-c3191dcd0afmr202466366b.27.1791458418081;
        Thu, 08 Oct 2026 04:20:18 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c317c2fae53sm204251866b.49.2026.10.08.04.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 04:20:17 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v4 5/9] fuse: support opening 64 bit backing ID
Date: Thu,  8 Oct 2026 13:19:56 +0200
Message-ID: <20261008112004.1899560-6-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261008112004.1899560-1-mszeredi@redhat.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YC4vXmw8zHm96qHM-k9pCaS4oExhB1bWOa00vXoMfRI_1791458419
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add backing_id_64 field to fuse_open_out to allow opening files with
64-bit server-allocated backing IDs.

If the connection was initialized with FUSE_PASSTHROUGH_V2, the kernel
reads the backing ID from open_out.backing_id_64 instead of
open_out.backing_id.

The open reply is now variable-length for backward compatibility with
servers that don't send the new backing_id_64 field.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dir.c             |  3 ++-
 fs/fuse/file.c            |  6 +++++-
 fs/fuse/fuse_i.h          |  2 +-
 fs/fuse/iomode.c          | 35 +++++++++++++++++++++++++++++------
 fs/fuse/passthrough.c     | 28 ++++++----------------------
 include/uapi/linux/fuse.h |  2 ++
 6 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index f48fafccce4b..874ec7cfffb1 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -876,6 +876,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 	args.out_args[0].value = &outentry;
 	/* Store outarg for fuse_finish_open() */
 	outopenp = &ff->args->open_outarg;
+	args.out_argvar = true; /* compat */
 	args.out_args[1].size = sizeof(*outopenp);
 	args.out_args[1].value = outopenp;
 
@@ -885,7 +886,7 @@ static int fuse_create_open(struct mnt_idmap *idmap, struct inode *dir,
 
 	err = fuse_simple_idmap_request(idmap, fm, &args);
 	free_ext_value(&args);
-	if (err)
+	if (err < 0)
 		goto out_free_ff;
 
 	err = -EIO;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bde07948d1f0..5273957f0399 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -28,6 +28,7 @@ static int fuse_send_open(struct fuse_mount *fm, u64 nodeid,
 {
 	struct fuse_open_in inarg;
 	FUSE_ARGS(args);
+	int res;
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.flags = open_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
@@ -45,10 +46,13 @@ static int fuse_send_open(struct fuse_mount *fm, u64 nodeid,
 	args.in_args[0].size = sizeof(inarg);
 	args.in_args[0].value = &inarg;
 	args.out_numargs = 1;
+	args.out_argvar = true; /* compat */
 	args.out_args[0].size = sizeof(*outargp);
 	args.out_args[0].value = outargp;
 
-	return fuse_simple_request(fm, &args);
+	res = fuse_simple_request(fm, &args);
+
+	return res < 0 ? res : 0;
 }
 
 struct fuse_file *fuse_file_alloc(struct fuse_mount *fm, bool release)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index b1e450f096f6..89dedcb54ba7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1314,7 +1314,7 @@ static inline struct fuse_backing *fuse_inode_backing_set(struct fuse_inode *fi,
 #endif
 }
 
-struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id);
+int fuse_passthrough_open(struct file *file, struct fuse_backing *fb);
 void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing *fb);
 
 static inline bool fuse_is_passthrough(struct fuse_file *ff)
diff --git a/fs/fuse/iomode.c b/fs/fuse/iomode.c
index 1b8b267d0c0d..8b4774c80b11 100644
--- a/fs/fuse/iomode.c
+++ b/fs/fuse/iomode.c
@@ -165,7 +165,9 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_open_out *outarg = &ff->args->open_outarg;
 	struct fuse_backing *fb;
+	u64 backing_id;
 	int err;
 
 	/* Check allowed conditions for file open in passthrough mode */
@@ -175,18 +177,39 @@ static int fuse_file_passthrough_open(struct inode *inode, struct file *file)
 	if (ff->open_flags & ~FOPEN_PASSTHROUGH_MASK)
 		return fuse_EIO("conflicting open flags");
 
-	fb = fuse_passthrough_open(file, ff->args->open_outarg.backing_id);
-	if (IS_ERR(fb))
-		return PTR_ERR(fb);
+	if (!fc->backing_id_64) {
+		if (outarg->backing_id_64 != 0)
+			return fuse_EIO("64 bit backing ID set");
+
+		if (outarg->backing_id <= 0)
+			return fuse_EIO("invalid backing ID");
+
+		backing_id = outarg->backing_id;
+	} else {
+		if (outarg->backing_id != 0)
+			return fuse_EIO("32 bit backing ID set");
+
+		backing_id = outarg->backing_id_64;
+	}
+	fb = fuse_backing_lookup(fc, backing_id);
+	if (!fb)
+		return fuse_EIO("backing not found");
+
+	err = fuse_passthrough_open(file, fb);
+	if (err)
+		goto backing_put;
 
 	/* First passthrough file open denies caching inode io mode */
 	err = fuse_file_uncached_io_open(inode, ff, fb);
-	if (!err)
-		return 0;
+	if (err)
+		goto passthrough_release;
 
+	return 0;
+
+passthrough_release:
 	fuse_passthrough_release(ff, fb);
+backing_put:
 	fuse_backing_put(fb);
-
 	return err;
 }
 
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 313c8d7ffc09..4894842ad6d0 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -150,41 +150,25 @@ ssize_t fuse_passthrough_mmap(struct file *file, struct vm_area_struct *vma)
 
 /*
  * Setup passthrough to a backing file.
- *
- * Returns an fb object with elevated refcount to be stored in fuse inode.
  */
-struct fuse_backing *fuse_passthrough_open(struct file *file, int backing_id)
+int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 {
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fm->fc;
-	struct fuse_backing *fb = NULL;
 	struct file *backing_file;
 
-	if (fc->backing_id_64)
-		return ERR_PTR(fuse_EIO("incompatible backing version"));
-
-	if (backing_id <= 0)
-		return ERR_PTR(fuse_EIO("invalid backing_id"));
-
-	fb = fuse_backing_lookup(fc, backing_id);
-	if (!fb)
-		return ERR_PTR(fuse_EIO("backing not found"));
-
 	/* Allocate backing file per fuse file to store fuse path */
 	backing_file = backing_file_open(file, file->f_flags,
 					 &fb->file->f_path, fb->cred);
-	if (IS_ERR(backing_file)) {
-		fuse_backing_put(fb);
-		return ERR_PTR(fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file)));
-	}
+	if (IS_ERR(backing_file))
+		return fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file));
 
 	ff->passthrough = backing_file;
 	ff->cred = get_cred(fb->cred);
 
-	pr_debug("%s: backing_id=%d, fb=0x%p, backing_file=0x%p\n", __func__,
-		 backing_id, fb, ff->passthrough);
+	pr_debug("%s: backing_id=%llu, fb=0x%p, backing_file=0x%p\n", __func__,
+		 fb->backing_id, fb, ff->passthrough);
 
-	return fb;
+	return 0;
 }
 
 void fuse_passthrough_release(struct fuse_file *ff, struct fuse_backing *fb)
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 37e9559783c3..4b3904b3acb7 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -254,6 +254,7 @@
  *  - add FUSE_PASSTHROUGH_V2
  *  - add FUSE_DEV_IOC_BACKING_CREATE, struct fuse_backing_create_in
  *  - add FUSE_NOTIFY_BACKING_REMOVE, struct fuse_notify_backing_remove_out
+ *  - add backing_id_64 to fuse_open_out
  */
 
 #ifndef _LINUX_FUSE_H
@@ -841,6 +842,7 @@ struct fuse_open_out {
 	uint64_t	fh;
 	uint32_t	open_flags;
 	int32_t		backing_id;
+	uint64_t	backing_id_64;
 };
 
 struct fuse_release_in {
-- 
2.54.0

