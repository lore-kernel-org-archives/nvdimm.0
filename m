Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337631FB7
	for <nvdimm@lists.linux.dev>; Wed, 16 Mar 2022 05:21:45 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id p15so1839268ejc.7
        for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 22:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=FJPuvcpULrXU5rJIxqChK1QcwIzv3ZufSJl5Tvybh4Q=;
        b=Pi0mNJrZGf0xS0gPTi1wEYM9oEa9N9U6+KeW/SphwCtCMLelTdyH2/RGPTt4M00mGc
         lWRV5j7BYg6dJzMqj9DRSExxYZ7WDl/kbnpTDfDvObVyylt52rfcqBVPaNTzSd7lPBx+
         J6mvj01XvMNaYDH6PnF2GdcWlzSvIu5THKK+jBuHYTumIyK/NvLqqjlUEjT2lq4tdDbQ
         qlMdqOR5DbHt5mIw8PFkcPngHD/E/49lXq6PG4gUnXbU/sVwJMCr3VJLPokY3BoDfl+a
         msWHdYHI4A+ApGbYiwieXSu3lWIHXR5DjZpNYrNRU7H4BMuQq7IVWNgpIQ+D2JPEoPVK
         Wt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FJPuvcpULrXU5rJIxqChK1QcwIzv3ZufSJl5Tvybh4Q=;
        b=bWsj8MJo3/O7XqHKj826QxexW5QDILSdxwldzRAIO20oRwE8l1AzeTNvbylRUabuX8
         Cd7DYsVsvcBBjNEsXmTIipsYf5pCLnGAcJOAyAOkvY3GgqrBepj4s4yylSVEUE/U/meG
         HR10SuRnWl5SXWPNBOuJqPp3TCzRGV/ho8Ihraqt3BPNsMRuctE5QK0lUR0Vve46Bs8n
         NRaFrh8hQvPm+uYVUxd2Tt1Oq5r8cq1IEvT4o0x6cJO1SNnwuY6/1YUyveN5FLan2Gs1
         IABuRg/pTUetGjvJY5Xzp1qfZW8qLlmi35AS/2POtjeI2qvjBfVcPuvlX5ijmJ34qZ/C
         H9Fw==
X-Gm-Message-State: AOAM530qiWn0H4xn5IPiA0lOh0BNLD/OnlicEFi038Mnj5wpVK66KyW3
	xOyfDr8eJ3joHKnUHE0f5mg=
X-Google-Smtp-Source: ABdhPJyivZ/URHlB2xL5PAgwk7CHlC6dMQg2EP1/JL1OLFw8sLjTPvEWbukfEh2PKpSDFH6A/iDoog==
X-Received: by 2002:a17:907:60cf:b0:6db:f0a6:74af with SMTP id hv15-20020a17090760cf00b006dbf0a674afmr5994072ejc.317.1647408103284;
        Tue, 15 Mar 2022 22:21:43 -0700 (PDT)
Received: from felia.fritz.box (200116b826783100351493f9f729970f.dip.versatel-1u1.de. [2001:16b8:2678:3100:3514:93f9:f729:970f])
        by smtp.gmail.com with ESMTPSA id j11-20020a05640211cb00b00418572a3638sm430509edw.38.2022.03.15.22.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 22:21:42 -0700 (PDT)
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: remove section LIBNVDIMM BLK: MMIO-APERTURE DRIVER
Date: Wed, 16 Mar 2022 06:21:33 +0100
Message-Id: <20220316052133.26212-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Commit f8669f1d6a86 ("nvdimm/blk: Delete the block-aperture window driver")
removes the file drivers/nvdimm/blk.c, but misses to adjust MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

The section LIBNVDIMM BLK: MMIO-APERTURE DRIVER refers to the driver in
blk.c, and some more generic nvdimm code in region_devs.c.

As the driver is deleted, delete the section LIBNVDIMM BLK: MMIO-APERTURE
DRIVER in MAINTAINERS as well.

The remaining file region_devs.c is still covered by the section LIBNVDIMM:
NON-VOLATILE MEMORY DEVICE SUBSYSTEM, and all patches to region_devs.c will
still reach the same developers as before.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Dan, please pick this minor clean-up patch in your -next tree on top of
the commit above.

 MAINTAINERS | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index faa5e53db1dd..5eacf125e052 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11128,17 +11128,6 @@ F:	drivers/ata/
 F:	include/linux/ata.h
 F:	include/linux/libata.h
 
-LIBNVDIMM BLK: MMIO-APERTURE DRIVER
-M:	Dan Williams <dan.j.williams@intel.com>
-M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dave Jiang <dave.jiang@intel.com>
-L:	nvdimm@lists.linux.dev
-S:	Supported
-Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
-P:	Documentation/nvdimm/maintainer-entry-profile.rst
-F:	drivers/nvdimm/blk.c
-F:	drivers/nvdimm/region_devs.c
-
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dan Williams <dan.j.williams@intel.com>
-- 
2.17.1

