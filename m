Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E3D126F21
	for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410313; cv=none; b=p/G3x8svH6Rax8ZpnyxjBA3zD8FieDsz+l9Y/Mm4SeF7u2kY4WQp2C+CzufITkJK2nSxDIDkqisDvh8O5S2j7ajmkFcN6R/skRCDWPAZ3/tNLf2Sx9TkSN1zDdAClPXNNNbBWvXgyfdu/r9a3UsVkkokOiAs7V49+zlSqhA3bq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410313; c=relaxed/simple;
	bh=Dq3IXVMAl3LwKTvbPabCyz/Wl0bJyojQgrN3Tsz/e+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UlWXzP3niVa8P0zYC8il+wwg0t9oaBZq4Cn+1RCEfiVVYYIo0pae/P7PnbhOQqEqTeEg/QB4/BQZDoKy1S4CMUIq6Jyo35XIAzX3iodv6vzRYcB3hYY1xCpMkexIKhMMD2n82dJQE7aSaU9gB5vNxclo7pkHlWVXp2tM0UuYXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KorWQ7ys; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KorWQ7ys"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3c5ee4ce695so1178340b6e.0
        for <nvdimm@lists.linux.dev>; Mon, 29 Apr 2024 10:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714410310; x=1715015110; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lyJucMVndmC161Z9DZrkXcMb4iGiZ+dSnJlqt7NeU2c=;
        b=KorWQ7yslkJZHjsj9ZOf81fCqW25i8cEKf8iD6Fse6ImQHU7UDmebLoySWa5bxRg1q
         vAGh2zbXm4EtyDXMju847AqcbDDp88FriFaVOqK9/su6zgQcszPqtSXLWTEEDJBweOAN
         kzGGNlFICNlXB1eQ3RTlBuM5J4XLfb8yzjjFJa1zNabGLassNsH12RRWGOyKrAYX3IwK
         9h6SGFebff+zehGx6DT83EmnPuEqz9IBdF3JCuspBxWuBfsXEkzYSUU0gMECRbcxtQCi
         ebHq0L5/8tiuzfAjS7XbzrVdiqBG8mtE6vVh+jZ9WGoWR7Gr7+0QNUNtV141De9metk+
         lr7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714410310; x=1715015110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lyJucMVndmC161Z9DZrkXcMb4iGiZ+dSnJlqt7NeU2c=;
        b=APVIrlTioS+hTY2N82YrCxB8UgdkUtskVsUndVS4xqYwuO+1r2ui0IYlAYy2EtRuCs
         FqJ/WlGLpr0kcz+V1Idr2HcuXGA8cS+b2TXWIKKjklCWhP760U8BHapgLcIEMPaPsFbC
         WrdIBZ/g5vjXZeo/U0UXh4cn00NBTtoLwsxsn9hGCGNL8yCOsCBAoI6ya2sbO/ouX9JH
         fJX3JYmTvfNdYylPHjCC2GAEH6r7aeXvgOu4aD/pwojmRt8Eb6Q1bz8glPRRByMUkX38
         bJL4aJbbPimO4exo6gJfhKVQtHt6gmIBbx4pdNOB1NfydM9ICR+Nal/8KrTKyZb9qAB9
         PQ1A==
X-Forwarded-Encrypted: i=1; AJvYcCU/OoFckZRYtvQr3ZetCUYf7JdSmuKNsQ7yhLxq7XGJepzlP4OqQIDb6Qdx6SHAGi5E/ysBSQ3t8A5hbyhqRLT2DutvWo39
X-Gm-Message-State: AOJu0Yx/H88vRWOWX0N3EWmmrEY7WsENj12HYZakx/hs4CeXpcvQ/fsg
	4hGLnWktjyMU2qRVqkfYMwgTdMW62N7IA7SAQ/fux8oD6CATUiDt
X-Google-Smtp-Source: AGHT+IHCqWTpNSXlvdUZw5ucdR3X7rIc7toNINCsl6MqALgYwnAAdl+NtVvIB095bO1OU6/08opuLg==
X-Received: by 2002:a05:6871:a4ca:b0:229:faa9:3b35 with SMTP id wb10-20020a056871a4ca00b00229faa93b35mr12606534oab.21.1714410310612;
        Mon, 29 Apr 2024 10:05:10 -0700 (PDT)
Received: from localhost.localdomain ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id g1-20020a9d6201000000b006ea20712e66sm4074448otj.17.2024.04.29.10.05.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Apr 2024 10:05:10 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: John Groves <jgroves@micron.com>,
	john@jagalactic.com,
	Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	dave.hansen@linux.intel.com,
	gregory.price@memverge.com,
	Randy Dunlap <rdunlap@infradead.org>,
	Jerome Glisse <jglisse@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	Eishan Mirakhur <emirakhur@micron.com>,
	Ravi Shankar <venkataravis@micron.com>,
	Srinivasulu Thanneeru <sthanneeru@micron.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Steve French <stfrench@microsoft.com>,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Julien Panis <jpanis@baylibre.com>,
	Stanislav Fomichev <sdf@google.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	John Groves <john@groves.net>
Subject: [RFC PATCH v2 06/12] dev_dax_iomap: export dax_dev_get()
Date: Mon, 29 Apr 2024 12:04:22 -0500
Message-Id: <bcbc4e4a58e763ac31aade005f61b6676518e581.1714409084.git.john@groves.net>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <cover.1714409084.git.john@groves.net>
References: <cover.1714409084.git.john@groves.net>
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
index 4b55f79849b0..8475093ba973 100644
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
index 4a86716f932a..29d3dd6452c3 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -61,6 +61,7 @@ struct dax_device *alloc_dax(void *private, const struct dax_operations *ops);
 #if IS_ENABLED(CONFIG_DEV_DAX_IOMAP)
 int fs_dax_get(struct dax_device *dax_dev, void *holder, const struct dax_holder_operations *hops);
 struct dax_device *inode_dax(struct inode *inode);
+struct dax_device *dax_dev_get(dev_t devt);
 #endif
 void *dax_holder(struct dax_device *dax_dev);
 void put_dax(struct dax_device *dax_dev);
-- 
2.43.0

