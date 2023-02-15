Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5D37B
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 16:51:42 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id v17so22482808qto.3
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 08:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkbCFn8Ee7nglxRTQaR3XeU/VL9CocntID81FAU1nqk=;
        b=H17CS+lQCeoyLFJlqYrrTp3KxYr23M+hndnYdXp7llPgioLluRk+RgXDnL/b5M8yL4
         6aL0TEk/5MsPJrEEK1upnAIHahuv+2PwaeL/MW+1+G53UvYTg/j+fSj/ntBHE1f91TLX
         t4jOz4rhaHIhyZM0T6ZVRSkVvaSCrT5uHtHLiVh7UorIZQv88wh9nCX3yn+8H1FrYRIB
         Bva8mla1HbTGF4/+fQ/EYlt7uK4JT6LsOIckY8LeFi080Psr/utIXVhicj2r4EDN78WP
         QDvpLy9ftLF5QA/w40I+c2yjf4fctBvMhusnfKyHwKVsNA4/kU8CkO7JKTXy6DGrApMm
         C0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VkbCFn8Ee7nglxRTQaR3XeU/VL9CocntID81FAU1nqk=;
        b=ENuaBa801G+EdzP7G9pAkyX5AEmY+O8eM7ewzVNcKReLQ85UsPXTisDJAY7bAJlRov
         1QYTml6PDsZsBJunHI045EAbP6vsdKnBonRtluN5rEXuyoKbsD2EAsWCltlVchRJMJT+
         RNd0jpCqfMR77JLSKJzAf2qPv/XwCsgiG6VTaDXZuAWD4QC6bfa6lTxwhlUy55yY62vY
         LD8wH0TlSnLNVtHVUBukUUTPZSNS3UgH5ENEsrbF8HxgJam8+xTXTJp9nClYfD9BJS2y
         2+JlUiQCeeOMLdc1ywu1AcXfpfdK6awFSELQWk8GxwdlljAdAuhnkaS7zsX8APDEl7iR
         8DHg==
X-Gm-Message-State: AO0yUKWR3moHl/Lfh591ltsqFG1YPedKIa/dQwUayKfIUBdoctkeUXa0
	R6BbwddGkK61dweB1A5XBWxKgT+QoOQf3JOdxJLEPr7zQReZAqLl8Jm/9EuP5pkmFQLvskXZXf1
	5QVbsclhXksGBNzCjFKUqGP7LhGbcryhh4iCpT7ko06JfBhpSXvUV7f8wCa+KbK0TxzIB
X-Google-Smtp-Source: AK7set8xzrg1aF02mVS1jVCEynsI0NZg626OTYs9dQA4tknf8LKJ8kTw+4YAIoXGLTNsmJd2uY8Y3g==
X-Received: by 2002:ac8:598f:0:b0:3bd:48:7097 with SMTP id e15-20020ac8598f000000b003bd00487097mr3521534qte.49.1676479901197;
        Wed, 15 Feb 2023 08:51:41 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id y10-20020ac8128a000000b003b68ea3d5c8sm13353529qti.41.2023.02.15.08.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:51:40 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 3/4 v3] libndctl/msft: Add custom cmd_is_supported method
Date: Wed, 15 Feb 2023 11:49:32 -0500
Message-Id: <20230215164930.707170-3-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230215164930.707170-1-mav@ixsystems.com>
References: <20230215164930.707170-1-mav@ixsystems.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It allows monitor mode to be used for this type of NVDIMMs.

Signed-off-by:	Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index b5278c5..b8ef00f 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -30,6 +30,15 @@ static const char *msft_cmd_desc(int fn)
 	return desc;
 }
 
+static bool msft_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
+{
+	/* Handle this separately to support monitor mode */
+	if (cmd == ND_CMD_SMART)
+		return true;
+
+	return !!(dimm->cmd_mask & (1ULL << cmd));
+}
+
 static u32 msft_get_firmware_status(struct ndctl_cmd *cmd)
 {
 	return cmd->msft->u.smart.status;
@@ -195,6 +204,7 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 
 struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
 	.cmd_desc = msft_cmd_desc,
+	.cmd_is_supported = msft_cmd_is_supported,
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
-- 
2.30.2

