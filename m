Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40614AA40D
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 12:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791377697; cv=pass; b=MYh8ajdccjM510Y1xjbtAgXx65LL/NktOYpsVZ+9t3n92OvgwPXptCaRjXB/ldDg7lYZPpw66OG4IHnMHfL8DC0ssOdl+6/KF0A6RtehdVf2hYLLSyXkPS00i3ItkMk2JZNozxsuMUFzddKnBp3iDiKKOq20WFQ8Hku4VG5UMvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791377697; c=relaxed/simple;
	bh=mZxD1Ygf+pj4Ki80fWTjetLEhLjuY+js/KB32uhXOlw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T9Y4Pk4FyjsO44qLEgpHSag4psEJvh1m3J9Y9tmJZo9St1eIDRifMRkdKYuXNUoLjcW/gqck5ZrzKynVoDG5voBow2CBz3LzVb/ySNQY0hAhRXvxM2Fu5CAJ1mkSEH44vT6xEQ0IWonwsvi9KRPpMDuAVlEWxTyZxKqLLlqUUUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=McygKWhP; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="McygKWhP"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53391022dc0so17740981cf.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 05:54:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791377687; cv=none;
        d=google.com; s=arc-20260327;
        b=K7JjayBYYXCeLs/RswEe03KQBbgA3qgIVP3wNaNTn+77rQrJnI3C+RTvGHQdmRpSiU
         ltBaXrALmqcC/Ue+5laSdDOBjx12aLGjyvK+LFzlbirYL7FgUeDRIPxIzR1iS5APoy6g
         srF4n+Bp5Wvxq07IRZyxzpmxZTM5x8fJKy+KTrjN8JIzRjp9+TfM7i3u+MqyGtKBEE3m
         lFGXOfXpRiORza6A01Dy+3AlfUIBuAuNzpavek2jY6lsC04fj19cj0UMBcddrqs16JWd
         D+KQNQwgcSTBipf85s+bn9CEKlG8/MahUuU7lSfIhQkyHuFVwZ9sRMQUjlz1uBnGTKAQ
         YWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PgzrrYK6etiYHLS8TerK5hAVSfusAUIu6hnQPEz0+jc=;
        fh=oki00e/Wo/X6RPTQICRuXTtu+Uk2vC6sRlSsOsSVu6w=;
        b=dpMCV+0EOGNcutzslamtsJ2tJ0Y3m0GHKP5CdDy+/hH7Cm/7ZVcTh/rvIUMcy8eIkK
         YJ/4zzc6aZgD4S6WQFCdDHry0NZt4Kj9KvAVWAcx7FkkweM3WrCfgtkBgvK1QerhlPYw
         /LJsLv7R+v9q/798m9OrqITTUShmiKqAKv/QJTSoiVDwEjB00z8OXopHykZpou8EvkUh
         WDteRppGWxj7UvOaP17KcT2Cve5ugpf6xnXUSxbVDjvgQyQLbLJFlr4P1N7TytVXBbnn
         EQM49pAMx6e9a3f4ePh2EQVNFbLWhUjpFM/iNYeAzaz1pQEYE7ALiI58t06AWFxFugjE
         6SYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1791377687; x=1791982487; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PgzrrYK6etiYHLS8TerK5hAVSfusAUIu6hnQPEz0+jc=;
        b=McygKWhPYkSV/z2dtIOYoUpXZJ4au33Z9gLfsRGEU4Iz9WPo/pGk9itPekjOVqLaHs
         TaLLTfoJOTQ8k2oUVIyHc+cdmj+AdZcbejhfjwtDCLFXsEYLlm4ZXTI3tGcjf/P8Q2bh
         X9cDZDbdMQxnvMRnyVIyLdAPmTHuBwKLZkavM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791377687; x=1791982487;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PgzrrYK6etiYHLS8TerK5hAVSfusAUIu6hnQPEz0+jc=;
        b=ubCZm9uroQyCilthGb8dBn88movLvbp9fPf8CXwKNSNpsu+llhPEIQvgNMTzb9mYnN
         gSSEXDB10w4kge00F2E6uIPBszBme+MR0p3yL3R4lbII3Ka+F/p8Lfvd+4Y03VosKGOh
         rseNscsLFNAnU+XlDnosFNFN6CR7mJVtaoooq6Mm0WyTf8CA7OHxtFM6zcWMvYQ8O9Mz
         EtfsqTZOFZHW11gj08ncoSri1ipv9bm61N/oeqAdh6ogoXQTQO/CG74IjRQfL7P/k9mA
         BEvhoGKG3mhvsIVlZhqDrMlaa6kmV2r+obR6K+tsUgVJ27ptvT5AWz6oo3ZeUP6BTgok
         jugA==
