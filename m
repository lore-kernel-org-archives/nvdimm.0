Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD88BE2
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 15:24:47 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ab1b79d3a7so41429075ad.3
        for <nvdimm@lists.linux.dev>; Tue, 09 May 2023 08:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683645887; x=1686237887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xqTlhCuOMEySxCpIGDOY/17nSui9/3djdb2737bjTc=;
        b=RhpWB1eIAcVtyj2EGg6MLu8VI5QAG91SmDEKHHb6nOso/f2iR2ciEzmubLBPD0bEAG
         Qs4AhoulyTAb95GRBvnba4mZMEHWMqD8fVtaeovRzRYrnHS684qOwun4XPr3cc3vrzAJ
         gNPPzy/kCWj8cOXwcHfHCJWZpFBnElXdqu09441zdT3yP4MrLzt12RH9cLrET82XfOki
         +3hCNTMzRWy3yfKoGF4YsaE6sk56M+tzDzR/5/sJ/Sd7stcSu+fzbvBQh7yTN1p5aifK
         pZ5tQJEYaY8FWT+NXihz2XGn3WF51+0qO7nzkfgZekUlcPk8TC0fQSDlxY4HQv5FBlEz
         pIIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645887; x=1686237887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1xqTlhCuOMEySxCpIGDOY/17nSui9/3djdb2737bjTc=;
        b=CTfOriEwORTScX7EHZ+Y444NTmaMDth+kdVazqlpm4LGOT86xPqtKRCVcsEhOWLYeF
         OXTlSe3seACgjihP3pcRKJfpJvSLUe2XodyN1s1QT+4Re9xqVmPwvF7R+0vzUxZu8mhk
         rKEowuhGMwkG1exaoGNDKbo5eMipWwTfQNywTruws5Y0nzlOJPF2Z09dEy5WCPdxjnR/
         QcV3M9r2ua830uljlsKd6FN3fKV9S6n5y9SjW7tgJu5USY8Q5TbjY/mrzdccfohwFN3C
         VyG+ADy4bSBfqNXOrukjqtDvvCSsDnlTo1bMBbyDE7pT9urYe2N7QT9d01ff9k9rOI9U
         Z3wg==
X-Gm-Message-State: AC+VfDwzswusyNbXaBkoKOvyPzC0Xdbw58fMv/xpsu6YOYJDhpz9V5nU
	TRAvwFO2VlKcgr5A45orZYM=
X-Google-Smtp-Source: ACHHUZ4JI0hkhf+QqYjZzAa/irLxrR3lEzxDsucwCw3qHBVuy0IyRQrFYxMlt2/QCZBggrX6881kXA==
X-Received: by 2002:a17:903:1208:b0:1a6:4606:6e06 with SMTP id l8-20020a170903120800b001a646066e06mr17108693plh.17.1683645886811;
        Tue, 09 May 2023 08:24:46 -0700 (PDT)
Received: from localhost ([1.230.133.98])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ce8200b0019ef86c2574sm1704049plg.270.2023.05.09.08.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:24:46 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [ndctl PATCH 0/3] cxl: clean up and fix typos
Date: Wed, 10 May 2023 00:24:24 +0900
Message-Id: <20230509152427.6920-1-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

Looking around QEMU-based emulated CXL device with ndctl, I've found
some miscs to fix up including typo and removal of some redundant
funciton name in a log.

Please review.
Thanks,

Minwoo Im (3):
  cxl/list: Fix typo in cxl-list documentation
  cxl: region: remove redundant func name from error
  cxl: fix changed function name in a comment

 Documentation/cxl/cxl-list.txt | 10 +++++-----
 cxl/region.c                   |  5 +++--
 2 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.34.1

