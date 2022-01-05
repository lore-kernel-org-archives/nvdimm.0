Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0462C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418372; x=1672954372;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lqxas7Jp2n48528XZYMSoM/T1vo3G5+Ksw7UW8FLeP8=;
  b=KqiVeVIA1vPImjgO5y9bpHLWPScYRRHQ9tz8sGPVg0gCHtUTs3hSucww
   RPu6RA//5HNf2uzv2LE56SwmvYJxzHw0Y2zRgkyCZxWLDTZi6y9l3/QYt
   YHZyLaZfuhG2yNQZOh8kH0yh/gjHXR+wr7eJo0VlonLRTSE0HD64nmKcS
   8R9NXd7B21SxK52IaqnElqjaICrHihTiwKSOc/6DjbeyE8Ad7BUrvzylt
   S54b9/gTRuJLCirGznGmx3I5K9Y1p3lAA3cfHFmsqVeknSlufJ3u1jBjI
   OaEzjexI9uY/qbvWSl2Oct+IxTlxCphkct0YWlEFkO3gmsQSHjirTLH/6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223224353"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="223224353"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:05 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="574526270"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:05 -0800
Subject: [ndctl PATCH v3 05/16] ndctl/test: Skip BLK flags checks
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:05 -0800
Message-ID: <164141832529.3990253.16538298357542644310.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

With the removal of BLK-mode support, test/libndctl will fail to detect the
JEDEC format on the nfit_test bus. Report + skip that check rather than
fail the test when that happens.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 0d6b9dd5b04b..aa624289c708 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2536,7 +2536,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 				fprintf(stderr, "dimm%d expected formats: %d got: %d\n",
 						i, dimms[i].formats,
 						ndctl_dimm_get_formats(dimm));
-				return -ENXIO;
+				fprintf(stderr, "continuing...\n");
 			}
 			for (j = 0; j < dimms[i].formats; j++) {
 				if (ndctl_dimm_get_formatN(dimm, j) != dimms[i].format[j]) {
@@ -2544,7 +2544,7 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 						"dimm%d expected format[%d]: %d got: %d\n",
 							i, j, dimms[i].format[j],
 							ndctl_dimm_get_formatN(dimm, j));
-					return -ENXIO;
+					fprintf(stderr, "continuing...\n");
 				}
 			}
 		}

