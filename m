Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751113ED5A1
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186974; cv=none; b=JhLWrqExrrHaIv7NDpAOnlGdkEtmOfeEPvFSnI1bjAa17CCdoy5BTvYDx8GnQao9bSCRZQV04NPBjBJfrbxxIb4nfWaWwFJ2Tyxpd0NupvxV31OIPbsvzx8s3G7USgBVPowk3qmQkVepxdaqkeEc1sDzG984BGJCl4zyQnGolGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186974; c=relaxed/simple;
	bh=kpXA6yFcgEj/dZUYvtOkGjq4OnKrIjZeikESSLTpnzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UdPRc7scOC2HnU9iuSBJ9uGOcV/HeaSJ3CyEwCxUSUM6NZk3rVAGSa5PTmdYLjrJgcfS+XpJP8qDkVKcT25w/cfOmcp7XkrD7BgniWJLIO0pf+DQSI0GudlS1F/RoEIoEPfGa6YcYhNPQtYqZTLMM24jBUMcJ7okdlZ9jCEJvcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=njvfeuJS; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="njvfeuJS"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93cc1ab5f6cso40565985a.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186972; x=1792791772; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=d2FeU/KA/HdZ7zmpfqoNfHf522vbSJvjixYnmAFtz/0=;
        b=njvfeuJSpKzfiaUAARGhYtP3BGXT6SGxCqcUyVe6cz56Gn5YiB+ORCzmrx7OezwosR
         SaSKVzGnE18QjacbA1AshO3Wggr4bGLeT/UhUKQjTDsjP6iwLEJEbdTTm5FGfP27i1Qz
         MPGvoVUtW7muXEYOHj6m2ybSqnY/DOBMcVyRR4XvadePjc0Tuwg5wEIXr+YT80w+PHfU
         ZG/ERYLmV/hNMd3jQWCJTWC4QSPUpWy6M725o/AM5xdSwakoVDf11Jo7O/dJZeBUnOUm
         rhwS8/R44iqb+9jqmwwTVSjRLrWnbpPNcc/VT8HCi1jQqALkuM+XAX7yBnQdBhnqev9h
         BrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186972; x=1792791772;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d2FeU/KA/HdZ7zmpfqoNfHf522vbSJvjixYnmAFtz/0=;
        b=2i4eDJ2P1HPSxwumv2Da/aHiVr4laLir3VF8H4c+5gXi9rAQ9KTmB71SQVhx9NcOuF
         72V7OKmUaBtfLzvPfygycMU6bgmM8JZyt2zrYHnIxjH5eHwRFlVuTdiWzLbC1FraKj/8
         3gpxJdexWNtdGgEaOloYK6OSoWwh8OpF5/t7yPWSigxvSVejF//oTRL6t6WnNJCwLf1B
         IQOIXC4T4sFlkpzAayL5e+SqckCUyUhiwzdfWUEWtI61A1z49GmZf/ajVYcPrD5hRJH4
         FTbqgtotfsIZ2cyWzNqqPsaegUFVOL4uJ4NqHgsyy1hIzi8kTIr5+W6Xxmkp3/9dOIkr
         lYYg==
X-Gm-Message-State: AFq9FYKfcoR4bU3JDYeUzoF8JagZ8pkLn+pUTjXmLAkMb6w4fIYWgajH
	mFSkM20upjKEaniIj6Wq34HCA1+q7Ti2lqO2ZRi0ST5JlER9C1LsBMr/I8TMkI773ZkOf9r+mOV
	/D6Eo7FQ=
