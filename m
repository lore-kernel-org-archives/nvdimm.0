Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CCA398714
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800099; cv=none; b=vEJOeALsbjo6PXPQ8qr1cw7XOxR60v6AmpvDxEtng7NmoNDbaNwFX6a4cpNq+PNbz9QdvO2avGsG9+BnaoKuPxJa5xqF56uS/9zOLwK/Jz1tfhpF8r0MD8KpP3/steBLNID+VCgPf/9V/OYMnfNkUTxGcIWx9CzS/huvEZao2Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800099; c=relaxed/simple;
	bh=vRum9MOJIbnk5V10fy2a3HtDPMHvk45XsqC1Kt9gTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTOjTdz7hrjUE20xRIxHWqCuXpEgSkEn/BibmfH5CrE44YtMIQZJpAGc5FB5hIdupPIAANtgU7w88PaeMmL9/adCyv4SNHq9h5pcNWG3stsK5p15uCPudlyL4I67+EV+Y9ItFCnQnTm6ncNah7hx62GKt4//LBt/9Tr9TTuPRA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QAYXfBl6; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QAYXfBl6"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4537407477aso1408957b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800094; x=1768404894; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AgHZ9K8s1Kd63AAlsULJaWt5wwYk3G9jV8eBPFKbz1s=;
        b=QAYXfBl6ugWhBkkqOGi/fP4JiK89gmkDRTUdN29AHjHhW/VEj5Zz49Ervd/7CoFvFU
         8BOVq+j/hgzuw746CqM8mzgojQS4jDIw9iJxaAh8R2alohQ4VC1LFc79cNwtaELw49wj
         CIPtO9DHB2+cjjw34u/j55PxftouOmGMsqNbQsMDrDrC01XlT4Qe0/v6aZcF4NTjiawJ
         DENfHZyyEulz8/BA/MuqTdZAqHfzfwApVXCbh27lImJtOSCENDBFn0+1nhSGAUfuFcBV
         tlnX1o2/cA1/0y6C4dmzkNd9/uAqbZgJhup0v9ScIlPlM36TL1EtQu3Xyar6QHEyC1I/
         UJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800094; x=1768404894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgHZ9K8s1Kd63AAlsULJaWt5wwYk3G9jV8eBPFKbz1s=;
        b=jllC8Tr0zZffh7l9ALnFJn+SuKgWbXJul+GzFHAAUSm1nsmA4m50skz/hlSEb1FQ8S
         V0XY92e/Tb1NRzKXUpBoPPbjcZQWB+bqeVDzg/705nZdjzwl5LbnS2KnfRUiZExJe17/
         s17eRdVCFyfa807eOTks5viUJ8BPbEnYVS0WhqCcxy2yi3ZZCBj/wm8cbHDlHGgBusEp
         2bnXhP2lhEpYAVZR9B89SeX2iX4mMh3/VPuzWbjeh3tCPWFmdRQ1W9VGgZLcGJBEtjTZ
         TipclObLNM+uZUMCPMsjGLlkrSbqhH2Ca9DJVSrc6BksaeDKTLMmYlLDUgxJRQ7qAQw4
         C5CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLhdR/Wg6i77hoDOXQWTMXISFXbE8YXm5kwrfhXLn5egLLGMlJnD1wpy3469vbU5OD1W2tWEQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0YAnN5RqXgyYScb1w13QZASbCJ+SQGKFLQ5qoxAl8DnplAKQh
	NAceyjlHBSrF0hoCsvesqAIw99UYmw/8V/QZZ5dNYaUw2qoIjtXZXnBn
X-Gm-Gg: AY/fxX4y2xUjDFsDNLy3Qo9CJ2935vLhHq36eziPNpm1hSOHhGPoeTZ9NJ630zlpm2a
	wV+pwDrhvT4g+b4uhD2/WjsUrKu1KjlzK1p2Ldll+QnRUn+TUJrdBKH3UclMU15XFo5PY7B8agB
	hMC4EwwKWrMUIgf96oMueJyIFUwsEt+oMcEqHxEVSyiybXRw3aTbPRnpZ4cv4wMTUFyvAEYwpgc
	umgmOMhVzPX0A/4eHWZdycTFaqom2DTQG2QpWVYj5Q+IGMBvmGBiVAWNiczs1X8tRJgQKU97ry9
	cJEdLUGz2zgJfDy7oorLyksjwK4MJkx2gz851lpYLczu+3clTbQlg2DRF2wVEh9m13S2eXnHZJF
	qTh4mg0YlaNfokPOc7KlFQudLTaonujZatTZbjrDip0VgY08dtRmtrXDzU6FonnHX1iuem+ZVIV
	yR3q1TuKiG+owNReYwXF7dLbrGsrgsECi5aSa5uuRN6ZInZs7hGp3KUfA=
X-Google-Smtp-Source: AGHT+IEctONtJN8X6RkDy3vlMMfCQL9fRHlA6U9Vq5ZhSHzcHAHtRbTqbeZMB15NbJe9BeCbtXIxAQ==
X-Received: by 2002:a05:6808:16a2:b0:450:340:2693 with SMTP id 5614622812f47-45a6bee4000mr1183862b6e.42.1767800094073;
        Wed, 07 Jan 2026 07:34:54 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm2398424b6e.4.2026.01.07.07.34.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:53 -0800 (PST)
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
Subject: [PATCH V3 2/4] fuse_kernel.h: add famfs DAX fmap protocol definitions
Date: Wed,  7 Jan 2026 09:34:41 -0600
Message-ID: <20260107153443.64794-3-john@groves.net>
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
2.49.0

