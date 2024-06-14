Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5722C181B83
	for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718382226; cv=none; b=bdakHPltVfUJNxFsfiSozkkTtUTAY3EjZfquFD+IxVraIZeTgD5/32dB/K38fYWLXeHQCdN1aIM04puREmZowGypR/VzYou6IRxNxxGLqUFApcmkePLi3q4dTPSnPXg3BzvgB0EaIABqoq4kMBzpzAY/lXvqJxHO974/ZBfKl/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718382226; c=relaxed/simple;
	bh=1tsL0VEqJqrKARrNEQ7BhIYxO64B/TpedUMAhGSl38Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bIc3cqOWPzlgUOuoYf8Cao2XFGNi9NC44o5ADKbHQXR5BRJ+mXniSMHf/4JZd9NySkuoAbE7FxbSnyF4efp0Br2WLcnSMN7+t+9w+JAJzynKfQ4TdF5Jb4Fama3inFbwmwRL4LKJU53LTwHP6R9vbDmJGQYBJuCnpg/7eybpfJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dp4+uUNh; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dp4+uUNh"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2c2cb6750fcso401809a91.1
        for <nvdimm@lists.linux.dev>; Fri, 14 Jun 2024 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718382225; x=1718987025; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7vaEVpmG2RwsTzAKQW5R1zRk1h3qTFZY8+hhd0hSUA=;
        b=Dp4+uUNhcKe62+pFAxPtjF6fstiBcITbSXslVRUz7GdsUerUj3+l3vtJ2IJYnI4D+I
         o5vAy/gAxn6gb8igIWu3RhJHrw84R08SGbmbtTwwwsbgorObNUPVN3EeRxes51ObI00n
         y/kwFMi/fFjTPofiQNXFBSfW/ZF67erSeW4VcBWz9YnCg6QZkSL+5l+gl4uDR5Ivjowc
         o6NTJbAXadrdOWJypvhqi7kiyHJRBBmufqtYKaND2R/i676b5KPXFp6WAFs7goikMTAQ
         RYxzWdr4NF2CytU8isaQsR7dgkeHhzMLEUtzgMiRnsUISBPdtKggiD/GCmVAMsH1G+5G
         T9Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718382225; x=1718987025;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7vaEVpmG2RwsTzAKQW5R1zRk1h3qTFZY8+hhd0hSUA=;
        b=lylmF9YBHB+wCsffT+iBcpMhel9iHGwOSYw4c4g5baNHutAC5ypDxhzpKGfbKfYQjB
         HfvF7Kn6Z0l9x0312thTaFZCI2CTUbOncTOa03uW7gCtfSVDz95TO1zAnlhp1xXWxCae
         I5EPgBPR8cCctYFH7wIFMgsfGv2DtFqh3lcD8Sbr6gPuAURkVEIfcJoMrkWNKmOqfLkd
         rog4b+XxgCf1PhdUxHPsrKtaN14VuB/QSR97kCEX+gemC5BRsqkMqMR2vQ/ZokCsO0bC
         mg7V2qv2taeImXdWVBF9r0k70lzYfLYI8uueEU+wyG/KLT0lPRRbU7Ar8A5/zNL3yAuG
         MEQw==
X-Forwarded-Encrypted: i=1; AJvYcCUW50TXY4TQCg5V7zfVipkDIMAkLQQT1H9NY1fhnEhu3vKP6Bplv1eJilBhL/7nql81JmAAszu4t4au/fuJcg4BO9Fy6XSR
X-Gm-Message-State: AOJu0YzAAQqEf0hVMUeSSpPclR2VovBcXpvtqkXn73n9Wt+GIr6VE61d
	7xpHJ9ZNhzQOAMC+M2pOEetewYbHEsE2Y9f5P0u9c6vUQ1P0wolTy0q94OI6KcY=
X-Google-Smtp-Source: AGHT+IFalaQCW4lC0HwsXT+MgtNdWkETqGGO3S2q0czZ2zVCeyt7k6ERpmMLcUdUuPUoSdg8KrcJIw==
X-Received: by 2002:a17:90a:de14:b0:2c2:f042:d96d with SMTP id 98e67ed59e1d1-2c4dc02b83fmr3292751a91.4.1718382224613;
        Fri, 14 Jun 2024 09:23:44 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4c46701absm4112038a91.40.2024.06.14.09.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 09:23:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
References: <20240613084839.1044015-1-hch@lst.de>
Subject: Re: move integrity settings to queue_limits v3
Message-Id: <171838222277.240089.6158080107617222931.b4-ty@kernel.dk>
Date: Fri, 14 Jun 2024 10:23:42 -0600
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.0-rc0


On Thu, 13 Jun 2024 10:48:10 +0200, Christoph Hellwig wrote:
> this series converts the blk-integrity settings to sit in the queue
> limits and be updated through the atomic queue limits API.
> 
> I've mostly tested this with nvme, scsi is only covered by simple
> scsi_debug based tests.
> 
> For MD I found an pre-existing error handling bug when combining PI
> capable devices with not PI capable devices.  The fix was posted here
> (and is included in the git branch below):
> 
> [...]

Applied, thanks!

[01/12] block: initialize integrity buffer to zero before writing it to media
        commit: 899ee2c3829c5ac14bfc7d3c4a5846c0b709b78f
[02/12] md/raid0: don't free conf on raid0_run failure
        commit: d11854ed05635e4a73fa61a988ffdd0978c9e202
[03/12] md/raid1: don't free conf on raid0_run failure
        commit: 799af947ed132956d6de6d77a5bc053817ccb06b
[04/12] dm-integrity: use the nop integrity profile
        commit: 63e649594ab19cc3122a2d0fc2c94b19932f0b19
[05/12] block: remove the blk_integrity_profile structure
        commit: e9f5f44ad3725335d9c559c3c22cd3726152a7b1
[06/12] block: remove the blk_flush_integrity call in blk_integrity_unregister
        commit: e8bc14d116aeac8f0f133ec8d249acf4e0658da7
[07/12] block: factor out flag_{store,show} helper for integrity
        commit: 1366251a794b149a132ef8423c8946b6e565a923
[08/12] block: use kstrtoul in flag_store
        commit: 1d59857ed2ec4d506e346859713c4325b5053da3
[09/12] block: don't require stable pages for non-PI metadata
        commit: 43c5dbe98a3953e07f4fbf89aa137b9207d52378
[10/12] block: bypass the STABLE_WRITES flag for protection information
        commit: 3c3e85ddffae93eba1a257eb6939bf5dc1e93b9e
[11/12] block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags
        commit: 9f4aa46f2a7401025d8561495cf8740f773310fc
[12/12] block: move integrity information into queue_limits
        commit: c6e56cf6b2e79a463af21286ba951714ed20828c

Best regards,
-- 
Jens Axboe



