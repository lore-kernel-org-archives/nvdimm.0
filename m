Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E171E2847
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199293; cv=none; b=Xbh/cK+0O10m2sO80QYXFexme9hBQZ/T9jVjKhk5GGensXOyJoG8QzI5STUXpXBFKVSrZaQqe9QutVoQUyYyYWWku6n1/Op3ZHwVQ7bo5i9R352SVC3tx5Nrl9FGDq7GSUV/IRp0C4/PiequkTM4cnKFKmingKlDZD7ZQMZoxfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199293; c=relaxed/simple;
	bh=KPHEXE5Cp/zGdVywYOsVdEbL6sn2rwfyb9wjdHeyhi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ROIjpkiSSNPBSQcohUb3i69QkT9C52/vCTLUp0vV+R6nDY2L6R6TCB9l37aggxIv1Or04FrV5RUtuNvKv82uPJo1senGE5Pifi4UQwtWiLaIPMwfpDOxkuK66e7IKP5rkTwcw/lSa8gLEAy/vsqAlyGltnb6PTHjDWiL27VjWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ef7PUmdX; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ef7PUmdX"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-72c16e658f4so1984248a34.1
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199291; x=1745804091; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oc4Vdr0o+nfx1QBJZJ6xepmEuT/UhfqhypvD0CxI7Ro=;
        b=ef7PUmdXd1sdY3IFM4YcnqHQnLK5FY9gBfIcfZP0oq71rOR2T7ZxOdU/fExb5JyUPW
         xHkMyZ/+XYEtNo3Ej8G0AVbQA4aw87y/xNgRx42L0hrrimbFgtywiu8imW19asS27JN4
         YCrTeVCzDYb1lFZyqv8Lrc/IacX/OuNxyExN+VbivbCEWEpbFBtMqj5T6JxNdknk6xr4
         X8X1wYGwP6lmrYshWZo05am7ihFpSoV+bparzDaMIEsQQu9i2g7rG940H88I8UarOJ/M
         KGj1dB4Z80FIycBCHdBOycL5YvlgGmsVGQ21HzWNFzOzuJfQlAtG28I6E4oV62gJcli5
         VsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199291; x=1745804091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Oc4Vdr0o+nfx1QBJZJ6xepmEuT/UhfqhypvD0CxI7Ro=;
        b=oIBJUzqACovt527bnF6bmFN8Mmtrk5azeVseAMpiQVQatEQlEy6hoW6oBAzi8ucEkR
         tWSfB2Fl1H623Qw32WWtej4QGK/Oin+h767mmav4QccOUFDUJWWycUefbeLI8lMeEqcn
         EWcX+RUyrNDFUf6vpfP/AdabLqgpvOP9gzmPC+f1qNqaTgPpW42YoNmsGBEcEPl4tAnF
         1UO6JZTbePI5uzG6uU2h95N39Lf7qGPiDsPNiKSWe0Krxu8C4z2XpSSg+Aq80w8egxcZ
         AQt11kSPx5XzgOGImkI7n7Ozc/+l6SnKFWctut/IO6wY730/waz0cfIJ1I+4gXE4hox9
         9Pkw==
X-Forwarded-Encrypted: i=1; AJvYcCVisDT38X/I6Ym3Ac/5ToY8xMVCK6WpVAhravORLqrDWVah+/UhKAV/MXnkZ4iBCGvp95b63Bk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhoC4ClxUUOI/FjaTS3OX89qA24iB5xZXr4PyAxd5A8drC+wvT
	w0UfDUjtg5O8jstTw0/DRQLYML8zDO1hNdAoVXvOkyzB08bCNVP+
X-Gm-Gg: ASbGncvgBGPZH4tJJTqBBUPznvVAfiROhCra5+3ZKTDF7qV8A4WNBwM0JWf3pPn7AkE
	jwA1NemvcJbAj6ua7EfnFsoN5F1YqXqOfcxmgrXY4XsD6PZQqccZTm8J1K3+GdTcga/e9zSad9b
	55ky/GD+tPbWnaei7UBa3ok1Zgb+yS9CH7DmWvQM9z+vpFZdBFbh6I/GZemLkLFp7460HrF81Xc
	JJgCCAuCGZXWnTzwDVn6BFxSiEfUKZSCFYRh6ZT4Qq1HhJhMTEH8Osb0qgQskUgrrrnTXMYtohJ
	kTSq+oF1ubmuzNJaHl+JwlWgusqfCrjiM2ltPKFoiv6KY2xk5kuFoxPwuQCkm98GSzKEKw==
X-Google-Smtp-Source: AGHT+IFvfaaZSi7N+55feNIb6bsiG1ALvnMH5W+/Xpyce53EuyD/gGFkOnKxGp91Sfa8827mA2MSVg==
X-Received: by 2002:a05:6830:4988:b0:72b:955a:852c with SMTP id 46e09a7af769-73006212cc9mr6434150a34.11.1745199290828;
        Sun, 20 Apr 2025 18:34:50 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:50 -0700 (PDT)
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
Subject: [RFC PATCH 18/19] famfs_fuse: Add documentation
Date: Sun, 20 Apr 2025 20:33:45 -0500
Message-Id: <20250421013346.32530-19-john@groves.net>
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
index 000000000000..b6b3500b6905
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
+The famfs fuse file system is part of the famfs framework; User space
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
+* Files must be pre-allocated by the famfs framework; Allocation is never
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
index 2a5a7e0e8b28..46744be9e6d1 100644
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

