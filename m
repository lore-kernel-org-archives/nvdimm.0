Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B8C23D7FB
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609349; cv=none; b=bweMqR2W1UaAgrXKvJCGLktf4ytcKbFrmDoWhOfxWzr+3RFuTjphtUsCn16bD/RdX5oXjmmw4on5S1qrq0Iy+UKEnA93Zlj95/MjKM6uF29Fczr9MbqVmBDZmGpydeE9YrkBO19DntyV1nMrOJJ2ol97m8thyFP7rU+JeTXQtM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609349; c=relaxed/simple;
	bh=fepsh5ZczHejHQ+pIB0aAVXMjOsC+Df3zI2s8R/oI7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcYL9REeZU4Us44Fz3UFJZW+Jjv1iVhh2rfQTv0aFhxt6aa9Y30kNeI9tXXfX7Cful08lo3VBzfdrGYxsNmqIQuo6T6jlMVtMVCtM5zX0keAIs/XK5+8wSiVlcsrrp4AOlhz/bnnSsu5a9kJPS+cjbL9nXwT9a27/tW/mn1ZPmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Uhfqi8gW; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Uhfqi8gW"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2a818fc4so13616851cf.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 08:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609346; x=1784214146; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RdnglpUnnAqtjCVM1uDDgn3DSuviUHWvWM6L5ZEdJ9w=;
        b=Uhfqi8gW2zWa27C8GDSY8lESxG4Doz9BhP4jmr2TW/I3DqzlhB5pJrmRaLvNhnfldA
         ANOGp3OO9ZeKzVYAseHnBGwtc5lN36sC1SmI54OFc39QnTc+AwoiScmgzfiZAjaMMoqa
         c625Dwjz04YOLQ1DEhQwU7NQy7BRpbXwUY7CcvuApoa7mY2RoxHNgwc0i/MaU8bI4lUY
         AeIrpvYdQ/pL4Euq75gUl1lofw11fjL25SV/oXr8iTfbJtqB9aeXitH9OZRRdLtubGLn
         Hs77neNCii8WJ9HTwbx0LJqL2x96rqGS0j5/bCm5dSbrFxmZnuatqSPGRCUwlWEaMtC+
         Fqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609346; x=1784214146;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RdnglpUnnAqtjCVM1uDDgn3DSuviUHWvWM6L5ZEdJ9w=;
        b=gVpBrELgDQYQj1NLdBl5uKpswwEpYg4BRqJClSUtVLfyBNQPSujIe3e6pGKD+RLMZn
         60tceLzWrlAV5hWU8c2PEhL/ehUhk4N4avef2SCNuO1g2pneTZZ5A97O/BX2iCy2u3aY
         hJ/N/nA+v7fSDqTqK7SVxJUGhL0R6dFrICON13F9rLduGrVchPfsCjT3gtnjysYYnC4w
         8JY09uMjDsd/YJWnMSZ/1sTWfMlpVpSezu/WMFW5k2p4+bUbDuZLtaOKOL6dHSHeRHGT
         eGeVrl/2rnqIwJktHLQceajS2tYeDZbA80SR4hIgsPXhmiVC979Gkm/D19zbPjbqdudF
         G8SA==
X-Forwarded-Encrypted: i=1; AHgh+RrFOacYesZx0aI2a+xzuSBelRH3hfL+EZne9+OgqtZesa4bDJ0tPkae5eGFurxmP0vK6GJDItM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yys9Uv5fOmbPqmthGEyl7NptbirNz4VJttGjLoHaxh9+RC9ZPDV
	sKxaW/WvdyngXhvPWNpNB6OT5d/Xfikq/6WEUNZf4Wx/7k1Msjm/lb7azSHocYF26AE=
