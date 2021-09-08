Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E742172
	for <nvdimm@lists.linux.dev>; Wed,  8 Sep 2021 23:18:39 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id f129so4241393pgc.1
        for <nvdimm@lists.linux.dev>; Wed, 08 Sep 2021 16:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sW4NTlq7SSKyyy7HoR/7gu1f7/0aKhJl18M8jx83+dY=;
        b=s33R3IfqxOpVYyZFcZ0cBjmgnfKK7bpLevNSo4k5JhEkapQc71J9n6IBQPhY9jgV3K
         DsRqc76lt1eXDNCRB0LZ5giVDA4S/MtOHPBV5POPxC28AS4SnIqaRVtBHH6q0yuGttW+
         7jnhJZ7h6jgcqj6/soP/npvR7JOOqM81CBfghzUGJSSOcHNDTS71M/DpIAqwtlnHV4UC
         GxNDVfJBFyTYgKiUDIY8dFfk91E7detUxRm1IByqrm2oMsq7yGIxOl/SjO651BzLSBnJ
         iceyoR8bM5FRH83y4hMvnXMacgufn4LdY+2ssRQPsgZVMbnKqfONPyt37c1xyvluAxJI
         vbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sW4NTlq7SSKyyy7HoR/7gu1f7/0aKhJl18M8jx83+dY=;
        b=1Oxu3auOXpWdPfUXC5my3zwNZjIlGY0+wHu8fm0Q8OF9gtZj7c78aX2xmgmlxrX2Fe
         OecP0IE0QuBw6TaL5gEIRCfmZewukbD5uP8+4jxk7eQqK5SV9P+ex1Ys4HXqozrTkuOM
         NmqwnWjTTIInNN3KfaMUsx2ELxRSyaLl/HYAFsm7vEgRqQOm8dkCikf/SS4j1ERJN/+r
         CpxldKoAsDNkn7xXEr6aWspyt85661xnDOa4F8v4+O47LEPTOTXM+doyvf9NIeAEYWio
         XkQThb/PnO4XY7lUcrrxhFmBgswqQZAW6cmc3dmnIunYzXvOtQKbXgTORgD+cCxkhUOV
         cp0w==
X-Gm-Message-State: AOAM532aWWdQ8IKG0m+7tu+nf2FfMPIgt+Mi/cc1/Ccr+oJyEXfxde+g
	XoNK+PjNi5d2JDUKtQRU+8A8BuU08JabyUNxuLB9zA==
X-Google-Smtp-Source: ABdhPJxEwnNqKfXQeWSlX52uT50Yab6X0/9GcmGWgPnzZ0tM2e6S8pUZvMRrb43TbvVD3jIFurQJZbdEjyhMdcOoPLo=
X-Received: by 2002:a63:3545:: with SMTP id c66mr528820pga.377.1631143119383;
 Wed, 08 Sep 2021 16:18:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Sep 2021 16:18:28 -0700
Message-ID: <CAPcyv4hvzS1c01BweBkgDsjg=VGnaUUKi7b6j+1X=Rqzzm961Q@mail.gmail.com>
Subject: [GIT PULL] libnvdimm / persistent memory update for v5.15
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.15

...to receive the libnvdimm update for v5.15. It includes a bug fix
for a long standing race in the driver shutdown path. More people are
stress testing the nvdimm configuration mechanism which is a welcome
sign. There is also a rework of the infrastructure for looking up the
dax_device associated with a block_device.

This collided (silent conflict) with the erofs updates to add dax
support this cycle. Gao Xiang noted this as well in the erofs pull
request. Stephen's fix [1] looked correct to me. Otherwise, it has
been in -next for a while with no other reported issues.

Please pull, thanks,
Dan

[1]: https://lore.kernel.org/r/20210830170938.6fd8813d@canb.auug.org.au

---


The following changes since commit e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93:

  Linux 5.14-rc7 (2021-08-22 14:24:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.15

for you to fetch changes up to 3fc3725357414636d91be1558ce8b14f228b4bda:

  Merge branch 'for-5.15/fsdax-cleanups' into for-5.15/libnvdimm
(2021-09-08 15:58:13 -0700)

----------------------------------------------------------------
libnvdimm for v5.15

- Fix a race condition in the teardown path of raw mode pmem namespaces.

- Cleanup the code that filesystems use to detect filesystem-dax
  capabilities of their underlying block device.

----------------------------------------------------------------
Christoph Hellwig (9):
      fsdax: improve the FS_DAX Kconfig description and help text
      dax: stop using bdevname
      dm: use fs_dax_get_by_bdev instead of dax_get_by_host
      dax: mark dax_get_by_host static
      dax: move the dax_read_lock() locking into dax_supported
      dax: remove __generic_fsdax_supported
      dax: stub out dax_supported for !CONFIG_FS_DAX
      xfs: factor out a xfs_buftarg_is_dax helper
      dax: remove bdev_dax_supported

Dan Williams (1):
      Merge branch 'for-5.15/fsdax-cleanups' into for-5.15/libnvdimm

sumiyawang (1):
      libnvdimm/pmem: Fix crash triggered when I/O in-flight during unbind

 drivers/dax/super.c   | 191 +++++++++++++++++++-------------------------------
 drivers/md/dm-table.c |   9 +--
 drivers/md/dm.c       |   2 +-
 drivers/nvdimm/pmem.c |   4 +-
 fs/Kconfig            |  21 +++++-
 fs/ext2/super.c       |   3 +-
 fs/ext4/super.c       |   3 +-
 fs/xfs/xfs_super.c    |  16 +++--
 include/linux/dax.h   |  41 ++---------
 9 files changed, 119 insertions(+), 171 deletions(-)
