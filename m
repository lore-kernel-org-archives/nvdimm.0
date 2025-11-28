Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361CC2441A0
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 01:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764293430; cv=none; b=BnIGZMOCBblEyr0HuGAqLOCnn3wRqM5MnkI3XKx7dJ3zOZAZjNT1pUVkEBneVm71WHb0Y3iNh65/gQm7hmpPs9LUPxAkOHfFczuEKVlidzyQe4HRCCpgwwVTBz+w/RgZwXtXJzDEWawNARSgNmTq/Ia6FPVTLVGSYMl/yRsnLo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764293430; c=relaxed/simple;
	bh=KBcsmp5at+jJviL3J+0mcROw+lr8j4mNJ+AGY+9OtGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nX0i4aVrvWpZ1RLyBbbC0lYkcxYRZe0aN6rpTt/Dj6THd6jyLz2TAkfXH++0YyT0TUzHrQjXSfIe5jSNocmcAsmo6l3O/vTTcThqpK7Sc23gBjT3+1kot88De6AHeWVhweC9yJIJUqhvycx31yKG08N0xHsPSXmEmwMUtthm0TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EohoMbcs; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EohoMbcs"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4edb6e678ddso17425841cf.2
        for <nvdimm@lists.linux.dev>; Thu, 27 Nov 2025 17:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764293428; x=1764898228; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5P89IZigPftxBdPjv0hBiMVJle7Ici8oyWvWVUIt1w=;
        b=EohoMbcslBppWCzyB78X0zdPUNazPZ+8ULHM/CB+1nxoiM5i34w5x6N51p9GbRm31g
         nL2+wQVDPaEK7VbUMREkHLMucLKNjZUV7jn/PSSp4EwX1Ad4Ynm/WsPG5KqQGEUa6ApI
         TdeqPqTpAQIvPKJbCNuOAwd5v4T2f/cHDrn44XHK5JidfVviE0kakqc8QlAJBbK4Qz48
         g+qH1iOCHXfYRSy3OaDmahzOWlPhv6oLq6scohMU8qtZXz0Hy0EF0+OjcHVd6CUMgXpZ
         RI/P1ty+0fgEvclEs9VPhgt2kT8NZa5fFXXVqPcl9d1ZnhvzMpH0QOf+agOuGYgn7URI
         A1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764293428; x=1764898228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D5P89IZigPftxBdPjv0hBiMVJle7Ici8oyWvWVUIt1w=;
        b=SDBT0nd3ZIG7D5Q4awSJMHh22oQw1JDs3j5NwNG0VTjplEdzPOXXSF0bSJGJIch1e9
         P1pRG/2F0IGCKPx4e17US/J2tgwKLgAP931n24N7o8l92t5CHgk0/htth7fDE4Z+rrzN
         wJaccxXiiXceSU6WI3NE6ZTPXnja9O0eKx38BavFn73/ipScLHtJ0ZUbg3AJ+Nb1lkaE
         QQhjVNUfPm/md5I+bW6UUEMZKHZmqXnbLtx3UIX4vSc4dPLP9s24Qzmuun1m7XNG7ikS
         XUEy1EfXJqGY1+Fo2TI1KLua1TU6R8TyN6qLe07Kk78m1YAlF1bZSpnI44ecVox1funo
         e3Xg==
X-Forwarded-Encrypted: i=1; AJvYcCW9hk8WF4Bo7xbD60k1b/AO3NSMZA68YIExQizvRRCYKE5SIxv18GChgBmwXl21P9vwFYjHBuo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxd8gKu1xWwKSFdQrpIhR+IH33hGvLdU6One/prYegmB6T9qmlL
	8AdbGi7p406q1632HCfkKhXBLcUtdVAWzvm11t8Sea7zN/sP53KGF/YTP9ffanYk3gfNI/2YI2G
	nUnteuZ3JZCrP/vZxg8lXnpkDzRldOOM=
X-Gm-Gg: ASbGncsCoXKHI8aPW3uKyKhsVVdhmBV6Sl/PMlCX/yo6d3R2Rt4+YCJulZpYvkSqolR
	UCbpCAPl6J/BwNDAYRXnxsnPbICVATnlg7R2fhqtoyND1lO4BxSscLeWfFjM95ZQOsdkvf+7e4H
	8JB/kjtUrruuzBDW3/TnQbLjQH627LWEuQ4FXIcLewH80cujtNOkPRT2iMN6N8cCvmwjI26nUzv
	gHPTGQXen9HAHU0uWZ9R5j098OnUJ47/UfZWpgF3SMyDajbuP1eC6fNr6rIW61TQleC/g8=
X-Google-Smtp-Source: AGHT+IHLwC+N+hhLqdlufghZ5fhnM4rSYysjvUV/1fIoNRweHCYWM0pQrvWGMYNUf8igtQ6F3vcEMbZAHieS7voSeP4=
X-Received: by 2002:ac8:57d0:0:b0:4ee:827:7e62 with SMTP id
 d75a77b69052e-4ee58b05b62mr339066531cf.82.1764293427985; Thu, 27 Nov 2025
 17:30:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org> <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org> <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
 <aSf6T6z6f2YqQRPH@infradead.org>
In-Reply-To: <aSf6T6z6f2YqQRPH@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 09:29:52 +0800
X-Gm-Features: AWmQ_bnZka8N-6d6tnub2wv_mKK_srvt07g0FExU0PMtOqpsh3yITqQM0jweo2c
Message-ID: <CANubcdVhDZ+G5brj6g+mBBOHLyeyM9gWaLJ+EKwyWXJjSoi1SQ@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8827=
=E6=97=A5=E5=91=A8=E5=9B=9B 15:17=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Nov 27, 2025 at 03:05:29PM +0800, Stephen Zhang wrote:
> > No, they are not using bcache.
>
> Then please figure out how bio_chain_endio even gets called in this
> setup.  I think for mainline the approach should be to fix bcache
> and eorfs to not call into ->bi_end_io and add a BUG_ON() to
> bio_chain_endio to ensure no new callers appear.  I
>

Okay, thanks for the suggestion.

> > If there are no further objections or other insights regarding this iss=
ue,
> > I will proceed with creating a v2 of this series.
>
> Not sure how that is helpful.  You have a problem on a kernel from stone
> age, can't explain what actually happens and propose something that is
> mostly a no-op in mainline, with the callers that could even reach the
> area being clear API misuse.
>

Analysis of the 4.19 kernel bug confirmed it was not caused by the
->bi_end_io call. Instead, this investigation led us to discover a differen=
t bug
in the upstream kernel. The v2 patch series is dedicated to fixing this new=
ly
found upstream issue.

Thanks,
shida
>
