Received: from a11-132.smtp-out.amazonses.com (a11-132.smtp-out.amazonses.com [54.240.11.132])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F784402BA0
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 17:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779814961; cv=none; b=mtJgCbQCQApGhpjZo/pMyaENku+qDZF1bQmUV5alGk2YOeAOzY+70ZVmogZN7s069DQZBS3Bxv5EBJLyVvT1b/Ekgc5LbND32n91W1Y4+lywNdHZ0ZinxBO+jRmXfMXBpRD2EHW8GWXb+jKwe/Qhn68Ou9xw52K83KppvL9x7Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779814961; c=relaxed/simple;
	bh=DY5oh7jG9i+YFcbdHwAYFPmXpO2Ppo6LD+vZt3X+1Vc=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=l/7uEOqHPFhHZwCmu0A3enreD4V9/67ZtQxH48iopQdt4ADAxga3hgJr/MpjkKrs0rym+T70E+iUsjgV1g6m2vXMwXzcAzTM1t4gV4RnFS2XFZgebC5JRP7wQJ165gczImhCcz1ELrgHgcm5seYjW7ZM+wa3AxFzPLH8Dx/+Wu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=T+1OOKbc; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=CvSRxeSC; arc=none smtp.client-ip=54.240.11.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="T+1OOKbc";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CvSRxeSC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1779814958;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=DY5oh7jG9i+YFcbdHwAYFPmXpO2Ppo6LD+vZt3X+1Vc=;
	b=T+1OOKbcfluKWDsz7+kv8gSINDqzH7Zmrly04BQe75iT/oYtezmFJi3J3Q56KSps
	HE9qUZthhbL8tB7p1mFGM8M9xDB3Tg+8s5FomwY3dwHTFN9eqhqPcDKoyz9CqWWfxJW
	dCRegGuzAAmzT5ICoUqjV+X6uZuELQN5pTXNO1sc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1779814958;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=DY5oh7jG9i+YFcbdHwAYFPmXpO2Ppo6LD+vZt3X+1Vc=;
	b=CvSRxeSC5ZWwCd5v2Sp+tz5DzeNhhyKBx/RTgoeumqTr7hj03C0rFsy4tprThfs1
	6VBAE1fNj5yHaz/OVUc54bvajSc0HiTgZqhLY04lBlLpqujZGudlDNMvEP80JH/cAFy
	WFvQsT2wSVk4iz+deqtnC+lIGQOPrCMgyNLNzNs0=
Subject: [PATCH V6 2/2] Add nfit_test famfs mode-transition test
From: =?UTF-8?Q?John_Groves?= <john@jagalactic.com>
To: =?UTF-8?Q?John_Groves?= <John@Groves.net>, 
	=?UTF-8?Q?John_Groves?= <jgroves@fastmail.com>, 
	=?UTF-8?Q?Dan_Williams?= <djbw@kernel.org>, 
	=?UTF-8?Q?Alison_Schofield?= <alison.schofield@intel.com>
Cc: =?UTF-8?Q?John_Groves?= <jgroves@micron.com>, 
	=?UTF-8?Q?Vishal_Verma?= <vishal.l.verma@intel.com>, 
	=?UTF-8?Q?Dave_Jiang?= <dave.jiang@intel.com>, 
	=?UTF-8?Q?Jonathan_Cameron?= <Jonathan.Cameron@huawei.com>, 
	=?UTF-8?Q?Aravind_Ramesh?= <arramesh@micron.com>, 
	=?UTF-8?Q?Ajay_Joshi?= <ajayjoshi@micron.com>, 
	=?UTF-8?Q?venkataravis=40micron=2Ecom?= <venkataravis@micron.com>, 
	=?UTF-8?Q?dev=2Esrinivasulu=40gmail=2Ecom?= <dev.srinivasulu@gmail.com>, 
	=?UTF-8?Q?linux-kernel=40vger=2Ekernel=2E?= =?UTF-8?Q?org?= <linux-kernel@vger.kernel.org>, 
	=?UTF-8?Q?nvdimm=40lists=2E?= =?UTF-8?Q?linux=2Edev?= <nvdimm@lists.linux.dev>, 
	=?UTF-8?Q?linux-cxl=40v?= =?UTF-8?Q?ger=2Ekernel=2Eorg?= <linux-cxl@vger.kernel.org>, 
	=?UTF-8?Q?John_Groves?= <john@groves.net>
Date: Tue, 26 May 2026 17:02:38 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com>
References: 
 <0100019e653c6c88-44f88088-8c87-4163-b88b-b3f3fc7aa726-000000@email.amazonses.com> 
 <20260526170233.56434-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc7TFcILV7h5r+TK67r8Gpp/8CFwAABfYD
