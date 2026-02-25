Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08F387353
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 23:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772063089; cv=none; b=UB5DStx6GllQd2Qga0wByDLrMCpAqON5Z8Exv3Dq7oYb8q0CrieQv+7ooyKvAMzWb615PRc0CI+WZP3t7RgxhrUL+rvrJ3/1+aav0crkLUYBHelfbMfQCgttRVpb9NGxOHUPY1mmdqJL4avflixNJnGb1L0CRS6MPHcO3u31wSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772063089; c=relaxed/simple;
	bh=gYLxuKpY2d3qKNQKxivfKoBOKiAm81D0oxjvJeYJzNU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hF1jMcFEoOZlSbr6q5dI1eLqhTBjFW6+vvReOJt4qy/3F9TOWufS5tVeF2bl8qG+xtRJIhrNm2LybidPd0yUJxpORbt3MmixsiyTlIpP/R2zDYQwJE1mNzBN6koxKgLpfZguL40iKBk2cdh7p6ozgPwzDA/x8kSFz4KFVqUv7Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=U1PIVhaQ; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="U1PIVhaQ"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNN5G1338710
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 18:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Q1k2
	aRLcgmydoMd1dEiHPTc9xxnOTAMtx9b+CM6PXh0=; b=U1PIVhaQRwd3nbrNnYtm
	L1no1lMCV2YmzeST//Dp/v7B3/cqL4T65QQrGFeq4b08zK5Y2bNTbh+NZ0dvRq8L
	fWxAXdfzylJQAflLxh8iC6HUOyaR7ki6/xPgiP+/NrizW4D7zaK1w0+W4ErGSFUd
	W0ErFErP2OIoxqkEv58jTOIg5iLwKzU7KKkGTTglXZHlYByD0dZEd4gm2XRonTBf
	IAwk64JaWJh5SI6PlHFHgjkB1xFbM72XAqyzdYvOCmP5fAPuCzBajwGH0E/vZsKp
	WVFnR0ForMBT3YjkIm2sCMYMPztXn+cqf57JO1rCfMS6vvmcio9eEyqAYlqMbGkD
	Vw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4chywywwtn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 18:44:45 -0500 (EST)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-896ff58f17aso27416446d6.2
        for <nvdimm@lists.linux.dev>; Wed, 25 Feb 2026 15:44:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063085; x=1772667885;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q1k2aRLcgmydoMd1dEiHPTc9xxnOTAMtx9b+CM6PXh0=;
        b=Q3zQNrmy1xfWdlqnUgYorCaq+mGVroDo04oqs6l/O0FY1JI+Lp6oOMjfZ0H7Ky+yeT
         Q3r5FPxynxMVu+8BHk1HO+0GhuzL//O4ZwEzEARo2Z8frXcCps3uxxuCVYmnFqrC35Au
         VVPUffuB/hr0CLYbvzYmFu30g+3iVIdVrlpNWwJpgSMSNKpgmLl2MhWvppR/dxpUEfGx
         9xEaIsUM130VlmVKpDCy6tGjTR+mDtOfhJoRV+6LpiCOc8glaz6vJmmVaM9sFrDbOT4C
         UTebW/BhjUuB4COqBwIWG9BHm/6ITT8B4+BMQvdAO/XuIG6hDRfa+0qJH9TKo5MOVFKJ
         jNJw==
X-Forwarded-Encrypted: i=1; AJvYcCUiYM4NsZJR0FpbbE/+qGU6kgsMGkL4yVEUoQsh684vjHoq4BqXb6jCOE50ToR8VklYgbBfJcw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxdq2MM5d28d+u+Um485Barsg9rlu6x3jS+QRQwOAb2Z0X1QbLc
	AcM0gOCONhLWwSOOe7Q0bO2e/0NIKWT0mfoIokFvA7ASXMff+NrEiZCIaMkPLWVqc3KTuJcxaBv
	KsqOabqmJq9SG81CD0UesdCydhtj9Vvipj/A32+vu5V1y9VeBW6MXOg==
