Return-Path: <SRS0=K/Bp=Y4=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72CD7CA9EB5
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 Nov 2019 16:35:41 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4407D2089C
	for <linux-nvdimm@archiver.kernel.org>; Mon,  4 Nov 2019 16:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="kI2Vyi5s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4407D2089C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from new-ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 7C806100EA537;
	Mon,  4 Nov 2019 08:38:30 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::242; helo=mail-oi1-x242.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 123BD100EA535
	for <linux-nvdimm@lists.01.org>; Mon,  4 Nov 2019 08:38:28 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id b19so5385780oib.13
        for <linux-nvdimm@lists.01.org>; Mon, 04 Nov 2019 08:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AEkOOBsRyqz6S+ml7meVEVcMXzICLOSN+wm0t1Bm4/g=;
        b=kI2Vyi5s6IFARw+I50TcDstJXvjqfa/MCVxIYjCcznfi/i/mmDYqq0yKEcHXICMIdN
         7jVe5nqjk0XbfmBl034yhZxzYFkDW+dHwFtrIBIs9DPa1Gi3T6bVB1grUszKCvaoS4rR
         7ek2rXId1qmhi3N5y1J1sPl0pm6sJnjXU27HSalqtWvGtTATQESbc6ZoMlw0268QCSc2
         4yH1NMfpIpAImn+IFC3cwx+E2hf8stMxpiPdVGNJ5/VdKWAYb4dpElUrS4dOI+AqbkWy
         pvcKO6UcUULJPlx5LWQSYaO7pUKig97FapEIKnOvgOo1Qk2uVFKUUsN5UDm6tZN5K45A
         AsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AEkOOBsRyqz6S+ml7meVEVcMXzICLOSN+wm0t1Bm4/g=;
        b=FX/xX/+PAEKVN9UD0fThd4roiBngmH42Gqa4PhjE8JG/vABu7lZeQApPML3jTu2dZV
         S5H3xd4bghuV/4I61pRgVoqoDNY0LMQE7rh3IiTrFOTfSvhg6LqEYTkuIFbqBDcKEBBy
         xE9RkGcrym7GMZ11UaJLxo/Dt+9SIHcOfR4lmbGY5ASbOg8geGiTa9sW5iYhxKDlAZqP
         ZAJQs861gNqN6xh94G9dviTApIw4uqis+a1Jn1Io0ZPmzEwA26feOer8npq/Mx89r1mQ
         UhK8E8Y6Pyk5Bw6RAaRBkcTNUVi+NnrcZ4K4TWTAZ+967fWnrEy9jPfcuONVopTdKQNC
         K3aQ==
X-Gm-Message-State: APjAAAWJyHz6dyQtOd6AyfTB0OQAyIyYC+iqBJV+5aylTLf5wclhaPH5
	82A8v6YPhdA1vp8VsN6wwm045a53k7WsFEoQeWHnfw==
X-Google-Smtp-Source: APXvYqwz+DL+iji17o9kNsMk2bn2I5d3bVfwa3DX+Dt4f8m49sFS3U9N6ON3F4xyspLbEZUvWbvFYttdH/X9b16GIMU=
X-Received: by 2002:aca:ad52:: with SMTP id w79mr16089035oie.149.1572885337466;
 Mon, 04 Nov 2019 08:35:37 -0800 (PST)
MIME-Version: 1.0
References: <20191101202713.5111-1-vishal.l.verma@intel.com> <20191101202713.5111-2-vishal.l.verma@intel.com>
In-Reply-To: <20191101202713.5111-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 4 Nov 2019 08:35:22 -0800
Message-ID: <CAPcyv4jWXXUgjd-_hsP+sUjBRfwQZQQOSUHUqSrdEYzfz3oS-g@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl/namespace: introduce ndctl_namespace_is_configurable()
To: Vishal Verma <vishal.l.verma@intel.com>
Message-ID-Hash: YALJZZMB2TUKCIHQFYHVS42GKPSQNJDY
X-Message-ID-Hash: YALJZZMB2TUKCIHQFYHVS42GKPSQNJDY
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/YALJZZMB2TUKCIHQFYHVS42GKPSQNJDY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 1, 2019 at 1:27 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The motivation for this change is that we want to refrain from
> (re)configuring what appear to be partially configured namespaces.
> Namespaces may end up in a state that looks partially configured when
> the kernel isn't able to enable a namespace due to mismatched
> PAGE_SIZE expectations. In such cases, ndctl should not treat those
> as unconfigured 'seed' namespaces, and reuse them.
>
> Add a new ndctl_namespace_is_configurable API, whish tests whether a
> namespaces is active, and whether it is partially configured. If neither
> are true, then it can be used for (re)configuration. Additionally, deal
> with the corner case of ND_DEVICE_NAMESPACE_IO (legacy PMEM) namespaces
> by testing whether the size attribute is read-only (which indicates such
> a namespace). Legacy namespaces always appear as configured, since their
> size cannot be changed, but they are also always re-configurable.
>
> Use this API in namespace_reconfig() and namespace_create() to enable
> this partial configuration detection.

A couple comments.... I think it's probably sufficient to just check
for ND_DEVICE_NAMESPACE_IO as I don't anticipate we'll ever have more
than one namespace type with a read-only size attribute. Also, how
about s/ndctl_namespace_is_configurable/ndctl_namespace_is_configuration_idle/?
Because to me all namespaces are always "configurable", but some may
have active non-default properties set.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
