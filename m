Return-Path: <SRS0=5gL2=AB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A97CC433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 20 Jun 2020 20:17:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A175A233CE
	for <linux-nvdimm@archiver.kernel.org>; Sat, 20 Jun 2020 20:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Kh7dx19O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A175A233CE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 60F0010FCC6CB;
	Sat, 20 Jun 2020 13:17:11 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::142; helo=mail-lf1-x142.google.com; envelope-from=torvalds@linuxfoundation.org; receiver=<UNKNOWN> 
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 5AFFD10FCC6C6
	for <linux-nvdimm@lists.01.org>; Sat, 20 Jun 2020 13:17:08 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u25so7498396lfm.1
        for <linux-nvdimm@lists.01.org>; Sat, 20 Jun 2020 13:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DkO/cTikH1vCB4t/qMP7eJZkR4/mPqVASeuRmjb69mU=;
        b=Kh7dx19OmKwl7jADZ8zqbQ72gVJECSRzZuxCNb1HOfzHCYIcwXzQM3ZOnLJypzch1S
         RnBpRHTTxOmvzv0LGtXoW8/plid3ltSRe/SHFRwf6CoqguDTLALBUB/TwLd/Q992czri
         GHXjyh1IJ03YgfxQXcaVj3BK+o+fFLDwEUV9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DkO/cTikH1vCB4t/qMP7eJZkR4/mPqVASeuRmjb69mU=;
        b=kfHYcJyxFlxV/RYRbE6zU6Mf4WVI2u/6U3QPyvMzVQdqi7zPh+ksXcM6MpwOA7o5kz
         yj22WRiHxiA9IpmJLvxco4JlISdPbZK9rz4Wdf/Sm/a3n5UZbpzc5K5l8OOdu5FjjxOG
         a7ReQRp70aM2terp5yAjIxcUgJzqyInxQuAYKNPnrEVJ0wPVUY2QrRtZTvh4N4GZY7Do
         iV8MHTsWJNjAimPUlBcu7eY1zALJ7KgqWYt/Atdl5DW95kOVlhIc8CdmSLnDUCLBPl+g
         xOoTAOz/dZMkuLtvQCyRq1lK8BmQwcQXXXzKffMSNIj4X6E4kJQGmsH6sygGk0Vi6Eao
         ANpA==
X-Gm-Message-State: AOAM533Z1nw2qkhEa6DExSgyb0VqBhZpDMluWp7wm642dTIeYAY2d1e6
	qzvpD97toF7Z1qZJwhR3qohivcT7AeM=
X-Google-Smtp-Source: ABdhPJzVVcYTshOPlAItb0fUfczZZtG6O3qJi6ucuPWf/J3go13gLbj1mzFwk5NBylXoHc87CSdCRg==
X-Received: by 2002:a19:c187:: with SMTP id r129mr5328266lff.129.1592684224331;
        Sat, 20 Jun 2020 13:17:04 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id v11sm1832133ljc.137.2020.06.20.13.17.03
        for <linux-nvdimm@lists.01.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:17:03 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id d27so7461158lfq.5
        for <linux-nvdimm@lists.01.org>; Sat, 20 Jun 2020 13:17:03 -0700 (PDT)
X-Received: by 2002:a19:8a07:: with SMTP id m7mr5381500lfd.31.1592684222742;
 Sat, 20 Jun 2020 13:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4jA-_Wd4S6gM2jf_VhVsgsdR5rQTeAc3AEPr6SAvhq3eA@mail.gmail.com>
In-Reply-To: <CAPcyv4jA-_Wd4S6gM2jf_VhVsgsdR5rQTeAc3AEPr6SAvhq3eA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 20 Jun 2020 13:16:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whD8TDJyiGauFj4GQxvBoKPFQCbgBtDTj_6oAUWUYo-Ow@mail.gmail.com>
Message-ID: <CAHk-=whD8TDJyiGauFj4GQxvBoKPFQCbgBtDTj_6oAUWUYo-Ow@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm for v5.8-rc2
To: Dan Williams <dan.j.williams@intel.com>
Message-ID-Hash: M3BW2TIM2YELKYSAMHW4TCIJFX47OSRB
X-Message-ID-Hash: M3BW2TIM2YELKYSAMHW4TCIJFX47OSRB
X-MailFrom: torvalds@linuxfoundation.org
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/M3BW2TIM2YELKYSAMHW4TCIJFX47OSRB/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jun 19, 2020 at 3:07 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
>     These patches are tied to specific features that were committed to
>     customers in upcoming distros releases (RHEL and SLES) whose time-lines
>     are tied to 5.8 kernel release.

Ugh. I'd have much preferred to see this during the merge window, but
the code looks straightforward and harmless enough.

            Linus
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
