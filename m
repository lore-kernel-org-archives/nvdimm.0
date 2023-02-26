Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384D364
	for <nvdimm@lists.linux.dev>; Sun, 26 Feb 2023 05:56:23 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id l15so3650580pls.1
        for <nvdimm@lists.linux.dev>; Sat, 25 Feb 2023 21:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ps7PPtmkV1wfKAGYjMd8DEEZ2jaRpzCcvl95Jx3hG3Q=;
        b=Y919pzF9HjdPEaxqQJ3+VWrmE1yAwv8f1ShwtatXfaJUlb7xwQvIwMwUpNvk2mLeyl
         pA32wARnZRm4Gpb1FfjbmSD/+EAEbSQpnevuVDFENf+vYTZG6nIKtGR5n9oY3Sd7sFOF
         OmBgtdNi2CpuKXOqJeTCa4Q3j4VmS40yBR8ecf2IzCnLqE5GlOp2BFvlVrr5i1T5hdLY
         WLqId5aIFRo/5K9UETp0FidD5KkHmlbq2DiO1Sl97sDwcvSi3Wqj3TJVOKn5LeDqomqW
         ApwT2tjdgMniuvvBclPE0xryR4QodJXofvRckFQGZ7XQhr+X8zoH2KxhwpzrjaxCFOhI
         EyBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ps7PPtmkV1wfKAGYjMd8DEEZ2jaRpzCcvl95Jx3hG3Q=;
        b=JNOD86vF6hyTyeZzG6/TQ35p5OcQ58AWDaxXHnTxdcag+E7/Vh0xxMG/IFfcIpEsk0
         WxKBqKB8bzRmZvOA16qsVoKXSBlFDqD5ZPgUggYnZveINnTQ4J7gV47fO8JY69aQtLSf
         Js1M+j56w4W0aQJRaeSmH9Fxsro8j76Zo5d390gty+wDccnepRu/A4LmLHkLy7pBqGoA
         2PWL5FhtEeTtrINvT+nCQecBggzyCixkyR1pUaqSRoPKMjq38tkN54AY4oZvOrSX8COy
         hKc+6RAj5Wld1bIflFMVFTv6PeWtk5I7f2OnU715/NIS7jgrmlQ4xUvGUZV9QNwHXrno
         LBWw==
X-Gm-Message-State: AO0yUKVhjcXptX/+LrSlyB1ADDeEg6uXaOnLJvp3BQoivCfZiDvz3FMg
	5AvMElW2D7q8jwpDaXTRGrI=
X-Google-Smtp-Source: AK7set/USgLACHG20TuGc+NO2lmQmZsRDGjXQY8KMULXPcThNbFtj/fymqPVEE9UHRF7kgsjlxr24A==
X-Received: by 2002:a17:903:230f:b0:189:5ef4:6ae9 with SMTP id d15-20020a170903230f00b001895ef46ae9mr27273116plh.45.1677390983349;
        Sat, 25 Feb 2023 21:56:23 -0800 (PST)
Received: from passwd123-ThinkStation-P920.. ([222.20.94.23])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709028d8100b00189e7cb8b89sm2081471plo.127.2023.02.25.21.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Feb 2023 21:56:22 -0800 (PST)
From: Kang Chen <void0red@gmail.com>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kang Chen <void0red@gmail.com>
Subject: [PATCH] nvdimm: check for null return of devm_kmalloc in nd_pfn_probe
Date: Sun, 26 Feb 2023 13:56:15 +0800
Message-Id: <20230226055615.2518149-1-void0red@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

devm_kmalloc may fails, pfn_sb might be null and will cause
null pointer dereference later.

Signed-off-by: Kang Chen <void0red@gmail.com>
---
 drivers/nvdimm/pfn_devs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index af7d93015..d24fad175 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -640,6 +640,8 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 	if (!pfn_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	if (!pfn_sb)
+		return -ENOMEM;
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
-- 
2.34.1

