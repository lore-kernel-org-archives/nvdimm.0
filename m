Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687623;
	b=CpQAcY6iAG2+WFgblV2BwHxPNF2xXTzLamB57jhl2aARe99wczm0mZyTN2jiSMuRW7iz
	 wr9uDxjVQB2f9DRBZB7D5R55InBtKgTAcaCRs+2TfU25UcN0KL0HPStHwRiwSEZor3GrQ
	 PJ5TKw2k3U2RMLiPn/apWhIx35bGSKphg8BmoKWmO7ho9IbGD5PuHVQF84rJUQKN+1T3I
	 v7RkjtgIJnNVPek/7rLhZ4pwqo4TOkRRdlRf1hD7a+Os7laA+Aqm35oyxobjonJaVWkHe
	 XCx0bDwL95pBdKtGBsT/vKHU1p70yq6Ejj6V35SeKjEsJIxdQo859jdbpswBjwh52ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687623;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=ID7yPTkzSVBQ72KhpcA430seexsA3T46pQ/u8vjuDwg=;
	b=K78hclKFaIgVZSjWWr/Df+XQBaqVmEPoAQFky2Hi2mAGD8FT5hBrgWMbMRd/sxbst3c0
	 KtrZs8fHe7YTk1FHbeny/kQ4Nkw+AdSCT+UlyslI9za+l6pKYG2bcAdK4AbiTW86AfWlS
	 dI/SoyLkwip5tKm0nyA/ssGmX0IxeZN6htDN4X81t+VO4SOpQor1yqUfg15xQWmMuiElM
	 VcAuCBzEGSfq1/CVkzZI/c+SZwLcNvq2R8bPTv9tlw8e/XLN37+kjvT/ra6+/XEjqRl5Y
	 8N7/0D8Puyx0GjB6SLaKA//qvoleFywealOhWFfuXC/W6rl3eJ1QiTLks6Tio3nmkxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=EPExVmuy;
	arc=none smtp.remote-ip=209.85.219.49
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9E4606A31B
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 16:47:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D9E4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=EPExVmuy
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-91b8306b9f8so942726d6.3
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 09:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792687622; x=1793292422; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ID7yPTkzSVBQ72KhpcA430seexsA3T46pQ/u8vjuDwg=;
        b=EPExVmuy64Fs0tuclvRZ9WYBwHZQHLr5MlesgK1kSGk8886txNN1j2g8jCFpFmrReX
         5qxtcZyymOhRA7oXqWM0nq9H0flBixirYQ5KQtLXzOp0N1gvyJ4bPa8MHnzBz+0Xf/9B
         fl8cpGiNKHoQgoFVpWTnp8fyoEoXULUgENwrr6bjHZmvUNJY/nkjG6mvTuf6Qp9zOpVj
         thnmjIOFbb647H+EsMPk1jEWEGig6g5Zh3+FkDE3so/IUDWgFL2k5QMU5Wq2NECvk88g
         YJzQmEnjGvrowxV5ZlafL1ect8LzbmjFN0/gYSkJSV2Es+F1d+JsFLzRIlTqb0bDsfLj
         OVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792687622; x=1793292422;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ID7yPTkzSVBQ72KhpcA430seexsA3T46pQ/u8vjuDwg=;
        b=MsqoyDZIhzwgoIl+4cvO2fkdJhdN/d42+zwt5LLbozw4FOZlrpYHzbFTYVuOlLbcFL
         CMYnKc+WKpJT+gVsGffPPHZ+RZoek3Jm/YpT1wPE5buRXvEEYjyQuRKBS7+O1TtSuomE
         vujeFttP9idZPkO2v9LanEM+cpGp2hqQG7NV1atRQTz+oPTZSbM3geZhIs2cLPLBMQuK
         NCMdPAWz1fswnJYvTGi7xqJGPZHUcVrbKkxD1wPJfrN4m86PMRZCNJCNCa+6/HpJzs8M
         bUhLxmbrxwx2yYcN3CBr5v/PDNAXFrSc40xcL5ek/Ut1QX11xWxsHzYaeS3euuJJ+jxS
         eUnw==
X-Forwarded-Encrypted: i=1; AKwUvBxAUB9gzT0h/dHcb8TrV4wCR121VNKj5O3CiX8V8faMHrkL9P9DFnrilDZ1HcfLPp0FzS60mik=@lists.linux.dev
X-Gm-Message-State: AFq9FYJYl7NIo9oS4BUD4jFcuMuv/kIlrKA4HPCkqC9G10cno0LDNe+v
	y3Mj1GMkIqJAd3HNqX+zm2WkXhxJKiHwQpr2f/8s4+HCdFX7MvV+WKFAKKmJTm8oah4=
X-Gm-Gg: AYBFou3kEWCCjq88Xi0FXDeO6mpvWXM/V0eyGifEEca9H4Pg3YCtZh8p0CPNBhffAnT
	R2S+QusKh168j8h8ZPpBBpAjIxAas8noR1QaumXoeSXQIcez/HVBG8gidPubOaGKaY6iHxJ8xEx
	RbcPyQn3BRq02WH3/0Rdg8jo6gR62yKbdL6Kjxc1OtHRgJ42kYOTfon0pyzP5kd8lSnMgguXsEE
	PoCJcLPw1UHUYt9AnETePpPnmwlXggMjTbb9xdC0kO6fxTd+LOmFYNjXbxHkwWyqKrQYox1q2eV
	gGWgHbBQl4GCRLdqI5vXZSW68d2V8mekUs20x26nxoU1Y/QiaWUlmdfG5BZI+0YBQ6XSGCXdzDS
	Xr4JXkI9dzvgo6Gkryt9wUC6aRZfglenxY177HptqVvYBh7a209AlsbAyq7QkoJfR4tVxPrpgnQ
	79U2NH2as6dXsCOaJN9vEkjq/DWHHe/r/xuz/sAETMdMgpBwKl/e4bPNHkU6X9TbR6gDAHo3UyY
	jKEgVPVS0VX0o34dRmyOkkKynsOXd52i4wAOp+WOw0w2hynwbDbUZvMHy3MxoVUI0jUZAb50VU9
	O/ico4ZAj0sSguijAJKWt60weXA=
X-Received: by 2002:a05:6214:5c0a:b0:912:6380:fe33 with SMTP id 6a1803df08f44-91c12f03979mr98117236d6.40.1792687622201;
        Thu, 22 Oct 2026 09:47:02 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c3709b14bsm1484856d6.30.2026.10.22.09.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:47:01 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/6] Documentation: describe atomic whole-device
 hotplug in daxctl man pages
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atlzl3h4cslBaV6j@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <20261016214248.443247-6-gourry@gourry.net>
 <atlzl3h4cslBaV6j@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 12:47:01 -0400
Message-Id: <179268762113.4072493.10493501438623710837.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-21 19:23 -0700, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 05:42:47PM -0400, Gregory Price (Meta) wrote:
> > From: Gregory Price <gourry@gourry.net>
> > 
> > Document that online-memory and offline-memory use daxX.Y/state where
> > available, that offlining always removes the memory blocks and how
> > that affects reconfigure-device, and the 'hotplug_state' attribute of
> > 'daxctl list'.
> 
> Hi Greg,
> 
> Can you add hotplug_state to sample outputs in daxctl-list.txt and
> cxl-list.txt?
>

ack

-- 
~Gregory

