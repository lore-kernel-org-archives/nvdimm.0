Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2132C87
	for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 22:32:13 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id 127so7364777pfu.1
        for <nvdimm@lists.linux.dev>; Thu, 28 Oct 2021 15:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NX4oKzsdtiCBcjkv0ooeUdxijzvTNPbKKtZXJyEL5SI=;
        b=iDJla/Vp669Z4iMSGfge1FP4VjHEtFHttByF+7j6E+kHIIIqmXbCf92jD4wj0SNwif
         37YAod19jRKiDYARSC5kzBEVrfXiCdOxKPUrrUGofMS1PDsHCBc9Yfotjpyu3A9DMt+S
         f3mJKPeO1QRqTEQ873OW4ZBZEW6KwGTAl6y7IGbsHSeaXEBiBIdwNZKJYk62/azTDuyh
         Gi1cTysDt4kK4JAb3nXYzveN+gD5DkP3X+KW+kY2YXo6+tB00eqiDwp9yhEtZXhqIDrL
         vY/nGOHxEGEaMj9XvFKYudgQKLPWheRezbs79qx7Ydpm+bMUZRuQaMq3m11sqi6v1CIT
         TqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NX4oKzsdtiCBcjkv0ooeUdxijzvTNPbKKtZXJyEL5SI=;
        b=Q/Kt0IjeHjBgP7ILDza1Is7WihXJSCD8jMSFrO4GlI/dqK7oqyDpFDBzRK9xtaUpG3
         x2FhHEwLKk/HR+CVFMuntItjJfEnMxGUpXnSGA0+PMm32RBSDZ4XVr8Jqcubt0z/t+oy
         CafENDIC1rpHmL61p5zHsgpl7Tei4Rsfz6GkjMxWeO8+Yvl57D/E/CEEY0y1J+FnQ5Xn
         DsWBuJBP65mG/btwA9YgYV40temqDjhaAfxN4EGgoZSe4BKj3XKPJZVDkmcbIK86DYME
         23x+d/PfNBxhmj3iufk1RPZvvkanqUDfRBVYOIS1BiQ0YcgJXRwgCXKXfbB4BJeD3WVc
         eC6g==
X-Gm-Message-State: AOAM533osiIfuMfDUZbH/m7ZHigW3fy+G/7hIyC8oRHrBK1vtEul3qPM
	adF+mQQvOYKK6938PVdgTFdZyBjxfm1kzVjVTSQEzL/wyzEBJQ==
X-Google-Smtp-Source: ABdhPJzwnFQBq6X59wQZ609TtUucj3VzBMCa8RdpPTm4uLLJzsotg3u+U5r/sTtyBpCTPLxAO0BtmWOhsa/GcXHTN+A=
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr5242961pgc.356.1635460332811;
 Thu, 28 Oct 2021 15:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 28 Oct 2021 15:32:00 -0700
Message-ID: <CAPcyv4igx1BJpp+Z3jvjTxahPYp8TBLSZY=jU7vsBWF34XHDOA@mail.gmail.com>
Subject: [GIT PULL] nvdimm fixes v5.15-rc8
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.15-rc8

...to receive a regression fix for v5.15-rc8. It has been in -next for
a few days now with no reported issues. Yi sent his tested-by, but I
had already committed the branch, so here it is for the merge message.

Tested-by: Yi Zhang <yi.zhang@redhat.com>

---

The following changes since commit 3906fe9bb7f1a2c8667ae54e967dc8690824f4ea:

  Linux 5.15-rc7 (2021-10-25 11:30:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.15-rc8

for you to fetch changes up to 3dd60fb9d95db9c78fec86ba4df20852a7b974ba:

  nvdimm/pmem: stop using q_usage_count as external pgmap refcount
(2021-10-25 16:12:32 -0700)

----------------------------------------------------------------
libnvdimm fixes for v5.15-rc8

- Fix a regression introduced in v5.15-rc6 that caused nvdimm namespace
  shutdown to hang due to reworks in the block layer q_usage_count.

----------------------------------------------------------------
Christoph Hellwig (1):
      nvdimm/pmem: stop using q_usage_count as external pgmap refcount

 drivers/nvdimm/pmem.c | 33 ++-------------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)