Thread-Topic: [PATCH V6 2/2] Add nfit_test famfs mode-transition test
X-Wm-Sent-Timestamp: 1779814957
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019e653d0570-ee57c906-e1e7-4981-8693-72ceea9ec72b-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.05.26-54.240.11.132

From: John Groves <John@Groves.net>=0D=0A=0D=0AAdd test/daxctl-famfs-nfit=
=2Esh, which builds its own dax device from the=0D=0Aemulated ACPI.NFIT b=
us (nfit_test) so it runs in the ndctl unit-test model=0D=0Arather than s=
canning for a pre-existing dax device.=0D=0A=0D=0Anfit_test ranges have r=
eal DRAM backing, so kmem onlining works and the full=0D=0Atransition mat=
rix runs end-to-end:=0D=0A=0D=0A- devdax <-> famfs switches, including sa=
me-mode re-enable=0D=0A- system-ram <-> devdax <-> famfs, with real memor=
y online/offline=0D=0A- system-ram -> famfs is rejected (the conversion m=
ust go via devdax)=0D=0A- JSON output reports the correct mode=0D=0A- inv=
alid modes are rejected=0D=0A=0D=0AThe test follows the existing ndctl te=
st style: 'set -x' command logging,=0D=0Aerr/cleanup traps, check_dmesg a=
t completion, and fixture teardown rather=0D=0Athan restore-to-original c=
leanup.=0D=0A=0D=0ASuggested-by: Alison Schofield <alison.schofield@intel=
=2Ecom>=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=0A---=0D=0A =
test/daxctl-famfs-nfit.sh | 215 ++++++++++++++++++++++++++++++++++++++=0D=
=0A test/meson.build          |   2 +=0D=0A 2 files changed, 217 insertio=
ns(+)=0D=0A create mode 100755 test/daxctl-famfs-nfit.sh=0D=0A=0D=0Adiff =
--git a/test/daxctl-famfs-nfit.sh b/test/daxctl-famfs-nfit.sh=0D=0Anew fi=
le mode 100755=0D=0Aindex 0000000..5730279=0D=0A--- /dev/null=0D=0A+++ b/=
test/daxctl-famfs-nfit.sh=0D=0A@@ -0,0 +1,215 @@=0D=0A+#!/bin/bash -Ex=0D=
=0A+# SPDX-License-Identifier: GPL-2.0=0D=0A+# Copyright (C) 2025 Micron =
Technology, Inc. All rights reserved.=0D=0A+#=0D=0A+# Test daxctl famfs m=
ode transitions and mode detection, targeting a=0D=0A+# nfit_test-backed =
dax device.=0D=0A+#=0D=0A+# nfit_test-backed dax devices have real DRAM b=
acking, so kmem onlining=0D=0A+# works normally. This test exercises the =
full matrix of transitions=0D=0A+# between devdax, famfs, and system-ram.=
=0D=0A+=0D=0A+rc=3D77=0D=0A+. $(dirname $0)/common=0D=0A+=0D=0A+trap 'cle=
anup $LINENO' ERR=0D=0A+=0D=0A+testbus=3D""=0D=0A+testdev=3D""=0D=0A+daxd=
ev=3D""=0D=0A+=0D=0A+cleanup()=0D=0A+{=0D=0A+=09# Best-effort return to d=
evdax so destroy-namespace can succeed.=0D=0A+=09if [[ -n $daxdev ]]; the=
n=0D=0A+=09=09"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" 2>/dev/=
null || true=0D=0A+=09fi=0D=0A+=09[[ -n $testdev ]] && reset_dev=0D=0A+=09=
err "$1"=0D=0A+}=0D=0A+=0D=0A+check_fsdev_dax()=0D=0A+{=0D=0A+=09modinfo =
fsdev_dax &>/dev/null && return 0=0D=0A+=09grep -qF "fsdev_dax" "/lib/mod=
ules/$(uname -r)/modules.builtin" 2>/dev/null && return 0=0D=0A+=09do_ski=
p "fsdev_dax module not available"=0D=0A+}=0D=0A+=0D=0A+check_kmem()=0D=0A=
+{=0D=0A+=09modinfo kmem &>/dev/null && return 0=0D=0A+=09grep -qF "kmem"=
 "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null && return 0=0D=0A=
+=09do_skip "kmem module not available"=0D=0A+}=0D=0A+=0D=0A+find_testdev=
()=0D=0A+{=0D=0A+=09testbus=3D"$ACPI_BUS"=0D=0A+=0D=0A+=09# Ensure the bu=
s has labels, like align.sh / daxctl-devices.sh rely on.=0D=0A+=09"$NDCTL=
" disable-region -b "$testbus" all=0D=0A+=09"$NDCTL" init-labels -f -b "$=
testbus" all=0D=0A+=09"$NDCTL" enable-region -b "$testbus" all=0D=0A+=0D=0A=
+=09testdev=3D$("$NDCTL" list -b "$testbus" -Ni | jq -er '.[0].dev | .//"=
"')=0D=0A+=09[[ $testdev ]] || do_skip "no victim device on $testbus"=0D=0A=
+}=0D=0A+=0D=0A+setup_dev()=0D=0A+{=0D=0A+=09test -n "$testbus"=0D=0A+=09=
test -n "$testdev"=0D=0A+=0D=0A+=09"$NDCTL" destroy-namespace -f -b "$tes=
tbus" "$testdev"=0D=0A+=09# x86_64 memory hotplug can require up to a 2Gi=
B-aligned chunk of=0D=0A+=09# memory. Create a 4GiB namespace, so enough =
space is left after=0D=0A+=09# alignment for kmem + online.=0D=0A+=09test=
dev=3D$("$NDCTL" create-namespace -b "$testbus" -m devdax -fe "$testdev" =
-s 4G | \=0D=0A+=09=09jq -er '.dev')=0D=0A+=09test -n "$testdev"=0D=0A+=0D=
=0A+=09daxdev=3D$("$NDCTL" list -n "$testdev" -X | jq -er '.[].daxregion.=
devices[0].chardev')=0D=0A+=09test -n "$daxdev"=0D=0A+}=0D=0A+=0D=0A+rese=
t_dev()=0D=0A+{=0D=0A+=09"$NDCTL" destroy-namespace -f -b "$testbus" "$te=
stdev"=0D=0A+}=0D=0A+=0D=0A+daxctl_get_mode()=0D=0A+{=0D=0A+=09"$DAXCTL" =
list -d "$1" | jq -er '.[].mode'=0D=0A+}=0D=0A+=0D=0A+save_online_policy(=
)=0D=0A+{=0D=0A+=09saved_policy=3D"$(cat /sys/devices/system/memory/auto_=
online_blocks)"=0D=0A+}=0D=0A+=0D=0A+restore_online_policy()=0D=0A+{=0D=0A=
+=09echo "$saved_policy" > /sys/devices/system/memory/auto_online_blocks=0D=
=0A+}=0D=0A+=0D=0A+unset_online_policy()=0D=0A+{=0D=0A+=09echo "offline" =
> /sys/devices/system/memory/auto_online_blocks=0D=0A+}=0D=0A+=0D=0A+ensu=
re_devdax_mode()=0D=0A+{=0D=0A+=09local mode=0D=0A+=09mode=3D$(daxctl_get=
_mode "$daxdev")=0D=0A+=0D=0A+=09case "$mode" in=0D=0A+=09devdax)      re=
turn 0 ;;=0D=0A+=09famfs)       "$DAXCTL" reconfigure-device -m devdax "$=
daxdev" >/dev/null ;;=0D=0A+=09system-ram)  "$DAXCTL" reconfigure-device =
-f -m devdax "$daxdev" >/dev/null ;;=0D=0A+=09*)=0D=0A+=09=09echo "unexpe=
cted starting mode: $mode"=0D=0A+=09=09return 1=0D=0A+=09=09;;=0D=0A+=09e=
sac=0D=0A+=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "devdax" ]]=0D=
=0A+}=0D=0A+=0D=0A+test_famfs_mode_transitions()=0D=0A+{=0D=0A+=09ensure_=
devdax_mode=0D=0A+=0D=0A+=09# devdax -> famfs=0D=0A+=09"$DAXCTL" reconfig=
ure-device -m famfs "$daxdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mode "$=
daxdev") =3D=3D "famfs" ]]=0D=0A+=0D=0A+=09# famfs -> famfs (re-enable in=
 same mode)=0D=0A+=09"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/de=
