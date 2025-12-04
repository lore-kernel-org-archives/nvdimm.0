Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718B5306B0C
	for <nvdimm@lists.linux.dev>; Thu,  4 Dec 2025 09:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841025; cv=none; b=Y9HVoTNaBXfB8vbBl/Se5vCmLTi648GZEsXuBuqgDrjF+Gc4FlhuvI/HKidnkq2rzh2FFcHK7LdvA1pTyWDIYwcMjVLrcLa0khMa3iI5OIClEUb6l9+CRK/LUMPAQ34UI5qPJbzbWdMRxNypGcj+CKYL0T23VhI+AsWcTft0nGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841025; c=relaxed/simple;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fL/EomNXC/ObKdbBwwJdgykERUznWrwxNti8ylAHVxSNfi5sNjZHEnMeqC4eefQg6vdtomPx62wSYMTp9bhsCc1hcDwAwq4dn3oR90jplEwUBzIN9X5c3tPXFMiqdTPzdgk3xQVz6YkiJc3NtVO2edpv107H6xaFCa9+ySy0yaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J9Xg1hNG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J9Xg1hNG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764841022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
	b=J9Xg1hNGgKJjP88Sx51OE4X/POL66noCRL4TOp8zfyt5r0S87yaYlEsZaFCXTn9d7HEudu
	p8V4h9zn+z9NvP99nwlzGjXejKldzFPtjXX2tCy+iphrOE7Zc2jFmAdt6NTxqCTzWi98m1
	cxkdLKadocpvq6QoQCkjbLAyCawE5kU=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-ouiNwjIeMTCv61Aj-7PNYg-1; Thu, 04 Dec 2025 04:37:01 -0500
X-MC-Unique: ouiNwjIeMTCv61Aj-7PNYg-1
X-Mimecast-MFC-AGG-ID: ouiNwjIeMTCv61Aj-7PNYg_1764841021
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787cf398a53so8270977b3.3
        for <nvdimm@lists.linux.dev>; Thu, 04 Dec 2025 01:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841021; x=1765445821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qeEjzVz7GQk6EpiDzPclRlc2LVPc/X5pecZGz9q1Q90=;
        b=Klp/OUpGIxMvPrA/ht5wNwI+QkBFgUI3Km6ieTbccVGmreQ96xVx1oD8NAj1e86BGv
         WPCB3IotFdc06mo5hSZl1ZcHuh5vxaH1zNxNfzCEpp4XmXCFzi5HMb0Ju4+ZWADj+Kvu
         0pEJ7V7JOWjCphNp943sEJyrGkcEwQ9pjXgj4NqnTeQa3tevk58tsK963WgjsuE1PIWu
         pcA8E3lvWhrloDSdZ1JtbqhsrM5fYUTKhLo2ebuZ5VEIi1/1kDzNEy/2vWe+iM8QdYig
         /zQVsBA6h9Ehw0TXNICdq4kMCxEu6qetCmLFAnINa3XMUfpVlXqEi/kqjGeVKgg7z8Ds
         QApA==
X-Forwarded-Encrypted: i=1; AJvYcCUpMv9xL37iSk4PnyrQGL0hNPblWZS+RQi3/uQQ4X1Dw+kdVrLTLLzNUxR4kErhWpAUmiv0HTM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx076w7auKrse0YvUbTZFF/BIojCv2aE3YkU4ytAvYPfISOzyTG
	K0KIEYytYeJNrVOt15z3oyRlA0tjDpOPrqKRhto4ajeIa2qcUZ9a9v8LjC88BOzpvzh/9kYol+p
	19yMgDfXevAJaS5g+luVRml5kha0rBrmsiy5kPw2fGppCOzxSQTOTPjIf2DgJp5g8l4GDncv2va
	DDGnfp9pAHgzFw8pDauRpdqD4b3/AZkTEQ
X-Gm-Gg: ASbGncsgUDc0DKJ9G+5sI/WbstP8N0qzMIGUNownAJytnluxKCjR4NZbJ6xqYX0WJ8e
	6bnI6A9pIAZ56iOjzbA0dLIaCw8jSLL245lWXtZySjC98R8dC+d63SK6OPX6LtieG1cB2HtLkEv
	1a5EARo3BvAmOM/7u2q3IvoTb/Ex9IprtM6UHzac5HBI5dPZxwVsBs8NIelX2WJXxv
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id 00721157ae682-78c0c210028mr42666237b3.67.1764841021012;
        Thu, 04 Dec 2025 01:37:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBJRkWOGl554rCJxMS1W+VD+59CzpNDKchBFktxp0UKkP2qgdZoPND338wG5ha+uJ8PPPkfv0dwHOd25ifO9U=
X-Received: by 2002:a05:690c:6713:b0:786:4fd5:e5de with SMTP id
 00721157ae682-78c0c210028mr42666067b3.67.1764841020714; Thu, 04 Dec 2025
 01:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
In-Reply-To: <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Thu, 4 Dec 2025 10:36:49 +0100
X-Gm-Features: AWmQ_blRRqbIFTY0f39yIA51TqtDoPBldWIhSqZwhzNWbMT5aHjbQPCsAOYEw2M
Message-ID: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UJsGvOkXy_LPGAqbc8ONHGDCSmqKxQYTzLHFjLElWxs_1764841021
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gmail=
.com> wrote:
> > This one should also be dropped because the 'prev' and 'new' are in
> > the wrong order.
>
> Ouch. Thanks for pointing this out.

Linus has merged the fix for this bug now, so this patch can be
updated / re-added.

Thanks,
Andreas

