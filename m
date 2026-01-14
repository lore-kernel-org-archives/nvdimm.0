Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C262338F259
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427038; cv=none; b=fmMYaki7CT3MvX6+2pC2aQa7hprM5tmYkpYPinSQX1Qgx1ZyUWVrIURcu1BtKeDySExs8BGQkovgJT2UpO/IU1y6XZv/YtNh+0nC/DTnCFowiRdrJyFEiQGxIE1ajHozkB03moGSaIGiahoK5AUOGrUGqqrxQbx8X8wFNVSmQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427038; c=relaxed/simple;
	bh=6IXyikUrXXga0w+XTOVh8PGo9rM6Mf6O+h0Sd4yHab4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ova/zRyQKEdQm2l6BmwcwB1ISgqwj1i8P8Lcde5U5GniC9GJZfKdxetQmKm/qyz8k1L9KXd/IzwxSOf0yMN03yKdqFIWfUYCs9x3KHVmyTvyFeNVGiArapwuNbsDtREMtxuIIxGMw1k3NQsiRy+W0NcB3re43awhxB2HI6yX1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GYvj0NwQ; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYvj0NwQ"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c6da42fbd4so169471a34.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768427023; x=1769031823; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KokXwqCF3cjj7h8MwPrV07VxZRdfFYCa5Cm5tvCoTf0=;
        b=GYvj0NwQGnkCyfaX4iAUGGqiMA9LGHGZfxwjjbxPPTbPs9bVyxujYdvUcwSLWi1TxK
         o8MIdOL7mKMOYsGWPOya8JdS/SH6UVM8s0PiqpAaB5awXx3fXk73IyuamWnVph5gNedH
         awJvM8i2d4X9WZTOwVtWtR1yvGG9ys4FFgujWNcYFxxuN1mc9zzR3INveO8dlas/cyIY
         Y3RX6ayz7h9Q//+gBprLrAoXLEx01zFmx5F4cIbl1e/smitSiLLux+bg9Iw9gCRY9YUN
         WTS0zqYLEo63iIPnnzoNHok1E5bPCgBVreYC6gglRu3DrsyUWIYvipKZFzTTG10N/2f3
         Lv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427023; x=1769031823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KokXwqCF3cjj7h8MwPrV07VxZRdfFYCa5Cm5tvCoTf0=;
        b=RkE0fSkmod/g4LfIsi3wASOK+CaeNa3grwTORATv3x7yooS7zOuD6g33O0M2G5e2u+
         PbCelGq1UvpMkwqSMUmHVlcKcY8me7rJXs7cbLYR7DHn938eixRYn3daNgt6qJKNoOXk
         ilBvz8I/UpO8NG5qz6uY95KdmpOn4zVWsfdh3vNnHZhD560jW9QiEWsuLohYqm18bUfW
         31jQMHa+VjtpKjtrWoEPYMF6E8R12tUrjn/wNTdoWcgxd3nkH+eq9O49uIayzQaEYv0Z
         8HWhJmNQRT+RhkexI1+Os6FQuiMap6A7p1hl1zDF+v16oPvipze+t0OL3A2VpBFiWTj+
         o30A==
X-Forwarded-Encrypted: i=1; AJvYcCV8n3LI2Fba47zeu0nE1LvkQjutQuAV9h51I3Kxstl1iQwWDIaoRiGe+YFWnTxQt0b0tKEiimY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFARaFmVHyFHy3JovhnD/SHLB9bolLpI33FM2bov3cOPVPQOvi
	XVpOTp8mHVp11ZBGDbcj2qUDh655uMErdS2vc3holur95Hym9r2vriuT
X-Gm-Gg: AY/fxX6KzFN8xSR9L+a77Xx9JBm8h+gp/NIgISsG/vYZW47gsd0Gea7bRuAG7B5kYvW
	CQDBNmsgHqBh7IGMWh1jQRG1aRO2kOP/l/2QZ+VGM/gWQDxvatQ/bOuUaYWOtq5uvCIVvQeMS99
	MmDo63gVUtsvcBXWZYL+USTMPTuBgFVAlqRDwHHUh4FRxz4rW7E1OOLSzYvPB2i/J7VYg5g6Z+E
	9WRxwAgdvkZE9aMZdV+ddLj753vJWLoQyxl/DcaiDvDS8+R7na3MRVszi8nUIw3TkuwFerz70C3
	ZxiYGCiTEhRaI/O3KyrWKoQVwRmKv51gefurFqGWo7zCNT8ZVM0bpNJFxSt/Y04MhANBp8VpUwK
	ZY4wIZic6me68GylT/PGJL5L2/4aUc67xq3WvgOsjilJz+7c7NU+Bxr2Bb7vFxJ7X+wVWbhuU6y
	oSpdW32PsIbQk2QN9GWDDqxGDsYZPxMINp6pzNhD8MstMd
X-Received: by 2002:a05:6808:229f:b0:450:ad22:f9ee with SMTP id 5614622812f47-45c712da165mr2717268b6e.10.1768427023109;
        Wed, 14 Jan 2026 13:43:43 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa515f4dasm17619569fac.21.2026.01.14.13.43.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:43:42 -0800 (PST)
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V4 1/3] fuse_kernel.h: bring up to baseline 6.19
Date: Wed, 14 Jan 2026 15:43:05 -0600
Message-ID: <20260114214307.29893-2-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114214307.29893-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114214307.29893-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is copied from include/uapi/linux/fuse.h in 6.19 with no changes.

Signed-off-by: John Groves <john@groves.net>
---
 include/fuse_kernel.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index 94621f6..c13e1f9 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -239,6 +239,7 @@
  *  7.45
  *  - add FUSE_COPY_FILE_RANGE_64
  *  - add struct fuse_copy_file_range_out
+ *  - add FUSE_NOTIFY_PRUNE
  */
 
 #ifndef _LINUX_FUSE_H
@@ -680,7 +681,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_DELETE = 6,
 	FUSE_NOTIFY_RESEND = 7,
 	FUSE_NOTIFY_INC_EPOCH = 8,
-	FUSE_NOTIFY_CODE_MAX,
+	FUSE_NOTIFY_PRUNE = 9,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -1119,6 +1120,12 @@ struct fuse_notify_retrieve_in {
 	uint64_t	dummy4;
 };
 
+struct fuse_notify_prune_out {
+	uint32_t	count;
+	uint32_t	padding;
+	uint64_t	spare;
+};
+
 struct fuse_backing_map {
 	int32_t		fd;
 	uint32_t	flags;
@@ -1131,6 +1138,7 @@ struct fuse_backing_map {
 #define FUSE_DEV_IOC_BACKING_OPEN	_IOW(FUSE_DEV_IOC_MAGIC, 1, \
 					     struct fuse_backing_map)
 #define FUSE_DEV_IOC_BACKING_CLOSE	_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
+#define FUSE_DEV_IOC_SYNC_INIT		_IO(FUSE_DEV_IOC_MAGIC, 3)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
-- 
2.52.0

