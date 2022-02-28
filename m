Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DF248CD
	for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 09:49:56 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id z2so10221911plg.8
        for <nvdimm@lists.linux.dev>; Mon, 28 Feb 2022 01:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KY+0Ivg1vSA1XaXQW6vtJsA4AuBXBDOS2j2Lb69bvkg=;
        b=lZmlnIMB1KDy7LvolDubvkcCurb9xuAnKdl+OxMKIbygv6rqnQlHsILNhi6QVW2O8/
         SJA7d8a67r7WxA3LU+Z2OA7gD71N/768nJABlTt44CdK6kMdagWENKPn9jVhLegs3EJo
         8bAZzFFzcxCwx0EDJZJQHGnYS88Nqpil3ObHBgTvvGi39Dyg4qsQUe4s0cuw4M5pti1D
         Cz7lqnHBf7pq0BPtluW/Tz5wEcLC+2nstdQDEIlC+cfsv9P9673wgLxoWxW5BD38Vt5i
         VgBgiwp92q+m8bNF7DTEBcrtlqiDlXjvxHKGGEh64aL+Yy3WbS56FeyZchD0r3dZbTYU
         lpFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KY+0Ivg1vSA1XaXQW6vtJsA4AuBXBDOS2j2Lb69bvkg=;
        b=ja3SiczBrMqkOpJOv0G1zxPgnq0fdf0hjeUREdJam8Z/PbgeSPTW5AYPGyOBLLAnz7
         63h5jIJd0mCxHgEKmov30aHZ6reIxoIRCDdLCbME6VO9Bu7d7qgrIB0j+/hCBmy/Nc7N
         MnLnCfBMAintnhErMe1fa4QYLAp4pSPtQ2Hg2rKvk5v63Q96dFtTjYGQ101xIpwJriNh
         MHFGeDpUA29iW6vFMYGpP1jheUs7Zj2vUyDVFLJblRIDB1hiSZSkt7eTgNaGQB3uyYiP
         p00FOiIgHk07YMRHQwETDtDl6NATZ3YRhkI/jaXB+6Gll7tLEzRSW4YQ5PDWU+AnXN/H
         Pg7Q==
X-Gm-Message-State: AOAM531GQYVgrJGgGVVtg/dn4kcR5vxr5n0ehLgChRa4M0105cy+V2nF
	4nKvFEk8OFEIYlxnxuIxU4s=
X-Google-Smtp-Source: ABdhPJwGzJ330n6ZAg/LXU5qOTuJRrtSbstxXYxrFqS3j7oOxt4hgVOU1dlCt/sDyAihPht4SFu7oQ==
X-Received: by 2002:a17:90a:9408:b0:1b5:3908:d3d1 with SMTP id r8-20020a17090a940800b001b53908d3d1mr15782855pjo.188.1646041796388;
        Mon, 28 Feb 2022 01:49:56 -0800 (PST)
Received: from localhost.localdomain (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id 2-20020a631342000000b0037487b6b018sm9802638pgt.0.2022.02.28.01.49.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Feb 2022 01:49:56 -0800 (PST)
From: Zhenguo Yao <yaozhenguo1@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com
Cc: nvdimm@lists.linux.dev,
	yaozhenguo@jd.com,
	linux-kernel@vger.kernel.org,
	Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: [PATCH v1] device-dax: Adding match parameter to select which driver to match dax devices
Date: Mon, 28 Feb 2022 17:49:38 +0800
Message-Id: <20220228094938.32153-1-yaozhenguo1@gmail.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

device_dax driver always match dax devices by default. The other
drivers only match devices by dax_id. There are situations which
need kmem drvier match all the dax device at boot time. So
adding a parameter to support this function.

Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
---
 drivers/dax/device.c | 3 +++
 drivers/dax/kmem.c   | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index dd8222a..a974cc1 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -452,6 +452,7 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 }
 EXPORT_SYMBOL_GPL(dev_dax_probe);
 
+unsigned int match = 1;
 static struct dax_device_driver device_dax_driver = {
 	.probe = dev_dax_probe,
 	/* all probe actions are unwound by devm, so .remove isn't necessary */
@@ -460,6 +461,7 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 
 static int __init dax_init(void)
 {
+	device_dax_driver.match_always = match;
 	return dax_driver_register(&device_dax_driver);
 }
 
@@ -468,6 +470,7 @@ static void __exit dax_exit(void)
 	dax_driver_unregister(&device_dax_driver);
 }
 
+module_param(match, uint, 0644);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL v2");
 module_init(dax_init);
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a376220..41ba713 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -214,9 +214,11 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+unsigned int match;
 static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
+	.match_always = 0,
 };
 
 static int __init dax_kmem_init(void)
@@ -228,6 +230,7 @@ static int __init dax_kmem_init(void)
 	if (!kmem_name)
 		return -ENOMEM;
 
+	device_dax_kmem_driver.match_always = match;
 	rc = dax_driver_register(&device_dax_kmem_driver);
 	if (rc)
 		kfree_const(kmem_name);
@@ -241,6 +244,7 @@ static void __exit dax_kmem_exit(void)
 		kfree_const(kmem_name);
 }
 
+module_param(match, uint, 0644);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL v2");
 module_init(dax_kmem_init);
-- 
1.8.3.1