X-Gm-Gg: ATEYQzxDy4aOY+ToRk72EvWgGIJhDC+PP38wJNGoGY/UEGf5C91Wb6QLNO6LcZxFoKs
	38EJolvqL2qBRAzyPcKxYGciMBENquTHUgC6yT9tkolz/zqy781l+1iuHtYdqgpU2kwhk7xH9Tt
	fjBJtEKXiXUchRfdXLWSDjl8gM7M+uzzpskTCyMs+Kej/BJglQubQLvUz0cglR9gN3Q+N3rXYG2
	b3GhdJVYDw3mGDzFtbriHaVz4v7kVbcoFqGphnyKh7gRNCgPSo6y+BZoG1LO61xrllqVPXBJ1ni
	KUuwqJMWznO2Sb15zDOF5aVvdF/Yr0i1VVyXoCrEvD6vYpLF5JmlNxO/aaxuv3rVCEapnTFsMH1
	S4BFQIdw4f9AfOzGwvHSWy1aPwmr7UZEL
X-Received: by 2002:a05:6214:21ea:b0:895:7864:f69a with SMTP id 6a1803df08f44-89979eedb2amr279116946d6.46.1772063085059;
        Wed, 25 Feb 2026 15:44:45 -0800 (PST)
X-Received: by 2002:a05:6214:21ea:b0:895:7864:f69a with SMTP id 6a1803df08f44-89979eedb2amr279115656d6.46.1772063084415;
        Wed, 25 Feb 2026 15:44:44 -0800 (PST)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c738d80bsm3357606d6.41.2026.02.25.15.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:44:43 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:44:26 -0500
Subject: [PATCH v2 2/4] fs: Remove unncessary pagevec.h includes
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-pagevec_cleanup-v2-2-716868cc2d11@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772063077; l=5646;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gYLxuKpY2d3qKNQKxivfKoBOKiAm81D0oxjvJeYJzNU=;
 b=0+QFbVO+EVyu3LcoNlltI7+0YkfiOzPAREHRqHF+/vRJBoggqFw4V6DeYqoYE35EGaZ0z2yM5
 xg7WRatCQDeAtdc5+Wn8weZAkk+lk9tyDOPYyXE2pnCtDyQNUNup7UV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: cNyZbGnNmEwtxmyU67w-DIkPseG7bzzK
X-Authority-Analysis: v=2.4 cv=ccTfb3DM c=1 sm=1 tr=0 ts=699f896d cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=_wBAnLaIECucki5onNwA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyNyBTYWx0ZWRfX8G6DPjZ5cl8Z
 hdLIxKsXIm6cz8HkQxKo2AijJ4xDA2h92AKA3nRWjsjbaD0BtnQY4fGn9lItFtr4TttVYirOQyn
 Rj+Ms2Z5PLcuyrwQLMUPEGM7vFVmeMLebAvrkgNgJrbb30/GtKUZWQanSA/lunL8nKnNXl1/zr5
 cE7PuTmJ2WZL08srM3vJxtaEVsqwSW2N/phcSHjSA9IMWUozYHbuJRA3dPyXcu7Ycj3LITIIgcJ
 xL0mvAJENz02Xx9UXrTZbOC8qxWUWl2xXdxJ/Js+YTO800Jv7JneWE6BiUQiL7p1zc77+BgKpJz
 /hXxYLHaU+hnosGcy23Ztry22/YlqhtemzyA6EY1GMR+AEeH4AtYsfC+rouCiG+B2pMiKxIE7eo
 EmH6BANEkfFYOQuMi/Y+k3nC3PmDGES6Qzf7WHYHcv9/qzKuKJ3/54ryoyJcXKug41rjHVD7hHl
 gj61OKjy6Ki7PHtmFOA==
X-Proofpoint-GUID: cNyZbGnNmEwtxmyU67w-DIkPseG7bzzK
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 adultscore=0 clxscore=1015 spamscore=0 impostorscore=10
 phishscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250227

