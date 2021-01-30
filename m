Return-Path: <SRS0=2mfB=HB=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFDBC433E0
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Jan 2021 23:52:06 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCDAF64E0A
	for <linux-nvdimm@archiver.kernel.org>; Sat, 30 Jan 2021 23:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCDAF64E0A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id A189B100EBBC3;
	Sat, 30 Jan 2021 15:52:05 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::435; helo=mail-pf1-x435.google.com; envelope-from=rientjes@google.com; receiver=<UNKNOWN> 
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id CB99B100EBBA0
	for <linux-nvdimm@lists.01.org>; Sat, 30 Jan 2021 15:52:03 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id q131so9036493pfq.10
        for <linux-nvdimm@lists.01.org>; Sat, 30 Jan 2021 15:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=Ui0BeJCwGOKq8ej5x7M1Q9u0lMO3l7TRN0DCBw5DBWc=;
        b=MzV7DeqSQEU06RPg78K/siciEFk1jfbTpumwWmLQl6H6Gtps4XMqo2d69/O5cLG2ib
         sWHVna8f+tRiTekQ27iMrabwakv/X6Gbl2kRVK/U/BGlRXp3T9i1yQQSuVnU6lr+dm/x
         8FEPu29yNnBux/VASHH7ScQ+Jl0IiYohkU6+RCuQUg1EgQPqAcab+9vyY4J5yCbNcTRR
         nr53UK6NJNWZfhq5VD+V3Le0HG/nMeKhW74bPHwhTL5zw+kABM4AX6dL+VwufuqFX1nq
         tUL0JTNvh8Ct349k+VfR9Xo8+biP3GeU+ESkvAHVcmQEBivIFsiEhTmpY/WaIHhwMGhe
         hhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=Ui0BeJCwGOKq8ej5x7M1Q9u0lMO3l7TRN0DCBw5DBWc=;
        b=WBIWiNaRJe5T1TUIsEB2nyKe+lVb++/XsUkkBinxDrsvzRvgXoO/aRwUYf0L0zfUZR
         nxcsztQE81fIishLBP938wYYd/XwCck0jKDgnh5fBmv4VZ5CmAqe+YWq3EDcG0YJWH2B
         dCwske38S/rvkA3uPJnq1yp6GDXQ+43hFZBgcwTa70WtFNf7sggg4aqls6cStR40nZ2h
         Jn2Hhl/Mqk4bZJ6YqX2aEsPo77zx7uQKjFMpoqoBbj+imsRinKjaRie6LeCsoEtxx3TG
         x0SfA3X446QOUCSaOaKss1ELnomEfmFr9aDa5P+hrw+W4z0Hy4AOp0yRa4IX0RjR8HuP
         pj3A==
X-Gm-Message-State: AOAM531UEW0q2Z6qnJl788Wt0fz8F+ycP+p8R69vjXxySYccuTz8sLb6
	sqfIIuCm18yvx/sBe21kdtbz5A==
X-Google-Smtp-Source: ABdhPJwhLUNT7kvzAUWFbzT9Lc1dFYnkmDtxMuvH7NNwX3Q8WOwnNGrRfaRhmDarU4sLoHVBNmVU6w==
X-Received: by 2002:a63:7947:: with SMTP id u68mr3474320pgc.451.1612050723241;
        Sat, 30 Jan 2021 15:52:03 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id e12sm13104562pga.13.2021.01.30.15.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:52:02 -0800 (PST)
Date: Sat, 30 Jan 2021 15:52:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Ben Widawsky <ben.widawsky@intel.com>
Subject: Re: [PATCH 05/14] cxl/mem: Register CXL memX devices
In-Reply-To: <20210130002438.1872527-6-ben.widawsky@intel.com>
Message-ID: <ecd93422-b272-2b76-1ec-cf6af744ae@google.com>
References: <20210130002438.1872527-1-ben.widawsky@intel.com> <20210130002438.1872527-6-ben.widawsky@intel.com>
MIME-Version: 1.0
Message-ID-Hash: 4O7DGNNANMY7MUZ47E5XYZIUB5T3ZDA4
X-Message-ID-Hash: 4O7DGNNANMY7MUZ47E5XYZIUB5T3ZDA4
X-MailFrom: rientjes@google.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-cxl@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>, Chris Browy <cbrowy@avery-design.com>, Christoph Hellwig <hch@infradead.org>, Jon Masters <jcm@jonmasters.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Rafael Wysocki <rafael.j.wysocki@intel.com>, Randy Dunlap <rdunlap@infradead.org>, daniel.lll@alibaba-inc.com, "John Groves (jgroves)" <jgroves@micron.com>, "Kelley, Sean V" <sean.v.kelley@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/4O7DGNNANMY7MUZ47E5XYZIUB5T3ZDA4/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 29 Jan 2021, Ben Widawsky wrote:

> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
> new file mode 100644
> index 000000000000..fe7b87eba988
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -0,0 +1,26 @@
> +What:		/sys/bus/cxl/devices/memX/firmware_version
> +Date:		December, 2020
> +KernelVersion:	v5.12
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) "FW Revision" string as reported by the Identify
> +		Memory Device Output Payload in the CXL-2.0
> +		specification.
> +
> +What:		/sys/bus/cxl/devices/memX/ram/size
> +Date:		December, 2020
> +KernelVersion:	v5.12
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) "Volatile Only Capacity" as reported by the
> +		Identify Memory Device Output Payload in the CXL-2.0
> +		specification.
> +
> +What:		/sys/bus/cxl/devices/memX/pmem/size
> +Date:		December, 2020
> +KernelVersion:	v5.12
> +Contact:	linux-cxl@vger.kernel.org
> +Description:
> +		(RO) "Persistent Only Capacity" as reported by the
> +		Identify Memory Device Output Payload in the CXL-2.0
> +		specification.

Aren't volatile and persistent capacities expressed in multiples of 256MB?
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
