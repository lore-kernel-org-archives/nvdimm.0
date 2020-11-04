Return-Path: <SRS0=OyRv=EK=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=BAYES_40,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B05C388F7
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Nov 2020 01:49:30 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FFEF223EA
	for <linux-nvdimm@archiver.kernel.org>; Wed,  4 Nov 2020 01:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="UsBEVsoy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FFEF223EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 9D57A1655402F;
	Tue,  3 Nov 2020 17:49:29 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2a00:1450:4864:20::641; helo=mail-ej1-x641.google.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DF96B16541970
	for <linux-nvdimm@lists.01.org>; Tue,  3 Nov 2020 17:49:26 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id gn41so10115962ejc.4
        for <linux-nvdimm@lists.01.org>; Tue, 03 Nov 2020 17:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SsI8FLX+ROhm74yYa0uy9F/wUHz1nE6pIirY7SrAk+g=;
        b=UsBEVsoy+VYtiEZx4RJDSz9XkqQwLH0X7jCpB4jcpWQ8WZbpgLBhKUGbj61G28fK7E
         /CyIPyGalHwIx0uEpRW5A6v+NWZYIKuiXYt0BE92K1LKEK7KDzU29SDUggtvq4gQkrUo
         3S5z27SLWfZ2Lc/jUnnzb/IZW0WmtkDnC6mO3wulWOtNo9I6jZGhmrFY1wbvnU48Rg1y
         AUbcjNbOk7XIMwPEflmfUdUQTlpsaUK5e1BVM7+4Rq90TiUu6vOqJBT/aqEtjn2BdGR0
         Xf4PpTmcDnfdEHDjuFGBbO0t1ATWG/EI5Gm+wpc4Bqg/lXq0FJDfiQ29dbgT0U5csOWn
         cGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SsI8FLX+ROhm74yYa0uy9F/wUHz1nE6pIirY7SrAk+g=;
        b=Jt7Imx1BpJpD3huMwAmq32UK22qgfoDRphtnSKb+xR4IgNUVM0HN2VsPeIDiTAiCw1
         NXMQGLv4ECH6QcYiB8C15mhJPaldik9mYy3Up8nLEhuHROrj+PIAFm5ZZJkLbh5WwxlZ
         ZqxRFSdE/mH1SjIBUnVG5BNtGKTjJL27OJk2vc/l0xxkFDxGX1XqAOGrbSJ8sLArXLte
         6rIu04pJ1HDPxBElmSkMs/Ej6jHTtjQ4cHjt6hyGv2PUSStxZoSl4iNKF50TkMzXmt63
         ALMi0KMw/8lf668TEluyz8lBGiH6GfmTQ3vRRJFPFMdMqPRORfs+rQeKUuqFfVB/Vj+v
         XJFQ==
X-Gm-Message-State: AOAM531lk3BlAWc+zw/3mTYTSzttlSxI6QjGPri3GJ/PebrZ5+KmdQKO
	aw4w2Js6Iyro8zNCzYa2OhBNbIs457QD8zhpTaszlA==
X-Google-Smtp-Source: ABdhPJxahyTItiGxDjQVa69wfe4tuWJs//oWzLxeI+KSFpKugY5JvISfevBEStN+neuRaWQ5yvLFSezqEgYaySv4Tv0=
X-Received: by 2002:a17:906:c20f:: with SMTP id d15mr22253299ejz.341.1604454564624;
 Tue, 03 Nov 2020 17:49:24 -0800 (PST)
MIME-Version: 1.0
References: <160402498564.4173389.2743697400148832021.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20201031091012.GA27844@infradead.org> <CAPcyv4gj9ibFuBY1yt79CdKRgYAftdveXT1Ow4QvyRxri4jBRA@mail.gmail.com>
 <20201103173816.8f80920621fe08012deacfcc@linux-foundation.org>
In-Reply-To: <20201103173816.8f80920621fe08012deacfcc@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Nov 2020 17:49:13 -0800
Message-ID: <CAPcyv4jD15=Xeer-dOKy3oYOLQBouN70s2vsaKYponh_c+8-yw@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: Fix phys_to_target_node() export
To: Andrew Morton <akpm@linux-foundation.org>
Message-ID-Hash: BILFU56YXXPD6XSJSVMXPE5CJFVEFTGY
X-Message-ID-Hash: BILFU56YXXPD6XSJSVMXPE5CJFVEFTGY
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel test robot <lkp@intel.com>, Joao Martins <joao.m.martins@oracle.com>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BILFU56YXXPD6XSJSVMXPE5CJFVEFTGY/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 3, 2020 at 5:38 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 2 Nov 2020 15:52:39 -0800 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > The attached patch is going through some kbuild-robot exposure to make
> > sure I did not break anything else.
>
> I'll duck this for now - please send it along formally if/when testing
> is successful.

Yeah, the robots are angry, some reworks needed.
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
