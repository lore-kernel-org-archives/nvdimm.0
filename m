Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F992C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418336; x=1672954336;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YG9eeeLnbMrLQY6Q0GuYOl0nHLjVehSnzpcQ/ICYIL0=;
  b=I8OnXtGFWeHrh6Lmk8s7zyYmWM8HXF2hFljRrO84cbVQ2uy8ACDCuKxJ
   eoA6mC3u9x2iNPNmNdfu2D9nttTlA1qkwIgWvBj6okMW7/JfN0wDhVJ2M
   zYu6/PV0PfrgohpWlEvbgE0iMsOL86EBexuuY3WgwecTdt4X170thdKi+
   koCfWb8/mL5cg+TZlT/IfSNImMwdLrPNZXws9yryFTosLCAQNTKRVB0OY
   Np1xqhnsJxkvEVIEowcnt1TxIqMbea9+GWfKvPf95JHHw9Q4GoDYR4aR0
   IJzbHO54GpbfE2sEEuu6fIPQHioAxwUNP5sQd9BP2jUW7H2+CZPrlUleb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="266822419"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="266822419"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="689157245"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:10 -0800
Subject: [ndctl PATCH v3 06/16] ndctl/test: Move sector-mode to a different
 region
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:10 -0800
Message-ID: <164141833068.3990253.15694496866707006837.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Previously the largest region on the nfit_test.1 bus belonged to a BLK-mode
region. With the removal of BLK-mode support update the test to instead
find a suitable PMEM region to perform the checkout.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/sector-mode.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index 439ef331adaf..f70b0f1786f4 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -19,11 +19,11 @@ reset
 reset1
 
 rc=1
-query=". | sort_by(.size) | reverse | .[0].dev"
-NAMESPACE=$($NDCTL list -b $NFIT_TEST_BUS1 -N | jq -r "$query")
-REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r "(.[]) | .dev")
+query=". | sort_by(.available_size) | reverse | .[0].dev"
+REGION=$($NDCTL list -R -b $NFIT_TEST_BUS1 | jq -r "$query")
 echo 0 > /sys/bus/nd/devices/$REGION/read_only
-$NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
+echo $ALIGN_SIZE > /sys/bus/nd/devices/$REGION/align
+NAMESPACE=$($NDCTL create-namespace --no-autolabel -r $REGION -m sector -f -l 4K | jq -r ".dev")
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a $ALIGN_SIZE
 $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
 

