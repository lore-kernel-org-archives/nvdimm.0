Received: from a11-174.smtp-out.amazonses.com (a11-174.smtp-out.amazonses.com [54.240.11.174])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0700339708
	for <nvdimm@lists.linux.dev>; Thu, 30 Apr 2026 15:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.11.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777563261; cv=none; b=mp8R4DDvPn8+vhMyJRqVtCmLmv0KeAa3loIq6bTWX2S1SoHL7OVUEDoN1TWcu+Nw4tXrLwJe3CwjHeKGSUqP7FOIdG//w/8eHExHV5m8s5v2sy90UtPTMkd5MGcZ8lVVJ/ZddmGyHA8KsteaVkWm4UhQtv0/w1HlZWeh9ECE5uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777563261; c=relaxed/simple;
	bh=z2WgA2egcUqE8et8l16Tsmhasj99SudwejH52JNMAIw=;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:In-Reply-To:
	 References:Message-ID; b=M+N8TBVhtJhs0TgOjVuLjGzapsvlJ/kBKQ/vW9LJx77LgoiY0TGzPdnHfoJ6EnHeBdUU00hgCMZMYVQU9SQyZ4KEly9HV4E7G+DBCBs+AQ4cNUaSExHn4Wv6rJYTFWvpUqsfbeOkFC/y11BPLvGp0xUSolA60P41jwHlTNvXGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com; spf=pass smtp.mailfrom=amazonses.com; dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b=NQgXBdsA; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=In7FU5K+; arc=none smtp.client-ip=54.240.11.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jagalactic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazonses.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jagalactic.com header.i=@jagalactic.com header.b="NQgXBdsA";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="In7FU5K+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=o25mqk5iffcfzgc3wo2zjhkohcyjzsoq; d=jagalactic.com; t=1777563258;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id;
	bh=z2WgA2egcUqE8et8l16Tsmhasj99SudwejH52JNMAIw=;
	b=NQgXBdsA3tdRlehYOkn7tYyatuvVUQWCBbd0A+SMoJnlI5sXerVZ783Dfi92NSmi
	TB3K8o4W699PjvhyWC503FOubFEB5mnV+Ep3aGAKRztbL1344WF/aez+s06kIYk6xlM
	IjEPunHgzyvrn/Yp3qfn0QpzEH6UX1Hcuru/SJYQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=224i4yxa5dv7c2xz3womw6peuasteono; d=amazonses.com; t=1777563258;
	h=Subject:From:To:Cc:Date:Mime-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References:Message-Id:Feedback-ID;
	bh=z2WgA2egcUqE8et8l16Tsmhasj99SudwejH52JNMAIw=;
	b=In7FU5K+pRx3+1M74jhspOhKCKAYpufIW0eh3JNff9Q9YRtg/LrYKcgAY3u5gK4I
	/PCKI5vQCnQaqMQijffv4tvK/D4J46SqcsGM3a3ZXaCrLzN+RIo4lEK9CWKR5zm1AFC
	a7j0/euf+anp3FrYpqE9cxjNEnz33kqLDrLPOFb0=
Subject: [PATCH V5 2/2] Add test/daxctl-famfs.sh to test famfs mode
 transitions:
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
Date: Thu, 30 Apr 2026 15:34:18 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: 
 <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com>
References: 
 <0100019ddf064477-8322b695-f2d8-481c-9fcd-8b16fc97ad4d-000000@email.amazonses.com> 
 <20260430153413.84181-1-john@jagalactic.com>
X-Mailer: Amazon WorkMail
Thread-Index: AQHc2LbN3rmpd2dQQ4eYiXkf4zL8kw==
Thread-Topic: [PATCH V5 2/2] Add test/daxctl-famfs.sh to test famfs mode
 transitions:
X-Wm-Sent-Timestamp: 1777563257
X-Original-Mailer: git-send-email 2.52.0
Message-ID: <0100019ddf06ce8f-c323d9cd-333b-4076-9717-7c80dbed7620-000000@email.amazonses.com>
Feedback-ID: ::1.us-east-1.LF00NED762KFuBsfzrtoqw+Brn/qlF9OYdxWukAhsl8=:AmazonSES
X-SES-Outgoing: 2026.04.30-54.240.11.174

