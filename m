Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A2B3986E1
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800093; cv=none; b=CfreKeidUC6RJEx0qVX8t5rKnjVeh88zeB5Mln337dQPmYSYJ3cT4AzmVts1AxIpiNRK2czM3WtVGSLCX/N2Pk417d8EPXkCbKzq/EQ2yoC/VZh5IvPzAuQXSJ0+TiLrrbyQKO6Ik351+aHpsw1hE4UKdChswpcwb2NVRjAOnkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800093; c=relaxed/simple;
	bh=rKi3IJhFbcB0WLwepeKv+pU0rou+ccXKzIoDaJEyXMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl0jQ530DrNleuanrFqQjxouvPakYDjEu9m1J/Q+OltFnq5lCJ3GVNZ2OoeyF2Dfr799eA/NF3JCNy+sTnlRmJfyZHB5WBw35gtZvrBjdcs9HHxhZmARmPP0CErPg4gsRez8Ld2UwcZO4bDa1qf9Z6g6GY636oK8HT/01UMG4xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGgdOxBL; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGgdOxBL"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45358572a11so1326571b6e.3
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800091; x=1768404891; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kBCgapkD0tMSytl4lZx+vzryyZ4HeCqXI7xZ8qhc6V8=;
        b=DGgdOxBLp+hRSKtpqD78KZBuT4YvefugX94mUVCEpDSQG+M/Q++0SLQ56AJ/2tz0HA
         jT1l1ItKzKkIPeR30NpQcN81Ch8i8yd2gApw1vsD8YMLw3ShuhfdufvpAUuzzPrlk2mh
         Qnvpe9ZxuK+6QWHHwxOQf5AOo8+JxGHQGU/6uy+xEyCjwS22ggr3hiice++M6VZdwsSF
         KAVEUOW/+ZCxcCzNBA43nWOCi3fFUTLxgxnXteZ9ANjPeUAORL1pUEU2OOTt8UgUSmf8
         DrCCJgK0Xi1SQzPu3BfH6R7V0kpWHepdZ6lOCS+X3/zLuMg+9CbFfjFi/50m4IW3Pz/I
         DuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800091; x=1768404891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kBCgapkD0tMSytl4lZx+vzryyZ4HeCqXI7xZ8qhc6V8=;
        b=rOx7UsLuZJZm+zXGErkspAny/vQXRrOu8l88C03xWcgye6Hj8GrLnKcQ23wVSWDAyw
         NH+YMncrJu2CY18BTXdSXVNeR9GhEyyQtPSt8YZwjoRFtN2rNjm8WjZwvxyhzA6QoAQ9
         orTEqxYe+mxwJxrejbNBuSaW7e+J2W1PfuYqF4KsqAgug2Ntdbiu0V0rKYWF75ddn68p
         XatKoiCVFSKmchbM1fIw4WfDyu5Kl4PzoGqXunNA8/cmDHNKhJRwnu7lufvHsV7AZP7t
         hQqKzOBaqptheoVKjRGHOvCXj60CDVqOd4w2me9V5iIqRnSwEwyNg+euxdlD7UFV1PYN
         enGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn+s99B5HWG9nc97a1OCinvMrv4LyNs6H+h6Nt8E8d/hr+86/gbJjHVOWBpQwswIV98jtQJ8Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhDUGrUiCzN7jct6gyc8LUxcbr9yXa3J8kecTOp+t1y41fRPOj
	+8yeNBMEh5NUZndjx8TQugYuvM/TNjatlCsE8E1LlnC2LSXXSpcqMCnf
X-Gm-Gg: AY/fxX5x4GiAdel/kIRr261kRXytDqc0xtaLHWs7SROVthmm29m28MF4WwOm5THIRGg
	ijUHK0Tf5wTMD5edRyYakc4i4gL1spTN+dY8CWHm8PBOki8XCJXe75+wZef2FkgRDG0HH078PyC
	KwO3VO1Cqvu9J1rtYddphgSA3AJeaBlWiDe3LkY7TX/A+oCsntfVl92ztBNqeOsiYDXtt+NYiEv
	eNyJ4WlwQnyFkycEbyRyrPvz/ZL2busbafhy6/s804UZeZHRgYNYmWumo/xt1/jxRwlV68zLTAa
	9RdzB5xvIp5/reBKI4Mh+5+gYyZCuFG3o/350UScwM2yn5Nqq5rpNUWcz81lbj3c8aHNblyItEX
	kOCVnIEb0t93AcQaWlDBpJYrNIC4JLUhS2DPEKLKh4lu18lGq/TJDn7IsqsUj2eMXsef0KSJOIT
	RgfZltnP9pr+qdaCGQ3zlDJBqRK4KB58o+6uEmLGSzDit3
X-Google-Smtp-Source: AGHT+IHcdywbJhWbPofmdnwqwy3siWxMKS2ZL8FYrwKJtzA3ot5XniZZCZFcJRodTSEL4vBFeFPTwA==
X-Received: by 2002:a05:6808:4a52:20b0:45a:76c9:303c with SMTP id 5614622812f47-45a76c9325cmr272281b6e.32.1767800091392;
        Wed, 07 Jan 2026 07:34:51 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e183ac3sm2398424b6e.4.2026.01.07.07.34.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:50 -0800 (PST)
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
Subject: [PATCH V3 1/4] fuse_kernel.h: bring up to baseline 6.19
Date: Wed,  7 Jan 2026 09:34:40 -0600
Message-ID: <20260107153443.64794-2-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153443.64794-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153443.64794-1-john@groves.net>
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
2.49.0

