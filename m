Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F7E34C981
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 23:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825745; cv=none; b=i/ftQgOg0ML+tzac2oU/JTLHI0fsOuha9098NOrifb0vKFHK3xfhkp4SjlNy0PFOBZksljA06lNv37u87sI6NMXXpmcUdytjDXSUjZileppARP0rc7hcpzleu8QiDlZXN9efVmjHlix9VezZRI+BWkHa3adL0+O9aV/S7X+GvM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825745; c=relaxed/simple;
	bh=qqeSoWk/kr7cgzxTryxgKHw4AT8tmJ/yRyn0JF+It4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sK/rQLcpMhJmvFZSZX4EEnoKQaoavBdvUpbVqjXYoGDZHTJyfYi2owAZ7SIqMNI9MPu87KYGn8CarR6wGYWjexSXrZ4KVoPOgHCwj33GVGkHwEd4bUuB/EvHPDD2lBiy9btnvLcOc7WYqvuYk27JW36Z+2Udh0hf5WdME8gIE3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WwjYkoyV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WwjYkoyV"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bed2195323cso215430066b.1
        for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 16:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781825743; x=1782430543; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k1mqpxSTTmULSk3oUwyZhCt8T4rICl+oa3gNsuybgSw=;
        b=WwjYkoyVAG4dzWovtTfOCdV1mr1f4pYyCQCLHGUcLEZl5w0cwSMHtogJcrW7kh3dms
         PaUQJAoV9UmfNMWRqnfhr4qkZCvqsETefSOBSHnz/REVcnSqUGh1AUVW4QLQ2MtIlzIi
         F15HWVbJNkwCz8+R9J5pc7OSBlcOo/Gb1rgc4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825743; x=1782430543;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1mqpxSTTmULSk3oUwyZhCt8T4rICl+oa3gNsuybgSw=;
        b=FERFd1Iyx83KUvIGDnJ5z2FK69foWCHsPLvpLbOz5h/FsTIFA1gbmGuZaoFt0DpKQR
         rEiRZd5Bt+PXP46AznxVNWUgUBJjSzIgUL9TzsJ6PeRyfXSTZEHnVmyyLNigrvcI9++O
         gT96W/1es/Rteb5cllS0iP5tTlTPLaYKhCxcQB97rPlDTfrjm9KYawAf+349GHFbQhm9
         E4kt0u/j6hG7MJDyze2YAgHtNovMKrk1Epob1op0vb1o6kvIzFlfiH39wxXq9hlk4KIm
         UFBThNSZ1lRWEhxzdI6SbTMMGjVmbmPgxsZvvOx3fNWpuxVoHyTsB8SX5uTMKiLF/cEY
         w02g==
X-Forwarded-Encrypted: i=1; AFNElJ+WUu97j9etohYay8+0SA5UySD0vardFUd3Vuo6NPzOj6VxS5HHFrhugcrf4+mEpX99WsqWkfs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9d3FoWQ5Dol/jbcnQd7oXjt1ucqYi0nS16scnbYktyw+GL264
	gAjxpfSLHIkYJwmdk7NRGUHUbUH6pIgIXvnOD4VrET4ivx9ywY9ZcBoTeZnERTI3JlqJY2yxR7R
	KSp/o9AI=
X-Gm-Gg: AfdE7cndIPdOomxGI39sARM3/LwMWwp9lGQZJ6w5HtQdMKHc/oORhqKWIkrk9LRLuvp
	ksXCWECeamZWh3ECIT0MOKFW1otfnf2xDkiSW+IIXVT6tjytgEK0pkxS+rb2jSbKIlxH2Bn/rQ7
	aoW/oyX2vzerCil0xQyhZDkdNiFtnZFjK9b8Bs6U+8TOeDY+G/udJd/IBLvi9Z3wxgpNZg9WamU
	W3m0WYheB1d2aZNjTHopu9Ts63lcgsgsgGZTQJnI2BD/VJAWrczx0clZFMznWK9SAkCubMls9jW
	wSiV9CgWK5hFhvyHn3YSbASvxPQErIr4DGY3TbOfxJC4Bog+4wuFIqGh63rLcEy4dLf4QhQOL/G
	PuAb9DSTwrN6VNiPlPKTRKtU5QSaMs252lPbdaalQXuprcBC/H9LTAn5Hes04ZoA0zCvFSMRsXO
	80eoGIa/KHE09DoCOh1tRsIPNKuZ5dfb3q9IYnZXJF/t1homZR3nohF3Zl+GemEg==
X-Received: by 2002:a17:907:7248:b0:bec:4a86:938d with SMTP id a640c23a62f3a-c0b4dc3db95mr9666166b.0.1781825742809;
        Thu, 18 Jun 2026 16:35:42 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0a844f53e9sm16419366b.13.2026.06.18.16.35.42
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 16:35:42 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c07680fdd12so170687266b.3
        for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 16:35:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/m1IJbmTHNkLQ1/jjHiP7iU5/XFE7yBtxGVlh7+WThXJ01Hd+TPcYd2smsdc/ywBJiSo8tM4g=@lists.linux.dev
X-Received: by 2002:a17:907:3d06:b0:c08:f5a:a0c4 with SMTP id
 a640c23a62f3a-c0b753888e4mr6338766b.43.1781825741933; Thu, 18 Jun 2026
 16:35:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
In-Reply-To: <ajQnMABCFUbVndvc@aschofie-mobl2.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jun 2026 16:35:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=whPaVoqWyFEgTYW7LNZOegBmP3YFcrbxCmXTgqVjytdyA@mail.gmail.com>
X-Gm-Features: AVVi8CfRncFN7f17ZLdsHNI0uVCQZOZshRiBelKMB6LETCMNjHTayK4EpucYVcg
Message-ID: <CAHk-=whPaVoqWyFEgTYW7LNZOegBmP3YFcrbxCmXTgqVjytdyA@mail.gmail.com>
Subject: Re: [GIT PULL] NVDIMM and DAX for 7.2
To: Alison Schofield <alison.schofield@intel.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Jun 2026 at 10:13, Alison Schofield
<alison.schofield@intel.com> wrote:
>
> Please pull to receive a small set of NVDIMM and DAX changes. Also
> included are updates to the MAINTAINER file, one which adds me as
> I'm picking up the patch wrangling role from Ira Weiny.

So I've pulled this, but generally I really prefer to have a heads-up
ahead of time that I should expect to get pull requests from new
maintainers.

Yes, yes, I see the updates to maintainer files etc, but a "expect the
next pull from Xyz" from the previous maintainer just makes me not
have to wonder what's going on...

            Linus
