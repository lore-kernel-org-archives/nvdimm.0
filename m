Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24866352014
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 12:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779194740; cv=pass; b=i6g683QkiOeablyDUVaafPNIVjSoSiN0HFS2iYcjdU0iHLlXwc9ushbi2G5vd4saK7uWIwTW2W8dBJ/g7RPrsbHpC9+PP8fKhA36Lwu42qiOOJ2Kji99bZK4Df6V2J0vicqF7aefJ3lDl8e7ESulnw/eWQKVqgLQO7+eilHykzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779194740; c=relaxed/simple;
	bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQVtJYojoexb6iDcq7rCXf4xPKuWax5Rr4beiFdCDHMTewzI29PrjSJqVqTbrGj2SCzXjucdEWkdNSXWCzPCMlgVKvfuPZqS/2HzvLqbhqGE+vLGfxBXj/XuTUJjk+uy/jYHGA/l/I0Epge3n7BhjFoDg+toZX3HJJ9Y1UVfOQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hX9M/7Hl; arc=pass smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hX9M/7Hl"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-303da604df1so223019eec.3
        for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 05:45:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779194738; cv=none;
        d=google.com; s=arc-20240605;
        b=UcAOM5fPGk3oLLZjM981cr2NAVFbNin7RPcNl9RO4zdazCImCfbQhQomU0zHtESnpK
         NmWoQpKK0iwL2n3rWvPPtC4N0SbUVYyNgGSTjCRUtS9VOcj1qFn6SVDz+K66FWSiJRUU
         0LuRkpSATXLWoHGoaBaQeM7Upz+A9P8HGU5FQYvHPKTSryvdJAjZIvGu28iyaDl63/z2
         gtLH9bUNcYWEciEvaqF/S0TzHcVYFjkvIcDR1yTwj6mGwgDyCpdnkUXqCq9UKLcHCxRg
         1Rt4N1u+X13sf7r8S4ervUbcsDXHjIbUoJx8iVXkYvzwu+yOg6AdicmWhqZVaSIpgecu
         koQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        fh=4IBxhdyHYJUQKk9yJvuAR3RX4G+fqT6cNlAALP/BQQs=;
        b=djMftc++bWQnesdiho2ElTWOr5X3Ks1Mzj0uMjOL/O0eb5glHoJGmlI7QqHtIX5S2a
         TXErAsVhjgSqH7qWVL6hdWObkDFp2EfNMBiLHqm+QpOszZ/1CEe2zeI2EZKeBeu6W641
         J8buYtQzgScu7WK0GCzOujUcw9RVXwj6S2lV5GLVxq5o4lps0bvw6VgGMreEqUHtU2hD
         3are8DzRgPB2MXMkXhTdLW566ZtMNp5CBNupiTVe5he0mu3/zQhn8JPuj80Ttxw17Z4t
         ZGsZ8YzCuNmuL6uovchxBYbVqKMnDeK3znVQBNBW68A/k63+aKWTVcpGY/TKWAI6vfee
         mosA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779194738; x=1779799538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        b=hX9M/7HlvdjoGrix+5vizW6S2ozIOnMJNZSxmqTtlsbAqDxG3reR48sNJ+UPG9gaDP
         OqnSn2ETlfXhQUFRfRL4hpb4a92XBCdr3jV72fwxeETf8Xt4q9GBTTSs0/nII1GjgJat
         3YYgrGePA7I4AremQHA/GFgCQNo4KXxdWEYkEeKKRnN+08UCoinb2MXS2P2PstRLLM9g
         TuyQQ4La5T7eK7kcpp6ZaQpEJk/nrjIJm3m+7/Ts3ksMPzJRZwFKkWHDNI0eyZ1tCWdI
         sKqZ7e74Fim5RFNT+ZrJO/ng4QyxrdMiYWVxi9731tU195mJC9mvBJAzJxcYcap24vdH
         mCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779194738; x=1779799538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iJFxbnlmJvWrQl+Lxd7lmj1zCeV+BRB2ufMB2h55rV4=;
        b=Vm0g0nGsbu4Jgkl4zZYv3aMZ7NVl4WFdjuvdsbuL9iKQKiVVDDa1k+F/4edTwyeCer
         Fk/67Ft3QRsts03coX4UVN84+uYB5aKhAS80TcZghyilfnXnYgW1lMZM8Yf/zEHIXr6l
         17X2UkLgP4wBkKItKGhNbnWFUx6rtTX2A3+HU6LhefPn3r3QoCwXzAfTpGo9z2HCuOZ/
         A5MvjehUAH2TMiKpdwTLvGbOdmpHixlgKmixLhvPNzpt7L6iEw0c10pTH5pNuz7qzGM0
         /eaaAxCh5M8rQiScJJkP0HVkD6P2dutsJF1RY3vqQN/TzS3u6Ugf5/gEqBdEOKp/K5sy
         PA7g==
X-Forwarded-Encrypted: i=1; AFNElJ86/u0gYZb/b+215e/fGT7u1VpDjztEoGTvl5wCjU9EAKq7SlTFyf/NscFmY1LtD7/vfR7Kbps=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5n0YYQJERvyS1y9qzc7WDjYiyzedjH/XrcnqyTbP2aYMkr0P4
	U88GLDkiqDLUgjngCMn8kNu7URpof7PnjdjYoL8plcsND4wFgch7a+YYWEvOTWla92eYH34OFsy
	+cYTTgvsbpPLEVQcJPcMDS4PAJNyY6E4=
X-Gm-Gg: Acq92OErgFiJFd3kprIk7cqbJEdmhNmK74L16OV7nUrgINhmy+3hc1Hc8iA158Wd+d5
	7rhW0b8BoZYQ1U1oEkT9h2mLI3LynvO9ATXonq76QLORGsLEj7eCC0aRl2dcrfMPgdKZO1iFWqU
	njShPKVaxHxKLb8kuv53afKk2RzjEa2Q4Qnu39+r4DXM2dXAokkLSxvHPwnyvxKkpQlr9AFpFq4
	jLgulnhoqCe5lO6z5tJy/IlLXUENP89cOUdMmx8Z1jr/b1f+NaZr3a1QlICtnZR7lZRKYOdCDWs
	XR4d+tGux1c61LO8i0AdJkmS1zRx/puqPLrCwe0L4olL0amAGmaTZzuiAIB06m/xQXh7f/yKfHN
	vCDUUFdbEjfKJL2WHN1NLo4c=
X-Received: by 2002:a05:7301:1284:b0:2ce:db5e:354b with SMTP id
 5a478bee46e88-3039868c605mr4201196eec.6.1779194738147; Tue, 19 May 2026
 05:45:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1779116497.git.d@ilvokhin.com> <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
 <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com> <agxPiQKt2pykEIA4@shell.ilvokhin.com>
In-Reply-To: <agxPiQKt2pykEIA4@shell.ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 19 May 2026 14:45:25 +0200
X-Gm-Features: AVHnY4I3tKHMpeVy0SsdLCwhfLkAoVFoOWpjpia5ybm3cMqW4XsbiRrpZww0564
Message-ID: <CANiq72nTDFiGp5f6=Xh3w4jnULq-Vs60Bztj6FhfGFeihwa_QQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 1:54=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> Thanks, fixed locally.

Sounds good, thanks!

Acked-by: Miguel Ojeda <ojeda@kernel.org>

Cheers,
Miguel
