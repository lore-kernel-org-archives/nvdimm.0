Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5994835CB66
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525820; cv=pass; b=GJ4kIsWg0uwF70IdvlsEMzEYqn6GSYrs898+uphlWFZD8hyTHX7M0Wqj/xWgl/xnTToWhFoM5kurL0ye2YAWCeP7+Vz6BK0ZUnn0J/Uobmd25men6aUidlDRgZUqZkDwfRbL82CxQIxwWzWa9s+gzcNvDAZgHLWZrz0BeFxPYkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525820; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ULszpCLD6XfvOyYN0T6IyiKAsxwGiOXjoTpWT3ZwfTzkpuVQCi2cCJX/hiHVA9r340qdZAIU4cQKVFS9FMuZ0b7fz8nwM6uoRShmqM0Cd9nz0Oa0isWNCo3isqI6FmZZXDsnm7NrcMd5SVgQEqwt+QOFgy7pGK/zsCDRfQtPo1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PI9BtVUi; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PI9BtVUi"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso9368425a12.2
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:56:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525817; cv=none;
        d=google.com; s=arc-20240605;
        b=AA08/XduBjmTVsIwng1+nCUV/woNzSn1PjYBIm7+zdW77n+jYpZtncB7jxKRAuSefv
         elaFYLWB1+3vICTF8LuDeNdK3QCmocqNWweYA6ARGABVV53YLjRQF3ORZSZtG0P9lbsJ
         HC7agSKrzmnlK5SAGEOff0VggbRoluAPdmXy4hR1Tan4LT3mAHr9Cr6Nha5T24SUv0Xd
         82B9ckQfp055XZoZ2E89NB96j8IRpe7l50CSWGxWMJNQA3uHBaIa6SwUXE43/Twm8j/V
         4yWM2FXDyRFX9Z90yH9hpgNW9zlOy3BkIaJ1woWs1Hl3XP+QyM8J7xQm4mYEyu3l2ByY
         8T4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=BXEp9bOZBgunWOyYoToGwPiyIuCVR7gomiB5V6q44mQ=;
        b=YkJHKHIq1KnqAILPD4h04MLrh1EDl3KAixB8U/x/jEP6OFI1TWohrd1oXZPV/DDyzE
         YhhYdGAwN9hoIyAfHc69QHaKQQ5tyC4JaQEkKWUTS7PhucYwd2bKc1YUTxagJEc9OuoB
         RNBvKjsKjFdMP+VaS01HWNGBIle9cFWPnatG/eo6fvHEdtd6IcTbzp7FcDQ4qLrt2LnR
         a9v3TRRMZ9bAafEudyeR16m8jXZJKIFUSs4XbfWPggK8+P4UgftWYye0BLEZWudvD9zz
         ovLK99hNwz17Dspyjf7wlXrdSlR5QB9pJwz3It5CpseRq62L8R7+5adOha3wfEYU0PFX
         +O+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525817; x=1770130617; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=PI9BtVUixFPSnbnmIRkee8/1JLKllYz0vvoUWtYMirqRz7c4430ezuhYQNo5ZHLnD1
         ZqbkOUkxWTmSS25JfIaDFMtLGgM0WmutjVvt6Zd6YtJw9JVFTZ85karfxdTJVe1eIrV5
         N5dkGya0LPHo9AT511L6HKk01EHIG2bUnJKATm36Q2ShjWEuaubmytbCC8KgZK0KpR46
         h13FB3s9uYVPN6Kt0Ct9/H6nbmeqJ89Vq/Px2Bel3lvj8QHbziYD4YPFerGFdGU+QeTF
         44VWf2Ul0jWzpFraOAGHpx9DfXTSJue6YJ6QD0fnPwgsSr1ym0cztblzHqky2xFHuWMf
         ZQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525817; x=1770130617;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=dL5oaZBtyYChI5lPNVjW+X3ueyZaIJKkGiwzO6vd7yPDDJMk8sMSICE8isX5KP56wi
         PnAKT14rcafW9zO5VKQeu5jthty1Ku4ldPXIHzv9rpNkzzCgx8HnKFBDMA+F/seo0xnq
         Uu0K1GmiSjVPQoaHzA+W/mtHJ4qLIehLmtzgLizFr7rh4O6yQx0Va7tin8DQ2yo2eWlo
         Ym7+gSvZBfOiiokEojyihHM2H1LXcOgkxBHiiUlq7sPFWc9Spw4QRAAP8lkQTOzXp7e8
         xJdEM7R4bgmeRPC/ceY1zl3cxlcet9Nz5mpx8Nk8Uqv91yf9mBehfDKDpD3MrKpAeFRa
         A81A==
X-Forwarded-Encrypted: i=1; AJvYcCVUCuNhebOgOlOqcZ7J3vczVk4CFsPFk9fQneI77tP3DNn5EDQXZGvoeP5d9HXw5MTfBwMFR3c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtmH/eLzZME27QJNnhFfHjGcHIQLlGxmWmRppauiERRcuAUjDV
	M12NQ1kk7WPqhFYUFgnWPursq/pI40gT+uFAXkfzDegwXO5i1H3icSy2s4sRQ7JO5jrQ+W5Jvdu
	+oL7zFUbqdOmQgiBq7i380oqztbk4MA==
X-Gm-Gg: AZuq6aKr79f9X8dRhJtvevvYcbZMIQTfYoSlw3tljUX42dwd7C9AaN5C4mNiOSkne8b
	zufjO+mOsaf9xo2JtxQZQoY9ECs015DgStgj1HIDTzF5D49SmiNxEtkcFiGtcVGOnKZ69sQQujq
	5ZcOZCgJgiClhev9YbapZMlFRg1W1kSjkq9ngXFrdR3lRM35CY4YWp/6OY5ZhyOvm5KirqRBMze
	1UAFmgIBxtXI2bEC3LX5vDwRrXS/jBI2ukI7TT51CCKuLTu1jY22VFYPVD1sW4x8t99dYXS8Ezx
	E+qxkVCfYBHSipYR3Z2xZGuB9H7RHq8v+4oZy2+XytBx3I1etFfhQLvAjw==
X-Received: by 2002:a05:6402:13d1:b0:64d:23ac:6ca7 with SMTP id
 4fb4d7f45d1cf-658a6083d59mr1404674a12.20.1769525817398; Tue, 27 Jan 2026
 06:56:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de> <20260121064339.206019-5-hch@lst.de>
In-Reply-To: <20260121064339.206019-5-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:26:18 +0530
X-Gm-Features: AZwV_QiDlPiwSdA1exwb_wyngdPHkJQcFo3xsAtPq8Ggx0ZleakNb4Ga8U4ZEd8
Message-ID: <CACzX3As2YHwiBXwHBTh-QHTc9g08V_tkBXqUsKCin8UfrgeLuQ@mail.gmail.com>
Subject: Re: [PATCH 04/15] block: prepare generation / verification helpers
 for fs usage
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
