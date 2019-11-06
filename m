Return-Path: <SRS0=80tl=Y6=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECC7C5DF65
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 Nov 2019 19:25:35 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4F5D217F9
	for <linux-nvdimm@archiver.kernel.org>; Wed,  6 Nov 2019 19:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="BO+HywfH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4F5D217F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 1AD8F100DC3E9;
	Wed,  6 Nov 2019 11:28:07 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::343; helo=mail-ot1-x343.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id E8BF9100DC3E7
	for <linux-nvdimm@lists.01.org>; Wed,  6 Nov 2019 11:28:03 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id d5so9801812otp.4
        for <linux-nvdimm@lists.01.org>; Wed, 06 Nov 2019 11:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nY2Xig5AEI1jAKsWo0TNKO3WPvFlMq0lCzO4EcmumPQ=;
        b=BO+HywfHdwEPGrIk58NnEihxuI/IJUyJiifGwSM1Wwe8X/v+B1SPWNepiPayo8keI3
         amTf1KlJcK+RRXSFtpz+C6cDIcNJWkKkos06YfIrca6IIJguO9Gd7zOfLKEcaPxxqGvb
         CLNOf0FWHNbwcX7lgQdahtBFo1xuYNnG4nqbveL0TS5rgc9apbT/l0DPX34rJl2hoXc7
         T24Rwj/ndJhEzie3sfnl9eXZ/4WtA5w5wovOCuBSJ6chlcEr/I2XtF6hHnBprwOnLXqc
         1PahmrnQmzyBZRwsdwl9oBy+RFfI4KGnwzyok0l9YJIHTWx/L9xord6Z2o/+yrCH6jnE
         nQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nY2Xig5AEI1jAKsWo0TNKO3WPvFlMq0lCzO4EcmumPQ=;
        b=RCrdgn/9M8nDTRM5cV0MeOxyY9qkTDoW+XDALygVz3zQKbHyBFCwY5yCBohhTHxWyP
         1lgx5UDcz4ISNOlXgFmo5IZaepqDpliv/Qahx4AiGWCsmdZRhk7SFrGKE8QSGlCZLvwA
         qbbMlwrsgSH7gFGQ4o61OSNFeY2KCywn0tF8QCL9PjTAB3lhl06Crt04hmV0GSJKk6Ve
         fNpodrL+kdWjIlfGDIcksJ+edqeXGtRWhWDDJFMqqK6Ep8W65De7PnWGHweSAlQZbup3
         IdBFqLf1NbYNjfa9ZvQTKUQzwE86u2td1ncm9tPluXkcs/HOJ4HuCYUdS2LRNcBEkvhh
         aGQQ==
X-Gm-Message-State: APjAAAVsWUxQQYwLeuJUMFzLob9avWWytik8x65DpHk66gqTJTiWiEuU
	rp1kuVAfNKudQYNsX29DbnWwBw3ErQ5cHXyISoftnA==
X-Google-Smtp-Source: APXvYqy11MSfQBYZjXYxueehKoX3Rxi0kd1MWfydrBvSkxPKhxJL9hjfr8h0oPVvV+AwkSBNzWsHoZ7rov/gT36iJ+A=
X-Received: by 2002:a9d:2d89:: with SMTP id g9mr3034395otb.126.1573068330251;
 Wed, 06 Nov 2019 11:25:30 -0800 (PST)
MIME-Version: 1.0
References: <20191106185052.11889-1-vishal.l.verma@intel.com>
In-Reply-To: <20191106185052.11889-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Nov 2019 11:25:19 -0800
Message-ID: <CAPcyv4iGJs2n-ZM1MH4FmOOa0Ad3mxVupSoBMvOQwHhStUWqEQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl/README: Update kernel documentation URL
To: Vishal Verma <vishal.l.verma@intel.com>
Message-ID-Hash: ZCBAI4XKSIVXSYBI4MNWNZ3QOPBYCMM6
X-Message-ID-Hash: ZCBAI4XKSIVXSYBI4MNWNZ3QOPBYCMM6
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/ZCBAI4XKSIVXSYBI4MNWNZ3QOPBYCMM6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Nov 6, 2019 at 10:50 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Commit ae4a05027e2f ("docs: nvdimm: add it to the driver-api book") in
> the kernel changes the location of the NVDIMM documentation. Use
> this chance to update the documentation link in ndctl to the Sphinx
> rendered HTML documentation hosted on kernel.org.
>
> Link: https://github.com/pmem/ndctl/issues/120
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
