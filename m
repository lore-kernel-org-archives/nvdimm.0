Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE3C17BED0
	for <nvdimm@lists.linux.dev>; Mon,  7 Sep 2026 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762881; cv=none; b=oI/DgPXE8/Bzw2pBAOvd2pqp858jWOcQDY5QFg+rd3DQz/KGVh4X3HAXy6iSlbNCqROX1QqPvOCiA2sSZ5nVyo1g/EdUaY30QMNE154Vp2TskD0sB1yVAhnvvCmLczIS+uvXyAczw/RqpSxI65DlTuQGhu/9KmvfGTvnClLSl8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762881; c=relaxed/simple;
	bh=OpnSbiaNVNBKpJLEg0ABVd1AxL35rUOfHxGetiPXgbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KActwchWhx8AdXK5aCG6JOwrLBcBrVrMqQXr/Z4JEYO7O/0CqAK25ufnchFmYg9BoIHiIhOiIm6R9z/InskTb0GC/+WhHHZZ1AlrdxvLHT4JK27nQIYEKWDAN2YHiFnEst3iPuiRRhoTlhOCKfQ4sMoCKrg2gC9EAGcoRBgIoe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BlSbiTwz; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BlSbiTwz"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2479866a91.2
        for <nvdimm@lists.linux.dev>; Sun, 06 Sep 2026 23:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788762880; x=1789367680; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2FSHqSDBVh7M0o7k7e9zq49JGk3OZQQpti1HpuYE3e8=;
        b=BlSbiTwz6T0ccCBLkMhEGPByCt+Eanot5W8prFESNRlRtEFqPBW1X8RmL4iLtlDGVM
         9Kir3nIrTMCOjeB1BY51nDETM/IjZJWeS3AAhQhVCvH13X68Gm1lq7WS84XYpPFiPg57
         1Fp53LvGv3fyZv/Mn9ENLyC1bMlRuRq4QXLmVil1uo5crT7WJ6YOh56SoR2FvOyMK0yj
         Jn6CeVL2wxbaZ6CA+RyYWe/mV7EyF6VJr4o+y3l+aQ9fX/f9jIJ8CxiFKvnXHuVufhwU
         RIkPP6UdZjo+8HGlcWDMVOjH80WjGMLoubnXeNarktME83W/pkiVCP18gzVPyklrXcay
         YILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788762880; x=1789367680;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2FSHqSDBVh7M0o7k7e9zq49JGk3OZQQpti1HpuYE3e8=;
        b=DZwYvrk2JU1Gmc0QSoWTBATuk8gGZhaWSe4XohLL63c5VBLHScLs/626OYoeJixlsa
         ea5kHKVZ2OQieh8spf8UorR7T/tZFaZiNf9gSRhBl8DXuRH/ctZjwjV/XKchdSNyWjRw
         v8OyHio9FW/31zK3Mv//ndxL4ST9RxRsEE1t70UYzRufDPXhJQ3w25GohqjwRS5pKLWx
         NKglHVUGZnlW+Sn1jUnBfksqOISvp8nZGD5MsyXsAVBiSpWDLNKPPl3x1+redF8pkzwq
         T2FFDz/ZuWvf0q40Lwe0fFChm6MjcBkPlWBYVobmue+cOYJvRxqXFVQdLYNHSx0XLa74
         tgtA==
X-Gm-Message-State: AFuF++nKTPHgECPMnO/E9HJID3boFngStJT2Pj/5QD9D4FpBgD7fS7vE
	/azJwJP+4e+gZJX4H7zpvXWqjejsxZ3wiYmzelK/RFYtr7vAXwbXX80a
X-Gm-Gg: AYBFou1RUr4gS+a5RetTbb2Crn0l41iviMA0Y1NWo3a1MMAFcYjkhzDxpNIEy4yR0qd
	QeB7NrAA6qvUphi8mF5Ljs9yAwjhD6id7D8HZzAxyh+j8ldQPiWDlPrT/Rbx1q6GCyRBHu+Grjo
	r5DHPd74roJf299/umrjYtZYxvJec/yxC5b3qQFYJKFrUz6EpQRT6W2w26HqFa+emjXPMnHbGwB
	C0MVhFsSCT3Ydb68npcLM/U+7KDmg4Cg+1SQgEQd7/L1NdFifFMhvCJth/Ekvkba3xFZDh0hEXM
	ZfocWaaeOy6pFITMZuKgFSnA4ZfmdFWNlGz6+UQR0+Yz/185+PPJpAsWbmb7uo9ubfhD2DIolD/
	62J+nZ+KA5q0oFPrxOv9RmAytb4r4nsJ2qMKYCbdkGlX5MeAWAIujon++oTbGaaU2pRPfSoKCme
	KtFc5eTGqYSCiSm2PduzTyI/YMEXM9azO0EfMW0ANZKr79PnGi0wOnKvrQ+SV9aFBl5Bo6Xizdx
	DgbAKwN53D8NQ==
X-Received: by 2002:a17:90b:3d92:b0:398:bf7e:b267 with SMTP id 98e67ed59e1d1-39b2614df9dmr33248659a91.2.1788762879664;
        Sun, 06 Sep 2026 23:34:39 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432441f5f2sm27634416c88.15.2026.09.06.23.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:34:39 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] nvdimm: fix typos and repeated words in comments
Date: Mon,  7 Sep 2026 12:04:32 +0530
Message-ID: <20260907063434.23060-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This corrects 2 misspellings and repeated words in comments.  Each is a
separate patch so that any one of them can be dropped without touching
the rest.

Nothing outside comments changes.  Every touched C file was checked by
dropping its comments, replacing each string literal with a placeholder
and collapsing whitespace; what remained was identical before and after,
so the compiled code cannot differ.

The mistakes were found with scripts/checkpatch.pl against the list in
scripts/spelling.txt.  The scanning, the edits and the changelogs were
produced with Cursor running the claude-opus-5 model, from a request to
find and fix spelling mistakes across the tree, and every correction was
then re-checked by the comparison described above.  Words that name an
identifier were left alone deliberately, even when they read as typos,
because correcting the prose would make the comment disagree with the
code it describes.

Tested by building x86_64 defconfig at v7.3-rc1-269-gbc35965f6940, which
is clean.  Nothing else was built, so any patch touching code that
x86_64 defconfig does not compile has been read but not compiled.

Hemanth Selam (2):
  nvdimm: fix typos in comments
  tools/testing: fix repeated word 'from' in comment

 drivers/nvdimm/namespace_devs.c  | 2 +-
 include/linux/libnvdimm.h        | 2 +-
 tools/testing/nvdimm/test/nfit.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.48.1

