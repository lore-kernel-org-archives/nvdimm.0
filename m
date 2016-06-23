From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] validate_namespace_options: fix bogus test
Date: Thu, 23 Jun 2016 15:59:50 -0400
Message-ID: <20160623195950.30968-4-jmoyer@redhat.com>
References: <20160623195950.30968-1-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160623195950.30968-1-jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Another coverity find.  The patch is self-explanatory, I hope.

Signed-off-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 ndctl/builtin-xaction-namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 8ce7c3e..7411a01 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -444,7 +444,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 				ndctl_namespace_get_devname(ndns));
 			return -EINVAL;
 		}
-	} else if (p->mode == NDCTL_NS_MODE_MEMORY || NDCTL_NS_MODE_DAX)
+	} else if (p->mode == NDCTL_NS_MODE_MEMORY ||
+		   p->mode == NDCTL_NS_MODE_DAX)
 		p->loc = NDCTL_PFN_LOC_PMEM;
 
 	/* check if we need, and whether the kernel supports, pfn devices */
-- 
2.8.2.335.g4bb51ae
