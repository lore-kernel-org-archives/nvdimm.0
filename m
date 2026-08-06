Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD942BEB8
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 23:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786058821; cv=none; b=o9MVGxCVpa8ZazKeiOtSIufVfq0a6i4KRTXghwvChlqgUZhAZ3gVZkkTz9HecQD5b2fyELGZCYA20+IkdJLIS8/EwkUWMdw2m1tZyFPQ3X1M312W8p8hnb2T+vQ3Cjn0zk3X1isMJSxkS/EsCkDISPp8/m0+HVZVSHg79hBEYZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786058821; c=relaxed/simple;
	bh=8ernjYW7bovLgY78GoVgutHqXvV1nj4wsCTAcwbRWr4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4TWDxx2SHu56c+R/Il2jCHXgaD5Nwm+Vopfo/WVc0brH8iKTlZXKCdxdaQlBKBZsoT7FfXWsbhcbfyg3p6iAmH0gzEOwQ7lKLY/jwwvzaz6+LglQgSM/uLIoOWiN9P386Ec5IAolarmSWR4KrJ2kvwVzRzQswNHzEQzEnGzRe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geOmtXi1; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geOmtXi1"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84862b0d5aeso3248659b3a.2
        for <nvdimm@lists.linux.dev>; Thu, 06 Aug 2026 16:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786058820; x=1786663620; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yMThCopPkAFmI168rEXeIJriFw8m5HwaXiuoWGQJQhA=;
        b=geOmtXi1IHbty0+WTZU/u+ZnqTp0EIjUWzq2yPlbBNHQMf8L5fd6p0in3fu4BFDi2y
         MmhaWFsiEG96MnrC2AUyAGF243Aqk396M3UhJo0nbi1aSHgQaam8VQynUxsgF49Oxbf9
         04Gxyqajiw1+ngnMDR4JlEqOsqeXU7yjpDaixy62legid765KWJ3rum8hexf63LTY89m
         K+AlNdbYORUONNt02Ty09IOqSaQn/xZ9AKyZyqsg3MEMjuZruHaepsbknEq8uUU3aKTz
         5wBYZFhlGJSzbaIaaMdMoYeFVw1fOXIueOGo2/wbIboWNIxbYwBNtnIUnACwp9xJpeLa
         58Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786058820; x=1786663620;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMThCopPkAFmI168rEXeIJriFw8m5HwaXiuoWGQJQhA=;
        b=TmDGZqO+mUhKTm5SVVpOwIZR5YxL392oHN7niQS9mphJWQX/wQNuBAvb9CNxkMlMIY
         KrmFHx2ElyyqDopzwlKy+8C1llO4mX65x9XSqLoKFHrB65j0vrpo6D7mH77r3N8bzbg/
         Zuh8k0Zb2HpfI0B/4uTOQlpsk2DFk6TI8gc+p+fNnNSfDc3VN1vuSiqrOLTdbqjkQCAS
         N0JS3VPsbgC1ngaAjklQVBFCtapQytgnc9fQAAw5HPRfKOezr3c+c9pUROyQTGnR8Xa1
         1noarSUOU5fMEEFWl7ADBrO2gOUgLsMwtv3wxkEOMSyaEO8TKOIuoHOkgttGWSFrDIpC
         rOoA==
X-Forwarded-Encrypted: i=1; AHgh+RrEx1j6Ab2q7bRV2plyiiwV10ThBX9tB4ciAtft3p6kn2fxlyVUmvPJeZ+bsAm5J8HfqplazqI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYynrKyEpsugHz4uYVo3YRKX4hq7tr5q3zoPMJms4C2AcJx5e+
	QjOISZFnq7NwqVnEjA7HfMRt37+VkGGRrvA+GUxoeWNdKl2+3c1mgMz2XXGCPc3W
