Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983142D0C90
	for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 06:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311243; cv=none; b=a00Y29BSfRJGbBhONgp2kDocywDMuoLUCnkmKFMLz/m2ac6KHuXMndwhbC25hjup8VQDEntBp4/iLLdwINT1lqkcp6W0GPyaEAigdEouIZFE8YMDRGIG7WKXMJ3bmDHjzo1NATHQTlGeLVmGp574oxKeurp1vcuFcymIx2KHZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311243; c=relaxed/simple;
	bh=uxXx2Dt9ovr7xEDXTx3MLSG145z2GZi2DJ1y87yMKcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4pscwVoe6gtsGl5C98lN3nwrzdXBcaa9F5+dhdinppwcnJBgmcRKHykE0pQUviIjsBYQLVmASe8UlqkyJJK1N5wnI8igy4AkvLnycwctrcusC9neaxDBEFHkJfIauSd47/dD6arpVTcwbI/0Dy6RTR5yd9BbeFImH2J9l0LglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J+Mdo120; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J+Mdo120"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b29ff9d18cso137273785a.3
        for <nvdimm@lists.linux.dev>; Thu, 27 Nov 2025 22:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764311240; x=1764916040; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNBX+tdFCi976CT3NTPOtFudKzRzrB7upXknWDTBPfs=;
        b=J+Mdo1204QiOaVSk7IR5i+v8RAeaScbetMzkahl3pZ0//PJJYuz+PTc2RM8m9keMdM
         1Nd1qCDvodQ4I7TfmAjqirgjOw9JClLpqGJzdsc3F9hXBr9f6FfmpirdUabESMuNXI5I
         9soRbOwuc2mowLRmYf6Ur3LO+qBdbhUxJjEVDo39/WfT46qSQ8mY/d37e/HKl/rA2ln0
         xcarpaIIkwJp36DkbTkpeLX3KU8sDoygArQyURsmwlrh+ge8CgE1qe8huE9ljk6tIu/t
         fykc/9JWATqjV0dPirlQPljb254r/Eli0jsxaTjyUMFsAhLH7FN5ZZque7sUzBNkJf6N
         Pgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764311240; x=1764916040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rNBX+tdFCi976CT3NTPOtFudKzRzrB7upXknWDTBPfs=;
        b=qj0LBOTf3lYzeL4q/KGRjcQIBC0K08oMK9PAihY4WB6cLHjys8LrdU4Ndx14sx1psF
         MJMZYohn3awMYDE09N8rkETkjdiAiHHxMkzUD/CsUwNXWz7hZZwoGmVCJUOEBk90ZV6O
         2PJMeHpqcbDQ2HKROBl9WXP7zLQTK+NrB6LEcyy2LxCvgKVmwZxdT8jb6edbcWRkV9hV
         MLre0U0OeCFyvoq+x1IIlOiVzsr66TVmU+hbloPvLGIpW0Juv//7XnyAg7RRQCQUWoXy
         b+abUv5QJgdvSdDD0hC2W+V0xKUePd6mwo9Marqz1VvZOUPS3YUMv2+Tz1SN8SN1aBHZ
         +Z1Q==
X-Forwarded-Encrypted: i=1; AJvYcCX+cuVI+1UaBe3LWWXGTRE0dAvF6o/9AaINlTMg/4Q0zQMRD+zQNQWc08VIoLA4xPCNuowfhTA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUqu8EJM+Cbop4IkqO6CyxpO1UGEAi/fi78VVFCVkyDQcUfnM2
	u/z8h1KN0fDkLL+AbLROhIJFL+vH9+2l3i+/Gnz9gKeq8Dmy+PlPHI3zlDGXeWGno/2bwwGOwUW
	4GBwrs922ksjcSnZb2JoxdQXsu3PuaO4=
X-Gm-Gg: ASbGncvZJLRVz7/8+eMy+83Fn/ja38dZQAtxqrvEjcLxXQLUZyAj5lNQWNvDpZLHrLR
	nwHnGfksqZoqocLV7blvtEhJHW+hNXz9z4wk+Cgbf79fz/Xw19YZnTG/xbOEJ5WD1jlgPB+XYqc
	yaU0+suJic49ihAnd6byYP85OouH9ZIcXMJO2gUVnlQwvQDpXomINzfdaVuZjSgIuTzKs9maAwy
	5veGMCHQXRDxuqSgw2gnjzwCDocwwTv0vp5wRoxvqLSl0NBlPabi40DH0CQKEJ3Psg/En8=
X-Google-Smtp-Source: AGHT+IHqoxxME/wZYacFTCZmpyvjYqen8b7+sN/d+VbUoZE5rC4JPn9P+8N4Y6c+biawDbsHSmqE9yp/CsWDMeNGoss=
X-Received: by 2002:a05:622a:3d4:b0:4ed:43ae:85f6 with SMTP id
 d75a77b69052e-4ee58911262mr343758661cf.47.1764311240290; Thu, 27 Nov 2025
 22:27:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <20251121081748.1443507-2-zhangshida@kylinos.cn> <aSA_dTktkC85K39o@infradead.org>
 <CAHc6FU7NpnmbOGZB8Z7VwOBoZLm8jZkcAk_2yPANy9=DYS67-A@mail.gmail.com>
 <CANubcdXzxPuh9wweeW0yjprsQRZuBWmJwnEBcihqtvk6n7b=bQ@mail.gmail.com> <aSk5QFHzCwz97Xqw@infradead.org>
In-Reply-To: <aSk5QFHzCwz97Xqw@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 14:26:44 +0800
X-Gm-Features: AWmQ_blfmVuM70WOWxBT6SLO-nBFz1VQq0RiOHlp-O6KawgJbGDwoH1nduOeubA
Message-ID: <CANubcdVTwitvE8ZP2BRtW28u8ZYBvdobxxXQgDSRWP_FbS1Wmg@mail.gmail.com>
Subject: Re: [PATCH 1/9] block: fix data loss and stale date exposure problems
 during append write
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=
=E6=97=A5=E5=91=A8=E4=BA=94 13:55=E5=86=99=E9=81=93=EF=BC=9A
>
> On Fri, Nov 28, 2025 at 11:22:49AM +0800, Stephen Zhang wrote:
> > Therefore, we could potentially change it to::
> >
> >         if (bio->bi_status && !READ_ONCE(parent->bi_status))
> >                 parent->bi_status =3D bio->bi_status;
> >
> > But as you mentioned, the check might not be critical here. So ultimate=
ly,
> > we can simplify it to:
> >
> >         if (bio->bi_status)
> >                 parent->bi_status =3D bio->bi_status;
>
> It might make sense to just use cmpxchg.  See btrfs_bio_end_io as an
> example (although it is operating on the btrfs_bio structure)
>

Thanks for the suggestion! I learned something new today.

Thanks,
Shida
