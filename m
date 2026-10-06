Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157FE376A01
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309687; cv=none; b=P15O6OIIvqlUc7HIMMQU2dddy0PMHXYjZ4fXjnZrWjnerO3478NpCET1owllg5iGCThvL0sQYzWC6KJcl5zeSjtJn7lFAnJCv+T4Un/NRUJ6q0zDRAfaquZpC17r+J0eN/rV/xmIcKjFjeveudqDgmMkEkDD8cglGbBNB5UnzYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309687; c=relaxed/simple;
	bh=khjQoA76ImVEwNZsVeK3BoShKiZnAqrp47XzOo+pGQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=dmJtCmO2YV3InQPmril5hwVQq4gKDUuuFe38wWeCRWuzx+O848rlXDxxQkBGknUOmTGw6oZXpSyBknfHU1NrgMTDz+W8oWXVpB+dOOtlWt37a97BJvSLCRPwbZdrvBEd04vboKKbgnJeWxAdNo4K6NMvHk1cK8Uk0kZy7l2Msb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGk3QdKz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGk3QdKz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791309684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7MTZcSt4JfCHhin1MairClvPsblFEaazbyiSbWW2Ywg=;
	b=CGk3QdKzcSp01DZ/00rj4TgRV+m8vyAUjxRX1Y9vekJXnjzB7Cza3GkMcIWZaVX5Y28vBw
	WnwBgil4suGLllPS/rwLTvEK2UWom6vdiDXyzkj5Cg3JtCuCnhoYf5QlvW3h46pKuOsymr
	ZJ3BnaYhcoa/Zh79GzDRfADhBFu6b+M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-Sv4NyQhBMc2U8Z7kWYswjw-1; Tue, 06 Oct 2026 14:01:21 -0400
X-MC-Unique: Sv4NyQhBMc2U8Z7kWYswjw-1
X-Mimecast-MFC-AGG-ID: Sv4NyQhBMc2U8Z7kWYswjw_1791309680
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a9cdcbe249so4627009a12.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Oct 2026 11:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791309680; x=1791914480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7MTZcSt4JfCHhin1MairClvPsblFEaazbyiSbWW2Ywg=;
        b=vJFu7o9MTiEz5CMZQckDU91TrOntahhBv5gog865cano626nhUcA1jLi/G2yM8cYVV
         HhRjIqxbneTx2hoUxRR8B7Nhk43KBeSVgMyDrcmSOhHETGdzkQ1cSaKuF1+Ag08AwkdG
         xdi7KFy2n58Rt0ev3X9rndaeRBlcmz0HbjibYmizrcU5hzXG/wi7RN0fx+Oryppq1riY
         Bh/8ni19j+CaUnYlfuu5jG8xSan7ynznrkGBkRKeKybXlUt9Bu8UchwveUeTM7pAKptc
         L93qgdrKjuUSWo61D38XhXWACOWD3K2G5DdtngWQUHvN1I+dzN2AZSHQPDrsKSunjVvG
         I21g==
X-Forwarded-Encrypted: i=1; AKwUvBx2oCsVMqwSIW+bhBOCL11IrpOjurUuSVmtuosJhq80Go8IyZgVl448CZVffKrQVdqcRHyUoz8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJrjETiKvl0hyM62K0SyaHJ52ItP0i6sVMykgoOMmIa6yW4APXR
	8aR/is8cjF+sVZ7UaGbVXyHFcQ6fosoGy/SJVPWp+Al0QGodsO8AI6CHZ+uMShIsi4dXO/TH45S
	euSuf6nSLXU7CJx1YVaelaazZk3H2Eh9w5tHIOpZjmV8chru0ZBmnsLw9Kw==
