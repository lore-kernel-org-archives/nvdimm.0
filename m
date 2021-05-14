Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4DB70
	for <nvdimm@lists.linux.dev>; Fri, 14 May 2021 23:43:44 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id lg14so933441ejb.9
        for <nvdimm@lists.linux.dev>; Fri, 14 May 2021 16:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=v3u3b9uT02hbX02b+XftSWgRRCv+2h7+b/1VyLPKTaw=;
        b=K1r0Y34sTbOrf9jhumBPZ6G5hS4KTjCXmUPdNQawQh5HvGQBrptyVrAqG6jr6L8Y+L
         LjY2R+rIs4BlpX2nZY0BmTPMwrDqRRjMSOVzKf6lde8k3YqjHrWXoh1kd4GNZ3dfjs4M
         YxJ1mFbUVttbWsestCFpjlab/6Ryfb78NVImRllTfgPHiPE0EOaQxNFP1HPmZzo1dsBb
         XJswTOGqiFzG5/qLR/D2shgk70Nn0o48RvU8ppVwTymgZuhmtqvLBuWgL76hZvBJYpsf
         XHUHHlp1fd1woMT06xwZxUS6Vx25gSRI/Wlc74dyqBk41haWmtGrMUoctS0PWbzAN1ri
         CGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=v3u3b9uT02hbX02b+XftSWgRRCv+2h7+b/1VyLPKTaw=;
        b=Q5cnwYmOoZtWAQWO7b5Aihs/0Uc97joos5epCfZDDNYvjHBx1s/qs8RlXmtj3JzSFh
         waEWU0FCKo894mJhS9ewZh0ojhLFipztEQyB4PgEOlrlUfFDJKsrFHCWQCfbod9XUyl5
         UgPdN5HXMkBLEMC3aL7TuMPU2o+YAnDNRG27lmhAmNK9fG/63ZUBJN0yJZUdwpVsZ0bg
         j3YW90TT0lnPHiaImtezRb40tOmn5dbW2FaBLxhByNLzOFRTsa5IsMVdsnvdja787w8n
         +QzYYaJuMAlx+emj69yYFQuFsiBzPTTKrIHB/JTzHc3upo0MooChkp2m9cZo96TPsZce
         K1cw==
X-Gm-Message-State: AOAM5317gcotKHmef4W1CwEI4Jc2nEAw1620Hnap0x4tvVHYPTPIQbFi
	DkvXcyoKcpWstLKKMMiNwaEx1vlAkOd9WzYTVYMTyw==
X-Google-Smtp-Source: ABdhPJxOQlIGiokO70SPnHXQBzx0NDpYA7ZkRGGn3AeoRPNbA/UMXqQl1o5UsxDfPBT75lhQedX4k1MOMo7xuNqSEMs=
X-Received: by 2002:a17:906:bc8e:: with SMTP id lv14mr50659631ejb.418.1621035822234;
 Fri, 14 May 2021 16:43:42 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 May 2021 16:43:31 -0700
Message-ID: <CAPcyv4gEKckAC2_mtjdK22OsEH4tHQSprYmuB7hkhafYquKNGQ@mail.gmail.com>
Subject: [GIT PULL] libnvdimm fixes for 5.13-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, nvdimm@lists.linux.dev, 
	Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.13-rc2

...to receive a regression fix for a bootup crash condition introduced
in -rc1 and some other minor fixups. This has all appeared in -next
with no reported issues.

---


The following changes since commit 6efb943b8616ec53a5e444193dccf1af9ad627b5:

  Linux 5.13-rc1 (2021-05-09 14:17:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-fixes-5.13-rc2

for you to fetch changes up to e9cfd259c6d386f6235395a13bd4f357a979b2d0:

  ACPI: NFIT: Fix support for variable 'SPA' structure size
(2021-05-12 12:38:25 -0700)

----------------------------------------------------------------
libnvdimm fixes for 5.13-rc2

- Fix regression in ACPI NFIT table handling leading to crashes and
  driver load failures.

- Move the nvdimm mailing list

- Miscellaneous minor fixups

----------------------------------------------------------------
Dan Williams (2):
      MAINTAINERS: Move nvdimm mailing list
      ACPI: NFIT: Fix support for variable 'SPA' structure size

Wan Jiabing (1):
      libnvdimm: Remove duplicate struct declaration

Zou Wei (1):
      tools/testing/nvdimm: Make symbol '__nfit_test_ioremap' static

 Documentation/ABI/obsolete/sysfs-class-dax    |  2 +-
 Documentation/ABI/removed/sysfs-bus-nfit      |  2 +-
 Documentation/ABI/testing/sysfs-bus-nfit      | 40 ++++++++++++-------------
 Documentation/ABI/testing/sysfs-bus-papr-pmem |  4 +--
 Documentation/driver-api/nvdimm/nvdimm.rst    |  2 +-
 MAINTAINERS                                   | 14 ++++-----
 drivers/acpi/nfit/core.c                      | 15 +++++++---
 include/linux/libnvdimm.h                     |  1 -
 tools/testing/nvdimm/test/iomap.c             |  2 +-
 tools/testing/nvdimm/test/nfit.c              | 42 ++++++++++++++++-----------
 10 files changed, 69 insertions(+), 55 deletions(-)
