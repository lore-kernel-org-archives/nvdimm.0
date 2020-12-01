Return-Path: <SRS0=kHQN=FF=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_20,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09BD7C71155
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Dec 2020 20:42:49 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 68DCB206E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  1 Dec 2020 20:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="TqhVp2wu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68DCB206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id EC270100EC1FD;
	Tue,  1 Dec 2020 12:42:47 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::635; helo=mail-ej1-x635.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 435C4100EC1FB
	for <linux-nvdimm@lists.01.org>; Tue,  1 Dec 2020 12:42:45 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lt17so7119844ejb.3
        for <linux-nvdimm@lists.01.org>; Tue, 01 Dec 2020 12:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0RBtUKeaPvU/GzP+jMS3Dsfo2rIt9YBehMmbHfwGd7A=;
        b=TqhVp2wuukokz3jQZaxuijfGTg+Cyjvo8mdtdphab3ayx20SLvi+f40TsI25kmNJeL
         5M2h1btbRcDdel8DD9g99aMFTOgPjufRoT+EAKc/IvZnOuthenykWAdJLoYk0R/AMnzc
         K3phAD+e/oP8ciIYw9uLyiviA2Opl7uz1mGiZTCXW6KNWaaKWvJDMnRH412k7nAhGIvi
         LWMYa9mqdQDpXUMm7q1C4JZCnxUAu/9zDzN9f8eWCdw3l2y8vrFW2JrLMjGgkHvsEbY/
         yVTXH2NGH0EKQdqJ6YQ7eenVmrU7rvYcu2VsIyB2QYSgs9eiMcblah5Mn7uDjxkqsjnu
         NpUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0RBtUKeaPvU/GzP+jMS3Dsfo2rIt9YBehMmbHfwGd7A=;
        b=qFaq3VU4fhcLkqJFf1hvu5tLEgc2kqUAFvIK8OioCVo+wXLBzlTW8YSeKMbunjp6X2
         7D7arJ+EHfshuKqAS4rTd0q6vr8y9HiT0dpn0QxUFMIP6C+oTnb5yfTFDfzJxPH8sIIZ
         iIGs4T3vRvbvC8yBmD8hjXRy/lcJ1s5lVnPEqXJ1F0Sg8e6sugjM/i0j2TK07Zydz5VC
         iRO8UAVTDzahhOmcK5upwgQQ9/0hwaf1LUPGDvg31RzF76uLJ/ECMd+UOXAJgNuB83IC
         83xOrJ4BCnT9Xq/IVWcIkaq8FJVeB3892zDnLN71riUovOggPadoHO20Ic8MvTSYDSe4
         2SOg==
X-Gm-Message-State: AOAM5315E4hODBkU2NTkO9cQaxq3/G/OeO8Dh8kJjZgo9LNT/PCBy0nX
	4lbYhGUxyUQdGGYPK0x5lV6deq1EWr0iZqqy0YcEJQ==
X-Google-Smtp-Source: ABdhPJw6elyMIoCPQlMD7L22PrIxSIlxVRceE737acKSgpuGoNsk6wo48ZXOON51AoZrJvlkpaizVjpKm2+u57GQA3g=
X-Received: by 2002:a17:906:c51:: with SMTP id t17mr4830318ejf.523.1606855363156;
 Tue, 01 Dec 2020 12:42:43 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4isen63tJ7q02rvVuu_Rm6QPdT0Bu-P_HJ2zePMySFNNg@mail.gmail.com>
 <20201201022412.GG4327@casper.infradead.org>
In-Reply-To: <20201201022412.GG4327@casper.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Dec 2020 12:42:39 -0800
Message-ID: <CAPcyv4j7wtjOSg8vL5q0PPjWdaknY-PC7m9x-Q1R_YL5dhE+bQ@mail.gmail.com>
Subject: Re: mapcount corruption regression
To: Matthew Wilcox <willy@infradead.org>
Message-ID-Hash: RAKYDGXWBMWM2YO3U6VY5LXEIN7BUWVL
X-Message-ID-Hash: RAKYDGXWBMWM2YO3U6VY5LXEIN7BUWVL
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vlastimil Babka <vbabka@suse.cz>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/RAKYDGXWBMWM2YO3U6VY5LXEIN7BUWVL/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 30, 2020 at 6:24 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Nov 30, 2020 at 05:20:25PM -0800, Dan Williams wrote:
> > Kirill, Willy, compound page experts,
> >
> > I am seeking some debug ideas about the following splat:
> >
> > BUG: Bad page state in process lt-pmem-ns  pfn:121a12
> > page:0000000051ef73f7 refcount:0 mapcount:-1024
> > mapping:0000000000000000 index:0x0 pfn:0x121a12
>
> Mapcount of -1024 is the signature of:
>
> #define PG_guard        0x00000400

Oh, thanks for that. I overlooked how mapcount is overloaded. Although
in v5.10-rc4 that value is:

#define PG_table        0x00000400

>
> (the bits are inverted, so this turns into 0xfffffbff which is reported
> as -1024)
>
> I assume you have debug_pagealloc enabled?

Added it, but no extra spew. I'll dig a bit more on how PG_table is
not being cleared in this case.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
