Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B847499
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 15:25:00 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so41430895ad.3
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 08:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683645900; x=1686237900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TX3aP/5DthuPCekKZDcqCd6crocwyObcAs1lRnioK90=;
        b=F5MUoBUE5u7DgsnADrU5ePszG0mAePgoJ0z1HVnRECMkTIO8vxBhxasZ7uC203/mk0
         eJophLn+d41ivCp0VZ0mekoyPYXrbfTTw98yEMc/534O0JJlQW4gNfsE2q4oYoZHeU82
         +2gmUQeRDsxRBLXFtwlhKorwSPaPybs0rsGVaurZlbo9H+KL3sNzcScM65Zr2IuOgu7q
         L5w5GctN9NyaN9IIvUfAOZ1Gf6kxwm8QP9Ddpp+yUlANGtmtA/CWkpEKGfbaZbym5WJD
         t1nP/ZL8eIMtxsK5qCXOl9MkFjSQcRp/lHvOC4Bmfna6HzMjLdiQP0vtMJlrgzALUYZM
         r7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645900; x=1686237900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TX3aP/5DthuPCekKZDcqCd6crocwyObcAs1lRnioK90=;
        b=YlCCCUxdPVniyOTRFeC6fqxzfEgr2kPcoLUPMM+cJdOnpcP+HMvZXEsvg5L6vAaHui
         HJkOtV/0Jm/luDOAt2CXjLubBATuz9dxfKbi/dBJHneLRR7fJAn7UmLM3tC8ylxujsXB
         TbNgI1UGUk3nq6KukUmpXtuheSdRkSe6q4z+9zWrg4wVbvKHzUWPJLFOG/RpX+x+Pgwt
         YPc+q80f5fgdKoGQXb6Ps4hDLJDcBcSQelVMfJfQ7N96xWYg1/4wqO+QXeJskn3HmmZw
         8NfhlE/OQdVHfg7L+/u4t+WYrWQAgLJgUq4kfcSuj66PjPxwhe5i8igvLv8/ZwGSroZL
         CV+Q==
X-Gm-Message-State: AC+VfDyYEmef9CJr95laXIzOtD0jsdfKjnP4hV0Figxk4pHrm+IInaxj
	l6PVFlEhqoFF10I9qA048Bo=
X-Google-Smtp-Source: ACHHUZ7qgn7AWYXmlGL/WnKq4Wk7cwfgJorb5hF6+xT0HWc/i8XXrOIez/uRh4nQJe7Z+IERMa3vbA==
X-Received: by 2002:a17:903:2308:b0:19d:778:ff5 with SMTP id d8-20020a170903230800b0019d07780ff5mr18797505plh.15.1683645900506;
        Tue, 09 May 2023 08:25:00 -0700 (PDT)
Received: from localhost ([1.230.133.98])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090276c900b001aaeaa27dd5sm1697344plt.252.2023.05.09.08.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:25:00 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [ndctl PATCH 3/3] cxl: fix changed function name in a comment
Date: Wed, 10 May 2023 00:24:27 +0900
Message-Id: <20230509152427.6920-4-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
References: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cxl_memdev_target_find_decoder() has been renamed to
cxl_memdev_find_decoder in Commit 21b089025178 ("cxl: add a
'create-region' command").  Fix function name in a comment.

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 cxl/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index 71f152d9e5a5..45f0c6a3771c 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -676,7 +676,7 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		}
 		if (cxl_decoder_get_mode(ep_decoder) != p->mode) {
 			/*
-			 * The memdev_target_find_decoder() helper returns a free
+			 * The cxl_memdev_find_decoder() helper returns a free
 			 * decoder whose size has been checked for 0.
 			 * Thus it is safe to change the mode here if needed.
 			 */
-- 
2.34.1