v/null=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "famfs" ]]=0D=0A+=0D=
=0A+=09# famfs -> devdax=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax =
"$daxdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "dev=
dax" ]]=0D=0A+=0D=0A+=09# devdax -> devdax (re-enable in same mode)=0D=0A=
+=09"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null=0D=0A+=09=
[[ $(daxctl_get_mode "$daxdev") =3D=3D "devdax" ]]=0D=0A+}=0D=0A+=0D=0A+t=
est_json_output()=0D=0A+{=0D=0A+=09ensure_devdax_mode=0D=0A+=09[[ $("$DAX=
CTL" list -d "$daxdev" | jq -er '.[].mode') =3D=3D "devdax" ]]=0D=0A+=0D=0A=
+=09"$DAXCTL" reconfigure-device -m famfs "$daxdev" >/dev/null=0D=0A+=09[=
[ $("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode') =3D=3D "famfs" ]]=0D=
=0A+=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax "$daxdev" >/dev/null=
=0D=0A+}=0D=0A+=0D=0A+test_error_handling()=0D=0A+{=0D=0A+=09"$DAXCTL" re=
configure-device -m famfs "$daxdev" >/dev/null=0D=0A+=0D=0A+=09# Invalid =
mode must be rejected=0D=0A+=09if "$DAXCTL" reconfigure-device -m invalid=
mode "$daxdev" &>/dev/null; then=0D=0A+=09=09echo "FAIL: invalid mode sho=
uld be rejected"=0D=0A+=09=09return 1=0D=0A+=09fi=0D=0A+=0D=0A+=09"$DAXCT=
L" reconfigure-device -m devdax "$daxdev" >/dev/null=0D=0A+}=0D=0A+=0D=0A=
+# Full system-ram transitions (real backing, so online_pages() works).=0D=
=0A+# Turns auto-online off so daxctl drives onlining explicitly.=0D=0A+t=
est_system_ram_transitions()=0D=0A+{=0D=0A+=09save_online_policy=0D=0A+=09=
unset_online_policy=0D=0A+=0D=0A+=09ensure_devdax_mode=0D=0A+=0D=0A+=09# =
devdax -> system-ram (no-online)=0D=0A+=09"$DAXCTL" reconfigure-device -N=
 -m system-ram "$daxdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mode "$daxde=
v") =3D=3D "system-ram" ]]=0D=0A+=0D=0A+=09# system-ram -> famfs must be =
rejected=0D=0A+=09if "$DAXCTL" reconfigure-device -m famfs "$daxdev" &>/d=
ev/null; then=0D=0A+=09=09echo "FAIL: system-ram -> famfs should be rejec=
ted"=0D=0A+=09=09restore_online_policy=0D=0A+=09=09return 1=0D=0A+=09fi=0D=
=0A+=0D=0A+=09# system-ram -> devdax -> famfs=0D=0A+=09"$DAXCTL" reconfig=
ure-device -f -m devdax "$daxdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mod=
e "$daxdev") =3D=3D "devdax" ]]=0D=0A+=09"$DAXCTL" reconfigure-device -m =
famfs "$daxdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D=
 "famfs" ]]=0D=0A+=0D=0A+=09# Full online cycle: devdax -> system-ram (wi=
th online) -> devdax.=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax "$d=
axdev" >/dev/null=0D=0A+=09"$DAXCTL" reconfigure-device -m system-ram "$d=
axdev" >/dev/null=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "system=
-ram" ]]=0D=0A+=09"$DAXCTL" reconfigure-device -f -m devdax "$daxdev" >/d=
ev/null=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "devdax" ]]=0D=0A=
+=0D=0A+=09restore_online_policy=0D=0A+}=0D=0A+=0D=0A+check_fsdev_dax=0D=0A=
+check_kmem=0D=0A+=0D=0A+rc=3D1=0D=0A+=0D=0A+find_testdev=0D=0A+setup_dev=
=0D=0A+=0D=0A+test_famfs_mode_transitions=0D=0A+test_json_output=0D=0A+te=
st_error_handling=0D=0A+test_system_ram_transitions=0D=0A+=0D=0A+ensure_d=
evdax_mode=0D=0A+reset_dev=0D=0A+=0D=0A+check_dmesg "$LINENO"=0D=0Adiff -=
-git a/test/meson.build b/test/meson.build=0D=0Aindex 8a3718d..cee8741 10=
0644=0D=0A--- a/test/meson.build=0D=0A+++ b/test/meson.build=0D=0A@@ -213=
,6 +213,7 @@ if get_option('destructive').enabled()=0D=0A   device_dax_fi=
o =3D find_program('device-dax-fio.sh')=0D=0A   daxctl_devices =3D find_p=
rogram('daxctl-devices.sh')=0D=0A   daxctl_create =3D find_program('daxct=
l-create.sh')=0D=0A+  daxctl_famfs_nfit =3D find_program('daxctl-famfs-nf=
it.sh')=0D=0A   dm =3D find_program('dm.sh')=0D=0A   mmap_test =3D find_p=
rogram('mmap.sh')=0D=0A=20=0D=0A@@ -230,6 +231,7 @@ if get_option('destru=
ctive').enabled()=0D=0A     [ 'device-dax-fio.sh', device_dax_fio, 'dax' =
  ],=0D=0A     [ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],=0D=0A   =
  [ 'daxctl-create.sh',  daxctl_create,  'dax'   ],=0D=0A+    [ 'daxctl-f=
amfs-nfit.sh',    daxctl_famfs_nfit,    'dax'   ],=0D=0A     [ 'dm.sh',  =
           dm,=09=09   'dax'   ],=0D=0A     [ 'mmap.sh',           mmap_t=
est,=09   'dax'   ],=0D=0A   ]=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
