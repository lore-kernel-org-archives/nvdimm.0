Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686642;
	b=FJ0L6DBQRSm+Nt/fqBWdmS1CxC3pJ/H+NK5hhx+FmsUo74F7Osy5N1MNz/zJDbyk1z8j
	 HOaa6e2yiFpA7OUrp0G58oetfcSB2fMNo8gZ5ROmo8GyUdYew8RgROL8OLOtxHW4KeIof
	 q1STE3AjgcqTXikXSsYCcFH9vdgY+GtwRS1pfad52CDApYJw8cwSFhxBvqm8CCo8kjXhl
	 F/WVDG3JJ0w3AwhE1b7eTZvWgqj+qMoPS9dgpJQvq1nMcim79e5EaCDzd53RrUN5nut/8
	 8Gu+E3E+YdfZ+T6y2+Ec5CU0e+VxHILxhbKX3KVHQrbLS1EHiF2gFTbcg7+um9eFVrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686642;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=B9wBdkvsPD0u1RN+rtbABzIGn1cuCiu8JDpq3+Srt2A=;
	b=4CZ7V25OtmJc1uAb9in6honGXbCIqPVxUWYybmX3S2UUUN6PyUBPAEawWv9DCceqYeCs
	 7zZBhiPdDOkLluHBNUAlEbWIlkynJRfYgmN0VZIxhgjpPLqLy6phrbRhVeFet4PkC8JPJ
	 EH8nm5ZYJrmdZ/b0L58TrttwMEWBlYn/woIwYvFRg7OART6pvYn5vtaYCrmLlNfdHBlRs
	 roNyiXeldzBb9QU7MFsReW4jWlwWnrLnO00hmxBX2EYUfU/nakNNejCHZM771mjNkJg6H
	 YlIhFJBPIYD9O59AkSEigTQqQGTq9b24lkcqOYpglTtMROcfUWsnobpR1apwT9P1f1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Ji6LDP+G;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93F9606A31D
	for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 16:30:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A93F9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Ji6LDP+G
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f1ca4132bso190880585a.0
        for <nvdimm@lists.linux.dev>; Thu, 22 Oct 2026 09:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792686640; x=1793291440; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B9wBdkvsPD0u1RN+rtbABzIGn1cuCiu8JDpq3+Srt2A=;
        b=Ji6LDP+GVGnd7PMQlhQTlSG9VptZH2M5YRarITO6vqmSbtCHacMTvRa9+9OuUWbQUn
         50CvxZXnU4Lthi84rooKMlsF2gq6EcYmB2egIaI+aPoLBtbFQKp97mRcU3CB2cd4d68G
         rUnJq+0nZZWEwbb6NwzJ2y9owu9bUZjOyt1IyM7f1qufwExWmfCl3uMOqkGIVh1vkxDQ
         gWf16Kzab+MZmqyawfARjK8iH/no8dMN9G6TDnevHFDGcbzfjTecqVLx00sYeFvbcs8L
         FBt35jiST3fyFjkzVlCwGwBiaXncT3ih67tGyrhTteMUh1jXvWoOBvfo75Cr0QAHEj0B
         BCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792686640; x=1793291440;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B9wBdkvsPD0u1RN+rtbABzIGn1cuCiu8JDpq3+Srt2A=;
        b=fisM2i6tsMXc5qrT8P2n0z9edXATy2LgWfUBim8wou3azQNk/+9jhfuxgvGaVEmbvF
         JnxWXI1CmOOJ30Gpf1nFDjWI8VyCSYLliMm7mRfCRxbwGZxHFEHT+C1lWrwx/9u5drrT
         Y1OBJqBLbYTqc/+N++QEG9wbg1Wdq2oc6OybGlrD+FYufyQukD5/YnFncPXcS40Tqxpk
         wkGUUtBgUbFxycemnska42qtoVWDS5AddmFOOvS65BT1ho94zriM3FZAOtofP/mhfVNG
         OGfhgoAGnSXRtxHS0+za1GrLhIiZGVbfjhq1dl2SIFpYLvuPwOQ1L8B7RPQMAyHb5TlX
         7p7w==
