Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664AA35EDC1
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426468; cv=none; b=C5pVUswA7B8eOoJWggBboljjvdzsJEewd66tgS/a65Rqtd3FJCgPCjD1XlR1M2MtJipx1FBKd/68W/OXlNsB2AtIIg+JIHkJRFi4QlQxAmr3rDm4VMmvJYylRNNTXwvo5uouebtePtQ9peFXFDYQQa7HqfS7UvxBmtRtY9ifZos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426468; c=relaxed/simple;
	bh=9in78rjKHXFfg7w69sXqer35Ki4r88+O4RkMgHiDMEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn+oXJ2rictlJ8kHuYIQeppeDehbHaIwWex403nGNbrliGMITkEXbpgNQSHuwo1/TkB+9brI8Amvs0TR1cPuWOvlzfjnOGfIBwBn5X/8zgFK+AthC6rSwhRX234jQxrPuiQQYJh+ot0BfgSUD+Ea9T0Ij2AxMDldzeeE9hNoxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BF/OP0B1; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BF/OP0B1"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7cfcb5b1e2fso182995a34.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 13:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768426464; x=1769031264; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U7XgQVWhUwcysFnko8qRq5dHQ4c7d0Rm3BbWfFJ4FJk=;
        b=BF/OP0B1pFMV53Ri4R/ckR6GwEjI4ljqD3bINNInPK7tEjSgBuvhkHlHvI1u5stUQB
         V7zCHOagEmqe/kZiGBQ480Q87MYNTWtVsaBj6wa5+VpVLx6zaDCyd6cn3m5nouKnPRue
         puyOAp0GM1M4bjOk5UGiKA9mVyYT362eq1096o8k9m7fub6tLHascmYr2j6o6BYTFY5V
         9OK1Nl56nXQ0vvhGkMLh2yiBj7QlUb4LybNy64t74BiW7DziOLzibU32lwevFq0JBk6a
         CnIxC6v1ziqMtPaZgXuGeS7yPE4V7O7sgomemig+BT3kF4oPQpprSxkFoJxQIRTVWgNH
         9Efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426464; x=1769031264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U7XgQVWhUwcysFnko8qRq5dHQ4c7d0Rm3BbWfFJ4FJk=;
        b=SUe77xSF7vuNo3Ygy2yLEF4nLEdOpvoHFGUVmczT81yZcDtlR6XANWc4r8BYadCgS4
         SL4yp0njH8MwxhE9Fmwt8kfEKLMy1JzDemLaaX+7a77A6EGqbWYbCQto0WlRO0dQxAEb
         w8NYmuL/Aq6jC4YG3UoQ1lpLwlPRbtnZhZmWzw0ssUe+fqYDpwGBVlQlprF0/diBL76r
         ZY+v/b9W9dsxsxpLoNLpdqqVW48cvUEVJ8LnF4V9saxWoRS+hnu7s7IkOcuPngyp2XxP
         cX60uPPGuttDvuV4APsGJVfNKlitpSn5OI17/cU7DoSR0sbi0LVcT1g3ppcyeGlm+y3K
         uq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVbnlImnzJIybjvUReTGsmRr14cMxmpMLO4ANGAQUgBt3AfwyvouuywxnfkE6qM2HPqen4aOwE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYQ7YYQHL+tPAMugYauNwoCZMC7g5VQWOLX+j8SicrcEeoxpY2
	3M6A+6D7aOXli02VIZczsMTSAi0oIqiR3SrSHS/E3VmdqfLeOM/AEBvx
X-Gm-Gg: AY/fxX42yhB/FUjnamW/XqburNT850G2lkvvpir9vzCkLrqFPhsbQO4dv6PDE4Wi6AF
	mYZ8qHUtbsUmibD77VFM6OZJTxdqZOLSqa+RHw5FOTi1J3UX7u0B9tpXKPdgftwHO8AEzLszdVx
	v2N5/yxFQzxKVJLXGrewVh9zJaSpV7ebPaEgFAYg+SVy6ACgfBIHFgQdxbiKFG3tqkhuOR90qHi
	gcNVOsGkATebnw8j2N2mVrVUQO7hGcoeSqKO1/B9pfty67rtCK/6s2aR47Xec5VxRF7tNdIF2nV
	3PSvFY3k4GBYJNOkDZ2B/OXS5ImSPqUvKTLmr18pI3bnEwejzxE964UxEECOmRj9YUe8SK82lxN
	3nyOlt+pZupw85wb6q7ftLFUlSyW4v0gGOhhzhWSun8gt0QSLAkN3FNjyJJF39a1jJEPvrbdzHb
	DkVuUe/tnbeQ4F2v2QFMt8KQ5WJdt80M0d66f9GDK/UThm
X-Received: by 2002:a05:6830:1cc2:b0:79d:eccc:96eb with SMTP id 46e09a7af769-7cfc8b3a75amr2512388a34.26.1768426464258;
        Wed, 14 Jan 2026 13:34:24 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce478d9c2esm19771776a34.21.2026.01.14.13.34.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:34:23 -0800 (PST)
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
Subject: [PATCH V4 04/19] dax: Save the kva from memremap
Date: Wed, 14 Jan 2026 15:31:51 -0600
Message-ID: <20260114213209.29453-5-john@groves.net>
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

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 9 +++++++--
 drivers/dax/fsdev.c       | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..f3cf0a664f1b 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -67,8 +67,12 @@ struct dev_dax_range {
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
- * @region - parent region
- * @dax_dev - core dax functionality
+<<<<<<< Conflict 1 of 1
++++++++ Contents of side #1
+ * @region: parent region
+ * @dax_dev: core dax functionality
+ * @virt_addr: kva from memremap; used by fsdev_dax
+ * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
@@ -81,6 +85,7 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 29b7345f65b1..72f78f606e06 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -201,6 +201,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
+	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.52.0

