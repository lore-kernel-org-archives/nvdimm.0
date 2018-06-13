Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F20B8211A320E
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 10:51:15 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 0/2] ndctl, test: add some helper function and
 cleanup test script
Date: Wed, 13 Jun 2018 17:51:14 +0000
Message-ID: <1528912272.4998.16.camel@intel.com>
References: <20180613015616.26487-1-msys.mizuma@gmail.com>
In-Reply-To: <20180613015616.26487-1-msys.mizuma@gmail.com>
Content-Language: en-US
Content-ID: <3B85B6DB3CADF847811DA412A2258F31@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-06-12 at 21:56 -0400, Masayoshi Mizuma wrote:
> Some test scripts have same function. So, let's cleanup
> to stop the duplication by intoducing 'test/common' file.
> Test scripts includes the common file to use the functions.
> 
> Changelog:
>   - Add SPDX style license header to the new test/common file.
>   - Fix wrong test expression in detect() on test/firmware-update.sh

Thanks for the updates, applied.

	-Vishal

> 
> Masayoshi Mizuma (2):
>   ndctl, test: add some helper function for test script
>   ndctl, test: cleanup test scripts
> 
>  test/blk-exhaust.sh       | 21 +++-----------
>  test/btt-check.sh         | 35 +++++++----------------
>  test/btt-errors.sh        | 20 ++++---------
>  test/btt-pad-compat.sh    | 52 +++++++++++++--------------------
>  test/clear.sh             | 23 ++++-----------
>  test/common               | 60 +++++++++++++++++++++++++++++++++++++++
>  test/create.sh            | 21 +++-----------
>  test/daxdev-errors.sh     | 19 +++----------
>  test/firmware-update.sh   | 26 ++++-------------
>  test/inject-error.sh      | 31 ++++++--------------
>  test/label-compat.sh      | 21 +++-----------
>  test/multi-dax.sh         | 19 +++----------
>  test/pmem-errors.sh       | 20 ++++---------
>  test/rescan-partitions.sh | 44 +++++++---------------------
>  test/sector-mode.sh       |  5 +---
>  15 files changed, 151 insertions(+), 266 deletions(-)
>  create mode 100644 test/common
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
