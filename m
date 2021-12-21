Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE22C82
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 04:13:04 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id f125so11229211pgc.0
        for <nvdimm@lists.linux.dev>; Mon, 20 Dec 2021 20:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKrfGiJLmo4BFy866IR6WichX7+97mPLbqHHnF9C+U0=;
        b=tXWtVTEdB1vLnxZFgNqvM6eVRbmeCYP+Q1isSNun2AINF3tkOQoPbc5mwZLgYaXm8Y
         k/KmzI1TmIAgdPYmIJR4UPLSck0t7tZqG+RpmSPUIbhqyf1ZAsG1lJWP7Q7fOQzn420V
         e0vfRHW//ZFG8A3MiMAUoxPa8wKqWM2d7MDo6ELULobAAmWxxsgSx1U1Rk9HLKh/kPcq
         FePQuH9EY0XHYGYMwMDciLuloL1ytQNqKV85cypG7RAd5k2pI4BV9C1Cwg+lLO08NMx6
         kaK9Ce2pFU8YyNtdVlJR9iBYno7Fn9unNDzVsMxmvLiDLDohH37mHsJGRfe0qh9pEupD
         5n1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKrfGiJLmo4BFy866IR6WichX7+97mPLbqHHnF9C+U0=;
        b=36jJZJs+ydWDATeG/GZAoRaaYGLLHJ2CPJ79a/LQcI4dPJ4HsSNIOyYiweShqNsRlP
         05r9S1JyERKCMI5cAmC+G/CfbBoLeIyNB11nUBbPklrCsyfm6N0ecG1h332bM7dwhe2w
         zcyBsF3v5P0MlZDuSiH/c0KOH90CXIDoVBJfIaKePRQ/4lBsEuljd9yM6Mi3Win6v03n
         KX8nulTAKqtWfaS6ASvkCCp2BgK1lHOlz35J1qnJenBOnUpPv7Icu5Epon6vVemNMQ/B
         S5w4N5CpBR3nQ5nteZ4esTJh4zPw8+ELg/w2/bq5fbEul/iSR5Pdt0ZdTaKYkBgTzM77
         vNaA==
X-Gm-Message-State: AOAM53232r+JzF6T4usDmeQ9EcW5+Nld72ycnHK2RbIba1BkpbuFVq9F
	XvFdu2i6jz8yCvCZBgMVj+FYwqR1i2qRBvbHoKRC8Q==
X-Google-Smtp-Source: ABdhPJxofkcdUiHzaUKIy+2kqqXjOLT/9cQ+sV/siMZg3Y8bfjR1kNm3ScUeEhTDEm/js2o4xLPKaPtXhCOBvTQOClU=
X-Received: by 2002:a63:824a:: with SMTP id w71mr1300001pgd.74.1640059983994;
 Mon, 20 Dec 2021 20:13:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211208091203.2927754-1-hch@lst.de> <YcD/WjYXg9LKydhY@casper.infradead.org>
In-Reply-To: <YcD/WjYXg9LKydhY@casper.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Dec 2021 20:12:53 -0800
Message-ID: <CAPcyv4gfGBSWf=+WxkSPbca1BH=OeTmFoSjUBKJV-aos=YwWMA@mail.gmail.com>
Subject: Re: [PATCH] iomap: turn the byte variable in iomap_zero_iter into a ssize_t
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-xfs <linux-xfs@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 20, 2021 at 2:10 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Dan, why is this erroneous commit still in your tree?
> iomap_write_end() cannot return an errno; if an error occurs, it
> returns zero.  The code in iomap_zero_iter() should be:
>
>                 bytes = iomap_write_end(iter, pos, bytes, bytes, page);
>                 if (WARN_ON_ONCE(bytes == 0))
>                         return -EIO;

Care to send a fixup? I'm away from my key at present, but can get it
pushed out later this week.
