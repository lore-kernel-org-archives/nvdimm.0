Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4113D564B
	for <nvdimm@lists.linux.dev>; Mon,  9 Mar 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773067960; cv=none; b=rv9cWGXcl/NssZ94CStZ3Kl7fK0OAq70LZeqi5MSXOMQEwLcMxPD60YG3KOrHzO/of4E9UKcQqhPIF4IaootrlzPvnRgHDmLjG3Rm+FyMOmN9HRatNnOGf7iQnYGnwYhbGZV93unr95l2kGHEXlBLbJGrNiXGgr9Ka9ejtNVLc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773067960; c=relaxed/simple;
	bh=njW+dpSk10SuO1AcbH5tukD81vdWuhIyIPazhF2qfvk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=V20fPD8ZW6PUZ6EFU+dQS9DHr5wLr9CtyWk95F55htSB72xbBMWBKi/i/BxrBKFxYOA+ntA78YyUYFkYjmpijXhuurgRfYXujchUqBjku4HZjHDgWbY2g9jdpmSisqpFyI8Xw81h1EVNOMApvNLxpmLPr5y9Pm7qTSPpAJg0deY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rCfPz1ys; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rCfPz1ys"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-899fb030812so117326466d6.2
        for <nvdimm@lists.linux.dev>; Mon, 09 Mar 2026 07:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773067958; x=1773672758; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M362llShL/olgkvofrhnarltpI/bzDs+ZoXPZquhvi8=;
        b=rCfPz1ysbjFoYMFoxa6XjrQS+GUoa/mYJNm4tsh+hCMnXn1haGC8U+bJC/VjdNeyI0
         h0HoAurJY+aocgenR0tqq9bhnYCWmXqDemsoRB7B8gLeTOsc8/rJAvoGBHJK0LiSl6N4
         91Inf+x69DKpzA+sgHV3N/wP543KG8fQOxg7RnhCIDpaOYnK/JtHBBFkiWyVfuEsfWBK
         i0tAP+ov1uuVPpcDFGbhIsDJiYkq9ttRXJ1ZxqNAEuE7EhushQrs0weVU32VpT1P4JdL
         wTZwpcvdNN8z3RiT1tLih0llDuA1wmZlI9dbX6NQyY/r0nXARDVPEx02ZbHSxaxi393M
         r0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773067958; x=1773672758;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M362llShL/olgkvofrhnarltpI/bzDs+ZoXPZquhvi8=;
        b=Blc/QGDJ2Cq8aSRHLdS5tjpxEWZGGnXJ5X0BTHkwLUm0JDQFphavL+zmKGnHfWCM4k
         PZ96sU//YrDCIiSNBdp6MdXw31WA/QjeEgZY6+frkjwMxHr6+SJ7LLtY6Kyd5/MS5fb+
         FhTEtdWTbyT1eSBraanWWbdp4OI7fzhrJ+Q4uPc0cXUv6ufsqeClhfBh2mFmXBWVZ22E
         rQBZHvXaLk0zoyiHxNLuBqY+LLVg+BK4M5+l3xtAaPvmuF63DNGknOdUKNhMb65tspyP
         rpMZr6caKdNGyKvEh4rcfVUL8AWO21a1IzDTIIV73oHCDHXt3v88VTy5DDZOX9gGNIkg
         p9kw==
X-Forwarded-Encrypted: i=1; AJvYcCUZMWKR8k44nyXo/dsbEotb1E+W6rN6qV5XC3vSJa+TGYJrKGZ7QDSNr4/wnKuvhHQ3CPpS0+I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyuih62lvYafPR5ee0PqMZsrabvPdPtyPTE01Ue32a0bt4W0MAp
	4eFV5mqrNfUygtPSD0CLAppq3cfTorpwjnQ6TToS73UZ55Ju4h1igvzDIfybQ2DTPHE=
