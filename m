Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F277A1A1DF5
 for <linux-nvdimm@lists.01.org>; Thu,  4 Aug 2016 10:59:51 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id k131so24218829oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 04 Aug 2016 10:59:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147032474225.32368.15775067933518377793.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147032474225.32368.15775067933518377793.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Aug 2016 10:59:50 -0700
Message-ID: <CAPcyv4iAGx8BSaZvjXhe-eoPah4EtQzbckgZfHW_a3us6QCH6w@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, create-namespace: trap and report invalid
 sector-size values
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 4, 2016 at 8:32 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> While the kernel will prevent invalid configurations, the user
> experience of a kernel error message and disabling of the namespace is
> too harsh.  Trap and report these attempts to make create-namespace more
> user friendly.
>
>     # ndctl create-namespace -e namespace0.0 -m sector -l 513 -f -v
>     validate_namespace_options:437: region0: does not support btt sector_size 513
>     failed to reconfigure namespace
>
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/builtin-xaction-namespace.c |   40 +++++++++++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 6 deletions(-)

Unit tests say we also need the following so that we don't try to set
a sector size on pmem namespaces.

diff --git a/ndctl/builtin-xaction-namespace.c
b/ndctl/builtin-xaction-namespace.c
index e136bfdefa39..35345fb26ec3 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -210,8 +210,13 @@ static int set_defaults(enum namespace_action mode)
                        error("'pmem' namespaces do not support
setting 'sector size'\n");
                        rc = -EINVAL;
                }
-       } else if (!param.reconfig)
-               param.sector_size = "4096";
+       } else if (!param.reconfig
+                       && (param.type && strcmp(param.type, "blk") == 0
+                               || (param.mode
+                                       && strcmp(param.mode, "safe") == 0))) {
+                       /* default sector size for blk-type or safe-mode */
+                       param.sector_size = "4096";
+       }

        return rc;
 }
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
