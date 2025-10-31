Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E06B24886A;
	Fri, 31 Oct 2025 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932406; cv=none; b=n0SqsxUbCujD7nPuoYcMnmAZprHuqZ0DZa3Zcck9WiLh6q+2AQ1i8SM0BQy7wMWyCNFSzM+VB8mn/QNlGRx8afHrHzx+L8FWUvk42C2Lg1ajGfFn1I/VVnXLfquxveLp4/tk0E6RvRUMoT86+6BDO5jQbpxJpPDcjrj1bKwqRik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932406; c=relaxed/simple;
	bh=i0+MbY4LC18Fc2UjtYfKt1Uk1+eChp6rpzyCxfkWFtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RmNtNHNwojW+UeX+f9CgscNZjboP2I4oyqW3Zbj8w2MK6Rn38tjiaEFe4N33zdsjVAQ0NJ3STyq5xXg2oU9JJ6pTx5NZhqNEoyOuL1F+mqhDkN+o1Ip4TZiKtjBZOMl+5Vag9/cCa3AnPbgqetgpT60lJAqEb8WSRKphoSG3kzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC7BC4CEE7;
	Fri, 31 Oct 2025 17:40:04 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH 0/5] cxl: Add tests for extended linear cache support
Date: Fri, 31 Oct 2025 10:39:58 -0700
Message-ID: <20251031174003.3547740-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The series adds unit tests to verify the kernel support for extended
linear cache (ELC). Added a test to check if the ELC region is setup
correctly, and another test to go through the poison handling flow
via the poison injection testing.


Dave Jiang (5):
  cxl/test: Add test for extended linear cache support
  cxl/test: Fix cxl-poison.sh to detect the correct elc sysfs attrib
  cxl/test: Move cxl-poison.sh to use cxl_test auto region
  cxl/test: Move common part of poison unit test to common file
  cxl/test: Add support for poison test for ELC

 test/common-poison     | 202 ++++++++++++++++++++++++++++++++++++++++
 test/cxl-elc.sh        |  89 ++++++++++++++++++
 test/cxl-poison-elc.sh |  41 +++++++++
 test/cxl-poison.sh     | 203 +----------------------------------------
 test/meson.build       |   4 +
 5 files changed, 338 insertions(+), 201 deletions(-)
 create mode 100644 test/common-poison
 create mode 100755 test/cxl-elc.sh
 create mode 100755 test/cxl-poison-elc.sh


base-commit: 01c90830d65b6b331986f5996dcf6ad73c1579f4
-- 
2.51.0

