Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB00472
	for <nvdimm@lists.linux.dev>; Sat, 10 Jul 2021 16:46:18 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id he13so22928436ejc.11
        for <nvdimm@lists.linux.dev>; Sat, 10 Jul 2021 09:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=FgRxku6Kq/BTQ7x6pg4bh4zbCPE8YN3oFjzx7M3K7qs=;
        b=WgKlXYRcVOBD9y9PjMK9fKUTZsFPTbCVkhHuMCzUc96hMYva0qJioWThSmG0JfMMGe
         qhPKm1C8s5HbOMag0/sloe9WZxglxXKQX58W6gL9DWZrTeRfCBaN9M8tFkRgiQeyQz59
         1eqkGdlQw8ZuaU9EamXvm/Vk0YXpGJtk/RrQFlSlDB18edcbJ5fsPGxdaLAKIkuNlsEo
         YymcPnt6rZLm1HEd7YOkRN7T0hZcBAQ8n5MD38SsQUMksMOTZ99P+PziiBofQJTrpKXL
         WQR+xZWWV5zjHWE8Kfu5Z2q6xrEhwbJGdQHzTv9q19j5i9VQyZw+ZqXWX2Y6eTKfZc8d
         YcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=FgRxku6Kq/BTQ7x6pg4bh4zbCPE8YN3oFjzx7M3K7qs=;
        b=KO7MM2+gI0Y6q0kJe7wTE69Mc7x6CTUclN89JH8GgrS8VPbH2oqJ6fqgMZrbK7nlL8
         ZdAgtgPQLIkaB5eS/Yp/6gBil3tC1GxxLxD3Csa3HuorgYA42YitGLHde7xs8+U1BmZr
         j3VffemW+vakutTM+NmOXs67b32sf64NqoIqfCicqqgXelUIJ6Tz1y64k3E+2tfAU4Bz
         CjdAGPZX0xDjukBvCh7SV9tz5wjXYqwt957+dP5ua7VAcxuvTAWZXYRQQ+kF9SAjeybC
         HFmrnPyTxikZTiV8CTyAsVvlNpDn28m3RO5YAVCZqRZOxgd0MJeAFyFxdcT9sQ9/Bf04
         ArxA==
X-Gm-Message-State: AOAM5337M+wNnyrixMCfE84AKwY7gcPODT9E9Ym/0HDPtBGxzSLMSkz+
	5rh4eTDpH0eaX2LemcKBfzY=
X-Google-Smtp-Source: ABdhPJwXNTFFablO4CB8vDpeLj4bBJB6IRJnqeT+134PmSKx88Q059C81g1pEL5wedTRgpU9XmU+mQ==
X-Received: by 2002:a17:906:3181:: with SMTP id 1mr44566282ejy.36.1625935577303;
        Sat, 10 Jul 2021 09:46:17 -0700 (PDT)
Received: from pc ([196.235.212.194])
        by smtp.gmail.com with ESMTPSA id o26sm3994026eje.96.2021.07.10.09.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 09:46:16 -0700 (PDT)
Date: Sat, 10 Jul 2021 17:46:15 +0100
From: Salah Triki <salah.triki@gmail.com>
To: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] dax: replace sprintf() by scnprintf()
Message-ID: <20210710164615.GA690067@pc>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Replace sprintf() by scnprintf() in order to avoid buffer overflows.

Signed-off-by: Salah Triki <salah.triki@gmail.com>
---
 drivers/dax/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 5aee26e1bbd6..bcae4be6ae76 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -76,7 +76,7 @@ static ssize_t do_id_store(struct device_driver *drv, const char *buf,
 	fields = sscanf(buf, "dax%d.%d", &region_id, &id);
 	if (fields != 2)
 		return -EINVAL;
-	sprintf(devname, "dax%d.%d", region_id, id);
+	scnprintf(devname, DAX_NAME_LEN, "dax%d.%d", region_id, id);
 	if (!sysfs_streq(buf, devname))
 		return -EINVAL;
 
-- 
2.25.1

