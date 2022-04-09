Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99222F5B
	for <nvdimm@lists.linux.dev>; Sat,  9 Apr 2022 23:47:07 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id f3so11550679pfe.2
        for <nvdimm@lists.linux.dev>; Sat, 09 Apr 2022 16:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MUbqjqroWUSuaCOjxZ4xcA3Ff9DzHo03eSpcfQTH7xs=;
        b=jd+dwSeiQNDcvKJh2B6IY6Tk/lOz864fH4P0sxe5iJIo67C/PpEHyeb4rvZ1TYblNz
         oyVI9ZXbEiaATFabXvynDPUOr5MarzmNgfogKr/e2hzv50KKXj+3Zi3UFjT0R+iPqZGR
         vFShBM7h6Sjyl2B9z5uow5OBCl5b63L8Dq1WSBzr6iZ7uwyOHjFPhYvrdICCv1j2135j
         f6JKaxvY62B8b/UwN+rOqJm8CgT84K6Q7bg9SDUOwc3OXMJgfm/QvM8iPOXK5Ul/8g/M
         91xmV6Gvnxe4zKxSdtxJ229slvTSjap6EucN0yzNBBH6B/ouVnl9b3AlE4G/Yn1/uD+p
         Fwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MUbqjqroWUSuaCOjxZ4xcA3Ff9DzHo03eSpcfQTH7xs=;
        b=mcVn60fX4n7TF2w/R8gitvsqmLtpAOFGd8zdj9c+HuKbAwaTz3ZzbWFoKCQEsct2AA
         5GTqSMvChbu1DG0u+RfGeH1pxrd9YQun4U3ZMTDPciCSdB6+x8OWfcqdK7TI/V4mePct
         KRiZaCmZxPy1S8lQpgoR2MC1oeSXw7B+zCd9/zW8jc56eCgnmhZzfbIirZXoQ1WYOcOg
         uU40eRw7wZl4kxH0LrByW2dOZUzxsadnFa2yPs10KBOCIKraSCAWYnNFu5cgsJsRvzBP
         LUqHTxi/+MlJS9k2dEex08BPQYLyp0lgXDSGQIgzAm3gu+TaasTF67J6+Rtxum4BljL6
         ZGXg==
X-Gm-Message-State: AOAM533ma9gLZTvyyLORdEGci7Pc2RP7q+QYASzmmRwh1JRNDv3M6vo6
	jDltqxzQCScYkJlHFZIMspgRBeplq0JK3N70pn9z475unAd9Zw==
X-Google-Smtp-Source: ABdhPJz86brASdkpVzG2YkHEjnR4KziiLzs3+/7QlKPE4XvQD/ceEaQo/bpzGu2sg4zmcjVzHdKPij9WgcSkJea0IeQ=
X-Received: by 2002:a05:6a00:e14:b0:4fe:3cdb:23f with SMTP id
 bq20-20020a056a000e1400b004fe3cdb023fmr26408877pfb.86.1649548027242; Sat, 09
 Apr 2022 16:47:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 9 Apr 2022 16:46:56 -0700
Message-ID: <CAPcyv4gLVHZSJNPcxcb6tDD3z8DO_X49OvV-cudeziKfG_08mw@mail.gmail.com>
Subject: [GIT PULL] NVDIMM + CXL fixes for v5.18-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/cxl+nvdimm-for-5.18-rc2

...to pick up a couple fixups for code that went in during the merge
window. These did not appear in -next yet, but they have seen kbuild
robot exposure.

---

The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/cxl+nvdimm-for-5.18-rc2

for you to fetch changes up to d28820419ca332f856cdf8bef0cafed79c29ed05:

  cxl/pci: Drop shadowed variable (2022-04-08 12:59:43 -0700)

----------------------------------------------------------------
cxl + nvdimm fixes for v5.18-rc2

- Fix a compile error in the nvdimm unit tests

- Fix a shadowed variable warning in the CXL PCI driver

----------------------------------------------------------------
Dan Williams (2):
      tools/testing/nvdimm: Fix security_init() symbol collision
      cxl/pci: Drop shadowed variable

 drivers/cxl/pci.c                | 1 -
 tools/testing/nvdimm/test/nfit.c | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)
