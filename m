Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA7536BCCF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426600; cv=none; b=mcoYcMCIFMtUy0mY+DwCsZMBF1VyRdIf4acmERT/VXGpM2QghQvauSwD6ArpYOumqdehaP84H2MCtHrXwFsUumBccZdErI1zmd2HqvEnlzVajod2tDOoPWnzT3XHpOBuHSCq3JP0USuY0ttIoDShcM6fopQhulo3Zk8sakSdaTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426600; c=relaxed/simple;
	bh=Ps/bSVqx4OehI5EayA5JYJNwyYnTQ9jqZuLjt15n6pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYZaskoBryrRcdF5SroXfEPOeh+vr1t8SPfg/N1gZDDvd/ETjCewcVXRzfn+NsJwNWqZSsBzL7efOoHp1QnHcJqvMvGSmJglDdy10lx1ikYuDThknqFD1vcyVvhQ+a0BOUdJMmK5E1mZNo/azCKzJ5volQnXFbTUu4ZxmueFQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhYNH4MV; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhYNH4MV"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7ce229972f1so202935a34.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426595; x=1769031395; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04R2Ca8mGblkvXlxAEPOlC0zVWkPjjtROdHv+tYqk9o=;
        b=ZhYNH4MVhuEK5mPd8DGHGJF6mNneXN7lBBUVkedvnaLmuL4vB/6xVG2glAzBNs5tcT
         f2nmJ3omvli3/9i+ASiWA7kekd7hjDvvKYuusyH6zXCCqFqqktHKNZ16ZcFZpZlPFuRf
         UJrvC4EqiqPfEA7fj1QZuBUvArwbr+NjGRK94Ixc2QIpauOx1KRndwzg4rwnK4+E/2JN
         mAv3rskIzYbVbYR1Qmjk32R2e2DRGqcBHpUTTajqprd1mkge926RC1RGf/uYHRegaVzk
         o69XWdzKgjY0cVlqseSHlj3/BGb/c/SUKRbmbvBRoK3Ti+/QM1ybXuOeFMKFakF6fDRr
         U3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426595; x=1769031395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04R2Ca8mGblkvXlxAEPOlC0zVWkPjjtROdHv+tYqk9o=;
        b=DVHrANvWdCTmfGsXxhUJJNHfYG7a3GX/wdUIJ+5i80jZ4N9U7x+wPpW8ilwboZr/tG
         tE+WrYsw8T0TciBkCJby4lneJ+8X4oOwjwn9ptBimZr4iASXmFG84R4oiMyO76/gIb4G
         U86BrwOB7K5l9ySWYhKd/CULFmQOZypXSkPFYXLb1j75080SV+xfjQ8aXn2tViH9gcyb
         Xdp4Q5+4clcmvxinUyVwJOPeXVse+5n+1ZyZ3dWivlkis41pOd5D6BMhXEW/2BmtWYFy
         YM/uJ2yVYBhC/amTRDrXygNvE2nh6FK5v2C/0UdsodRb1XWinuqldyXp5Ynp/89Xk20O
         Fw+w==
X-Forwarded-Encrypted: i=1; AJvYcCXLjC/6RAPaSab8t10tp2iqSVmUX9KrXUSB+40XxPDVPoE02+t96yMxbxrJcdThA1JC75mRagw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMTxy9rwppVO+x6T1l3ie0coUWl1fi6aGp3jWQ2+9+YzHddcOl
	IPj27Mltaqcutbc/Og/kcu7R/idRn61PVAnTNxeRBaHT5GUQ7fyz7WR0
X-Gm-Gg: AY/fxX7aGIcaOmdswx8zUbfjCcAZbg4etFxVtLH9GBGYZT1W4tXh/S6gLrp+E/auqaG
	LQ351BAoIiLdPlZswYs2GQzozA/y7qEHdSMVGyeKB9QPJcf98p+BApTsQxeDveCJ/ON5rntL+oY
	S6dNo6FZghjSXvXUSI1FHAGTEaYo/F+n6bXw9PIuTKoHSlHP5EHo/q8FE9wNqRr5pmcgA+CgzKo
	VgyC9XoFROtqlDC5YqqYt6CZsxJtMlUOzdMz+DZNXgjQtxg3MDT/Fj5vxxNBrDwx38Bia+c1vTN
	ZWZ8rKIuKGLsjFy/o5Vzm+/C0EIcRoQnx3C3OqknbyMqyW0Z3RixVFEWki/H22a9z3G+FxzHZdj
	R0+1GdDDS0LZv5np6dk/lGyyYJgF2qEgEL9Wn/nI+tIjM2mVVdGk3DadQGNK74qv9mCryUZ35mC
	DR+wdyrPQ7YZf9mJv2Oz2PFQj8PftjCfGizh0e6fkzvmbu
X-Received: by 2002:a05:6808:4f1f:b0:45a:5584:9c58 with SMTP id 5614622812f47-45c73d67fd3mr2620000b6e.21.1768426595172;
        Wed, 14 Jan 2026 13:36:35 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4040cba2d2asm2418156fac.5.2026.01.14.13.36.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:36:34 -0800 (PST)
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
Subject: [PATCH V4 08/19] dax: export dax_dev_get()
Date: Wed, 14 Jan 2026 15:31:55 -0600
Message-ID: <20260114213209.29453-9-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114213209.29453-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114213209.29453-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

famfs needs to look up a dax_device by dev_t when resolving fmap
entries that reference character dax devices.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 3 ++-
 include/linux/dax.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 00c330ef437c..d097561d78db 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -513,7 +513,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-static struct dax_device *dax_dev_get(dev_t devt)
+struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -536,6 +536,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
+EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 6897c5736543..1ef9b03f9671 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -55,6 +55,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
+struct dax_device *dax_dev_get(dev_t devt);
 void dax_write_cache(struct dax_device *dax_dev, bool wc);
 bool dax_write_cache_enabled(struct dax_device *dax_dev);
 bool dax_synchronous(struct dax_device *dax_dev);
-- 
2.52.0

