Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2E38A72F
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800052; cv=none; b=FcBzZ9JeogjGpn68ml0NG+lNpoAGTrsmqsLeH0c/WFQN1m7IRpuC89Hggw/RXNAK4V7EO93bA24dyLUchWSlRCkd9kdo8MJSbgIOHQyfB0A8y2zFd0cKRb8zOCNUegclPUDcvlvbQPUBbL1cBWVPKV32FSRp4guam9aQnETDsSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800052; c=relaxed/simple;
	bh=4TXKGjJAeQJwDyMsPwSGTtB9EZ4t0ayfW9/mqhAX0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9oF/jKUUJd1dSo/3KEbw2tz8ekBMeVpdtm9PRduMK7SzKNgCjHXBVm59H1x/+ZV7Utlbh4+ZR53nUhJeCthQ7W1pm7vMCLZCLOyJbm6QoSHcSgz4MSIFGvKvVmMH75L6M8EtPD7K/hh5zFu/uF06m+nG4fccHPbTIsOFAUW+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRC2Z5Hl; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRC2Z5Hl"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-4503ee5c160so1387872b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800050; x=1768404850; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xsoizNZgLZaDBPInQieK4jd0iMDgMqPyINA++t0nMgM=;
        b=KRC2Z5Hl8olmbz7d5WAIHR1wqgay8PxMgqvLxSx2QEhaKEK0J6sKLmrI8DvTDEoa5S
         4w+cPm9LMWxMI+ZNd0REC+0zoAarUIR4jSlw5rTLa7t0+uYa1n3XZ3v9VMP35cOI6wui
         mpCE0Mat+OaVfWmZ1M7M+n9f/tYxOy2cpINAezSJXsSDeZHIoxRGeTi9As4vC/dnoWKG
         ARZFAUVJ1Xy5aq2G1Qf2F/JO1A8J6124G88abakCWCx/zW2HoJYH+olpRUDXvxm/vSh0
         RdyVLQb6/NQ8ePM2h7bxfLbFYcwrpr3fZM4dUPgOgmFllqa09nmJyhrQQByctah+oBjc
         jv1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800050; x=1768404850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsoizNZgLZaDBPInQieK4jd0iMDgMqPyINA++t0nMgM=;
        b=LS8WkzQqcAILM+GRd6oGzjlG8fTwEOMvJMCc4BOaH9GM3aLARlyaURYKE1sYYeN5fj
         ocr16yWxEf7JOzd1ymi8HpjgfLQ/ei/x5IZn2VkNrj4ul85UQsroSPZAAR8QHpW/iuP1
         G8G7YLdznX+ht6IgoTPjBHflSaGrK2VuIimkDLAQI6+//FJgWHPBal8Lq4hACVA14maj
         T7EgQJWAeR1kW16W9jIKWTqGMR3BTI8s33rUYVCIkjJ6BzB3KAGX3pAiHPDAO9koBS7i
         8Auc2Olfmlgq2b6emGoEZ/JvgY5CsTDuUucC85YXcX+Iu+l2gECrwwiNRCBJSU4pwBul
         u5qg==
X-Forwarded-Encrypted: i=1; AJvYcCX1Q9cvFMifgK4wLN0BV8Bl1zNAwtXeZ3jLTPGGA10aYi6wFNIJIn8j2UDkBkZVQ/IjLgRAZcY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA3+hvIFKq2jrT+gD+/Yjbegx9BRlQePklGm0BAyVoFyHlaztR
	DJUoSYC8iw8oxo5STb0CuAUOpTX2crMph5Hvm0cfIk4ZqBkuMNJV5i2k
X-Gm-Gg: AY/fxX6G/gh9AgpP3HT5dnJmLYBcEV8XK7FQSitd63J2vtQcytnV5idJ6PIqUwS5wJk
	yzA3r6J9YDdph9WtvwzHRTMNUdkOLV2MA3iLkLqUrsWfNqCgFbuBBhjSk83XlstMsUEWQV0OeY4
	dQKT9pASI8W5GTYje2ai48RPAGcaFIw8LzKg8wJLuIcrOUGmgbaj21eAH1XRN6yRXuxRcv3U3V9
	LlsyWDeodOubo7tx7dZ8otfqBtteppZ/1q5eHKxA0JYUEdW+IcM6B7D+k8esg4YxFksWIPsVDEs
	5+vRU2ofgb0aTm00tjR9fK3oYCyCk5FSpBSU9VTnwEawIde18XPwFcTVu8b928X8E4ySj8BEqYJ
	PYZEeNxSnUN/jIyOQDo1Qq2QUDCTS/urPkISB6XKQG2Xg68Yx0Q0bbHZhGdy2gmhHzBO9C1dviT
	wErNaM2I9UBpT2/9ILjj9djh7c2F9HkXfcjqZYNg573h5PGttTK7y9H8A=
X-Google-Smtp-Source: AGHT+IFO/ZLxuqaj17abyw10+8CVi9iLvz7AXlLgZerskMOrQo6BFT5caxK0XQr+JNLPJZbm/V9Mbw==
X-Received: by 2002:a05:6808:1786:b0:44f:f747:f9f with SMTP id 5614622812f47-45a6be3820fmr1144818b6e.36.1767800050216;
        Wed, 07 Jan 2026 07:34:10 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:09 -0800 (PST)
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
Subject: [PATCH V3 10/21] famfs_fuse: Kconfig
Date: Wed,  7 Jan 2026 09:33:19 -0600
Message-ID: <20260107153332.64727-11-john@groves.net>
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

Add FUSE_FAMFS_DAX config parameter, to control compilation of famfs
within fuse.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/fuse/Kconfig b/fs/fuse/Kconfig
index 3a4ae632c94a..3b6d3121fe40 100644
--- a/fs/fuse/Kconfig
+++ b/fs/fuse/Kconfig
@@ -76,3 +76,17 @@ config FUSE_IO_URING
 
 	  If you want to allow fuse server/client communication through io-uring,
 	  answer Y
+
+config FUSE_FAMFS_DAX
+	bool "FUSE support for fs-dax filesystems backed by devdax"
+	depends on FUSE_FS
+	depends on DEV_DAX
+	default FUSE_FS
+	select DEV_DAX_FS
+	help
+	  This enables the fabric-attached memory file system (famfs),
+	  which enables formatting devdax memory as a file system. Famfs
+	  is primarily intended for scale-out shared access to
+	  disaggregated memory.
+
+	  To enable famfs or other fuse/fs-dax file systems, answer Y
-- 
2.49.0

