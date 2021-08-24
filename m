Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B599272
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 09:51:37 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso1941313pjq.4
        for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 02:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1iUjoIHAHSPcb+Vjmn30gMqM9iXUyBU913+foah2qA=;
        b=QOZ0TpNKbocf7HtNdHsThwb+PeMicqTM/sarwOPKx2bHql0Hbexww7VUu5OTxXG7Ed
         h7B7fD4gzuR/Gjc3Zy9lhYA1uoSwfdkwty686jiF3yfea5QniMNNIXKdLUZOoIy4DRpG
         BQR+4yF6YqQobdrcdZbre15WOHgDGts6f6nvqXbDZJO0H/XCN+8KRiijZm50PKu4nQ28
         Uap4duPq0f9vjn6YBRT2+yUVYrCcFej3rG2LILxYaptW04aTlF6C4gxefxLYcgcEDm6/
         bwvXTx/WzY095A1+/nETo3ru5pqFF8yiejkM/XH9bfrpR2yrHOacsTrhze7nmDz8BVt9
         PwAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N1iUjoIHAHSPcb+Vjmn30gMqM9iXUyBU913+foah2qA=;
        b=CVcplQnD//mYKZZ8KvLqwg+DtHEqaqtsSfL6FmEWpEad1JSm4rKPzBNZct9T4/XShW
         fZ8zs1HSIL4iYXWYV7RKFL226GGEFjd90SA0JJT24pP8+mlGo4E7GBq/5fAhv7jfMBaX
         57/Em94iidnugDIJj6+Pbjwz3rOnXJwnAArLau3oBDL5sAkBLO9cMNXEzSr07MkgPztD
         JcEJcHvkomKGIAT4T7dgcThvz4zh3diVGA8fz2//x/BTp/uyVbDX6Ai8qMMIJdHzjgyg
         wPHP8LdThS1BQbK6CgJOpDsLOlFcrQm0Rshchdv2riZIGfBosS87VZGoKx+15t/rnFFs
         L7kA==
X-Gm-Message-State: AOAM530khzYpftDcfb7hXltf5CRcE8hWG0smDFPAP9D2PcBEUIODAPDa
	Sc5rNkbPHeYVN0w0ggXHx+tQs/pjj8CPIA==
X-Google-Smtp-Source: ABdhPJx9MDXGW/iByZYd0X1uwuBpfMby0dpOtUQmlCaHzaEX3u6IVPfWTuD3PoELpXT/d7gUCbP6Zw==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr3577950pju.51.1629798697286;
        Tue, 24 Aug 2021 02:51:37 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id l19sm1873881pjq.10.2021.08.24.02.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:51:36 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH v2 0/5] make ndctl support global configuration files
Date: Tue, 24 Aug 2021 18:51:01 +0900
Message-Id: <20210824095106.104808-1-qi.fuli@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: QI Fuli <qi.fuli@fujitsu.com>

This patch set is used to make ndctl support global configuration files.
All files with .conf suffix under {sysconfdir}/ndctl can be regarded as
ndctl global configuration files that all ndctl commands can refer to.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>

v1 -> v2:
- Update the version of iniparser helper

QI Fuli (5):
  ndctl, util: add iniparser helper
  ndctl, util: add parse-configs helper
  ndctl: make ndctl support configuration files
  ndctl, config: add the default ndctl configuration file
  ndctl, monitor: refator monitor for supporting multiple config files

 Documentation/ndctl/Makefile.am       |   2 +-
 Documentation/ndctl/ndctl-monitor.txt |   8 +-
 Makefile.am                           |   8 +-
 configure.ac                          |   6 +-
 ndctl/Makefile.am                     |   9 +-
 ndctl/lib/Makefile.am                 |   4 +
 ndctl/lib/libndctl.c                  |  52 ++
 ndctl/lib/libndctl.sym                |   2 +
 ndctl/lib/private.h                   |   1 +
 ndctl/libndctl.h                      |   2 +
 ndctl/monitor.c                       |  69 ++-
 ndctl/ndctl.c                         |   1 +
 ndctl/ndctl.conf                      |  56 ++
 util/dictionary.c                     | 383 ++++++++++++
 util/dictionary.h                     | 175 ++++++
 util/iniparser.c                      | 838 ++++++++++++++++++++++++++
 util/iniparser.h                      | 360 +++++++++++
 util/parse-configs.c                  |  82 +++
 util/parse-configs.h                  |  34 ++
 19 files changed, 2048 insertions(+), 44 deletions(-)
 create mode 100644 ndctl/ndctl.conf
 create mode 100644 util/dictionary.c
 create mode 100644 util/dictionary.h
 create mode 100644 util/iniparser.c
 create mode 100644 util/iniparser.h
 create mode 100644 util/parse-configs.c
 create mode 100644 util/parse-configs.h

-- 
2.31.1

