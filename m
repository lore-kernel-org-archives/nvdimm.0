Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8658135965
	for <nvdimm@lists.linux.dev>; Fri,  5 Dec 2025 07:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920780; cv=none; b=Acc88ourxRW/gPAFw3cEK2HT33n4jPtQVtMYKwQ+2KRLiWdZSHJEDq+qzTtfDWo3nQolDMKCadwebXbJ29dI1UfmlepHEeBMUUshVZQ7I1prbEPVom836lWPLW/KCB7/CEOiQIdZLvgNDQFS9qYe/crMDkybIdkJeSfLH2tVNVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920780; c=relaxed/simple;
	bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzK16FO7d7bfy56Kuo78gH7SkZAx7eVNsUQoPG/4bWN4YHoUmXcT+fee4D9rwk6dB3xCngTCUmPTREo7aCfwD+KSrtOnniX6N5ACPUvINelCCBx+A5HTXooX8j5NGVkypni9uDDwHK0I22L8bTY2MtslusfN7KgjZRctx350j+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCgeGtSh; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCgeGtSh"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee4c64190cso14862681cf.0
        for <nvdimm@lists.linux.dev>; Thu, 04 Dec 2025 23:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764920762; x=1765525562; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=QCgeGtShn5sQIp+qXD9lLofuqOAz51ym4+jn2ZTqQjC1DsA0OFxxo688aXO2ns0eBc
         yLyjYx17zfKWJxL6qzT+4ZqfSsAaVz4Fa9h76MDikj7QWXiKyPgT7aFkHKpJMls7/5WM
         cuh29v3oRNRFXt7A0540rfSjx0xJ8Sd4/jZXf5WmGrFEFnfWO+UNFlqpJz+1dEFLsJlR
         g+jJL8pdyxyzRghWbcF4CdU/+1Yp4eLSHpVmvjfUwRZmSmXi5BMRYSx75r8wR0SqCs8U
         Z6LJFHRjzy9UHiWZLuDildxw20AkRRErYkmDjWykIJ9tHBDPnxJHveTW+T3meqNPujAL
         MG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764920762; x=1765525562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HXtSwPAI2lC/ImQNYqZw2xOGmU6O3GtB13oXE7vjpQ4=;
        b=fZeWMaB2XQGeVd8EEcwcbDTc9LAnmpvfbIcoFSIcwHZC/jCdCfV1WJTvn+rmmwaPLw
         gVXI0+O+BUlitE+CQQKj2X++xajGtLqDKNJStjLhkP0G5jVdYdN+JOyZHUWvfX1hbSZE
         IwypTHlcC5ymNtiOPVG6NaMBquXJ5NLz8g+9dJIBgDjG5ojSK+h/7eHoNY5umpM0Tj5W
         igDr58zaD+ZlWXkOa8QszpwbMplVSMnmGfnmcVbAe56Y/VmlK73fv/YvZ3mRUvfvmSRz
         LWx3AQ0Nb5sTOdODjNK6Ysap1nB9nkDlgOtA41R2XVdEDD8ja9idz17/c/OwpXIJzB+P
         a+Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWsQp8tR3JHf7ezEkCQOb6XaCbhyDH5KfYhZpXIrh9Na0ydR4bfDnUwTzozGiueR+ZREsKgwvM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxm8DgkUFp5gPUtwzH+c6yLK3ZS7nHJHf6MEQnFQpY7LUJbgepu
	Q/mna01+EI0C+RPoOyCOdEVn76cqSUss3Pq2L9Klgb3aifl2+aCwF7MxpVZrNviGvIx6zOWfQsP
	/RHKqIJWlV9CLzlcnWOoit84pWFnueYU=
X-Gm-Gg: ASbGncuCB4MH3vCOtncSVn9f9JR/a4xYt5ym1pLO5F3StV7wGObxCsExrkMGfiDlnMU
	KJ/8L5ZNq1NBX+5xUC4yIpmrjOnHOa/FDMC+5hFJOFMZ1+ft0U8RC8aRTo1MZmxR2SX4lOt2GmV
	jq8r+qGWNO509U40MfZg4HG7WJs5DuZlCkc5ogL0dlTtY0dMcqzt63xsR+df1qI6bkI6H/teQS0
	64AGYFxuODx+PrZ4FoH7H/B4btn+TqfLlXid+3a2jXaz12s8hju+EuF/HE0du942ckuVWSvFy/Y
	9EHWMw==
X-Google-Smtp-Source: AGHT+IGno4YCEk34HtoQAUN6GrFl01k867Kp7tydcNcb8xmuE9aFUTESOSk0G3T3M/y8W6zfCnRmuyMISYmpdGJqEvo=
X-Received: by 2002:a05:622a:5c6:b0:4ed:2164:5018 with SMTP id
 d75a77b69052e-4f01770bf40mr116570781cf.80.1764920762038; Thu, 04 Dec 2025
 23:46:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-7-zhangshida@kylinos.cn> <CANubcdUtncH7OxYg0+4ax0v9OmbuV337AM5DQHOpsBVa-A1cbA@mail.gmail.com>
 <CAHc6FU5DAhrRKyYjuZ+qF84rCsUDiPo3iPoZ67NvN-pbunJH4A@mail.gmail.com> <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
In-Reply-To: <CAHc6FU57xqs1CTSOd-oho_m52aCTorRVJQKKyVAGJ=rbfh5VxQ@mail.gmail.com>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 5 Dec 2025 15:45:25 +0800
X-Gm-Features: AWmQ_bnqjBxuauDVJJL96EAzZiNCKi7bmfbcq5aA841m6f5U8UUuamAPefRv5L8
Message-ID: <CANubcdVuRNfygyGwnXQpsb2GsHy4=yrzcLC06paUbAMS60+qyA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, ming.lei@redhat.com, 
	Gao Xiang <hsiangkao@linux.alibaba.com>, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Andreas Gruenbacher <agruenba@redhat.com> =E4=BA=8E2025=E5=B9=B412=E6=9C=88=
4=E6=97=A5=E5=91=A8=E5=9B=9B 17:37=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Dec 1, 2025 at 11:31=E2=80=AFAM Andreas Gruenbacher <agruenba@red=
hat.com> wrote:
> > On Sat, Nov 29, 2025 at 3:48=E2=80=AFAM Stephen Zhang <starzhangzsd@gma=
il.com> wrote:
> > > This one should also be dropped because the 'prev' and 'new' are in
> > > the wrong order.
> >
> > Ouch. Thanks for pointing this out.
>
> Linus has merged the fix for this bug now, so this patch can be
> updated / re-added.
>

Thank you for the update. I'm not clear on what specifically has been
merged or how to verify it.
Could you please clarify which fix was merged, and if I should now
resubmit the cleanup patches?

Thanks,
Shida

> Thanks,
> Andreas
>
