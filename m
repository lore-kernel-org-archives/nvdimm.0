Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF074C9DEA
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 15:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792163847; cv=none; b=ah91OoKq76hkdIw2nZ4XymEaJdN+/F6xbvWuNrhMqNzOCMy2wpwlwA6SFDtGRuXSV7EoQhc7VNFtOKZFZupmPfvbHafAZFOiwuZAlLfmFuxvdVhrNjLybcUXBx15ViiDAPGmy2z/dVM3HQ9OdyyGVFhp3z3Dl4mcW2CgWA6HlI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792163847; c=relaxed/simple;
	bh=YxnZvwd57GKZBvpC2GbbHw9D3LkU97A3oVoH0EYOGNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=faznusLIZwbsu8nvY3cC+LkPHfgdMfeIeFw6yQnSHxacBjpNyTItbRsqvQFWRidEbyu+VAq9j/y/0A0MTM2NQJeRciOTaUR2AewE+YAXYRTSaq6SraYynwbIgQPADL63eBMdjCE/ZjqCnp3XO5e6RHFHB1zyDroVP+wJ+jf/IyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gg4KoFCd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gg4KoFCd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792163843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8E4HluxTqTz4GH5KzcjRySdZqvF11U4sB58FTslbo0s=;
	b=Gg4KoFCdC9Gd9f//HwcSU3bu2lzgYbXRexF2A8S7xynl3TBoG1HqR6kL8t+pu78rM7k/a0
	t1YBuUIGT7iGZ2xC4jqryhx8x1SugIbN9wQJ4/W2fszMqBq0HWgFp7dDtcZljERhTs8Fbz
	XGXLrLi8Ma8jqS3VFfnvd7ir+vxHTW8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-8TivB8vYNsucUagpd7nupA-1; Fri, 16 Oct 2026 15:17:22 +0000
X-MC-Unique: 8TivB8vYNsucUagpd7nupA-1
X-Mimecast-MFC-AGG-ID: 8TivB8vYNsucUagpd7nupA_1792163841
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so613955e9.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 08:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792163841; x=1792768641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8E4HluxTqTz4GH5KzcjRySdZqvF11U4sB58FTslbo0s=;
        b=ob2sTNQyJSooGAHU5e7X++ckrKCnxZp6cjtzQJ0Xuz6vNGd3BwNibl3h9vYY6eu7KK
         /9t4eoSvH6V8Fnlx9sV320a/IZ8rOofC2XhvNcxzL8UR5djyXqFSaV6ESkj/VAqkajNV
         vI6ntuOmG3e72jmpII1Nkc9ZNLYZ2FDgZpUjcndDUesLhwUv8h8hbXCjutczf2LlUqtA
         YAMytSlBpZmS6eLf+ijVU2jYdKUlT3+yJ5Pk54/nCM1eqovWYluK5Nux5hhgm7661r/D
         /mMAeEabqwsFmGu5k9z3cOtc6JqL4hKtC3V9hm9ti9jxmDaOrpPoIrF56OvdS9/i3LEc
         195Q==
X-Forwarded-Encrypted: i=1; AKwUvByZOUoJwyZnCnjiRprmDU6dO90sCfEXyn+5lhIdx3bZjIWzwE/TMILNZMWUjbXkxTVgKNwEsQQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ1HX7YOqHfL8fXIJN4blpIbK5yL1DPYG3ioa1wxjm2sPXkJbVh
	rxZo/tjiKNLdqJttnjFUx+Y9f3pfBIphS6SJEjTTF4f9LKhuPCYv8euN5tQlGVkcWDvizeTufiv
	+0ek/zI6Ui02tbGKjN7XpCGye1J9GvegxVUGpnc/sPgn7zRyLZ1vzvW8huA==
