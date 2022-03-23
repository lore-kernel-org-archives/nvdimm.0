Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB67A
	for <nvdimm@lists.linux.dev>; Wed, 23 Mar 2022 01:39:58 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so364927pjm.0
        for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 18:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=2ueOjlq15eu7oYpfnlXkQFucNb+A7c4qBM8Kc8VaCtE=;
        b=W1URGPCPrRJ2ZZEx+kiyBzNSfX9hhFHEuQexMQTNcvyApLOu5B9QKXqB8vtKN81xa8
         RwJZe0mNGYPJ8QrW0K72E/5DnYNgE8dMWmHEtpZS21oVB+20EVrYeXVhJfyeBoHkMVJm
         aM2gftiaMc3lxYbV1gU+hdcMqE78CSHPkape7ootr92pLnKA40tu8nXeoOx4MJ9k+99P
         5xWaph0nEZGjZfz/QrUS1yA20SToq4mjlk73T/URN0MQIrpMg30itCyuMzA5NPrDHI4p
         XOckKI6B8JVDu0ec9mx70F0y30qXBNPHw6ZqzAbK8Q4xjyOolOG8bvFsjAUjuuBy3TFF
         /Yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=2ueOjlq15eu7oYpfnlXkQFucNb+A7c4qBM8Kc8VaCtE=;
        b=urGWVa+1kZsCX6cKB2anUeoK5Bb9J/ZoCyjarDoeJmDvazjPRCz362hHDBwLg7+6Vc
         xGt/1/9Aazgb0FcCJUoh7w7q/MUVjmQjJRA3k95BD66H20ii8vrI+W2hd/hNnv4l2FKd
         Ij0WiybdUZLfILHIdWlMdSfmQd/uETunSePFjzgq5HidSrSJNv/2If25v/bCQz+TIAcj
         W+exyxuZ9BqoNb5FmfJwEkclS+5IUiBNp0AiRt7VHnLrZ9+P2neMFvYwrtyOK+9yPvWo
         gyyPFUrwzhxFgDGCSoGlpjEOWu96zES2YIW8wdf57BZu2Ynj/2g5OBZWKmbNSM1g5s/S
         B5vw==
X-Gm-Message-State: AOAM532Pl+2bzxHy8ouMIv00zHf2PpH402OrAms0ykwmBE7rdtc6J79v
	flWNKujrasRr+rJa5OkS83LGBPdOugx6Epr4ECq9OA==
X-Google-Smtp-Source: ABdhPJyCemkBbr0iy/8AAuAdcEuO1L5SWva5HC++gia6XuC8WzbURILZLfz41Bl0ZSMwmVW9iIcDOHB+zHzx9W/zsLA=
X-Received: by 2002:a17:90a:430d:b0:1bc:f340:8096 with SMTP id
 q13-20020a17090a430d00b001bcf3408096mr8379919pjg.93.1647999597006; Tue, 22
 Mar 2022 18:39:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Mar 2022 18:39:49 -0700
Message-ID: <CAPcyv4iOwM+qaKdw-BPkDe9Fpc19YVezVVurZ0n0o7OsRsEuJw@mail.gmail.com>
Subject: [GIT PULL] DAX update for 5.18
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.18

...to receive a small collection of dax fixes for 5.18. Andrew has
been shepherding major dax features that touch the core -mm through
his tree, but I still collect the dax updates that are core-mm
independent. These have been in Linux-next with no reported issue for
multiple weeks.

---

The following changes since commit 754e0b0e35608ed5206d6a67a791563c631cec07:

  Linux 5.17-rc4 (2022-02-13 12:13:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-for-5.18

for you to fetch changes up to db8cd5efeebc4904df1653926102413d088a5c7e:

  dax: Fix missing kdoc for dax_device (2022-03-12 13:46:25 -0800)

----------------------------------------------------------------
dax for 5.18

- Fix a crash due to a missing rcu_barrier() in dax_fs_exit()

- Fix two miscellaneous doc issues

----------------------------------------------------------------
Ira Weiny (1):
      dax: Fix missing kdoc for dax_device

Shiyang Ruan (1):
      fsdax: fix function description

Tong Zhang (1):
      dax: make sure inodes are flushed before destroy cache

 drivers/dax/super.c | 2 ++
 fs/dax.c            | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)
