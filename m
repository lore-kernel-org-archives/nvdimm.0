Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BE42F9495
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568703; cv=none; b=iy4y2j3SCgBrvO5OSkUoH5fzEY1jhJjJosXecx2oAS6u13onLDgqwg75Dx4eU7tG5Zfln2aVhPo56K2IJPxk0mbaSw33VPSBE3oscxFXZTSYdR6B67PB5Mw2CKtgMllF5H9tUQt/QMHfPKpyZA//+PRgtUzKpyH+iEQjv8CZULM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568703; c=relaxed/simple;
	bh=2GAozt3GI52rhisyuFm59adRbnyMvu8uPfkVdb4WXbo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C4KHs4tECL79oqN5dBaYwW41g2sVlRgSUFLFkXYTUZHY0LeOkMMA00S6uKS5FM8B8HJRO2kqooHrp6Ka2temfUnJSzXFtUQ3tHKdklLXKnAyPNNMkkTjwTzZd4Th2/nSdINa7q9Eh9Q5oiKKOhtg6om1wifzLRLCSgFRwi49dCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khh2f7Z8; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khh2f7Z8"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-2ea080f900cso82301fac.2
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568701; x=1752173501; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk7l0GfRD3h+I6lOGqS5B01ZAdefY7DdGtDZDmtpdlE=;
        b=khh2f7Z8QOUMejdoGZ+ssH4pxXVpzp6TWW9M1yKTRsEbeKMpUt2LDoCZG2MMzGPXFG
         DVsZlxwty79I3PVKQL0R0lXFec/AkBAFhJ45SCFA9r+SqgvAA0fzu2XAQgf7FlLWvpAB
         Khitzb4O4YxUFdfDF7BBJqRGs+ZgHJpYk3Fg3ZfauBxrhj3NPIPbkyms8G9Fkz1fRkGq
         dWDsbS0layl2DwA0BOqnsaC8MiKsX3XTm/d67xshE3Bxi3ed2y9pKHWYrJrLdQ9niHdP
         AHtxjDM+qsGKopJE9/TS/o7gkH8NPQ0YA8khQPxM3Mb4FopBJsEw3/T0EXZb7yPqxJEM
         QGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568701; x=1752173501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kk7l0GfRD3h+I6lOGqS5B01ZAdefY7DdGtDZDmtpdlE=;
        b=V4vK+UwUbC0inG1Lv5Mc0ewYKBeECq2QB9vT7yIeIl9zU9vnk8jDQZvo3dL3wdyvp5
         xTpRb1gm6WKnfbtLj0wQp7Qf1/huQ8MPVfA2eFx+DTJVYVbUqCOJkslkGsytcEoZ3slg
         wJEsr9j1h62Xtz8AsmgSM9xYP7UHJ44gxXziQ+YwlQpjZ9lIBR7YvtEKtB3FCEgm4cZV
         5Xea4GsvRs00oylh/lK4tA+28CGAShgRB4Uds8hRnX497gWOW4ayyVkV4BcWJWdslksx
         5jsMJPtEjf6bk96oI02uVUCaQNJ99zXwf6JXCwmMp3FFRi3vn81hL74HWxAZYs3EIcrp
         o8LQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUuoKvfblAxXRozJmBNiS7U1eS7qmf3j78G0Ej37iQA+B23tSFSrG28pemiQkJ273qe2w3KWQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx6Kb6dDWTjhwhnrQmfXXKgS2wnMM5i9PcnuLF92rhKBM+qkFXc
	JqmbgnYJCVEu6LE+o/r05UV1EshHfDnsgXk+5X4LjNTuK2zaIxITOTa/