From: John Groves <John@Groves.net>=0D=0A=0D=0A- devdax <-> famfs mode sw=
itches=0D=0A- Verify famfs -> system-ram is rejected (must go via devdax)=
=0D=0A- Test JSON output shows correct mode=0D=0A- Test error handling fo=
r invalid modes=0D=0A=0D=0ASigned-off-by: John Groves <john@groves.net>=0D=
=0A---=0D=0A test/daxctl-famfs.sh | 253 +++++++++++++++++++++++++++++++++=
++++++++++=0D=0A test/meson.build     |   2 +=0D=0A 2 files changed, 255 =
insertions(+)=0D=0A create mode 100755 test/daxctl-famfs.sh=0D=0A=0D=0Adi=
ff --git a/test/daxctl-famfs.sh b/test/daxctl-famfs.sh=0D=0Anew file mode=
 100755=0D=0Aindex 0000000..12fbfef=0D=0A--- /dev/null=0D=0A+++ b/test/da=
xctl-famfs.sh=0D=0A@@ -0,0 +1,253 @@=0D=0A+#!/bin/bash -Ex=0D=0A+# SPDX-L=
icense-Identifier: GPL-2.0=0D=0A+# Copyright (C) 2025 Micron Technology, =
Inc. All rights reserved.=0D=0A+#=0D=0A+# Test daxctl famfs mode transiti=
ons and mode detection=0D=0A+=0D=0A+rc=3D77=0D=0A+. $(dirname $0)/common=0D=
=0A+=0D=0A+trap 'cleanup $LINENO' ERR=0D=0A+=0D=0A+daxdev=3D""=0D=0A+orig=
inal_mode=3D""=0D=0A+=0D=0A+cleanup()=0D=0A+{=0D=0A+=09printf "Error at l=
ine %d\n" "$1"=0D=0A+=09# Try to restore to original mode if we know it=0D=
=0A+=09if [[ $daxdev && $original_mode ]]; then=0D=0A+=09=09"$DAXCTL" rec=
onfigure-device -f -m "$original_mode" "$daxdev" 2>/dev/null || true=0D=0A=
+=09fi=0D=0A+=09exit $rc=0D=0A+}=0D=0A+=0D=0A+# Check if fsdev_dax module=
 is available=0D=0A+check_fsdev_dax()=0D=0A+{=0D=0A+=09if modinfo fsdev_d=
ax &>/dev/null; then=0D=0A+=09=09return 0=0D=0A+=09fi=0D=0A+=09if grep -q=
F "fsdev_dax" "/lib/modules/$(uname -r)/modules.builtin" 2>/dev/null; the=
n=0D=0A+=09=09return 0=0D=0A+=09fi=0D=0A+=09printf "fsdev_dax module not =
available, skipping\n"=0D=0A+=09exit 77=0D=0A+}=0D=0A+=0D=0A+# Check if k=
mem module is available (needed for system-ram mode tests)=0D=0A+check_km=
em()=0D=0A+{=0D=0A+=09if modinfo kmem &>/dev/null; then=0D=0A+=09=09retur=
n 0=0D=0A+=09fi=0D=0A+=09if grep -qF "kmem" "/lib/modules/$(uname -r)/mod=
ules.builtin" 2>/dev/null; then=0D=0A+=09=09return 0=0D=0A+=09fi=0D=0A+=09=
printf "kmem module not available, skipping system-ram tests\n"=0D=0A+=09=
return 1=0D=0A+}=0D=0A+=0D=0A+# Find an existing dax device to test with=0D=
=0A+find_daxdev()=0D=0A+{=0D=0A+=09# Look for any available dax device=0D=
=0A+=09daxdev=3D$("$DAXCTL" list | jq -er '.[0].chardev // empty' 2>/dev/=
null) || true=0D=0A+=0D=0A+=09if [[ ! $daxdev ]]; then=0D=0A+=09=09printf=
 "No dax device found, skipping\n"=0D=0A+=09=09exit 77=0D=0A+=09fi=0D=0A+=
=0D=0A+=09# Save the original mode so we can restore it=0D=0A+=09original=
_mode=3D$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mode')=0D=0A+=0D=0A+=09=
printf "Found dax device: %s (current mode: %s)\n" "$daxdev" "$original_m=
ode"=0D=0A+}=0D=0A+=0D=0A+daxctl_get_mode()=0D=0A+{=0D=0A+=09"$DAXCTL" li=
st -d "$1" | jq -er '.[].mode'=0D=0A+}=0D=0A+=0D=0A+# Ensure device is in=
 devdax mode for testing=0D=0A+ensure_devdax_mode()=0D=0A+{=0D=0A+=09loca=
l mode=0D=0A+=09mode=3D$(daxctl_get_mode "$daxdev")=0D=0A+=0D=0A+=09if [[=
 "$mode" =3D=3D "devdax" ]]; then=0D=0A+=09=09return 0=0D=0A+=09fi=0D=0A+=
=0D=0A+=09if [[ "$mode" =3D=3D "system-ram" ]]; then=0D=0A+=09=09printf "=
Device is in system-ram mode, attempting to convert to devdax...\n"=0D=0A=
+=09=09"$DAXCTL" reconfigure-device -f -m devdax "$daxdev"=0D=0A+=09elif =
[[ "$mode" =3D=3D "famfs" ]]; then=0D=0A+=09=09printf "Device is in famfs=
 mode, converting to devdax...\n"=0D=0A+=09=09"$DAXCTL" reconfigure-devic=
e -m devdax "$daxdev"=0D=0A+=09else=0D=0A+=09=09printf "Device is in unkn=
own mode: %s\n" "$mode"=0D=0A+=09=09return 1=0D=0A+=09fi=0D=0A+=0D=0A+=09=
[[ $(daxctl_get_mode "$daxdev") =3D=3D "devdax" ]]=0D=0A+}=0D=0A+=0D=0A+#=
=0D=0A+# Test basic mode transitions involving famfs=0D=0A+#=0D=0A+test_f=
amfs_mode_transitions()=0D=0A+{=0D=0A+=09printf "\n=3D=3D=3D Testing famf=
s mode transitions =3D=3D=3D\n"=0D=0A+=0D=0A+=09# Ensure starting in devd=
ax mode=0D=0A+=09ensure_devdax_mode=0D=0A+=09[[ $(daxctl_get_mode "$daxde=
v") =3D=3D "devdax" ]]=0D=0A+=09printf "Initial mode: devdax - OK\n"=0D=0A=
+=0D=0A+=09# Test: devdax -> famfs=0D=0A+=09printf "Testing devdax -> fam=
fs... "=0D=0A+=09"$DAXCTL" reconfigure-device -m famfs "$daxdev"=0D=0A+=09=
[[ $(daxctl_get_mode "$daxdev") =3D=3D "famfs" ]]=0D=0A+=09printf "OK\n"=0D=
=0A+=0D=0A+=09# Test: famfs -> famfs (re-enable in same mode)=0D=0A+=09pr=
intf "Testing famfs -> famfs (re-enable)... "=0D=0A+=09"$DAXCTL" reconfig=
ure-device -m famfs "$daxdev"=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=
=3D "famfs" ]]=0D=0A+=09printf "OK\n"=0D=0A+=0D=0A+=09# Test: famfs -> de=
vdax=0D=0A+=09printf "Testing famfs -> devdax... "=0D=0A+=09"$DAXCTL" rec=
onfigure-device -m devdax "$daxdev"=0D=0A+=09[[ $(daxctl_get_mode "$daxde=
v") =3D=3D "devdax" ]]=0D=0A+=09printf "OK\n"=0D=0A+=0D=0A+=09# Test: dev=
dax -> devdax (re-enable in same mode)=0D=0A+=09printf "Testing devdax ->=
 devdax (re-enable)... "=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax =
"$daxdev"=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "devdax" ]]=0D=0A=
+=09printf "OK\n"=0D=0A+}=0D=0A+=0D=0A+#=0D=0A+# Test mode transitions wi=
th system-ram (requires kmem)=0D=0A+#=0D=0A+test_system_ram_transitions()=
=0D=0A+{=0D=0A+=09printf "\n=3D=3D=3D Testing system-ram transitions with=
 famfs =3D=3D=3D\n"=0D=0A+=0D=0A+=09# Ensure we start in devdax mode=0D=0A=
+=09ensure_devdax_mode=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "d=
evdax" ]]=0D=0A+=0D=0A+=09# Test: devdax -> system-ram=0D=0A+=09printf "T=
esting devdax -> system-ram... "=0D=0A+=09"$DAXCTL" reconfigure-device -N=
 -m system-ram "$daxdev"=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D =
"system-ram" ]]=0D=0A+=09printf "OK\n"=0D=0A+=0D=0A+=09# Test: system-ram=
 -> famfs should fail=0D=0A+=09printf "Testing system-ram -> famfs (shoul=
d fail)... "=0D=0A+=09if "$DAXCTL" reconfigure-device -m famfs "$daxdev" =
2>/dev/null; then=0D=0A+=09=09printf "FAILED - should have been rejected\=
n"=0D=0A+=09=09return 1=0D=0A+=09fi=0D=0A+=09printf "OK (correctly reject=
ed)\n"=0D=0A+=0D=0A+=09# Test: system-ram -> devdax -> famfs (proper path=
)=0D=0A+=09printf "Testing system-ram -> devdax -> famfs... "=0D=0A+=09"$=
DAXCTL" reconfigure-device -f -m devdax "$daxdev"=0D=0A+=09[[ $(daxctl_ge=
t_mode "$daxdev") =3D=3D "devdax" ]]=0D=0A+=09"$DAXCTL" reconfigure-devic=
e -m famfs "$daxdev"=0D=0A+=09[[ $(daxctl_get_mode "$daxdev") =3D=3D "fam=
fs" ]]=0D=0A+=09printf "OK\n"=0D=0A+=0D=0A+=09# Restore to devdax for sub=
sequent tests=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax "$daxdev"=0D=
=0A+}=0D=0A+=0D=0A+#=0D=0A+# Test JSON output shows correct mode=0D=0A+#=0D=
=0A+test_json_output()=0D=0A+{=0D=0A+=09printf "\n=3D=3D=3D Testing JSON =
output for mode field =3D=3D=3D\n"=0D=0A+=0D=0A+=09# Test devdax mode in =
JSON=0D=0A+=09ensure_devdax_mode=0D=0A+=09printf "Testing JSON output for=
 devdax mode... "=0D=0A+=09mode=3D$("$DAXCTL" list -d "$daxdev" | jq -er =
'.[].mode')=0D=0A+=09[[ "$mode" =3D=3D "devdax" ]]=0D=0A+=09printf "OK\n"=
=0D=0A+=0D=0A+=09# Test famfs mode in JSON=0D=0A+=09"$DAXCTL" reconfigure=
-device -m famfs "$daxdev"=0D=0A+=09printf "Testing JSON output for famfs=
 mode... "=0D=0A+=09mode=3D$("$DAXCTL" list -d "$daxdev" | jq -er '.[].mo=
de')=0D=0A+=09[[ "$mode" =3D=3D "famfs" ]]=0D=0A+=09printf "OK\n"=0D=0A+=0D=
=0A+=09# Restore to devdax=0D=0A+=09"$DAXCTL" reconfigure-device -m devda=
x "$daxdev"=0D=0A+}=0D=0A+=0D=0A+#=0D=0A+# Test error messages for invali=
d transitions=0D=0A+#=0D=0A+test_error_handling()=0D=0A+{=0D=0A+=09printf=
 "\n=3D=3D=3D Testing error handling =3D=3D=3D\n"=0D=0A+=0D=0A+=09# Ensur=
