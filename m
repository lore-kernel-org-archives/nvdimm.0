Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D7382050AB04
 for <linux-nvdimm@lists.01.org>; Wed, 29 Mar 2017 13:02:29 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] test: add fio test for device-dax
References: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 29 Mar 2017 16:02:27 -0400
In-Reply-To: <149067383236.19079.12786890634892425193.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Mon, 27 Mar 2017 21:03:52 -0700")
Message-ID: <x49inmrua0c.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> +check_min_kver()
> +{
> +	local ver="$1"
> +	: "${KVER:=$(uname -r)}"
> +
> +	[ -n "$ver" ] || return 1
> +	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
> +}
> +
> +check_min_kver "4.11" || { echo "kernel $KVER may lack latest device-dax fixes"; exit $rc; }

Can we stop with this kernel version checking, please?  Test to see if
you can create a device dax instance.  If not, skip the test.  If so,
and if you have a kernel that isn't fixed, so be it, you'll get
failures.

> +
> +set -e
> +trap 'err $LINENO' ERR
> +
> +if ! fio --enghelp | grep -q "dev-dax"; then
> +	echo "fio lacks dev-dax engine"
> +	exit 77
> +fi
> +
> +dev=$(./dax-dev)
> +for align in 4k 2m 1g
> +do
> +	json=$($NDCTL create-namespace -m dax -a $align -f -e $dev)
> +	chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
> +	if [ align = "1g" ]; then
> +		bs="1g"
> +	else
> +		bs="2m"
> +	fi

I'm not sure the blocksize even matters.

Cheers,
Jeff

> +
> +	cat > fio.job <<- EOF
> +		[global]
> +		ioengine=dev-dax
> +		direct=0
> +		filename=/dev/${chardev}
> +		verify=crc32c
> +		bs=${bs}
> +
> +		[write]
> +		rw=write
> +		runtime=5
> +
> +		[read]
> +		stonewall
> +		rw=read
> +		runtime=5
> +	EOF
> +
> +	rc=1
> +	fio fio.job 2>&1 | tee fio.log
> +
> +	if grep -q "fio.*got signal" fio.log; then
> +		echo "test/device-dax-fio.sh: failed with align: $align"
> +		exit 1
> +	fi
> +
> +	# revert namespace to raw mode
> +	json=$($NDCTL create-namespace -m raw -f -e $dev)
> +	mode=$(echo $json | jq -r ".mode")
> +	[ $mode != "memory" ] && echo "fail: $LINENO" && exit 1
> +done
> +
> +exit 0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
