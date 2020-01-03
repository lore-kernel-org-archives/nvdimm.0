Return-Path: <SRS0=02oh=2Y=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A8AC2D0C2
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Jan 2020 19:30:51 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0AA82215A4
	for <linux-nvdimm@archiver.kernel.org>; Fri,  3 Jan 2020 19:30:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="QcqFB30M"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AA82215A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 53D9510097DF8;
	Fri,  3 Jan 2020 11:34:09 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::244; helo=mail-oi1-x244.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 7894A10097DF6
	for <linux-nvdimm@lists.01.org>; Fri,  3 Jan 2020 11:34:06 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id i1so14845949oie.8
        for <linux-nvdimm@lists.01.org>; Fri, 03 Jan 2020 11:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+A1yNa9EKEJAvf7mT00hIXluvZccqZJ7nsuzns/AIw8=;
        b=QcqFB30MvhWgAdAzPCflfRmMETbH1hoaJBG7MjYnvbJcTSSYFCqw7gCztL7VDsBjEQ
         bft3HLIHqI3AG32tRCL397/3D+LE5eZUjbGrWZoUGjgrKYA3BuQJ7UwTUoalWAZm+esn
         8VdrudiYMzMuJ2ZlhI0/GyrZnfkMedu++29oggEnKOE7bVGp9DPbnOW7whKKa8O3My1v
         HoCi+cbEXmbmUDIWSPp3CDf36DG9rMFaaQTalTxHrlD/PJvxiwpEn0B+nR3yasZOwDky
         JzxMuv+w316sqBBqiR96737ifpKGaWFGzriRnlgq4zDPQgbOkNVzn1ruNr2LzpuIl1yv
         O9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+A1yNa9EKEJAvf7mT00hIXluvZccqZJ7nsuzns/AIw8=;
        b=D0RBGgC39mQJdYdri9j0VuBA2mTrQPD/fHsNsKZkuoFBRh9djuZg6B3nLOBazZ+9qN
         ZSL4pgECYwDGe+eAzZRpXZm845UWtWTHDnKTJTd2EWhjHjvX7V416wnAbMgWYZHuTLfV
         Vt1p1HgHuiPs0QBd/Wiwymjr4t+C4iEddViUBHrj6+PeUH0HjjU+lA0DwJ84n/VHnr5S
         S2zNhWhyspHtyc2/xJN4SxLlwouXx4pKBtxa4L6klmp9jwN5KvSI7IThbwtzv4jrPSY2
         CnLYOsuF9OAuk3w3MEpZyfv9d39UxS3q0H15ikPreEr0F4yNtFB33hM0HybsVNzRhB1Z
         TTyg==
X-Gm-Message-State: APjAAAV1OGZ8nbyi+aosF+sXCBoqufih8wLNqkfm5891wdoZ5wwJm9SU
	l7Kgyc/YQgWHMoplfSYZKIdD7xj2L3Ek2bsGPE+e6g==
X-Google-Smtp-Source: APXvYqyU0RUmJHbu8sFP1etbSHj6m5ri0lKObr59npnVW1CLsV3/SdCgQXzjKK3OOe298BMpuBxbd4JwwIlerJ4Wg8c=
X-Received: by 2002:aca:3f54:: with SMTP id m81mr4434705oia.73.1578079845934;
 Fri, 03 Jan 2020 11:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20190821175720.25901-1-vgoyal@redhat.com> <20190821175720.25901-3-vgoyal@redhat.com>
 <20190826115316.GB21051@infradead.org> <20190826203326.GB13860@redhat.com>
 <20190826205829.GC13860@redhat.com> <20200103141235.GA13350@redhat.com>
 <CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
 <CAPcyv4jM8s8T5ifv0c2eyqaBu3f2bd_j+fQHmJttZAajZ-we=g@mail.gmail.com> <20200103183307.GB13350@redhat.com>
In-Reply-To: <20200103183307.GB13350@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Jan 2020 11:30:35 -0800
Message-ID: <CAPcyv4geobjz_FZpfow7CKYDHHPe=65=tYV65E0901OzPszpww@mail.gmail.com>
Subject: Re: [PATCH 02/19] dax: Pass dax_dev to dax_writeback_mapping_range()
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: OH2GC2GBAW5FH3T5BT3OX34RFR2PZB3Z
X-Message-ID-Hash: OH2GC2GBAW5FH3T5BT3OX34RFR2PZB3Z
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christoph Hellwig <hch@infradead.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/OH2GC2GBAW5FH3T5BT3OX34RFR2PZB3Z/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 3, 2020 at 10:33 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Jan 03, 2020 at 10:18:22AM -0800, Dan Williams wrote:
> > On Fri, Jan 3, 2020 at 10:12 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > On Fri, Jan 3, 2020 at 6:12 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > [..]
> > > > Hi Dan,
> > > >
> > > > Ping for this patch. I see christoph and Jan acked it. Can we take it. Not
> > > > sure how to get ack from ext4 developers.
> > >
> > > Jan counts for ext4, I just missed this. Now merged.
> >
> > Oh, this now collides with:
> >
> >    30fa529e3b2e xfs: add a xfs_inode_buftarg helper
> >
> > Care to rebase? I'll also circle back to your question about
> > partitions on patch1.
>
> Hi Dan,
>
> Here is the updated patch.
>
> Thanks
> Vivek
>
> Subject: dax: Pass dax_dev instead of bdev to dax_writeback_mapping_range()

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
