Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2782F9485
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568699; cv=none; b=a49B0azLiHHMDi0Y76BPeI2OYmDrqUNH0n+SE1o52OABCXp3X06JqhFR66TbahFjsNpbWnfXPLsbrnNelmyRpRaoegXEFapjDFNSmJGifAzAscy0Ob6H/CUBn2SepVMiokg0YFdLBFciDNuBT47XegSrKGTiVQoK/VHJjgUp0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568699; c=relaxed/simple;
	bh=nISANB0XlQ0BLoj4/fUTHodInegZ2G/VHJowR2UMMe4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SLVrrzTdjFKoEssxFFY/kzsElO2fv9hsmBszQv3Cr3WrtvD2oFWuHIonS/J/DQygymQx16QtT0s9eRjxwK90YVifpavNplfb8ox/BxU1PJhjabZ84/pZFPg4HsQRRDu12W6tIOMt8WXBQ5D7oeFgqEInDgjXdSR3GuPEAUKFEwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAibTPHj; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAibTPHj"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2ea08399ec8so232631fac.1
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568696; x=1752173496; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4P2ebQHmA7kMFafoMqaSVOZx8bY3tIBj6NaPdz6n/Mg=;
        b=LAibTPHj5HtJIhax5vXus/6aP2mnYVmU1V/VWCyeXaDIYYJo2bDCCdXiM79mHcH9Az
         boo92N2kekBECxV79//aRp2FOopdbfoPc7ax5h2QowTyNawj4JEeDdvnSaFEewY6zmWE
         OcDROC6l6wwVI3FtRXgbrJSIhVyUugSLIsOisJwn4iWYIPEIZNe7zJiXC/wfGYhZ9XJh
         HyY5s6JQenaRcDQNpQ8lv7GJCTt0JKu4zHmWsyyQrL/9eYOYZNDNKUUPdbNTo87XbocN
         /WR3Mhbcdozg4QaEtLVCmQx/+45z6Ni0Jp/vbYpMYYOFY+q1NqPxNoyDFTJIbvvAd4HS
         pUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568696; x=1752173496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4P2ebQHmA7kMFafoMqaSVOZx8bY3tIBj6NaPdz6n/Mg=;
        b=PyR4a9NS+dAKcjBZ0Tp2Y0OQLAlah0NyHR1hvrdGbLX5rOUTxQLo+CKwDszZmbEoA4
         g0OMClGIh6ErhLYzPiRiJxIRm19Vq5E8X3h8X705w5X6HoBGt9TfVl2BdqRbW8fE7l+N
         1JVYO9PI6qZOKvigFnvDwxTO2rznw5NUYeaWfmWppORFQDsNbut6sw2Ah+yLtcIe5mLE
         VwbYI1URtIry+qEUcmbmdZDR3yMcdiMwWXqyGPMy3rx+WJMRvRTcJUo7sZSOirjpd4ox
         MM3cc0J8KLiNU7hwFjZlSNYoTKwegY+kUjG7/a/Er9O6yWhQGDegNy3gee2OCr6b+X28
         Z7FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXplJWbHPdTMIsLm3JL+fHb6T236fEKABcADRNXDZ0OuLFRyEM6AMQcc3j6D6vDz/7LDNSWavE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8FI9h1JqLhnmSTf36bbJnx1pNhbCeFc/Ns9lQztSCbQ5Iddcm
	NIJ9W5D7YRdoFnAgDbMWaUUJyeiWX7MJH2U8YbBl+cAUrtON5ryhkAMK
X-Gm-Gg: ASbGncuEESoLOvVTttycLrkYRVoDzXuK4Qu8BpE2imbcNFQ5NVjs/RqoVFj7ipUEYEm
	jyffI/EQOLcoL9g/d93In5YzO1vBk8KGZNFUPSOOoHieCi7YWUt5sOLdQ+xXwrsdMr8ohnrr7m0
	9LyJFI0BoMAVcnUL9acMNOpbvfsiyP9biwNNYNkuLLuO/s60J0P6fvtxGZCWVH4sj8XyMqqT3Kj
	uQZqahzLRgT78Jdu2P8A4k0tTaqDBMhx54zhjJn3QtmZEerWBwPLpV02q5DvSUQZtG2LSPcIojS
	+rY1RBYA+a6E3w5d2A4LyLQru0WUINGjNSl1B6S7kSbGTkGSxV4aXdOvYWP5YNQaIeSDkREC6I9
	em9zqs0Xkiu+RHQ==
X-Google-Smtp-Source: AGHT+IFnaohm+1vpUnTkm3zoIOdovIzr+/8MuJ2xXxfmzv2Todd3FjvaTkrldDEH046PZ67gRIosKQ==
X-Received: by 2002:a05:6871:68a:b0:2eb:87a9:7fc5 with SMTP id 586e51a60fabf-2f791de6e45mr6858fac.16.1751568695843;
        Thu, 03 Jul 2025 11:51:35 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:34 -0700 (PDT)
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
Subject: [RFC V2 17/18] famfs_fuse: Add famfs metadata documentation
Date: Thu,  3 Jul 2025 13:50:31 -0500
Message-Id: <20250703185032.46568-18-john@groves.net>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250703185032.46568-1-john@groves.net>
References: <20250703185032.46568-1-john@groves.net>
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
 fs/fuse/famfs_kfmap.h | 87 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/famfs_kfmap.h b/fs/fuse/famfs_kfmap.h
index f79707b9f761..2c317554b151 100644
--- a/fs/fuse/famfs_kfmap.h
+++ b/fs/fuse/famfs_kfmap.h
@@ -7,10 +7,87 @@
 #ifndef FAMFS_KFMAP_H
 #define FAMFS_KFMAP_H
 
+/* KABI version 43 (aka v2) fmap structures
+ *
+ * The location of the memory backing for a famfs file is described by
+ * the response to the GET_FMAP fuse message (defined in
+ * include/uapi/linux/fuse.h
+ *
+ * There are currently two extent formats: Simple and Interleaved.
+ *
+ * Simple extents are just (devindex, offset, length) tuples, where devindex
+ * references a devdax device that must be retrievable via the GET_DAXDEV
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
+ *   different memory device
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
 /*
- * These structures are the in-memory metadata format for famfs files. Metadata
- * retrieved via the GET_FMAP response is converted to this format for use in
- * resolving file mapping faults.
+ * The structures below are the in-memory metadata format for famfs files.
+ * Metadata retrieved via the GET_FMAP response is converted to this format
+ * for use in  resolving file mapping faults.
+ *
+ * The GET_FMAP response contains the same information, but in a more
+ * message-and-versioning-friendly format. Those structs can be found in the
+ * famfs section of include/uapi/linux/fuse.h (aka fuse_kernel.h in libfuse)
  */
 
 enum famfs_file_type {
@@ -19,7 +96,7 @@ enum famfs_file_type {
 	FAMFS_LOG,
 };
 
-/* We anticipate the possiblity of supporting additional types of extents */
+/* We anticipate the possibility of supporting additional types of extents */
 enum famfs_extent_type {
 	SIMPLE_DAX_EXTENT,
 	INTERLEAVED_EXTENT,
@@ -63,7 +140,7 @@ struct famfs_file_meta {
 /**
  * famfs_daxdev - tracking struct for a daxdev within a famfs file system
  *
- * This is the in-memory daxdev metadata that is populated by
+ * This is the in-memory daxdev metadata that is populated by parsing
  * the responses to GET_FMAP messages
  */
 struct famfs_daxdev {
-- 
2.49.0

