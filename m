Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A3F1714A1
	for <nvdimm@lists.linux.dev>; Thu,  6 Mar 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741273513; cv=none; b=RYvJm+6AWHLFvLlGszYmIZPSoQ6+H/AL2JJqdMOy8fIO6W6iZNqR4OK88lPYiVGXQwMq5TcjSzxpUt45IjBoYquQlPv6y3uaGqoLc5UaR/VSOTY9ooXiYhSOIZsSI1Xre/qHAboNZWBx+jHhE5Y9ZEL8Mlwtbrv08+yq5+i6kOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741273513; c=relaxed/simple;
	bh=TK7VGJ9wAuiaUqk6rSlvDmS9VC/uE/WDIOEUN3K8tI0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dz6aTuKf1CNpdRezYf7VIh0AiD8e7n08MnckY3CH3YGajzv37sRUxrogCk1FzCk8nnyQl8Iw1x2nDevUWmsLw5Urdy4JlKEDuuIxR0LHIuN8GhCWvCvLEk19q4BP4nt8fdXoGxKCC7wLfW+MYT7hP9Hny3mUGrI4+pT+qDWXfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Uz4vGPlU; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Uz4vGPlU"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-85ada0cf40fso19929239f.2
        for <nvdimm@lists.linux.dev>; Thu, 06 Mar 2025 07:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741273511; x=1741878311; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mxhfe662mFKXoNMPrYea9QmFeK+eqDDltOasYkoZcA=;
        b=Uz4vGPlUD/XT/+uityUgWH5wqlVzaj3W15PMm3cRbI66HlOpf15uaQ5TAqunN/uxXz
         l0wMp7pr4P/1CXBWlOg6UIhmA0rXTLFBsP6NVOcJMooih0Yf8Ku8K6Sj/lyX9rcApPUY
         McE6SiVjI+MGXEtd4TgcEjCFm2dw30ZQPxB5YN35KDADfTAvHkK1HBsLLAyF+M1Amcgn
         GMbsRdHxUqYPuYBXfo2Ds+DCDTL9ZhMDdCUX/WyS0BZ3w7CNKmM+OKv3veT/Z3vTJtdb
         Nudbh54bIaisA6yexUY1T3850FVkQnciqw3JAn8KvrTU5skddYn8maZ9cMeTveLVAF52
         TIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741273511; x=1741878311;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mxhfe662mFKXoNMPrYea9QmFeK+eqDDltOasYkoZcA=;
        b=OqFYj/lHc/peN46Nh4tanAuIAbrYjLdiKiKI4Gi0W12eI/VdYVedqVfTl9tMpYonWg
         3aEod1fxdWLVr+FeYJu8YkKlO1H7dtruF02YgD0RKrlLWgPTowJAA46qc9NL9w253fSC
         V2OXdXppvMeL1aDjQIVeuNIJpxcD/bv17PwpAdtOLTFvR52VUn16ft1eUR8X1IuJzx4L
         5MADHpuiJtZ5nUvDwyxhOlEXHtVjfLpw2SJTlqBZcRdsNFXGZzXSrlNpZdVShwAF6d+c
         GGV2iLp1+Wm4knIT27epip3ujm/C7yZUAl/30QV4p3RzOPZ3Sv1igjMpPWs97lPdfqoH
         nmlA==
X-Forwarded-Encrypted: i=1; AJvYcCXvF1dGdIQg/sPEJ32vtbwHey5a/J7hUUtulsxsyB6M56cYKp0T1eOvx0O6+hEOqAKLkPjnhdw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMj4hYXKCWOcBE7ZPy3E61eoEoRZiEiZW3AbXyDs8RbbHAoFN8
	aQ3zqPUeBjfL2G+7xK8oAtVq408gIOpAeBMDA+a9gAuVjw3d4CQ192uOJWtoxW0=
X-Gm-Gg: ASbGncv7A4jgII0ZnW9IVtS9xunnB83X4vXddag0eztxvVgdJWd/5Qs+FDMpAZ9YCkK
	akAQee4PBSq/PGF72eaVu8+seT+W7ex1MRk7zqdpbSxZn1QLWZtZLn9bjousft3/z3+/B20b5rv
	Uj6kgKO5BENGIU6qmFLC2cL0ovtd2GcZ/j8/3ryfR01et3U3OeSoGmct9/cuCTiBqefOWTSs+TW
	cQ3JcRw9Nxg2gy+DdO2L+ezNsObZbKdZR1sv6V/AjqpmsWlGA2MZPdYybpLpFAuji+Hvi0UnE/m
	myUMDhjK3gvylpDAq2DRpcfy39y3zGHh57Qx
