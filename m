Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3152F7EE8
	for <nvdimm@lists.linux.dev>; Thu,  1 Oct 2026 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867391; cv=none; b=N6V1uqEla8dButDrnQ5eVnZzPuFKwRnvWnALD4rZv1YnfAqQi++9Onc5Im4iOBdNxQjTYbR4pogunBAXCtqtCRNzoum3cs2eMHhp/HMrwqSsLNKgkx4GzpTgv1NmXzXDTV/qj0h2zSLuBKceMBzxE75jeEqos/ZTBtA5vEh04AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867391; c=relaxed/simple;
	bh=9t1aAWmP4b4YG8k12sDVjav4RYFhEJqBqzzCt8PuK3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=Fwuc3oLCqQZoCSKfxWIGmxX5apgb/hqRyI1Kfa2GN91EwO63SZh3JTZ56C+QhPtVaZ4ZNae1Ya7ppy74CNdaXSJqgeQdQ57T+U7n+MReXky8NSOK8dRHC1w3oPPujNT2+aSbRX4cjXOlhJwI1nYLJAk0Y7Wd1ptfdDHEZUOYv28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SJkANfrj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SJkANfrj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790867388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qqtf/4r/JNjXdQHR8/rYcGVT30iqL+vSIact1bVLvZY=;
	b=SJkANfrjfdVhjbUNog3Nx/ur4hoxNMrC9M+y1VXbC4cyMZG+Z9dduul5k51DshK0t2KqkX
	6306Y08W292Jr6ws1pvx1UcW9Z1Akkw3JhLTdb19u6NAIW9YYYHwnUMfgWRN9POhSPYNdY
	YK9rfHrO1hZcLxiFCNy7UurGh6iLkhQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-NIatuV4kNWWZzW1w4KZt_w-1; Thu, 01 Oct 2026 11:09:40 -0400
X-MC-Unique: NIatuV4kNWWZzW1w4KZt_w-1
X-Mimecast-MFC-AGG-ID: NIatuV4kNWWZzW1w4KZt_w_1790867379
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e2da5823aso65242266b.0
        for <nvdimm@lists.linux.dev>; Thu, 01 Oct 2026 08:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790867379; x=1791472179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qqtf/4r/JNjXdQHR8/rYcGVT30iqL+vSIact1bVLvZY=;
        b=wC1CQYRmjmGupiy3thjseX/0k76cF0qAU9gDcPLmtkNOvPPfTX7V5dX5lmdUQ24aAP
         +HWC6KXaVyoEl8PI7/+gcFQvC+xXsyuYpHh8V/RqhILBff/fw2g2PbwmeG1KO9FNCEdF
         PFER7w2bSAYpqyXw9TKG12BjYLSrZztdVtHVw82Jr+9NW7DszTo7MVM5HiO008QXGwRz
         qOhiNV8wA1lPC6hckvzU7jy2PagkPhTaA7/1dZZSlrUF4l8oW0ZH1I1OLNmGGrRvOsuo
         OIfsJO5WqFosbxGXQYnBddp6HOa6QYLOmUDpNJXH8liCq6Sw4hI82BxEc/LF+3k2EVZJ
         cIPQ==
X-Forwarded-Encrypted: i=1; AKwUvBwl4Q2UhD522wUoTJRaP3VqldenRKn7/C7wiDbVuNKloiz2mDuyPjqvz7SF4ZQ3svGY+etjx0o=@lists.linux.dev
X-Gm-Message-State: AFuF++mEq1Md6FJu5PBA9cQC6K/efjT/3mkkzpggx8petecmR6T/ln56
	k4EbLhfn7xtEhjqFE8nz2dr3n06H+A/0H4B54eyQM6g25O9bUotdDsZpSAJfbRUzLLnfzPMHoXW
	r8OZBkDieZg3Fq8zMKPEBLD3UM+yBp+ZGr42E7iecQAivWKPUdXYSLCcksw==
