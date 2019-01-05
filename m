Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D51C211AEA57
 for <linux-nvdimm@lists.01.org>; Fri,  4 Jan 2019 17:21:33 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 06/12] ndctl: add unit test for security ops (minus
 overwrite)
Date: Sat, 5 Jan 2019 01:21:31 +0000
Message-ID: <85084f33914e23835d93e6e0e225ce207dda4e64.camel@intel.com>
References: <154482154540.65434.14399161818571651882.stgit@djiang5-desk3.ch.intel.com>
 <154482177593.65434.4385425536053044648.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154482177593.65434.4385425536053044648.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <D5C540E3067EE94791D4321F1E298E76@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-12-14 at 14:09 -0700, Dave Jiang wrote:
> Add unit test for security enable, disable, update, erase, unlock, and
> freeze.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/Makefile.am |    4 +
>  test/security.sh |  191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 195 insertions(+)
>  create mode 100755 test/security.sh
> 
> diff --git a/test/Makefile.am b/test/Makefile.am
> index ebdd23f6..42009c31 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -27,6 +27,10 @@ TESTS =\
>  	max_available_extent_ns.sh \
>  	pfn-meta-errors.sh
>  
> +if ENABLE_KEYUTILS
> +TESTS += security.sh
> +endif
> +
>  check_PROGRAMS =\
>  	libndctl \
>  	dsm-fail \
> diff --git a/test/security.sh b/test/security.sh
> new file mode 100755
> index 00000000..5238c9c4
> --- /dev/null
> +++ b/test/security.sh
> @@ -0,0 +1,191 @@
> +#!/bin/bash -Ex
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2018 Intel Corporation. All rights reserved.
> +
> +rc=77
> +dev=""
> +id=""
> +dev_no=""
> +sstate=""
> +KEYPATH="/etc/ndctl/keys"
> +UNLOCK="/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm"
> +MASTERKEY="nvdimm-master-test"
> +MASTERPATH="$KEYPATH/$MASTERKEY"

Local-only variables don't need to be all uppercase. By convention,
only variables you export are uppercase.

> +
> +. ./common
> +
> +trap 'err $LINENO' ERR
> +
> +setup()
> +{
> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all

quote all "$expansions".
Generally, consider running the script through shellchek for styling
problems.

> +}
> +
> +detect()
> +{
> +	dev=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].dev | tr -d '"')
> +	[ -n "$dev" ] || err "$LINENO"
> +	id=$($NDCTL list -b $NFIT_TEST_BUS0 -D | jq .[0].id | tr -d '"')
> +	[ -n "$id" ] || err "$LINENO"
> +}
> +
> +setup_keys()
> +{
> +	if [ ! -f $MASTERPATH ]; then
> +		keyctl add user $MASTERKEY "`dd if=/dev/urandom bs=1 count=32 2>/dev/null`" @u

Applies everyehere in the script - prefer "$()" instead of backticks.
Also before using keyctl, lets make sure it is installed. test/common
provides a function for this - check_prereq()

> +		keyctl pipe `keyctl search @u user $MASTERKEY` > $MASTERPATH

Before the first use, would be a good idea to make sure keypath exists.

> +	else
> +		echo "Unclean setup. Please cleanup $MASTERPATH file."
> +		exit 1
> +	fi
> +}
> +
> +test_cleanup()
> +{
> +	keyctl unlink `keyctl search @u encrypted nvdimm:$id`
> +	keyctl unlink `keyctl search @u user $MASTERKEY`
> +	rm -f $KEYPATH/nvdimm_$id\_`hostname`.blob
> +	rm -f $MASTERPATH
> +}
> +
> +locking_dimm()

Do you mean "unlock_dimm()" ?

