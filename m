Return-Path: <SRS0=JRRB=7J=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8763C433E2
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 May 2020 11:22:09 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E089207D3
	for <linux-nvdimm@archiver.kernel.org>; Wed, 27 May 2020 11:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="qmgUq0I6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E089207D3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 09B6D12270B01;
	Wed, 27 May 2020 04:17:59 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::635; helo=mail-pl1-x635.google.com; envelope-from=axboe@kernel.dk; receiver=<UNKNOWN> 
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 9BC2012267988
	for <linux-nvdimm@lists.01.org>; Wed, 27 May 2020 04:17:56 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x10so10024878plr.4
        for <linux-nvdimm@lists.01.org>; Wed, 27 May 2020 04:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7gJxdvCpfrIue0RzTQk7obMxzbW3P/jexa322JS6jTk=;
        b=qmgUq0I63dQ2fxzbhTuUO1HPoFuKTJDCCKA0uUwXHJ02CVggXfImEsCyjOw5g1M/B6
         7uy1TbpqSl35DbJJihbShNSfLZWbB5jnC1Q1PHaGWrWF6b3dqqaamxAu8bWXgvdpgeG/
         vGqr7Bh47yvhhjrMyN7G8WxeAZvNQTAkGbFMiMxL304wcD/RlC2ouNW9QkIfbjmT9NG6
         HNDCRMhO+sl+dvr3KX0ePD7uimis7UAIGumlrG7i2AhQ2gF6HpcMYe/fkUJBrA8y8l2f
         hl8lGM/7kjKwl/LsGgfh/4F/KON7ZiAbCb0V/K4votERrdvFnmbuwtmnVkXRCyro4/+p
         YcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7gJxdvCpfrIue0RzTQk7obMxzbW3P/jexa322JS6jTk=;
        b=ewgWIdjGmAXjDpHpwo08IyN5CjtKXPzD7nKYwh/bOgobkGIvaWbK+LB9gGQVm9R4t1
         kXPUISCeb9ehx8i2wv/B3KT0Y4kYQe7IqsT0ZNnD72Bf+kHOISavJ4MTGS9VCFq9uxbm
         EUqj/gam8ipHrDt/OuV8S5EL47X03ZfgTnf+dUmf/YCc5dzRSNGgFhZc+o9oYMLDGqZI
         fCRdJgfXmdODIbs5OZVumMLn1Tuy/4W4hLUEFh/Tk0PZY9H2KHpPINppaCgdRDZoz5bK
         857lkJjHSmR4AcKhesjOS3TsQXJ/d/J7+mKncjdXMuG/9uvosnBqIEKBDXsb8bClwane
         /41g==
X-Gm-Message-State: AOAM53106xv3oLMIVpT1nTKCAiJGAFwzmgWBtDgISN6vg9k0AVguVv9J
	12Qwv7NEx7OBNn49lPwPVLCB+g==
X-Google-Smtp-Source: ABdhPJy6PZ//6S2JWbZAJxsDE8wE3cmlRBZk4jwdGJuMizvUypFmxI08dabu3vfsUXeWFY3+3DUfDA==
X-Received: by 2002:a17:902:d3d4:: with SMTP id w20mr5510652plb.3.1590578526110;
        Wed, 27 May 2020 04:22:06 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:2cc3:8599:f649:862c? ([2605:e000:100e:8c61:2cc3:8599:f649:862c])
        by smtp.gmail.com with ESMTPSA id a16sm2317879pjs.23.2020.05.27.04.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 04:22:05 -0700 (PDT)
Subject: Re: block I/O accounting improvements v2
To: Christoph Hellwig <hch@lst.de>
References: <20200527052419.403583-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e807976c-4a6a-ac93-17b4-a6a7dfc438be@kernel.dk>
Date: Wed, 27 May 2020 05:22:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527052419.403583-1-hch@lst.de>
Content-Language: en-US
Message-ID-Hash: WRGCUOD7VFOQAHQPY72F3SWVC655X4Q5
X-Message-ID-Hash: WRGCUOD7VFOQAHQPY72F3SWVC655X4Q5
X-MailFrom: axboe@kernel.dk
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/WRGCUOD7VFOQAHQPY72F3SWVC655X4Q5/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/26/20 11:24 PM, Christoph Hellwig wrote:
> Hi Jens,
> 
> they series contains various improvement for block I/O accounting.  The
> first bunch of patches switch the bio based drivers to better accounting
> helpers compared to the current mess.  The end contains a fix and various
> performanc improvements.  Most of this comes from a series Konstantin
> sent a few weeks ago, rebased on changes that landed in your tree since
> and my change to always use the percpu version of the disk stats.

Applied, thanks.

-- 
Jens Axboe
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
