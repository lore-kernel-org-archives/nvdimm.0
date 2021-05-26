Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2556570
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 23:33:05 +0000 (UTC)
IronPort-SDR: yAuuLgMAaHlsKDMqWzn+rF9k9030RSt1tpCcYbTQhyNfOnMylLhJgwZPK7CXDEdkqxFj4Fvm8z
 v/K7R9HRRVsw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="189981031"
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="189981031"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:33:00 -0700
IronPort-SDR: ckq5DaWvXhQBUAt0IXe0UdR/p3R2cYzUEiv/9CM3TlkC+6+vG5QcMGCBUG3Dj767lCIdAzZn24
 YcnIXRDnp6sg==
X-IronPort-AV: E=Sophos;i="5.82,333,1613462400"; 
   d="scan'208";a="444314982"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 16:32:59 -0700
Subject: [ndctl PATCH 0/2] ndctl/scrub: Fix start-scrub vs exponential
 backoff
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: Krzysztof Rusocki <krzysztof.rusocki@intel.com>, nvdimm@lists.linux.dev
Date: Wed, 26 May 2021 16:32:58 -0700
Message-ID: <162207197868.3715490.6562405741837220139.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The initial scrub that Linux performs at boot may complete before the
next firing of the poll timer. Use the start-scrub event as a manual
polling event.

---

Dan Williams (2):
      ndctl/scrub: Stop translating return values
      ndctl/scrub: Reread scrub-engine status at start


 ndctl/lib/libndctl.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)
