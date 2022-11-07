Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E415C90
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 22:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861744; x=1699397744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BN5/PiaNIWFamosoHFOxCQGmhFrm+Yv35c9GGAFSA+I=;
  b=bK5Gr8/+kB+0eYxI9Og7UcsJ6ql3I5xuZUNCSsJJj/NONwMu9VRt7y3G
   WQKA1Egofqv32k/YAjQzZIRcnYgmMsJjpua8u09P3Y8CUMVo1mH9pQBR1
   fO6749ZGMutb/WVYYCmatCp7SQflZ1/eLR2GRnFjrE1OkezfvyB7Q5Q1X
   Tuzu0WE9rbQMesBCW4b9XQ7h4Hu3zkdKKELf9S4oioVfdI50rxzu0U/nA
   PpAxLJPTleoz4avZwLSk/jOmN/AuNRpqbpfXOsoL480ba1pwHc7btjQU7
   WnxlsMOWVIoxoaIiG3JcT13MvSQVDAp3qJHmzBf60vOzv9OSg4GqnqDSn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="290933058"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="290933058"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:55:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="761268852"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="761268852"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.100.77])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:55:43 -0800
Date: Mon, 7 Nov 2022 14:55:42 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 02/15] ndctl/test: Add kernel backtrace detection
 to some dax tests
Message-ID: <Y2mM7pXOCTv4po+1@aschofie-mobl2>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777841716.1238089.7618196736080256393.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166777841716.1238089.7618196736080256393.stgit@dwillia2-xfh.jf.intel.com>

On Sun, Nov 06, 2022 at 03:46:57PM -0800, Dan Williams wrote:
> It is useful to fail a test if it triggers a backtrace. Generalize the
> mechanism from test/cxl-topology.sh and add it to tests that want
> to validate clean kernel logs.

Useful!  

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/common              |   10 ++++++++++
>  test/cxl-region-sysfs.sh |    4 +---
>  test/cxl-topology.sh     |    5 +----
>  test/dax.sh              |    2 ++
>  test/daxdev-errors.sh    |    2 ++
>  test/multi-dax.sh        |    2 ++
>  6 files changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/test/common b/test/common
> index 65615cc09a3e..44cc352f6009 100644
> --- a/test/common
> +++ b/test/common
> @@ -132,3 +132,13 @@ json2var()
>  {
>  	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
>  }
> +
> +# check_dmesg
> +# $1: line number where this is called
> +check_dmesg()
> +{
> +	# validate no WARN or lockdep report during the run
> +	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> +	grep -q "Call Trace" <<< $log && err $1
> +	true
> +}
> diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
> index 63186b60dfec..e128406cd8c8 100644
> --- a/test/cxl-region-sysfs.sh
> +++ b/test/cxl-region-sysfs.sh
> @@ -164,8 +164,6 @@ readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
>  			  jq -r ".[] | .decoder.decoder")
>  echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
>  
> -# validate no WARN or lockdep report during the run
> -log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> -grep -q "Call Trace" <<< $log && err "$LINENO"
> +check_dmesg "$LINENO"
>  
>  modprobe -r cxl_test
> diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
> index f7e390d22680..1f15d29f0600 100644
> --- a/test/cxl-topology.sh
> +++ b/test/cxl-topology.sh
> @@ -169,9 +169,6 @@ done
>  # validate that the bus can be disabled without issue
>  $CXL disable-bus $root -f
>  
> -
> -# validate no WARN or lockdep report during the run
> -log=$(journalctl -r -k --since "-$((SECONDS+1))s")
> -grep -q "Call Trace" <<< $log && err "$LINENO"
> +check_dmesg "$LINENO"
>  
>  modprobe -r cxl_test
> diff --git a/test/dax.sh b/test/dax.sh
> index bb9848b10ecc..3ffbc8079eba 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -118,4 +118,6 @@ else
>  	run_xfs
>  fi
>  
> +check_dmesg "$LINENO"
> +
>  exit 0
> diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
> index 7f79718113d0..84ef93499acf 100755
> --- a/test/daxdev-errors.sh
> +++ b/test/daxdev-errors.sh
> @@ -71,6 +71,8 @@ if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badbl
>  fi
>  [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
>  
> +check_dmesg "$LINENO"
> +
>  _cleanup
>  
>  exit 0
> diff --git a/test/multi-dax.sh b/test/multi-dax.sh
> index 04070adb18e4..d471e1c96b5e 100755
> --- a/test/multi-dax.sh
> +++ b/test/multi-dax.sh
> @@ -28,6 +28,8 @@ chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices
>  json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a $ALIGN_SIZE -s 16M)
>  chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
>  
> +check_dmesg "$LINENO"
> +
>  _cleanup
>  
>  exit 0
> 
