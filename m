Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829E54EE853
	for <nvdimm@lists.linux.dev>; Thu, 17 Sep 2026 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789648105; cv=none; b=sBjQ1NzT019zQqOiWzfV2MRPe1ULgyCB8N+vJHbYFNVpJXrajckAtsDdEh1Vp5XcCs4YlDXfKfBG9O52aJcaPbTYOyLwOHpmVCumphp7QBv3GsOF9P86AQjkijxlVwxzKMGs0XgGM9mBsLSq85qIUN4TWzO01oIF3kMkcgseaCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789648105; c=relaxed/simple;
	bh=0+JgyF0oo3n2o9uBQku5EmBrQgG5ORRz/ZZCDwf6MHo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JFUz57QODtfrG7i9p3sdL7bOfy+PSFEM+MtAxhnNXAN0MVnuot2QvV2JJovboGPknTEX7e0eg01jaVJQh1Yj3TmQ+WQU6tMZVoCbQx3RtuJIda//AVWloAelENJBGqnm3i6B2UZlvkUjHPJPb4FvzGmUpQQpe5FyrulI5X5H5PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADH+ELh3KtqPoGACA--.43567S2;
	Thu, 17 Sep 2026 20:28:17 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: dave.jiang@intel.com
Cc: djbw@kernel.org,
	ira.weiny@intel.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] nvdimm/bus: Fix dev double put in nd_async_device_register()
Date: Thu, 17 Sep 2026 12:28:16 +0000
Message-Id: <20260917122816.2151081-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADH+ELh3KtqPoGACA--.43567S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF45Kw17tr1kAF48Xr4UXFb_yoW8JFy7pr
	s8Jas8ArZ7Grs8Ka1UZr1DuFyrKw1Iya4rury8J3y0grn8X345trWrWFWjqa1rArZ3GF1U
	trW7tw18JF4kArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
	v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwCY
	1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r48Zr
	WUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
	kF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07b5lk3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQNA2qrq02cxwABsu

device_add() takes and drops its own reference on every return path, so
the async worker only owns the reference that __nd_device_register()
took with get_device(). The failure branch drops that same reference once
more before the unconditional put_device(), which underflows the refcount
and frees the device while it is still referenced by its creator, as
reported by KASAN for the parent pointer access in this function.

Drop the spurious put_device() from the failure branch.

Fixes: 4d88a97aa9e8c ("libnvdimm, nvdimm: dimm driver and base libnvdimm device-driver infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/nvdimm/bus.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 45b7d756e39a..a1f33a03aba8 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -488,10 +488,8 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
 	struct device *dev = d;
 	struct device *parent = dev->parent;
 
-	if (device_add(dev) != 0) {
+	if (device_add(dev) != 0)
 		dev_err(dev, "%s: failed\n", __func__);
-		put_device(dev);
-	}
 	put_device(dev);
 	if (parent)
 		put_device(parent);
-- 
2.34.1

