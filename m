Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6C350D75
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806596; cv=none; b=qqoh41At5DAdsP51DRhfITHF/w+b1aVImknfB9mrMHmI3KP01R0sYfrq1VdAa/5Mic8CFzRj4inGzfdGR5tU4Jm7P1tIxssDPqieS1KPgR0EWHsAj7si9Ktqq4+gkrY/eNNUCAlyQ9qIWUFr5Q8e+iomBQD8xEg4CIWggsEAkog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806596; c=relaxed/simple;
	bh=Iv8QEQFRzeBfeVTlG+UF1DvDWR96yJ8hOeXcNbevDAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R93dK+9V79vLnQRgMz4st55mjENIijL90nQ9HTlT4vzEv/qcApU+Vf2XH4TW/yQJLDLNfLSMJ02QPqtjg7FYcty0+i64+dkFJvAxmbfu48qQimWKhopT+XwoIAjgu6pI715abq6RTCupDoN8irN64bnR8Y5biXgxHPbFtsNVuzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3PCct2Y; arc=none smtp.client-ip=74.125.82.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3PCct2Y"
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-11f42e97340so313043c88.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 09:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767806586; x=1768411386; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ByDlzKUbACiwWH3Dgtn+v+MBoRieZFlgupkDEPd2zG0=;
        b=k3PCct2Yw9w/w4QF1NW/phuIgMZaKRCj7YZMKpXzG+8tnMaX/zOnhDWVRlJnlhABF0
         /x5a42VdCIkpU8KVki/Md+l4tTYhCLJgCJl40kVeX9ohFQXlIMFXYhLXAbf/tDZvsZEW
         YA9ThDVlk1lIKH4+mXjOOC5e6ErMnfu0uUbgB9blzWqhL0d+Ap+vw4cnf3K0DIpo4lZ9
         c7nm50wW7IxVvX1gZE8oacGkoJ433BczMaYjkbxYChzk5wb31qZlMcJMUm1leG7f3xd7
         SywB8NDK7r0btl/+sVbqV4usyfPxGTtFCKoUJtmHXrIzbR7J4DgPRf+DMB1lR5n61jdb
         3YdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767806586; x=1768411386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ByDlzKUbACiwWH3Dgtn+v+MBoRieZFlgupkDEPd2zG0=;
        b=VOssp6DjPY92k1rFOKWwJ8pTwsn1aA3E0yi5kfMxu9WkkvR1V0MssSyiCPU0LoVGL0
         xsm9orJvmFPBDqlB64IGuwgTW9ze7MIlaD8K4jqDCOgNx6nyF0woxvqvECqaowzwZVWS
         xLlt8xh8u8siAKs6vLM5MQVhqnL2CQb6014D06Vh4lDX10scKjQX8d9s/jA0/Pufre0L
         IgiL48CCLI/5Nrr6lTTn8eGg/HUXPMZULRSZlssAn/2g4V6mzibz8Mhytumo26/Y9F+q
         4brr21fWbiUcldyx8y/77CN+GvTO0pS1qw25pUqmI93oC1Ba1wdu921hDCCe3lKQ8GTU
         kM2w==
X-Forwarded-Encrypted: i=1; AJvYcCXNJcEaiYhRiRgvev6BZ69HgbBzUNaO9dMah+rSwE+KKjEYsdIqgg5U9AOlbDTRuUmnGbLU5dU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNSYmrT/c6Kicz3+Ioh472PAZQztzybWU+5ImPvwphrMFfSisu
	33HY8shVzNu/+OojIbTHH2I/wcWMkMJLc0x6aaM8XRjNV/TXY+gRAzy2BpKSLR67
X-Gm-Gg: AY/fxX4J1IQahpzadby0Sw0qIvnArUhl8nCz3SkWL2cKaDGYqDsd55JuQejKMDtEWKO
	ZeHSkEwLD6l4pptetRA5a57IQp7x2Hu+WAQ9VZxAsp70S9xsb4P3HNPaueSDzhaPE9z7RBfsYwk
	hXUnWwbwwCLGBzkkZKAZoGT05xOUeXDxUrirvo7hCAR5DM+WT+6pG1YEYZkFYD9pX6AlEr+sWBJ
	kVvPF83n9ESmocteqhqZ4JJes6r7HiFweOkEAE+gmWSGAw0fbNx6/HZRnzl6uqaJStLPj6r0pS8
	WdF1bAF19YAJVmJxFptelp7a0IIAUJ01OC/XcUXdMhQNu8uPWgbwjYTA0NfOhg1s5MV7MmTmHCP
	2EDAsKqdPfFm0EaSeOwE+FKEO6vEW6StX28IVHHzz7hQ1TlhZU8D+9Ope0kzhtD2+9zX8IJ1HMa
	uzLEsSi93SyAdekQimxtJtuT3d08RDUyZ3lUglYI9UncAe
X-Google-Smtp-Source: AGHT+IHH6c3F0YfxvIazIzqmrv5Gfwpzb8ium784lL1LqhHDGR+rc1ftda1nHLwiQjItEG5YQPZNcQ==
X-Received: by 2002:a05:6808:6d91:b0:453:50af:c463 with SMTP id 5614622812f47-45a6bebb603mr920549b6e.41.1767800083021;
        Wed, 07 Jan 2026 07:34:43 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:42 -0800 (PST)
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
Subject: [PATCH V3 21/21] famfs_fuse: Add documentation
Date: Wed,  7 Jan 2026 09:33:30 -0600
Message-ID: <20260107153332.64727-22-john@groves.net>
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

Add Documentation/filesystems/famfs.rst and update MAINTAINERS

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
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
index f4873197587d..e6fb467c1680 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -89,6 +89,7 @@ Documentation for filesystem implementations.
    ext3
    ext4/index
    f2fs
+   famfs
    gfs2/index
    hfs
    hfsplus
diff --git a/MAINTAINERS b/MAINTAINERS
index 16b0606a3b85..b74ac9395264 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10380,6 +10380,7 @@ M:	John Groves <John@Groves.net>
 L:	linux-cxl@vger.kernel.org
 L:	linux-fsdevel@vger.kernel.org
 S:	Supported
+F:	Documentation/filesystems/famfs.rst
 F:	fs/fuse/famfs.c
 F:	fs/fuse/famfs_kfmap.h
 
-- 
2.49.0

