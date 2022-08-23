Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C509AA3B
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661240731; x=1692776731;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MQGAynVVQNWd8X9mtXQpToldlZvQ77AW/OreICS7N/k=;
  b=QFBYTji+7v/JnRqJjX7is2mIjihq1mUnjNzfTj1ztWYwqGCbj1v1LE/F
   ltaMoMX4KssQUM0ps7bMOr39g/LWUMUAOLay5HDicXpe9Eb4WpDdu0xul
   k3x0+sjvFXmhletRJKZdXoplnMS7sJ9Jv87j48lMFWRqfBMP/qbiorrQI
   OEUBNgLba6sWJfglPSA0KGMLbizoUtue7EOHrc0xwtTWmI+1LjSvkQmGZ
   UwswyVpZFMzXup3mCfCYcFt7TXMiCoZQRfPLPErw3u1QY1IjzjhFnNmSL
   xVlQ+Biyx7rFNuWcRXd+n4JP7RGx+PdC5RSxhcMqoa7PQYwSQcIvCuOsF
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="294901755"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="294901755"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="609254276"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:45:30 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 0/3] cxl: static analysis fixes
Date: Tue, 23 Aug 2022 01:45:24 -0600
Message-Id: <20220823074527.404435-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=703; h=from:subject; bh=MQGAynVVQNWd8X9mtXQpToldlZvQ77AW/OreICS7N/k=; b=owGbwMvMwCXGf25diOft7jLG02pJDMksrdMWpf3hSjjnkO6smPXwyNKyS2k37umdFdyxy9ph9bU/ lnucOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRR2mMDLf/3DKa+ixfxClvw92y7S 3PLHayf7y64++r5njVKxZLPC8y/E9kXdadGOl2x0GW4dMpDR79ySytPzQEuJM2fkyddnbKMyYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Changes since v1[1]:
- Fix the decoder filter check in patch 1.
- Fix a missed free(path) in patch 2.

[1]: https://lore.kernel.org/linux-cxl/20220823072106.398076-1-vishal.l.verma@intel.com

---

Fix a small handful of issues reported by scan.coverity.com for the
recent region management additions.

Vishal Verma (3):
  cxl/region: fix a dereferecnce after NULL check
  libcxl: fox a resource leak and a forward NULL check
  cxl/filter: Fix an uninitialized pointer dereference

 cxl/lib/libcxl.c | 4 +++-
 cxl/filter.c     | 2 +-
 cxl/region.c     | 5 ++---
 3 files changed, 6 insertions(+), 5 deletions(-)


base-commit: 9a993ce24fdd5de45774b65211570dd514cdf61d
-- 
2.37.2

