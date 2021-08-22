Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E003FC1
	for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 20:30:53 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id j187so13556080pfg.4
        for <nvdimm@lists.linux.dev>; Sun, 22 Aug 2021 13:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ZDMVQHU6QnANHbgff3+JA2VBWtmecGV6CGTak61MWQ=;
        b=uU1DGPGAjYssq9SeqyccjurOJVdlFKcJu2To2C5xpiV6Wpb8yUBUdBBGu5mKUNj7kU
         WWTpRX5FJdDyka1CnqXMt0GC2dQ+owD8AJzN8Zmvsta32gcUT0GMMv1pK/7+qca/cIsu
         BPSb50UliqsvucrasQCUos9BdXD4j4bGAmYIi/5bAlbCQP3AeHSYEGYoyndtO55js4uD
         fbdl8HFIEhsSzH8fC5SMrA+jR6uCuzznVFDlLP2oYGwnbrxVejEKCEy4egBwlAf2c7qo
         WwCugNogif9BaB2rbaOA1MsPErL6jGmwiBUi8dtkvC4q3A9KyjWNjJbfbVgG9F556KFy
         A7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0ZDMVQHU6QnANHbgff3+JA2VBWtmecGV6CGTak61MWQ=;
        b=aujvfuANjSQotfw7nAVz364GQ6Lm7ZavfKUMeBLBy+TFD3fdY2smuNLHd/iMWI3L+E
         Vh6EWIc/KDMfwO8pPz7avvIH4gXLVYQppdUdu/o4ca7jayh5mUWa2WC0CnAr59xezeuj
         cazGKzjOf2GX3SpqUIlGSOSeZqZfUGQAPZ12lJXLzu+U+a1Q3Ti10drTSH+u523NHoTv
         n/O9VbgebDwObalRAEZIP0piSI/kg266S5pQ3GjxYGUqFkxc4R+bHxZ8lkXsfnZmRiJM
         jIeV+tA9svOpszyx2ZVJMDh4LqilDdL7HOPh9czZPmz0ZwDqMbCMAUtYsEnEODpGuofl
         nrLQ==
X-Gm-Message-State: AOAM5304N9fhzNgsgocVCGNsG1v6e93aVfZmsPe28bAWhUtkSo9sCMy1
	3P8eX+huADae3y50i27HdyndwCJ2TwpNsw==
X-Google-Smtp-Source: ABdhPJylEDmDQsa+rnBzqanK5l1i0Q2d/gRsJ9ueyxsSRG3Ms2w/i/8puFioYDUuoofzKuIns5iK1Q==
X-Received: by 2002:a63:e00b:: with SMTP id e11mr29227056pgh.190.1629664252900;
        Sun, 22 Aug 2021 13:30:52 -0700 (PDT)
Received: from localhost.localdomain (125x103x255x1.ap125.ftth.ucom.ne.jp. [125.103.255.1])
        by smtp.gmail.com with ESMTPSA id n30sm13587804pfv.87.2021.08.22.13.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 13:30:52 -0700 (PDT)
From: QI Fuli <fukuri.sai@gmail.com>
X-Google-Original-From: QI Fuli <qi.fuli@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: QI Fuli <qi.fuli@fujitsu.com>
Subject: [ndctl PATCH 0/5] make ndctl support global configuration files
Date: Mon, 23 Aug 2021 05:30:10 +0900
Message-Id: <20210822203015.528438-1-qi.fuli@fujitsu.com>
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
All files with .conf suffix under {sysconfdir}/ndctl can be regarded
as ndctl global configration files that all ndctl commands can refer to.

Signed-off-by: QI Fuli <qi.fuli@fujitsu.com>

QI Fuli (5):
  ndctl, ccan: import ciniparser
  ndctl, util: add parse-configs helper
  ndctl: make ndctl support configuration files
  ndctl, config: add the default ndctl configuration file
  ndctl, monitor: refactor monitor for supporting multiple config files

 Documentation/ndctl/Makefile.am       |   2 +-
 Documentation/ndctl/ndctl-monitor.txt |   8 +-
 Makefile.am                           |   8 +-
 ccan/ciniparser/ciniparser.c          | 480 ++++++++++++++++++++++++++
 ccan/ciniparser/ciniparser.h          | 262 ++++++++++++++
 ccan/ciniparser/dictionary.c          | 266 ++++++++++++++
 ccan/ciniparser/dictionary.h          | 166 +++++++++
 configure.ac                          |   6 +-
 ndctl/Makefile.am                     |  10 +-
 ndctl/lib/Makefile.am                 |   4 +
 ndctl/lib/libndctl.c                  |  52 +++
 ndctl/lib/libndctl.sym                |   2 +
 ndctl/lib/private.h                   |   1 +
 ndctl/libndctl.h                      |   2 +
 ndctl/monitor.c                       |  69 ++--
 ndctl/ndctl.c                         |   1 +
 ndctl/ndctl.conf                      |  56 +++
 util/parse-configs.c                  |  82 +++++
 util/parse-configs.h                  |  34 ++
 19 files changed, 1467 insertions(+), 44 deletions(-)
 create mode 100644 ccan/ciniparser/ciniparser.c
 create mode 100644 ccan/ciniparser/ciniparser.h
 create mode 100644 ccan/ciniparser/dictionary.c
 create mode 100644 ccan/ciniparser/dictionary.h
 create mode 100644 ndctl/ndctl.conf
 create mode 100644 util/parse-configs.c
 create mode 100644 util/parse-configs.h

-- 
2.31.1

