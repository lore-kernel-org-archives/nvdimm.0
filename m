Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29785387591
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 23:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063096; cv=none; b=b/JgDRAoI2B2S/FE6cbYn+mvoO2/pybp/3gSYYptzs2kvNbXVKiziEPv+W64F14SVohuZ/59FRtpg9nu1AhMnVves+yvgyAob7x1FlFYbBGoWi16gNnTS3uqlrcK5s3rRFd4QWY6+a5ZvCKgmGDjWYWycazylQ0zAG0Zr0GMfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063096; c=relaxed/simple;
	bh=89ejBUbJAbl9gMJxu0YjzDjYEINzrXDJ4zlC90ZjW70=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ed7y+ru+JE59Tg4U3JUdL6Cs4Pplt4Y0OT6e4xUAR+iZD7kuVSR5DFhfdR+j+VrgNMs6HCuBSoL0UOPIGN2GyeWolO62Sqr4hK2iCJ9OBSoqLSURQlcGRfaOhQ4c3fY7CAAdMHskp3TDi7nSmCHt7tbSOkeW0Qkex0i8kNFkJho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=KoW+Dwoa; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="KoW+Dwoa"
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNN4s02878354
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 18:44:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=aPwS
	t3hNTFLah6XnifhLIiPsp4G0eC4H6I7+g5VD+/A=; b=KoW+DwoaLBgIKKp07zkU
	w6LYikbpCWQdrh8W1nzdyxYpkzLEcclQRcT7hkkJaTTe33MpHaIr+E7mV91Tq/bL
	SSiXdSa+Gguo6I/AW/mctmElGMAmkjDC+H2jI36BoHDA7GKVhEHL7OJPnGLlvEtT
	4BTdKWrcZuavMXt9r5oc/wjjaziypL86FswUmtKMi7y6Z6HU9iS0yuI9a8I+b0P6
	C+9RwDMULkiKD/iD9k3Sj1JnVFSLbkH0d37CIXOpEzab4zAj7ZLAs5c42CcZAvY/
	y6VP7ocVtll9BIBDwonFGbm0jimM+NTHDOvcuRroLMGuOZKT2Zb5ZQ5D6pO86jQn
	BQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chnrtr686-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 18:44:48 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c71156fe09so141131485a.0
        for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 15:44:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063088; x=1772667888;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aPwSt3hNTFLah6XnifhLIiPsp4G0eC4H6I7+g5VD+/A=;
        b=oaYTvaz4tSZ0sgRNac5LsdDn81WMIu9KYS7ZLsQPg9l77RxsU1s/NUpicKDT/NBhSe
         m4JRN6CWwOBE5ao3K1I05dD50SFkLYvj8FtXF2XI/N3Le51ulvkM8nc8+6SpLK/U0DaY
         cNBufvBd76vSXZRcOe730qk0v1u96y1B1saMjQ//2juFMYPTpdJs4lEm3ybehmTyXk6i
         WkYM/hp6Dz9AxRy5LtH9SfrLIm7bz7P/3BjmyKL0+rPeUWFpUuH8+dYsD3KkIIBPY7cf
         G/0sAO19mATcAG3+szG/n0d4VDOWEPDpWHTICkznvCtHtUCoXhD1/eiXqvo4/hqQv+0q
         pE+w==
X-Forwarded-Encrypted: i=1; AJvYcCW605ihIXLem4zVEhfURWw6I1VOcR8uDmRSngCpeg0JyDXMiJsNzuNv4ks4YHOMbiyQBRGpSJU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUwuaMkPd5gXmVKEi0PAPSug0ToPEWgCw68uNlrnXfayViWFLR
	8K/pT6+HwbzG78VGzhU49xyqh6v+aAFxaiAYUInQK4JBm81pHFCKooObw/0d08NYu5VloX3/0rN
	6MbccNGtdsyReq0NDOFuNYRZoQxTHh1MtwyDwVSOSAXabvBGkeKn/XQ==
X-Gm-Gg: ATEYQzwpHY3GNn1NKw/RQzo+tVW9GHwNAYo3i76ec3KR4cpJjd7DibXb/lLZPy9fASj
	+ihd21cw7RvnThL+uEeZaoLGOWiskcWnYp8ydo4QOVdnY+eAfIC5JXlEs8VWD0J6kqHU4o985Kl
	3Lc42J4ehw7wdWiajQl9t0ElQz6kaFwEWuHQ4a3QpvRc5J9Z+erbOX1Qkx9wH3eO6KG3jHnGRME
	CtdY57Nu1LJmuCK4WumkaTbC8mTIDGLm0/uCxG06vB8W7dpiYSu/Vj+HedSPBztudAeH3A503ev
	oC/SWAvbI1FNqZ7MxWY+UsBEAgn4oUL+EJtjnbvOaWSezf0dB9vLWWDL9P0bwIdwP1pQmBIz13I
	whNpZjgA+G8LRj3C3y8S2zUud/iGDwXjv
