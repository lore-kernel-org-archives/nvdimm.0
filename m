Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792777048;
	b=kyby6pQZGKTH1n2Cx9Ghu5PdTkOvKCdKFxPk93sS33TlOmRNnCfj8IgnNEykScPUFg7d
	 ifEBqdNMst2oBUg4m5MRMz7J1TrsI38/hWnWyhV554+SCiYHRTaQq4LkbG6n34OjOsjrQ
	 9/RGO6i6bIPzh98Dff+ZXSHR72YP8s2/ekw4Deir9/i0trqNp60g/4wOEsEfIRj3mFsh5
	 0dLmiYH5RqUkc9Z/6wBSxjF5Zro2/d87sBH61ssJ2qPg2b8zDz3VoY0CyNKuKBiSYUR5w
	 CicezkRc7NeQzNLN5roOIU/00cVz9AKR1ykRjs00z0DT+I3weCBoTN2fOhoT7xTkn9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777048;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id:X-Mailer;
	bh=hraUT/Vp7Vp58veMWgeGRnI/Rj38Sr/3KoYA2Iypfx0=;
	b=xUa0D9c/VmYHfbylbXqxwkkvQ0j2veBzRRARyfzUmwtTDuybxOOKsqbLXujrBQKEzMN5
	 qyK9JK3V/GgF8RSOKcoilwXtrtW6EGwR3VkXxUkcyudzgVlwt/KY3CvS+PfVtEbjxMct+
	 pNjqZdUB3bFQAEFkaTbr2+X7mVjI1LINBGpUodSoYT8HSrY9fStzRSf2sFuZwtvy4M4Zr
	 tqDPzb8hoZITYxZHg4Rwj7wZ/PQvt6BoNNzJNj6w58ZXq4YHiQsNsBBv7GwxqVkivmDjC
	 1HiQWQ96SR/K7ov1VLUrAGBRkIQ+tGQNBSrknlAJrsSGf8kf4mIXYmjQGv7y2oS9Ofw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DSS6qlZi;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B52C606A31D
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 17:37:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B52C606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DSS6qlZi
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5363c8de563so10845911cf.0
        for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792777047; x=1793381847; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hraUT/Vp7Vp58veMWgeGRnI/Rj38Sr/3KoYA2Iypfx0=;
        b=DSS6qlZiF4rHcbO2W9+J+Wn7OGU2+UZd6WF6/Y3r3ZiKDAZvIeD7eKV+zzmN9/ZLX+
         2YO2m/gQdpS1TcmmVJTdvUV8JF7RZ7LCcLJL4a3bHJtg1o2r8JS1veDD/Nw3OlzIuuYZ
         m6OM9cPH9PBVYlke3pSOIpbZeq7n2lCE9lqetK2XO6BqpuNziWUtVnrTNiM5H0/ApGp3
         xHMWtxypmXtwgbOFG2Z2HxkAHpk1TThDY0WMropjMXjk4GPnOYus11+xddLMZnGyPf2v
         Z2Sgi2dAk3LYwRLB9vIjR4bjALAN6B3Z9l3QmKfHex0YuEHPs9geFnX743toGAlHRXJd
         HFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777047; x=1793381847;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hraUT/Vp7Vp58veMWgeGRnI/Rj38Sr/3KoYA2Iypfx0=;
        b=Gpz/y7EWlZPpgTByEE/HikKaGEFFApoj+z2H/qeCzfvle5S7zGghtZTkrRACQ1ncrp
         vi+NeE88p2lUTEJWJM62emqhqkEK2mKME1g7Lu84WXbsrMqboY2Cvlp3t8xgGnX0oRLr
         ggD8cW4dkJPyv3taCaxE3czkWcG7WC6zX6JaG5lTHREZETWGlXBGsjkPNlQGOctg9I9o
         0rGMDwHnfzamzt4oh0+ieKpqFcA99IMvJ74GtANrMGqTO9yYscWBiXtE1fusV/+jf036
         eVrXKsUpGlW6ZoLmqFl6B/Z7jEufy6LycEp9s2JKLtDykrp5NAyTr85anxRH9aRFQun5
         Cn1Q==
X-Gm-Message-State: AFq9FYJMq2tTKQ9IhNdq5Jf6PMPnx4byBFKwiCFAyDACrIFmpN9oDXDt
	JUOpsLc74qV6wE8J8dT1QpfGvDkypfYUrtKkPjq3EN5MSvrpcbdErlFu/ZibgyMQFyI=
X-Gm-Gg: AYBFou1eq2Lx2d1yWFtujxCbx+Au1BEP0DOznybIT9ekCeyb74IMcpNcZl8hN0yH7vr
	PzPpRj0CCSgVrUwlpbpkbVchEJnXxvwunL1vPpKQl0Fiy7IEtrc5X3IZ9owEkyQRyJMa+4ci1RC
	iOlGStOPIjzekxshuOxtI22kiFDbY5u0ENJJ8xRhuPtP+p6jId17ory/ZsGg/Sc6B79wnqqSEd/
	arkBZWsR/pkBMWz2OUEsDOuw0Aw84jc8FC9oSfrwZ0FsICxxpTFMbg403C3pF9Ghi5ncZNfWCjn
	RxSpIBpPiO8Y0Oe+RgaiP8fThQRZ3sPVHXuBBgK+gT/ZFmSf/II6GSvAgxzfBIhgrKJs1rbpJfb
	+1mEmJ2FYTfnkpni8o/aXgc5b9co+2uba3BjlYhnjCddVUwxTmhnibWtvwSCuXnD9jIx+qgUDBw
	NTevM93CqtTNT1kTHPfwvATQBPoPyiPnjRLzWhFwg6g5msDMj9TdRs4H2PpCmlu6RD42CtJKYXg
	2EBAd4OsIGBDrElfZwbWzDNqmQ+CabC/hu5L/yaQbxXavj1Aex12n680SVl9V29P0yYsdXjvQ28
	wDVajx5WxUXRmQ9+3+n87v0rU0U=
X-Received: by 2002:a05:622a:e082:10b0:537:a19d:40e0 with SMTP id d75a77b69052e-537a19d4158mr12656411cf.35.1792777046504;
        Fri, 23 Oct 2026 10:37:26 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c96375sm201576d6.33.2026.10.23.10.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 10:37:26 -0700 (PDT)
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
Subject: Re: [ndctl PATCH 0/4] libdaxctl: Fix multi-range memory block
 handling
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, Gregory Price <gourry@gourry.net>, 
 linux-cxl@vger.kernel.org
In-Reply-To: <cover.1792695259.git.alison.schofield@intel.com>
References: <cover.1792695259.git.alison.schofield@intel.com>
Date: Fri, 23 Oct 2026 13:37:25 -0400
Message-Id: <179277704537.2498233.16797078329348590460.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-22 12:56 -0700, Alison Schofield wrote:
> [ Gregory: Hoping you can help w reviews here ]
> 

in my queue, thanks for looking at this.

-- 
~Gregory

