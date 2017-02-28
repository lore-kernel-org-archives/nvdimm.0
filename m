From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ndctl PATCH v2 3/3] ndctl,
 test: Add a unit test for the BTT checker
Date: Tue, 28 Feb 2017 16:19:05 -0500
Message-ID: <x494lze10ae.fsf@segfault.boston.devel.redhat.com>
References: <20170222224724.7696-1-vishal.l.verma@intel.com>
 <20170222224724.7696-4-vishal.l.verma@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170222224724.7696-4-vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> (Vishal Verma's
 message of "Wed, 22 Feb 2017 15:47:24 -0700")
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> writes:

> +# re-enable the BTT namespace, and do IO to it in an attempt to
> +# verify it still comes up ok, and functions as expected
> +post_repair_test()
> +{
> +	echo "${FUNCNAME[0]}: I/O to BTT namespace"
> +	test -b /dev/$blockdev
> +	dd if=/dev/zero of=/dev/$blockdev bs=$sector_size count=$((size/sector_size)) > /dev/null 2>&1
> +	dd if=/dev/$blockdev of=/dev/null bs=$sector_size count=$((size/sector_size)) > /dev/null 2>&1

Maybe validate the data you got?

> +	echo "done"
> +}
> +
> +test_normal()
> +{
> +	echo "=== ${FUNCNAME[0]} ==="
> +	# disable the namespace
> +	$ndctl disable-namespace $dev
> +	$ndctl check-namespace $dev

Shouldn't we ensure there are no errors reported by the check?

> +	$ndctl enable-namespace $dev
> +	post_repair_test
> +}
> +

[snip]

> +test_bitmap()
> +{
> +	echo "=== ${FUNCNAME[0]} ==="
> +	reset && create
> +	set_raw
> +	# scribble over the last 4K of the map
> +	rm -f /tmp/scribble
> +	for (( i=0 ; i<512 ; i++ )); do
> +		echo -n -e \\x1e\\x1e\\x00\\xc0\\x1e\\x1e\\x00\\xc0 >> /tmp/scribble
> +	done
> +	seek="$((raw_size/bs - (256*64/bs) - 2))"
> +	echo "scribbling over map entries (offset = $seek blocks)"
> +	dd if=/tmp/scribble of=/dev/$raw_bdev bs=$bs seek=$seek
> +	rm -f /tmp/scribble
> +	unset_raw
> +	$ndctl disable-namespace $dev
> +	$ndctl check-namespace $dev 2>&1 | grep "bitmap error"
> +	# This is not repairable
> +	reset && create
> +}
> +

Can you add a test to inject badblocks in the metadata?

Cheers,
Jeff
