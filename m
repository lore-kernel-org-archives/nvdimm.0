Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C528837FF73
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427077; cv=none; b=MFIMeII4hb3kyio/saoi5HzTcIC9jo0utNORqdwdcnASpxTytrhnrhOKf0gbexdC3lAPXSrhed4oU7yUbzA08+nVymbrSzM9YYqubUDC85a8ki7rlc+Tt6EMTrV/S7UVBK0UmV/ESjNvUiBHAl8uKL0fZc4qZ9LbhTF+hMHb5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427077; c=relaxed/simple;
	bh=1w3TFMU+/vaY5sE0p34dspzPaMtaVRyYHuyJ2SCiYhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNxg+pbyZQ2RyBuHhoYsF+RSmqBRxNbBqLW4c7hSmQbkC7yPlRpaWo5zen3B014PprI+/J2OtdED5CgO6AGOJ5Ko7roOnv08KEgtigduT7sbafHMlWAWT2nEx5s74hORcwt3nkZAXShloNpPySkNVsUXaUwUoqVryCHHb10b9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dV4iCQq3; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dV4iCQq3"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c750b10e14so119930a34.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768427056; x=1769031856; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mT0uh5MNFRoQeuCeqp5qm4knejXoLQDh1fSqDovZOWM=;
        b=dV4iCQq3ugGha+IypWm6QHD47KHVgWw1+9C2fM04ll2OguTni4krd6o6HZ47377oN5
         s/fuyg4HrCaggKOsR+pN+h7/YtV9sF14y+KhdOCsRHYZO5KEuGmY2nXoq3H34qYohhD2
         XG5J9oMvwCrSJwNp7wGnd2ylXyrXz9A0ZXRGlOjaV1AQAQlgGtXhEEUz7h8rgDtLpFtO
         8/X6tx5+N1N4FDCR8WRgtrdRcXaIDKRiolU9NMX38Fvs46CtYgvQkQSJeS1acZ4gOyhe
         KUg3+SbXLr48TH4vfJp0rv54z4iWf/PHvyZN/+k7rXWKteKxHIvS1UmcU8lw3wwkBCH/
         y40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427056; x=1769031856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mT0uh5MNFRoQeuCeqp5qm4knejXoLQDh1fSqDovZOWM=;
        b=vADMkr5vwQN6xwRkDwhTy2KYsvnXZgJyHV0TNeihYBI/Vl3G38OOtgjVQVaqc7fDLW
         HI+UMK1mM77LbBxsSd9EysIKw2yQX1C079Jgaq2EMxe7Yi75vCpWsed3GyyBSrhw8MHF
         sriovnXF5RSnoOCflnELAm3+HUEjlA0fDxeZ8vVbD86oPheu+QBBPudmgDX7IWYM3mto
         r1clWW83GxsnPG8d3l7aY9vOkjKMBcC36blH8UZx1p/+WK6Po+0KgGQs64JHkn+i+gi4
         U7c/MJsJPOVn24bCCvdEkVAkNgDXNZR6PymhYIC3q9yv5UsnQI2AslWPOvrPzZy/sIHp
         LiBw==
X-Forwarded-Encrypted: i=1; AJvYcCWbPHsHj9Dp8EHWO23QVe9l9fGKv3/4U55SJAas0PmQH1aI0NRiuSPB1hXRyb1//5EXR9xW8rA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjuN6rVYjv467tguQzWoQOMpK/As3i5hJhsx8MMqclgKhwPKWm
	hlRP5N8KhXV2EUsnPBPtA6CEHCOFvHdyKu+rsZwE9gSCCAcDV609Lr0P
X-Gm-Gg: AY/fxX559KHl3mZI9qjR4NIEAC1BUemr8XvG3p9icSSeChN3PdckCu1aLhUoiIjq62O
	a7GGUrEjlVGdjXylmrE3AMtWgE0kIPSXTTaVRbIIvVIZArjHgyz5LIuWg1cj/8h6q2Jg00Caucc
	7QuuabufwFoTDaY/crVqdxrZZhKH4f/OqkBFq1LSRlKewnQauoBrLkiz5HpN7jiFJj1U33YvUId
	zrDz1pLFL4N4YBxQZ8NasCpPF8KpuTraAvv55qxGdVnMJa3K9u1iNJYXcGoNysAg1+Hvxj6nkjq
	clIvPLUjeOwEUsVNz/fiDf0/BCuCwh183Z85q6BRXrdrH/4PWPgcmfl5aBa4fQ6Uw7p5UvOJ4IX
	lVqeKACPgzCX+LukhAjcpXtuNfI7UHLv4ENzbVAYza8TgrZRmPFusg1ZqEwMYgfHSF9wIBUyF5b
	ImqFqFc3e5FcCDFutdUoPFWFDd6Nr4kQMiBU9CuHsbzvt+
X-Received: by 2002:a05:6830:8410:b0:7c7:65f4:1120 with SMTP id 46e09a7af769-7cfcb65e6efmr1926180a34.23.1768427056116;
        Wed, 14 Jan 2026 13:44:16 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfcd061ac6sm1958801a34.13.2026.01.14.13.44.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:44:15 -0800 (PST)
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
Subject: [PATCH V4 2/3] fuse_kernel.h: add famfs DAX fmap protocol definitions
Date: Wed, 14 Jan 2026 15:43:06 -0600
Message-ID: <20260114214307.29893-3-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114214307.29893-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114214307.29893-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add FUSE protocol version 7.46 definitions for famfs DAX file mapping:

