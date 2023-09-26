Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5374C7D
	for <nvdimm@lists.linux.dev>; Tue, 26 Sep 2023 06:44:58 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4047ef37f55so23234375e9.1
        for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 23:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695710696; x=1696315496; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vy+8WASYGTBS1mWxTg8Np7QtelHMw3rWndRVIOTdjBE=;
        b=1PJy7rhtbsLPH9llwjpFc9T2mT3H2DjcNd7+1Ej4+cm8bZM64xu7ta9JXA37RFeyIC
         kArKzSB50wOiVeoSEcSM8BDoQBNxQJr7R2E3/o17DHyQgQVPvGu5xj7otO9778n01z51
         mwdN6GdsaCJPymXj3Ikim5wOo/UxGWGJqVYuoqU57qmZ2zG8QBLSctxH1/lhQ9gf29xt
         FyRo++1HbtDaoKMeHjgHrnQrgkW3S/6dzdXXHXkgjl2fTBrxCI08F5PxTYrUv+JBgarm
         9SFEW7cz95pbThOZxpCk8UANwXJTsne/EK+/AcUmsXFxZVG3fnqfEOSIw/jeiXH3AuQl
         kkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695710696; x=1696315496;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vy+8WASYGTBS1mWxTg8Np7QtelHMw3rWndRVIOTdjBE=;
        b=IyaTcgJik7uEgfZNZu97f+o6O2bi9WgIE1msd6qvt6mqzdFtUwN1FJx7HogJJ+/MhD
         vsWmO0dfM6EdgK1z4E3TXrWf6Axub4rhDwlbKZdcEACpGtpBCBYzCbHw/s+HrJpUMt5Q
         VjiR7qKAo3xSccHIoYxnLqbQEKeVtMGe14DBRVi/gz8jJcz/xMCMw29kNqFJ2uNCJdnI
         0p37UQa936O44unJhXwON1ZYmKhvR8gJgMOyuY55veaaOAslDmBVDWtVL15ulB41Mhzp
         Y4ZJJfcytL4zmdDzyqYlfzZ/rOMKXVqPlLBCnMk0Tj+WcsUneUfBmqT/N7zassSwbNRZ
         KK2g==
X-Gm-Message-State: AOJu0YyP7ovn03vO/EQkQeiuWlWbodmIZl6UZ481S8JZFi9Jhhfgzt+h
	lCMb6fYscvr9qikGa8mjURD4JsAT1ByNebyDa3Aum6xf
X-Google-Smtp-Source: AGHT+IH9l76dfcSqxOnW7BCusuZLco1ls+8gcRWVia87WNg/ADhYwhN0gbWksHNTHTDBt6adAkwcMA==
X-Received: by 2002:a05:600c:4f50:b0:405:39bb:38a8 with SMTP id m16-20020a05600c4f5000b0040539bb38a8mr7418100wmq.2.1695710695345;
        Mon, 25 Sep 2023 23:44:55 -0700 (PDT)
Received: from [127.0.0.1] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c230800b004042dbb8925sm1127571wmo.38.2023.09.25.23.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 23:44:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, 
 NeilBrown <neilb@suse.de>, Richard Fan <richard.fan@suse.com>, 
 Vishal L Verma <vishal.l.verma@intel.com>, 
 Wols Lists <antlists@youngman.org.uk>, Xiao Ni <xni@redhat.com>
In-Reply-To: <20230811170513.2300-1-colyli@suse.de>
References: <20230811170513.2300-1-colyli@suse.de>
Subject: Re: [PATCH v7 0/6] badblocks improvement for multiple bad block
 ranges
Message-Id: <169571069404.578063.8660956212739660767.b4-ty@kernel.dk>
Date: Tue, 26 Sep 2023 00:44:54 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2


On Sat, 12 Aug 2023 01:05:06 +0800, Coly Li wrote:
> This is the v7 version of the badblocks improvement series, which makes
> badblocks APIs to handle multiple ranges in bad block table.
> 
> The change comparing to previous v6 version is the modifications
> enlightened by the code review comments from Xiao Ni,
> - Typo fixes in code comments and commit logs.
> - Tiny but useful optimzation in prev_badblocks(), front_overwrite(),
>   _badblocks_clear().
> 
> [...]

Applied, thanks!

[1/6] badblocks: add more helper structure and routines in badblocks.h
      commit: e850d9a52f4cd31521c80a7ea9718b69129af4d5
[2/6] badblocks: add helper routines for badblock ranges handling
      commit: c3c6a86e9efc5da5964260c322fe07feca6df782
[3/6] badblocks: improve badblocks_set() for multiple ranges handling
      commit: 1726c774678331b4af5e78db87e10ff5da448456
[4/6] badblocks: improve badblocks_clear() for multiple ranges handling
      commit: db448eb6862979aad2468ecf957a20ef98b82f29
[5/6] badblocks: improve badblocks_check() for multiple ranges handling
      commit: 3ea3354cb9f03e34ee3fab98f127ab8da4131eee
[6/6] badblocks: switch to the improved badblock handling code
      commit: aa511ff8218b3fb328181fbaac48aa5e9c5c6d93

Best regards,
-- 
Jens Axboe



