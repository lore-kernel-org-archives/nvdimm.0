From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] libnvdimm, namespace: potential NULL deref on allocation error
Date: Wed, 12 Oct 2016 09:34:29 +0300
Message-ID: <20161012063429.GA13780@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

If the kcalloc() fails then "devs" can be NULL and we dereference it
checking "devs[i]".

Fixes: 1b40e09a1232 ('libnvdimm: blk labels and namespace instantiation')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3509cff..abe5c6b 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2176,12 +2176,14 @@ static struct device **scan_labels(struct nd_region *nd_region)
 	return devs;
 
  err:
-	for (i = 0; devs[i]; i++)
-		if (is_nd_blk(&nd_region->dev))
-			namespace_blk_release(devs[i]);
-		else
-			namespace_pmem_release(devs[i]);
-	kfree(devs);
+	if (devs) {
+		for (i = 0; devs[i]; i++)
+			if (is_nd_blk(&nd_region->dev))
+				namespace_blk_release(devs[i]);
+			else
+				namespace_pmem_release(devs[i]);
+		kfree(devs);
+	}
 	return NULL;
 }
