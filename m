Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4DD35C188
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525799; cv=pass; b=GD/UP901WXUaDduwUOwWgjO4jgWPQtwK+ldCRVOurU39Hb0IVIlo2HA4wygK9EQEhambiXX+M5CMzuo8Uqjb7NMkb/gtKZ4+7aiMwEEURrIvrPB3SEg02HCpOHvDlwq4h8RzpcgKkazhBePG+39hQI3M6l/qfimS7Yao76d2CvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525799; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gcfOaOhn2qYSbJZxZzIt4kaf7Ys2zV1ZovPPYGFbeD8ybu42W0c+3pSoGkvDd36tEZlmdus1egvXL3Dlhr6/1pVBNlOk64kGAmwVQDGhfWcqN8iahd1x/65IV45w6/qloiA4YH3QI/OPyvbiyHyWNmJhSH/AMcpRQlgKPvadcq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOKZcMeI; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOKZcMeI"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64bea6c5819so8615627a12.3
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:56:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525796; cv=none;
        d=google.com; s=arc-20240605;
        b=dAODoqktuv9Bal8BCleDkLQ+3NoJp/Mqj+dr9uX2nsaS4zJ96fsE1dyDKFI6k4Z/fB
         zWsIf8QPeWLY3R8p3uQRcxsJleHpMZIcUenmBdSuCSan7fmurRGYjzSqeflJQiyDSxRK
         IOxzb5NhPv89xqG/CcI9A/z1BPf+6QVm55snc2z54jeN6j+fseB5U/WqFpQoIF0L6yi0
         pTLV5tPPYoqFjKQEIljp6m97C4OYKGIgwXG1b8r7Rt4SEf6Sgs1YxqysWtvgXqOEqXt/
         DYKEC6pwJxfIZPwL3mDbzCNsUvhsWbb3SM+HBeXR71XHqnO4TFtg+Ler8QEcvlXT4JYC
         E9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=begsIklja71foNsFlq6Sjcq44gEb3SYcdEk3yo7Fg2E=;
        b=OvZFAXt3tOEB9UkafZe6H0LxRKJtEl8+W5LImif+htIh4pKGklm/nvdeYE2HEi4uwC
         zscmKMHbhmIPweCAazneWIRk7KH4xwyxetioliYhtVeNnVZaSoCd3/MxOVs8eik8ko8z
         hovFXwq8gNIkVDjtiPIMe5HE45Vt6wFAPzAh0xv1T6iSOMKL8S2K2siu+DsYQaswOpQz
         NAvvxyHiV85IkKaswBfdk1N6lmhtDFE4Bct9q1SmvT7wr2uRUYylG9wd2lmKj56ONP86
         +kx4MrMtPDqgcHaK+H7nLRnBX6ioKIk+itITElistvVOpQg83NGLd+064AqlxpwrC8M9
         619g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525796; x=1770130596; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=QOKZcMeIKVy+K5Osj7l8GJYKokL/T9YjP2uncDYZXh0RNqAzx5ff2cM+9kS2mGR0Rg
         VTp+WDbn7nW+GQlXW8JMnnLKOSSSAl+VAK06g2fzFZMKwz8d7F7HLZjThwc8O34eSzL9
         ugLNV0ZTChBvYgsiittCd4L7yMbY/leBMih/ZnbGWPt7AWPBDlAn5fle8qxyIHX0gFz2
         OE0Jw9Gf43oWlsBzeC5CposX0ZFIxJHfBR58rdi9JesnZd91GbdecqM7WRvtUFeF8VhY
         J/CsH+XO8inj3jPK5TosiFRNjkx6soVCUDJNehPv2miPLn42XxnMtigj3BHZnwp/Fyw0
         hZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525796; x=1770130596;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=D0IMvgei3UxEp/vx2lcOU3iXs+PRORNorZOEpIbeTcBHNz8jdQY9PyLbSAnglAZ3vJ
         UGpmeQsscOrIb+BHhIR0ikiWf3mBAiGBGxEARfk8kJJvKHQaa66BO4C+SPZGTUlX3tSV
         WMu99klIoPUCrERdYCOTOq7c/6YAku1gDEVcJOkertZemFgBEn1jiY2M7qCiV4jiKjqi
         HjYJ3jO7ur1kAQTd314vwk4Z9gWkrKAbQAZo9ngP8H2Q2+H4HERqyoRC8GLOi/hAI6J6
         nIgVjjefnnwXBJOwcCUop1oeuLlA3tzOrEVhZPIb55JQU9NFeNh0yXQL+RotkPS0C1MR
         x5pA==
X-Forwarded-Encrypted: i=1; AJvYcCVbrxNyUv0dXfc7qZMZIrhqE52Y00Av1ybNA6tE1fR6KckfKdvEYq1PnUMEWlvXFRis3uYhwEY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8RD+i27eI2zScHSeTwJd4TRr5VfDxTW7RutBksruIb3ksLC0b
	nPQfkHDk8EU8HgM5AtMcFrZGAD4bBNIP0dsG0d5gUWv1qStUTsqbLsp+UiftGoSeD7o5Ye3trZ+
	rBrXxOFNvoJO4cLdRqcQqnGpgT06jpA==
X-Gm-Gg: AZuq6aJH8pMW+lF4DMJVzNFDrlBTmWirmn77DCuZmdjnfODgThpaHyp7tc41oA2FUhf
	WZhdATKJE7SAapF5b7ECkmKHYnAMqpz9Xm9EtE05fsHN/Yo4jzLw46a0YcX5rnjudlzV2QtADfG
	d+nzJbBmnSHQVBUIuZcinCF084MKGg8gYeFJQDv3uME4z/xB9eJV/yCN+SOBAQTQHz11twQNhQI
	j8B5dkhpe4noB1XSdNG32PySziJEn3MEE5VwImOzFlEek4ctif3E88/KZC8NJGyOhe8VEiH40hO
	PdybE7epVKthmmLuX9DWb0ivdTGKafGYIF9y/ZdAxlJ5vUAPOYcimlVUMg==
X-Received: by 2002:a05:6402:358e:b0:64c:e9b6:14d8 with SMTP id
 4fb4d7f45d1cf-658a6086b03mr1532367a12.16.1769525796336; Tue, 27 Jan 2026
 06:56:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-4-hch@lst.de>
In-Reply-To: <20260121064339.206019-4-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:25:59 +0530
X-Gm-Features: AZwV_QjH1kmIMaQrUVHIXGBlrGO-v9DSB6aQQaOIY-kGTdF4jliUvC8MjPPK3J8
Message-ID: <CACzX3AtYb5d8iySouG5Dn81vtuwwGtQzqZdWCm-d8ZUCLq-6Cw@mail.gmail.com>
Subject: Re: [PATCH 03/15] block: add a bdev_has_integrity_csum helper
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
