Return-Path: <SRS0=iqJD=EP=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B45C388F9
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 01:54:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26F12206ED
	for <linux-nvdimm@archiver.kernel.org>; Mon,  9 Nov 2020 01:54:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XPGt9iSf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26F12206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D75E7165124E4;
	Sun,  8 Nov 2020 17:54:29 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::32f; helo=mail-ot1-x32f.google.com; envelope-from=enbyamy@gmail.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id C5B7A165124E1
	for <linux-nvdimm@lists.01.org>; Sun,  8 Nov 2020 17:54:25 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id k3so7455654otp.12
        for <linux-nvdimm@lists.01.org>; Sun, 08 Nov 2020 17:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZuEbJd/rC1DWMKE3T/Ch6Xoh1cqdm6Mb9Oh+kDQM/38=;
        b=XPGt9iSfnLtzThbKpkfUu9on6i/kTxpXQzvCrOAPuXUVK8L4wiSUQCyPuIrFFrWfC0
         0tnXRL3f3zh6MB+ilA0+vUAathZIkEtL9DyUbHp82Ri6zELrg53TXORqlAG8N5WwzGPG
         MNQdwfdv8B4f+iLfSf7Q/DTWSC3/Qug6EirZWRke8eljiWVh4TbQiLAAghEttswIpHIc
         NnebFuoY9AHVkeER2RK/9tlL1+cKTwye3poChnNOH/TQVI9Rp8ea5hs0WQNLKEvCNeEE
         DTMFI8/ZTaODhE0KU69Kcq8Zgyou8Ll8p7++qAQZTI1nIRVGyoHejepZ7QLcsJVZQvi8
         V9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZuEbJd/rC1DWMKE3T/Ch6Xoh1cqdm6Mb9Oh+kDQM/38=;
        b=F/AyZwtiVXw7hnS1ADaiawlemW7aqohlk+r37VoJenPjxIdv3Em8irReA5z/OAZuB9
         7EvppdLZW1pdilJ6P+LgIyPAjL7uWZKGSPFGJv08CrX1ON2Y8pJY1i8zKcDWF4J9KkWI
         2IN+2iqep3vKcTn5Tr2Jpq9lZBUzsUNviBA1dCTGMa/IxcOZIKuq0sk8KHxGBTBJv2to
         1pwojpu1SyJBY1vcoxrRykp7kBhkEUHSBSHwtXC1kUu4s1CKB6/PGxpoZjkr14u0vrJs
         WK9Qpwiy30sYP7dxJyXkUn2qNrqZLYEIi81G3zsYRVHf6KfqHTw8Anlj29JzmvU7cVmj
         Y0Mw==
X-Gm-Message-State: AOAM533hQbYW0v93lWF5nD7uYX4fklj4MJfBAnXeRTZF6Mib/Zr9n8tX
	94u81NJZJ8sKHCCTx+zd5XmPQBd3H0hPPeY4Spg=
X-Google-Smtp-Source: ABdhPJwHfE+dlPM0iWt4PF2iejUc2DO6Beo90SBNvuX2L1LPbTXt+i/TQjSSaSIcIG6YHVd4NormZqKAaWtWGfUQdwQ=
X-Received: by 2002:a9d:1b2:: with SMTP id e47mr8146282ote.45.1604886864960;
 Sun, 08 Nov 2020 17:54:24 -0800 (PST)
MIME-Version: 1.0
References: <CAE1WUT6O6uP12YMU1NaU-4CR-AaxRUhhWHY=zUtNXpHUfxrF=A@mail.gmail.com>
 <20201109013322.GA9685@magnolia> <20201109015001.GX17076@casper.infradead.org>
In-Reply-To: <20201109015001.GX17076@casper.infradead.org>
From: Amy Parker <enbyamy@gmail.com>
Date: Sun, 8 Nov 2020 17:54:14 -0800
Message-ID: <CAE1WUT7LBAKYoZ=-UxEdt1OdoirwcKMU_A=6TAKPo7HxwnS+zw@mail.gmail.com>
Subject: Re: Best solution for shifting DAX_ZERO_PAGE to XA_ZERO_ENTRY
To: Matthew Wilcox <willy@infradead.org>
Message-ID-Hash: CZUBY2NQRBSD6TVKVPR2SVR5L6HAOSOT
X-Message-ID-Hash: CZUBY2NQRBSD6TVKVPR2SVR5L6HAOSOT
X-MailFrom: enbyamy@gmail.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CZUBY2NQRBSD6TVKVPR2SVR5L6HAOSOT/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Nov 8, 2020 at 5:50 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sun, Nov 08, 2020 at 05:33:22PM -0800, Darrick J. Wong wrote:
> > On Sun, Nov 08, 2020 at 05:15:55PM -0800, Amy Parker wrote:
> > > I've been writing a patch to migrate the defined DAX_ZERO_PAGE
> > > to XA_ZERO_ENTRY for representing holes in files.
> >
> > Why?  IIRC XA_ZERO_ENTRY ("no mapping in the address space") isn't the
> > same as DAX_ZERO_PAGE ("the zero page is mapped into the address space
> > because we took a read fault on a sparse file hole").
>
> There's no current user of XA_ZERO_ENTRY in i_pages, whether it be
> DAX or non-DAX.
>
> > > XA_ZERO_ENTRY
> > > is defined in include/linux/xarray.h, where it's defined using
> > > xa_mk_internal(257). This function returns a void pointer, which
> > > is incompatible with the bitwise arithmetic it is performed on with.
>
> We don't really perform bitwise arithmetic on it, outside of:
>
> static int dax_is_zero_entry(void *entry)
> {
>         return xa_to_value(entry) & DAX_ZERO_PAGE;
> }

We also have:

if (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE)) {
       unsigned long index = xas->xa_index;
       /* we are replacing a zero page with block mapping */
       if (dax_is_pmd_entry(entry))
              unmap_mapping_pages(mapping, index & ~PG_PMD_COLOUR,
                            PG_PMD_NR, false);
       else /* pte entry */
              unmap_mapping_pages(mapping, index, 1, false);
}

and:

*entry = dax_insert_entry(xas, mapping, vmf, *entry, pfn,
              DAX_PMD | DAX_ZERO_PAGE, false);

>
> > > Currently, DAX_ZERO_PAGE is defined as an unsigned long,
> > > so I considered typecasting it. Typecasting every time would be
> > > repetitive and inefficient. I thought about making a new definition
> > > for it which has the typecast, but this breaks the original point of
> > > using already defined terms.
> > >
> > > Should we go the route of adding a new definition, we might as
> > > well just change the definition of DAX_ZERO_PAGE. This would
> > > break the simplicity of the current DAX bit definitions:
> > >
> > > #define DAX_LOCKED      (1UL << 0)
> > > #define DAX_PMD               (1UL << 1)
> > > #define DAX_ZERO_PAGE  (1UL << 2)
> > > #define DAX_EMPTY      (1UL << 3)
>
> I was proposing deleting the entire bit and shifting DAX_EMPTY down.

That'd probably be a better idea - so what should we do about the type
issue? Not typecasting it causes it not to compile.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
