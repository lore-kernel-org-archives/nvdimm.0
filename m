Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A11350F7
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 20:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129679; cv=none; b=bJOfPYrYiAqYhHaknuxEd+7IWq9dOCll1QoREyI/xnmGQFvmUHDPvQ3Ti2CnjUFMjZEpMQnYemVL2mqsGJuSl6VzwiMFaQyWWv/5J36ggGtnIzKC3sIl4dib1wNJUMO26T4Eh3FAJnXxU4/k0TeUshuTPpoMy3XtcJ3s0VPYHI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129679; c=relaxed/simple;
	bh=ZfSEhen8IKbAQ9yIOeK2q5cY+gxAQjAxdehsLcyEEW4=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=XO4+Z4SybvE/OBSklU8RYiu8dA68PABGOsMrMHuxdUBB9Dcc9ORMY5yEY1dE54o27AaGDjdZvfZuljX2KS6DjVnh59usmVUTM3uDLzT+cYKmo2nsqsTmq1Y8zYndRMyxSD5RHfPjzpFrXtiCqhkW172ddSov7V/R306xv3wuVqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kV2Ozf04; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kV2Ozf04"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706129677; x=1737665677;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZfSEhen8IKbAQ9yIOeK2q5cY+gxAQjAxdehsLcyEEW4=;
  b=kV2Ozf04D/0LmIX5LkXzdNItCpu/t9i/AWrn9wYosvvPJSEezUyoLKZL
   r/VtUKCnYmE8d0ulNyRSunoug5BplBmT+hVfz/BGyATCxngO7kVKwr18W
   bsWehz8OXj0krF4fVx8RmhvRCHykSG4oTFjIQf7pY87F0aTZV8/qix61J
   RRo4ZAxD2plna2GNi4fi4GPd5N/Jw7GX+hO3EFAFi8xzmAiD0W8VZzMOS
   8rz1+oN7dJOQwrh6CEEJ0xgfHgQ7M601cx7zatBdZdr4/RnTkdJXXOFIu
   bw8RwlSKBjZq6ZLRdP4aSiZq578lOs5U7ZyLT1SPmAW7suL96RhYNz2Ru
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="20524124"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20524124"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="786538916"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="786538916"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.29])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:35 -0800
Subject: [NDCTL PATCH v3 0/3] ndctl: Add support of qos_class for CXL CLI
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 24 Jan 2024 13:54:35 -0700
Message-ID: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Vishal,
With the QoS class series merged to the v6.8 kernel, can you please review and
apply this series to ndctl if acceptable?

v3:
- Rebase against latest ndctl/pending branch.

The series adds support for the kernel enabling of QoS class in the v6.8
kernel. The kernel exports a qos_class token for the root decoders (CFMWS) and as
well as for the CXL memory devices. The qos_class exported for a device is
calculated by the driver during device probe. Currently a qos_class is exported
for the volatile partition (ram) and another for the persistent partition (pmem).
In the future qos_class will be exported for DCD regions. Display of qos_class is
through the CXL CLI list command with -vvv for extra verbose.

A qos_class check as also been added for region creation. A warning is emitted
when the qos_class of a memory range of a CXL memory device being included in
the CXL region assembly does not match the qos_class of the root decoder. Options
are available to suppress the warning or to fail the region creation. This
enabling provides a guidance on flagging memory ranges being used is not
optimal for performance for the CXL region to be formed.

---

Dave Jiang (3):
      ndctl: cxl: Add QoS class retrieval for the root decoder
      ndctl: cxl: Add QoS class support for the memory device
      ndctl: cxl: add QoS class check for CXL region creation


 Documentation/cxl/cxl-create-region.txt |  9 ++++
 cxl/filter.h                            |  4 ++
 cxl/json.c                              | 46 ++++++++++++++++-
 cxl/lib/libcxl.c                        | 62 +++++++++++++++++++++++
 cxl/lib/libcxl.sym                      |  3 ++
 cxl/lib/private.h                       |  3 ++
 cxl/libcxl.h                            | 10 ++++
 cxl/list.c                              |  1 +
 cxl/region.c                            | 67 ++++++++++++++++++++++++-
 util/json.h                             |  1 +
 10 files changed, 204 insertions(+), 2 deletions(-)

--