e we're in famfs mode=0D=0A+=09"$DAXCTL" reconfigure-device -m famfs "$da=
xdev"=0D=0A+=0D=0A+=09# Test that invalid mode is rejected=0D=0A+=09print=
f "Testing invalid mode rejection... "=0D=0A+=09if "$DAXCTL" reconfigure-=
device -m invalidmode "$daxdev" 2>/dev/null; then=0D=0A+=09=09printf "FAI=
LED - invalid mode should be rejected\n"=0D=0A+=09=09return 1=0D=0A+=09fi=
=0D=0A+=09printf "OK (correctly rejected)\n"=0D=0A+=0D=0A+=09# Restore to=
 devdax=0D=0A+=09"$DAXCTL" reconfigure-device -m devdax "$daxdev"=0D=0A+}=
=0D=0A+=0D=0A+#=0D=0A+# Main test sequence=0D=0A+#=0D=0A+main()=0D=0A+{=0D=
=0A+=09check_fsdev_dax=0D=0A+=09find_daxdev=0D=0A+=0D=0A+=09rc=3D1  # Fro=
m here on, failures are real failures=0D=0A+=0D=0A+=09test_famfs_mode_tra=
nsitions=0D=0A+=09test_json_output=0D=0A+=09test_error_handling=0D=0A+=0D=
=0A+=09# System-ram tests require kmem module=0D=0A+=09if check_kmem; the=
n=0D=0A+=09=09# Save and disable online policy for system-ram tests=0D=0A=
+=09=09saved_policy=3D"$(cat /sys/devices/system/memory/auto_online_block=
s)"=0D=0A+=09=09echo "offline" > /sys/devices/system/memory/auto_online_b=
locks=0D=0A+=0D=0A+=09=09test_system_ram_transitions=0D=0A+=0D=0A+=09=09#=
 Restore online policy=0D=0A+=09=09echo "$saved_policy" > /sys/devices/sy=