Capability flag:
  - FUSE_DAX_FMAP (bit 43): kernel supports DAX fmap operations

New opcodes:
  - FUSE_GET_FMAP (54): retrieve file extent map for DAX mapping
  - FUSE_GET_DAXDEV (55): retrieve DAX device info by index

New structures for GET_FMAP reply:
  - struct fuse_famfs_fmap_header: file map header with type and extent info
  - struct fuse_famfs_simple_ext: simple extent (device, offset, length)
  - struct fuse_famfs_iext: interleaved extent for striped allocations

New structures for GET_DAXDEV:
  - struct fuse_get_daxdev_in: request DAX device by index
  - struct fuse_daxdev_out: DAX device name response

Supporting definitions:
  - enum fuse_famfs_file_type: regular, superblock, or log file
  - enum famfs_ext_type: simple or interleaved extent type

Signed-off-by: John Groves <john@groves.net>
---
 include/fuse_kernel.h | 88 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index c13e1f9..7fdfc30 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -240,6 +240,19 @@
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
  *  - add FUSE_NOTIFY_PRUNE
+ *
+ *  7.46
+ *    - Add FUSE_DAX_FMAP capability - ability to handle in-kernel fsdax maps
+ *    - Add the following structures for the GET_FMAP message reply components:
+ *      - struct fuse_famfs_simple_ext
+ *      - struct fuse_famfs_iext
+ *      - struct fuse_famfs_fmap_header
+ *    - Add the following structs for the GET_DAXDEV message and reply
+ *      - struct fuse_get_daxdev_in
+ *      - struct fuse_get_daxdev_out
+ *    - Add the following enumerated types
+ *      - enum fuse_famfs_file_type
+ *      - enum famfs_ext_type
  */
 
 #ifndef _LINUX_FUSE_H
@@ -448,6 +461,7 @@ struct fuse_file_lock {
  * FUSE_OVER_IO_URING: Indicate that client supports io-uring
  * FUSE_REQUEST_TIMEOUT: kernel supports timing out requests.
  *			 init_out.request_timeout contains the timeout (in secs)
+ * FUSE_DAX_FMAP:        kernel supports dev_dax_iomap (aka famfs) fmaps
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -495,6 +509,7 @@ struct fuse_file_lock {
 #define FUSE_ALLOW_IDMAP	(1ULL << 40)
 #define FUSE_OVER_IO_URING	(1ULL << 41)
 #define FUSE_REQUEST_TIMEOUT	(1ULL << 42)
+#define FUSE_DAX_FMAP		(1ULL << 43)
 
 /**
  * CUSE INIT request/reply flags
@@ -664,6 +679,10 @@ enum fuse_opcode {
 	FUSE_STATX		= 52,
 	FUSE_COPY_FILE_RANGE_64	= 53,
 
+	/* Famfs / devdax opcodes */
+	FUSE_GET_FMAP           = 54,
+	FUSE_GET_DAXDEV         = 55,
+
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
 
@@ -1308,4 +1327,73 @@ struct fuse_uring_cmd_req {
 	uint8_t padding[6];
 };
 
+/* Famfs fmap message components */
+
+#define FAMFS_FMAP_VERSION 1
+
+#define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */
+#define FUSE_FAMFS_MAX_EXTENTS 32
+#define FUSE_FAMFS_MAX_STRIPS 32
+
+enum fuse_famfs_file_type {
+	FUSE_FAMFS_FILE_REG,
+	FUSE_FAMFS_FILE_SUPERBLOCK,
+	FUSE_FAMFS_FILE_LOG,
+};
+
+enum famfs_ext_type {
+	FUSE_FAMFS_EXT_SIMPLE = 0,
+	FUSE_FAMFS_EXT_INTERLEAVE = 1,
+};
+
+struct fuse_famfs_simple_ext {
+	uint32_t se_devindex;
+	uint32_t reserved;
+	uint64_t se_offset;
+	uint64_t se_len;
+};
+
+struct fuse_famfs_iext { /* Interleaved extent */
+	uint32_t ie_nstrips;
+	uint32_t ie_chunk_size;
+	uint64_t ie_nbytes; /* Total bytes for this interleaved_ext;
+			     * sum of strips may be more
+			     */
+	uint64_t reserved;
+};
+
+struct fuse_famfs_fmap_header {
+	uint8_t file_type; /* enum famfs_file_type */
+	uint8_t reserved;
+	uint16_t fmap_version;
+	uint32_t ext_type; /* enum famfs_log_ext_type */
+	uint32_t nextents;
+	uint32_t reserved0;
+	uint64_t file_size;
+	uint64_t reserved1;
+};
+
+struct fuse_get_daxdev_in {
+	uint32_t        daxdev_num;
+};
+
+#define DAXDEV_NAME_MAX 256
+
+/* fuse_daxdev_out has enough space for a uuid if we need it */
+struct fuse_daxdev_out {
+	uint16_t index;
+	uint16_t reserved;
+	uint32_t reserved2;
+	uint64_t reserved3;
+	uint64_t reserved4;
+	char name[DAXDEV_NAME_MAX];
+};
+
+static __inline__ int32_t fmap_msg_min_size(void)
+{
+	/* Smallest fmap message is a header plus one simple extent */
+	return (sizeof(struct fuse_famfs_fmap_header)
+		+ sizeof(struct fuse_famfs_simple_ext));
+}
+
 #endif /* _LINUX_FUSE_H */
-- 
2.52.0

