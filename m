Return-Path: <SRS0=AX0L=F2=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4A4C433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 04:25:43 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7FF012311B
	for <linux-nvdimm@archiver.kernel.org>; Tue, 22 Dec 2020 04:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FF012311B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 44B62100EBB6F;
	Mon, 21 Dec 2020 20:25:43 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::62b; helo=mail-pl1-x62b.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 72F78100EBB6B
	for <linux-nvdimm@lists.01.org>; Mon, 21 Dec 2020 20:25:41 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t6so6787650plq.1
        for <linux-nvdimm@lists.01.org>; Mon, 21 Dec 2020 20:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xhAFrR9jtzwDWeloSl3q32TBY64JH9RSrkYJWBlq3yk=;
        b=ga9791ueqfoVvKJTBeDlUb81kHC/6NyyhsOWPP6UGtpgvLY0Ya7NN5hl1lAbGkR6m7
         sIX/qQaUVa4WpT87/wYTRePk/BoDK/11QVFCxIf5epqO+9Xcpkq6qLre8djkVwrQLgO5
         mk6m4bHQfDaGyo61jCS2mfHTyNqqiW0zByksuqgMOD3NdOnPQ5toDQDrb+YnzOYu2jJ3
         Jsh6mFAc+GTVhwQYbFnT73mbBEQKWgUKtdIYtfZVCUH7sxqy6Ngp0ENT/g4BR3KpdD2V
         ie5GEEuA1BA5sikZgSxoif0dnBz4vkTuIsNX2t7U6Jz5wSAbcL7MP9t17rLI0M5Kma8L
         flQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xhAFrR9jtzwDWeloSl3q32TBY64JH9RSrkYJWBlq3yk=;
        b=VxDXO1jbmQxUmTjmEC26UI1oxtbBShuK891rTK2fQHGGAFmmDPYiDIKQ7GQuBtiKSM
         tMsZK4txB10EUgSmWMQ31Olh+HwaNwnChiD2hBR00ShNk8rYA8tLcOBK+cdCfH8vpYNM
         uA5c5+l4HqEkKfGU57vniojdcpEXpQcNeSZ/ZhY34DKb4u5mltuzPhSq18Yabp5y6NaA
         Lk/yPYtGmPwpJPbTXJYiaFegMjc3ChAJ43a6yWKk1XeNCqYUC09hxwVH7wMvlcM9Xe81
         A078UdVHQmQGjzjrBzXLWopsZWY8xrOaW8XG17TZ7U+3MnzioKzlyZhyZXcyCbc4fq4R
         ZHeA==
X-Gm-Message-State: AOAM533HGaNBIhim30AgggcLsPLT83wV+dey4cHvwgbJ0pni2w5etApK
	j7s8Klz3MVARjGMSCw4VHoOl4Tt/g1a8Hg==
X-Google-Smtp-Source: ABdhPJxfoGW0MTnCmsknwQmMYVbf+6IoAsRBXYQBmSqBBuABlRaFuxeoDJogxY2zSFXoKMJXYEQW7w==
X-Received: by 2002:a17:902:b406:b029:db:3c3:e4cd with SMTP id x6-20020a170902b406b02900db03c3e4cdmr19370744plr.79.1608611140918;
        Mon, 21 Dec 2020 20:25:40 -0800 (PST)
Received: from santosiv.in.ibm.com.com ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id z13sm17765992pjt.45.2020.12.21.20.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 20:25:40 -0800 (PST)
From: Santosh Sivaraj <santosh@fossix.org>
To: Linux NVDIMM <linux-nvdimm@lists.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Harish Sriram <harish@linux.ibm.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Subject: [ndctl 4/5] test/libndctl: skip SMART tests on non-nfit devices
Date: Tue, 22 Dec 2020 09:55:15 +0530
Message-Id: <20201222042516.2984348-4-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201222042516.2984348-1-santosh@fossix.org>
References: <20201222042240.2983755-1-santosh@fossix.org>
 <20201222042516.2984348-1-santosh@fossix.org>
MIME-Version: 1.0
Message-ID-Hash: HGKKWIRCJWUEFHYMBP3UNP5GARETUF4W
X-Message-ID-Hash: HGKKWIRCJWUEFHYMBP3UNP5GARETUF4W
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HGKKWIRCJWUEFHYMBP3UNP5GARETUF4W/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is just a temporary check till the new module has SMART capabilities
emulated.

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 test/libndctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 5043ae0..001f78a 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2427,7 +2427,8 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	 * The kernel did not start emulating v1.2 namespace spec smart data
 	 * until 4.9.
 	 */
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))
+	    || !ndctl_bus_has_nfit(bus))
 		dimm_commands &= ~((1 << ND_CMD_SMART)
 				| (1 << ND_CMD_SMART_THRESHOLD));
 
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
