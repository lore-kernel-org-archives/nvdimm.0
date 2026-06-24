Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25A23DBD5A;
	Wed, 24 Jun 2026 15:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313972; cv=none; b=F4Uc0qJ+xEBP9AZ7JEpDC2VkVEbomL3jvBzCGABe35p4u9s08P++NtBeOpFhMd/3lzlae1/8R0MOdFLYKb9xXfsGIOkSyBwbL0ylUwLUTC8Yr5FTCFfrexwiHrHm9C7PaNDK1QmDQTU3A0zHf5eOiuj83vwJiVGpa3hcaqpBKic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313972; c=relaxed/simple;
	bh=PYYsBn/shyhf0VG43nhCnvn4lfx0blk03LPeYsmqjIc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nsOon9AkbXpWMvqHGj6m85zOmM2ViNN+WMGYd/nIWZySBgNivN+6wwkLwbiMBG/UQjLUbjRjqF2tsFdb5VY86ms0o6m4A04rR2kB6tWE7P99Sh/UajpYmBIZsIhgMWCzqrha04aFQon4iixcwj8C+ZaaLRRI1gCJpHJx4XJcpwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzJfjSjh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzJfjSjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3961F00A3A;
	Wed, 24 Jun 2026 15:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313971;
	bh=xiWczev4rm26HS1dPcVgB0XgpHbON8oXHkp46rCsGoo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dzJfjSjhN4Pq9vG2SbkTW43NuotTs3HAGSYxK06sEooTTX9Yc2PztLFmpQmA8B+MK
	 ghHzikJg103O7h609I1YQt+HyHkaQm41E92tHcbRwn7/ZhAFn4O8++c8TnaP1asMlM
	 WMj2nD+7WTDP/HO8GlWiCf2KUuEHg3iqhqQg8UQki6IlIxMdB4ZaVZHMePKV6ZzJLT
	 c/YJLTPjCGJpJubtkiw0mk2VUlSPiDXUvDiSPCxWwl8MjdXd0d95yn+GURzuiUwOXl
	 ziJUuvq1lmqU949VSjdupjjQDoNuyoxkjPozsnLovVoqZor/boGbmrHkvVEsPUl6Xv
	 +tofdF0Kr5c2Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 9/9] selftests/dax: add dax/kmem hotplug sysfs
 regression test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gregory Price" <gourry@gourry.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260624145744.3532049-10-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-10-gourry@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:12:50 +0000
Message-Id: <20260624151251.5B3961F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Cascading test failures due to unhandled baseline restoration fa=
ilure.
- [Medium] Device state restoration is clobbered before the destructive tes=
t, leaving the device altered if the test is skipped.
--

commit 86db030de2c10bd6941657c29afc9ffc162f74b5
Author: Gregory Price <gourry@gourry.net>

selftests/dax: add dax/kmem hotplug sysfs regression test

This commit adds a kselftest for the dax/kmem whole-device "state" sysfs
attribute to validate transitions between unplugged, online, and
online_movable.

> diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/test=
ing/selftests/dax/dax-kmem-hotplug.sh
> new file mode 100755
> index 0000000000000..803bbd5a64098
> --- /dev/null
> +++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh

[ ... ]

> +set_state unplugged; rc=3D$?
> +mt=3D$(memtotal_kb)
> +if [ "$rc" !=3D 0 ]; then
> +	ktap_test_skip "unplug from movable not accepted (memory in use?) rc=3D=
$rc"
> +elif [ "$(get_state)" =3D unplugged ] && [ "$mt" -lt "$mt_movable" ]; th=
en
> +	ktap_test_pass "unplug from online_movable removed memory: $mt_movable =
-> $mt kB"
> +else
> +	ktap_test_fail "unplug from movable reported success but memory remaine=
d: state=3D$(get_state) MemTotal $mt_movable -> $mt"
> +fi
> +
> +set_state online_kernel; rc=3D$?

[Severity: Medium]
If the unplug command fails and we emit the ktap_test_skip message, the scr=
ipt
continues execution to the online_kernel test.

Since that test expects an unplugged baseline, does this lead to cascading
spurious test failures if the memory couldn't be offlined?

[ ... ]

> +[ -n "$ORIG" ] && set_state "$ORIG"
> +
> +# DESTRUCTIVE: unbinding the driver while memory is online causes the re=
sources
> +# to leak - but the unbind should not deadlock.  Instead the driver leak=
s it
> +# with a single "suck online" warning. This leaves the memory online and=
 the
> +# device unbound until reboot, so it runs last.
> +set_state unplugged; set_state online
> +if [ "$(get_state)" =3D online ] && [ -w "$DRV/unbind" ]; then

[Severity: Medium]
We restore the original state of the device here, but then unconditionally
overwrite it by running "set_state unplugged; set_state online" before chec=
king
if the destructive test can actually run.

If $DRV/unbind is not writable, the test is skipped and the script exits.

Does this leave the device permanently altered (left "online") instead of in
its original state?

> +	mt_on=3D$(memtotal_kb)
> +	dmesg -C 2>/dev/null
> +	echo "$DAX" > "$DRV/unbind" 2>/dev/null
> +	mt_after=3D$(memtotal_kb)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624145744.3532=
049-1-gourry@gourry.net?part=3D9
