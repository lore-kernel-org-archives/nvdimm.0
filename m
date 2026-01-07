Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665D43AA182
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800034; cv=none; b=dWjLZjOpyZdEK8GAeIQs92XZCVis/sHDMV4qHArn27cYjmHJQ/G0t7+Lat5JdCwHy+zWX9of9hvE536bWwfftgVMnp5vdx7Pax3y24GoaAUDMst9RqOZhUROK+C+kxxj8Hb52dh+tnrG55XYYltlNKiHi1LMhC6Ocfq6gMixKxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800034; c=relaxed/simple;
	bh=hD5I6TrfIkqR6ZL+5ujqz6J1CgfKrd1fwnq5BYvWvKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeMh0xdExlfX1oggA8D01B7qaNkrEx3fAdG3qL1O5SgGsZvRAJs7qoLnBAcSRGisk81kmnSiV9ISzmq9EQixMntYGh13/+O2o8mUdclB2cP/RFpvPAbmFHcyee9gX465OuFEKdwVNzT+ponwkbpJZtoqEy4E9I3jwKXxBIUDzWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCLRYR+V; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCLRYR+V"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-455a461ab6eso929544b6e.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800031; x=1768404831; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sf1UcbhIiBjc/Uk94gbmf97qs8tTGqNT0DMGx4pvtTw=;
        b=hCLRYR+VedqIfPICGMasdm2s5jO4PiEk4QZwUepm6W8fS9kZbxPF7Uvl/nlPkPG3tG
         aNpozkJ+rYEqzWjZQr7WM80W05Agu35Gg1oy4BB3Z5onwnB4qYdDYgiS/3Hau0+3YIzF
         Phf4H37K0xF66FWEMu70/HYVbhC4Hfb5+mJY7FD7WMdevv393/SSyKh3cTGm1KbuDP41
         qa1On1kZbylgAADRrVj8hF+RSYGA/PadNtXkLb5mShU0LgfeJ0qUKIMSFI/xTLY2kptB
         Kc6jYUY9mRFcjueSaS1ejSJT+VC1qE2wkUBbCD8ZRQZBXp6uNKJbsaSBoAsGPxb2MHaD
         UGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800031; x=1768404831;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sf1UcbhIiBjc/Uk94gbmf97qs8tTGqNT0DMGx4pvtTw=;
        b=wJo8huJGsSWRRwJaTA7rtk4dB8SvbT8Z8yLH0tY214FwGiexLlVWpB7v/ayMUKEu+h
         A4pW8+gdV88vkeMf4V2Gz9B2ZxrAd8O7xOdR6IcU+xxBrFMDz2jcg6FIGuFPfFJrYI7A
         QTY7MxzgqTEbxZHWUlEYnPtARfZeeJDGMsr3vIEVI6a7yUqmeZDJIpmVK8P9xseDm8mw
         lHdBXGTI+YhIMeUcSZX2JvxctRcclbyqG/gnJ+VzotYYaqhSxIMfh6S0rDMeGwr2gnuc
         unfCd8459XA7ukUOrxwiBmEDFhhQh9Ib8RIQ9WWgDZSPruWE8mnyPSP0bS2TpVTHYW3Q
         sfzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA08t37RGjuBptGxbrJXbdL0gn8qjQDUDDIpBAsxIU6FVgVdk3quzyI2YJRSbfg1XTe5fgSjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW/qRZDdBs+adDPoXvQYsLCmvo9p67IH/k+PRcqVIDWXlaStOs
	8I8UzPjM7zZdSrEz4CwIIs//naWqWSc4F8RbUUYsRfLX4vc/UBDTqrYA
X-Gm-Gg: AY/fxX5lUIg8nPfqhi9LmMW0OX9YzJeOIidocFmzVqYYJRNWLQj9cbLy4qQaEQ2op7/
	lRRflgb7+v0nVOjSO7ah9C/8YlNMkFpnW9ikJvj8TWgBx8pfbHv5enI2uocfA63WfD3TwX0R0N/
	n5MbVpxk67CI2Ccys1REPtP9rp0DCUo1ynyHM5IMoVMZ4X7WPyZuFwbAbMuWmE4zqJ1RmWRfMyV
	B9MgvGsVACKfou4R0blMQ5HgXcwAyu3W9vsBy73Yz+ZYJVrbELzWvOj1E3iJWV2H/enmSL4HXq1
	TBrYWHtvE5BxX/xbjgu4n/0OVFrdr6sUmHvOZWuxfNq6c/jhyP2Z0V9X+oSDe1o8kvJGigfBokw
	TwPXTuJ3urr7jNlmGuiseqpqaVB0txw71DEQsrnA6dT/q+RuQxkTih4XoPZgvCWA/FkP/PZ+qeV
	3f6Q8846wc3LHTkXtkMIlXfdBQCaEuPnE40+zn+WQTkD2Q
X-Google-Smtp-Source: AGHT+IEqVwo0n9Yhx+3/EIppk2vTR8GrN00AjqQRNTP0en45Aku1OwSuAXlc5vd++JGo553Ggky0EQ==
X-Received: by 2002:a05:6808:1822:b0:450:3823:b607 with SMTP id 5614622812f47-45a6bf24bebmr1260765b6e.59.1767800031155;
        Wed, 07 Jan 2026 07:33:51 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.33.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:33:50 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	John Groves <john@groves.net>
Subject: [PATCH V3 03/21] dax: Save the kva from memremap
Date: Wed,  7 Jan 2026 09:33:12 -0600
Message-ID: <20260107153332.64727-4-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save the kva from memremap because we need it for iomap rw support.

Prior to famfs, there were no iomap users of /dev/dax - so the virtual
address from memremap was not needed.

(also fill in missing kerneldoc comment fields for struct dev_dax)

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/dax-private.h | 4 ++++
 drivers/dax/fsdev.c       | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..1bb1631af485 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -69,18 +69,22 @@ struct dev_dax_range {
  * data while the device is activated in the driver.
  * @region - parent region
  * @dax_dev - core dax functionality
+ * @virt_addr - kva from memremap; used by fsdev_dax
+ * @align - alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dyn_id: is this a dynamic or statically created instance
  * @id: ida allocated id when the dax_region is not static
  * @ida: mapping id allocator
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @memmap_on_memory - allow kmem to put the memmap in the memory
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
+	void *virt_addr;
 	unsigned int align;
 	int target_node;
 	bool dyn_id;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 2a3249d1529c..c5c660b193e5 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -235,6 +235,7 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
+	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.49.0

