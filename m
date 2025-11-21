Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A753020CCE4;
	Fri, 21 Nov 2025 00:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684420; cv=none; b=Yc3J3NUC7BvHDHLl/QpBVPAXOmA9Mtx5a9av+dQC1GCorxmrDHlNoI+ypc4+72+W3m8AsjAjHBgzmVtKQ1xPsSfF3xG25LZG0LYaOPII1R1uYBGWKUzDetoCZ/zYEj38D7iN+uTiJUrK2ElMw0dA5zxXQW8h+Kfn5cOep1QNTRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684420; c=relaxed/simple;
	bh=54DzKL4MckkpDLwBpQGwvnzxW0T0Se+BCMUxNNCo99E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fLwenQXWAjajsmpHMxl/nv1WwJv8Q0JD27I9+m5xkdFjEvxTK/9GKXp+j8KNtBKNXzEcpZBuQZwL9DAR8MOALDS6pF7Xx4S++rSzWb85jxy/52Z/duQvR2oYVIV1e2NYKl08vwErQtRMzG3iLSfBKSFay/GsrCfdlU7CfCg9Fpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BAC5C4CEF1;
	Fri, 21 Nov 2025 00:20:20 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com
Subject: [NDCTL PATCH v2 0/2] cxl: Add tests for extended linear cache support
Date: Thu, 20 Nov 2025 17:20:16 -0700
Message-ID: <20251121002018.4136006-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- skip if no extended_linear_cache mod param. (Alison)
- Cleanup at the end. (Alison)
- Fix shellcheck double quote issues. (Alison)
- Err if elc region not found for cxl_test. (Alison)
- Add missing call to find_region() (Alison)
- Fixup jq query when setup also has qemu cxl devices.
- Dropped folded in patches. 2 and 3.
- Move poison changes to cxl-poison.sh and drop 4 and 5.

The series adds unit tests to verify the kernel support for extended
linear cache (ELC). Added a test to check if the ELC region is setup
correctly, and augments the test to go through the poison handling flow
via the poison injection testing.

Dave Jiang (2):
  cxl/test: Add test for extended linear cache support
  cxl/test: Add support for poison test for ELC

 test/cxl-elc.sh    | 95 ++++++++++++++++++++++++++++++++++++++++++++++
 test/cxl-poison.sh | 61 ++++++++++++++++++-----------
 test/meson.build   |  2 +
 3 files changed, 136 insertions(+), 22 deletions(-)
 create mode 100755 test/cxl-elc.sh


base-commit: 8a94356bc9c0af493be76c0428eee24fe2f5594a
-- 
2.51.1

