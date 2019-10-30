Return-Path: <SRS0=P1Qp=YX=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE317CA9EC6
	for <linux-nvdimm@archiver.kernel.org>; Wed, 30 Oct 2019 19:16:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6F3402080F
	for <linux-nvdimm@archiver.kernel.org>; Wed, 30 Oct 2019 19:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="YNRHsI+l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F3402080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lca.pw
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id CB929100EA551;
	Wed, 30 Oct 2019 12:16:39 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::842; helo=mail-qt1-x842.google.com; envelope-from=cai@lca.pw; receiver=<UNKNOWN> 
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C0074100EA54F
	for <linux-nvdimm@lists.01.org>; Wed, 30 Oct 2019 12:16:37 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id l3so4825070qtp.2
        for <linux-nvdimm@lists.01.org>; Wed, 30 Oct 2019 12:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Cpa84iefVqkjjKhqw25JrRoeu7AV++eH5Wze4rYcprw=;
        b=YNRHsI+lzFIiZJuqWErT6nhqJdHUyOrITkT3K6GC6+WwQsRwHDvaP7tzLLxSxPz5JB
         9C77ZS54M3BSa6J7bRjLDbtzS8mqi5cXygauY0pVzMvLI8aRQTNPGdmZERtK1p7Wroz9
         gccEHjx45NGthf0L0f/068kTn9bkB1g8/+AEsA09Eu2To9ppMpcOgJHJFsELj8ld8YyE
         xjK3hAeky/7uf2skmKt21k7Oohf0EW+fIc7EjVCaHKRkLWSBaXgSNWR7CPxYOxricPxG
         MTq1NaftRGcMaSRSJCBXtQw8WEiZnhhDXxe5DiAX9/5Wf5FXjhVpqNPcIyniA65qwuhe
         qDcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cpa84iefVqkjjKhqw25JrRoeu7AV++eH5Wze4rYcprw=;
        b=PE3O4kydcygF0mY+oS8VVITB4BL24TK34oWHy5/UBnhX+2KHREFRTMi1F/92TauLfN
         Yso3EoEWIsux29ewubabIQFvYCtnsPTCif4j30CjfdE0orRxtm6ksAzasmJngeNsKbk1
         3j21bwoHMbpkXM7C9U5YLuA8sTCbh1NsfLI6boSUlvRP/rbu9MJWUDyKA6B698x33pux
         dhNwC4dpgqaJGBOMNcRfe4nAkudqVzvbuizEL5rZJebIBlH6mHC4jd86GJ89Xheg2MD9
         Qil+PrQ2HEDS0diks9jHribBSpdhl3IWx5FHY33dRiRHS7qN7s2PCo+AFDtAxD0KNkDG
         gvmQ==
X-Gm-Message-State: APjAAAUcP+SFDi21QvdJVM8JnpNJ09gBj9dcnpN0FlAVModfcyiw6VqM
	ofqxvpKaIu2p0MDyr6y1QoXL2g==
X-Google-Smtp-Source: APXvYqyC3vTZaFFNPiCvhN+5dfaKyIGMRbKBbGNx68oP0+sqyT+P89zOg9sJyPT8UnXmgHax7qvcAQ==
X-Received: by 2002:ac8:746:: with SMTP id k6mr1698563qth.135.1572462962616;
        Wed, 30 Oct 2019 12:16:02 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v205sm476037qkb.123.2019.10.30.12.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 12:16:01 -0700 (PDT)
From: Qian Cai <cai@lca.pw>
To: dan.j.williams@intel.com
Subject: [PATCH] nvdimm/btt: fix variable 'rc' set but not used
Date: Wed, 30 Oct 2019 15:15:39 -0400
Message-Id: <1572462939-18201-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Message-ID-Hash: AGU6UGG7QUF6377W35AEVFGMWEHNR5IZ
X-Message-ID-Hash: AGU6UGG7QUF6377W35AEVFGMWEHNR5IZ
X-MailFrom: cai@lca.pw
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/AGU6UGG7QUF6377W35AEVFGMWEHNR5IZ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

drivers/nvdimm/btt.c: In function 'btt_read_pg':
drivers/nvdimm/btt.c:1264:8: warning: variable 'rc' set but not used
[-Wunused-but-set-variable]
    int rc;
        ^~

Add a ratelimited message in case a storm of errors is encountered.

Fixes: d9b83c756953 ("libnvdimm, btt: rework error clearing")
Signed-off-by: Qian Cai <cai@lca.pw>
---
 drivers/nvdimm/btt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 3e9f45aec8d1..59852f7e2d60 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1266,6 +1266,11 @@ static int btt_read_pg(struct btt *btt, struct bio_integrity_payload *bip,
 			/* Media error - set the e_flag */
 			rc = btt_map_write(arena, premap, postmap, 0, 1,
 				NVDIMM_IO_ATOMIC);
+
+			if (rc)
+				dev_warn_ratelimited(to_dev(arena),
+					"Error persistently tracking bad blocks\n");
+
 			goto out_rtt;
 		}
 
-- 
1.8.3.1
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
