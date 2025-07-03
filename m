Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8F12F5324
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568665; cv=none; b=S6VhNT3ElzWz5y+ZeMlsUI5uDClV87IvAMRh9CyghpsgIUbls0Fg0XtR3mrSgHjomd7eLXX/Bl2yK942Jy4IskjC11iPpioNQ8y5+fJviZH0K/a/pT/oREtELvhkVaqpBst7YaXjyePCuzdYY8LQeAlUlOfMiBFfgzWmmFNrDy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568665; c=relaxed/simple;
	bh=kGGXBghV4lzKmeRVN+j+pfeJiQeXOVHeL7W4dyeFZvE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZdG9j/3d+EdoOXlQ513uRUpfizGav7USvWECAAdFzQxzlQkCU0Yx8HtN+Rx3RAyR/9Yu8CLv4eMvURaM3NunNgVFDMgzQbRRgqwAWU4m/vAxDFq6DEly7G1B4fGGGg048qjl1c36L8evz5K00Dmki2TN5TeXP+ELV4CwPjloidM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cIXMDYQy; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cIXMDYQy"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-735b2699d5dso153400a34.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568663; x=1752173463; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/+tFl2/Decgi2IQHespB0RF7ZlGK7hVUQHMC/s+Z0A=;
        b=cIXMDYQykRBDSuHShwTfH3i74VkDMkyYoVzskswUe08NqXJIWkRzNIhSy8UuWx5Qhm
         RnCEXI6R3yoCog9lzsmMaWPkWOd96bVy1LMEM2hP5WYs8H0MvmrLgCrx120bw0AUYjDH
         pNK+rQf/qr85qWRRCdCSLRThkjzoYDbwPU8GIIctrARfuwnMGGBOy250e4TphmNr5uvm
         86FvQ9D+xZI02mLAqg8vND+uxrXszcujhFRGgfva/aNgDnJFA3ogWrozOtv0376+3tmA
         m7TaH66IbkFln6Mb4xe9P9CuSq/wKXrFdsMVtFgD4B3pdYcik5MxXhWqbN3B+YxZk9Gt
         dRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568663; x=1752173463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b/+tFl2/Decgi2IQHespB0RF7ZlGK7hVUQHMC/s+Z0A=;
        b=Y9nH6PLKyzSh3lSf263SxAp8KKLQ1lhMyWkWvFOORBfUW0QDWv98N71/75CvuYAtJs
         eplx9Rom5gcqccQGC+BhN4VbqGVPrWs4Al5mEKkp7tm0cZN5D98IKuA+dhU2zYZkxG4z
         jgwf3L3/tiz0A8SlbNXsFVlg08ydEc6LDPeD+vAaF4wkrpj4mguDfCVKJ7RV5TG7Swia
         Ua5Il8Xxo7kzIWTtpm2MXKQPrN9xng5FOqbzjzgrujxQTUmtAVmg4ZNa9oij0HodN3uU
         amgjGRhVjM2MC02YA2NdqtcRbPdVOs4PTwIlOpq/mNEEOD74RUmuz76GVgqTYfCvgmLe
         HNMw==
X-Forwarded-Encrypted: i=1; AJvYcCVZlBh5HiWHUc+SyqMly2PCWCM3ExNCJWF3BL8hvsZSfbrgPHqhfF47t9bPypXq/lApkr4ipoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTZNIMBceD5DHKvkvwfzRuHWBLS+Wqjws77JGqsLyx+vbkyok0
	BqKC/ux8cjHV+bDKuKZYRSUp9fkoG8WbG2tSUFd0WZwuy6MbvhXAMB4D
X-Gm-Gg: ASbGnctd0KxbjDs7QAMaRipVA2qIBjkoN7dkU6Q/QgzRC62H8GAblBopT7mdlBdjSbp
	4hCM0cJy4VHPd2B6YxdKO6uP1t0+bFBlLy6mlrIOo9FqXE0LVgNDxV2Ga1NiFTfPBndGDq8MUdo
	98tIv+WFeUY19rs9zJPG2/+LAd9ZqlcdzSvMroCMSWC5HUKhWzRf42EqtQAXrplUgbBObRLE4Hu
	2xEQQ2mwjPQpD+lUhSqy0LcNIEz4PVlUKPjoGjgjpYbbTvJFtoowGOFlrIsFGhy6ebdkLB4oXpM
	xOeDk5NBl6swXJcGP9Uvi2SXtvUkcMOGr/zBkB9s5ggxzLc4NU5oqKTysg0c2VusLfqnGIeD0UU
	85+ly2y8/B4xmkA==
X-Google-Smtp-Source: AGHT+IGO7sODaaFj8dS4msIF49YLoYQDdi+gB7SnaLJLRU0NcABvpJXyxo3DQ89xtl0K0dJU2j4aYw==
X-Received: by 2002:a05:6830:630d:b0:73a:6904:1b45 with SMTP id 46e09a7af769-73b4c9c704bmr7359023a34.8.1751568662976;
        Thu, 03 Jul 2025 11:51:02 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.51.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:51:01 -0700 (PDT)
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
Subject: [RFC V2 08/18] famfs_fuse: Kconfig
Date: Thu,  3 Jul 2025 13:50:22 -0500
Message-Id: <20250703185032.46568-9-john@groves.net>
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