X-Gm-Gg: AfdE7cnyPv9cYrWqSbIRlYgmwzHIy7RbBhffU8Vpho2LIVUL00DJzrgTnwL5jJAgXLQ
	RoMUNnFaudozfwW3k1GxmYIWmycqJLNgfJLwZ0192sK4MhPmyVpcylmZDz93pC69krxHnFNpzr1
	3s5XQyuCyRqZ7wSckWiVTPUGcDJfgZJFda5/V53MXyh5YX1OLVgB+GjoJU4pr1XM4rG2S9yQzqI
	qHjMi2icJlKVnY5chFqsbjF+3aNCUGag13RDBY4wPrbp1YiTjIa83K4c8IHKVrfHyxXg5p+E79n
	T+55Y6SItcNh/VYNA/u+adgxGhmX6y3nfcykwjSIpcQGGDXZqwPelUyk4zjIPVS0eRUqwyNcaFo
	j7NO9lEgMctGlYNusrxPl8LYfoZyX5Y2myFlZa4O175oJ8suyGIIOLkBwQBaCPu3dnrC6M736ss
	BEwn543T/GmknlFj2FDiD/3s3wtfViMgCQstL4pgz0r93OJ0xf/RBQOx7B+GqanTBqQ0MwvN+jS
	wCnc34=
X-Received: by 2002:ac8:5ccb:0:b0:51c:52a:8e70 with SMTP id d75a77b69052e-51c8b400931mr88109581cf.2.1783609345738;
        Thu, 09 Jul 2026 08:02:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41dad192sm173838841cf.23.2026.07.09.08.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:02:23 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:02:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 10/10] selftests/dax: add dax/kmem hotplug sysfs
 regression test
Message-ID: <ak-3-0OZt09mfeWp@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-11-gourry@gourry.net>
 <ak9Y1UTTe3Hl6rVN@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9Y1UTTe3Hl6rVN@MWDK4CY14F>

