Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3563235C188
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525888; cv=pass; b=HEVpFxcCAGdgeLuVqk6yWwrLxhJbZBL9Pv+dFIKcBKqrL5et4m4HtMHGukKIKdqIVmoY2MvFfdPks3zZExMh4e/sM+WyDQEKzHKYR/cTpPIz0oIpVCoUABwktfOv/vVvWmsnNJjhgmAHkYRdDfnroED71Xw4Fljv+n5rLsBESfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525888; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WjdRpv0m9QLI7xCkgkM1IWPcvomhMOdP6b3eazr1zQacFPSySpkT9eJ6r/98jK5KMPSuNrkvsYdJVNt3D8mIYpgWN2J1OuyrXWvsA56mo7cN5OstW+ccqB/5KlU77fySwqK5Kjauf/gJQC5rbqS3k1jM7sYf7fL98vZxXmAYSWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTsim6LT; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTsim6LT"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso9370397a12.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:58:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525885; cv=none;
        d=google.com; s=arc-20240605;
        b=jk4aZhWO6DYGlU/GpJUOhLGMVERrW8ALCDsAZRMv6OBH85sEdgpqjm4ID+uHN3sC6v
         KnnfWnJJbu4qn3jveApAy/OQYc22OrKPPzQQFfBEmiYxFF9MmYcy5jAkP+ndq+APaF/U
         Q+6n0SFXSYBBUd7KFmcYg9wOm+U/ca63GDSSn+f8xg8qlRtw/vrQeCixHpKTmYpEdUMq
         HfSQ+0enIiJs4gWcz0w1JY0iSVjmh62/NR3YhK7Q3qmjcgIijyRRwq1CXCiG/x4GHpX6
         cq7xwXYz1SinxlkLQ9km3thy94qkdvg0Fpykavg8jBb0qlAVAx/0leDohkRDuMXL/Loc
         zy1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=CmvGJNlNZ+VETQVaH1NgAT3aL7BBqrq8eJjPbgW0A3s=;
        b=OfoEfGW8SXr+sG11dNNLH4iYi0jdBrxJauwJ5dP45mrGKtqlxig67JdyKjUuHsZmcY
         40ShuUFHxFbQrtH2Q9FEsqHyz0Bd7WXln/P+0JLd9P6sIAKo5SwQ07QfWBo3WZX3uzME
         G+WCiH4ovZHlBqyYeRE6EkSKKwVr/5CoyY/SgunJMS0O5uaXkiBOEUFURq7aCZZKICbS
         1/lp+Hn+9fwtzZg31spiPzVNGhYE3tZJV06xKzLGzuwNH9CNoI2YSEGfs/ciWXdCExU0
         Ja4tN43xeJmyHBoAHcFT7dAu69dzvNTNEHv4hXEjUqGdfMJnOgcaCgapbDLTj8pHTkep
         vvdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525885; x=1770130685; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=dTsim6LTS+M846b0EfkY0QPZeuyNwGAchqvHmRBCmpecgXbT4Y5slBPMdYOZdCcw7R
         y3ezFxho7Y/TSgXDQgWnYlhZBOUai2wfIrrx4/Jd8803imOiCDtmPWNFU3MZeRiIRwoD
         pfr+x/Fz9HDdKzIjsxLhk416ms7KflmgveobVuP0FHsPKl431djZPpV0t4H2Osnbpbhy
         lJS0q6hWkFrH8W9nOfV3CSyiUNUkHAJmm7bxEsAhrCRy6yKTStA4ECn2rhXMEvSIbswj
         X2R13mkeThO4M11WF7vcjfADCk0BEw3iedAWX0RDPtmVHt7+qnxXEXYUhiJMX8Si7zW4
         eyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525885; x=1770130685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=HZYHE+SqhyzvuYJnqgUDx+S2eHCz9p/ofyhW+DcZxXIqXWI2zPyBYoodx+tlyNpryC
         J9Bnoqfh5FbSUolqM8K4b1NHpUOVCsU7tUAPQ/0kYaiR/84Z19/kTKbHPWyfYtu8+l+L
         xl3iottMJ4NjHSDY/pM69wCX/FAi8TFTBYJPVMsA6NebM8E6I3BKqHw3tyaSKrplJ1Jn
         QpkxrnwU6ZPYtuOjfnJEanKG68wiqqp79CqES9F+WAh52WWWEfioJHQ+NRwU6ok5cKHd
         dtgu6Hxjxt2SiDsIz4X0PGc31I89tn71nwlmbsW8LNCF78LFr/Wgszft408uT7FYOBAG
         xOzg==
X-Forwarded-Encrypted: i=1; AJvYcCXzBy3xf1kcgFslg5vhPLIwioYKaCaRgtia276VzUEK5iGn7gqvUfhHHEN4YQE7lWafFV8YGhY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZM3j+nfgyUweik6AHJonhgrTzC1c49IotPrxNCccLmuQ/LqDv
	EBGOX9/HFqgx0nJqlC8vuJsprCUxgp3EWblhiTXmN8jZNX+7boyWFQstAPBLdE0O6dyETx7yJBx
	+JCZ5Q+mumnAGxyYFlnasQK+iYtJULA==
X-Gm-Gg: AZuq6aKntS6MF8reGzbRT3bvwA5OaRneSuHAETv6ZNXefFDeRlJSlgbIWnY9DJWPCfV
	W2vbr5XIYAxH6vmcztxKLaK3mB+QTz1JBEUE1KK4X86Rzf8ijtaRgVsEWtq6fNBzeDDbHFRVb/z
	kpPtv14VGoVlEWAdaZCnZ6oOU8w/oFw3GfX44QrGxlGJdWPGs3BSs8zkqL5O7No6v6Aqyb+jS9o
	3cn3R8D98fvBTd9c4GB62su/pd8+04u/nA3Hm2EU7UBhooHllF2JYVEUr2+X3XODEhet9vekepy
	ajXAEHQbFPWqRu5JWDrLXkX+lYWZdHX2bQTyZqSqCewuxzByHUZ3shJo7Q==
X-Received: by 2002:a05:6402:3990:b0:658:1b1b:15a2 with SMTP id
 4fb4d7f45d1cf-658a6015a38mr1102233a12.7.1769525885403; Tue, 27 Jan 2026
 06:58:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-8-hch@lst.de>
In-Reply-To: <20260121064339.206019-8-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:27:27 +0530
X-Gm-Features: AZwV_QiLLibbUg0iWqpfZ42-4rmvFtl9Ak5eBKgkKHdzZSGOKr8Fr4xqlZcQZ0A
Message-ID: <CACzX3AuFkVucGMbP=YQTB9AH8J2iBzzhPW98JSizDNChzV2HuA@mail.gmail.com>
Subject: Re: [PATCH 07/15] block: pass a maxlen argument to bio_iov_iter_bounce
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