X-Google-Smtp-Source: AGHT+IEqAuXd7afnd0Dt1HKumrunpDNZSQhc5PKX/Hjsq7JDKDGmQ5oF9rxSxlYeY9IOKZII3LXW2Q==
X-Received: by 2002:a05:6602:36c5:b0:85a:f63f:cf06 with SMTP id ca18e2360f4ac-85affb58d03mr901346839f.11.1741273510171;
        Thu, 06 Mar 2025 07:05:10 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b11986819sm29718039f.6.2025.03.06.07.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 07:05:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: song@kernel.org, yukuai3@huawei.com, dan.j.williams@intel.com, 
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
 dlemoal@kernel.org, kch@nvidia.com, yanjun.zhu@linux.dev, hare@suse.de, 
 zhengqixing@huawei.com, colyli@kernel.org, geliang@kernel.org, 
 xni@redhat.com, Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com, 
 yangerkun@huawei.com
In-Reply-To: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
Subject: Re: [PATCH V2 00/12] badblocks: bugfix and cleanup for badblocks
Message-Id: <174127350864.65950.963243812292712820.b4-ty@kernel.dk>
Date: Thu, 06 Mar 2025 08:05:08 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 27 Feb 2025 15:54:55 +0800, Zheng Qixing wrote:
> during RAID feature implementation testing, we found several bugs
> in badblocks.
> 
> This series contains bugfixes and cleanups for MD RAID badblocks
> handling code.
> 
> V2:
>         - patch 4: add a description of the issue
>         - patch 5: add comment of parital setting
>         - patch 6: add fix tag
>         - patch 10: two code style modifications
>         - patch 11: keep original functionality of rdev_clear_badblocks(),
>           functionality was incorrectly modified in V1.
> 	- patch 1-10 and patch 12 are reviewed by Yu Kuai
> 	  <yukuai3@huawei.com>
> 	- patch 1, 3, 5, 6, 8, 9, 10, 12 are acked by Coly Li
> 	  <colyli@kernel.org>
> 
> [...]

Applied, thanks!

[01/12] badblocks: Fix error shitf ops
        commit: 7d83c5d73c1a3c7b71ba70d0ad2ae66e7a0e7ace
[02/12] badblocks: factor out a helper try_adjacent_combine
        commit: 270b68fee9688428e0a98d4a2c3e6d4c434a84ba
[03/12] badblocks: attempt to merge adjacent badblocks during ack_all_badblocks
        commit: 32e9ad4d11f69949ff331e35a417871ee0d31d99
[04/12] badblocks: return error directly when setting badblocks exceeds 512
        commit: 28243dcd1f49cc8be398a1396d16a45527882ce5
[05/12] badblocks: return error if any badblock set fails
        commit: 7f500f0a59b1d7345a05ec4ae703babf34b7e470
[06/12] badblocks: fix the using of MAX_BADBLOCKS
        commit: 37446680dfbfbba7cbedd680047182f70a0b857b
[07/12] badblocks: try can_merge_front before overlap_front
        commit: 3a23d05f9c1abf8238fe48167ab5574062d1606e
[08/12] badblocks: fix merge issue when new badblocks align with pre+1
        commit: 9ec65dec634a752ab0a1203510ee190356e4cf1a
[09/12] badblocks: fix missing bad blocks on retry in _badblocks_check()
        commit: 5236f041fa6c81c71eabad44897e54a0d6d5bbf6
[10/12] badblocks: return boolean from badblocks_set() and badblocks_clear()
        commit: c8775aefba959cdfbaa25408a84d3dd15bbeb991
[11/12] md: improve return types of badblocks handling functions
        commit: 7e5102dd99f3ad1f981671ad5b4f24ac48c568ad
[12/12] badblocks: use sector_t instead of int to avoid truncation of badblocks length
        commit: d301f164c3fbff611bd71f57dfa553b9219f0f5e

Best regards,
-- 
Jens Axboe