On Thu, Jul 09, 2026 at 04:20:00PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 05:18:42PM +0800, Gregory Price wrote:
> > Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
> > (/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
> > dax device between "unplugged", "online" and "online_movable".
> > 
> > The kselftest also includes a test to demonstrate the force-unbind
> > does not deadlock - but this is a destructive test.  The dax device
> > can never be rebound after doing this.
> > 
> > Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
> > out of scope for an in-tree selftest, so the test discovers an already
> > kmem-bound dax device and SKIPs when none are present or the memory
> > cannot be freed to reach a known baseline.
> > 
> > When a device is available it validates the interface contract:
> >   - online / online_movable actually add memory (MemTotal grows),
> >   - online is idempotent,
> >   - switching between online types without unplug is rejected,
> >   - unplug removes memory and the reported state is "unplugged"
> >   - invalid input is rejected.
> > 
> > One specific regression test:
> >     online -> unplug -> online_movable -> unplug
> > 
> > Re-online must re-reserve per-range resources so subsequent unplug
> > actually offlines and removes instead of silently reporting success
> > while the memory stays online.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  tools/testing/selftests/Makefile              |   1 +
> >  tools/testing/selftests/dax/Makefile          |   6 +
> >  tools/testing/selftests/dax/config            |   4 +
> >  .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 ++++++++++++++++++
> >  tools/testing/selftests/dax/settings          |   1 +
> >  5 files changed, 202 insertions(+)
> >  create mode 100644 tools/testing/selftests/dax/Makefile
> >  create mode 100644 tools/testing/selftests/dax/config
> >  create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
> >  create mode 100644 tools/testing/selftests/dax/settings
> > 
> > diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> > index 6e59b8f63e41..8c2b4f97619c 100644
> > --- a/tools/testing/selftests/Makefile
> > +++ b/tools/testing/selftests/Makefile
> > @@ -14,6 +14,7 @@ TARGETS += core
> >  TARGETS += cpufreq
> >  TARGETS += cpu-hotplug
> >  TARGETS += damon
> > +TARGETS += dax
> >  TARGETS += devices/error_logs
> >  TARGETS += devices/probe
> >  TARGETS += dmabuf-heaps
> > diff --git a/tools/testing/selftests/dax/Makefile b/tools/testing/selftests/dax/Makefile
> > new file mode 100644
> > index 000000000000..25a4f3d73a5b
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/Makefile
> > @@ -0,0 +1,6 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +all:
> > +
> > +TEST_PROGS := dax-kmem-hotplug.sh
> > +
> > +include ../lib.mk
> > diff --git a/tools/testing/selftests/dax/config b/tools/testing/selftests/dax/config
> > new file mode 100644
> > index 000000000000..4c9aaeb6ceb4
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/config
> > @@ -0,0 +1,4 @@
> > +CONFIG_DEV_DAX=m
> > +CONFIG_DEV_DAX_KMEM=m
> > +CONFIG_MEMORY_HOTPLUG=y
> > +CONFIG_MEMORY_HOTREMOVE=y
> > diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> > new file mode 100755
> > index 000000000000..c8bbaf6178ed
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
> > @@ -0,0 +1,190 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Exercise the dax/kmem "state" sysfs attribute:
> > +#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
> > +#
> > +# The test needs a dax device already bound to the kmem driver.
> > +# If no suitable device is found the tests SKIP.
> > +#
> > +# A dax device can be provisioned with the memmap= boot param, e.g.:
> > +#   memmap=2G!4G
> > +#
> > +# then, in the booted system:
> > +#
> > +#   ndctl create-namespace -m devdax -e namespace0.0 -f
> > +#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
> > +#   ./dax-kmem-hotplug.sh
> > +
> > +# shellcheck disable=SC1091
> > +DIR="$(dirname "$(readlink -f "$0")")"
> > +. "$DIR"/../kselftest/ktap_helpers.sh
> > +
> > +DAX_BASE=/sys/bus/dax/devices
> > +
> > +memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
> > +get_state() { cat "$HP" 2>/dev/null; }
> > +# set_state STATE -- write a state to the state attribute; returns the
> > +# write's exit status (0 = accepted by the kernel)
> > +set_state() { echo "$1" > "$HP" 2>/dev/null; }
> > +
> > +find_kmem_dax() {
> > +	local d drv
> > +	for d in "$DAX_BASE"/dax*; do
> > +		[ -e "$d/state" ] || continue
> > +		drv=$(readlink "$d/driver" 2>/dev/null)
> > +		[ "$(basename "${drv:-}")" = kmem ] || continue
> > +		basename "$d"
> > +		return 0
> > +	done
> > +	return 1
> > +}
> 
> It picks the first kmem-bound dax device and runs online/offline cycles on it.
> If the selected device is a real device with production usage, offlining movable
> memory will migrate all in-use pages.
> 
> Could the destructive parts be gated behind an opt-in, e.g. an environment var ?
> Or find the testable backend device instead of just picking the first one?
>

I think probably easiest to just include an environment variable, as
some people may in fact want to run this on a real device. 

Will work this in.

Thank you
~Gregory

> Best regards,
> Richard Cheng.
> 
> > +
> > +ktap_print_header
> > +
> > +if [ "$UID" != 0 ]; then
> > +	ktap_skip_all "must be run as root"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +
> > +DAX=$(find_kmem_dax)
> > +if [ -z "$DAX" ]; then
> > +	ktap_skip_all "no kmem-bound dax device with a state attribute"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +HP=$DAX_BASE/$DAX/state
> > +ORIG=$(get_state)
> > +
> > +# A failure to reach the baseline is environmental (memory in use), not an
> > +# interface failure, so skip rather than fail.
> > +set_state unplugged; rc=$?
> > +if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
> > +	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
> > +	[ -n "$ORIG" ] && set_state "$ORIG"
> > +	exit "$KSFT_SKIP"
> > +fi
> > +mt_unplugged=$(memtotal_kb)
> > +
> > +DRV=/sys/bus/dax/drivers/kmem
> > +AOB=/sys/devices/system/memory/auto_online_blocks
> > +
> > +ktap_print_msg "using $DAX (initial state was: $ORIG)"
> > +ktap_set_plan 8
> > +
> > +# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
> > +# collects unmovable allocations and can then never be offlined, which would
> > +# wedge the device for the rest of this test.  So this test only ever
> > +# successfully onlines online_movable, the one mode that is reliably unpluggable.
> > +
> > +set_state online_movable; rc=$?
> > +mt_online=$(memtotal_kb)
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
> > +	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
> > +else
> > +	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
> > +fi
> > +
> > +set_state online_movable; rc=$?
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
> > +	ktap_test_pass "online_movable idempotent"
> > +else
> > +	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +# A different online type is rejected without an intervening unplug.  The write
> > +# is refused before any hotplug, so this never actually onlines a kernel zone.
> > +set_state online_kernel; rc=$?
> > +if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
> > +	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
> > +else
> > +	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +set_state unplugged; rc=$?
> > +mt=$(memtotal_kb)
> > +if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
> > +	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
> > +else
> > +	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
> > +fi
> > +
> > +before=$(get_state)
> > +set_state bogus_state; rc=$?
> > +if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
> > +	ktap_test_pass "reject invalid state string"
> > +else
> > +	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
> > +fi
> > +
> > +# The online_movable -> unplug cycle once regressed: a re-online failed to
> > +# re-reserve the per-range resources, so a later unplug reported success while
> > +# leaving the memory online.  Assert each iteration really adds and frees memory.
> > +set_state unplugged
> > +cycle_ok=1; fail_i=0; on=0; off=0
> > +for i in 1 2 3; do
> > +	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
> > +	on=$(memtotal_kb)
> > +	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
> > +	off=$(memtotal_kb)
> > +	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -ge "$on" ]; then
> > +		cycle_ok=0; fail_i=$i; break
> > +	fi
> > +done
> > +if [ "$cycle_ok" = 1 ]; then
> > +	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
> > +else
> > +	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
> > +fi
> > +
> > +# change system default online policy while the device is unbound, and show
> > +# the new system default policy is utilized across bindings.
> > +set_state unplugged
> > +if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
> > +	orig_aob=$(cat "$AOB")
> > +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> > +	echo offline > "$AOB" 2>/dev/null
> > +	echo "$DAX" > "$DRV/bind" 2>/dev/null
> > +	sleep 1
> > +	st=$(get_state)
> > +	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
> > +	if [ "$st" = offline ]; then
> > +		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
> > +	else
> > +		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
> > +	fi
> > +	set_state unplugged 2>/dev/null
> > +else
> > +	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
> > +fi
> > +
> > +[ -n "$ORIG" ] && set_state "$ORIG"
> > +
> > +# DESTRUCTIVE: unbinding the driver while memory is online causes the resources
> > +# to leak - but the unbind should not deadlock.  Instead the driver leaks it
> > +# with a single "stuck online" warning. This leaves the memory online and the
> > +# device unbound until reboot, so it runs last - and only if we can run it,
> > +# leaving the restored state above untouched otherwise.  online_movable only:
> > +# this test never onlines a public node into a kernel zone.
> > +if [ -w "$DRV/unbind" ]; then
> > +	set_state unplugged; set_state online_movable
> > +fi
> > +if [ "$(get_state)" = online_movable ] && [ -w "$DRV/unbind" ]; then
> > +	mt_on=$(memtotal_kb)
> > +	dmesg -C 2>/dev/null
> > +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> > +	mt_after=$(memtotal_kb)
> > +	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
> > +	# their names dereferences res_name, which a buggy unbind already freed.
> > +	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
> > +	cat /proc/iomem > /dev/null 2>&1
> > +	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
> > +	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
> > +		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
> > +	else
> > +		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
> > +	fi
> > +else
> > +	ktap_test_skip "could not online device for unbind-while-online test"
> > +fi
> > +
> > +ktap_finished
> > diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
> > new file mode 100644
> > index 000000000000..ba4d85f74cd6
> > --- /dev/null
> > +++ b/tools/testing/selftests/dax/settings
> > @@ -0,0 +1 @@
> > +timeout=90
> > -- 
> > 2.53.0-Meta
> > 
> > 
