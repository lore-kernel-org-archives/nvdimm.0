Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FB81FC0
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1650555601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S9DMw1QVObZXzp5ejmL5d1FwtHhPc8XTYmN4X9Dq3O0=;
	b=SX8ggy+WRRBiGbC8Q1kpyqVcUWAvP3bnbMT0S9FLEdiuRF4HYgOai1LgZLtXEwvPvMO1PE
	uU4kNqStOXJXL+Mpe9LB7aOCbMUzENzAUI7zZQs69eq4fuV+IWHV78OIBqcZ90y8P5VqbD
	CeHLLGdr45pV29tfiIs1L36v4Kl98JE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-kHYjyeOzN0-6oPzZ-801Kg-1; Thu, 21 Apr 2022 11:39:59 -0400
X-MC-Unique: kHYjyeOzN0-6oPzZ-801Kg-1
Received: by mail-qv1-f71.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so4204265qvb.21
        for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 08:39:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S9DMw1QVObZXzp5ejmL5d1FwtHhPc8XTYmN4X9Dq3O0=;
        b=o7fF6x4XYhv7M2oEqopP6QP9YO0lwCUidkj1tb44Zw2TWHrsoqXACa7DlcM2UNavfz
         6xS+s8DU0OlMfkZBTUFfx1ZIuZb24hRSdFunokXyfccOhnJAarI3o1ouWpUjClihyFQo
         +fviXvPxOHVMPdtAdx8VVCc7Eznrbwp9Ua5zdOGj0OghDAY+MWxtEOE8zkjZxkwdroCW
         75eavhWnbgNRX9DoqtHx3Jeiw2F5Sfn4ML8yqSmGp6MTflhhzs5Rdb1gvdascJpR0w9/
         +c6oEz/jR+CUxAbHTvpsg999IXHZ+ndO00NhEk/KCt6vmqhuKtEiLsNBoHbTgGaqyqO8
         DNZA==
X-Gm-Message-State: AOAM533ZSHUeTuQ+2OOobcgNymBRCseB3VXQ2u3JFGMUM4MmAqOGofAg
	74kR0+CxUDLhGsCIQRzl56jCUz+VPnb5uZgShGeKKC9x5ZxNRSujSGqNeka7visFUxUCGyMPueh
	4gktpbo8z+E2Voswa
X-Received: by 2002:a05:620a:2489:b0:69e:996d:7940 with SMTP id i9-20020a05620a248900b0069e996d7940mr12470770qkn.553.1650555599188;
        Thu, 21 Apr 2022 08:39:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCwL51TZHhleKjAOtyVvVuDn5ubOOLwr4iM0Tlnqh/J1qgACgnab0k7LSIjuU6d2UPFyXdzA==
X-Received: by 2002:a05:620a:2489:b0:69e:996d:7940 with SMTP id i9-20020a05620a248900b0069e996d7940mr12470746qkn.553.1650555598818;
        Thu, 21 Apr 2022 08:39:58 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k14-20020ac85fce000000b002f344fc0e0bsm2401950qta.38.2022.04.21.08.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 08:39:58 -0700 (PDT)
From: Tom Rix <trix@redhat.com>
To: dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Tom Rix <trix@redhat.com>
Subject: [PATCH] libnvdimm/security: change __nvdimm_security_overwrite_query from global to static
Date: Thu, 21 Apr 2022 11:39:51 -0400
Message-Id: <20220421153951.35792-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=trix@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Smatch reports this issue
security.c:416:6: warning: symbol '__nvdimm_security_overwrite_query' was not declared. Should it be static?

__nvdimm_security_overwrite_query is only used in security.c so change
its storage-class specifier to static

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/nvdimm/security.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4b80150e4afa..d3e782662bf4 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -413,7 +413,7 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 	return rc;
 }
 
-void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
+static void __nvdimm_security_overwrite_query(struct nvdimm *nvdimm)
 {
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nvdimm->dev);
 	int rc;
-- 
2.27.0