Remove unused pagevec.h includes from .c files. These were found with
the following command:

  grep -rl '#include.*pagevec\.h' --include='*.c' | while read f; do
  	grep -qE 'PAGEVEC_SIZE|folio_batch' "$f" || echo "$f"
  done

There are probably more removal candidates in .h files, but those are
more complex to analyze.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/afs/write.c                   | 1 -
 fs/dax.c                         | 1 -
 fs/ext4/file.c                   | 1 -
 fs/ext4/page-io.c                | 1 -
 fs/ext4/readpage.c               | 1 -
 fs/f2fs/file.c                   | 1 -
 fs/mpage.c                       | 1 -
 fs/netfs/buffered_write.c        | 1 -
 fs/nfs/blocklayout/blocklayout.c | 1 -
 fs/nfs/dir.c                     | 1 -
 fs/ocfs2/refcounttree.c          | 1 -
 fs/smb/client/connect.c          | 1 -
 fs/smb/client/file.c             | 1 -
 13 files changed, 13 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 93ad86ff3345..fcfed9d24e0a 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -10,7 +10,6 @@
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/netfs.h>
 #include <trace/events/netfs.h>
 #include "internal.h"
diff --git a/fs/dax.c b/fs/dax.c
index b78cff9c91b3..a5237169b467 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -15,7 +15,6 @@
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
-#include <linux/pagevec.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/uio.h>
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f1dc5ce791a7..5e02f6cf653e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -27,7 +27,6 @@
 #include <linux/dax.h>
 #include <linux/filelock.h>
 #include <linux/quotaops.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a8c95eee91b7..98da200d11c8 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/mpage.h>
 #include <linux/namei.h>
 #include <linux/uio.h>
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 830f3b8a321f..3c7aabde719c 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -43,7 +43,6 @@
 #include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 
 #include "ext4.h"
 #include <trace/events/ext4.h>
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c8a2f17a8f11..c6b6a1465d08 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -17,7 +17,6 @@
 #include <linux/compat.h>
 #include <linux/uaccess.h>
 #include <linux/mount.h>
-#include <linux/pagevec.h>
 #include <linux/uio.h>
 #include <linux/uuid.h>
 #include <linux/file.h>
diff --git a/fs/mpage.c b/fs/mpage.c
index 7dae5afc2b9e..e5285fbfcf09 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -28,7 +28,6 @@
 #include <linux/mm_inline.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 /*
diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 22a4d61631c9..05ea5b0cc0e8 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -10,7 +10,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
-#include <linux/pagevec.h>
 #include "internal.h"
 
 static void __netfs_set_group(struct folio *folio, struct netfs_group *netfs_group)
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index cb0a645aeb50..11f9f69cde61 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -36,7 +36,6 @@
 #include <linux/namei.h>
 #include <linux/bio.h>		/* struct bio */
 #include <linux/prefetch.h>
-#include <linux/pagevec.h>
 
 #include "../pnfs.h"
 #include "../nfs4session.h"
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 2402f57c8e7d..0d276441206b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -32,7 +32,6 @@
 #include <linux/nfs_fs.h>
 #include <linux/nfs_mount.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/swap.h>
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index c1cdececdfa4..b4acd081bbc4 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -31,7 +31,6 @@
 #include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/writeback.h>
-#include <linux/pagevec.h>
 #include <linux/swap.h>
 #include <linux/security.h>
 #include <linux/string.h>
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33dfe116ca52..9e57812b7b95 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -20,7 +20,6 @@
 #include <linux/delay.h>
 #include <linux/completion.h>
 #include <linux/kthread.h>
-#include <linux/pagevec.h>
 #include <linux/freezer.h>
 #include <linux/namei.h>
 #include <linux/uuid.h>
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 18f31d4eb98d..853ce1817810 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -15,7 +15,6 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/pagemap.h>
-#include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/delay.h>

-- 
2.39.5

