Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E21122526485
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 18:04:21 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v3] ndctl: complete move to "fsdax" and "devdax"
Date: Fri, 13 Apr 2018 01:04:19 +0000
Message-ID: <1523581457.5234.5.camel@intel.com>
References: <20180412202804.18141-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20180412202804.18141-1-ross.zwisler@linux.intel.com>
Content-Language: en-US
Content-ID: <3300BCE96C42A04EB7E0FEA4A89A2CE6@intel.com>
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
To: "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-12 at 14:28 -0600, Ross Zwisler wrote:
> Add on to the work started by:
> 
> commit ebb4fb605e68 ("ndctl, create-namespace: introduce "fsdax" and
> "devdax" modes")
> 
> and change some more user visible places to use "fsdax" and "devdax"
> modes
> instead of "memory" and "dax", respectively.  Having multiple terms for
> the
> same mode is confusing for users.
> 
> We will continue to accept "memory" and "dax" as parameters, but all
> output
> and man pages will now use the updated terms.
> 
> Note that after the above referenced commit we still printed the old
> names
> in the default 'ndctl list' output for backward compatibility with
> scripts.
> This patch intentionally breaks that backward compatibility in favor of
> avoiding confusion and using the new mode names everywhere.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
> 
> Changes since v2:
>  - Update files in the 'test' directory as well. (Vishal)
> 
> I've executed all the ndctl unit tests in an nfit_test setup and made
> sure everything still passes.
> 

Thanks for the update; Applied.

> ---
>  Documentation/ndctl/ndctl-inject-error.txt |  2 +-
>  Documentation/ndctl/ndctl-list.txt         |  6 +++---
>  ndctl/namespace.c                          | 16 ++++++++--------
>  test/btt-pad-compat.sh                     |  2 +-
>  test/clear.sh                              |  6 +++---
>  test/create.sh                             |  6 +++---
>  test/dax.sh                                | 12 ++++++------
>  test/daxdev-errors.sh                      |  8 ++++----
>  test/device-dax-fio.sh                     |  6 +++---
>  test/device-dax.c                          | 10 +++++-----
>  test/inject-error.sh                       |  2 +-
>  test/libndctl.c                            |  2 +-
>  test/multi-dax.sh                          |  8 ++++----
>  test/rescan-partitions.sh                  |  2 +-
>  util/json.c                                | 10 ++--------
>  15 files changed, 46 insertions(+), 52 deletions(-)
> 
> diff --git a/Documentation/ndctl/ndctl-inject-error.txt
> b/Documentation/ndctl/ndctl-inject-error.txt
> index 01f6c22..94c4e69 100644
> --- a/Documentation/ndctl/ndctl-inject-error.txt
> +++ b/Documentation/ndctl/ndctl-inject-error.txt
> @@ -45,7 +45,7 @@ OPTIONS
>  
>  	NOTE: The offset is interpreted in different ways based on the
> "mode"
>  	of the namespace. For "raw" mode, the offset is the base
> namespace
> -	offset. For "memory" mode (i.e. a "pfn" namespace), the offset
> is
> +	offset. For "fsdax" mode (i.e. a "pfn" namespace), the offset is
>  	relative to the user-visible part of the namespace, and the
> offset
>  	introduced by the kernel's metadata will be accounted for. For a
>  	"sector" mode namespace (i.e. a "BTT" namespace), the offset is
> diff --git a/Documentation/ndctl/ndctl-list.txt
> b/Documentation/ndctl/ndctl-list.txt
> index 04affc4..2abc572 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -49,7 +49,7 @@ EXAMPLE
>    "namespaces":[
>      {
>        "dev":"namespace0.0",
> -      "mode":"memory",
> +      "mode":"fsdax",
>        "size":8589934592,
>        "blockdev":"pmem0"
>      }
> @@ -132,11 +132,11 @@ include::xable-region-options.txt[]
>  -X::
>  --device-dax::
>  	Include device-dax ("daxregion") details when a namespace is in
> -	"dax" mode.
> +	"devdax" mode.
>  [verse]
>  {
>    "dev":"namespace0.0",
> -  "mode":"dax",
> +  "mode":"devdax",
>    "size":4225761280,
>    "uuid":"18ae1bbb-bb62-4efc-86df-4a5caacb5dcc",
>    "daxregion":{
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index f2c5644..fe86d82 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -103,7 +103,7 @@ OPT_STRING('n', "name", &param.name, "name", \
>  OPT_STRING('s', "size", &param.size, "size", \
>  	"specify the namespace size in bytes (default: available
> capacity)"), \
>  OPT_STRING('m', "mode", &param.mode, "operation-mode", \
> -	"specify a mode for the namespace, 'sector', 'memory', or
> 'raw'"), \
> +	"specify a mode for the namespace, 'sector', 'fsdax', 'devdax'
> or 'raw'"), \
>  OPT_STRING('M', "map", &param.map, "memmap-location", \
>  	"specify 'mem' or 'dev' for the location of the memmap"), \
>  OPT_STRING('l', "sector-size", &param.sector_size, "lba-size", \
> @@ -533,7 +533,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  			 * supported a 2M default alignment when
>  			 * ndctl_pfn_has_align() returns false.
>  			 */
> -			debug("%s not support 'align' for memory
> mode\n",
> +			debug("%s not support 'align' for fsdax mode\n",
>  					region_name);
>  			return -EAGAIN;
>  		} else if (p->mode == NDCTL_NS_MODE_DAX
> @@ -542,7 +542,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  			 * Unlike the pfn case, we require the kernel to
>  			 * have 'align' support for device-dax.
>  			 */
> -			debug("%s not support 'align' for dax mode\n",
> +			debug("%s not support 'align' for devdax
> mode\n",
>  					region_name);
>  			return -EAGAIN;
>  		} else if (!param.align_default
> @@ -696,7 +696,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  
>  		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY
>  			&& p->mode != NDCTL_NS_MODE_DAX) {
> -			debug("%s: --map= only valid for memory mode
> namespace\n",
> +			debug("%s: --map= only valid for fsdax mode
> namespace\n",
>  				ndctl_namespace_get_devname(ndns));
>  			return -EINVAL;
>  		}
> @@ -709,10 +709,10 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		struct ndctl_pfn *pfn =
> ndctl_region_get_pfn_seed(region);
>  
>  		if (!pfn && param.mode_default) {
> -			debug("%s memory mode not available\n",
> region_name);
> +			debug("%s fsdax mode not available\n",
> region_name);
>  			p->mode = NDCTL_NS_MODE_RAW;
>  		} else if (!pfn) {
> -			error("operation failed, %s memory mode not
> available\n",
> +			error("operation failed, %s fsdax mode not
> available\n",
>  					region_name);
>  			return -EINVAL;
>  		}
> @@ -723,7 +723,7 @@ static int validate_namespace_options(struct
> ndctl_region *region,
>  		struct ndctl_dax *dax =
> ndctl_region_get_dax_seed(region);
>  
>  		if (!dax) {
> -			error("operation failed, %s dax mode not
> available\n",
> +			error("operation failed, %s devdax mode not
> available\n",
>  					region_name);
>  			return -EINVAL;
>  		}
> @@ -759,7 +759,7 @@ static int namespace_create(struct ndctl_region
> *region)
>  		return rc;
>  
>  	if (ndctl_region_get_ro(region)) {
> -		debug("%s: read-only, inelligible for namespace
> creation\n",
> +		debug("%s: read-only, ineligible for namespace
> creation\n",
>  			devname);
>  		return -EAGAIN;
>  	}
> diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
> index b2e395d..281a8e5 100755
> --- a/test/btt-pad-compat.sh
> +++ b/test/btt-pad-compat.sh
> @@ -26,7 +26,7 @@ trap 'err $LINENO' ERR
>  # sample json:
>  #{
>  #  "dev":"namespace7.0",
> -#  "mode":"memory",
> +#  "mode":"fsdax",
>  #  "size":"60.00 MiB (62.92 MB)",
>  #  "uuid":"f1baa71a-d165-4da4-bb6a-083a2b0e6469",
>  #  "blockdev":"pmem7",
> diff --git a/test/clear.sh b/test/clear.sh
> index 635e11d..d64dd27 100755
> --- a/test/clear.sh
> +++ b/test/clear.sh
> @@ -69,10 +69,10 @@ fi
>  size_raw=$size
>  sector_raw=$sector
>  
> -# convert pmem to memory mode
> -json=$($NDCTL create-namespace -m memory -f -e $dev)
> +# convert pmem to fsdax mode
> +json=$($NDCTL create-namespace -m fsdax -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" && exit 1
>  
>  # check for errors relative to the offset injected by the pfn device
>  read sector len < /sys/block/$blockdev/badblocks
> diff --git a/test/create.sh b/test/create.sh
> index 4eea78a..3f30d6e 100755
> --- a/test/create.sh
> +++ b/test/create.sh
> @@ -54,10 +54,10 @@ eval $(echo $json | sed -e "$json2var")
>  [ $dev = "x" ] && echo "fail: $LINENO" && exit 1
>  [ $mode != "raw" ] && echo "fail: $LINENO" &&  exit 1
>  
> -# convert pmem to memory mode
> -json=$($NDCTL create-namespace -m memory -f -e $dev)
> +# convert pmem to fsdax mode
> +json=$($NDCTL create-namespace -m fsdax -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
>  # convert pmem to sector mode
>  json=$($NDCTL create-namespace -m sector -l $SECTOR_SIZE -f -e $dev)
> diff --git a/test/dax.sh b/test/dax.sh
> index d522e79..e35f914 100755
> --- a/test/dax.sh
> +++ b/test/dax.sh
> @@ -44,9 +44,9 @@ fallocate -l 1GiB $MNT/$FILE
>  umount $MNT
>  
>  # convert pmem to put the memmap on the device
> -json=$($NDCTL create-namespace -m memory -M dev -f -e $dev)
> +json=$($NDCTL create-namespace -m fsdax -M dev -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
>  #note the blockdev returned from ndctl create-namespace lacks the /dev
> prefix
>  mkfs.ext4 /dev/$blockdev
> @@ -57,7 +57,7 @@ umount $MNT
>  
>  json=$($NDCTL create-namespace -m raw -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
>  mkfs.xfs -f /dev/$blockdev
>  mount /dev/$blockdev $MNT -o dax
> @@ -66,9 +66,9 @@ fallocate -l 1GiB $MNT/$FILE
>  umount $MNT
>  
>  # convert pmem to put the memmap on the device
> -json=$($NDCTL create-namespace -m memory -M dev -f -e $dev)
> +json=$($NDCTL create-namespace -m fsdax -M dev -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
>  mkfs.xfs -f /dev/$blockdev
>  mount /dev/$blockdev $MNT -o dax
> @@ -79,6 +79,6 @@ umount $MNT
>  # revert namespace to raw mode
>  json=$($NDCTL create-namespace -m raw -f -e $dev)
>  eval $(echo $json | sed -e "$json2var")
> -[ $mode != "memory" ] && echo "fail: $LINENO" &&  exit 1
> +[ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>  
>  exit 0
> diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
> index cf6adc6..0c8acf5 100755
> --- a/test/daxdev-errors.sh
> +++ b/test/daxdev-errors.sh
> @@ -49,12 +49,12 @@ rc=1
>  query=". | sort_by(.available_size) | reverse | .[0].dev"
>  region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
>  
> -json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096)
> -chardev=$(echo $json | jq ". | select(.mode == \"dax\") |
> .daxregion.devices[0].chardev")
> +json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a
> 4096)
> +chardev=$(echo $json | jq ". | select(.mode == \"devdax\") |
> .daxregion.devices[0].chardev")
>  
>  #{
>  #  "dev":"namespace6.0",
> -#  "mode":"dax",
> +#  "mode":"devdax",
>  #  "size":64004096,
>  #  "uuid":"83a925dd-42b5-4ac6-8588-6a50bfc0c001",
>  #  "daxregion":{
> @@ -70,7 +70,7 @@ chardev=$(echo $json | jq ". | select(.mode == \"dax\")
> | .daxregion.devices[0].
>  #  }
>  #}
>  
> -json1=$($NDCTL list $BUS --mode=dax --namespaces)
> +json1=$($NDCTL list $BUS --mode=devdax --namespaces)
>  eval $(echo $json1 | sed -e "$json2var")
>  nsdev=$dev
>  
> diff --git a/test/device-dax-fio.sh b/test/device-dax-fio.sh
> index f2cbd4d..6214030 100755
> --- a/test/device-dax-fio.sh
> +++ b/test/device-dax-fio.sh
> @@ -43,8 +43,8 @@ fi
>  dev=$(./dax-dev)
>  for align in 4k 2m 1g
>  do
> -	json=$($NDCTL create-namespace -m dax -a $align -f -e $dev)
> -	chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") |
> .daxregion.devices[0].chardev")
> +	json=$($NDCTL create-namespace -m devdax -a $align -f -e $dev)
> +	chardev=$(echo $json | jq -r ". | select(.mode == \"devdax\") |
> .daxregion.devices[0].chardev")
>  	if [ align = "1g" ]; then
>  		bs="1g"
>  	else
> @@ -80,7 +80,7 @@ do
>  	# revert namespace to raw mode
>  	json=$($NDCTL create-namespace -m raw -f -e $dev)
>  	mode=$(echo $json | jq -r ".mode")
> -	[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
> +	[ $mode != "fsdax" ] && echo "fail: $LINENO" && exit 1
>  done
>  
>  exit 0
> diff --git a/test/device-dax.c b/test/device-dax.c
> index d9196a7..0a42a32 100644
> --- a/test/device-dax.c
> +++ b/test/device-dax.c
> @@ -58,7 +58,7 @@ static int setup_device_dax(struct ndctl_namespace
> *ndns, unsigned long __align)
>  	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
>  	char align[32];
>  	const char *argv[] = {
> -		"__func__", "-v", "-m", "dax", "-M", "dev", "-f", "-a",
> align,
> +		"__func__", "-v", "-m", "devdax", "-M", "dev", "-f", "-
> a", align,
>  		"-e", "",
>  	};
>  	int argc = ARRAY_SIZE(argv);
> @@ -68,13 +68,13 @@ static int setup_device_dax(struct ndctl_namespace
> *ndns, unsigned long __align)
>  	return create_namespace(argc, argv, ctx);
>  }
>  
> -static int setup_pmem_memory_mode(struct ndctl_namespace *ndns,
> +static int setup_pmem_fsdax_mode(struct ndctl_namespace *ndns,
>  		unsigned long __align)
>  {
>  	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
>  	char align[32];
>  	const char *argv[] = {
> -		"__func__", "-v", "-m", "memory", "-M", "dev", "-f", "-
> a",
> +		"__func__", "-v", "-m", "fsdax", "-M", "dev", "-f", "-
> a",
>  		align, "-e", "",
>  	};
>  	int argc = ARRAY_SIZE(argv);
> @@ -175,8 +175,8 @@ static int __test_device_dax(unsigned long align, int
> loglevel,
>  	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 7, 0)))
>  		return 77;
>  
> -	/* setup up memory mode pmem device and seed with verification
> data */
> -	rc = setup_pmem_memory_mode(ndns, align);
> +	/* setup up fsdax mode pmem device and seed with verification
> data */
> +	rc = setup_pmem_fsdax_mode(ndns, align);
>  	if (rc < 0 || !(pfn = ndctl_namespace_get_pfn(ndns))) {
>  		fprintf(stderr, "%s: failed device-dax setup\n",
>  				ndctl_namespace_get_devname(ndns));
> diff --git a/test/inject-error.sh b/test/inject-error.sh
> index 976be5e..8630745 100755
> --- a/test/inject-error.sh
> +++ b/test/inject-error.sh
> @@ -28,7 +28,7 @@ trap 'err $LINENO' ERR
>  # sample json:
>  #{
>  #  "dev":"namespace7.0",
> -#  "mode":"memory",
> +#  "mode":"fsdax",
>  #  "size":"60.00 MiB (62.92 MB)",
>  #  "uuid":"f1baa71a-d165-4da4-bb6a-083a2b0e6469",
>  #  "blockdev":"pmem7",
> diff --git a/test/libndctl.c b/test/libndctl.c
> index a66bcb7..af28390 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -878,7 +878,7 @@ static int __check_pfn_create(struct ndctl_region
> *region,
>  
>  	mode = ndctl_namespace_get_mode(ndns);
>  	if (mode >= 0 && mode != NDCTL_NS_MODE_MEMORY)
> -		fprintf(stderr, "%s: expected memory mode got: %d\n",
> +		fprintf(stderr, "%s: expected fsdax mode got: %d\n",
>  				devname, mode);
>  
>  	if (namespace->ro == (rc == 0)) {
> diff --git a/test/multi-dax.sh b/test/multi-dax.sh
> index bcc9bdf..59ec6d6 100755
> --- a/test/multi-dax.sh
> +++ b/test/multi-dax.sh
> @@ -48,10 +48,10 @@ rc=1
>  query=". | sort_by(.available_size) | reverse | .[0].dev"
>  region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
>  
> -json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096 -s
> 16M)
> -chardev1=$(echo $json | jq ". | select(.mode == \"dax\") |
> .daxregion.devices[0].chardev")
> -json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096 -s
> 16M)
> -chardev2=$(echo $json | jq ". | select(.mode == \"dax\") |
> .daxregion.devices[0].chardev")
> +json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a 4096
> -s 16M)
> +chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") |
> .daxregion.devices[0].chardev")
> +json=$($NDCTL create-namespace $BUS -r $region -t pmem -m devdax -a 4096
> -s 16M)
> +chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") |
> .daxregion.devices[0].chardev")
>  
>  # cleanup
>  $NDCTL disable-region $BUS all
> diff --git a/test/rescan-partitions.sh b/test/rescan-partitions.sh
> index 47f0b62..be26c14 100755
> --- a/test/rescan-partitions.sh
> +++ b/test/rescan-partitions.sh
> @@ -100,7 +100,7 @@ test_mode()
>  rc=1
>  reset
>  test_mode "raw"
> -test_mode "memory"
> +test_mode "fsdax"
>  test_mode "sector"
>  
>  exit 0
> diff --git a/util/json.c b/util/json.c
> index 5b4b4c3..8d65525 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -685,19 +685,13 @@ struct json_object *util_namespace_to_json(struct
> ndctl_namespace *ndns,
>  			size = ndctl_pfn_get_size(pfn);
>  		else /* native/static memory mode */
>  			size = ndctl_namespace_get_size(ndns);
> -		if (flags & UTIL_JSON_HUMAN)
> -			jobj = json_object_new_string("fsdax");
> -		else
> -			jobj = json_object_new_string("memory");
> +		jobj = json_object_new_string("fsdax");
>  		break;
>  	case NDCTL_NS_MODE_DAX:
>  		if (!dax)
>  			goto err;
>  		size = ndctl_dax_get_size(dax);
> -		if (flags & UTIL_JSON_HUMAN)
> -			jobj = json_object_new_string("devdax");
> -		else
> -			jobj = json_object_new_string("dax");
> +		jobj = json_object_new_string("devdax");
>  		break;
>  	case NDCTL_NS_MODE_SAFE:
>  		if (!btt)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
