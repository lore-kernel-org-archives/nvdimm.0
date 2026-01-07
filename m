Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F68389463
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800048; cv=none; b=tNhE+AEaG8PnnkN2YfO0ILZE89KfysmwBYFQIMJJNtJZi9fPNkOu70CW2Xopf1UhlZAdbVIq0CPLIHVsJ4fBiustI3/TiRifh+qjemTVPpZlOqz0OKKHRypbVI7YMZRrR+J2egYGBzngk4nqI8iKYVnYBvhVJm6E5EVKO1c8VNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800048; c=relaxed/simple;
	bh=rXk3y4C8WJeOSfMI8cZ5ZlL/TCkv73ERx5NvQkCSpyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olTVSlzPsAb20YNfOv8sTpg6N4F+iLrz2Q8KH4ZqEpt5dOJro7+kspSwiWOrn44/zHkBI7lP+4D66ltG8wN8OGTbOQpL+b5k8gkT2RzZqFMxEA/JtWdMSBXmXoqAj/NneF8vOO8Y2FMJdE/IgUmxowC2s6+FaDzOUafL4ajh6Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4GNDJuh; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4GNDJuh"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-459ac606f0bso1285265b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800045; x=1768404845; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nEjVEszBS1bXBch+QTu9nax0OtrFw3AqtXa5XoSe9fA=;
        b=k4GNDJuhVaYUH2NqQNTtfQPBS7ghv5hwlw3jMSwt7b8y9Zj1SqhNqtexA9oQq9+4n4
         OXpKYUeuPphq+ufF848Ri6kXOXUQK86iSsRXV8COHr8axEjFXBimwxFoT9RehhYeumxd
         PtdsTO/n907TXsJZh+gO7fRdfqmqPV718R4WLoxzEwjmuW2mZC5H+28qVwcFOIbKzTih
         N5wD8i89hCfYGApGL2EO0CKqFrZZblgbDS5q9SULrvPXEeAXXWg90oag3FDnd+WZpCdL
         hxCLsOzWj1Hi3GrCNpeKmre5Fd+iHHT1KHxmb8FLFVLF9pdKi44zbWqJIileBwusk9GM
         KQ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800045; x=1768404845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEjVEszBS1bXBch+QTu9nax0OtrFw3AqtXa5XoSe9fA=;
        b=ZB536elXlFBDNIk0eMVF8ramBVG0Bmlr4KIARid1nHxayViDIiM6gaT/wv9mb29WAJ
         IW+QO7O1s86BMzIr6RRbI6ky7Q7yIXfdO47RxAIT56UesSM6u4R9TTMBTNaPlswpWYbL
         DU/kF0McSQJvcdSlIfoUg5U76STqV/ujROUjhRWGKRUBz2IXXPzqRG2DDVAy6QJKN5Ia
         kj95N7uLLa+PdTDFjiitZIoqrskIZwT67aynAwPYH1uFpKMaCSNTsyamEHS/DezMCD5X
         6kfkdE3W2UT4Ucez2zV5UcAv1rvEkGezxGZkvmQoMY6UdLQEarbWssjxqQ4WwRP6pxyc
         VZDA==
X-Forwarded-Encrypted: i=1; AJvYcCWBuxuBonP/LYiXlwPnuvep3Ny/fsSK9ePP72vPufgiFvDuiYo6Y9DiL5C/+MRdV8x3GWw0HZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8jWYhKL5yvj/HctvpZBYVVGY2dngeZLL66kszxaOgGKGwknbF
	rydlyY+yN4kNKPU6+F5Xii5P4AHL9F2F65rdU7T26jONbndyrVdyjVXw
X-Gm-Gg: AY/fxX6VIkplmSzDifEqLgVExgMY+Km53L5GwwvDgj/1WX6d9qGyBQcYGsO91guqqST
	2HMzOxLmJXvwO6jdoQSuzt7pnyg1MmqwGCUvT9VhcsvWRxTqP8H7sZGKRw+JyFr7W+/foqaABng
	lbLTUDPG+u3hkrbkI0ZgyfxhkvmSFFkn+XmYQmo/pat/k+MLVLDXJdvrASOx49UGj/58uGkcNpl
	PknQ2yxyHAwOFRkdVU0/xdEPuEINfgU55hVTOkCfxGUjwwOhZMAoLhoQbHxFvFn140djr6HCpC7
	9YY+AlHkX4ZyVAIgLqV6QqICMH8+HrcjBRSQwMIGCgRLcgBP9EIKLCj3rqG3elU6ve7+i2VY//z
	gqdrzGSPW8QYAmFYUDNrsD+wXeaQE/UclK4U5J95r/cFzCkTCfxOKCfHXgoRbFKQZF4ir1YOK+P
	M3r+HD8y3NT0sMomEwaKlchcgGHuhrC6mf0VMtX27CTfOd3GkdQJty7ds=
X-Google-Smtp-Source: AGHT+IFX5hj+WsCZcQN0F9ui7U4tLr7OXye3gCol3kbUSaMg5lrVm0TVcSYSe8f2gPxdB0ZE4wEzIg==
X-Received: by 2002:a05:6808:c28c:b0:43f:2a62:8b79 with SMTP id 5614622812f47-45a6bd4ad18mr1041781b6e.29.1767800044921;
        Wed, 07 Jan 2026 07:34:04 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.34.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:04 -0800 (PST)
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
Subject: [PATCH V3 08/21] dax: export dax_dev_get()
Date: Wed,  7 Jan 2026 09:33:17 -0600
Message-ID: <20260107153332.64727-9-john@groves.net>
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

famfs needs to look up a dax_device by dev_t when resolving fmap
entries that reference character dax devices.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/super.c | 3 ++-
 include/linux/dax.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 68c45b918cff..c14b07be6a4e 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -511,7 +511,7 @@ static int dax_set(struct inode *inode, void *data)
 	return 0;
 }
 
-static struct dax_device *dax_dev_get(dev_t devt)
+struct dax_device *dax_dev_get(dev_t devt)
 {
 	struct dax_device *dax_dev;
 	struct inode *inode;
@@ -534,6 +534,7 @@ static struct dax_device *dax_dev_get(dev_t devt)
 
 	return dax_dev;
 }
+EXPORT_SYMBOL_GPL(dax_dev_get);
 
 struct dax_device *alloc_dax(void *private, const struct dax_operations *ops)
 {
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 76f2a75f3144..2a04c3535806 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -56,6 +56,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
 struct dax_device *inode_dax(struct inode *inode);
 #endif
+struct dax_device *dax_dev_get(dev_t devt);
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
 void kill_dax(struct dax_device *dax_dev);
-- 
2.49.0

