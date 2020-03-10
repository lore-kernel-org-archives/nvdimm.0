Return-Path: <SRS0=xhOP=43=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFA0CC18E5A
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 19:50:03 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 436972467D
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 19:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="OhbAghdN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 436972467D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=szeredi.hu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3B19410FC3632;
	Tue, 10 Mar 2020 12:50:54 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::d44; helo=mail-io1-xd44.google.com; envelope-from=miklos@szeredi.hu; receiver=<UNKNOWN> 
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3207410FC362D
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 12:50:52 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id n21so14043547ioo.10
        for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 12:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3QS0e8RcKFN7/huSeBCCDwuVM9JqD+PwQz/25LYZ7s=;
        b=OhbAghdNUJbciPVHuH7moOlqqCFrFRE9cU5y6G8bZaazds/cVCLgdwVJGN8cktdJeV
         PcCU4iK+sDFS7sQ0uFJKeBvYtAZY/fdaWTYPriu+UWlAjLMThNuq340tP6KkBerdfuKh
         y3T0QJitw2eIkqR+syI0QC6SM1+A3omTiS8nU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3QS0e8RcKFN7/huSeBCCDwuVM9JqD+PwQz/25LYZ7s=;
        b=F6pTaSKQFQ3cYLtF6c3VidObCNd/vOuslbmlsAAffPb1nPXkTtwdj7ZnYdxNSDKhB+
         UspjqRfHzQsm0uIXn2xdY32a/3caDt6KEHllTJs54epCEa07fflx9YmaRcUGZ58k9Ro+
         6ovg0TYz6Mc5vd4dZf6KQCzSVhknfTdhXtgwi5enrFBvoEPbs65x1tE+bJPyH47CPFoi
         HRMI+hWPcT0uH1urRnB2whO+lh5TzNcx3mfJA0QOXLBLHlccsRNyIVaaPiYNNd+nC2RG
         a8y96mwrgXwB96ghIB4VoG0ItBYHDxoXQHUqaRrJxHrpOQooSRoSsS1JXQSFXrbgwK2J
         tZzg==
X-Gm-Message-State: ANhLgQ0ieGwJhLliuamujiQfox92rBWdCBcWQ/TnKUATvjMQ1dgSO9r0
	wsnosZ8BpTjfxgMHTEap3658F11139Gj4tPawmcQMw==
X-Google-Smtp-Source: ADFU+vst15KzgX+tYyB+mxwdb3zdIiBvf9oRWln6x3JODjSTwfwW2FTFg8mFRjfOJtT7xvjklxE++Xz8fUEBp6Pgo14=
X-Received: by 2002:a02:a813:: with SMTP id f19mr19907887jaj.35.1583869800367;
 Tue, 10 Mar 2020 12:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200304165845.3081-1-vgoyal@redhat.com> <20200304165845.3081-13-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-13-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2020 20:49:49 +0100
Message-ID: <CAJfpeguY8gDYVp_q3-W6JNA24zCry+SfWmEW2zuHLQLhmyUB3Q@mail.gmail.com>
Subject: Re: [PATCH 12/20] fuse: Introduce setupmapping/removemapping commands
To: Vivek Goyal <vgoyal@redhat.com>
Message-ID-Hash: E27PWQFPDQ7MQQYXPV5CS5QLX7NDMOWC
X-Message-ID-Hash: E27PWQFPDQ7MQQYXPV5CS5QLX7NDMOWC
X-MailFrom: miklos@szeredi.hu
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Peng Tao <tao.peng@linux.alibaba.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/E27PWQFPDQ7MQQYXPV5CS5QLX7NDMOWC/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 4, 2020 at 5:59 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Introduce two new fuse commands to setup/remove memory mappings. This
> will be used to setup/tear down file mapping in dax window.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> ---
>  include/uapi/linux/fuse.h | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
>
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 5b85819e045f..62633555d547 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -894,4 +894,41 @@ struct fuse_copy_file_range_in {
>         uint64_t        flags;
>  };
>
> +#define FUSE_SETUPMAPPING_ENTRIES 8
> +#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
> +struct fuse_setupmapping_in {
> +       /* An already open handle */
> +       uint64_t        fh;
> +       /* Offset into the file to start the mapping */
> +       uint64_t        foffset;
> +       /* Length of mapping required */
> +       uint64_t        len;
> +       /* Flags, FUSE_SETUPMAPPING_FLAG_* */
> +       uint64_t        flags;
> +       /* Offset in Memory Window */
> +       uint64_t        moffset;
> +};
> +
> +struct fuse_setupmapping_out {
> +       /* Offsets into the cache of mappings */
> +       uint64_t        coffset[FUSE_SETUPMAPPING_ENTRIES];
> +        /* Lengths of each mapping */
> +        uint64_t       len[FUSE_SETUPMAPPING_ENTRIES];
> +};

fuse_setupmapping_out together with FUSE_SETUPMAPPING_ENTRIES seem to be unused.

Thanks,
Miklos
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
