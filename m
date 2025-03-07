Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A121B0F11
	for <nvdimm@lists.linux.dev>; Fri,  7 Mar 2025 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741388628; cv=none; b=KFrhfIWPcEMGls89yq2Ut28bbF6hr3DYrMCAaCIEtiibWAo66NwuXyu/AvKoZRxhmpj5PN3fdpDJ4VjNogbxIRZXf7wSU59h0WrizgLUDdkhotk7QyrbLkoiFySo/zvygTVfihTiNb3A/0ueyx1JAx8ejSSSbYKj5XBanlQ+8nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741388628; c=relaxed/simple;
	bh=Cg7tzJF/cbegOUZRx8dSKGVw+mp1jDxyJ6VHBTQ9Zg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCqT/DIM99x5UvxMs34jQ5glf6mHjpCibe8knipdGOvdtRaAc1Q3GbVZA1nzlcDFofijIuKoWSZwvNWLHoHUitl3fDUo7sorXGTzbW3YEiHc6q1uB8LZiKJxYgkpicPqLdQeqxQ6IG6sWXWxaB5HzP+XbLKVjYmFt8nPKLWTfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EB7erDS3; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EB7erDS3"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6e41e17645dso22129456d6.2
        for <nvdimm@lists.linux.dev>; Fri, 07 Mar 2025 15:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741388626; x=1741993426; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTzXTB5/hI3k/tUV1QdjmWKVi1pI+jp0+a6jtCFIsMQ=;
        b=EB7erDS39OWM8TNv6lMk1i7WZ14nWhdrhmllkTN8Q74hpCrF5AuwDuknQoYwFWR01z
         9j7DXOB5AcY6xjQR1kcFYSQqG2ZOnBUXKktJOzrPAnOCz6VK38U5oCsaDM080kliYCBB
         qVPe5M/KRIfWdbVYj3f735R1Fxrqetu/CiFQBaNli1Usnkxlbhu2tvwanh6X3V5sAsr1
         mrwxFQmvja8ttIBkX3g+XLXibj6SNlxkIgRACEXhJOTYwp0MlpMD93VWLt4coZWxktQP
         nyl2Kng4bd3HN5xIFeuDLX+Zmc5qMJQ4q7GX4xCWR6GBd3V9gIqDHBaczgKxVX3QBsrt
         +F2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741388626; x=1741993426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTzXTB5/hI3k/tUV1QdjmWKVi1pI+jp0+a6jtCFIsMQ=;
        b=j3m+dPSNdf71i67TXwgY0bRVCr7KkhhiGmS5oYKp4+bUXgwgGhYAj6csiizw3WUXJT
         /bXHjJUIcX7+DBNC9AdpLRQQ4xQFQjGL0IN2FgPkL8+tQGxqjO2TUJ0Ub57v3+9wxwLw
         Ztj2Rz9BX+MRUO8t4C/9OI85PrVxEDbI4+whva1U/FwofjAK1lBWjPnZsxd1ETGKh8h8
         XnOF3ySCHzVnAAYEOLR6FUf26atLxigL+UngjhLMTXjjHd6e54Fyan8fpM0BGKSghuJ8
         f9QIMzWCH99ezUfrkTLrFxjAN3v4f+2zQIwP12e5hvDx1fORtSJvYt+GlWo5Ckfb1clA
         br1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYDnoUN67BnnEZPpr0BKn45qwLcA2vzxzw6RyEqS1Qfk7n3OWetQVBLydMwtzjvhUrGRzidW8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNMRp4VMRk7A4qDshR2NtS5xD215CE2/GZcR/4Q/UNUF/95OKH
	kCZnXyn6bxkLGDRWxGSWOvPsijMaaUopIX5Gfb7mHiplhx6ew2/Yt0ucQKQt0+7gHUAq+TqBI8v
	9foljN0Sn0Ihylx0qmlMAhC5IN2I=
X-Gm-Gg: ASbGncusMCW+9dxrejZ6qgqvuUCCYVtKfJ2oB9X2wb+p3X5w3mavXGOX4XF3kjBJseX
	JqvTwOLsogfkld7NHywZQu29U4gSbeAoqni+Q4A0G9Rt88QYsCB3wzdk9EhgAZcUOtjpKedb2zl
	PuUEQihF/gErpYT8jq65ou2TbiHzVEvsZq0m6ODb+8NQ==
X-Google-Smtp-Source: AGHT+IGuZ0NkG/KYo9Dv4g1oyD3XwK6X16DBM6QY/A6W3C/6eEhj7vqNq1AeDarxJvsQFObtM42FXnLLMg29Plyo2bk=
X-Received: by 2002:a05:6214:2aa7:b0:6e8:9e9c:d20f with SMTP id
 6a1803df08f44-6e900621afcmr58352476d6.21.1741388625281; Fri, 07 Mar 2025
 15:03:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
In-Reply-To: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 7 Mar 2025 15:03:34 -0800
X-Gm-Features: AQ5f1Jr_FBnz9qk1uNlckq4_7pHKTqldI029tYPnmq326QX8Uckh0mZErYX0PQo
Message-ID: <CAKEwX=NfKrisQL-DBcNxBwK2ErK-u=MSzHNpETcuWWNBh9s9Bg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Barry Song <baohua@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 4:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@mediatek.co=
m> wrote:
>
> This patch series introduces a new mechanism called kcompressd to
> improve the efficiency of memory reclaiming in the operating system. The
> main goal is to separate the tasks of page scanning and page compression
> into distinct processes or threads, thereby reducing the load on the
> kswapd thread and enhancing overall system performance under high memory
> pressure conditions.

Please excuse my ignorance, but from your cover letter I still don't
quite get what is the problem here? And how would decouple compression
and scanning help?

>
> Problem:
>  In the current system, the kswapd thread is responsible for both
>  scanning the LRU pages and compressing pages into the ZRAM. This
>  combined responsibility can lead to significant performance bottlenecks,

What bottleneck are we talking about? Is one stage slower than the other?

>  especially under high memory pressure. The kswapd thread becomes a
>  single point of contention, causing delays in memory reclaiming and
>  overall system performance degradation.
>
> Target:
>  The target of this invention is to improve the efficiency of memory
>  reclaiming. By separating the tasks of page scanning and page
>  compression into distinct processes or threads, the system can handle
>  memory pressure more effectively.

I'm not a zram maintainer, so I'm definitely not trying to stop this
patch. But whatever problem zram is facing will likely occur with
zswap too, so I'd like to learn more :)
