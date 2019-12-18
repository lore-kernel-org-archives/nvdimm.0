Return-Path: <SRS0=X/oK=2I=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE91C43603
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 16:16:25 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 54A78218AC
	for <linux-nvdimm@archiver.kernel.org>; Wed, 18 Dec 2019 16:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="tRnFOYF/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54A78218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 466FE10113663;
	Wed, 18 Dec 2019 08:19:47 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::343; helo=mail-ot1-x343.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9CEAD10113636
	for <linux-nvdimm@lists.01.org>; Wed, 18 Dec 2019 08:19:45 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id h9so548511otj.11
        for <linux-nvdimm@lists.01.org>; Wed, 18 Dec 2019 08:16:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bQp6lLSFsS8pqkcDpe8OVwPL/u8pI2v8s9QRkMC8/LY=;
        b=tRnFOYF/epm7tidSQIRXBdeBxXIa4BJo1VRQsmwhGTjWmPRErT92f/jiOjkTgqFwgh
         A84Btf6w+aSgwBxMjQw7gZkdpii6YTSJbbOxdmwQm4AB3/K7Sh8Oou6UKzSR7rqOEMV4
         +EEwK1HiVoS46TOpj237MjnZTyDq6RTZQkWs/4mGPaLmiOFC61x/cITw4HfBRLMxh6GJ
         lIFcaFfkq4zxkzYzXbR2Og5i0Tzhny7wjqPSQbA6BNbgEFHpA+6ytgfc6K28KamWUNlG
         8r4/Ar8pFOHJUiKNqv3J+ed4/+hqJcY/u5uz0UDHGqk8bjzYzSEhWRteEbWH4d6hs4RE
         /bCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bQp6lLSFsS8pqkcDpe8OVwPL/u8pI2v8s9QRkMC8/LY=;
        b=Cm7Nw/CRSre5lIOLwKk801QkJVjHqEwJgZcpLxA37PfZKsW1W/AZb/ssEo0pbWOLTT
         G1F+0vTjvMTza7dWSRyAEbwEF9WWGr8q9GXfMVAq3t28ZIhe+zYGXSCUKiImlP4ru9bB
         b5zrUrVqq4vHTB7FM2Tm91bG8eddX9RrWvx228tSeX05/FXDZePj47ZF9zuYW1l+QHNl
         mHghvN+rGTi9DdPSxtOThcA4AQ87lhE3Dp2RMkJFnfW6QCgGG1PUaz+pbvgpE3O0/OKY
         F9a3jmgspW5c87sMx+eNlVTzSGW0iFdr3OY+y0lPoQ0uf6nEmbTg+Me+wCBqeo9ZX9vF
         ZSLw==
X-Gm-Message-State: APjAAAV/VynV1DJyNs1/VPWaz69HKU4c/anhrCL2AOxkB1Wo3s4Jsg+8
	ha4cN/c4JK+vjHI+KlLQ9maEN9JQgdUmbTacZvv3aw==
X-Google-Smtp-Source: APXvYqwEg3IS2Fr0jEUrhRTS22qd4QsBxlvGobOYtVgWk5VzqbAIWO93VIpuu/k8Mp/blvn1XgfMxt3zEIiWwBtMTzI=
X-Received: by 2002:a9d:4789:: with SMTP id b9mr3233923otf.247.1576685781765;
 Wed, 18 Dec 2019 08:16:21 -0800 (PST)
MIME-Version: 1.0
References: <20191218025145.26741-1-yi.zhang@redhat.com>
In-Reply-To: <20191218025145.26741-1-yi.zhang@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Dec 2019 08:16:10 -0800
Message-ID: <CAPcyv4h6XgTB7Dv_PAVSjU+0cEw5tsVf3BUYGCPfxRudEKamrw@mail.gmail.com>
Subject: Re: [PATCH ndctl] ndctl, test: add bus-id parameter for
 start-scrub/wait-scrub operation
To: Yi Zhang <yi.zhang@redhat.com>
Message-ID-Hash: IJH5CSPFDOMUI5R2KZNQ5DBROSYGT2ZK
X-Message-ID-Hash: IJH5CSPFDOMUI5R2KZNQ5DBROSYGT2ZK
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/IJH5CSPFDOMUI5R2KZNQ5DBROSYGT2ZK/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 17, 2019 at 11:18 PM Yi Zhang <yi.zhang@redhat.com> wrote:
>
> On some NVDIMM servers, scrub operation will take long time to be finished
> as it start on all nvdimm buses in the system, add the bus-id parameter to
> do the scrub on the NFIT_TEST_BUS0

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
