Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D8D3BA239
	for <nvdimm@lists.linux.dev>; Thu, 14 May 2026 06:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778740372; cv=none; b=JLqfgIgsfYufjDrcnPNkjrXPE4hEHSI0CQud6++jV+hz9FD2Ehzb1bENkHS287dl3YS3ZEeKA9MZ0WFrxJhWxY8HA5eymJPOjqg1uic7BSxDEvuaBGmRQYFpXZ7pyw3PivSZv53DfecgnAvlvvAsu1gIt7RyNJJw76xg/bKfZUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778740372; c=relaxed/simple;
	bh=zyJuc28vTx22lV6NaTmHtNR9pAcEnHZsVJwY5vB17hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hc8i6e8gvve7egz5Ial4WqzSsr4MPs8BkTdWKQGzXXsssnZg3P/yVMcsjmvg2YuyzP4/zVuRT2u3uebI6SawH8P27wCHNZtB2S4X0j+P5XxJ65Ne6iCISKZTIKcT6BEjz51s0kUbaOLPo+6HDcoNT1J8hKiNnXpbVw8g77hzWV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mh8bsxLA; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mh8bsxLA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778740362; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MF1oR7h0O4ehH+UKwWgU01orTmBll/vw/iuqZ5Jszm4=;
	b=mh8bsxLA7yvDFAFAAszLSwWlYhA5Ijg8fmO9GRa0BR2ZKEyz0Hz/oYLb4N/xkMSbXnjWj1xv+1spQwF/NG1wMwi9ykoYXzqIFlbQGC5qFHJZFT1rImW5lhKRAB6iq/QoU1qUe+8ka4gcnZ0EP1gAOyALEAYkeMiINKKF62r2tdg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X2vwT6J_1778740357;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X2vwT6J_1778740357 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 14 May 2026 14:32:42 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	guoren@kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH 0/2] daxctl, util/sysfs: fix builtin-driver false failure on enable
Date: Thu, 14 May 2026 14:32:32 +0800
Message-ID: <20260514063234.86439-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a DAX / ndctl driver is builtin (not a loadable module),
daxctl_insert_kmod_for_mode() and __util_bind() still call
kmod_module_probe_insert_module() unconditionally. libkmod only
short-circuits builtin modules when it can find the modules.builtin
index; otherwise it falls through to init_module() and returns -ENOENT,
surfacing as a spurious "insert failure".

Pre-check kmod_module_get_initstate() and skip probe-insert when the
module is already BUILTIN or LIVE, matching the pattern used by ndctl's
own test/core.c.

Chen Pei (2):
  daxctl: fix kmod reference leak on probe-insert failure
  daxctl, util/sysfs: skip module probe-insert when driver is builtin or
    live

 daxctl/lib/libdaxctl.c | 19 +++++++++++++++++--
 util/sysfs.c           | 17 +++++++++++------
 2 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.43.0

