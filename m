Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 70429210C4DA4
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 21:36:31 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/2] nfit, test: cleanup test scripts
Date: Tue, 19 Jun 2018 04:36:26 +0000
Message-ID: <1529382984.1960.4.camel@intel.com>
References: <20180614194336.15341-1-msys.mizuma@gmail.com>
 <20180614194336.15341-3-msys.mizuma@gmail.com>
In-Reply-To: <20180614194336.15341-3-msys.mizuma@gmail.com>
Content-Language: en-US
Content-ID: <AD19415750335C4097DAF3B05BF660BF@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "msys.mizuma@gmail.com" <msys.mizuma@gmail.com>
Cc: "m.mizuma@jp.fujitsu.com" <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-06-14 at 15:43 -0400, Masayoshi Mizuma wrote:
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> Cleanup some test scripts by using helper functions.
> 
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  test/blk-exhaust.sh       | 21 ++++++----------
>  test/btt-check.sh         | 52 ++++++++++++++++++---------------------
>  test/btt-errors.sh        |  7 +++---
>  test/btt-pad-compat.sh    | 36 ++++++++++++---------------
>  test/clear.sh             | 25 +++++++------------
>  test/create.sh            | 26 +++++++++-----------
>  test/daxdev-errors.sh     | 29 ++++++++--------------
>  test/firmware-update.sh   | 25 +++++--------------
>  test/inject-error.sh      | 24 ++++++++----------
>  test/label-compat.sh      | 17 +++++--------
>  test/multi-dax.sh         | 23 ++++++-----------
>  test/pmem-errors.sh       | 19 +++++---------
>  test/rescan-partitions.sh | 22 ++++++++---------
>  test/sector-mode.sh       | 22 ++++++-----------
>  14 files changed, 135 insertions(+), 213 deletions(-)
> 
> 
[..]

> diff --git a/test/sector-mode.sh b/test/sector-mode.sh
> index d507788..3576b70 100755
> --- a/test/sector-mode.sh
> +++ b/test/sector-mode.sh
> @@ -11,10 +11,6 @@
>  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>  # General Public License for more details.
>  
> -NDCTL="../ndctl/ndctl"
> -BUS="-b nfit_test.0"
> -BUS1="-b nfit_test.1"
> -TEST=$0
>  rc=77
>  
>  . ./common
> @@ -24,25 +20,23 @@ trap 'err $LINENO' ERR
>  
>  # setup (reset nfit_test dimms)
>  modprobe nfit_test
> -$NDCTL disable-region $BUS all
> -$NDCTL zero-labels $BUS all
> -$NDCTL enable-region $BUS all
> +$NDCTL disable-region $NFIT_TEST_BUS0 all
> +$NDCTL zero-labels $NFIT_TEST_BUS0 all
> +$NDCTL enable-region $NFIT_TEST_BUS0 all
>  
> -$NDCTL disable-region $BUS1 all
> -$NDCTL zero-labels $BUS1 all
> -$NDCTL enable-region $BUS1 all
> +$NDCTL disable-region $NFIT_TEST_BUS1 all
> +$NDCTL zero-labels $NFIT_TEST_BUS1 all
> +$NDCTL enable-region $NFIT_TEST_BUS1 all

In all six instances above, missing the '-b' before $NFIT_TEST_BUS*

>  
>  rc=1
>  query=". | sort_by(.size) | reverse | .[0].dev"
> -NAMESPACE=$($NDCTL list $BUS1 -N | jq -r "$query")
> +NAMESPACE=$($NDCTL list $NFIT_TEST_BUS1 -N | jq -r "$query")

Also here..

>  REGION=$($NDCTL list -R --namespace=$NAMESPACE | jq -r ".dev")
>  echo 0 > /sys/bus/nd/devices/$REGION/read_only
>  $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
>  $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m dax -f -a 4K
>  $NDCTL create-namespace --no-autolabel -e $NAMESPACE -m sector -f -l 4K
>  
> -$NDCTL disable-region $BUS all
> -$NDCTL disable-region $BUS1 all
> -modprobe -r nfit_test
> +_cleanup
>  
>  exit 0

Other than these, the patches look good. Thanks for these cleanups!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