X-Gm-Gg: ASbGncvNqYAZSXHeZ2eRuPPQYJsqt0jn26ga9dMwKLboIiUs/2c+06phYR8YCO4YMNX
	6vqmTU2NLRX+glkF8+zupdxfoXifl4d4TLISoOfoGe1nroDc3D8mabeeS8IQwS8RHJPWwc/AwCD
	ABSDniOl56S+9GdkNdTiZXIyAphieang85y1+KpC6vDKVVEfBtoHha4xu/43mfB9SZxzDfvVcLV
	4jC7Xz5jTOlE5g5HGQW6mBDLiXv0KqBi8dBx4+y9qV5FrmPRIVRXGRwTswNPVSzqBF6nPZF5UXf
	O2lowSJ1KmDH78my7bk7BIXdocVICFBz9KiaxSh24M5Qk1EsrOJ3xJ/T7gO7JVfeJZ60afLMq6p
	THPzQPax+zytJidvYPYDC4fAR
X-Google-Smtp-Source: AGHT+IGyynocoCnJ7HhmXu2ub5GrunKuCD0K0j7iMXpe886ZyEto3OHXwpTDbVj7W1yPxb0He4yvEQ==
X-Received: by 2002:a05:6871:454:b0:2e8:eccb:fe1c with SMTP id 586e51a60fabf-2f76ca3651cmr3726270fac.31.1751568700979;
        Thu, 03 Jul 2025 11:51:40 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:40 -0700 (PDT)
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
Subject: [RFC V2 18/18] famfs_fuse: Add documentation
Date: Thu,  3 Jul 2025 13:50:32 -0500
Message-Id: <20250703185032.46568-19-john@groves.net>
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

Add Documentation/filesystems/famfs.rst and update MAINTAINERS

Signed-off-by: John Groves <john@groves.net>
---
 Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
 Documentation/filesystems/index.rst |   1 +
 MAINTAINERS                         |   1 +
 3 files changed, 144 insertions(+)
 create mode 100644 Documentation/filesystems/famfs.rst

diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesystems/famfs.rst
new file mode 100644
index 000000000000..0d3c9ba9b7a8
--- /dev/null
+++ b/Documentation/filesystems/famfs.rst
@@ -0,0 +1,142 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+.. _famfs_index:
+
+==================================================================
+famfs: The fabric-attached memory file system
+==================================================================
+
+- Copyright (C) 2024-2025 Micron Technology, Inc.
+
+Introduction
+============
+Compute Express Link (CXL) provides a mechanism for disaggregated or
+fabric-attached memory (FAM). This creates opportunities for data sharing;
+clustered apps that would otherwise have to shard or replicate data can
+share one copy in disaggregated memory.
+
+Famfs, which is not CXL-specific in any way, provides a mechanism for
+multiple hosts to concurrently access data in shared memory, by giving it
+a file system interface. With famfs, any app that understands files can
+access data sets in shared memory. Although famfs supports read and write,
+the real point is to support mmap, which provides direct (dax) access to
+the memory - either writable or read-only.
+
+Shared memory can pose complex coherency and synchronization issues, but
+there are also simple cases. Two simple and eminently useful patterns that
+occur frequently in data analytics and AI are:
+
+* Serial Sharing - Only one host or process at a time has access to a file
+* Read-only Sharing - Multiple hosts or processes share read-only access
+  to a file
+
+The famfs fuse file system is part of the famfs framework; user space
+components [1] handle metadata allocation and distribution, and provide a
+low-level fuse server to expose files that map directly to [presumably
+shared] memory.
+
+The famfs framework manages coherency of its own metadata and structures,
+but does not attempt to manage coherency for applications.
+
+Famfs also provides data isolation between files. That is, even though
+the host has access to an entire memory "device" (as a devdax device), apps
+cannot write to memory for which the file is read-only, and mapping one
+file provides isolation from the memory of all other files. This is pretty
+basic, but some experimental shared memory usage patterns provide no such
+isolation.
+
+Principles of Operation
+=======================
+
+Famfs is a file system with one or more devdax devices as a first-class
+backing device(s). Metadata maintenance and query operations happen
+entirely in user space.
+
+The famfs low-level fuse server daemon provides file maps (fmaps) and
+devdax device info to the fuse/famfs kernel component so that
+read/write/mapping faults can be handled without up-calls for all active
+files.
+
+The famfs user space is responsible for maintaining and distributing
+consistent metadata. This is currently handled via an append-only
+metadata log within the memory, but this is orthogonal to the fuse/famfs
+kernel code.
+
+Once instantiated, "the same file" on each host points to the same shared
+memory, but in-memory metadata (inodes, etc.) is ephemeral on each host
+that has a famfs instance mounted. Use cases are free to allow or not
+allow mutations to data on a file-by-file basis.
+
+When an app accesses a data object in a famfs file, there is no page cache
+involvement. The CPU cache is loaded directly from the shared memory. In
+some use cases, this is an enormous reduction read amplification compared
+to loading an entire page into the page cache.
+
+
+Famfs is Not a Conventional File System
+---------------------------------------
+
+Famfs files can be accessed by conventional means, but there are
+limitations. The kernel component of fuse/famfs is not involved in the
+allocation of backing memory for files at all; the famfs user space
+creates files and responds as a low-level fuse server with fmaps and
+devdax device info upon request.
+
+Famfs differs in some important ways from conventional file systems:
+
+* Files must be pre-allocated by the famfs framework; allocation is never
+  performed on (or after) write.
+* Any operation that changes a file's size is considered to put the file
+  in an invalid state, disabling access to the data. It may be possible to
+  revisit this in the future. (Typically the famfs user space can restore
+  files to a valid state by replaying the famfs metadata log.)
+
+Famfs exists to apply the existing file system abstractions to shared
+memory so applications and workflows can more easily adapt to an
+environment with disaggregated shared memory.
+
+Memory Error Handling
+=====================
+
+Possible memory errors include timeouts, poison and unexpected
+reconfiguration of an underlying dax device. In all of these cases, famfs
+receives a call from the devdax layer via its iomap_ops->notify_failure()
+function. If any memory errors have been detected, access to the affected
+daxdev is disabled to avoid further errors or corruption.
+
+In all known cases, famfs can be unmounted cleanly. In most cases errors
+can be cleared by re-initializing the memory - at which point a new famfs
+file system can be created.
+
+Key Requirements
+================
+
+The primary requirements for famfs are:
+
+1. Must support a file system abstraction backed by sharable devdax memory
+2. Files must efficiently handle VMA faults
+3. Must support metadata distribution in a sharable way
+4. Must handle clients with a stale copy of metadata
+
+The famfs kernel component takes care of 1-2 above by caching each file's
+mapping metadata in the kernel.
+
+Requirements 3 and 4 are handled by the user space components, and are
+largely orthogonal to the functionality of the famfs kernel module.
+
+Requirements 3 and 4 cannot be met by conventional fs-dax file systems
+(e.g. xfs) because they use write-back metadata; it is not valid to mount
+such a file system on two hosts from the same in-memory image.
+
+
+Famfs Usage
+===========
+
+Famfs usage is documented at [1].
+
+
+References
+==========
+
+- [1] Famfs user space repository and documentation
+      https://github.com/cxl-micron-reskit/famfs
diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 2636f2a41bd3..5aad315206ee 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -90,6 +90,7 @@ Documentation for filesystem implementations.
    ext3
    ext4/index
    f2fs
+   famfs
    gfs2
    gfs2-uevents
    gfs2-glocks
diff --git a/MAINTAINERS b/MAINTAINERS
index 02688f27a4d0..faa7de4a43de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8814,6 +8814,7 @@ M:	John Groves <John@Groves.net>
 L:	linux-cxl@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
+F:	Documentation/filesystems/famfs.rst
 F:	fs/fuse/famfs.c
 F:	fs/fuse/famfs_kfmap.h
 
-- 
2.49.0

