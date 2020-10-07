Return-Path: <SRS0=DizB=DO=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A982C47095
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 04:23:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 00410208C7
	for <linux-nvdimm@archiver.kernel.org>; Wed,  7 Oct 2020 04:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fossix-org.20150623.gappssmtp.com header.i=@fossix-org.20150623.gappssmtp.com header.b="NTuSjpvg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00410208C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E46E8158AFE9B;
	Tue,  6 Oct 2020 21:23:48 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::1044; helo=mail-pj1-x1044.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 10F63158AFE93
	for <linux-nvdimm@lists.01.org>; Tue,  6 Oct 2020 21:23:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id az3so402778pjb.4
        for <linux-nvdimm@lists.01.org>; Tue, 06 Oct 2020 21:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBvDWr4/NX6bfMo1QfQQmBKKesecrbWEBvo2e7fmrPE=;
        b=NTuSjpvgjy5kj1W81BKPxH332c5uhzSH+NxY+Z5tBMrm4qiMe2l2HnxhqaSF/GZuU2
         U3wdgEJ3hZkNdClMz/wEm1OdNgv4WGJbXEDGEqAacHVo90SPOJpBbEodOnJ+vv00qiEV
         LIAV62sm3bfxfsgDCt4skYZQK4eJsDNj2dSfr4qXHE3uGyC3p5W9EeMNjM9UDVSzjbAd
         zmrCGlhlZ4G5ehm+Qy+GnR6L64qAcB2ZpS852Vspu6QjugJVn7yrc+0a6I+QLaW2i5l/
         GyemnOUPs1z8aAlE4m9Ra5sC42ufG7flhUFUydVYJdLigutUYCPAJ84h6Sp20oHqzNnO
         pFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBvDWr4/NX6bfMo1QfQQmBKKesecrbWEBvo2e7fmrPE=;
        b=HBorlMjOpj8LxIlPcVTWQ/X0jTvC7u+WrmyELC5+185hw/QWRHTGpc4+e2vAELOQD9
         HEojoaKHWIVFFP9j9YzPyf0j8otG9NHgMmHeKNCjl6rrb50gi/h3wWfDVed3+AAfMFoh
         yMzZzyoWCEsfw+TxHrDfcqAsV5c98LY4NZ7bSf45OgQHRf47PyrB4wW7QxqJQ1rPOVyV
         kSRNR4tB7dIBOL121QDq5jKgSD5Kdfzr0BS6AfxNq3ZPIqaNct3NZFFT52ZpT+FxzKx+
         oJvSLe+ZOhFHiCCp8lMSyg+Ro/DZdMMxWFIMHlpJivFIwm6/VrwdVHQdd2n6qubZbm40
         OyNA==
X-Gm-Message-State: AOAM532z8f7aRoNGvZyJr1ZtMdh0EHtQp/fTX06tZntuiD48xE1d/qJT
	z92xKWt4y9UKPRniEcHDmy7Ydr5YJP3AFQ==
X-Google-Smtp-Source: ABdhPJzdaytlp5UFUjHl/YZikmA+ZWnZNsCIHipULohqMpT2NKatBUMezAvMQuraxXjHj5w1mzW0qw==
X-Received: by 2002:a17:90b:1804:: with SMTP id lw4mr1274037pjb.9.1602044626394;
        Tue, 06 Oct 2020 21:23:46 -0700 (PDT)
Received: from santosiv.in.ibm.com.com ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id t186sm844499pgc.49.2020.10.06.21.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 21:23:45 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: Linux NVDIMM <linux-nvdimm@lists.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Harish Sriram <harish@linux.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH RFC ndctl 6/9] test/libndctl: Don't check for two formats on a dimm
Date: Wed,  7 Oct 2020 09:52:53 +0530
Message-Id: <20201007042256.1110626-6-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007042256.1110626-1-santosh@fossix.org>
References: <20201006010013.848302-1-santosh@fossix.org>
 <20201007042256.1110626-1-santosh@fossix.org>
MIME-Version: 1.0
Message-ID-Hash: WIBBBWSADODDIGXK6DMD53NW5VKCJE2C
X-Message-ID-Hash: WIBBBWSADODDIGXK6DMD53NW5VKCJE2C
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/WIBBBWSADODDIGXK6DMD53NW5VKCJE2C/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The number of formats is itself populated only when there is a nfit
bus present. So skip this sub-test for all other platforms.

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 test/libndctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 93cbc7a..aaa72dc 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2543,7 +2543,8 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 			return -ENXIO;
 		}
 
-		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0))) {
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)) &&
+		    ndctl_bus_has_nfit(bus)) {
 			if (ndctl_dimm_get_formats(dimm) != dimms[i].formats) {
 				fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
 						i, dimms[i].formats,
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
