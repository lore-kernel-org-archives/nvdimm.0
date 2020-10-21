Return-Path: <SRS0=d0Fg=D4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=BAYES_50,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3FEC388F9
	for <linux-nvdimm@archiver.kernel.org>; Wed, 21 Oct 2020 14:24:23 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4A672224E
	for <linux-nvdimm@archiver.kernel.org>; Wed, 21 Oct 2020 14:24:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4A672224E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A7A6016081B3C;
	Wed, 21 Oct 2020 07:24:21 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=209.85.210.194; helo=mail-pf1-f194.google.com; envelope-from=snitzer@gmail.com; receiver=<UNKNOWN> 
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 4A1F316081B3A
	for <linux-nvdimm@lists.01.org>; Wed, 21 Oct 2020 07:24:19 -0700 (PDT)
Received: by mail-pf1-f194.google.com with SMTP id b26so1582958pff.3
        for <linux-nvdimm@lists.01.org>; Wed, 21 Oct 2020 07:24:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kd24n8fvExqkMZoTQn7ZLbjiXdKLPg+Z9WhqJAOkLno=;
        b=UoprI5DJXJuVTtoJiHECq+uRkuY8ZImJb98sl1GBQw6td6phLbOG4nDh2QpgXNg5Yn
         VEJx+yhJLT14qo1SLw96r5adrV3edIjLZbDOVs19RrHWNdM6539OHdjp/JJ5eeuAB6oK
         KhBj4Ua1mpT50hb4O62u2Wkv/69RuSV2iDBPpY6gG8Ye0HT8aMRkxTtNudXL4118pDEJ
         C/ti8JMF5Q9EDVXwa378Dm+9bcZEiHPMKxfp0okhfPWD7vvfsYlTkEERby6DEP22ZDbB
         /Woo0Jr/EwXtIjr1iYzAMzIMOWAUWsMx/jbktxxIzisSxvz0TzAFSF/NnHaNyD2Ydgxc
         GJ3A==
X-Gm-Message-State: AOAM532INOMGPkYh2ggjwNPfgrCBkHMwkLcuDuLFPa7OIIjak6IlK25v
	F98e+TC6+q4h0gbjJSCHFVf52vG9FQ4iDr+Lapc=
X-Google-Smtp-Source: ABdhPJzzUagLy2/wTR2reR/iEjOUzGDitwgsUDsCMI6OUJ3VjWJ4T7EinTswEywdjKJZfSeH/cpZeoxXijk2LTN0EIQ=
X-Received: by 2002:a63:a546:: with SMTP id r6mr3613847pgu.160.1603290258598;
 Wed, 21 Oct 2020 07:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201012162736.65241-1-nmeeramohide@micron.com>
 <20201015080254.GA31136@infradead.org> <SN6PR08MB420880574E0705BBC80EC1A3B3030@SN6PR08MB4208.namprd08.prod.outlook.com>
 <CAPcyv4j7a0gq++rL--2W33fL4+S0asYjYkvfBfs+hY+3J=c_GA@mail.gmail.com>
In-Reply-To: <CAPcyv4j7a0gq++rL--2W33fL4+S0asYjYkvfBfs+hY+3J=c_GA@mail.gmail.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 21 Oct 2020 10:24:05 -0400
Message-ID: <CAMM=eLf+2VYHB6vZVjn_=GA5uXJWKL-d6PuCpHEBPz=_Loe58A@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH v2 00/22] add Object Storage Media Pool (mpool)
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: KOFHEI5LZSGCIZM6P2VICM2V7SG4WFWV
X-Message-ID-Hash: KOFHEI5LZSGCIZM6P2VICM2V7SG4WFWV
X-MailFrom: snitzer@gmail.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: "Nabeel Meeramohideen Mohamed (nmeeramohide)" <nmeeramohide@micron.com>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Steve Moyer (smoyer)" <smoyer@micron.com>, "Greg Becker (gbecker)" <gbecker@micron.com>, "Pierre Labat (plabat)" <plabat@micron.com>, "John Groves (jgroves)" <jgroves@micron.com>, device-mapper development <dm-devel@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/KOFHEI5LZSGCIZM6P2VICM2V7SG4WFWV/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hey Dan,

On Fri, Oct 16, 2020 at 6:38 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Fri, Oct 16, 2020 at 2:59 PM Nabeel Meeramohideen Mohamed
> (nmeeramohide) <nmeeramohide@micron.com> wrote:
>
> > (5) Representing an mpool as a /dev/mpool/<mpool-name> device file provides a
> > convenient mechanism for controlling access to and managing the multiple storage
> > volumes, and in the future pmem devices, that may comprise an logical mpool.
>
> Christoph and I have talked about replacing the pmem driver's
> dependence on device-mapper for pooling.

Was this discussion done publicly or private?  If public please share
a pointer to the thread.

I'd really like to understand the problem statement that is leading to
pursuing a pmem native alternative to existing DM.

Thanks,
Mike
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
