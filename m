Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4DA2F50AD
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568662; cv=none; b=QBFnlM54DrHtYeNIG0afUStM14l6O4u86bxrd05noi4l9tOMY92Sz+WffCy4QExKGx94G4N/lwcOOirigup0wWA/x//veKVmJ4jpqKVuw/CdJJzZzCFDx6rrDVFeEzzHmPiniosWqqj9x5ozHbaQinfZrYujyfsKVQ2F3TSIvP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568662; c=relaxed/simple;
	bh=i2RCOjAti+UF5LQ1PHdINLhvfnaWKUaVeHHuyTJYyzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SlND5VbbWuGOyiX2UNyG9hLU0NtTCJmApwOdipa+unUtwZwky4nTRwJ4Pmrnj4Hm6iK8Hifo1lNMVXzCIDJfsfuTUSrCVpwC//YzCmnMNTh9joIwwQj5cyx2S+pN4B4l3RSAczuh66znWsxfn7iJlA2fIziwVE6pL7BT6CuGIiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EunH7Egy; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EunH7Egy"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2e9a38d2a3aso226422fac.3
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568660; x=1752173460; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2xZpjaui5XzSxxh0Gj0eCk++fJOkriDnBX6FJshI1g=;
        b=EunH7EgySOcwT4GNNm0WEI8y4iPk2h1NFFkOo/6fFnk54pdL7b8/XLKmKkW1/ahzw7
         3F7e/qeKM1r3i0Nob34R4vr05gEO6R5hEQvTm8QnCJ3uKWPvc/VD1PpIeO6Qhnz/MY/n
         1AAOupBU/J37MvDnwOFXFQgRU4WurQUXNJQLCTt8G28a1k8e5YRW2LwuJzrNfM9Ldb3Y
         y8e5gp93Ae334ud42HXNDdbIQ4FsbHDqb5ogrdlicgm7ugLcDT/n0CkAJ0SbqNGoIgYk
         aOef8YlRUtnjO+nsMk7sto/Gj9SmWb95QDBhNXnAtQ+BuUc+cPjtEOfn0vdFJWzMOYY5
         uoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568660; x=1752173460;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s2xZpjaui5XzSxxh0Gj0eCk++fJOkriDnBX6FJshI1g=;
        b=nU+dVnjgNfufYYXm3r6FOewMi+SG0qNztFzCjY948h/VusvHo4MHUeq316jZb8HlUg
         ZiEVh7/qHmVGG5kdSEA/DXR7T+Le5kXeX13lX5qv83W19sHj/yTBLFmjVuIuhdI3kokT
         X2IdTxpZ7JbYCmO9UThYdi0TJsrEp4k8qbVEtnhj4cmT1SDO/Fzur4YNpFyTdPfwunjQ
         vUrvVNwjpG/4L0L/9OEPuqfqBPLc77BBPV7SDtMlbHaAMUV1VaItpZC9GNoJsNa45T6K
         9nrb931+bumPMbxgyOvm4X0GLF7nAF/Dx1DZm9eKoP0hMzwZrRDvNsUmbLSc65QzUron
         FviA==
X-Forwarded-Encrypted: i=1; AJvYcCWRR2Er3nVv+NJ7f73iZwZHAasBQTeay+c4ISaiqRJU0AFkxzJnZMeqrols+5fmP4ZSbYa2dTc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/4KrmUI1m9cvB74W03frcqKWFxZL6e/77EiyfZwutmSrbFk2l
	0FHJ+5MWE1BMIBoG0yr8cJD2el8kGTg3xKyM9kaBShKHgt6+KDMBVWkO
X-Gm-Gg: ASbGncugpbyFhjeyjkpyvkJYXfU+FDElkNDLlHQqzdu7+lJWY4XCJHEBAzecTUWzF34
	ozmJn2txOnUKoFNNnrwwngAqBvejAPi6l5N87ORmgAdYzD0bQDtE4eUh5qd5zY8L3D9x9QbGXmr
	2eQfL64KNUeVq9E7f5zVsrOmnDFk6TLIAasYKddF4iLp/e9xftsxoGj576chEq7EfQDRfmy9jDi
	oejjrIr1da/QuQIthxfI92QiLJ8NSQlqgn5XvHzFDiYxNME3DoxeNcKmWS0hJzbnCuVEeglGWqq
	rMv+5EPGVNG1E9UB8eMYqjEfagNN88dD+XkdfkHMyvgg2aaPRjbg1qiUvLSr6QSmWCobdRUOC81
	B8xQRFsTFdmTTAQ==
X-Google-Smtp-Source: AGHT+IFWojQvKP3cIpPU0Ex4gOP0RyReOaJ9oJ//8+DQ1D2UxOY6HF2XKVzeow4Q9s0j3FT7ZnZiXw==
X-Received: by 2002:a05:6870:b201:b0:2f3:e087:6b08 with SMTP id 586e51a60fabf-2f5a8b9022bmr6076525fac.24.1751568659637;
        Thu, 03 Jul 2025 11:50:59 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73c9f90d1ccsm68195a34.44.2025.07.03.11.50.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 11:50:59 -0700 (PDT)
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
Subject: [RFC V2 07/18] famfs_fuse: magic.h: Add famfs magic numbers
Date: Thu,  3 Jul 2025 13:50:21 -0500
Message-Id: <20250703185032.46568-8-john@groves.net>
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

Famfs distinguishes between its on-media and in-memory superblocks

Signed-off-by: John Groves <john@groves.net>
---
 include/uapi/linux/magic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..ee497665d8d7 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -38,6 +38,8 @@
 #define OVERLAYFS_SUPER_MAGIC	0x794c7630
 #define FUSE_SUPER_MAGIC	0x65735546
 #define BCACHEFS_SUPER_MAGIC	0xca451a4e
+#define FAMFS_SUPER_MAGIC	0x87b282ff
+#define FAMFS_STATFS_MAGIC      0x87b282fd
 
 #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
 #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */
-- 
2.49.0

