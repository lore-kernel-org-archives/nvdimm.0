Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499A1A268
	for <nvdimm@lists.linux.dev>; Sun, 16 Aug 2026 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786838499; cv=none; b=nmo//jhblFhg604erinn2RGfWSe2hwkKSBl6WN87VSKD/gAyI5HmizwTnqNmWGSQH4yO1nYNHZWTaMEHFrDvKCc5+47+5P0zhe4/nlSUPDqpQcZTKZ/3XnYcQlrUJ11LLGQLyrHBAQ0CaeYLLLdXIVDYcKUh60Jj7aVrAU3xbRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786838499; c=relaxed/simple;
	bh=GLv7MLH1JWc+5XrUg1Z1RvY7w8aG92a4ZA0fo54R1DI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=KUBJYTuHl5G0fswrJrZFwhR8GAsssWbishK0Ug9VUKLyagtMzX/WqUl2y/SShghLu9q57ibrfNcKXss2SoJYAWvpvDiWQ33+QvF1p2eCU3tpj1xs5zWtgcDQBnbNFfj5eBdA4EPSrsBuE1ONK9MxtCUHZy1SP/n1FbzVbcsKRi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0RvEWBz/; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="0RvEWBz/"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4472500e25fso1356464fac.1
        for <nvdimm@lists.linux.dev>; Sat, 15 Aug 2026 17:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786838496; x=1787443296; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZPPcb+6L1tSSLsANqwKI7loeM1EwHu96h0gKbDhNEvI=;
        b=0RvEWBz/x5KBddLcdXAPltYLJYgtXvYeKZ5wd+eSyHozb2IyEpzAXjN5k/nioan9wH
         MR7/k/385B5JBVCliYdeW9VSsy4EjVxAIfA6YX5DzbIXEuwCWuO5A7FkQlnORzE2o0Xc
         O/tp7salVwnLQ6Sf4gT1/lupZz5DJKQn+PrlFMVztVP4jW5vQ30zmNTM8L7yyRnss5Ik
         om3m29nePAeksM9K2Pokn2lM7TGoLbQjZpGG3za28Amf1n3TBy+8mtYSDHv3vG6XNuEw
         aZVzmMEY9lKBvc222nzf+bNORgI4kLBlpcb5hN9efqZ7BnWSbZX/ZF8lnhl3G4owPtP8
         2A8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786838496; x=1787443296;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZPPcb+6L1tSSLsANqwKI7loeM1EwHu96h0gKbDhNEvI=;
        b=oIye669/plJV3cdPV8t8ZYOmUkQGIqxeM4/BgbTsK0KpCpz+jQGBQSDUgTrz1od55D
         17xTVUxsPmzbzXt2iF1X4uERMsdudeIBsKZuG0+BnfKQUjdzzpLCMuuPLhlzTKHX1V+7
         pFtAqK8myVD7FZbVpU5a+iWYepqUg6EicpGOjhSaGcaUwJQ00GSklOvg6T26IclkLG3h
         t+zuaHIwbp/9KaRhrCE0cGtPel/iuZnj7IQl3KMWUrwN/hXBortsYD2ryuTCr9IlhsQp
         PWKuUbBf6E/Q0exvkLbmVYI2+4zDM04mP/ECJEQtRu8FRFJsCkYV2sfG59OduYtJB/v4
         27vw==
X-Forwarded-Encrypted: i=1; AHgh+RqEn+XYmviq9KLd5ZSZk7zXCiNFOmB3/cqQe5DmD+pFAtzIXT1LwwjzSXFZB/1+xYxC066cD4A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/6NkV1NVqDOxGsPMPD9zZVJYMP1o50cIRD1VQfu9y+8bpnVa4
	NBrS/JA46SR5iZdlb5bIxPdrjBkBh8bAD+WO6Z+UvRmXU07R3YCfKt5JtFYPiVH5btU=
X-Gm-Gg: AR+sD12UbxHKd2uhyxjC9Ff5jvyThAW3pihD/OZJtAdsCin4YVT4lb2uy1viRw/Px+p
	vncSteFJ4m9Ji1wfCeQokTcf2D2mwdKaGJl4xajUlj6dRAnT8dUYtmbS/axb9bvGDW1WkxTjOpm
	l6868K6fwCDDrWiPdzc9WECTuqAXINd5umTVgLojInljrIXNkDJUndBAMfupCaoq4G+m7BiFTEC
	IMmVOx6+Rl7YDIUk/feWPzgKdo8cIDibbvWpCfdiX7DsXUwh7n3qInDdN1mYF7+/noK6sc7ALeM
	A5qcGBI/KUR6NnNADwqrlJ7rsJ4uN1r+o92lCcGxm7UnqX4XWa4S8391CG+0b4hI+4ErPeOYR9d
	snurFO6aLpkpwV892ljyCNWd4tCMgkMNzy6gHLpsO5zfZj/PGiITeMYcKBr+V/a+wWJFW5ku54E
	ypz3f+Y5xslf6t+mmizvEkY0pECXHCX/5GfDlL2OauZp45a0f0rlt6UJjJs9EdmU7H0SV+Lzd6p
	SnWlwLMc05J2WA4pnMV3HYKfaCKNZKfruRV0eF33A==
X-Received: by 2002:a05:6808:23d4:b0:4a4:ddde:5207 with SMTP id 5614622812f47-4b24198f27dmr12801839b6e.8.1786838496365;
        Sat, 15 Aug 2026 17:01:36 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b24d92462dsm4347729b6e.5.2026.08.15.17.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2026 17:01:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>, 
 William Power <william.power@intel.com>, 
 Phil Cayton <phil.cayton@intel.com>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>, 
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, 
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH v5 00/16] Add dmabuf read/write via io_uring
Message-Id: <178683847578.1984298.10059277109543676478.b4-ty@b4>
Date: Sat, 15 Aug 2026 18:01:15 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Sat, 01 Aug 2026 16:46:12 +0100, Pavel Begunkov wrote:
> The patch set allows to register a dmabuf to an io_uring instance for
> a specified file and use it with io_uring read / write requests. The
> infrastructure is not tied to io_uring and there could be more users
> in the future. A similar idea was attempted some years ago by Keith [1]
> (from where I borrowed a good number of changes). Later it was brough
> back up to life by Tushar and Vishal.
> 
> [...]

Applied, thanks!

[05/16] block: move bvec init into __bio_clone
        commit: e228404b05c8293f6a1286856e49ba3e55da1933
[06/16] block: introduce bio_iov_iter_set()
        commit: 8b8755e00847da1027fe6624277e43d289e2300e

Best regards,
-- 
Jens Axboe



