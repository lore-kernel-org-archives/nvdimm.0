Return-Path: <SRS0=uw/X=ER=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_50,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C98C56202
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Nov 2020 02:21:28 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 089ED206C0
	for <linux-nvdimm@archiver.kernel.org>; Wed, 11 Nov 2020 02:21:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="k+jciPx6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 089ED206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 97F0C1671246F;
	Tue, 10 Nov 2020 18:21:27 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::b4a; helo=mail-yb1-xb4a.google.com; envelope-from=3peqrxwwkdokyopdlfwytpcdrzzrwp.nzxwtyfi-ygotxxwtded.lm.zcr@flex--ndesaulniers.bounces.google.com; receiver=<UNKNOWN> 
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 99F7E1671246D
	for <linux-nvdimm@lists.01.org>; Tue, 10 Nov 2020 18:21:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v12so830846ybi.6
        for <linux-nvdimm@lists.01.org>; Tue, 10 Nov 2020 18:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=C5CJXWtztogE8YGBqU6z1Oq0yEo7wNJFt1eX9+HlMtc=;
        b=k+jciPx6CWVV41y0DFUewoeFIV6SfcBQMoy2ESs5LNChqv0ObN0B1B/rfq8vbrWWG0
         heCk4rKfzOGxxHZm+BO3kAGjUqowwBnd5wzLt4B/6l+XPcbiY0cN5XpGZmt/jnXslOoc
         43kmzeEBbNGbO084siFjeDmLUwdToI8gNVUpArmhz/qwGD3/QV32cklxfMwqolgysbJ7
         AF/hMsLDz63vWpiL/to+3/KCe99EcVPnYpSy5hbWnTQ9GT7jQo+e743d7fsjdzGFkMTD
         2glgL1c49i8OS/vtZZpEdxXbuTF2vWtaMrl7J5jrKLUXxNbfe8OH1D45cV9kR2TLpSOl
         +WVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C5CJXWtztogE8YGBqU6z1Oq0yEo7wNJFt1eX9+HlMtc=;
        b=UrCh+LlOKkouJsDi51EXD/fUmfopzP9KpO0MXVWmowDaqE5ZijYWJZrJXoMGAULpva
         sFnIjrg5kTEVXGEQpcf/9yRnxtfIYUQrpPdCb4db/p+oyR5fd9/KOsF0M2W6whszJQGN
         DJTixhihS+KEzjcathjLhGfU0HAECs1NINTIAmqV4ndyMxwAFrC3GBmMHdOsK3VMh+7V
         FF/CYWIMQA/4M6ekxWX93MXMrCWUa4pG6Ju0m4ZZB5ZNCntxgg5PV7asLskdPvfpnMWl
         EnEZWn5EQ4fXS1UwRk/uinE2xcGLG59OB7xZOKKoVOOfo8GfRF3Jay/lO4fqJ6dGz6WI
         AJBQ==
X-Gm-Message-State: AOAM531tjyoBWrWH4sa2lh1zPxwArm49ysoFPf+DwMON1FCng8vDpHy6
	XePXPtaifIvQRMNUj22MA05AI4jynmXkP4RZBxA=
X-Google-Smtp-Source: ABdhPJxvxcfPlRvAs53Nfpq0r7dtScIlARHBVcwQzof4jhhEpU7A+HIt5nl8mHAB+KrrAMucIS0r20+3TCh+MWXSprw=
Sender: "ndesaulniers via sendgmr" <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a25:8809:: with SMTP id
 c9mr30786370ybl.521.1605061284396; Tue, 10 Nov 2020 18:21:24 -0800 (PST)
Date: Tue, 10 Nov 2020 18:21:22 -0800
In-Reply-To: <20201029101432.47011-3-hch@lst.de>
Message-Id: <20201111022122.1039505-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20201029101432.47011-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2.222.g5d2a92d10f8-goog
Subject: Re: [PATCH 2/2] mm: simplify follow_pte{,pmd}
From: Nick Desaulniers <ndesaulniers@google.com>
To: hch@lst.de
Message-ID-Hash: VPYLPVD4TQYTM6SNVE6MXRG6TCIJZPVH
X-Message-ID-Hash: VPYLPVD4TQYTM6SNVE6MXRG6TCIJZPVH
X-MailFrom: 3pEqrXwwKDOkYOPdLfWYTPcdRZZRWP.NZXWTYfi-YgOTXXWTded.lm.ZcR@flex--ndesaulniers.bounces.google.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: akpm@linux-foundation.org, daniel@ffwll.ch, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, clang-built-linux@googlegroups.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/VPYLPVD4TQYTM6SNVE6MXRG6TCIJZPVH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sorry, I think this patch may be causing a regression for us for s390?
https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/432129279#L768

(via https://lore.kernel.org/linux-mm/20201029101432.47011-3-hch@lst.de)
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