X-Gm-Gg: AYBFou0QjMAeaTKzPupd113Tkg6XkLKB2fFBAaUHpOkXRIt2NTWrZ3a85g+dKta/nZh
	d/LjXCUIsIaaKll1euuI+fASCKY1BUWhXyKEWbTbbdYBOw02tTC3zL2eNqY/lq0G7FQHNARz05a
	jWcMQvlu7glML3XMRIBpJnrkBQl2QViAIed35Ot4al/dh7dLhFMFQDI41FQ4PCIcTu9486wDN4t
	sNIDdMz6tf079YJ19BgELZnbvx8DC1g8OpFPQxZyYK3n5FOUYeUTihOHGZLIkn/m/8xZfbOPdZL
	8L/+VOm+lu5jPI/BAX+3qJ2kTkWl5HokQRzURNBgZKK79dPmyvAfsJk/wFku5QqrDd7AwJ4IFkz
	KJsQH8ITikysupHL3+aPqPQ==
X-Received: by 2002:a05:600c:4fc8:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4a1d75acc6amr3391675e9.2.1792163840838;
        Fri, 16 Oct 2026 08:17:20 -0700 (PDT)
X-Received: by 2002:a05:600c:4fc8:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4a1d75acc6amr3390515e9.2.1792163840004;
        Fri, 16 Oct 2026 08:17:20 -0700 (PDT)
Received: from maszat.com (85-67-2-18.pool.digikabel.hu. [85.67.2.18])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1c8de7230sm64621665e9.14.2026.10.16.08.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:17:19 -0700 (PDT)
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
Subject: [PATCH v5 00/10] fuse: DAX device based extent maps (famfs)
Date: Fri, 16 Oct 2026 17:16:27 +0200
Message-ID: <20261016151638.2962413-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uOBr6po_61N2oFtgtWMpiKk6s8btWGpd8qlDP450J9A_1792163841
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
 https://github.com/jagalactic/famfs.git#master

This patchset:

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#for-next

Passes famfs smoke test on emulated dax device.

Comments are welcome.

Thanks,
Miklos

---
Changes since v4:

 - extent array (John)
 - error out on truncate/hole punch on a dax backed file (Sashiko)
 - small fix (Sashiko)

Changes since v3:

 - redid the first patch (prompted by sashiko: passing dev_t is racy)
 - more fixes (John, Amir Sashiko)

Changes since v2:

 - add a trivial prep patch modifying drivers/dax/super.c
 - reserve zero value for 64 bit backing ID (Amir)
 - add Originally-by: tag to acknowledge John's work
 - more fixes and cleanups (Amir, Sashiko)

Changes since v1:

 - moved 3 prep patches to fuse.git#for-next
 - introduce FUSE_PASSTHROUGH_V2 (Amir)
 - lots of small fixes and cleanups (Amir, Sashiko)

---
John Groves (2):
  dax: add fsdev_dax_from_file()
  fuse: resolve extent maps in O(1) when possible

Miklos Szeredi (8):
  dax: use READ_ONCE() in dax_holder()
  fuse: add helpers for EIO return value with kernel message
  fuse: support 64 bit, server allocated backing ID
  fuse: support opening 64 bit backing ID
  fuse: add support for opening dax device as backing
  fuse: add extent map data structure
  fuse: add extent map I/O support
  fuse: add support for striped backing

 drivers/dax/fsdev.c       |  23 +++
 drivers/dax/super.c       |   5 +-
 fs/file.c                 |   1 +
 fs/fuse/Makefile          |   2 +-
 fs/fuse/backing.c         | 302 ++++++++++++++++++++++++------
 fs/fuse/dev.c             |  54 ++++--
 fs/fuse/dev.h             |   3 +
 fs/fuse/dir.c             |   6 +-
 fs/fuse/ext_map.c         | 376 ++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c            |  33 +++-
 fs/fuse/fuse_i.h          |  79 +++++++-
 fs/fuse/inode.c           |  25 ++-
 fs/fuse/iomode.c          | 116 ++++++------
 fs/fuse/notify.c          |  75 ++++++++
 fs/fuse/passthrough.c     |  66 +++----
 include/linux/dax.h       |   3 +-
 include/uapi/linux/fuse.h |  53 +++++-
 17 files changed, 1044 insertions(+), 178 deletions(-)
 create mode 100644 fs/fuse/ext_map.c

-- 
2.54.0

