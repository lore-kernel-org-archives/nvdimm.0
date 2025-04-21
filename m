Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99D51E1021
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199290; cv=none; b=C3ov54FaL2SlJJkPnvP5PqMv1ArIRLK6hrTwM+ltw39n+y1ltbSkR9FvNvWfXBpEin/KplVLU6Ecpg9mNg1iBYi3Z/gJFsySmTlmpPT63lafWBhLpYPCq3cXuGgF2U5DVMbMW1+bcpkb8/V41MlN63lsREqJP+J0DRk/K2u5Fb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199290; c=relaxed/simple;
	bh=MM13n9Dx+H0dyx/Dhthrh9y/E3RrzqwxsXubhn+xKog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDXu4sHIhFIqwUg9injW+TNzr4P4TiNKoE0s3YUZEsfSF+EJcWebu4b2Q+nve3R+mRDlIyJZD8caU9aF0E8z9lC6enFZk4hOZs3LzCA3AQT/xF96aDum1Piy2kPMRaFvCUlv7beL8V4LoFT7qJgbuROptceYuo6N8tcf5B1vO/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YydOFVVf; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YydOFVVf"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-72ecb4d9a10so2164160a34.3
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199288; x=1745804088; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8DZkuvGPoZyvYY7CYd1QUDkY8rgPO2CgXNLlDQXY+DU=;
        b=YydOFVVfdTC7Q1opwfOzAZ5VOUsnYUIGeoVVDITF+fN6hf+8ocKu1yU+F1ws6OKbcj
         StdypLronGrAX7vmY0/P15wxC/tXdmuIw41tzVRhJJVx4vC6jCSWDdnKqDre17NISPP4
         anF4UsNZ0uLO+LR39P3cdx7zo6B4N8EUySpFSZHTpy3LR3qvut7RwxHJPhbIkwo/mIZu
         wHkTAPM2Isw3G3bJJlO7eAg+QkIGwI2odMqfxDCrRtrUKg9yIfgXjVk4EQ8gsWXRj4f5
         yzyQ+euCQd84fgfMEDSE1qtxPtQxeiGAYEhOUq0LRHAKXfPlEPkvvcItpFmlnqnwqoLR
         NFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199288; x=1745804088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8DZkuvGPoZyvYY7CYd1QUDkY8rgPO2CgXNLlDQXY+DU=;
        b=AchavGC8go5waX+nFZVoA3xEMRFumQBzAbtrvNEW/w7Q1wizVAOflgk0PPkVx2cL1F
         MY6BjcihpUD+njJ+iOTZHly++LjZp2LPX+gsGeUHLZI7dWiY2p9Gj+8vRKxNwowh8rWE
         m2f7ydKhTgnOZ75Fdj/U5ySC4YwBkc43ZGeOaYRGecK/9NjOQv/rnixBv6u86LCI/0Lq
         wC/Hf2lsi+6M7MzG7sV6FMFe4yu53X2SKApD5dL07ba2mswsZpt6wOXbmHtTHuadcln3
         EPRQh60lri67D4268ShYkttd/Hbvp8XEtOCYWy0rxgsCvQDvDlBOw9T/iI+y0AInRRuS
         Fdeg==
X-Forwarded-Encrypted: i=1; AJvYcCWwUKB+8Opt1OuouRIVwY5Ma4c6NfRdHC8x0cvSVhMIIqS/MCiw3bkBuGSctUYuJTo5SuC5ZMM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHthZg7kToKKMoskb5G9hn0/mZf9JQUzXTiwMlaMsqfFbMtr/y
	XAR+yKE4FJ/umsy+wLfuDJHX8JFOwbMbAbFzBzVO4ObanMiKFZln
X-Gm-Gg: ASbGncuDnwkvti/TuR/EJaard7acF/uOJATJ/KpHuVdALLK5waAlXIGwsqt/gaoRu+5
	tVzbycC8dRmnfzI8OfwNXo+Ru3bgiNoK9FZIYAY+Ngev/h43veKPDuR/QFk+9bKCI50NDvyS/hi
	dsNgmRKbqB2qzeqn2SvA49cAQSwSqF8LBJcQ7oPNnIp56UL6+RGpHhLyGFCAbYJBQo3n9ByKTRc
	QVT7eD63ZOAeoR3lxuHf0kzpV7Evlwcv39Ya741XPoU1OJ5wLxCJsxuZAcro5Qf7TGoYZW38JzC
	MAk30l5sOY7uHoVgjbQO0oa/di0gUC/U+4+sCiQtMX4WqBOVk7FRCZh1m60yf+EpBN90cw==
X-Google-Smtp-Source: AGHT+IHRzHbpEH68+SMoh6y648whfivnAKStZ+3OUKcCZuorXP0l5a3+idNZSKoZxCVX8afRpNyjWg==
X-Received: by 2002:a05:6830:4193:b0:72b:8ec6:e533 with SMTP id 46e09a7af769-7300620c89fmr5674124a34.7.1745199287924;
        Sun, 20 Apr 2025 18:34:47 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:47 -0700 (PDT)
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
Subject: [RFC PATCH 17/19] famfs_fuse: Add famfs metadata documentation
Date: Sun, 20 Apr 2025 20:33:44 -0500
Message-Id: <20250421013346.32530-18-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250421013346.32530-1-john@groves.net>
References: <20250421013346.32530-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

