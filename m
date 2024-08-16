Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994481E4AF
	for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 18:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723833781; cv=none; b=UZ02zJ+gVi1tioBvaqnzFohyn5MsjMP5W2lbpBgfBwY/XW5U/Moo/iJshOjeh2cZ7ZyySQRCBvBbMIbaRhHkyx5sdD87VScFjRmwg32CWrATyUyWxuKc09/SF7+IiQgjDZlQ0sgukYCKo3g+um4yslz4UnyH+lfh7ew7UPztquY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723833781; c=relaxed/simple;
	bh=IwDsZVeG3gGyoqwk/D1vcp3mZayiN81MvGHLXWnEqvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pteT+PNRarOtvdA7OWHWMYqJr2cbIJiTgHc7Typ5Bl5EOeJ1zQDeSl9MAe6DkyfuZ5PEPwMPs8jzpAJfwe5AFeavwEeEkRFfvU2/OBhWm+PhSZt4BUiUAJiNh35BO7LxJAmu2FAsNpUwRI/FGSLwkWWWOT0N+ddrSa9RS4hEGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GTJuQcY1; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GTJuQcY1"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-530e2287825so2299216e87.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 11:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1723833777; x=1724438577; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SwP9f/9nyRQVtMDDIAkjN0ZO4UbDprmvfV2rz1oAwo8=;
        b=GTJuQcY1fLsVL5mue+uVw7rOVCM/ZUeJCWSnENmii6I750qhRu+BaWPkQk33QNw6Xp
         CW7cw1ap0yPFbgmaocYWvoH8DmmcIQ5pn4xnajYEniRyfajSpRQ2AmGFnbJscTXupH0/
         B3YYb4EVAKUdOO5gxJu4bctdKP01/mkMJgyhs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723833777; x=1724438577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwP9f/9nyRQVtMDDIAkjN0ZO4UbDprmvfV2rz1oAwo8=;
        b=vsAZ3lCg/mY6SKaDrHjHs0SlYNZH7Xc2fGHWG55UgJ9mJnHLfUE9ZR0Ar5I49zV61R
         6JimEATV27UxgicqbZ11+6h4xlDPtfWD7pHEdT3FJ2nSrv5fukM+BXmsyPeakwWHRigP
         qEOxqzGBGyTSY295W1TohPeO68Fs+/cmEM7AwsmY9m8gnAdSDMqvDyQgYB/xnkNRURMf
         9EfU/wsfT8qUzvoz+/f57Jau7DIZT76z3EjrjSS8a254XQ3AWOSlk6D7SofQNplaVdZN
         hMnFm8ep5wjh/BYbZJ1cABttTo5El8BJAFgHy7ECnNu9jlPwOkP4Mmee4vroXFRAFX/w
         VbRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjPXO7Fok0Rr8jot/QYyekqAIGdM1IyhuZ2dUDG9O5yJi5L9w1ZMg6FE/pDAWjStfObcRo4Zc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR2h/fvpfyZ4n3pvsUM/5xaj3KNyNp2m8LG0FNz4dkzUPHmIRe
	NIzlbhAD8stzlGTn+eukYllbSvI7fVBBMCtpkNOyYVZgUHRs0UzTjh/elFU9z69npk75L5EpZyR
	4gX4=
X-Google-Smtp-Source: AGHT+IGzv/daqROEnOT7rG7jadUIaIZRnVhH5tT3FD5bWsxrwwqWSqzpGMLfjvBGgkbQTCwB7gLFaA==
X-Received: by 2002:a05:6512:39d0:b0:52c:86d6:e8d7 with SMTP id 2adb3069b0e04-5331c69e8cemr2499702e87.13.1723833776799;
        Fri, 16 Aug 2024 11:42:56 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5330d3ff322sm641353e87.173.2024.08.16.11.42.56
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 11:42:56 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ef2d96164aso27839381fa.3
        for <nvdimm@lists.linux.dev>; Fri, 16 Aug 2024 11:42:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU5RmmgnIJy+7TbwsN0Kd4YCbZIMTcuoIE9XMDi9GU9mzegKeHbQ7GLU1UsKCtSjE/shHfdsYg=@lists.linux.dev
X-Received: by 2002:a2e:d1a:0:b0:2ef:2fc9:c8b2 with SMTP id
 38308e7fff4ca-2f3be5de43cmr21003861fa.37.1723833775772; Fri, 16 Aug 2024
 11:42:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <66bf57c7b023f_22218329410@iweiny-mobl.notmuch> <66bf8913bae92_23041d29441@iweiny-mobl.notmuch>
In-Reply-To: <66bf8913bae92_23041d29441@iweiny-mobl.notmuch>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Aug 2024 11:42:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiBSaEoou5_0myVxAgLd5YXUbeGq1e8BSd4i=vdMb1jcg@mail.gmail.com>
Message-ID: <CAHk-=wiBSaEoou5_0myVxAgLd5YXUbeGq1e8BSd4i=vdMb1jcg@mail.gmail.com>
Subject: Re: [GIT PULL] DAX for 6.11
To: Ira Weiny <ira.weiny@intel.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 10:15, Ira Weiny <ira.weiny@intel.com> wrote:
>
> Ira Weiny wrote:
> > Hi Linux, please pull from
>      ^^^^^
>      Linus.
>
> Apologies,

Heh. I've been called worse. And it's a fairly common typo with people
whose fingers are used to type "Linux" and do so on auto-pilot.

I have an evil twin called Kubys, which is what happens when I type my
own name and my right hand is off by one key.

So if I occasionally mis-type my own name, I can hardly complain when
others do it..

          Linus