stem/memory/auto_online_blocks=0D=0A+=09fi=0D=0A+=0D=0A+=09# Restore orig=
inal mode=0D=0A+=09printf "\nRestoring device to original mode: %s\n" "$o=
riginal_mode"=0D=0A+=09"$DAXCTL" reconfigure-device -f -m "$original_mode=
" "$daxdev"=0D=0A+=0D=0A+=09printf "\n=3D=3D=3D All famfs tests passed =3D=
=3D=3D\n"=0D=0A+=0D=0A+=09exit 0=0D=0A+}=0D=0A+=0D=0A+main=0D=0Adiff --gi=
t a/test/meson.build b/test/meson.build=0D=0Aindex 8a3718d..5b75c07 10064=
4=0D=0A--- a/test/meson.build=0D=0A+++ b/test/meson.build=0D=0A@@ -213,6 =
+213,7 @@ if get_option('destructive').enabled()=0D=0A   device_dax_fio =3D=
 find_program('device-dax-fio.sh')=0D=0A   daxctl_devices =3D find_progra=
m('daxctl-devices.sh')=0D=0A   daxctl_create =3D find_program('daxctl-cre=
ate.sh')=0D=0A+  daxctl_famfs =3D find_program('daxctl-famfs.sh')=0D=0A  =
 dm =3D find_program('dm.sh')=0D=0A   mmap_test =3D find_program('mmap.sh=
')=0D=0A=20=0D=0A@@ -230,6 +231,7 @@ if get_option('destructive').enabled=
()=0D=0A     [ 'device-dax-fio.sh', device_dax_fio, 'dax'   ],=0D=0A     =
[ 'daxctl-devices.sh', daxctl_devices, 'dax'   ],=0D=0A     [ 'daxctl-cre=
ate.sh',  daxctl_create,  'dax'   ],=0D=0A+    [ 'daxctl-famfs.sh',   dax=
ctl_famfs,   'dax'   ],=0D=0A     [ 'dm.sh',             dm,=09=09   'dax=
'   ],=0D=0A     [ 'mmap.sh',           mmap_test,=09   'dax'   ],=0D=0A =
  ]=0D=0A--=20=0D=0A2.53.0=0D=0A=0D=0A
