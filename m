Return-Path: <SRS0=4vrS=BP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_50,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50798C433E0
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Aug 2020 13:44:55 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 23E7E22D05
	for <linux-nvdimm@archiver.kernel.org>; Wed,  5 Aug 2020 13:44:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="et3kZHN5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23E7E22D05
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id E60AD117DDD66;
	Wed,  5 Aug 2020 06:44:54 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=205.139.110.61; helo=us-smtp-delivery-1.mimecast.com; envelope-from=mst@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 36700117DDD64
	for <linux-nvdimm@lists.01.org>; Wed,  5 Aug 2020 06:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1596635090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WBH1LHbCDthOlF25HB1GNrSGXvGdUkDAo8hvALVyXYI=;
	b=et3kZHN5GgQWvP0XtDxVoTL2zhpFYIyZPrhSLTJ41yZKHVNsa/E1X8Dzd1StXJmuRg/nhU
	zM9jryYHNaNV7C+ZGU8QWzmcrV25yofT+kItmV+kMh/WTolxp+5SvrDkG+fHqvjvvK9RNm
	dqbCA9WSr8tket3ei3ugV8Vkb82ysMg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-p5D9afSXM-qj4DHPfU4iRw-1; Wed, 05 Aug 2020 09:44:49 -0400
X-MC-Unique: p5D9afSXM-qj4DHPfU4iRw-1
Received: by mail-wr1-f71.google.com with SMTP id 89so13595315wrr.15
        for <linux-nvdimm@lists.01.org>; Wed, 05 Aug 2020 06:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WBH1LHbCDthOlF25HB1GNrSGXvGdUkDAo8hvALVyXYI=;
        b=sLLsJFCtdsXQwyqs95Rq4NL7q+2xBhEqlTQgwv8IUI4OkhN1fkfdOFHVymNZksZ7I4
         UECH9gdUn82SOoYZhh4dTLcq1/oajCmcxnrdwNLWeXNRGj26kf+HC7pnvRMXXQ0AF9hh
         /yGuHs1V8low7JH2pYJWLKMdtz4qT+07zmXexCuRyXmxlopk8Xb/VrqocNNpvz6PvNaF
         rNb/fiJOh7foLJMDU3XSkPPH/+zc275zTAcdhI5EY7g+QlF+tijSdHNrrzj+XoiqfErs
         MpbXy7JLhJ45hA9KcgUPxPzlx9cx1Nt8OpiUN0OyAQBC0QKgEpmKbVTczZ8kWgRuCw+V
         CndQ==
X-Gm-Message-State: AOAM531gaGLIwW2DTX1inXOzZ1BOTP0xhCAEp3EWr2Z29H6Zdh6Az8l+
	tXM7q3GzlFJLTt6tm5U+XogwUhhDVVr/tTFPcok1JVQdg0R8mA0RM0Ir5TeFwjF8bG5kFIxxn6C
	VWB+p0ZcJp3PffCvZMF+J
X-Received: by 2002:adf:ab0d:: with SMTP id q13mr2728302wrc.134.1596635087916;
        Wed, 05 Aug 2020 06:44:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxc8ukE7mtzF0Xw22J8QjnJI7RUP7Alfizi2qIlpwN9G61AnzGldaFn2ZneBCQ7Es9dgmyqZg==
X-Received: by 2002:adf:ab0d:: with SMTP id q13mr2728292wrc.134.1596635087769;
        Wed, 05 Aug 2020 06:44:47 -0700 (PDT)
Received: from redhat.com (bzq-79-178-123-8.red.bezeqint.net. [79.178.123.8])
        by smtp.gmail.com with ESMTPSA id n24sm2989133wmi.36.2020.08.05.06.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:44:47 -0700 (PDT)
Date: Wed, 5 Aug 2020 09:44:45 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3 33/38] virtio_pmem: convert to LE accessors
Message-ID: <20200805134226.1106164-34-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200805134226.1106164-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=mst@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Message-ID-Hash: HXCS5G7GYUUNQVWOYZR3STJUOV2X6NIB
X-Message-ID-Hash: HXCS5G7GYUUNQVWOYZR3STJUOV2X6NIB
X-MailFrom: mst@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HXCS5G7GYUUNQVWOYZR3STJUOV2X6NIB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Virtio pmem is modern-only. Use LE accessors for config space.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/nvdimm/virtio_pmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 5e3d07b47e0c..726c7354d465 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -58,9 +58,9 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
-	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
+	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
 			start, &vpmem->start);
-	virtio_cread(vpmem->vdev, struct virtio_pmem_config,
+	virtio_cread_le(vpmem->vdev, struct virtio_pmem_config,
 			size, &vpmem->size);
 
 	res.start = vpmem->start;
-- 
MST
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
