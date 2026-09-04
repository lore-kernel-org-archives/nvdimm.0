Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7223E3EF66B
	for <nvdimm@lists.linux.dev>; Fri,  4 Sep 2026 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535685; cv=none; b=aGDPEM6wCFBFJT5NjKSn16cJIxcehjPHDmPt/HGlb3S8ZnP0PXCmTNqUp144UC7/53OZ26+pVbhNA12zRX+IwfBWJ+P64bubYLDzcMhSO+ZdhitksMKV4LbYYh8p+Qak45+ed8BhXVjHcKEljhiXENLyjtB35Hpjb0Wfnx8GO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535685; c=relaxed/simple;
	bh=khWOV4nhtNatbdG5MbKsnk+RFqMS0aXqdoGb+Au4O0w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lLshMNX7tNWUjm6UnNs2VBDx3eOVz7Cy6k4YznI2Oy/j177uZW+BVV24PVu5izg7jeA8hFdxoe2a3OY2SM6zaDlG+wVtgOIVExVGpUlFXX5XzuhULvobrHJWsxFJPRyWn2AOPIuhz3O0jc7HZcnvrarhohhXsxKWWiDbLw01iyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jKxJP1lJ; arc=none smtp.client-ip=91.218.175.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jKxJP1lJ"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=khWOV4nhtNatbdG5MbKsnk+RFqMS0aXqdoGb+Au4O0w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788535680; v=1; x=1789140480;
 b=jKxJP1lJrFjjelRnizRjNFUBDTuNWzt3kX+HdvT/UKAPwYNznbC/xZVNIIlN+gDCctsOBwqY
 bPmNdeCNydYZ2NV6pxjfn8+MGMtkhrE4HBhBwLyvLIqWEHQpkFZHThKQy7rpEfcSC1lUAAZz2+/
 xyEDz4vqMeMw8zR4zPn/og/g=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 202a343dba7560ad;
	Fri, 04 Sep 2026 15:28:00 +0000
X-Mizu-Trace-ID: 202a343dba7560ad
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH 0/2] fs/dax: Clean up busy page lookup helpers
Date: Fri,  4 Sep 2026 23:27:47 +0800
Message-ID: <20260904152749.84493-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dax_layout_busy_page() and dax_layout_busy_page_range() helpers were
originally exposed so filesystems could find pinned DAX pages before
changing file layouts. Filesystem callers now use dax_break_layout(),
which provides the complete operation, leaving no direct users of these
lookup helpers outside fs/dax.c.

Remove the unused whole-mapping wrapper and make the remaining range
helper private to fs/dax.c. This reduces the exported DAX interface with
no functional change.

Kaitao Cheng (2):
  fs/dax: Remove unused dax_layout_busy_page()
  fs/dax: Make dax_layout_busy_page_range() static

 fs/dax.c            | 24 ++++++++----------------
 include/linux/dax.h | 12 ------------
 2 files changed, 8 insertions(+), 28 deletions(-)

-- 
2.50.1 (Apple Git-155)

