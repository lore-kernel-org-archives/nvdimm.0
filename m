Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4507208989
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741389283; cv=none; b=cORi41hConBwPHPvSoRwZM5KG9SgTfMEWa7RBua0ud3QVrMaastteynwbeclwJL+ezO3WSs357vOAPKsC8wLiP9zAiLwHzSHGmay1GpZ0+1Z37PL2un1VExKGhxxOY8clCIhu/dOJkiOS0k9E/gC3Ud8aXrlJP4cNVfhCVi/6os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741389283; c=relaxed/simple;
	bh=hvlQKLrSiuf2/LahHmulAvjGAEyNjmerVi/1M7Kc3Yc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ck72mxrjswiWwdMfUF5zGu0f+3vrEzREH2m772XazlHneIlhWjg86Fsp8uwd1XVTc6l5kxrtXFIkrQf78agNjqtVqCyOv3eWL8znPY3eDG/PWRqtDMJqitsHc24+4njt2r1XSuXa19LzTjhDYyulvy0TUnJe6FRWNTe35A1mjxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aibn7WLQ; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aibn7WLQ"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6e8fca43972so17646206d6.1
        for <nvdimm@lists.linux.dev>; Fri, 07 Mar 2025 15:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741389281; x=1741994081; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvlQKLrSiuf2/LahHmulAvjGAEyNjmerVi/1M7Kc3Yc=;
        b=aibn7WLQnGTjNMHgf4xWYwEcsbkRkTxIOd44+b9JENCfMK4iZ0APW2CAR8E+BdaBfV
         OmBG1zB0f3COKVfDDBw3whE2jNR+mXQuWy/IVHSS9FpfQ5SW4H86FUxWMwn1N6W1DpP8
         8k1EwdiJcZRNLEVCL6SAjhY7mS71mwdUohsWQXNPonA912egbDXBVbqZt6i5JxhyLqNb
         YXm190yUwONhnFu6xVpEqaeyh60z5QULtGNRkQlBP6n30ZyPCBFh9QHtSVyTXWkbM9xl
         RSe15Oh2LDds5TSeMBCnuFzeZtfNfadzNlJOGSZ7OdPu3SFGedQRij4NtgCyizAOgTRg
         Ut4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741389281; x=1741994081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvlQKLrSiuf2/LahHmulAvjGAEyNjmerVi/1M7Kc3Yc=;
        b=mgqzzVgjQLvjjkINMBxQ49qxa07vh42Vg4Als+qFuM0AzA8Cl9Zl9wJk/2yHqnZl+/
         CsS3i9IGQnNducYzrnfVUnPD/pJab59j1LJcM4TLxmKlNXiHOs3+cQLCuQ/4TcS5ejGl
         ZG/Pa/1Nq6WKSLA69rRpkwuV47h6KcPJbDu1TOYZC+pfzJC9bWy8NdIjmwGqFvU/pRNC
         JYHUN9HuPuT44eVNv7rtmcKtEXTfrDEVKEt12erI+pNMnaJceD8vsBZYCzUtsLz8iSnO
         FXuTNGXPGEcgwHk3OuV+NTCyOmZdbzBV+oVvNEJmrfE04wXUj4q3gMaUV/MCNj8zY3SB
         vYOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXII5dAsL0HwE+RMnJx+gFa4ikkTFuX2OCRhWBSbkZj5TMeIHGDbxAuswpb4TUx8rGiUDS29Jk=@lists.linux.dev
X-Gm-Message-State: AOJu0YztHw6SN3f5uQBXTwZoAoZpvgqmotg/FZ0tTj/swBvGnW2ujahR
	iY/A0y2FIs82i7XLP/wXmhaDPbSKgfx5QX/XBDV9k2KnKK9gIpHSYBiV8oR6KzHwPr03ojQUuzB
	tCFjBvVYZ73UG+/XBR53oFEa9nTs=
X-Gm-Gg: ASbGncstVCTOFT02cWML63ls5EUw2bEjnLebnqW4Lxszf3MObbN35Iu+jE2FG4M8j3A
	E0yyGQgEuxaLVkr20ayzfboBcVs1JwS6Of873r/2IO+AnL8hGZdiC0ihdm2BC0KaHGx7hcjYPWr
	/QNwA9jbktY6pM99/+mMMETv694V/RgEWhZvhH/RoA3A==
X-Google-Smtp-Source: AGHT+IHWYEQ6LscglzBgawkGRiqBX2sOTVaS0nueKi1A4ZzRN9eK4g2H4WB1UETzJEMeMek/KVtF2JUfl6jDtMtPy88=
X-Received: by 2002:a05:6214:76c:b0:6e8:fa7a:14ab with SMTP id
 6a1803df08f44-6e9005b6618mr58352686d6.6.1741389280497; Fri, 07 Mar 2025
 15:14:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <20250307120141.1566673-3-qun-wei.lin@mediatek.com> <CAGsJ_4xtp9iGPQinu5DOi3R2B47X9o=wS94GdhdY-0JUATf5hw@mail.gmail.com>
 <CAKEwX=OP9PJ9YeUvy3ZMQPByH7ELHLDfeLuuYKvPy3aCQCAJwQ@mail.gmail.com>
In-Reply-To: <CAKEwX=OP9PJ9YeUvy3ZMQPByH7ELHLDfeLuuYKvPy3aCQCAJwQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 7 Mar 2025 15:14:29 -0800
X-Gm-Features: AQ5f1Jo_UNIHhJUaEMGqM4jtD6PWvuZ_dX8aqKe0wEkynddQGZ-ujq2FDrA5W-U
Message-ID: <CAKEwX=MtzM4Vw221pHTj8CZJ1NhLgo7Ls3xroxLRO399fzG98Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] kcompressd: Add Kcompressd for accelerated zram compression
To: Barry Song <21cnbao@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>, Jens Axboe <axboe@kernel.dk>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kairui Song <kasong@tencent.com>, 
	Dan Schatzberg <schatzberg.dan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 3:13=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
>
> Agree. A shared solution would be much appreciated. We can keep the
> kcompressd idea, but have it accept IO work from multiple sources
> (zram, zswap, whatever) through a shared API.

by IO I meant compress work (should be double quoted "IO"). But you
get the idea :)
