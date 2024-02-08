Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FC4364DC;
	Thu,  8 Feb 2024 18:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.114.26.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707418179; cv=none; b=kIDs7mkh37r8Mr50mwM1Cupl3WJd4RGU6dvmp4C72kYO5E9oKoS+DxjjYL5HUNioNcWQAbFfcAbG/TchkLWbLdokAV4GSudP2eCnXaGOQUEVa1V+3tUfw/D/yAIe+arT9oG6pWn4OQo3Zz7qDG98n1po1+STZNWCBb/WVpbbYYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707418179; c=relaxed/simple;
	bh=umcqlnyoni1L+YV9DQVqbsmdwpCSWY7IqX3VvZk7A10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FqHXnjR7pqXy2W6Ap8RhWmebM1EjZi0JG7bBcrrN4YOLpCFGqltr8ujNQoAzl6zLvi5o6jGY1fQtYrrPbwzS3/qbsSuN3R7fdIu4bTXy9Keo4l5AGDVG0I4UOqdGR36pdEbTz2mFyNGesD6Fe53PPSk1VI/U8NloNZlm7/8GYN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com; spf=pass smtp.mailfrom=efficios.com; dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b=FUBQbuoc; arc=none smtp.client-ip=167.114.26.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="FUBQbuoc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
	s=smtpout1; t=1707418167;
	bh=umcqlnyoni1L+YV9DQVqbsmdwpCSWY7IqX3VvZk7A10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUBQbuoczWUo8k5+ANycG5EnwK2AZwZz+GM2Uz2zImOXhkBzFtGTdwBZAYCenP6fC
	 DgLffSigWmSC0rW6EM/A/gCcDBjQqYAWbEiusKZCP/jz+pOnSPLQWkJpy21cC8SmOh
	 7iFVQnDrBxgXCvAMOSe7hVjYTOmI/BykW8ePB+qiKPACpJtReCrtD81c1ldvkSSgXY
	 169iBhHYQPa5LIPJ3/XYMbbPDKLgg7sPaH9XXE5MMG0A2HDed+b0Hbw+qnFFAYipQh
	 Ks5Sbzoa+ogU/4NEMlev5PchVfLYxH7lv49QChUb5wmbf1476V86H9j9CkdWhoRXIX
	 FqmNBGS/mqM+w==
Received: from thinkos.internal.efficios.com (192-222-143-198.qc.cable.ebox.net [192.222.143.198])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4TW5cl4DQpzXwg;
	Thu,  8 Feb 2024 13:49:27 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Russell King <linux@armlinux.org.uk>,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v4 12/12] virtio: Cleanup alloc_dax() error handling
Date: Thu,  8 Feb 2024 13:49:13 -0500
Message-Id: <20240208184913.484340-13-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
References: <20240208184913.484340-1-mathieu.desnoyers@efficios.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that alloc_dax() returns ERR_PTR(-EOPNOTSUPP) rather than NULL,
the callers do not have to handle NULL return values anymore.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arch@vger.kernel.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-xfs@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Cc: nvdimm@lists.linux.dev
Cc: linux-s390@vger.kernel.org
---
 fs/fuse/virtio_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 621b1bca2d55..a28466c2da71 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -809,8 +809,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
 		return 0;
 
 	dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
-	if (IS_ERR_OR_NULL(dax_dev)) {
-		int rc = IS_ERR(dax_dev) ? PTR_ERR(dax_dev) : -EOPNOTSUPP;
+	if (IS_ERR(dax_dev)) {
+		int rc = PTR_ERR(dax_dev);
 		return rc == -EOPNOTSUPP ? 0 : rc;
 	}
 
-- 
2.39.2