X-Gm-Gg: AR+sD12u68Fk8A4QKFhgF5Kz37bsgPoj0b1I4HYnBHrDnRRTAfza26q83vRaONIP0/c
	HZVxr8ubyIWWcbatcguVKkC5/dSVv+8C0NvexQ9u4J6UHXN8Vy0c42DObPKauiaQbVKjBnvlcNp
	uAo/N40ujpOhjStTkwD11P+Ef1l5bbrIHBnTnDAQmoTiKPic058TXl8BOeDXh+P7i3hQWkWNd6F
	cARLLJCNTB5hlsKuwlxJQl9UekCcIhsMZE2J+l6iGgd6E+KwPMFIib6mjTMBXPQpP3+aYzzZTcd
	ygzeeenVF7PH9N42vCWllMKWvnYEQzQ5uQvIaLge0bqekEbJVNfcbHCACqWQagTB+mYCuQ9kbbU
	bGBTPhZIMalvAGmdUL9KRFlMa8if6rkSq4N3f0Fr8UV6U+oKIS1Be6cIY5EVFijxiISVyzc4bDg
	4R7XtpEm/ndP9tyCd6Ey12yBhxD4WWrfy8IplmMUiMm5YtD4dOGJRojQ79
X-Received: by 2002:a05:6300:4049:b0:3bf:a638:4376 with SMTP id adf61e73a8af0-3cb85ea369dmr22427218637.21.1786058819814;
        Thu, 06 Aug 2026 16:26:59 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbe8bb33f90sm25853a12.2.2026.08.06.16.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 16:26:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Fri, 7 Aug 2026 08:27:27 +0900
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, sashiko-reviews@lists.linux.dev,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Message-ID: <anUYX0t32y37vfyR@cxlqual>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-7-anisa.su@samsung.com>
 <20260731090444.558491F000E9@smtp.kernel.org>
 <am28sIX7a6Z7QaXr@AnisaLaptop.localdomain>
 <anExYCOu1n0RnYvh@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anExYCOu1n0RnYvh@aschofie-mobl2.lan>

On Mon, Aug 03, 2026 at 05:25:04PM -0700, Alison Schofield wrote:
> On Sat, Aug 01, 2026 at 02:30:24AM -0700, Anisa Su wrote:
> > On Fri, Jul 31, 2026 at 09:04:43AM +0000, sashiko-bot@kernel.org wrote:
> > > Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> > > 
> > > New issues:
> > > - [High] Infinite IRQ Thread Loop / CPU Spin when handling DCD events
> > > 
> > False Positive. DCD events are ignored because DCD is turned off
> > (mds->dcd_supported = false).
> 
> Hi Anisa,
> 
> I have related review feedback -
> 
> 
> snip
> 
> > > 
> > > [Severity: High]
> > > Since mask now includes CXLDEV_EVENT_STATUS_DCD, status can have this bit set.
> > > However, cxl_mem_get_event_records() does not appear to handle the DCD event:
> > > 
> > The mask never includes CXLDEV_EVENT_STATUS_DCD.
> > Above in cxl_event_drain_mask:
> > 
> > if (cxl_dcd_supported(mds))
> >               mask |= CXLDEV_EVENT_STATUS_DCD;
> > 
> > mds->dcd_supported is set to false in Patch 1 so the DCD bit is never
> > set.
> > 
> > So status &= mask becomes zero and we break from the loop.
> > 
> > - Anisa
> 
> I understand that dcd_supported being forced false makes this unreachable
> today. My concern is that this patch adds the DCD bit to the drain path
> before there is code to consume and clear that log.
> 
> As soon as a later patch enables dcd_supported, the bit can enter status
> and the handler can loop without clearing it. Could the DCD bit be added
> to the mask in the same patch that adds the DCD drain handling?
> 
> -- Alison

Sure, that makes sense.

cxl_event_drain_mask() no longer sets the DCD bit, and it
loses the mds argument it needed for checking cxl_dcd_supported() to set it:

	/* Event logs the driver drains: standard logs when native_cxl */
	static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
	{
		if (host_bridge->native_cxl_error)
			return CXLDEV_EVENT_STATUS_ALL & ~CXLDEV_EVENT_STATUS_DCD;
		return 0;
	}

The bit is added back by "cxl/mem: Set up framework for handling DC
Events", the patch that adds the DCD case to
cxl_mem_get_event_records(), so the mask and its consumer arrive
together.

The commit message is updated to make it clear that the DCD event log
is not drained in this patch:

    The DCD event log is not drained here.  cxl_event_drain_mask() reports
    only the logs the driver can service, and the DCD bit is added by
    the patch introducing DCD event handling.  Until then a DCD interrupt
    wakes the event thread, which finds no log it owns and returns.

Thanks,
Anisa