This describes the fmap metadata - both simple and interleaved

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs_kfmap.h | 90 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index 325adb8b99c5..7c8d57b52e64 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -7,10 +7,90 @@
 #ifndef FAMFS_KFMAP_H
 #define FAMFS_KFMAP_H
 
+
+/* KABI version 43 (aka v2) fmap structures
+ *
+ * The location of the memory backing for a famfs file is described by
+ * the response to the GET_FMAP fuse message (devined in
+ * include/uapi/linux/fuse.h
+ *
+ * There are currently two extent formats: Simple and Interleaved.
+ *
+ * Simple extents are just (devindex, offset, length) tuples, where devindex
+ * references a devdax device that must retrievable via the GET_DAXDEV
+ * message/response.
+ *
+ * The extent list size must be >= file_size.
+ *
+ * Interleaved extents merit some additional explanation. Interleaved
+ * extents stripe data across a collection of strips. Each strip is a
+ * contiguous allocation from a single devdax device - and is described by
+ * a simple_extent structure.
+ *
+ * Interleaved_extent example:
+ *   ie_nstrips = 4
+ *   ie_chunk_size = 2MiB
+ *   ie_nbytes = 24MiB
+ *
+ * ┌────────────┐────────────┐────────────┐────────────┐
+ * │Chunk = 0   │Chunk = 1   │Chunk = 2   │Chunk = 3   │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 0  │Stripe = 0  │Stripe = 0  │Stripe = 0  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ * │Chunk = 4   │Chunk = 5   │Chunk = 6   │Chunk = 7   │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 1  │Stripe = 1  │Stripe = 1  │Stripe = 1  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ * │Chunk = 8   │Chunk = 9   │Chunk = 10  │Chunk = 11  │
+ * │Strip = 0   │Strip = 1   │Strip = 2   │Strip = 3   │
+ * │Stripe = 2  │Stripe = 2  │Stripe = 2  │Stripe = 2  │
+ * │            │            │            │            │
+ * └────────────┘────────────┘────────────┘────────────┘
+ *
+ * * Data is laid out across chunks in chunk # order
+ * * Columns are strips
+ * * Strips are contiguous devdax extents, normally each coming from a
+ *   different
+ *   memory device
+ * * Rows are stripes
+ * * The number of chunks is (int)((file_size + chunk_size - 1) / chunk_size)
+ *   (and obviously the last chunk could be partial)
+ * * The stripe_size = (nstrips * chunk_size)
+ * * chunk_num(offset) = offset / chunk_size    //integer division
+ * * strip_num(offset) = chunk_num(offset) % nchunks
+ * * stripe_num(offset) = offset / stripe_size  //integer division
+ * * ...You get the idea - see the code for more details...
+ *
+ * Some concrete examples from the layout above:
+ * * Offset 0 in the file is offset 0 in chunk 0, which is offset 0 in
+ *   strip 0
+ * * Offset 4MiB in the file is offset 0 in chunk 2, which is offset 0 in
+ *   strip 2
+ * * Offset 15MiB in the file is offset 1MiB in chunk 7, which is offset
+ *   3MiB in strip 3
+ *
+ * Notes about this metadata format:
+ *
+ * * For various reasons, chunk_size must be a multiple of the applicable
+ *   PAGE_SIZE
+ * * Since chunk_size and nstrips are constant within an interleaved_extent,
+ *   resolving a file offset to a strip offset within a single
+ *   interleaved_ext is order 1.
+ * * If nstrips==1, a list of interleaved_ext structures degenerates to a
+ *   regular extent list (albeit with some wasted struct space).
+ */
+
+
 /*
- * These structures are the in-memory metadata format for famfs files. Metadata
- * retrieved via the GET_FMAP response is converted to this format for use in
- * resolving file mapping faults.
+ * The structures below are the in-memory metadata format for famfs files.
+ * Metadata retrieved via the GET_FMAP response is converted to this format
+ * for use in  * resolving file mapping faults.
+ *
+ * The GET_FMAP response contains the same information, but in a more
+ * message-and-versioning-friendly format. Those structs can be found in the
+ * famfs section of include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)
  */
 
 enum famfs_file_type {
@@ -19,7 +99,7 @@ enum famfs_file_type {
 	FAMFS_LOG,
 };
 
-/* We anticipate the possiblity of supporting additional types of extents */
+/* We anticipate the possibility of supporting additional types of extents */
 enum famfs_extent_type {
 	SIMPLE_DAX_EXTENT,
 	INTERLEAVED_EXTENT,
@@ -63,7 +143,7 @@ struct famfs_file_meta {
 /*
  * dax_devlist
  *
- * This is the in-memory daxdev metadata that is populated by
+ * This is the in-memory daxdev metadata that is populated by parsing
  * the responses to GET_FMAP messages
  */
 struct famfs_daxdev {
-- 
2.49.0

