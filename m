Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0635C188
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525870; cv=pass; b=kl6i0azuuBLA2J0vl7ikB7Ha8+3nDvCr1vwlAPrdOA/uOXAvaU/FPoKvevAoMTHfKjtrbrBmuG96XhHfEpM50bNAgSOcd6jjxTfavaVYVjaqUtuUURFZl1AO9Fz1aPBslBx9ZXsA5GCEhjprXbOMnv892Gw/MqAAmGWwrIonS2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525870; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hZcN0HiEqEr+Ky0csnf2Gfn9goMJqADCwPfIW58zTjcYRioph9eJ2kmQ2+KF+DsyKchM7EUu3ETqXcko4+A83Ft6LdnRQ+jSv9quLiSznM/dQ2aSfBzPEYGa7mfV1m0Jn/pMzLiFAxBUDL6RdViQ1ejGlDoo3soENIQoUoPgvDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VB0ZGYEj; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VB0ZGYEj"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-655af782859so11442461a12.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525867; cv=none;
        d=google.com; s=arc-20240605;
        b=AXaOoQfQtUxYPa+cGS5ZgV5G8B5gbkGM/yOUVESYTNiB7LkmVlPz3LGqy+VJ1v1JSp
         7YLpchb5xe38miuGpuDEnYW4wQZgzx1dBAWc7uxa06MA1KTT/s3SlJVOPOAeWCHDsw85
         pHQlzUKKpANcuBaWwMBc4WrN+A32ghV4NDCIm3Q1Q53iT0b5olmUOnPi41TPe3carHnc
         +abWFHjx3L2ICPPj2ZhdRf4maV1HN3wrtI1oYp/O+u14KVBmNti3iTJwwp2nomse1/dW
         l/YFqLTW5U4id/6cK4+0wr+4KBCSOffOXzruCEd5pPI6zmNKsFRveKSa4hSVzebS2bg5
         ZT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=sWxgkQKUXbdiy1kw9wWNnVS/pFwWI+kXbYS5+wgHkpc=;
        b=OpC9JlmXDvq+RYqcm/v8eEofXfVQBMqm7hKCed2mrRaWEBEiUerSioRuKq/WzP+diU
         mYAxaY+Rsqln0jS9BRayGRLNvlAd34WdBoCTQ5f6omAkvE36fJ6c/3Abzl/DHQxtUzhK
         3m91xCnui8pkYs+Pr/0C19xCWDEGYM9gR7exKvXISmGogoqebTD2DKFN0Yps2Yrb2ut9
         K0vaNQGDVV95JQVOZyRivYD1dKLRQC+HqiCOLWst9lIGfDEGQT+y3nziwKBV0O8m4JE6
         ExP6y511Asbpn5yf2IoV9+D6ElmHdx6z7diKHYwqSRneLyQ5ov7yOxwc5IWR+H15UUPQ
         jQEA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525867; x=1770130667; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=VB0ZGYEjZAONk8BFI9hr9MMH2wWKEVE3Ta3WpYQChqiZ6oS1U2PAWMaOob82Nu4Jjg
         oxedmF/MYN1Xy3UgwdBhizrntl9Z79CfuGcy7z1NGCwQsGseG3Gk5v6oe/dSx+2R9SZ/
         Fo6piTjeBx39U3xm62ZQqgUpnGQ///LYPLB5B43MAuF9uycP9nTzNzScipNE0ASzwwJz
         2jfRiR85L9kPAxHBTHsmk7s7GFA8msVxEg5lIO02TcNucuHcfkdxlQwlQMiMXy6WfbRr
         iv7WpzJij7hiRH+gX0Plcx3SxvUMEfnWfwz794PKbQZ/jDs31Be8bcrC5JJk+1tkVg+g
         ErVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525867; x=1770130667;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=BnQyq88XKylOWwhOKUF9pztjmkgOxXZ2VgqukiFHzIR5LsG0xFMmfT/NzqR6PJIv/O
         cy6TN6ZB4D0OU9lnsLPq/Frij0RNNmo4/5vzI+IfEf7p/xd0ESCIj8u2f3nEGLZ+3qWa
         msgqgApftqhmTpzoF/Nny6fpe+JgeCvWyHWB+e3zNsqfsTOFDAhEReXeKrg/VeYV2fbw
         o/hfgQXzwV/IjFPdsAazkQUoYnfmbaAdZYcHIKxUqj4jresTCQ2ntoGsYM/GnF2kmAzm
         h8JFl4b2iHlltWZN6DgCfCYtbT0+8K17cafjYQS4pqT3myzLri/XZ1CfNPB/C5BfIPVn
         n1BQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbhJcwmI6zkZoLV6v6v8gGOY5gYJVniNSifw+h7CButLJJFb8XIsawk+TsWTh43EJ4LrJJq7M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwY+jY5uSsJ8ygeuH6pzjqz7cHm8HxBP+oCq4/S7J/b8MUuY1Jc
	a+tMlFAw2xdjZ36JjDDn0D0V7QOTHjvCWvPi+pf/SdJB6i+JaFMPj31AGxm4OjivOaV3+ixYsqO
	XXuWw4Qu4D+6eWF6hZEK2BUuvil1BAw==
X-Gm-Gg: AZuq6aI/B5naNe+3PakWUZzlwAx/mVjxWr15KbMELkXnMYrZQiSgD14BJJhWTL1M4uk
	3sEzyywz+X+P7Zr7jUc6Xpu+N6hVavzDN//MEiVZy1vepxect4XfDM2wrFV8JONXBS9ZXbiZgZ+
	IBSckhe6efeAQ6nTp2ziXrDcs6sBYLGrxVxWHkZq1BHMo67LSlmYmA1YXxyUoS9j5P7CmiTXBvT
	M83FIOylNfBoV81kAgS1Ml3w5CvyFtSmiWd6L4xclG6IdSmsSN7ixHaps94qD3Bw4t6T0kyC4MV
	zxK0OcGgduM1hmJq3K4PVZecQvGggrt4ZFcAgqc9AyQDfBjzNcO3WrZNGfktT1t/aAsj
X-Received: by 2002:a05:6402:3481:b0:653:9849:df10 with SMTP id
 4fb4d7f45d1cf-658a60a2a1fmr1194748a12.26.1769525867163; Tue, 27 Jan 2026
 06:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-7-hch@lst.de>
In-Reply-To: <20260121064339.206019-7-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:27:10 +0530
X-Gm-Features: AZwV_Qj4X0rX0yo1V91-mqj5DZP7DcX3ShOAwmDMBq59mWSXl3oyqbRMM9BDq0A
Message-ID: <CACzX3AuBQNjOtnmRFFXsyggUWqRB8eJrhpLwjUFzsLzVcKrSog@mail.gmail.com>
Subject: Re: [PATCH 06/15] block: add fs_bio_integrity helpers
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