X-Gm-Gg: AYBFou2WI7y5kEZCNVTZvi99sisNyT8+AQTbFsYI5yRz+UbOjpwr+Ge+vATX85cC7k1
	4nx0p2vOcxOdV/pMSkwhPfGx5fR1rlk6R3Hz4GbK+cGHPr1FMqjBg4JKUEa1+GoK0BdY2itkGwP
	0PPpPgsWfl+WDdXa0Vckxm6gHXpFmJyXITjFFltoSCMqULRM20C5TC/cW9eCnPx2wokTZlYEbJY
	GTIY8QP1d0E1vjyCZ+IipinQWCjw6cdIyrpDVAx1lLuK5LChCc5On6phGrmp6nrZnxtUjh1m3kD
	HMigbJ1lCwRviwp32W7t2hqLQWDmvPlAXNuH9d8cRHK13KLY4we+UktYZsW9Z5Zdx0azs+bjSiX
	hYkiCT72MarMV8F9OOwaRC7J3xsS/6NDGTPosTcEI/Hi9yWG+Q4urUSNvPG4=
X-Received: by 2002:a17:907:3e1a:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c2e23cae407mr400304666b.11.1790867379347;
        Thu, 01 Oct 2026 08:09:39 -0700 (PDT)
X-Received: by 2002:a17:907:3e1a:b0:c25:2d27:5652 with SMTP id a640c23a62f3a-c2e23cae407mr400302066b.11.1790867378822;
        Thu, 01 Oct 2026 08:09:38 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (193-226-245-188.pool.digikabel.hu. [193.226.245.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31d86372sm177735166b.56.2026.10.01.08.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:09:36 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: fuse-devel@lists.linux.dev
Cc: John Groves <john@groves.net>,
	Amir Goldstein <amir73il@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [PATCH v2 0/8] fuse: DAX device based extent maps (famfs)
Date: Thu,  1 Oct 2026 17:07:18 +0200
Message-ID: <20261001150935.655979-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KpPfXpH1G9mOF5PSJQUAd8z4cNSSsoxc-0rqizjG8UM_1790867379
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This is the FUSIfication of the famfs-fuse patchset.

 - extent maps are assigned to a backing ID

 - 64 bit backing ID's managed by server

 - maps can be linear or cyclic (striped)

 - API supports nesting, but not implemented yet (i.e. multiple striped
   extents per inode, a-la famfs)

libfuse/famfs trees for testing:

 https://github.com/szmi/libfuse.git#extent-map-v2
 https://github.com/szmi/famfs.git#extent-map-v2

This patchset:

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#extent-map-v2

Passes famfs smoke test on emulated dax device.

Comments are welcome.

Thanks,
Miklos

---
Changes since v1:

 - moved 3 prep patches to fuse.git#for-next
 - introduce FUSE_PASSTHROUGH_V2 (Amir)
 - lots of small fixes and cleanups (Amir, Sashiko)

---
John Groves (1):
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

Miklos Szeredi (7):
  fuse: add helpers for EIO return value with kernel message
  fuse: support 64 bit, server allocated backing ID
  fuse: support opening 64 bit backing ID
  fuse: add support for opening dax device as backing
  fuse: add extent map data structure
  fuse: add extent map I/O support
  fuse: add support for striped backing

 drivers/dax/super.c       |  38 ++++-
 fs/fuse/Makefile          |   2 +-
 fs/fuse/backing.c         | 292 ++++++++++++++++++++++++++++++-------
 fs/fuse/dev.c             |  21 +++
 fs/fuse/dev.h             |   3 +
 fs/fuse/dir.c             |   3 +-
 fs/fuse/ext_map.c         | 299 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c            |  16 +-
 fs/fuse/fuse_i.h          |  72 +++++++--
 fs/fuse/inode.c           |  17 ++-
 fs/fuse/iomode.c          | 108 +++++++-------
 fs/fuse/notify.c          |  75 ++++++++++
 fs/fuse/passthrough.c     |  63 ++++----
 include/linux/dax.h       |   6 +-
 include/uapi/linux/fuse.h |  53 ++++++-
 15 files changed, 904 insertions(+), 164 deletions(-)
 create mode 100644 fs/fuse/ext_map.c

-- 
2.54.0

