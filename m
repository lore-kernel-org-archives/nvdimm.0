Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37F5175A8B
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786020743; cv=none; b=caY2wMV35DTur9v+TnYNrwZ6vn4+Fm10uTxPgpo5v4qClmwXPzCBubAmiJ+kV6rIxWpXzLOjURNRZgQGdL1xx4okFWZiOe2IptVIV4XId0SNFYXOT0r39FqHzxoBoVHyN9QtGp/+cNqb0RT+4NGfGJR+9HY3/Ka57W7p9sR3ny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786020743; c=relaxed/simple;
	bh=E+t1gFtcHDiraPPrfsroY+Aj4GCqUrp3X08deU2GKIU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i1/2B2qvLImDoEj1/IkbhLLXXHpb9ffmg9GJIX5qSulvQhQdY80Ik6EAGI2Wapp4+/4tpnsK9cd6xXRecvWb92K3FcAk0HbQXAIL8okx3sRMTX0R7iOD0xs211c0zAxQTpo/psACqBR11TgnwtweXPOFmOSu3szrnTyO6tN5LQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=DyTfwgdN; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="DyTfwgdN"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-930f618435cso138718685a.3
        for <nvdimm@lists.linux.dev>; Thu, 06 Aug 2026 05:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786020741; x=1786625541; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=DyTfwgdN+LS8PpTre9FFVAIAZUz0w6KUwa2Cn2A6z1CUSClybLXbQIYWEOEf7gHHHy
         SI0oL16CRE2jBUD1IGw2+MSXvpZ2pLHZIydEc+whd3ODs6XsQaHrUaXolGeg4zmnmC9A
         qrBaALjL4r0CS1Im2wnDg1eOxLR/zYUlgMPcKDauSSaxXAb1+nZlKbN7YmKoPA8hsqRQ
         dgY/oCsluR1XG6EUfU7234AddH4tXprwlFvZ2vfhRvKu20ooao4EV8AunP4nggh2lxz3
         eqBIVDB/lWx00btPxUaSIYYr1Z8o7bPTEhsUwriYBU8RJc8eu+69Th1tNUWzj/5MrV5y
         BpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786020741; x=1786625541;
        h=content-transfer-encoding:content-type:mime-version:date:message-id
         :subject:references:in-reply-to:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vo5x/LABgr4z5KWlM8OBLiF0UJfhkaG4qblmSgV8YMA=;
        b=F9LEUHZ61tuYwtVbrFBYkdsjqzvqsyFM82An2BvqTTR37vuHIEKU+MBSXQDp6suajW
         jKPESe5dqIv5yO5rCjHIyKOzBAe4ZBLzY96Lit87zXzclCWWZeOuoHU05X6DQ1YVjOuk
         sbKBqXytoUPUgb5kLKzCloRTxIu1zlNsnIndTxh+A8WTYnQg5TiKvOUVMy2bPmoZLtux
         eZV3jb/q2KsDdZHHC8pF3+0amVimwqVXaGwCfxeL32zTt6ZVYn/MOhDREaXiS4wQadAc
         2vA3qaetWW2Z0ugP29Cv1mC0mpkz8LNp4kfpQn4z+ZtqupgJTzUI/0OqpS1lS1OQmEF6
         gVFw==
X-Forwarded-Encrypted: i=1; AHgh+RoqJD8UaPUtrQ0yZMwKxXKOaeXRFquc5Wc9cGMYGU2E4sui57On89AevfYUABrdwjK7IMrR7m4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxztnf0ezoKGndBaDaTwHYXPDpkdWt7DHD2z1eLxkSW9uubwgEV
	MHPFz6729qecwJYgfj5FJdBbhVdGyVjH3rCvhHazyqRtUeCBDoL7ZmM3pSqW+57Pf04=
X-Gm-Gg: AR+sD10NfBIyoQZvHQtmDpf3TjIlYMhgFT8cOJ5WwCOnOouk8/f4vvoeJXmTG4s1w50
	/iAuxGXs++O7n7W3NgHZ69NpWcZf7hX0NH4cpFIHNTST1VqyFBKWHMyd8avE2G/q5R/ak3Mx1PV
	ykAhnWSYNrj5mo6mrAbsh5u7L+4VmcxRLsz6n8x4p3FPbUG6s3O/+07vNKb/7IUNuH0bdT4NHrh
	XxIW7S/58wVqbe5NZdCdsTvLO04tzF4yJFSG78Ak8rtJP6dZ3fQIRkkoy2zEO5c0q/uSvc/EIvG
	kBhIGPnez70Tgb3XIZN+68HsI1sMCIxyC6tsJk1Ea4d4K1IrXCU4mhvslxnty6gjKgQ0FFXsEdQ
	0B2ka0iA8W5g5OtaDFEuyPzsnnB89Q8CKOAjhWvXFNyVfy/bKaUu3ZdWKWcm6kmc+Y9U3cEAaXj
	2pn60UpdrF+inTputNeXqER45+uxcrddc86HA7JIS/Ct2BJELFpNSbSX7akR1Mrq4QtG4T/D21F
	h2v2hQrc23a1XZWqsyNow24oCsMeJz/5OCVoWdBLzav90s3
X-Received: by 2002:a05:620a:2311:20b0:930:84d0:fd3b with SMTP id af79cd13be357-93648fafbc7mr1150209885a.7.1786020740525;
        Thu, 06 Aug 2026 05:52:20 -0700 (PDT)
Received: from [127.0.0.1] ([2605:59ca:42bb:f910:6d9f:8dfb:ae1:441b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9365ef833edsm123847685a.3.2026.08.06.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 05:52:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Damien Le Moal <dlemoal@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>, 
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org, 
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ceph-devel@vger.kernel.org
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
Message-Id: <178602073720.2137920.17721545855702977301.b4-ty@b4>
Date: Thu, 06 Aug 2026 06:52:17 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Thu, 06 Aug 2026 13:19:27 +0100, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

Applied, thanks!

[1/1] block: rename bi_bvec_done
      commit: b539aeacf8cc5e9d8e5d94625d2d9c697a167add

Best regards,
-- 
Jens Axboe



