Return-Path: <SRS0=P5fg=CY=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC4AC43461
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 19:49:31 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E89C12078D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 15 Sep 2020 19:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="SjddBFQ7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E89C12078D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 29217142738B8;
	Tue, 15 Sep 2020 12:49:30 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::62e; helo=mail-ej1-x62e.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 71CCC14263AF6
	for <linux-nvdimm@lists.01.org>; Tue, 15 Sep 2020 12:49:25 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r7so6742843ejs.11
        for <linux-nvdimm@lists.01.org>; Tue, 15 Sep 2020 12:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/yJXWaEzcVM2wKN3tcoj8ipQVLaJSMiiv4HXBSmDtOI=;
        b=SjddBFQ7rQopve3TmiCqZNR34CfXHNcfTLhm1WymMn5vO2oAPZ5NCqpqmqZtBGLQf6
         4Rn1zFdXpHljW4HjlUj0ODX2plf1bgsv8DIGTXWERCxup3e8WrqH+ZRkuSACVdG2C6UV
         GeGV7U9M/D9DCG5VmjC4je1+F+ZCbllRAJE8BloMPaIOk5QGE1k/A0HD5fHLjwrbFiKD
         +NaIe2L9gmub7UfmNRKJvi3Os3FM9329N4vWQlO4JsKc2ba2VT+a9EQQEiyBniGMB3/x
         qpfuOpG08mROh/8qaukYYfztE2ycMD3J3adgq9aNbwcFyLS08TM6qnzzGTByOW/yXwsc
         OFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/yJXWaEzcVM2wKN3tcoj8ipQVLaJSMiiv4HXBSmDtOI=;
        b=QAx4apVYiKmO34nGNA48EM92HP8whuccxgLUHF5xXQsG7hZjJHSNYvgfXywro+c2Vg
         obY4IVnu2F9u1BkcySmZLKg3vzcaBahL04CrrUDgHAzGkltVl7gvaBYnTpOajljIB7n3
         igjtGr6lpirAj+7tPCGOgqeUrUHEGh+PQO/7XC/dyJ3TOin04dliF4L3lAosGdTd3nvD
         lWi01OWqLY45ylhGV/EOZ25GnZM7lCcCs7WgP6WbEGHLFtu5lpz2orzoXMHtKKHCOoxu
         hACSsE4eK1n189WCbfWLaMCsQ2A51iuGaRLyr4pAKzO+/FB4nkJrEvIdpXZ9+uSBGFL0
         uuMw==
X-Gm-Message-State: AOAM533UmBzxlp8/eqEeENn9N3klo7ec5veDo/9JJyZm3pNxxOiB3pA1
	QlnSIbMIroIYvJgBNSmbYRhLdUIIWBKqsdWQkkTUbA==
X-Google-Smtp-Source: ABdhPJwFbGGjEQo2AKfJ5b6wRV7H33HAP3mYOop+4kPiaZQAHWgJ0ivkD02d+ZJ2XQLAWRJcgWDYknexd3kY/+r7QYY=
X-Received: by 2002:a17:906:d7ab:: with SMTP id pk11mr21653335ejb.472.1600199362573;
 Tue, 15 Sep 2020 12:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2009141131220.30651@file01.intranet.prod.int.rdu2.redhat.com>
 <211sy17ij47lox90ncna7kwk-k7cl0b-ubtml5jg8ocd-r7lb68jgkncbq5ng3g-koqyd471rzfh-t231u5-sxwvexwht98i-b7in5pxxck0j-3b40lqlmuelf13q0uk-ye4ohhsbgodw-xuloz9wpp7tf.1600139009031@email.android.com>
 <20200915080106.GG4863@quack2.suse.cz>
In-Reply-To: <20200915080106.GG4863@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Sep 2020 12:49:10 -0700
Message-ID: <CAPcyv4jHG7Lp0RrX+WmNHY5iSE5FjgrvYxd_d6TN5CKfc5LReQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E5=9B=9E=E5=A4=8D=EF=BC=9Aregression_caused_by_patch_6180bb446ab6?=
	=?UTF-8?Q?24b9ab8bf201ed251ca87f07b413=3F=3F_=28=22dax=3A_fix_detection_of_dax_s?=
	=?UTF-8?Q?upport_for_non=2Dpersistent_memory_block=3F=3F_devices=22=29?=
To: Jan Kara <jack@suse.cz>
Message-ID-Hash: 7DS5WRE6FTWNVWNUL2SAT5BI6SY4V57Q
X-Message-ID-Hash: 7DS5WRE6FTWNVWNUL2SAT5BI6SY4V57Q
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "colyli@suse.de" <colyli@suse.de>, Adrian Huang <ahuang12@lenovo.com>, Jan Kara <jack@suse.com>, Mike Snitzer <snitzer@redhat.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mikulas Patocka <mpatocka@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/7DS5WRE6FTWNVWNUL2SAT5BI6SY4V57Q/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 15, 2020 at 1:01 AM Jan Kara <jack@suse.cz> wrote:
>
> Hi!
>
> On Tue 15-09-20 11:03:29, colyli@suse.de wrote:
> > Could you please to take a look? I am offline in the next two weeks.
>
> I just had a look into this. IMHO the justification in 6180bb446a "dax: fix
> detection of dax support for non-persistent memory block devices" is just
> bogus and people got confused by the previous condition
>
> if (!dax_dev && !bdev_dax_supported(bdev, blocksize))
>
> which was bogus as well. bdev_dax_supported() always returns false for bdev
> that doesn't have dax_dev (naturally so). So in the original condition
> there was no point in calling bdev_dax_supported() if we know dax_dev is
> NULL.
>
> Then this was changed to:
>
> if (!dax_dev || !bdev_dax_supported(bdev, blocksize))
>
> which looks more sensible at the first sight. But only at the first sight -
> if you look at wider context, __generic_fsdax_supported() is the bulk of
> code that decides whether a device supports DAX so calling
> bdev_dax_supported() from it indeed doesn't look as such a great idea. So
> IMO the condition should be just:
>
> if (!dax_dev)
>
> I'll send a fix for this.

If you beat me to it, great, but you might be sleeping now. I agree
the original condition was bogus and looks to be a result of previous
non-thorough refactoring on my part. I think we can move that !dax_dev
into dax_supported(). I'll take a look.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
