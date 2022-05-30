Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12807A
	for <nvdimm@lists.linux.dev>; Mon, 30 May 2022 18:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1653935956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oREYfii8268D+SJ71twg9YvDIowl5zBevuAhXKYzK4M=;
	b=RKyMBietotrnfdHuCl0sCyhhKVgmWgDaPtvRU/Cm1B0IEDtCZEsY1+Em5ueXRRbxORuHEO
	/pTgvTHXHrT2lOyZdzQ/+w/008MtmSJrUfA1/vYdodCWvvhNSWuwcErI5Il0yFLb9/i5fo
	WKea4JA0MaAbN3yuI6puSW04Ye9/V7I=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-mBHgO8l8MH6AvRVSerBawA-1; Mon, 30 May 2022 14:39:15 -0400
X-MC-Unique: mBHgO8l8MH6AvRVSerBawA-1
Received: by mail-qk1-f197.google.com with SMTP id g3-20020a05620a108300b006a329bc4da3so9086675qkk.3
        for <nvdimm@lists.linux.dev>; Mon, 30 May 2022 11:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oREYfii8268D+SJ71twg9YvDIowl5zBevuAhXKYzK4M=;
        b=XM0kSkKsAvv2bME0TR+X1RC8Gso2wC7BRydwXYv3cGgjEJsDSyPZrWtFOK/TDY7QSU
         tbdPCVLIlkZPV63yMyW2BA7St9URsu5zeUU0mdf7DgRzTfTISvLByf6T7L2qwpqYeFgO
         im3L0uuckICSIWMcVLlSgDS2GyhQjZ3/Eav1cVGIKq3QRmSh/IqZy4PzpJvbL8KlCp4+
         n6WNlQFqioDVN6uTAtgSfQxRNCtYkC8TEZH6bmrtrqHNwejAjt8ne/zuYKcukLa+Eok3
         MSONxNGoNx2mrOblZZjsJO8+iRVgh+JgVZJPdwxndngqdW/KwyIi0HbTH8jtsYOgUZvc
         h1ZQ==
X-Gm-Message-State: AOAM533JYFO6PnvReP1iF6iL+bvCdGY7l3ARGkRUBxDI/dwIcerpHVwt
	M/ZpCpTpxiGigctfE5gAmHvQwfT4ed8YxDnmKqxyvrhXxCze5TmzdPPYW5s9RfczttofQT/Ba4i
	l1Nab7fi/22LXFuw/
X-Received: by 2002:a05:620a:1a14:b0:69e:9090:a7ba with SMTP id bk20-20020a05620a1a1400b0069e9090a7bamr38266505qkb.582.1653935955377;
        Mon, 30 May 2022 11:39:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCToRradBLOq6t7wYOeb4G8/QmYmXQANMYcAUrzfr+44PNLUgltY7kruU/ecnwjtQHIwmoTw==
X-Received: by 2002:a05:620a:1a14:b0:69e:9090:a7ba with SMTP id bk20-20020a05620a1a1400b0069e9090a7bamr38266494qkb.582.1653935955102;
        Mon, 30 May 2022 11:39:15 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16-20020a376410000000b006a371ba1fa5sm8055751qkb.32.2022.05.30.11.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 11:39:14 -0700 (PDT)
Date: Tue, 31 May 2022 02:39:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: Potential regression on kernel 5.19-rc0: kernel BUG at
 mm/page_table_check.c:51!
Message-ID: <20220530183908.vi7u37a6irji4gnf@zlang-mailbox>
References: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=zlang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 30, 2022 at 04:06:16PM +0800, Zorro Lang wrote:
> Hi mm folks:
> 
> I reported a regression bug on latest upstream linux:
> https://bugzilla.kernel.org/show_bug.cgi?id=216047
> 
> It's about xfs/ext4 + DAX, panic at mm/page_table_check.c:51!
> 
>   static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
>   {
> ==>     BUG_ON(!page_ext);
>         return (void *)(page_ext) + page_table_check_ops.offset;
>   }
> 
> It's 100% reproducible for me, by running fstests generic/623:
>   https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/623
> on xfs or ext4 with DAX enabled.
> 
> It doesn't look like a xfs or ext4 issue, so send to linux-mm to get more
> reviewing. More details please refer to above bug link. I changed its Pruduct
> to mm, but the Assignee isn't changed by default.

It's not a regression *recently* at least, I still can reproduce this bug on
linux v5.16.

But I found it's related with someone kernel configuration (sorry I haven't
figured out which one config is). I've upload two kernel config files, one[1]
can build a kernel which reproduce this bug, the other[2] can't. Hope that
helps.

Thanks,
Zorro

[1]
https://bugzilla.kernel.org/attachment.cgi?id=301076

[2]
https://bugzilla.kernel.org/attachment.cgi?id=301077

> 
> Thanks,
> Zorro

