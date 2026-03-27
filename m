Received: from a11-6.smtp-out.amazonses.com (a11-6.smtp-out.amazonses.com [54.240.11.6])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3763837998A
	for <nvdimm@lists.linux.dev>; Fri, 27 Mar 2026 21:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774645487; cv=none; b=KgwrwRThQGMkmfce1TeDuKXjj7yKoo7Ktty+0sSrVF94WIwnXNxeHzYhrkqHvfZKbAMk1ARXNNx1sE+ecPORxTNSqloaCsc1Kvj8td0PZ/ahwo+m3A64KyDPV2O7Zg1IQemQM8xCZgG6VNe6MlHcVe2hr4Su5sC+YE+Q3cL+iQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774645487; c=relaxed/simple;
	bh=TwR55drkrAD8h6d/3sw7QkigmSk+Wy9TW9LZv3CZZB0=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=rJpb3RE8d0ZLraLlkCDHFQtUni2ZpUcUNmY6CueO2oShLCUfCen3zDrPXWAdMtTTlaR+YAdYaUkf3P1tMvlolT/r5i2KGZavatOmEnqiyVwUodpR5Fg+64y5UrTA7Me5JCKunnvUNTNJtY/h4bHLHafvY2EqwpJfH6IO12+GUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=PMAFYcP4; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=qXOFdqCR; arc=none smtp.client-ip=54.240.11.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="PMAFYcP4";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="qXOFdqCR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1774645485;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=TwR55drkrAD8h6d/3sw7QkigmSk+Wy9TW9LZv3CZZB0=;
	b=PMAFYcP4KktgVA/2bifoOFOvE/wJqutOjemN91FDz6UkIlMiUAHZXtE0ndeG1zrc
	Acp96URGarUqTIi52p83wF7dXr1N0B66KzpdxPavM710YiLkonP/eCpR19zdras0t45
	28nGYZMMIIXeLlY+2eeue/KNxcb6Z8U7sgs5dSi0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1774645485;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=TwR55drkrAD8h6d/3sw7QkigmSk+Wy9TW9LZv3CZZB0=;
	b=qXOFdqCR56VOxnnR0whSMfw3YU98KwFzTkgHHovA5vPHpvvPT7ICLncU//1smdAo
	qOQSaZtcsfnuPUYtTvJ9tPJw8DlsQx6B8rLFG01IVc976fMSmUfUN2GxQM+U/8IGLpB
	cfOcoDaZunNAt7IIOfXAj15UVVBJTapWyCTmp57M=
Subject: [PATCH V10 4/8] dax: Save the kva from memremap
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?Miklos_Szeredi?= <miklos@szeredi.hu>, 
	=?UTF-8?Q?Dan_Williams?= <dan.j.williams@intel.com>, 
	=?UTF-8?Q?Bernd_Schubert?= <bschubert@ddn.com>, 
	=?UTF-8?Q?Alison_Schofiel?= =?UTF-8?Q?d?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Jonathan_Corbe?= =?UTF-8?Q?t?= <corbet@lwn.net>, 
	=?UTF-8?Q?Shuah_Khan?= <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Matthew_Wilcox?= <willy@infradead.org>, 
	=?UTF-8?Q?Jan_Kara?= <jack@suse.cz>, 
	=?UTF-8?Q?Alexander_Viro?= <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?David_Hildenbrand?= <david@kernel.org>, 
	=?UTF-8?Q?Christian_Bra?= =?UTF-8?Q?uner?= <brauner@kernel.org>, 
	=?UTF-8?Q?Darrick_J_=2E_Wong?= <djwong@kernel.org>, 
	=?UTF-8?Q?Randy_Dunlap?= <rdunlap@infradead.org>, 
	=?UTF-8?Q?Jeff_Layton?= <jlayton@kernel.org>, 
	=?UTF-8?Q?Amir_Goldstein?= <amir73il@gmail.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Stefan_Hajnoczi?= <shajnocz@redhat.com>, 
	=?UTF-8?Q?Joanne_Koong?= <joannelkoong@gmail.com>, 
	=?UTF-8?Q?Josef_Bacik?= <josef@toxicpanda.com>, 
	=?UTF-8?Q?Bagas_Sanjaya?= <bagasdotme@gmail.com>, 
	=?UTF-8?Q?Chen_Linxuan?= <chenlinxuan@uniontech.com>, 
	=?UTF-8?Q?James_Morse?= <james.morse@arm.com>, 
	=?UTF-8?Q?Fuad_Tabba?= <tabba@google.com>, 
	=?UTF-8?Q?Sean_Christopherson?= <seanjc@google.com>, 
	=?UTF-8?Q?Shivank_Garg?= <shivankg@amd.com>, 
	=?UTF-8?Q?Ackerley_Tng?= <ackerleytng@google.com>, 
	=?UTF-8?Q?Gregory_Pric?= =?UTF-8?Q?e?= <gourry@gourry.net>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?linux-doc=40vger=2Ekernel=2Eorg?= <linux-doc@vger.kernel.org>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2Eorg?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2Elinux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40vger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?linux-fsdevel=40vger=2Ekernel=2Eorg?= <linux-fsdevel@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>, 
	=?UTF-8?Q?Ira_Weiny?= <ira.weiny@intel.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <jonathan.cameron@huawei.com>
Date: Fri, 27 Mar 2026 21:04:44 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
In-Reply-To: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com>
References: 
 <0100019d311bed04-dbb67b48-c55d-4e6a-962a-a0f8b714f2e7-000000@email.amazonses.com> 
 <20260327210438.79187-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHcvi1V6SORlep7RO6AMDKflmXMOw==
Thread-Topic: [PATCH V10 4/8] dax: Save the kva from memremap
X-Wm-Sent-Timestamp: 1774645483
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019d311d1d08-dd372cb9-5934-43b8-bef8-089660d04a81-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.03.27-54.240.11.6

From: John Groves <john@groves.net>

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 2 ++
 drivers/dax/fsdev.c       | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

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
index 8b5c6976ad17..c75478d3d548 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -121,6 +121,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dev_pagemap *pgmap;
 	struct inode *inode;
+	u64 data_offset = 0;
 	struct cdev *cdev;
 	void *addr;
 	int rc, i;
@@ -196,7 +197,6 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 	if (pgmap->range.start != dev_dax->ranges[0].range.start) {
 		u64 phys = dev_dax->ranges[0].range.start;
 		u64 pgmap_phys = dev_dax->pgmap[0].range.start;
-		u64 data_offset = 0;
 
 		if (!WARN_ON(pgmap_phys > phys))
 			data_offset = phys - pgmap_phys;
@@ -204,6 +204,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
+	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.53.0