X-Forwarded-Encrypted: i=1; AKwUvByoI9SeLWRrzZQ9BKnwLGHsh7+VXiJiIFgyg78dgSLaV3/R6spVP285z7mlOQpfJVbcMZHhNJg=@lists.linux.dev
X-Gm-Message-State: AFq9FYI+ZqBcX/m+Gkkl3475Jbgl1tMh+e2KFgbKzd+qt+nY8z0UyINm
	oDPv2UxwIjqYyNSANViQHh+sziIUpsBiuAxfvyON/4qfw4R9Wq3pwl28r68RJCl4zgQ=
X-Gm-Gg: AYBFou0uoWHTf3UZsnBSdWHnk33Dd1AJ1F6e936LrjzqObfzx6VYXCD7+Jdp2xdnqkk
	SxFOlCh6cAZ5qe+g0Z+q2clD0sIxBHtQpMFOPAc+63Yvagr+Zdj/1R6tdUfZJyVujEjPomHaaxi
	+LOZPd8QRUTiSccO+oNZ6qvCLnT/9AICCv0wRlokqulDWbbV8HtV0KrYlNPWSmdhVDnF9oPIKAv
	L6c+9O7EIlnAvRIueEUwyG5QwmqSQj8RDjcGm+W65OhTMZDIE/3GhxxEGdmJkIPuB26AyXAEWtf
	QIR/uDEIMwhc91SWCGhHvPzYjBT/EsGgmbjLb7gIFUKKr90/SWqdpFSO5KlnbszzFCtf3aWaazf
	dDXIL9zsVjzd5oaurlje8pFbf+RMKiUwmhniaZLZ8HCS1eO8/hpNrg5LkDuq5QeSouQbsquzI+F
	FFdXgYRRBALPf4eFrM7bQLzmgOxj/Ql6/2QfR4jiJIbgqYnb24XYVlnk2iHg2DhaKjLF8iy4Dfx
	yOTrg9ye10ptCXwiWbNM/F1ZoY6B/KGNy17K/47ydaUGsaSFnQid/z2bJBbU5Gsbd8AXrlx9cuF
	53DdGoOFNtXoNs38QKNzigF9pEQ=
X-Received: by 2002:a05:620a:2796:b0:93c:9c0b:3898 with SMTP id af79cd13be357-93f57f58197mr938681785a.59.1792686637640;
        Thu, 22 Oct 2026 09:30:37 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e0952asm548887785a.34.2026.10.22.09.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 09:30:37 -0700 (PDT)
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
Subject: Re: [PATCH 0/6] daxctl: use dax kmem atomic whole-device hotplug
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, nvdimm@lists.linux.dev, 
 linux-cxl@vger.kernel.org
In-Reply-To: <atluEdaffcWYOf_0@aschofie-mobl2.lan>
References: <20261016214248.443247-1-gourry@gourry.net>
 <atluEdaffcWYOf_0@aschofie-mobl2.lan>
Date: Thu, 22 Oct 2026 12:30:36 -0400
Message-Id: <179268663642.4072493.16012427078662920029.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-21 18:59 -0700, Alison Schofield wrote:
> On Fri, Oct 16, 2026 at 05:42:42PM -0400, Gregory Price (Meta) wrote:
> Hi Greg,
> 
> Next version, please add the ndctl label, ie [ndctl PATCH v2 0/6]
> (https://github.com/pmem/ndctl?tab=contributing-ov-file)

yeah sorry, i realized immediately after I sent it.  Noted for the
future.  I did also open a PR on github.

> 
> I see this goes with the kernel functionality that arrived in kernel 7.3.
> That took me a bit to realized because the linked kernel series shows
> crickets at v7.
> 
> I'd like to get this into the pending ndctl release, so let's see if we
> can close on a few things.
> 
> I tested against 7.3, regression and new tests and all is good there.
> I tested against 7.2 because daxctl command functionality itself needs to
> be backward compatible, and it is!
> 

I spent a good amount of time testing that it is :]

> Some per patch feedback and tags follow.
> 

ack

-- 
~Gregory