> +{
> +	$NDCTL disable-dimm $dev
> +	dev_no=$(echo $dev | cut -b 5-)
> +	echo 1 > "$UNLOCK$dev_no/lock_dimm"

Best to explicitly delineate each variable using ${}:
"${path}/${id}/lock_dimm"
Also 'unlock' isn't very descriptive, maybe 'unlock_path'? It also
contains "nfit_test.0" which should be obtained from the variable
"$NFIT_TEST_BUS0".


> +	get_security_state

See below

> +	if [ "$sstate" != "locked" ]; then
> +		echo "Incorrect security state: $sstate expected: disabled"
> +		exit 1
> +	fi
> +}
> +
> +get_security_state()
> +{
> +	sstate=$($NDCTL list -i -b $NFIT_TEST_BUS0 -d $dev | jq .[].dimms[0].security | tr -d '"')
> +	[ -n "$sstate" ] || err "$LINENO"

Avoid setting global variables, it is easy to lose track of what has
been set where. Instead make helper functions like this simply print
their result as the output. Then call them like so:
sstate="$(get_security_state)"
make the '-n' check the responsibility of the caller, and this function
could simply be:

	get_security_state()
	{
		$NDCTL list -i -b $NFIT_TEST_BUS0 -d $dev | jq .[].dimms[0].security | tr -d '"'
	}

In most of these cases, since you are checking for sstate to be exactly
"some-state", you don't even need a -n check.

> +}
> +
> +enable_passphrase()
> +{
> +	$NDCTL enable-passphrase -m user:$MASTERKEY $dev
> +	get_security_state
> +	if [ "$sstate" != "unlocked" ]; then
> +		echo "Incorrect security state: $sstate expected: unlocked"
> +		exit 1
> +	fi
> +}
> +
> +disable_passphrase()
> +{
> +	$NDCTL disable-passphrase $dev
> +	get_security_state
> +	if [ "$sstate" != "disabled" ]; then
> +		echo "Incorrect security state: $sstate expected: disabled"
> +		exit 1
> +	fi
> +}
> +
> +erase_security()
> +{
> +	$NDCTL sanitize-dimm -c $dev
> +	get_security_state
> +	if [ "$sstate" != "disabled" ]; then
> +		echo "Incorrect security state: $sstate expected: disabled"
> +		exit 1
> +	fi
> +}
> +
> +update_security()
> +{
> +	$NDCTL update-passphrase -m user:$MASTERKEY $dev
> +	get_security_state
> +	if [ "$sstate" != "unlocked" ]; then
> +		echo "Incorrect security state: $sstate expected: unlocked"
> +		exit 1
> +	fi
> +}
> +
> +freeze_security()
> +{
> +	$NDCTL freeze-security $dev
> +}
> +
> +test_1_security_enable_and_disable()
> +{
> +	enable_passphrase
> +	disable_passphrase
> +}
> +
> +test_2_security_enable_and_update()
> +{
> +	enable_passphrase
> +	update_security
> +	disable_passphrase
> +}
> +
> +test_3_security_enable_and_erase()
> +{
> +	enable_passphrase
> +	erase_security
> +}
> +
> +test_4_security_unlocking()
> +{
> +	enable_passphrase
> +	locking_dimm
> +	$NDCTL enable-dimm $dev
> +	get_security_state
> +	if [ "$sstate" != "unlocked" ]; then
> +		echo "Incorrect security state: $sstate expected: unlocked"
> +		exit 1
> +	fi
> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
> +	disable_passphrase
> +}
> +
> +# this should always be the last test. with security frozen, nfit_test must
> +# be removed and is no longer usable
> +test_5_security_freeze()
> +{
> +	enable_passphrase
> +	freeze_security
> +	get_security_state
> +	if [ "$sstate" != "frozen" ]; then
> +		echo "Incorrect security state: $sstate expected: frozen"
> +		exit 1
> +	fi
> +	$NDCTL disable-passphrase $dev && { echo "diable succeed after frozen"; exit 1; }

What is the 'exit 1' here for? Shouldn't we just fall through and check
the  state explicitly anyway, even after a successful disable? And if
so, no need to echo the success message, the state will just get
checked later.

> +	get_security_state
> +	echo $sstate
> +	if [ "$sstate" != "frozen" ]; then
> +		echo "Incorrect security state: $sstate expected: disabled"
> +		exit 1
> +	fi
> +}
> +
> +check_min_kver "4.21" || do_skip "may lack security test handling"

"may lack security enabling" - its not just the test infrastructure
that was added in 4.21

> +
> +modprobe nfit_test
> +rc=1
> +setup
> +rc=2
> +detect
> +setup_keys
> +echo "Test 1, security enable and disable"
> +test_1_security_enable_and_disable
> +echo "Test 2, security enable, update, and disable"
> +test_2_security_enable_and_update
> +echo "Test 3, security enable and erase"
> +test_3_security_enable_and_erase
> +echo "Test 4, unlocking dimm"
> +test_4_security_unlocking
> +
> +# Freeze should always be run last because it locks security state and require
> +# nfit_test module unload.
> +echo "Test 5, freeze security"
> +test_5_security_freeze
> +
> +test_cleanup
> +_cleanup
> +exit 0
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
