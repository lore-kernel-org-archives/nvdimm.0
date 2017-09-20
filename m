Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2165920945B80
 for <linux-nvdimm@lists.01.org>; Tue, 19 Sep 2017 17:52:17 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 namespace: fix sector size default when switch modes
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Sep 2017 17:48:57 -0700
Message-ID: <150586853757.32311.8714053831475428757.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Maurice reports:

    I do have a question about specific behavior I observed. Before I was
    able to configure an NVDIMM into any mode from any mode. With these
    patchs if I go to sector mode and try going to memory or dax mode it
    fails with:

    # ndctl create-namespace -f -e namespace0.0 -m memory
      Error: namespace0.0: sector_size: 4096 not supported
    failed to reconfigure namespace: Invalid argument

This results from the fact that we pick up the default sector size from
the current btt. However, if the next mode is not btt we should fall
back to the native sector size of the namespace.

Validate this conversion with an extension to the 'sector-mode.sh' test.

Fixes: 61e82a3d7bc8 ("ndctl, create-namespace: support sector size...")
Reported-by: Maurice A. Saldivar <maurice.a.saldivar@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c   |    7 ++++++-
 test/sector-mode.sh |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 905ebadc6b8d..d26ed1289c33 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -653,7 +653,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 	} else if (ndns) {
 		struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 
-		if (btt)
+		/*
+		 * If the target mode is still 'safe' carry forward the
+		 * sector size, otherwise fall back to what the
+		 * namespace supports.
+		 */
+		if (btt && p->mode == NDCTL_NS_MODE_SAFE)
 			p->sector_size = ndctl_btt_get_sector_size(btt);
 		else
 			p->sector_size = ndctl_namespace_get_sector_size(ndns);
diff --git a/test/sector-mode.sh b/test/sector-mode.sh
index 75bd3c1f82bb..ee364ebad62b 100755
--- a/test/sector-mode.sh
+++ b/test/sector-mode.sh
@@ -45,6 +45,8 @@ NAMESPACE=$($NDCTL list $BUS1 -N | jq -r "$query")
 REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
 echo 0 > /sys/bus/nd/devices/$REGION/read_only
 $NDCTL create-namespace -e $NAMESPACE -m sector -f -l 4K
+$NDCTL create-namespace -e $NAMESPACE -m dax -f -a 4K
+$NDCTL create-namespace -e $NAMESPACE -m sector -f -l 4K
 
 $NDCTL disable-region $BUS all
 $NDCTL disable-region $BUS1 all

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
