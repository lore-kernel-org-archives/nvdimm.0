Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D162BD5BD
	for <nvdimm@lists.linux.dev>; Thu, 19 Mar 2026 01:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773883797; cv=none; b=Nj8q9lrWAQDsB0iwaD4+Ten3+p9nUYVZzC0v6wbrmCFWO+nMWZ3MXYTe7/sHNHRZwza3SX+8fD80oa20UgkGD8EmTGgbY0rLymPv5JG+FeIh3sgHvOSW7+736OGy1MN+PXh77HIJNF0s0rNPBKl9q+xLHo4th32WosjPpcjEyeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773883797; c=relaxed/simple;
	bh=+7qbZO+oJj9sQzSsIPmzQyBDvR4X1djf6CJiJixJ0Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl7gsDJqEcyeGrsxp9yOM4zBUpRSyih1M7w7cK+rg++W5fSHDyhS6W3H+NwVvx+iAjzmTj6ux0zqs+n1o/szsPX3JM1wcQTnKv+ahixaFGEOSzjdty/mcCN5aTzaoWApWvlZq1C028IsQag7OtPue7tdKKKWZ4ObKFey/DJRc0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B8EB1402CF;
	Thu, 19 Mar 2026 01:29:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 1741B30;
	Thu, 19 Mar 2026 01:29:32 +0000 (UTC)
From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH V8 4/8] dax: Save the kva from memremap
Date: Wed, 18 Mar 2026 20:29:28 -0500
Message-ID: <20260319012928.4475-1-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318202737.4344.dax@groves.net>
References: <20260318202737.4344.dax@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dkpkffgus8z66bd9f9sd14x6bhyfu1nc
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 1741B30
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18DqTQzoVHQR2j04qujFgikIh0PwIqh0sM=
X-HE-Tag: 1773883772-493721
X-HE-Meta: U2FsdGVkX1/TOaPnpzQYJ2rlYO5+cP+e93RxraFn/Z9D2rhOUpEzm0Vg6OOW8Ib4ENiSrSa5Ta+mkewmtIJll8KHV/C5fZ9QDRri0ow0zeRnp0Esy7Ugo1A+N3LlA+zzMF5iptT7kAsxaTPOLtW6sQEMKIgoJQ6snFJFrTYMMLdT+kGFocRHZfKDbTmVtV06enuCd7DYWEdEuKfas5frt/PlZYjLWALsKfltOIp/grxcnXLwdYtnG2pF1X9Bd335bHOyIOzW4cqtLpK7nm8x8ivFCx/ME8HrvemGn+V6vDSIRTXZ1igmzp4gilFf9p4bcbE7OMoItc0BTTSrBA5sLhwGyS52Fyr0

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 2 ++
 drivers/dax/fsdev.c       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index c6ae27c982f4..7a3727d76a68 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -69,6 +69,7 @@ struct dev_dax_range {
  * data while the device is activated in the driver.
  * @region: parent region
  * @dax_dev: core dax functionality
+ * @virt_addr: kva from memremap; used by fsdev_dax
  * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
@@ -83,6 +84,7 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index e5b4396ce401..d2f6c0341c24 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -212,6 +212,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
+	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.53.0