X-Gm-Gg: ATEYQzwBg5Mp38UdVGB95WzTUjP2dypvGLyeh9acbyKCCckbvKygE8QNAxvdQUlCRmT
	6BrGvaPF/wLd8hbuy/fiiuNo/uLuZIp7PItix0hpPFXt3CxNQcxQJMCpEfZGurO7WWw5CqGcA2V
	Z3zpYiXx5lwvF/c6xWtIPf0ReFNngYMGVghDtLHcZGfOOiQknUwqrHX3utSCHseAQXedZ4EekLS
	LOvdloy9mgIUuG9SPf6xen7DFYbVCyePCrza11jE+qVXAr/MJdi79jxFTP/VuuG0rt9dFumIgGz
	jDvbVqORbrG6zlfWik9opcLvpXoDe095WxpzkF526eWBvJBPGSugFfjLlX0x4V3taoPnJqMMqLI
	1SkpGvG4/xsW36QuMJfRJh+2TnQQWUZTUgSIQKvbaBplDKU5qsiMoP2bZS+agHb6Mrgz8tCFCpf
	N3ZY2H6FT572r1nGexQ7Ki+A83wkBNBFXCJUJY3rNX1fbvbiA=
X-Received: by 2002:ac8:5fd6:0:b0:4f4:de66:5901 with SMTP id d75a77b69052e-508f46c9079mr149938371cf.5.1773067957796;
        Mon, 09 Mar 2026 07:52:37 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.133.212])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-508f651440dsm65793431cf.5.2026.03.09.07.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:52:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Anuj Gupta <anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 ntfs3@lists.linux.dev, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260223132021.292832-1-hch@lst.de>
References: <20260223132021.292832-1-hch@lst.de>
Subject: Re: (subset) support file system generated / verified integrity
 information v4
Message-Id: <177306794392.32482.9164747646721806111.b4-ty@kernel.dk>
Date: Mon, 09 Mar 2026 08:52:23 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 23 Feb 2026 05:20:00 -0800, Christoph Hellwig wrote:
> this series adds support to generate and verify integrity information
> (aka T10 PI) in the file system, instead of the automatic below the
> covers support that is currently used.
> 
> There two reasons for this:
> 
>   a) to increase the protection enveloped.  Right now this is just a
>      minor step from the bottom of the block layer to the file system,
>      but it is required to support io_uring integrity data passthrough in
>      the file system similar to the currently existing support for block
>      devices, which will follow next.  It also allows the file system to
>      directly see the integrity error and act upon in, e.g. when using
>      RAID either integrated (as in btrfs) or by supporting reading
>      redundant copies through the block layer.
>   b) to make the PI processing more efficient.  This is primarily a
>      concern for reads, where the block layer auto PI has to schedule a
>      work item for each bio, and the file system them has to do it again
>      for bounce buffering.  Additionally the current iomap post-I/O
>      workqueue handling is a lot more efficient by supporting merging and
>      avoiding workqueue scheduling storms.
> 
> [...]

Applied, thanks!

[01/16] block: factor out a bio_integrity_action helper
        commit: 7ea25eaad5ae3a6c837a3df9bdb822194f002565
[02/16] block: factor out a bio_integrity_setup_default helper
        commit: a936655697cd8d1bab2fd5189e2c33dd6356a266
[03/16] block: add a bdev_has_integrity_csum helper
        commit: 7afe93946dff63aa57c6db81f5eb43ac8233364e
[04/16] block: prepare generation / verification helpers for fs usage
        commit: 3f00626832a9f85fc5a04b25898157a6d43cb236
[05/16] block: make max_integrity_io_size public
        commit: 8c56ef10150ed7650cf4105539242c94c156148c
[06/16] block: add fs_bio_integrity helpers
        commit: 0bde8a12b5540572a7fd6d2867bee6de15e4f289
[07/16] block: pass a maxlen argument to bio_iov_iter_bounce
        commit: a9aa6045abde87b94168c3ba034b953417e27272

Best regards,
-- 
Jens Axboe



