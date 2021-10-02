Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CD52F80
	for <nvdimm@lists.linux.dev>; Sat,  2 Oct 2021 01:19:21 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id n2so7344668plk.12
        for <nvdimm@lists.linux.dev>; Fri, 01 Oct 2021 18:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=aXTpsgwefS9FjUBmruzpl69mLwyzpoyIy9pYOBOwR6E=;
        b=isQPBvIbRcj7jMCawK8NBi6iXKFkgh7LMYGFehd/UVjbT/KT4vJLmr+KQhi8dm5Nd+
         QUaqn1gsiad9y3m48SiPTEi+ynUTJlJOIUJGkf4O9awIEKgIDr9DCkULV3LEl1hXoo+9
         Yng+of4AtymWeKnwgLS8ycd+FGBIpI7G/pIuC7qKZfKMQIMlH0aqAF7ubKT1tgCJgT8i
         c+8yFignuCOZnHJj+JzVTAZ6mBC/MxDyQHJSXt7VIa5YrxMTRDyKwXjM5V9Q0Bc9MKJF
         /SEoTqKHttkZF93Tuxnlgs/k+n9C9ZzFS5jyIZcWA1xUwBvpQFsUS5NE/Yy8i8jBUcBn
         yUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=aXTpsgwefS9FjUBmruzpl69mLwyzpoyIy9pYOBOwR6E=;
        b=VxGqNs9zLkgxLdm63E+55upqwNi6FTUUgmrAArzXiNa46wBzGIw2WxkYGBZcbXy9kq
         yWFPn4Cep6eMYBEj87Z5xQ9zcnTEwCXdN0s+XkAz11eA10AFcnfEChQEu+C+o9ih40So
         73AdXQ7EgIx8PWRxJtgI9tlaymRCcNiM0695AJ4clv+1047IhA1R71JeAZuzw0YV2h/a
         Qyf0MsNX8zmc0FVThgHKdHEPtvz05Ls7IhP97FCm6+Mk/MAb8hQevgjg0I6aGYsF4tU9
         1hxXGxh4SBufpcm4k/oDZogw/UBLxCQoTWnCODuBx606+t+VghtX0j0dmvZQmtdAS0P3
         I62g==
X-Gm-Message-State: AOAM532pFDyvKoxE/qQYYwPy/DK7OS2wAIpyoX4AGjbViNXN+U+4qZxq
	A7jCwVFiOBy6hTIJCBjDEyPKg8CALVllWbxevXUINQ==
X-Google-Smtp-Source: ABdhPJy8why/nFvpoAdWHRvrYyGtF5XaGSuamMCitKXoR2UFihU44ob4ierB9fkn1vARcWPZkaIyQMNNGhXAFjf/M1k=
X-Received: by 2002:a17:90b:3b84:: with SMTP id pc4mr16605771pjb.220.1633137561353;
 Fri, 01 Oct 2021 18:19:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Oct 2021 18:19:12 -0700
Message-ID: <CAPcyv4iEHttW7fDzaKYdAr2t4w3YJQ7t7QtadO0bZKDWPuK0Ag@mail.gmail.com>
Subject: [GIT PULL] nvdimm fixes for v5.15-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.15-rc4

...to receive a fix for a regression added this cycle in the pmem
driver, and for a long standing bug for failed NUMA node lookups on
ARM64.

This has appeared in -next for several days with no reported issues.

Please pull, thanks.

---

The following changes since commit 5816b3e6577eaa676ceb00a848f0fd65fe2adc29:

  Linux 5.15-rc3 (2021-09-26 14:08:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.15-rc4

for you to fetch changes up to d55174cccac2e4c2a58ff68b6b573fc0836f73bd:

  nvdimm/pmem: fix creating the dax group (2021-09-27 11:40:43 -0700)

----------------------------------------------------------------
libnvdimm fixes for v5.15-rc4

- Fix a regression that caused the sysfs ABI for pmem block devices to
  not be registered. This fails the nvdimm unit tests and dax xfstests.

- Fix numa node lookups for dax-kmem memory (device-dax memory assigned
  to the page allocator) on ARM64.

----------------------------------------------------------------
Christoph Hellwig (1):
      nvdimm/pmem: fix creating the dax group

Jia He (1):
      ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect

 drivers/acpi/nfit/core.c | 12 ++++++++++++
 drivers/nvdimm/pmem.c    |  5 +----
 2 files changed, 13 insertions(+), 4 deletions(-)
