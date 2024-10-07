Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356041C230A
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728342987; cv=none; b=JZKsaBdx79+32R5vu7/Yv4yDGgDmd/iQHvOqk8wdR/tF90T08LPYPl7NM3akkTv1r88U+L9jea9gDRSpalsBaOx+j8vTbM62a1Wsq+guTyP1lBt41d/Rp/s5rSP9ClGEEPbnxNXxyGUZtAr02h0bB2s1SbBWhxyPqcOjYRXVnZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728342987; c=relaxed/simple;
	bh=07I2KD7+kzZQpza3GP7lcZeYEOxq4Zpa5vfjWi10te4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EQPI1a/zNkiFSvhJJ+pY+0VNbpO+ckr2/BhNr0o7tUO4lT/2o6GVXSiV7ai8MHbqraI2BvHvCOAh3uEFJkR8KKg9Z1nmsfctRqeKNo53Jw0KI09lf/C15BnNnM80nQLjsgQP23pFXUmfClUp5/pPhnjeEjRJXhhunIp1yeEef78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YnJ3ncqc; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YnJ3ncqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728342986; x=1759878986;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=07I2KD7+kzZQpza3GP7lcZeYEOxq4Zpa5vfjWi10te4=;
  b=YnJ3ncqcc4ko9zw0q/PvDfjR8zpwM/HpByOqqJ7vp0sNrEbc9MN9uvtR
   K+b+34BLi6OoTHQ+Rhij0TEZMbQiBdJ+IAMK8vvv6XwkQ1PAS9bwjfTHg
   dke312GjBYWPveQlptwhhs2FrhCag/9SmafVWIXU8D49uorfZn5o5Q8c9
   Vvh1Z7byEfaQGjNjK+WVlBpl/5ljHesd0aH0I/qOZgIlLr5XHKJCMUit1
   Vg7tlKDlyJaFjFbkRPH6uDnGS+Lx7FncDTsJyi3jRKATW43VxqEBoC3Xu
   1iNoO9OIDmGp+M07kPlecSyEKoqIFVltPUaXtb+KZW6rOy7lfzX0GvvsD
   w==;
X-CSE-ConnectionGUID: UHXgM+E1Q+W+jHoeRBs/ZA==
X-CSE-MsgGUID: tV1WZfkBQ4mBpLj9X+dGBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="38078898"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="38078898"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:26 -0700
X-CSE-ConnectionGUID: YQ4dGJlOQv2wgdd2OGtsHA==
X-CSE-MsgGUID: PhYByG35REKP6WUALPHotQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="75634575"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:16:23 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 07 Oct 2024 18:16:10 -0500
Subject: [PATCH v4 04/28] range: Add range_overlaps()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-4-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>, 
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=3425;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=07I2KD7+kzZQpza3GP7lcZeYEOxq4Zpa5vfjWi10te4=;
 b=Gx+w5m+4Pi2Qt9xyC75hqePjeE7TVGvSP6kNXikpkuW4sazXEwKwoe1YMvyCGZD4658eEXSkj
 H4LIyLC0BvDCsRmjv4k4PJKh5n7mYKNkQqS4RLepdMD7TSHk6HnPOlX
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Code to support CXL Dynamic Capacity devices will have extent ranges
which need to be compared for intersection not a subset as is being
checked in range_contains().

range_overlaps() is defined in btrfs with a different meaning from what
is required in the standard range code.  Dan Williams pointed this out
in [1].  Adjust the btrfs call according to his suggestion there.

Then add a generic range_overlaps().

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org

Acked-by: David Sterba <dsterba@suse.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

[1] https://lore.kernel.org/all/65949f79ef908_8dc68294f2@dwillia2-xfh.jf.intel.com.notmuch/
---
 fs/btrfs/ordered-data.c | 10 +++++-----
 include/linux/range.h   |  7 +++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2104d60c2161..744c3375ee6a 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -111,8 +111,8 @@ static struct rb_node *__tree_search(struct rb_root *root, u64 file_offset,
 	return NULL;
 }
 
-static int range_overlaps(struct btrfs_ordered_extent *entry, u64 file_offset,
-			  u64 len)
+static int btrfs_range_overlaps(struct btrfs_ordered_extent *entry, u64 file_offset,
+				u64 len)
 {
 	if (file_offset + len <= entry->file_offset ||
 	    entry->file_offset + entry->num_bytes <= file_offset)
@@ -985,7 +985,7 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(
 
 	while (1) {
 		entry = rb_entry(node, struct btrfs_ordered_extent, rb_node);
-		if (range_overlaps(entry, file_offset, len))
+		if (btrfs_range_overlaps(entry, file_offset, len))
 			break;
 
 		if (entry->file_offset >= file_offset + len) {
@@ -1114,12 +1114,12 @@ struct btrfs_ordered_extent *btrfs_lookup_first_ordered_range(
 	}
 	if (prev) {
 		entry = rb_entry(prev, struct btrfs_ordered_extent, rb_node);
-		if (range_overlaps(entry, file_offset, len))
+		if (btrfs_range_overlaps(entry, file_offset, len))
 			goto out;
 	}
 	if (next) {
 		entry = rb_entry(next, struct btrfs_ordered_extent, rb_node);
-		if (range_overlaps(entry, file_offset, len))
+		if (btrfs_range_overlaps(entry, file_offset, len))
 			goto out;
 	}
 	/* No ordered extent in the range */
diff --git a/include/linux/range.h b/include/linux/range.h
index 6ad0b73cb7ad..9a46f3212965 100644
--- a/include/linux/range.h
+++ b/include/linux/range.h
@@ -13,11 +13,18 @@ static inline u64 range_len(const struct range *range)
 	return range->end - range->start + 1;
 }
 
+/* True if r1 completely contains r2 */
 static inline bool range_contains(struct range *r1, struct range *r2)
 {
 	return r1->start <= r2->start && r1->end >= r2->end;
 }
 
+/* True if any part of r1 overlaps r2 */
+static inline bool range_overlaps(struct range *r1, struct range *r2)
+{
+	return r1->start <= r2->end && r1->end >= r2->start;
+}
+
 int add_range(struct range *range, int az, int nr_range,
 		u64 start, u64 end);
 

-- 
2.46.0

