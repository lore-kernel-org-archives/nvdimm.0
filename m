Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C556396D3C
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800079; cv=none; b=tWqd7UpUUP1TpMO5COMIpxBpc2eAw6OCMSPBCOvJ+Kh7WdVorsQ/WCN9Y0tZyUQ/B2dV2yQipYGGLGRSgeafHeXC/R6X9UWYhI20ly71/R7S/QkSvqtDp/3S/TN88IwjriaVgqJfqYq1lpw05bm6ddVZUbSWaSgLi70dxEk7YVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800079; c=relaxed/simple;
	bh=zQL6OSWBO4m5+Q/hEBIHqSQry3+21Rl32A58FZEFgEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozirkMbOegIVMNQL6qmqbqzastf1VOEF836x7hvQkTT1SxkzMAgUib57ssmdQxC4F76BQozmethYjqwDwkS1MfnTkdW1LS7dWRuvmeqfIxoaQtqgFtbxhyXKundihdUP1HPDHTMCu5p0DiPTBsIF+rIVj6P8Kmt7PGyNIsqFSwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBRxD0k8; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBRxD0k8"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-45392215f74so1095956b6e.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800076; x=1768404876; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BadRqtdIUTjJqSpAIjL5u97iCPqnyeMr+lfViz9uPAM=;
        b=gBRxD0k8FAc3NjtfQ8XWbx5C9V12dzLhJly8InHcXGQpHx5zVCOVIY9++3I2YtQKHJ
         5dw4tByu3BDdXtjIjFraoDv+FRVnoyh2hlPPEWUqEtgcXVrLsrgM0k8OmWWyfWcybOFG
         auAuikcq1A1xFxaSU+myQotUrRhqgtgRyYhjmEKSZyTuYirJ7SLwNp533WIEdFJpBL6S
         CrkF5sXjaIkq5p5y8H80o5+fP7GGdMfc5oMw7PNhMxGlhcSvsA2R0QAGnbifG/YaREQI
         gJ7gM2YFrEYj3RrpKx1+So8PWfO/venk+LanBBEMZuCSHiXSssT2V0I13ns0QXz6quIe
         IjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800076; x=1768404876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BadRqtdIUTjJqSpAIjL5u97iCPqnyeMr+lfViz9uPAM=;
        b=dNogHWNdcSz+UaC+uBZBI2DhC/SRLY/nabzhw9itNopANsjEXsn8qsifg01Y+mowLZ
         +3FnV6ze+AvAD/2HRBxw1+XYcAoYaZ6WiBCQDTSEzLi8aQznC0BYR5r/2BgQA7Pzgxfs
         z7RrYzxegmJ2hzoXhpVW5jsELgDnYVL5yNxCvN3wQDg6+J8zXrT9ZTWJz8Otr2lSCW2l
         /A5Sgg5Sb6KJy5GMBMQ8YpSoepDrLXqCaBB0EkSwpgOYKr3C8OXxFT/EAJDS+xDiT5n+
         VveL0ec/EUJc75VRevFm6XN9EblrPO8eEGcNDt7Yz2Z7Za5VohY24DNpajWNqK1JYPrv
         nFfg==
X-Forwarded-Encrypted: i=1; AJvYcCVtHm8ecxw97bzE04AjdIlIYqRzahJo7xlezUaBABG8p4C461FVGzJCfBpULrIvi42CYd9MAS8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzxHAcHYiwfrIE7agVdiJF8hr/dB0rOUuWdJ3DFwzZSOpGW+UIf
	RfM3iXRaOGXqkKRw+t3vc57oloE5IGD0l/lnqPJbJ4HPS4uQDCT4VkWZ
X-Gm-Gg: AY/fxX6lY22aO9lXzE+qmG7oJwFNGGK4TPiz2lJFI8QkQ3re5Fm3uQdlHBWO+CvIJ3y
	xi6K7EpCMOPLTrHnTXKrcwr5G+DpmfjClQRaEmN4Nsniud6gmpagKvAFgrONo32BV0UishF0RqI
	Muf/A9HhKs8C9NRSN1CC56KQrF4KX2G7kAGCkzrSGbE5cr+41UlHh7A4BdjB0xHkm6N5nGrJFaN
	sF7ZDmgE65tQPL4XxnV9iLAwPatp9gKfgSwWNKi2163c2oYyws3MYL+Gy4qwNLmNYm5OUrvYzqf
	Vhy8o7rpxM27C/4D6rwzU3jUjvlUwvaYEUu1f6j9A4+N6BNDzJGLGG6EvQDnuWiMPCd6baQvk/G
	HV00mGw4JDgbzyTHX6Kbt80mGquaBFibLrrwj3tYuMVEaA1873QgN8+VXSrWh9QfgiCguZPqq/z
	YSMUsLd9Be8T8miFLmaJRqCQ+UIGR/44O4eImVTKCHcnvH
X-Google-Smtp-Source: AGHT+IGiBgbbbwZi9OtjHC2lwZve1mJRhadFMJn6qeQ/EHq2CoD4bMYUWvkIfhWahXqGzzsZgFZhkg==
X-Received: by 2002:a05:6808:2383:b0:45a:156f:dbcd with SMTP id 5614622812f47-45a6bf2a83emr1169537b6e.62.1767800076370;
        Wed, 07 Jan 2026 07:34:36 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:36 -0800 (PST)
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
Subject: [PATCH V3 19/21] famfs_fuse: Add DAX address_space_operations with noop_dirty_folio
Date: Wed,  7 Jan 2026 09:33:28 -0600
Message-ID: <20260107153332.64727-20-john@groves.net>
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

From: John Groves <John@Groves.net>

Famfs is memory-backed; there is no place to write back to, and no
reason to mark pages dirty at all.

Signed-off-by: John Groves <john@groves.net>
---
 fs/fuse/famfs.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/fuse/famfs.c b/fs/fuse/famfs.c
index 4eb87c5c628e..32c3d0c2ec48 100644
--- a/fs/fuse/famfs.c
+++ b/fs/fuse/famfs.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/dax.h>
 #include <linux/iomap.h>
+#include <linux/pagemap.h>
 #include <linux/path.h>
 #include <linux/namei.h>
 #include <linux/string.h>
@@ -38,6 +39,15 @@ static const struct dax_holder_operations famfs_fuse_dax_holder_ops = {
 	.notify_failure		= famfs_dax_notify_failure,
 };
 
+/*
+ * DAX address_space_operations for famfs.
+ * famfs doesn't need dirty tracking - writes go directly to
+ * memory with no writeback required.
+ */
+static const struct address_space_operations famfs_dax_aops = {
+	.dirty_folio	= noop_dirty_folio,
+};
+
 /*****************************************************************************/
 
 /*
@@ -657,6 +667,7 @@ famfs_file_init_dax(
 		}
 		i_size_write(inode, meta->file_size);
 		inode->i_flags |= S_DAX;
+		inode->i_data.a_ops = &famfs_dax_aops;
 	}
  unlock_out:
 	inode_unlock(inode);
-- 
2.49.0

