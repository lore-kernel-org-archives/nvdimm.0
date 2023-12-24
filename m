Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A9657
	for <nvdimm@lists.linux.dev>; Sun, 24 Dec 2023 01:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P91nhfaf"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-28ba5cca7fdso482574a91.0
        for <nvdimm@lists.linux.dev>; Sat, 23 Dec 2023 17:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703381908; x=1703986708; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4PCt0BUJxtEtgmlWQFvEAznyF7V0hSV/duRlgdufCo=;
        b=P91nhfafFYgQppZbgpKli8X6/okzDJF60pOwVARENvluHuzjnxqTBNL65xNUGQvDsT
         +0qyYDPwNjb1U5/IienME/kDDyIMq/wSjzopqirY9FYofyy4n4Y2tqLWGIT3oGi/TtIC
         ZGyZNPIck4SUtUwfJPAE/IfUu5FHTumpmtd8PiUlSOX+jWiBLnZ3BJfNl+1HVowyAs8M
         ZHIBk1Er4VEzzoiQhcjUPGby0YT6w+cZ/8M3AUvNTY5b9FW/QvGNjAME5VI/K7ao5qMu
         ybaApSfekd1i9gCTyPfhCkte4gltPgxdXkpNd8xXNRY4Ijap69W8mcqEUtS7kQryOwmh
         uMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703381908; x=1703986708;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4PCt0BUJxtEtgmlWQFvEAznyF7V0hSV/duRlgdufCo=;
        b=tDRTcutEnP2b0UrBtWAFv1gRyIVaUMwfg3fz8FXoZJWtmoLWtG85DwX8wt5Rv36X+X
         ApmH4bNzvSf7twpAMB6W+xi61U4ujgZaInPU8AdsZKU+fXHuf25V4KVfeUB8Bm91i+30
         ICsQsAqasOBgYlBgJYY+JQrcEtIlKjTYe4gsvn8R8bAXiS0A2oXDoRIAmfvJhRWYf0/M
         J00C3WDuZulWzZAdr/peMdLHTF94BmNi3u7/CyRSRVCzQxfuomyQIUyNIj5DNgNCd6EX
         MuR5ncAaLCLJFywkJnJZuoxT2IIO4ZvHC353bfshBAGOvg6dO0oYjhLlrubL5WfTD9X7
         PLQg==
X-Gm-Message-State: AOJu0YwH44i+QlCT9zSWDApr427ija8lU51WNPtEAA3ykpu+yvWER09H
	k6Z8PeUpxc9yoqkxfm7U4MW6WzyoMX+OUQ==
X-Google-Smtp-Source: AGHT+IGBrvgr5pgQQNrjr2yKzG+YadtnLw/TgftQcaHqh3uqbZcrmAcVRJmdd3rzGx3sugWBSLqC2w==
X-Received: by 2002:a05:6a00:1824:b0:6d8:f420:da04 with SMTP id y36-20020a056a00182400b006d8f420da04mr7534114pfa.0.1703381908143;
        Sat, 23 Dec 2023 17:38:28 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id f30-20020aa79d9e000000b006d9ae6fe867sm692086pfq.110.2023.12.23.17.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 17:38:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Coly Li <colyli@suse.de>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Geliang Tang <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>, 
 NeilBrown <neilb@suse.de>, Vishal L Verma <vishal.l.verma@intel.com>, 
 Xiao Ni <xni@redhat.com>
In-Reply-To: <20231224002820.20234-1-colyli@suse.de>
References: <20231224002820.20234-1-colyli@suse.de>
Subject: Re: [PATCH] badblocks: avoid checking invalid range in
 badblocks_check()
Message-Id: <170338190635.1172668.12689831383588478650.b4-ty@kernel.dk>
Date: Sat, 23 Dec 2023 18:38:26 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-7edf1


On Sun, 24 Dec 2023 08:28:20 +0800, Coly Li wrote:
> If prev_badblocks() returns '-1', it means no valid badblocks record
> before the checking range. It doesn't make sense to check whether
> the input checking range is overlapped with the non-existed invalid
> front range.
> 
> This patch checkes whether 'prev >= 0' is true before calling
> overlap_front(), to void such invalid operations.
> 
> [...]

Applied, thanks!

[1/1] badblocks: avoid checking invalid range in badblocks_check()
      commit: 146e843f6b09271233c021b1677e561b7dc16303

Best regards,
-- 
Jens Axboe



