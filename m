Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FC91925A0
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199262; cv=none; b=l/qORPn/x83f/Niu2YNojEiIPnp/iEE+CrxSDyxhzG6JYXVwLaB0PFvDlDrwL8yblnSqXFuPTKDN3GVpZrxh7o/xFReYOjlIOzAcEY3LfUA51krEiBEYmIN70zE6Ha4RZHzHMZQE+DmZwdyZT0R5r1B7jUYgfKqkiLkLVcoXrIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199262; c=relaxed/simple;
	bh=kGGXBghV4lzKmeRVN+j+pfeJiQeXOVHeL7W4dyeFZvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JoghSZyHHMvGfXrmTGh45c9UW4tfLW2fhxzfQW0QcqTWjpQCuDGyppFhgjFeCrc+I+Qaeo8PWArcW0O6sFvL0EIz65bxpEwYOjmTc7rvAffqgNSSU5CO3554qoun82XICWNTrZyZrgaubMQWAnXC6AcW2D4B4mztAl5KVDlM9bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R5jGeCIr; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R5jGeCIr"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-72e965ddd79so1870118a34.0
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199260; x=1745804060; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/+tFl2/Decgi2IQHespB0RF7ZlGK7hVUQHMC/s+Z0A=;
        b=R5jGeCIrk4I3Apv1RDXtdO3hMhnaXunJl2To3/dvVSdQh0HUjDU5xEtlimFY1LF66w
         IMROijjm0nt4P3FFB1ZGaMYFGXotNHiajQSPYbXz+LGFSH13WE7JhSr3OxbBp7TS6cgl
         974PQ9MmtwCxu2W1T85rWQf6DhSsfB7Zh+rqJowBTEyksGjZysSbSdqTXllr+95gYip8
         MqFhdo8P6+WXUqHKP5G2bpjF5zr4FwR0S2ha1PZ+5FCf6A/X7vUfpSwi53HlopJRPSHG
         Z01EoT9L8q0mvvE6gk2cpUg94b1jlfXIAIWTCLdr+6Om16Y0zli/h9+Y6SWUcrYihwwG
         +6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199260; x=1745804060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/+tFl2/Decgi2IQHespB0RF7ZlGK7hVUQHMC/s+Z0A=;
        b=RP52PAYymw2AQCNa69jeUotOCuXeb5yHx6z9OlU2ZyW1L+OrF57EnptxTW6Hc8XYHb
         uxmUUUBFBFImOPBGe8Q4SHbyFVeUxXdiN7jyI1B/se/YoLVOKEq3Qm+WmeID9mVHeQsd
         k31qdXS6qOi/p0r1nOYfkNUbyMXl3LPDUY0pAIgJ2CKc9pKqFcfxWJhsF90xn4+Qz0JK
         lMhIFlABSQPR60bQN/xgNzcoTiEDxGjLFK7KNi/fJWv5yAq0WucXfwILhL0ook3hVQbs
         AgzB3G0h9ipHF7iBlrkAu+f/4qwveJBgkQf1I02ZnU0Bl1CCgVjMu/ZlApL6Lufc2BuT
         fBAA==
X-Forwarded-Encrypted: i=1; AJvYcCVvAAID/XsNl/KHTYd7h4wk3hZYiB6CAgZT6QXgX19Lzo9Qe9mVD+n4ddVNAL3U3nDOSvUWFQM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoH8GzRcnzwc1GVSUycTfYVX0OnbCEXYE4VpQHmGKcbN0VzKrW
	CYOiQnQ17hqGsHAAt1sXjf7ZYmyO7ik9wv+iDzf1vlDfNMlUv+QJ
X-Gm-Gg: ASbGncvMegLW5HOfGKaFmhL3boZc257t/Ob3/Gk2CqV23L/+vlOUhsj5zNzvxu0Nx1t
	DHA4+rOBb0Px4rTI/8wpA3Nb1HwFvcknaVXGZo/qWVbqmcemXx42NV1gO8ncrpiVrWiQV/ug9PE
	IoP6HDbe+lmGwHsnUdJaQT2TAnHfrjmFDRxf6+kMti7O737nqvGUU65NiwIRIAb6nVuEc1pVMMe
	APJfICX7Xj3QqWROvDNDMvvn2134EOr3mHN+bKDQsUYUOHwLEL/XVzyvA54CMmQDCP8UhGwPw62
	ZSxGbeU0Y541Rlqaox8jrozuU1//8eOHIRQBJi5Mywg7lBWahltKIrJFnxhqkYQSolTLiw==
X-Google-Smtp-Source: AGHT+IEz5bP7JM3BwiQMEUcJwi1iHjsHutNBExuPGxHLduN/ka75Z9MzoFBPbybdCpgm9y3qzmrR2g==
X-Received: by 2002:a05:6830:d06:b0:72b:9bb3:67cd with SMTP id 46e09a7af769-7300620ff0dmr6144248a34.12.1745199259823;
        Sun, 20 Apr 2025 18:34:19 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:19 -0700 (PDT)
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
Subject: [RFC PATCH 08/19] famfs_fuse: Kconfig
Date: Sun, 20 Apr 2025 20:33:35 -0500
Message-Id: <20250421013346.32530-9-john@groves.net>
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

Add FUSE_FAMFS_DAX config parameter, to control compilation of famfs
within fuse.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/Kconfig | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index ca215a3cba3e..e6d554f2a21c 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -75,3 +75,16 @@ config FUSE_IO_URING
 
 	  If you want to allow fuse server/client communication through io-uring,
 	  answer Y
+
+config FUSE_FAMFS_DAX
+	bool "FUSE support for fs-dax filesystems backed by devdax"
+	depends on FUSE_FS
+	default FUSE_FS
+	select DEV_DAX_IOMAP
+	help
+	  This enables the fabric-attached memory file system (famfs),
+	  which enables formatting devdax memory as a file system. Famfs
+	  is primarily intended for scale-out shared access to
+	  disaggregated memory.
+
+	  To enable famfs or other fuse/fs-dax file systems, answer Y
-- 
2.49.0