X-Gm-Gg: AYBFou3+THb0esI1nMpZckXi2HnsHdJxMLaJXyRMo8mofOdS1cgYZGog48IOS7W1NG3
	pstW4KDymtbQ3FiTKhPbq/BhQW8F902LUb04YiPOgtBi97gSmm79q6hvsaxBnngNRAjGpqbCqpi
	Q4njyBFeGtqxQ8MVKpNTrm4/1DCgsp65+G8KaDdXbtDNjcMO+eWc1cJPuDY0Y+IYw3JYD4MbG0o
	xPosXGtitlNI5PH1XuVM4NzdieqCupCJe6gmtLKLj2Ya5+c3tGUw5TzcU7+W9GCd2+1vdt3OLcv
	+TV4y9myptWiaE+mkuKLROY1xZM7vIHYYVBwkTeOeHr8n4Lm4mbGIy56dipQ+kmJyd94ZnkPFe5
	0wZegIZ6ZvrZ5MDF2Cb5Z8+sEdSZYuMM+ODKgjue20lvYNJmvdFCwxYmPxMFsfkCOoamu9XTOQ+
	TQiFprWAfjAuI5Pj576ZI/h6J7Wh/cuwAo6laz/MoKVdc9r8p4DuCKdpbtOTJXgqIXrkPXdlqO5
	3anekKpAhYBCCzoP3xGvzu+XgFjeldkri2yRNumByA8LJlEot/PNJ+I93Wgkd52Z6G2Mfo=
X-Received: by 2002:a05:620a:2609:b0:93e:7dfa:2f3f with SMTP id af79cd13be357-93f29d9614cmr208269885a.62.1792186972297;
        Fri, 16 Oct 2026 14:42:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:42:51 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com
Subject: [PATCH 0/6] daxctl: use dax kmem atomic whole-device hotplug
Date: Fri, 16 Oct 2026 17:42:42 -0400
Message-ID: <20261016214248.443247-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernels with the dax_kmem daxX.Y/state attribute [1] can unplug or
plug-and-online a whole device atomically. Use it in daxctl
online-memory and offline-memory so other agents (udev, auto-online)
can't race daxctl block by block, notably the offline-then-unbind race
on teardown.

Kernels without the attribute keep the per-block path.

Behavior change: offline-memory now always unplugs the device (state
'unplugged'), removing its memory blocks, even if they were all
offline already. Previously that was a no-op.

'daxctl list' (and 'ndctl/cxl list -X') gains 'hotplug_state',
reporting daxX.Y/state. The kernel only updates that when written, so
it goes stale if blocks are toggled individually.

If there is a mismatch between 'dax/state' and the blocks, then
'hotplug_state' reports 'inconsistent' (online state / zones disagree).
That is intentional: it flags agents fighting over the device.
It only appears when the attribute exists.

Compatibility notes:
- Where the unplug fails (e.g. no memory hotremove support),
  online-memory falls back to the per-block path and offline-memory
  of an already offline device remains a no-op.
- Older daxctl/ndctl/cxl binaries don't expect a device with no memory
  blocks.  Basically multiple daxctl versions on the same box can cause
  older versions to fail when in the unplugged state.  Not a huge issue.
- If re-adding fails after an unplug (e.g. region can't be reserved)
  the device is left unplugged.
- For multi-range devices the kernel succeeds if any range is added.
  daxctl can't tell that a range is missing.

[1] https://lore.kernel.org/all/20260712154505.3564379-1-gourry@gourry.net/

Gregory Price (6):
  libdaxctl: add dax kmem atomic hotplug state accessors
  daxctl: online whole-device memory atomically when available
  daxctl: offline whole-device memory via atomic unplug when available
  daxctl: report whole-device hotplug state in 'daxctl list'
  Documentation: describe atomic whole-device hotplug in daxctl man
    pages
  test/daxctl-devices.sh: cycle offline/online to cover unplug and
    replug

 Documentation/daxctl/daxctl-list.txt          |   5 +
 .../daxctl/daxctl-offline-memory.txt          |   5 +
 Documentation/daxctl/daxctl-online-memory.txt |   5 +
 .../daxctl/daxctl-reconfigure-device.txt      |   5 +-
 daxctl/device.c                               | 156 +++++++++++++++++-
 daxctl/json.c                                 |  53 +++++-
 daxctl/lib/libdaxctl-private.h                |   9 +
 daxctl/lib/libdaxctl.c                        |  71 +++++++-
 daxctl/lib/libdaxctl.sym                      |   6 +
 daxctl/libdaxctl.h                            |  18 ++
 test/daxctl-devices.sh                        |  53 ++++++
 11 files changed, 379 insertions(+), 7 deletions(-)

-- 
2.53.0-Meta

