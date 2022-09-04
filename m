Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC56B7E
	for <nvdimm@lists.linux.dev>; Sun,  4 Sep 2022 02:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662257807; x=1693793807;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfzx5y9B9XHcY/WNGZvpd9adYJw1q+hyjxJ0sZQS8JA=;
  b=G2lKi/5YVjr0fQQEupyjQ4WoSG2ni7C+16Cc99GAa0Z56b8fQivW2p8O
   SyPgi5d/1j+5MDUHRE5sHWFLj586hwYV6BQxBA2/X2esX69jBEBe8umgQ
   0GBvNvFSatc6nWEK6ttplj5/6aLmK7dSYtXrl4jM910Iq09WVpLP2Wh/6
   zZwP29oHbmF4DGgXBu1DFUCKlNQkQh72ITV2MU5KrQH/SN/v7gsWbQPuK
   HYxOmRgHk+XoX4nhYWqZQev2QfXFNzjc9RsbT2JgJbF6vgdvREbANSjMt
   i7x+QFktvRmw/FudT9wSFpqu5EOckqHPiB70ugCzXYgdmXawQJVbePRMb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10459"; a="293790538"
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="293790538"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:47 -0700
X-IronPort-AV: E=Sophos;i="5.93,288,1654585200"; 
   d="scan'208";a="755659485"
Received: from pg4-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.132.198])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2022 19:16:46 -0700
Subject: [PATCH 08/13] devdax: Minor warning fixups
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org
Cc: hch@lst.de, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org
Date: Sat, 03 Sep 2022 19:16:46 -0700
Message-ID: <166225780636.2351842.2332609175968045796.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com>
References: <166225775968.2351842.11156458342486082012.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Fix a missing prototype warning for dev_dax_probe(), and fix
dax_holder() comment block format.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax-private.h |    1 +
 drivers/dax/super.c       |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 1c974b7caae6..202cafd836e8 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -87,6 +87,7 @@ static inline struct dax_mapping *to_dax_mapping(struct device *dev)
 }
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+int dev_dax_probe(struct dev_dax *dev_dax);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline bool dax_align_valid(unsigned long align)
diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 9b5e2a5eb0ae..4909ad945a49 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -475,7 +475,7 @@ EXPORT_SYMBOL_GPL(put_dax);
 /**
  * dax_holder() - obtain the holder of a dax device
  * @dax_dev: a dax_device instance
-
+ *
  * Return: the holder's data which represents the holder if registered,
  * otherwize NULL.
  */

