Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4080C77104
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199254; cv=none; b=ciOiSEnB5Sgm/iVo+mkr5etlH+LbHwW5zaPuOB+A3BYJbujlAzStXwmMM6OPDAGpevRXX/FN0YkOFkDoKMSYNQydxJDoq4E0iCv6NE6bRssGeHswwY/d8NCm3mQk2TywEuvmR7cB0VGLS9nvDPBTUB+lnV5EE5hBireaSNje87c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199254; c=relaxed/simple;
	bh=3KazfK/QQTaTKMCPWi0YxDdEC7X6OVxJtOIOm2yyTcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l+j5vVNs/IrZH8vcAlSRS4CSRac1eST7F7B7BbQAZL2o668q3XqiHgra5ZO5WV9iAURu5Whh59OST3cEdfNqX72HNt7iJyiEG3q/QKHsCaIQCB/eaowMiy+xresnkdF1x3khcxPACUo9UT0qdCwdL96HPDDTZk9TzqCw85WzabM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJR/yxeg; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJR/yxeg"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2cc89c59cc0so2472380fac.0
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199252; x=1745804052; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PaZvyCikUvPqtnjUjM92+A61XpmMjGb4Ba8q0a5FCxQ=;
        b=GJR/yxegPiUAcp37LaqaXTm4DFjLRvQKzWAUyZ7VPC1mSFWLrlrjQ8lBAuMcubL5cn
         IDCfveSz9kUVuV1PVsnfRgRGLz9Wb9YioL9pcQCfu7GgrpdTQncFgTV4zZ1amSuXwy82
         v3SB8lzcTEyt0GTdQOssDhVo0D9nJmpLI7mQoTkduNkp8Npl57LqeRXxvF+8W6Qv20Hm
         8EG4Hqt3EqffRh//6xbCDTz/kZ3aoPr0ABtDhl0AWg8LJiClKj5OBbNS9Chk5MVLRYMQ
         N1Qm6cESKDT1FG3eEe995PuzdW6MUXbwsqlNLCEGpmbCwhFTQ0PvviWapkZMorFUQG+l
         ebPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199252; x=1745804052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PaZvyCikUvPqtnjUjM92+A61XpmMjGb4Ba8q0a5FCxQ=;
        b=f+bS3p1n6B4r4NN6RFHbJmwx6cB52pa+Ah/HlOoLOxI0KPIlQTxNx8RdZlw+RPgvQK
         ErxLvrkgNmOo+hnNQLMypDQaBNgZO/Moa6aZdrJpWXUGq9lbhdcVcrvEOATm2D1a96iu
         lEGHdUjcciuMpphwYDTQDWMqWyaXWG9Nw+rsm3OS4QCJN+I98NiY8dLBme8zk+ntXOv/
         MPm8E6H925BfpLYlf4Z1z4kzLafGk5zwkVKD23wPvS5YjoPvOhiC7XSJ9ZwQ0oIlcRcG
         OLDUpf9rREIcKOwIwMGq0H6nc8oAhrCjfJW6ngwUyq04iMOpYdAqAN5mQGdxJakc3SVS
         xtjA==
X-Forwarded-Encrypted: i=1; AJvYcCUNOd6xRMoADznasmMhpNebQqj2wXOnxV6kKuUFQpPWt4EH2NZpItg2vsBygrDCVV6wuT+GrB8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoUDhS2lDOMkizt1QORQRHYdqPVlziBlAGNinrYPKN6xO0NcEf
	YMqvR7wb4jS+WEO2zlfKxQUYQm0OTpJZjTTbQLgM4d4vV4KZzICc
X-Gm-Gg: ASbGncsc8bSQYZBj1R9bDzzLMyxFaXlhMVAD/S73nLyxY2aqBQqOfOKNeRkPiGnpDqE
	2r157ry5Q7kXacJemOsSBO3IX0BiKdbs2E1b7Joy/7/SSJFIND1v3zYJ5HM4qcm2CGERrw7rYTX
	SkbMiAmhvIJh5XNqZ+VWVLRWIEyn6HY1e7dBjNeYBK6V+6p/zt5e7P7T+Uv/1EbNjsuMYmgixmF
	1RvTNM2osMtEJYEm2EBnqMMzLIWo4kl52p+40kzdOufYOzWrzbeG7FiAhYA4KvA0W9YWgHYbDMs
	l6JeKuUAry0eKqO49HuJYV06/olPGxlCxj4fR8xdwcdAyEaiw2DB7bibmjVoIN2aFUc3HNpsUpa
	YFEkh
X-Google-Smtp-Source: AGHT+IGCQNEZypkRNMPI57FiYqCy8iQHVYwKVOXbiWyff9YUegbi0IX622RgL2rwTfO/kYbxNmvVtg==
X-Received: by 2002:a05:6871:24ca:b0:29f:bdf0:f0f5 with SMTP id 586e51a60fabf-2d51df20f01mr6123664fac.17.1745199252117;
        Sun, 20 Apr 2025 18:34:12 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:11 -0700 (PDT)
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
Subject: [RFC PATCH 05/19] dev_dax_iomap: export dax_dev_get()
Date: Sun, 20 Apr 2025 20:33:32 -0500
Message-Id: <20250421013346.32530-6-john@groves.net>
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

famfs needs access to dev_dax_get()

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 3 ++-
 include/linux/dax.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 48bab9b5f341..033fd841c2bb 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -452,7 +452,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-static struct dax_device *dax_dev_get(dev_t devt)
+struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -475,6 +475,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
+EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 86bf5922f1b0..c7bf03535b52 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -55,6 +55,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 #if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
 int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
 struct dax_device *inode_dax(struct inode *inode);
+struct dax_device *dax_dev_get(dev_t devt);
 #endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
-- 
2.49.0

