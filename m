Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E0A1203B99B6
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 11:44:23 -0700 (PDT)
Date: Wed, 11 Jul 2018 12:44:21 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, test: Fix dax.sh return code
Message-ID: <20180711184231.GA20078@vverma7-desk1.amr.corp.intel.com>
References: <153073826178.9647.3462886609135347418.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1530908758.7574.40.camel@intel.com>
 <CAPcyv4hCTXSodetks8xxrwSnErw42-RBJhHGDaLOTso2a2xEhA@mail.gmail.com>
 <1530909130.7574.41.camel@intel.com>
 <CAPcyv4gRADddnVHo07EGebMthVfd6mPjHk3p6_-HTgEMgAENPA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gRADddnVHo07EGebMthVfd6mPjHk3p6_-HTgEMgAENPA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/06, Dan Williams wrote:
> On Fri, Jul 6, 2018 at 1:32 PM, Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> >

[..]

> > Yes, but that gets overriden by:
> > https://github.com/pmem/ndctl/blob/master/test/dax.sh#L33
> 
> Hmm not sure. I instrumented dax-pmd.c and the shell script to dump
> the rc value:
> 
>     test_dax_poison: rc: 0
>     rc: 1
>     FAIL dax.sh (exit status: 1)
> 
> diff --git a/test/dax-poison.c b/test/dax-poison.c
> index a25bf0b17d61..3cf2c108ca81 100644
> --- a/test/dax-poison.c
> +++ b/test/dax-poison.c
> @@ -145,7 +145,9 @@ clear_error:
>         x = *(volatile unsigned *) addr + align / 2;
>         rc = 0;
> 
> +       fprintf(stderr, "%s: rc: %d\n", __func__, rc);
>  out:
> +       fprintf(stderr, "%s: rc: %d\n", __func__, rc);
>         if (addr != MAP_FAILED)
>                 munmap(addr, 2 * align);
>         free(buf);
> diff --git a/test/dax.sh b/test/dax.sh
> index 2a82281edb35..016fea5bb0bf 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -90,4 +90,5 @@ json=$($NDCTL create-namespace -m raw -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
>  [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
> 
> -exit 0
> +echo "rc: $rc"
> +exit $rc

I went with the following since the original patch could potentially
lose an rc=77 status.

8<----


>From 5f6e14c827c068ad892b4451844b4ad2135f2696 Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 6 Jul 2018 15:55:43 -0600
Subject: [ndctl PATCH] ndctl, test: Fix dax.sh return code

Commit 11b349b5236e "ndctl, test: Disable poison tests for now"
inadvertently prevented the dax.sh test from ever succeeding. Make sure
the test function actually overrides rc every time instead of only when
there is an error so we don't propagate the initial rc=1 all the way to
the end.

Fixes: 11b349b5236e ("ndctl, test: Disable poison tests for now")
Based-on-patch-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/dax.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/dax.sh b/test/dax.sh
index 30fe167..b63d563 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -29,6 +29,7 @@ err() {
 }
 
 run_test() {
+	rc=0
 	if ! ./dax-pmd $MNT/$FILE; then
 		rc=$?
 		if [ $rc -ne 77 -a $rc -ne 0 ]; then
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
