Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1C2354AF2
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525782; cv=pass; b=fm2rnOGldZQq5gJfJ5h/uT0Z4dATWMfASel7OS5negHcPGeCnYiNeJbZFhZNiTSCGNbiRjU0Z1sZvm0WnNWdyYLosxBsvRQv0DJZ8bPuGWU6sfNkL8N9YxQ825wqTw3VGHhNiQBexOS0qAkFK1NVLHpNMUQ4LvOuWK4mDsNENIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525782; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4Oc7DJnre30EreG7odyGVqx85wwBopUqhF+13OQzc5w6bqDszba53NW+Ey0z92Iv15q4QUQ42D7b0hM+5iKfEhVOgylvSusxGLCZKOssQQN6G7Sm7m9aIJH9gCVo3cbBkCZ+v26hUxSx+FfnT5rcrQSXd5U5bJSS7G0jJsROGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LRQnlEEM; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LRQnlEEM"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8838339fc6so1095804966b.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:56:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525779; cv=none;
        d=google.com; s=arc-20240605;
        b=BdOuv+HjKp5aN8wtDnr1hkBS91y0NMvhEXKmOhXvrxbh9jmhxGIPH3oWQqY04gplXL
         P9FRj0mJCmbzQDJHwlVRkKoPLQXFNlfDxHpR+zB5Opw9UQL2UUiuvoWI6F6gt3e1b3Ql
         Z1WZLujgOSx8pS9f7yZ/zgfau2d7rTCFLIgVSoWWZkwF2GGhLzRGP5vjDERrDUoqos/8
         WTVDE9nPNMR5Q+xzzM2VnMCJRiu2wDNmvMKmt1LPQZOFtLUVQsrbJ7xSHl6hUEaGJALf
         WWsgi8NuVn8Llb6O3ZdpTV159nNHeAC9uIBSYtrj0vuIDEGWsYrkFu834G9KwMxLqZXW
         Sruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=AjuDN3wFqY9DgprgZs592jxIdQWcMKrzvQXq3BjbvxE=;
        b=YN0iWUGqVP+YDvTCxPzkc40YrBDM9W4uxIkGm9zgamgQptoOEPPvl2H8KcQX/taB+y
         F9q5K1JjozDnns2jhCMdmb9iH0Q5A1EoaWo5yFofMjVk0yiX21kHL6EnmUZVU/2W8htk
         9L/3eT4nsE2OXusgFtOYRq4Ml4/uZ6pwYDyzbIFEt7IsubxjCODWWnEBfGcWml3Z3kSE
         zjMmw78WHArbcX4l0okjFnLs7viSMyPMLofEL0qdV8DwEaxWWqtTTWG/O9qUwWTYU5SG
         x48n6/DAllCbjXu4lsReuzbfbu8qfkzUU6F3gYdUFzRrWFMAu9A2P4hrrYFk+TejzZhY
         f2/Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525779; x=1770130579; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=LRQnlEEM+IUxDXBY7zJGT1eNFZexdAWvbfQK6xAjJ3NukylvSJeuEE7rA7Sr0Q9bL0
         VO6oKuLkmLnqetKnAP2ADISoR+Zr1pb7xhHaTxy+IPb9SFXx2oqgrl1TrlfUBFF8tC6H
         E/h7CVTiWNyhnsCk9lvmqyGotyG3/zPPPPJcrh0UqaPn871EsupP//45NWut4q9x9gtk
         o1tgeXN4UQvDGcV0YokqgsLCxHfAQ4445Xku9n3OyCSlDAVmwg4X6SLq3XIG0uXPFrIB
         UGEteRbECPWmBfQSNURG1B9qT4kaPsB6H1zo0Fl8lGZ724dXvMbLByMDZdzVrcqzyOQY
         +45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525779; x=1770130579;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=A8dC3cukidHzF+3WC/T4EumnrNbCTughExTgmIO8X5uNVPAoAT1EknZb9JYR8maoWV
         v5ESRsws+4T22DBpBujv12Rae/7N/7VNEEhnQVHdKtPi30vGXLXoofzTP3ZOS7bv58ol
         WQhCpXrMa72xXqauu9zLe8z87v4vj2fhBDAt57hvvP5xk8OZ0PqOrgNbWe5uZQlGYJYq
         LPebC/wuKLrI0Ocq+zPMqZUTyvRG3KbkSi9dMaP3573c/FcMGjw3Vg5YaMU6aXNSbRDv
         v6dJAm3j9hkLi8Zbw9lRLijrqGFuLqDYZSRDaCQ3dG8iSyO3Y3TdBvxGp7iCwFEhgu6p
         hvlg==
X-Forwarded-Encrypted: i=1; AJvYcCVmQpauFaer6Pprf/HBDkWXCR1hGNwc/zh/PpAvu18EdbssBXGUzEZMzc/yTbF3hBckRXXpM2g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFS8e4vc30fqFQ3vGx/ZzIpevwk+zW+ImPpmEOh9iAh8JQep8b
	qut/iO16QBGsK2ls7aDmrL14uaLmnn/IFDsbQzcQ2ZH6vKxlkV9O6goi+vCKL7FRWnOOa5wa6k1
	04xX0eGOMw9SvLOsk1+a4lj1/95LVWQ==
X-Gm-Gg: AZuq6aInPzC9lHGPCsahiPnXxF261leg3rr2MdHZJl09gqhoNoV6JKj7553LliFpReN
	QcuUoFUaxtgbwXZef955Ueghu1GMcIql0WjAJtvjmA/3+3om0j9TZK4MjjP1IE3xq4PzXS4QTlb
	N1Bg01L8f7gYkN/z/maT90FVgpDNxstQs8c9UJZ04rpjwXV9M0OpiPAYpnqJnhU40No/OmRtjcL
	gDmjuSFJGNJCf3mPL7mSGtOJyjkuJqYD8tjotlIeAn3YxgcY61LLIP2hMgZk11+3+kJE1YNHXAE
	EnI0Ejz3TrNQj89F1jF5kpMxq3itB8J/woFdYp3iQSv7UoJJ7rLz+1DZcwRh8AwMUzFa
X-Received: by 2002:a17:907:2d08:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b8daca2128fmr161899866b.18.1769525779240; Tue, 27 Jan 2026
 06:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-3-hch@lst.de>
In-Reply-To: <20260121064339.206019-3-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:39 +0530
X-Gm-Features: AZwV_QiAoKA4QtWy_y0NR6iP_vvxOusoftdbzNUmcHtGTAMptU2eKdF9ySt53aI
Message-ID: <CACzX3AtY6PBV58jXS=jwD-o6Dd=m_3HkB=jRp-3Xt4Ab_U+RSw@mail.gmail.com>
Subject: Re: [PATCH 02/15] block: factor out a bio_integrity_setup_default helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
