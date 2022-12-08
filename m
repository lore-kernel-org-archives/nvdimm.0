Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863207F3
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 08:55:26 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id c7so756163pfc.12
        for <nvdimm@lists.linux.dev>; Thu, 08 Dec 2022 00:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6VayokB70LyrjXyEVWXgl8dkywJiJ31ush1u5QME9Tk=;
        b=C0p48f4zpfmKrFRC7iJWW38eFBvFreifFdLYzew/eWTOnEWLrf4Rec7rra16DB2OAv
         g6pUj+47xCV17nBOXuIjD7gYLZbqPXHjodmrpj8SzA0wctQqsrnMCMtUk3JCVUJnQJDL
         f2c8wvIDA1W0GLJMHx4g55gxi5D1SIXU4cwLWkUlqqNnmsam/sEOGOu0gnXgzucoo+b5
         TPLidokkjGh6Sg7WH9BftcmV6TzjWzmNLzSj0769x+lj/9q5sJnfimWRxewpTGQFv6Hh
         +DXVSIm1aPR0H1QvYu/5Zw8cH/2JJZBW0975UEhnzrYYpfjvIlAodMbKcEc8e9hWM4uY
         SKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6VayokB70LyrjXyEVWXgl8dkywJiJ31ush1u5QME9Tk=;
        b=i9FkcZSGurdvFKTG1Cu1pyWhE8FkP5RdSp0vxAoo71cggzb6/YQ+pEbqUY4+dsPrWk
         jNK67iP33tFHeD8UqgLmw/q4rGoeAZU5BXCZDdYXyzkXpUwEolmAlywVTRPRoBZjj7Wb
         divtJvEhdW/SNquH0g4Nz2StcectAAJoc/vpSdCfXqT+G1vbN5UjSgfjd3RRMeT6EQiF
         T4ELZp578c4C7xEnLu0cg9PH7DQPALx/2c2+gUvlpXr3QPzCM5BSzDXcDa7irI08Ec64
         A7zJY05lJeOeCpZfPL7Lpy48lGda+AcQuWcsLb8iha+oWnyiTO4b1M5g7DZ9nhtZzrYS
         nDsA==
X-Gm-Message-State: ANoB5pnelnB6F3JqrKsWFchuFRkVlWvhPnm2XZOi2hQjHHFkaZoilBAQ
	tFSKuEJhYHks5GLv74/5yf5Hrg==
X-Google-Smtp-Source: AA0mqf61iqjNUTJ3MoLwp1y/7j/mwSj98Di9I2tLZhII1HDwxBs6fk7hVhzy/DYluSIMVt0fv0vgyw==
X-Received: by 2002:a62:6d46:0:b0:563:54fd:3638 with SMTP id i67-20020a626d46000000b0056354fd3638mr97634913pfc.44.1670489725917;
        Thu, 08 Dec 2022 00:55:25 -0800 (PST)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b00183c67844aesm16158990plg.22.2022.12.08.00.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 00:55:25 -0800 (PST)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	muchun.song@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] dax: Kconfig: add depends on !FS_DAX_LIMITED for ARCH_HAS_PMEM_API
Date: Thu,  8 Dec 2022 16:55:14 +0800
Message-Id: <20221208085514.8529-1-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The implementation of dax_flush() is non-NULL if
CONFIG_ARCH_HAS_PMEM_API is selected. Then if we select
CONFIG_FS_DAX_LIMITED with CONFIG_ARCH_HAS_PMEM_API in
the future, the dax_flush() in the dax_writeback_one()
will cause a panic since it accepts the struct page by
default:

dax_flush(dax_dev, page_address(pfn_to_page(pfn)), count * PAGE_SIZE);

Instead of fixing this, it is better to declare in Kconfig
that pmem does not support CONFIG_FS_DAX_LIMITED now.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
BTW, it seems that CONFIG_FS_DAX_LIMITED currently only has
DCSSBLK as a user, but this makes filesystems dax must support
the case that the struct page is not required, which makes the
code complicated. Is it possible to remove DCSSBLK or change it
to also require struct page?

 lib/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index a7cd6605cc6c..6989ad3fea99 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -672,6 +672,7 @@ config ARCH_NO_SG_CHAIN
 
 config ARCH_HAS_PMEM_API
 	bool
+	depends on !FS_DAX_LIMITED
 
 config MEMREGION
 	bool
-- 
2.20.1

