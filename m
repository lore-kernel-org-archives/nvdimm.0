Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F8536A
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 03:31:50 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id k1so3685019pfu.2
        for <nvdimm@lists.linux.dev>; Wed, 02 Mar 2022 19:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZtUvw3ZALmibfhioe1cE1cnVZR/Sbit8bfsFXqhXpk=;
        b=R889e/UhGXgW9S0vzeC67QxDykTwNM796kvjr+1ckA60LLU5z7oOpoFl7sZYJ/tfbX
         wcHDWmT0mADRl21Gss+yBSksjIeKQCthjIIhaL64IWZ6tjiSHBr1Vr/s9/knMqEfirdP
         6wmXbhc3wVCh5eNkp8vT2b4DNpWCGO2HJS9qv+7CFIWI7RMU6Y2L4u2GyFd1M7P1v2i2
         yRGc4+j/hioGlpxNYyD+lJIdq80qqSn6zOdNUnojOcuXnQuUoVPh725lNe//9Vb8277L
         0vtQ2hsqKYZeEshvvHthxwk/kfSuLzvTxxbNmg31gIwuFMXAEqqS6+BvcvYom7llqRbc
         Xx4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RZtUvw3ZALmibfhioe1cE1cnVZR/Sbit8bfsFXqhXpk=;
        b=qi9BYrd9FT9cMzVQMLqHRluGvLXnUoR3Eh6tMTuZvzdg4oRkWlMkxL7Tfg9gPmwp/c
         VS48nYDTd1iq77Dp2PQ6gCccQjc6HVd6sn3xqYGnRfUoN7il5UXwirYS5c9Bm7rUwfz5
         hPwG/YOyaZb/95hF08nJh+d/dpmLhkWzCqZRm/BhiuD8iDofNiB1dWJ6Dj0boKHDPoBB
         EVILty2p3aAmi7wIRGfrp2piaCo5TVanHTgTOBuZ02TwJV6dsczV42HzeW5MsFNX8GdA
         PqocBXW8fKPMiA+49UGmpMa3FBFSnNIvk1kZdNPqkCWscHhx/usUO4VJLmgrrBFSKE9V
         2PcQ==
X-Gm-Message-State: AOAM533hHVJtq9yQYJOYoeM8pHW45uniFU/UmjQ2KVFfl4NSHw/BVQs2
	C4bqNwGNkMduk2CcrDkLIzc=
X-Google-Smtp-Source: ABdhPJwah2kbQNm59hmoFB1LFxz1aX5pX+VgN7aUlOeSs1kAzVW0ZJUqmjy0WCf0givJuFhU4mWDDw==
X-Received: by 2002:a63:e74d:0:b0:372:645d:d9ee with SMTP id j13-20020a63e74d000000b00372645dd9eemr28697178pgk.228.1646278310304;
        Wed, 02 Mar 2022 19:31:50 -0800 (PST)
Received: from localhost.localdomain (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id t12-20020a056a0021cc00b004e105f259e8sm626785pfj.152.2022.03.02.19.31.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Mar 2022 19:31:49 -0800 (PST)
From: Zhenguo Yao <yaozhenguo1@gmail.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com
Cc: nvdimm@lists.linux.dev,
	yaozhenguo@jd.com,
	linux-kernel@vger.kernel.org,
	Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: [PATCH v2] device-dax: Adding match parameter to select which driver to match dax devices
Date: Thu,  3 Mar 2022 11:31:32 +0800
Message-Id: <20220303033132.27750-1-yaozhenguo1@gmail.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

device_dax driver always match dax devices by default. The other
drivers only match devices by dax_id. There is situations which
need kmem drvier match all the dax device at boot time. So
adding a parameter to support this function.

Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
---

Changes:
	- v1->v2 fix build errors report by kernel test robot <lkp@intel.com>
---

 drivers/dax/device.c | 3 +++
 drivers/dax/kmem.c   | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index dd8222a..3d228b2 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -452,6 +452,7 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 }
 EXPORT_SYMBOL_GPL(dev_dax_probe);
 
+unsigned int dax_match = 1;
 static struct dax_device_driver device_dax_driver = {
 	.probe = dev_dax_probe,
 	/* all probe actions are unwound by devm, so .remove isn't necessary */
@@ -460,6 +461,7 @@ int dev_dax_probe(struct dev_dax *dev_dax)
 
 static int __init dax_init(void)
 {
+	device_dax_driver.match_always = dax_match;
 	return dax_driver_register(&device_dax_driver);
 }
 
@@ -468,6 +470,7 @@ static void __exit dax_exit(void)
 	dax_driver_unregister(&device_dax_driver);
 }
 
+module_param(dax_match, uint, 0644);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL v2");
 module_init(dax_init);
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a376220..2f1fb98 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -214,9 +214,11 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+unsigned int kmem_match;
 static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
+	.match_always = 0,
 };
 
 static int __init dax_kmem_init(void)
@@ -228,6 +230,7 @@ static int __init dax_kmem_init(void)
 	if (!kmem_name)
 		return -ENOMEM;
 
+	device_dax_kmem_driver.match_always = kmem_match;
 	rc = dax_driver_register(&device_dax_kmem_driver);
 	if (rc)
 		kfree_const(kmem_name);
@@ -241,6 +244,7 @@ static void __exit dax_kmem_exit(void)
 		kfree_const(kmem_name);
 }
 
+module_param(kmem_match, uint, 0644);
 MODULE_AUTHOR("Intel Corporation");
 MODULE_LICENSE("GPL v2");
 module_init(dax_kmem_init);
-- 
1.8.3.1

