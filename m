Return-Path: <SRS0=mu3p=2G=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E4DC43603
	for <linux-nvdimm@archiver.kernel.org>; Mon, 16 Dec 2019 16:06:02 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3E81206EC
	for <linux-nvdimm@archiver.kernel.org>; Mon, 16 Dec 2019 16:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="QsIADyvz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3E81206EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id C16B210097F1E;
	Mon, 16 Dec 2019 08:09:24 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::744; helo=mail-qk1-x744.google.com; envelope-from=brho@google.com; receiver=<UNKNOWN> 
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 75FDC1011363E
	for <linux-nvdimm@lists.01.org>; Mon, 16 Dec 2019 08:08:53 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id u5so4894059qkf.8
        for <linux-nvdimm@lists.01.org>; Mon, 16 Dec 2019 08:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+lKQBDpzDPcg15QBEHobBzdq4ppx02T+T0NScAe4/rA=;
        b=QsIADyvzRl9qoNxQVFr7adBzvQjOsTJR7jI2oGaHKBK2GYda2oFKhnUM4xsOl/UMeZ
         bv3vJ75KMRCZfpDFk0zrSDBcVzpxUeN9Re6zIr5fB/AhTVSxcq5SWQyxUXf1VhA3JQ38
         OtXjHCD7meb2uorDQ4B8xW1i0pURq1ZiCyEKVoudzSWAC7/ETU95NvFX161h2xTesLtu
         4CKCXS25EHzRA2iiyARcykUTfWjbc8j7uq0YAG6OfWm3eSPsxturRhZ1hQmkFlcMsE+k
         THvZZRA5PRenWMpOZSycSBezhCZaOOfS/SpDxP7Y8oey3DrqEVkfsXSpow6ryeiYCngM
         HWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+lKQBDpzDPcg15QBEHobBzdq4ppx02T+T0NScAe4/rA=;
        b=RgdGn7WaIlMbh2X7N7Pqw9fYop8AhGAM/ZHv/6q+kefwbM8GewdwvYnpNPgbwvZCwR
         /HOvYPWair1qIEEoSYNoFXhhogQKglR8ZcdsG+GwuQq9f46v0tyj5xDkynUPwUi1OZ45
         PjUN1lPpLcJoriYlkCwjSnMEm1Qqxen8QokGYlyidC8guM1Vlvt7KuQJEu5SdcoDyoXw
         RnIugjYHvmSq8fvnAGBmO9/7U7qWK2L82rH4NY04PSmukE+zKQqHBPHVtTGhXPskGt1E
         f4HclR3opBhMchptreK/4hm6/4v7SJdWkO2Vymz9AQs9G6XrmQEcwUn0DqB5lTPVw/Al
         +dPg==
X-Gm-Message-State: APjAAAVHnPXGb6dDRAMRR3KzEeu43rBzVDHiDryuLQAUGK23J6qgIxCX
	9a9tguFSRiuMtLEnaOaY76HXpg==
X-Google-Smtp-Source: APXvYqwzTOp0qWhlavl8UpEOrZOd6WkqWpFywuJjzXs13a42ZVBjXmBZSsWQfNbKB9CjvluM06GlvQ==
X-Received: by 2002:a37:6d5:: with SMTP id 204mr25587692qkg.448.1576512328086;
        Mon, 16 Dec 2019 08:05:28 -0800 (PST)
Received: from ?IPv6:2620:0:1004:a:6e2b:60f7:b51b:3b04? ([2620:0:1004:a:6e2b:60f7:b51b:3b04])
        by smtp.gmail.com with ESMTPSA id r37sm6992733qtj.44.2019.12.16.08.05.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 08:05:27 -0800 (PST)
Subject: Re: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
To: Sean Christopherson <sean.j.christopherson@intel.com>,
 Liran Alon <liran.alon@oracle.com>
References: <20191212182238.46535-1-brho@google.com>
 <20191212182238.46535-3-brho@google.com>
 <06108004-1720-41EB-BCAB-BFA8FEBF4772@oracle.com>
 <ED482280-CB47-4AB6-9E7E-EEE7848E0F8B@oracle.com>
 <f8e948ff-6a2a-a6d6-9d8e-92b93003354a@google.com>
 <65FB6CC1-3AD2-4D6F-9481-500BD7037203@oracle.com>
 <20191213171950.GA31552@linux.intel.com>
From: Barret Rhoden <brho@google.com>
Message-ID: <e012696f-f13e-5af1-2b14-084607d69bfa@google.com>
Date: Mon, 16 Dec 2019 11:05:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191213171950.GA31552@linux.intel.com>
Content-Language: en-GB
Message-ID-Hash: EAOF7QPTZI5PHH2TZZZANUIDQF7WFLAT
X-Message-ID-Hash: EAOF7QPTZI5PHH2TZZZANUIDQF7WFLAT
X-MailFrom: brho@google.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@redhat.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jason.zeng@intel.com
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/EAOF7QPTZI5PHH2TZZZANUIDQF7WFLAT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit

On 12/13/19 12:19 PM, Sean Christopherson wrote:
> Teaching thp_adjust() how to handle 1GB wouldn't be a bad thing.  It's
> unlikely THP itself will support 1GB pages any time soon, but having the
> logic there wouldn't hurt anything.
> 

Cool.  This was my main concern - I didn't want to break THP.

I'll rework the series based on all of your comments.

Thanks,

Barret

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
