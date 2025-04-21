Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929B126BF1
	for <nvdimm@lists.linux.dev>; Mon, 21 Apr 2025 01:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745199260; cv=none; b=ts6brwbmgle9h6bq9FJxJqd+hShyXm+ooZNKkrDROPwB74fl/0D7tTK/3gM5uXIsne67gEnmpfW9KMJhNR5bbvoC2xRgMK7wGpphRm0VGIAUXH4z81xueOdVEVIxXdmn+BYLae8rNC9vBg0toUHAzXtc6yPVV2E9gAqSjGlIAfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745199260; c=relaxed/simple;
	bh=i2RCOjAti+UF5LQ1PHdINLhvfnaWKUaVeHHuyTJYyzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kFO49KbGX4cRzXklJjH80bARzYfMfXn1vroolYxLi8Q0tgev+sJ/QqOzXZlL3e56ndmmcwsW4i0ojYNoE5fLJgax8aNXCFXIylpQAWXENJfjD2NlhZgd5EhO4Z+DgWz0R/dgLV+JJxsYCVLoxAf+Xom47NvfmX7UYGQnnGQvaKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5azwsE9; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5azwsE9"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2d060c62b61so2130925fac.0
        for <nvdimm@lists.linux.dev>; Sun, 20 Apr 2025 18:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745199257; x=1745804057; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s2xZpjaui5XzSxxh0Gj0eCk++fJOkriDnBX6FJshI1g=;
        b=d5azwsE9xvno3zaxoVITfNHWhYE2IQDQrPt6zfea5XF5OJR9Q2UMPFlAUtvpmCtA8S
         E5VqFgnlKAYk3bGV6tYYnWQR/cx0HBe5ZYfJEUWH6GUJFw+wxXrIFfN/fHIzsdXM+xmh
         vc3quyynBdkQhiY5s89Zpj530AMwgEvGzzXlYGsHwXfC9s1OGI6JstHDW0P+GAfy0naT
         hYen2mZjWWahndsuKzJI+vVHPS5uzI8r8KbAxK4J6bM977YVJD4bIK0Sf0qTaB59f3+F
         x2y+yo5WBnZZXoVW7Bwb/T/fBHH9MOr1cvuX7JjLWhCGhSm+CyEuB2d2KXETufaUsHly
         5NYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745199257; x=1745804057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s2xZpjaui5XzSxxh0Gj0eCk++fJOkriDnBX6FJshI1g=;
        b=ah183lTuSKOMBSMuINdCMJjUCV7E/VIhiVMEgpRNx+xH1+HQRbjvXgIh7H04olWBY1
         YeS5QU1SVh/JjqtMLj7VPLk21hLomHQpzz50QmgCtZUB/YwEVRqdS49wUSpJB7tOHiOR
         avSoRhKUw58t/kw4WA67r3Td91boobeqNN/YAkJkSVS8pTeq3DYAS5V+ZhKjv2e8EMTN
         B6OCUednMI9f1pc+nC/wcoQsdMlYnZygLCI7kH+iDlap41ZJHPwvqyg0UAd3hw2nHD2M
         pwqBlsE4CQBM7nOYx4xG7Svo3lndsH2vHtC9OES1JfBn7NUHiEt5qSyjNBQahEC7tggm
         ZwyA==
X-Forwarded-Encrypted: i=1; AJvYcCVZtrRk5Kya9q3gWElape54LC+Nn9LnXzI0vrhrExqX9/6xgTAUTAqaGLDrvfhJAyaArGEAr8U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyzSYyQ3Z99rijNhByHtWVTKq4zXXTlQR4D3mHcWypC48GLdSI
	CxqlgY1jobD83zXG/1OKsq09gV9RrAfGYNHMJ0PbjPzEoTAKR4d7
X-Gm-Gg: ASbGnctS/dGv3nw3uwvQSV7BJxgeUMk58B3ciKFIxddHjUbNIB3MECWjOgnq83C0Gz7
	iRrQzVwdCjSC+U88A3iSL6YNh/hTtEeac7dhP2hhflRNLeg4dCDakq1kajYezoL+aZPfrJiKpwO
	ttEc+pSZ/JJetfXvRWrn/FL4jT3jtvnMdiNvrSBQUCANJgUxqRccwVSzjc3LfvSELw0eFzxj0Ey
	Sn3OH0ooCBuc0OHXHfpLVSvJdZz9JUTI3WTUBMzSxhaGHfiYhQ6oq+gK3NmBcY3P+uVXy/2LIAv
	16EZIfIqtnbKdb6xbQXM4MKdyTUs1ZdRA7t77GFE31baEAt7kfmV20kh8XROlktqiMbx9Q==
X-Google-Smtp-Source: AGHT+IHCLVWvYpObY4uNOR1oTBCfkL9tkIi0WbVuxLpCH24LCz6hBnpqZN4tzVwpynAzf1wjqnSRrg==
X-Received: by 2002:a05:6871:bc8a:b0:2d5:6c97:8f92 with SMTP id 586e51a60fabf-2d56c97cb4cmr2290882fac.14.1745199257157;
        Sun, 20 Apr 2025 18:34:17 -0700 (PDT)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a8f7:1b36:93ce:8dbf])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7300489cd44sm1267588a34.66.2025.04.20.18.34.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Apr 2025 18:34:16 -0700 (PDT)
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
Subject: [RFC PATCH 07/19] famfs_fuse: magic.h: Add famfs magic numbers
Date: Sun, 20 Apr 2025 20:33:34 -0500
Message-Id: <20250421013346.32530-8-john@groves.net>
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

