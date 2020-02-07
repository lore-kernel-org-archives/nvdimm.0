Return-Path: <SRS0=GwHd=33=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64091C35242
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Feb 2020 16:59:00 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3ADA2214AF
	for <linux-nvdimm@archiver.kernel.org>; Fri,  7 Feb 2020 16:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="koBQP5WF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3ADA2214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 6F25510FC3584;
	Fri,  7 Feb 2020 09:02:17 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::343; helo=mail-ot1-x343.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id D3F2310FC341E
	for <linux-nvdimm@lists.01.org>; Fri,  7 Feb 2020 09:02:15 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 66so2769499otd.9
        for <linux-nvdimm@lists.01.org>; Fri, 07 Feb 2020 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8bcluL/nyB0VjYEVoSs9KiwWiRD7Dbfw+/1BJdMrk04=;
        b=koBQP5WFRdSccDvp8kq2R42mnRkVSz3AyEe+njywG0w25vOKocmUHBP+hhLRJbJPdV
         0siW4MN0Ch+0FlKEr/DxZY99CjNRC7VHWffcP7dfudqLHPN9Q5Wu8iNYSlF1lU46puto
         OVuO38Dt/HpQ2iZ4EDkORmi3QCOdf7JJ44hG97VxluV4ZGqD43xbP5lSmYG4tGn/wJn5
         f4i0YoJsxhpEHzx1HI87Zqg/Tnjpm88GCg1KjwJrNfvQxIjj73oSpYB6a1eEwMMfwBvm
         ZDOY3DatxhU42dRREAiQTreFD1Fur5YS5E7AvCRiaruCk/fbmKQzxr5vSkrI3Kyr1Vok
         tlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8bcluL/nyB0VjYEVoSs9KiwWiRD7Dbfw+/1BJdMrk04=;
        b=YOHTJld1v7ICN7p+VhQvGT0Fi/px8BoQiBq+LeJSiRBu59W0uzFbtjudVng8eOWxi+
         0x6bAGSDEBjg3Nfdw3EbVgcNL/fW2QqHbYp8/aw2BnvHuxdEeY15ZBvHS7cF4oZHUJqE
         p8ru3+ttd8dxNFNRe1STmPDByVq/Eaj7xZi76uhoQCKwluOQAdtljtuPP8mxn1ud0lFF
         zuf2DYoEmG/8vQTzMifUyIgWR+CvPFlfiJK3puEbLcHbKzQ9erPEAn/sD/BVVdOvAJUk
         WgK82C+2YLwu7IZFfegz4yCT4pZS+/Bv4pUdNVQvmdfR7UP8dDKFIC/thRsOgq7IquWL
         ejDw==
X-Gm-Message-State: APjAAAU93cg8+41XsNs3r0J1+5dz7Lsngr891oESOkGNWCNRxSy4HlaN
	y1Ma4EpYnJQs0uMTHUbO66m+BvGr/FRG3GqKIBLnYw==
X-Google-Smtp-Source: APXvYqw/6C4HAwNxaZVrwpTLMDnDTG++NB0iw0IEYHejzh7To9hof2jrUWdeK9OYAkgfD9kJ++NgZCvHPVbY0ouBQlw=
X-Received: by 2002:a9d:6f11:: with SMTP id n17mr251422otq.126.1581094737435;
 Fri, 07 Feb 2020 08:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20200203200029.4592-1-vgoyal@redhat.com> <20200203200029.4592-2-vgoyal@redhat.com>
 <20200205183050.GA26711@infradead.org> <20200205200259.GE14544@redhat.com>
 <CAPcyv4iY=gw86UDLqpiCtathGXRUuxOMuU=unwxzA-cm=0x+Sg@mail.gmail.com> <20200206143443.GB12036@redhat.com>
In-Reply-To: <20200206143443.GB12036@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Feb 2020 08:58:45 -0800
Message-ID: <CAPcyv4j_SN3cyeVfkVQBEniGBZ+XgmCx3ezBJ_KwiUpawaq40g@mail.gmail.com>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: CDHZPPBGZ36XM6VUYHDYH45TMNC4MATM
X-Message-ID-Hash: CDHZPPBGZ36XM6VUYHDYH45TMNC4MATM
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/CDHZPPBGZ36XM6VUYHDYH45TMNC4MATM/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 6, 2020 at 6:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Feb 05, 2020 at 04:40:44PM -0800, Dan Williams wrote:
> > On Wed, Feb 5, 2020 at 12:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Feb 05, 2020 at 10:30:50AM -0800, Christoph Hellwig wrote:
> > > > > +   /*
> > > > > +    * There are no users as of now. Once users are there, fix dm code
> > > > > +    * to be able to split a long range across targets.
> > > > > +    */
> > > >
> > > > This comment confused me.  I think this wants to say something like:
> > > >
> > > >       /*
> > > >        * There are now callers that want to zero across a page boundary as of
> > > >        * now.  Once there are users this check can be removed after the
> > > >        * device mapper code has been updated to split ranges across targets.
> > > >        */
> > >
> > > Yes, that's what I wanted to say but I missed one line. Thanks. Will fix
> > > it.
> > >
> > > >
> > > > > +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > > > > +                               unsigned int offset, size_t len)
> > > > > +{
> > > > > +   int rc = 0;
> > > > > +   phys_addr_t phys_pos = pgoff * PAGE_SIZE + offset;
> > > >
> > > > Any reason not to pass a phys_addr_t in the calling convention for the
> > > > method and maybe also for dax_zero_page_range itself?
> > >
> > > I don't have any reason not to pass phys_addr_t. If that sounds better,
> > > will make changes.
> >
> > The problem is device-mapper. That wants to use offset to route
> > through the map to the leaf device. If it weren't for the firmware
> > communication requirement you could do:
> >
> > dax_direct_access(...)
> > generic_dax_zero_page_range(...)
> >
> > ...but as long as the firmware error clearing path is required I think
> > we need to do pass the pgoff through the interface and do the pgoff to
> > virt / phys translation inside the ops handler.
>
> Hi Dan,
>
> Drivers can easily convert offset into dax device (say phys_addr_t) to
> pgoff and offset into page, isn't it?

It's not a phys_addr_t it's a 64-bit device relative offset.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
