Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C22D8376;
	Sun, 11 Oct 2026 22:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757991; cv=none; b=R98eBunLDCmL8qe0cz31NQ3AVv+2PTI9bcd1dZ2hFbQrIzN+P0vJ18YHS8IZm33hAU5HWdsF1YAUrP0YlH7zEj3s35qqf/oVbUXYby7HsCmDgZgXejxQXNoRXNxS6Y+ocRqSYP+3Rc6CcBNjLx91MGdIPSWfIttSsj4FM0klIL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757991; c=relaxed/simple;
	bh=vjfhu8l68WW4M5SlFYlgw/AaCJa7ZGCHw1RglsjaPsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kp7vzGJt/BAKrSxMOxJ8ihsWY7apyGtA3YSmeledfaaTAhj4ZHf2qETRzD8w/4AhTol+nrwQPQryHHKw5YwMncf4g+KkLD/DgmHXmZVZN3qBtBjlvXh6qULx/65WHUQGw3jI1PliSuHgCWufBjTDJS2RYgGaAa9mJUh0ACtUYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7159F1607DA;
	Sun, 11 Oct 2026 22:33:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf15.hostedemail.com (Postfix) with ESMTPA id 5B1F91A;
	Sun, 11 Oct 2026 22:32:59 +0000 (UTC)
Date: Sun, 11 Oct 2026 17:32:58 -0500
From: John Groves <john@groves.net>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, Amir Goldstein <amir73il@gmail.com>, 
	"Darrick J . Wong" <djwong@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 0/9] fuse: resolve extent maps in O(1) when possible
Message-ID: <aswN-UprZHx9wU9y@groves.net>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008112004.1899560-1-mszeredi@redhat.com>
X-Stat-Signature: ijefzzk89zw5pojijsffjojg7pfis3t7
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 5B1F91A
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18hBECT34yFbX+3XO0vrSaYGVmeVjD8qWM=
X-HE-Tag: 1791757979-211104
X-HE-Meta: U2FsdGVkX1/bsgbwZAZAyt4Ak9dDYjgaMcmMjZhLwYoIBQeUT0kPdN8l+tkd3Lf36Ekauh/vuyt0tAtpr7BM/k9rz83Yn+mgLvLINDVwC5atlG5qDQDGnXcVk6zCF4gw+zWPuGalOsxOqHTiYWLbhJp/Zo+8DIQUuuMmDww10N/VyFGIdUSiup2rjuPvvjWwPJ6UBW0aY+Nen6ecK45Sl23wgH92FkAp2MxpZynqwv676TJA+tKnmQlLLBmpb4+HG/Ia4MQtvK+v1iSa+8xU4H3jZLBfwwK0RvWBo7563kIdp3y1hYzgkWLs8ktpsXPxEdxWU5JyEwe/7hT9wtTUmJTrDZqo0qQgRe1Kswrx3amq+tvS1oj10ktYjN0dh+sJtqZ/TWgqHOdc0oA4h6LZ0A==


From 48d28d18ad0ccfc950cf9b3ff71033ae03b3a171 Mon Sep 17 00:00:00 2001
From: John Groves <john@groves.net>
Date: Sun, 11 Oct 2026 15:06:48 -0500
Subject: [PATCH 0/1] fuse: resolve extent maps in O(1) when possible

This patch applies on top of Miklos' v4 "fuse: DAX device based extent
maps (famfs)" series and replaces the rbtree of extents with a sorted,
packed array hung off the extmap backing.

The extent resolver runs on every mapping fault of a DAX extent-mapped
file and on every chunk of every read/write.  Unlike a conventional
page fault there is no I/O to amortize it against; the fault only
installs page table entries for memory that is already there, so each
rbtree level is a potential LLC miss added to an otherwise cheap fault.
With a packed, sorted array a uniform map (including every cyclic map)
resolves with one divide and an array index, and an irregular map
bisects the array.  famfs always produces uniform maps today.  The
commit message has the full rationale.

Logically this folds into the last three patches of v4 (extent map data
structure, extent map I/O support, striped backing).  I'm happy to send
it pre-split if that is easier than folding it yourself.

With this patch on top of v4 the famfs test suite passes; that tree is
at [2].  The famfs userspace master branch [1] now works with v4.  If
the next revision needs further userspace changes, please base them on
that branch or send them my way so the two don't diverge.

[1] https://github.com/jagalactic/famfs.git master
[2] https://github.com/jagalactic/linux.git famfs-extmap

John Groves (1):
  fuse: resolve extent maps in O(1) when possible

 fs/fuse/backing.c |   7 +-
 fs/fuse/ext_map.c | 219 +++++++++++++++++++++++++++++-----------------
 fs/fuse/fuse_i.h  |   8 +-
 3 files changed, 147 insertions(+), 87 deletions(-)

-- 
2.55.0