X-Forwarded-Encrypted: i=1; AKwUvBwLr3odRz5evTqi5jKXGV0umVFWD5KRLOpclUgLswS5mVq8DA1MlAUcDbq/a2bm8JKv0XyHyMk=@lists.linux.dev
X-Gm-Message-State: AFuF++npQz1cjtek6E71bare4JN+o/JquzTDDywprktA7iyBMWQXug2+
	t3IAwnmlqcLr7S6UFe2FJdVU/4sHZba7nVHtUMHgHbiNP4WB9ic1VXuel/1J1agwUKkoU0nlYjD
	ah6jeqYy4ucvQiCwodR6lzdF3M71Tn0/Qo6SJrSB8PQ==
X-Gm-Gg: AYBFou1FUhaA7AEZ0l9+xOFcRdE7Mk8CExZHKrqe664/vooY9OVLThs3JSzu0rjHk6y
	9vMeef9BS7OXLmHJcuoOKQRIBa61y58eByXpCZHIa7uj/YtLLwveNH1qZ6KLpPc0SEPNvcQDNnY
	GzaiZ/WbH6e5/WflsDfkaEHrodLp3yUXAr3/kxevvL/COOjHhoVXVXmwWBVoaUKKpbvihL1HTNK
	vk31lqd/OEZp3j3MjxRUSQQ3w5UvBbepX547N9JOEoxv6IWWCt1HECHfbR2fDjKfUtZGsvHFX5s
	IA/E7zm9aSh0G+Qbj6CjU2V+EcYMxrFjpj4XwlDn5GMpN4xhYgkPOOJLaEHAzej0q0OiejuI+uG
	4+28QOUvgq8tF
X-Received: by 2002:a05:622a:955:10b0:535:863a:7cd5 with SMTP id
 d75a77b69052e-535863a7d68mr329801cf.41.1791377687608; Wed, 07 Oct 2026
 05:54:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261006180115.1425232-1-mszeredi@redhat.com> <20261006180115.1425232-5-mszeredi@redhat.com>
 <CAOQ4uxjRAgNKEKOj3yrh0fp_uBdQ-G=5C55G6M8vyjWgp2zvoA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjRAgNKEKOj3yrh0fp_uBdQ-G=5C55G6M8vyjWgp2zvoA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 7 Oct 2026 14:54:35 +0200
X-Gm-Features: AclHuK-2JR3jF5vhr6-2N836D1tWhMAXJTWcwxFUH5uC3YviT4HdxQEL0a7ZY6w
Message-ID: <CAJfpegsK3ydDW4Hy+yKxxnHsx7nPSSuC1aqOnOPjkD=g33jY_A@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] fuse: support 64 bit, server allocated backing ID
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, fuse-devel@lists.linux.dev, 
	John Groves <john@groves.net>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Oct 2026 at 00:12, Amir Goldstein <amir73il@gmail.com> wrote:

> #define FUSE_PASSTROUGH_PARAMS(max_backing_stack_depth, flags) \
>              ((max_backing_stack_depth & 0xff) + 1) | ((flags & 0xff) << 8)

I don't think that beast belongs in a public header.   That alone is a
reason not to go this way.

> It also avoid the unneeded questions/documentation/awkwardness
> regarding FUSE_PASSTHROUGH_V2 with/out FUSE_PASSTHROUGH

"If FUSE_PASSTHROUGH_V2 is set, FUSE_PASSTHROUGH is ignored"

Thanks,
Miklos