X-Gm-Gg: AYBFou00uLPNmutQgYUgoX4+H15VfmycdvKUMTBbJCFlF6VgjIrv3PhWYticb71Ze/S
	iiOrD1EgCEIdJUdlJIe3t851pHw9x8Zg/9PQRL4hiCHwVQAOFRSrqnqTkgH1AuljyA/UVTXxFlB
	r5w2g2evYszLpmfgvsRBOR0q5uFfICj4vuSa1H5em7H6cEZenxZAFKGdl6X3ooDnGbreFLjcsG7
	PWM5iXqZMCOw0ooiZ8XHu1GrhoHZrc+PYliW0m2JzsnL2UxVaOoxUoFIW3JuAQOIffyOn6M4cXN
	1xHZa97IwKbW9BhDMYjtIGs3r4lQHmIsKLr54a2YMIda80DD8jNczMd6wZX427WwajYHivQADYT
	b8XYceYLp4Z5Fx61N8vooAqWj36dO1e770eECd9wLDOWdy/KPsdp/5y6J
X-Received: by 2002:a05:6402:13ce:b0:6aa:f7f4:24b3 with SMTP id 4fb4d7f45d1cf-6afe29de45cmr2370956a12.35.1791309680446;
        Tue, 06 Oct 2026 11:01:20 -0700 (PDT)
X-Received: by 2002:a05:6402:13ce:b0:6aa:f7f4:24b3 with SMTP id 4fb4d7f45d1cf-6afe29de45cmr2370926a12.35.1791309680029;
        Tue, 06 Oct 2026 11:01:20 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (188-142-152-55.pool.digikabel.hu. [188.142.152.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb01e5942sm5056684a12.9.2026.10.06.11.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 11:01:17 -0700 (PDT)
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
Subject: [PATCH v3 0/9] fuse: DAX device based extent maps (famfs)
Date: Tue,  6 Oct 2026 20:01:05 +0200
Message-ID: <20261006180115.1425232-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Di6BRe1_atSrvaQqIKlrAdPQ2gt6aW912yEIqWTG79k_1791309680
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

 https://github.com/szmi/libfuse.git#extent-map-v3
 https://github.com/szmi/famfs.git#extent-map-v3

This patchset:

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#extent-map-v3

Passes famfs smoke test on emulated dax device.

Comments are welcome.

Thanks,
Miklos

---
Changes since v2:

 - add a trivial prep patch modifying drivers/dax/super.c
 - reserve zero value for 64 bit backing ID (Amir)
 - add Originally-by: tag to acknowledge John's work 
 - more fixes and cleanups (Amir, Sashiko)

Changes since v1:

 - moved 3 prep patches to fuse.git#for-next
 - introduce FUSE_PASSTHROUGH_V2 (Amir)
 - lots of small fixes and cleanups (Amir, Sashiko)


John Groves (1):
  dax: replace exported dax_dev_get() with non-allocating dax_dev_find()

Miklos Szeredi (8):
  dax: use READ_ONCE() in dax_holder()
  fuse: add helpers for EIO return value with kernel message
  fuse: support 64 bit, server allocated backing ID
  fuse: support opening 64 bit backing ID
  fuse: add support for opening dax device as backing
  fuse: add extent map data structure
  fuse: add extent map I/O support
  fuse: add support for striped backing

 drivers/dax/super.c       |  40 ++++-
 fs/fuse/Makefile          |   2 +-
 fs/fuse/backing.c         | 305 +++++++++++++++++++++++++++++-------
 fs/fuse/dev.c             |  24 +++
 fs/fuse/dev.h             |   3 +
 fs/fuse/dir.c             |   3 +-
 fs/fuse/ext_map.c         | 316 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c            |  18 ++-
 fs/fuse/fuse_i.h          |  78 ++++++++--
 fs/fuse/inode.c           |  26 +++-
 fs/fuse/iomode.c          | 116 ++++++++------
 fs/fuse/notify.c          |  75 +++++++++
 fs/fuse/passthrough.c     |  63 ++++----
 include/linux/dax.h       |   6 +-
 include/uapi/linux/fuse.h |  53 ++++++-
 15 files changed, 965 insertions(+), 163 deletions(-)
 create mode 100644 fs/fuse/ext_map.c

-- 
2.54.0

