Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FF368
	for <nvdimm@lists.linux.dev>; Tue,  9 Nov 2021 20:09:09 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 200so144127pga.1
        for <nvdimm@lists.linux.dev>; Tue, 09 Nov 2021 12:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MFhgPmMUzY5bixt3ED/CYNqP+oP8LzDB/9oB7Scx130=;
        b=Qkv2PJhpyguE9H5EFEK/8CBdT9QeCz49sWnshnEAN1618U4VqNbw7MJPROb1ow90v/
         e/brizB5rwAyJosrcL55QzUMwXV22tE1E1uUs7Pc1lXS3Im0iU7s9kbZmJdJxB4abkso
         LOrZtdZBJ5xiHo8gHvnFyaCC6qDj0UdCEZSYiOyYB8a7UjJqXY9yftq1CWtRTdUKJ0HE
         ztE5dLQAFKK29jR5EH64Ytc3b+gLMyi5sD2C3Ua2CRUfA/Or3qVDEuw+1W57QYuEEJfB
         I3371caYZKglz3jqfbAMA4w6EciXwq84TVaVWkLvHZsvTCXV7Gb+ZI0mqWmlGpUpTetR
         k35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MFhgPmMUzY5bixt3ED/CYNqP+oP8LzDB/9oB7Scx130=;
        b=Pa3jc7DoyR+KpKZiNWDwjG/0ejK7E/tFBH4FO5UEEQKBCKEsINkRYNwDuGbgA1Yazr
         L08CHe3WWWdY0yeXnUJLXyqcWqyR4UWEem56uMbQdvt/tXY3gVyqZUxJEZNHlK2dXNe5
         NZ5v+FmQjwidKgGaUZd8V9UyYHiye6ZeWNB4PB3f6oV5ePlSuFBYH7pK3McCaok5Dl7o
         g8nzjIUo5DoGeOUagPmamtVA/YRW+H8zZ8eEsOmOZYz9HKwe2nAtOwCSxYvgtXoAbt9W
         YkiNy7eWTznAzU8SUHnMFrdleHiAQ9tSnPjTNioheHtB+NyWEXrzmBcA1sINF7qYjl3I
         Hyxg==
X-Gm-Message-State: AOAM532oWuzXUKDYE3v8SyHh3zGoXW4l1QCYGcmp0a8dnfhNb9gFWs+5
	OnKf2J914vRIfz7uoUnes5gGq3C2bWtYvWOWZkhqYw==
X-Google-Smtp-Source: ABdhPJzMrhmzp3umuOmUUffcIwDAAVL3qHvK1pI4UgmDNf55IOUbfaAtccYX8Dkem2gd/om76jsPzmu7q/UXylvHFLg=
X-Received: by 2002:a63:6bc2:: with SMTP id g185mr8002283pgc.356.1636488548404;
 Tue, 09 Nov 2021 12:09:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 9 Nov 2021 12:08:59 -0800
Message-ID: <CAPcyv4jo4gsDVYRJFZY==-4gNY-B2yC7M-NWc4j+OnQYWYctKA@mail.gmail.com>
Subject: [GIT PULL] libnvdimm for v5.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.16

...to receive a single cleanup for v5.16 that precedes some deeper
PMEM/DAX reworks that did not settle in time for v5.16. No urgency to
pull this, if it misses v5.16-rc1 I will rebase. However, since it has
been soaking on Linux Next, follow-on work has already been based on
this commit. It is easier if it just moves ahead, please pull.

---

The following changes since commit 5816b3e6577eaa676ceb00a848f0fd65fe2adc29:

  Linux 5.15-rc3 (2021-09-26 14:08:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.16

for you to fetch changes up to e765f13ed126fe7e41d1a6e3c60d754cd6c2af93:

  nvdimm/pmem: move dax_attribute_group from dax to pmem (2021-09-27
11:32:51 -0700)

----------------------------------------------------------------
libnvdimm for v5.16

- Continue the cleanup of the dax api in preparation for a dax-device
  block-device divorce.

----------------------------------------------------------------
Christoph Hellwig (1):
      nvdimm/pmem: move dax_attribute_group from dax to pmem

 drivers/dax/super.c   | 100 +++++++++-----------------------------------------
 drivers/nvdimm/pmem.c |  43 ++++++++++++++++++++++
 include/linux/dax.h   |   2 -
 3 files changed, 61 insertions(+), 84 deletions(-)
