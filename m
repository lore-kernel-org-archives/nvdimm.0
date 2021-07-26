Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC0E168
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 06:09:12 +0000 (UTC)
Received: by mail-wm1-f49.google.com with SMTP id u15so1176489wmj.1
        for <nvdimm@lists.linux.dev>; Sun, 25 Jul 2021 23:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fs/qMW+zCQPBZoUzNXy1A88u02WLrjhFdFexEEelAZE=;
        b=fWSOVnu0bm2MWyRGIQz25MGM8/MU5L2FQwlEkfAFE2TUWTTLoPJiNNE6aKCcykbHC9
         hsBqYWklnDby93Dkq+PljyFW1dXOAZSArNcj5MY+WejFMo04xKr5bpIKU6RpnE/ViRRi
         EX97NDejVrJYpa6WDTDp97pYD0fGpcGqqv3L66cPxAYrfjIzfVj43tPMVG2p2CsYmIcZ
         IZ9AbiFRufHClTbE7vxm9AW2a8+d2i+B+PU+FGbqbLGr5v7aePLbu2pgxN2r2ZlNkqze
         7zTw9HwOq5ndsUO5Lay2tyVMcXSZto2ICsgtKauqHvMsteO+fyRqqKPKQsL84Xs4Vz9g
         RNqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fs/qMW+zCQPBZoUzNXy1A88u02WLrjhFdFexEEelAZE=;
        b=Ydnl8v32lKXaRy485yBqLS+p/Qbm4nCjQ8dMspftIGXbs+Yrldu3CX2RtC2UvjGb1j
         dqbMsUol6XL9grx5KKxdQ6qrpYD/Fx+KFz96+ZnOJUgDHnawZabcpTfaJs85MI6pApoS
         YUGFjGpoFupJaIkVxKW+auqUsGqzNy3895W9OwP9L9N6U1Zzju2aQYBqhhMrrUhICcsZ
         3dUG8V/MeNJgR2WgHht6784rIlQEcUAn9c9gEZhTAKPecbFfgqsc6gBhJqBCtFHWkULQ
         zeHVlebBzCYAuUuxe/AvjOg9p3rGjmZHCOh50ixalQNBvRacUSQ7zVJrCcbHbVTBWteQ
         bLYQ==
X-Gm-Message-State: AOAM532nBrro3/G+iWGLN9dn2/fQfGLF9yhI4obFc14x6xk2VwikdIwq
	zCU2+RYX+4X1Vaa2WyoJQXgu1+MWI7gmicL1
X-Google-Smtp-Source: ABdhPJzids5i79f84ChWXUAzzYA4qPfgWcx00yP2mkCfTQCIK7koHv/gRtQJKSI5H/l/AJ8/9NBadw==
X-Received: by 2002:a05:600c:1d0b:: with SMTP id l11mr8434949wms.2.1627279750969;
        Sun, 25 Jul 2021 23:09:10 -0700 (PDT)
Received: from lb01399.fkb.profitbricks.net (p200300ca572b5e23c4ffd69035d3b735.dip0.t-ipconnect.de. [2003:ca:572b:5e23:c4ff:d690:35d3:b735])
        by smtp.gmail.com with ESMTPSA id j2sm5817548wrd.14.2021.07.25.23.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:09:10 -0700 (PDT)
From: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
To: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com,
	jmoyer@redhat.com,
	david@redhat.com,
	mst@redhat.com,
	cohuck@redhat.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	pankaj.gupta.linux@gmail.com,
	Pankaj Gupta <pankaj.gupta@ionos.com>
Subject: [RFC v2 0/2] virtio-pmem: Asynchronous flush
Date: Mon, 26 Jul 2021 08:08:53 +0200
Message-Id: <20210726060855.108250-1-pankaj.gupta.linux@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pankaj Gupta <pankaj.gupta@ionos.com>

 Jeff reported preflush order issue with the existing implementation
 of virtio pmem preflush. Dan suggested[1] to implement asynchronous flush
 for virtio pmem using work queue as done in md/RAID. This patch series
 intends to solve the preflush ordering issue and also makes the flush
 asynchronous for the submitting thread.

 Submitting this patch series for review. Sorry, It took me long time to
 come back to this due to some personal reasons.

 RFC v1 -> RFC v2
 - More testing and bug fix.

 [1] https://marc.info/?l=linux-kernel&m=157446316409937&w=2

Pankaj Gupta (2):
  virtio-pmem: Async virtio-pmem flush
  pmem: enable pmem_submit_bio for asynchronous flush

 drivers/nvdimm/nd_virtio.c   | 72 ++++++++++++++++++++++++++++--------
 drivers/nvdimm/pmem.c        | 17 ++++++---
 drivers/nvdimm/virtio_pmem.c | 10 ++++-
 drivers/nvdimm/virtio_pmem.h | 14 +++++++
 4 files changed, 91 insertions(+), 22 deletions(-)

-- 
2.25.1