X-Received: by 2002:a05:620a:298c:b0:8ca:d5cb:6844 with SMTP id af79cd13be357-8cbbcff7196mr323699485a.49.1772063087784;
        Wed, 25 Feb 2026 15:44:47 -0800 (PST)
X-Received: by 2002:a05:620a:298c:b0:8ca:d5cb:6844 with SMTP id af79cd13be357-8cbbcff7196mr323686785a.49.1772063086986;
        Wed, 25 Feb 2026 15:44:46 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:46 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:27 -0500
Subject: [PATCH v2 3/4] folio_batch: Rename pagevec.h to folio_batch.h
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260225-pagevec_cleanup-v2-3-716868cc2d11@columbia.edu>
References: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
In-Reply-To: <20260225-pagevec_cleanup-v2-0-716868cc2d11@columbia.edu>
To: David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Paulo Alcantara <pc@manguebit.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Ilya Dryomov <idryomov@gmail.com>,
        Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
        Dai Ngo <Dai.Ngo@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
        netfs@lists.linux.dev, linux-nfs@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org, gfs2@lists.linux.dev,
        linux-nilfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        cgroups@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=17408;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=89ejBUbJAbl9gMJxu0YjzDjYEINzrXDJ4zlC90ZjW70=;
 b=DZR7t8/xTD2RV8IcGDVSrVRbyHqSjvi+mmPKtQKoMAq7YXgwLRBOLtA12ryjIBbsZ8xRvPgOR
 iq+s155nXzBDa4/nkNXPNn2pWi+s7DCbvZYs9/y3NwEhX5dVRbKSlDM
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX2WfvraOZAf+r
 mX9cxVjWLVLDDYQ83eGrWeR/iapKcUdsiz7+eNs4+bzLXsVxIJ4H9DBt9euMtK70ZlZ6jmVTuHf
 tr0T2NP88hXl5zoRYA+VWaYKu1r1C4vYSr5f9qSC+oR2rD4UaVfXyk2RJsJ6HAD5ibAVskBO4dN
 4SUn3V3C9btuCwKm2v4XM3fCuTTYSBFBQDPhdbt/YLpmGDSH/6ZBU1y0ZnQIJ4+3AcSEz4ncxba
 7485hcmzQ4Bl5Uld7VWfob5ZjuN8P52+7lHsPnGX8bsmt1ZC23HBENeB0CaUzwdZLbuEqwbU91i
 PDZjmr+kwix+Lt29B1npjMjFobjKaHHh7KWRQ4wVJ7S8+R8rk7fD5qliHtRx2BfNL4LJFvEv5yr
 m99G8otstzbwQpRXY1jzyvi1v2DCINWyYy5NLWSjWT/lB2BruSepkJKgjA0j0+YGYqi8HJvTD1v
 cQ9vkZ288TMXRtdSl0w==
X-Authority-Analysis: v=2.4 cv=bcRmkePB c=1 sm=1 tr=0 ts=699f8970 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=1-S1nHsFAAAA:8 a=37rDS-QxAAAA:8 a=VwQbUJbxAAAA:8 a=_gStYsYcyfV-qr5JuIkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
 a=gK44uIRsrOYWoX5St5dO:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-ORIG-GUID: 9ADP-wvvD3aVRMF-OA6hhNZV-asNz9cb
X-Proofpoint-GUID: 9ADP-wvvD3aVRMF-OA6hhNZV-asNz9cb
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 priorityscore=1501 phishscore=0
 clxscore=1015 adultscore=0 impostorscore=10 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227

struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
pagevec"). Rename include/linux/pagevec.h to reflect reality and update
includes tree-wide. Add the new filename to MAINTAINERS explicitly, as
it no longer matches the "include/linux/page[-_]*" pattern in MEMORY
MANAGEMENT - CORE.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 MAINTAINERS                                | 1 +
 drivers/gpu/drm/drm_gem.c                  | 2 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c  | 2 +-
 drivers/gpu/drm/i915/gt/intel_gtt.h        | 2 +-
 drivers/gpu/drm/i915/i915_gpu_error.c      | 2 +-
 fs/btrfs/compression.c                     | 2 +-
 fs/btrfs/extent_io.c                       | 2 +-
 fs/btrfs/tests/extent-io-tests.c           | 2 +-
 fs/buffer.c                                | 2 +-
 fs/ceph/addr.c                             | 2 +-
 fs/ext4/inode.c                            | 2 +-
 fs/f2fs/checkpoint.c                       | 2 +-
 fs/f2fs/compress.c                         | 2 +-
 fs/f2fs/data.c                             | 2 +-
 fs/f2fs/node.c                             | 2 +-
 fs/gfs2/aops.c                             | 2 +-
 fs/hugetlbfs/inode.c                       | 2 +-
 fs/nilfs2/btree.c                          | 2 +-
 fs/nilfs2/page.c                           | 2 +-
 fs/nilfs2/segment.c                        | 2 +-
 fs/ramfs/file-nommu.c                      | 2 +-
 include/linux/{pagevec.h => folio_batch.h} | 8 ++++----
 include/linux/folio_queue.h                | 2 +-
 include/linux/iomap.h                      | 2 +-
 include/linux/sunrpc/svc.h                 | 2 +-
 include/linux/writeback.h                  | 2 +-
 mm/filemap.c                               | 2 +-
 mm/gup.c                                   | 2 +-
 mm/memcontrol.c                            | 2 +-
 mm/mlock.c                                 | 2 +-
 mm/page-writeback.c                        | 2 +-
 mm/page_alloc.c                            | 2 +-
 mm/shmem.c                                 | 2 +-
 mm/swap.c                                  | 2 +-
 mm/swap_state.c                            | 2 +-
 mm/truncate.c                              | 2 +-
 mm/vmscan.c                                | 2 +-
 37 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4572a36afd2..f50421e65cb1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16664,6 +16664,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/highmem.h
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 891c3bff5ae0..dc4534fb175c 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -38,7 +38,7 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index c6c64ba29bc4..07025b547c94 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -3,7 +3,7 @@
  * Copyright © 2014-2016 Intel Corporation
  */
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/shmem_fs.h>
 #include <linux/swap.h>
 #include <linux/uio.h>
diff --git a/drivers/gpu/drm/i915/gt/intel_gtt.h b/drivers/gpu/drm/i915/gt/intel_gtt.h
index 9d3a3ad567a0..b54ee4f25af1 100644
--- a/drivers/gpu/drm/i915/gt/intel_gtt.h
+++ b/drivers/gpu/drm/i915/gt/intel_gtt.h
@@ -19,7 +19,7 @@
 #include <linux/io-mapping.h>
 #include <linux/kref.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i915/i915_gpu_error.c
index a99b4e45d26c..ffe5f24594c9 100644
--- a/drivers/gpu/drm/i915/i915_gpu_error.c
+++ b/drivers/gpu/drm/i915/i915_gpu_error.c
@@ -31,7 +31,7 @@
 #include <linux/debugfs.h>
 #include <linux/highmem.h>
 #include <linux/nmi.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 #include <linux/utsname.h>
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 790518a8c803..dbc634d10ad3 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -8,7 +8,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
 #include <linux/time.h>
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 744a1fff6eef..c373d113f1e7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -11,7 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/fsverity.h>
 #include "extent_io.h"
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index a0187d6163df..b2aacf846c8b 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -4,7 +4,7 @@
  */
 
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/sizes.h>
diff --git a/fs/buffer.c b/fs/buffer.c
index 22b43642ba57..f3122160ee2d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,7 +45,7 @@
 #include <linux/bitops.h>
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <trace/events/block.h>
 #include <linux/fscrypt.h>
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e87b3bb94ee8..2803511d86ef 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -7,7 +7,7 @@
 #include <linux/swap.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/signal.h>
 #include <linux/iversion.h>
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 396dc3a5d16b..58f982885187 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -29,7 +29,7 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
 #include <linux/namei.h>
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6dd39b7de11a..0143365c07dc 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -11,7 +11,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 #include <linux/kthread.h>
 #include <linux/delayacct.h>
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 8c76400ba631..614e00b8ffdc 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -13,7 +13,7 @@
 #include <linux/lzo.h>
 #include <linux/lz4.h>
 #include <linux/zstd.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 #include "f2fs.h"
 #include "node.h"
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 338df7a2aea6..90e8ef625d82 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -10,7 +10,7 @@
 #include <linux/sched/mm.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/blk-crypto.h>
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 74992fd9c9b6..ba0272314528 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -10,7 +10,7 @@
 #include <linux/mpage.h>
 #include <linux/sched/mm.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/swap.h>
 
 #include "f2fs.h"
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index e79ad087512a..dae3dc4ee6f7 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -10,7 +10,7 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mpage.h>
 #include <linux/fs.h>
 #include <linux/writeback.h>
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 22c799000edb..2ec3e4231252 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -25,7 +25,7 @@
 #include <linux/ctype.h>
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/fs_parser.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index dd0c8e560ef6..b400cfcdc803 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -10,7 +10,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include "nilfs.h"
 #include "page.h"
 #include "btnode.h"
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 56c4da417b6a..a9d8aa65416f 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -14,7 +14,7 @@
 #include <linux/page-flags.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/gfp.h>
 #include "nilfs.h"
 #include "page.h"
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 098a3bd103e0..6d62de64a309 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -19,7 +19,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/crc32.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
 
diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 0f8e838ece07..2f79bcb89d2e 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -14,7 +14,7 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/ramfs.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/include/linux/pagevec.h b/include/linux/folio_batch.h
similarity index 95%
rename from include/linux/pagevec.h
rename to include/linux/folio_batch.h
index 007affabf335..a2f3d3043f7e 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/folio_batch.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * include/linux/pagevec.h
+ * include/linux/folio_batch.h
  *
  * In many places it is efficient to batch an operation up against multiple
  * folios.  A folio_batch is a container which is used for that.
  */
 
-#ifndef _LINUX_PAGEVEC_H
-#define _LINUX_PAGEVEC_H
+#ifndef _LINUX_FOLIO_BATCH_H
+#define _LINUX_FOLIO_BATCH_H
 
 #include <linux/types.h>
 
@@ -102,4 +102,4 @@ static inline void folio_batch_release(struct folio_batch *fbatch)
 }
 
 void folio_batch_remove_exceptionals(struct folio_batch *fbatch);
-#endif /* _LINUX_PAGEVEC_H */
+#endif /* _LINUX_FOLIO_BATCH_H */
diff --git a/include/linux/folio_queue.h b/include/linux/folio_queue.h
index adab609c972e..0d3765fa9d1d 100644
--- a/include/linux/folio_queue.h
+++ b/include/linux/folio_queue.h
@@ -14,7 +14,7 @@
 #ifndef _LINUX_FOLIO_QUEUE_H
 #define _LINUX_FOLIO_QUEUE_H
 
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/mm.h>
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 99b7209dabd7..4551613cea2f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct address_space;
 struct fiemap_extent_info;
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 4dc14c7a711b..a11acf5cd63b 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -20,7 +20,7 @@
 #include <linux/lwq.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/kthread.h>
 
 /*
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index e530112c4b3a..62552a2ce5b9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -11,7 +11,7 @@
 #include <linux/flex_proportions.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/blk_types.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 
 struct bio;
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4ada..63f256307fdd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -31,7 +31,7 @@
 #include <linux/hash.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
 #include <linux/hugetlb.h>
diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..ad9ded39609c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -18,7 +18,7 @@
 #include <linux/hugetlb.h>
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db59fad3503f..51508573963d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -34,7 +34,7 @@
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/vm_event_item.h>
 #include <linux/smp.h>
 #include <linux/page-flags.h>
diff --git a/mm/mlock.c b/mm/mlock.c
index 2f699c3497a5..1a92d16f3684 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -13,7 +13,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/pagewalk.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..1009bb042ba4 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -33,7 +33,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/timer.h>
 #include <linux/sched/rt.h>
 #include <linux/sched/signal.h>
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d88c8c67ac0b..74b603872f34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -31,7 +31,7 @@
 #include <linux/sysctl.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
diff --git a/mm/shmem.c b/mm/shmem.c
index cfed6c3ff853..149fdb051170 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -61,7 +61,7 @@ static struct vfsmount *shm_mnt __ro_after_init;
 #include <linux/slab.h>
 #include <linux/backing-dev.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/percpu_counter.h>
 #include <linux/falloc.h>
 #include <linux/splice.h>
diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece46..2e517ede6561 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -20,7 +20,7 @@
 #include <linux/swap.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/mm_inline.h>
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 32d9d877bda8..a0c64db2b275 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -15,7 +15,7 @@
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/migrate.h>
diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711..df0b7a7e6aff 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -17,7 +17,7 @@
 #include <linux/export.h>
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/shmem_fs.h>
 #include <linux/rmap.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7effd01a7828..7e921dbe2373 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -44,7 +44,7 @@
 #include <linux/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/oom.h>
-#include <linux/pagevec.h>
+#include <linux/folio_batch.h>
 #include <linux/prefetch.h>
 #include <linux/printk.h>
 #include <linux/dax.h>

-- 
2.39.5

