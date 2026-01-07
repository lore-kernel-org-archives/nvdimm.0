Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7093AA1AF
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800050; cv=none; b=H7FLQQrJst09PSdoKQcmXlT+AslxfGJg9xlW3uHZbN16qug1ajpmgdm/JE6e1eq95wLhX8uHl9ivVaoX6nS2jlNY3EySQXWdioHwy3YFmyu4zH63TSumv3BAoNX45G6i28NmAuBi7gDBd+raGUucCNV2jlYDvJOR6mrS9PAG1BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800050; c=relaxed/simple;
	bh=G0p06p4Oj55Eoe9gPvplGLniqIrk/l49GkW6H+icHvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBZcRLYS8DQDUuoyIvNJ45kt6jJx/oD3BEZJ8rlHSAVLWXB3bmBFHIOJWFCkZhp9qvjDAeYv6XjzylzGv4mvhX593hhvWtZW2C46eF+Ek5NV8fXmsgwGmJGo1suN77ifVZEHsy/SLyvS18YLA9zCmeCU9rTl3x8XV92XOrNoi3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=db1s+ilU; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="db1s+ilU"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-459a516592eso1397892b6e.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800048; x=1768404848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eO9EJ1SzMv+Xy0KnqPrEHfvHLOumowI49Qpx0L6iCR4=;
        b=db1s+ilUPwxOHvKJFkqrM0LlfJaOTtHCEZWE610g4DQuHoPjJQQy8goVX/+JcqDoDs
         WPklY1aJpY3bFD6w49AvzLoktWTaGVLPamSbVFpTYpg5rg7klkS8JjWvtFWjWLS9mMR1
         ltro/DDYEZrXKgF8wJVmOONznTpl6QGupxxncrRgnVCLsdDfDJOJZ3XoZI5wk6uFKrpa
         DskqJ5SmsqUhc+k0jfXGd6b6HFgBwnxHw/rpmSp0knUH1+1Y2ViS+GHu1YdA9UFTIbQH
         5D+ivVpZLypFKel4Zm1bOAlfZltMp3MUDifJ+lGSeHmMffeoEO3p/kuX5gWULRNmZkSp
         /4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800048; x=1768404848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eO9EJ1SzMv+Xy0KnqPrEHfvHLOumowI49Qpx0L6iCR4=;
        b=Ou7rjVLXb/2h7i6PcW5MHGSsN3zVSX+F6bgWT8VNeJYVDb6sHeRt3tc530CLvU+5LG
         HBIo0DQi8XTWfej9O0GnDWUyhd1f0zE1QS1l0oogV22rSnOv0WDOkxj6XdQOsfR6kjGw
         7YxXn5+zQRKSrpcHCgx/D+nTUDuS7+YBZydc/IfWKs64slOeH7pb8EoVxQczQ3k4C4c4
         bjwyI2FCucULmPXPqkIGsVZj+k+YjUyDDzzSX7faDFk7wgD6Bs7aEFL5Bn5enAc0pa8R
         UC2uvXd2bL06eS5eCVg/5ZvVA9pNKZ6kNGEWwBvO5klclW6X6ZQXzZPBLM1gFuCYa7YE
         HeLA==
X-Forwarded-Encrypted: i=1; AJvYcCVyqmyhSumQ4YKdPjtOXnf79lsv40Dx7LERddtcSa1g1ZPscZqBjPexb7qNCWxmb+kuUy1y5p4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNpwAHqpUyiSE/Ent1mBGRJLRqdgccqn08a/Afu0bjxFRiExd8
	iZ5kZfgNIbgxOTAVXwjZnJlkv/xWNpZffLWvcjOqMyLh/JzbLVh//MWa
X-Gm-Gg: AY/fxX7zJBDVedwieQ6T06ypHqVSV5rkY4/hbF8NttMefv/CB8WstG2BZYcx9av+t4O
	9hF1dTybHtN5k1PcJY05e/OW0QNqf/ZGLFuqyvfqmxdyquKTf1feqK3f4kw6MBUT55nqZYv78EL
	C4rZ8TIrNUhi5to6km01XpMj7FXNPK8ju5w40yT6+CHIr49DcsBbPEWimntq78JgQKjVbr0O47A
	UBXM0fEn4Wvw1BobBhGVmDsWekKqcAG28eISsb1kncZRa2M4ASDfp7rqrPPj/AO1e+Mfd/jErsv
	ZcSx8o4E1xhF2rf061I0LGJEexp+lvMXGdsXZ4OlKgjzblyqxS+0SjmQ38o4WthbxZboA3O04DP
	15Mvh+rSOxxe5tqAdwWPi0JLjW0Zwbn28yCdDHbcPD7/mlbZzwEHzcXd44tpwPPR/CKjTIdXx6a
	S8Slx0WtBOaRoR9qOYmjdFiA0ORhJmadFqSdnnRe0SOXJS
X-Google-Smtp-Source: AGHT+IGtCDu0G6eYH3g3wT1M6IKy3YB9HAJ3+3EJ/cXXN1DdsBvhXWe62M+fG6NKVgTW6NRYPp6OFA==
X-Received: by 2002:a05:6808:18aa:b0:450:32f0:4887 with SMTP id 5614622812f47-45a6bdfd28fmr1087090b6e.31.1767800047653;
        Wed, 07 Jan 2026 07:34:07 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:07 -0800 (PST)
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
Subject: [PATCH V3 09/21] famfs_fuse: magic.h: Add famfs magic numbers
Date: Wed,  7 Jan 2026 09:33:18 -0600
Message-ID: <20260107153332.64727-10-john@groves.net>
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

Famfs distinguishes between its on-media and in-memory superblocks. This
reserves the numbers, but they are only used by the user space
components of famfs.

Signed-off-by: John Groves <john@groves.net>
---
 include/uapi/linux/magic.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 638ca21b7a90..712b097bf2a5 100644
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

